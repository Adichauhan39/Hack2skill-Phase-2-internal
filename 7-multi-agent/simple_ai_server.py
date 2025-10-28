"""
Lightweight AI Hotel Search Server with CORS Support
Routes AI requests through Manager Agent architecture (lazy loading + error handling)
"""
import os
os.environ['GOOGLE_API_KEY'] = 'AIzaSyAaC4DMxu0mHPggTp7eyEoG4rtAywCQ4z8'

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Dict, Any, List
import pandas as pd
import json
import google.generativeai as genai

# Configure Gemini for fallback
genai.configure(api_key=os.environ['GOOGLE_API_KEY'])

# Lazy import - only load when needed to avoid startup delays
search_hotels_online = None

def load_agent():
    """Lazy load the web_hotel_search agent only when needed"""
    global search_hotels_online
    if search_hotels_online is None:
        try:
            print("   🔄 Loading Manager Agent sub-agent (first time)...")
            from manager.sub_agents.web_hotel_search.agent import search_hotels_online as sho
            search_hotels_online = sho
            print("   ✅ Agent loaded successfully!")
        except Exception as e:
            print(f"   ⚠️ Error loading agent: {e}")
            # Fallback to None if loading fails
            search_hotels_online = None
    return search_hotels_online

# Create FastAPI app
app = FastAPI(
    title="AI Hotel Search - Manager Agent Architecture",
    description="Multi-Agent System using Google ADK with web_hotel_search sub-agent (Fast Startup)"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load hotel data
hotels_df = pd.read_csv('data/hotels_india.csv')

class HotelSearchRequest(BaseModel):
    message: str
    context: Dict[str, Any]

@app.get("/")
def root():
    return {
        "status": "AI Hotel Search Server Running", 
        "architecture": "Google ADK Multi-Agent System",
        "root_agent": "Manager Agent",
        "sub_agent": "web_hotel_search",
        "model": "Gemini 2.0 Flash",
        "cors_enabled": True,
        "note": "All AI requests routed through Manager Agent architecture"
    }

@app.post("/chat")
def chat(request: dict):
    """Simple chat endpoint - redirects to manager agent"""
    try:
        message = request.get('message', '')
        
        return {
            'status': 'success',
            'response': 'I understand your request. Let me search for the best hotels for you using our AI agent!',
            'agent': 'manager_agent',
            'note': 'For hotel search, use /api/hotel/search endpoint'
        }
    except Exception as e:
        return {
            'status': 'success',
            'response': 'I understand your request. Let me search for the best hotels for you!',
            'agent': 'chat'
        }

@app.get("/hotels")
def get_hotels(
    city: str = "Goa",
    min_price: float = 0,
    max_price: float = 50000,
    type: str = None,
    amenities: str = None
):
    """Simple GET endpoint for hotel search (no AI, just filtering)"""
    try:
        print(f"\n📊 CSV SEARCH REQUEST:")
        print(f"   City: {city}")
        print(f"   Price Range: ₹{min_price} - ₹{max_price}")
        print(f"   Type: {type or 'All'}")
        
        # Filter hotels by city and price
        filtered_hotels = hotels_df[
            (hotels_df['city'].str.lower() == city.lower()) &
            (hotels_df['price_per_night'] >= min_price) &
            (hotels_df['price_per_night'] <= max_price)
        ]
        
        print(f"   Found {len(filtered_hotels)} hotels after city+price filter")
        
        # Filter by type if provided
        if type and type.lower() != 'all':
            filtered_hotels = filtered_hotels[
                filtered_hotels['accommodation_type'].str.lower() == type.lower()
            ]
            print(f"   Found {len(filtered_hotels)} hotels after type filter")
        
        # Format response
        hotels_list = []
        for _, hotel in filtered_hotels.head(20).iterrows():
            hotels_list.append({
                'id': hotel['name'].lower().replace(' ', '_'),
                'name': hotel['name'],
                'city': hotel['city'],
                'type': hotel['accommodation_type'],
                'price_per_night': float(hotel['price_per_night']),
                'rating': float(hotel['rating']),
                'amenities': hotel['extras'].split('|') if '|' in str(hotel['extras']) else hotel['extras'].split(', '),
                'image_url': f"https://picsum.photos/seed/{hotel['name']}/400/300",
                'description': f"{hotel['accommodation_type']} in {hotel['city']}"
            })
        
        print(f"✅ Returning {len(hotels_list)} hotels\n")
        
        return {
            'status': 'success',
            'hotels': hotels_list,
            'count': len(hotels_list)
        }
        
    except Exception as e:
        print(f"❌ CSV search error: {str(e)}\n")
        return {
            'status': 'error',
            'message': str(e),
            'hotels': []
        }

@app.post("/api/hotel/search")
def search_hotels(request: HotelSearchRequest):
    """
    Hybrid hotel search: CSV first (cost-effective), AI agent fallback
    - Try CSV database first for simple city+budget searches
    - Use Manager Agent's web_hotel_search sub-agent ONLY when:
      * No hotels found in CSV (city not in database)
      * User has special requests (near airport, specific amenities, etc.)
    """
    try:
        city = request.context.get('city', 'Goa')
        budget = request.context.get('budget', 25000)
        message = request.message
        check_in = request.context.get('check_in', 'flexible')
        check_out = request.context.get('check_out', 'flexible')
        guests = request.context.get('guests', 2)
        
        print(f"\n🔍 HOTEL SEARCH REQUEST:")
        print(f"   Message: {message}")
        print(f"   City: {city}")
        print(f"   Budget: ₹{budget}")
        
        # Detect if user has special requests (triggers AI agent)
        has_special_request = any([
            'near' in message.lower(),
            'airport' in message.lower(),
            'station' in message.lower(),
            'beach' in message.lower(),
            'mall' in message.lower(),
            'spa' in message.lower(),
            'pool' in message.lower(),
            'gym' in message.lower(),
            'romantic' in message.lower(),
            'luxury' in message.lower(),
            'family' in message.lower(),
            'business' in message.lower(),
        ])
        
        # STEP 1: Try CSV database first (cost-effective)
        print(f"   � Step 1: Checking CSV database...")
        city_hotels = hotels_df[
            (hotels_df['city'].str.lower() == city.lower()) &
            (hotels_df['price_per_night'] <= budget)
        ]
        
        csv_hotel_count = len(city_hotels)
        print(f"   📊 CSV found: {csv_hotel_count} hotels")
        
        # STEP 2: Decide whether to use AI agent
        use_ai_agent = False
        reason = ""
        
        if csv_hotel_count == 0:
            use_ai_agent = True
            reason = "No hotels in CSV database for this city"
            print(f"   ⚠️ {reason}")
        elif has_special_request:
            use_ai_agent = True
            reason = "Special request detected (requires AI intelligence)"
            print(f"   🎯 {reason}")
        else:
            print(f"   ✅ CSV has hotels, no special requests → Using CSV (cost-effective)")
        
        # STEP 3A: Return CSV results (no AI cost)
        if not use_ai_agent:
            formatted_hotels = []
            for _, hotel in city_hotels.head(20).iterrows():
                formatted_hotels.append({
                    'name': hotel['name'],
                    'city': hotel['city'],
                    'type': hotel['accommodation_type'],
                    'price_per_night': float(hotel['price_per_night']),
                    'rating': float(hotel['rating']),
                    'amenities': hotel['extras'].split('|') if '|' in str(hotel['extras']) else hotel['extras'].split(', '),
                    'match_score': '90%',
                    'why_recommended': f"Good {hotel['accommodation_type']} in {city}",
                    'highlights': ['Available in our database', 'Verified listing'],
                    'perfect_for': 'All travelers'
                })
            
            print(f"✅ CSV SEARCH COMPLETE: Returning {len(formatted_hotels)} hotels")
            print(f"   � COST: ₹0 (No AI used)\n")
            
            return {
                'status': 'success',
                'powered_by': 'CSV Database (Cost-Effective)',
                'ai_used': False,
                'cost': 'Free - No AI tokens used',
                'hotels': formatted_hotels,
                'count': len(formatted_hotels),
                'overall_advice': f'Found {len(formatted_hotels)} verified hotels in {city}',
                'location': city
            }
        
        # STEP 3B: Use AI agent (web_hotel_search sub-agent)
        print(f"   🤖 Step 2: Calling Manager Agent → web_hotel_search sub-agent...")
        print(f"   💰 Reason: {reason}")
        
        # Determine price range category
        if budget <= 2000:
            price_range = "Budget"
        elif budget <= 5000:
            price_range = "Mid-range"
        else:
            price_range = "Luxury"
        
        # Try to load and call the web_hotel_search sub-agent
        agent_func = load_agent()
        
        if agent_func is None:
            print(f"   ⚠️ Agent unavailable, using direct Gemini...")
            agent_result = None
        else:
            try:
                print(f"   ⏱️ Calling ADK Manager Agent web_hotel_search...")
                import threading
                
                # Call agent in a thread with timeout
                result_holder = [None]
                exception_holder = [None]
                
                def call_agent():
                    try:
                        result_holder[0] = agent_func(
                            location=city,
                            check_in=check_in,
                            check_out=check_out,
                            guests=guests,
                            price_range=price_range,
                            star_rating=None,
                            amenities=None
                        )
                    except Exception as e:
                        exception_holder[0] = e
                
                thread = threading.Thread(target=call_agent, daemon=True)
                thread.start()
                thread.join(timeout=8)  # 8 second timeout
                
                if thread.is_alive():
                    print(f"   ⏰ Agent timeout (>8s), using Gemini...")
                    agent_result = None
                elif exception_holder[0]:
                    print(f"   ❌ Agent error: {exception_holder[0]}")
                    print(f"   🔄 Falling back to Gemini...")
                    agent_result = None
                else:
                    agent_result = result_holder[0]
                    print(f"   ✅ Agent returned: {agent_result.get('status') if agent_result else 'None'}")
                    
            except Exception as agent_error:
                print(f"   ❌ Agent error: {agent_error}")
                agent_result = None
        
        # If agent succeeded, use its result
        if agent_result and agent_result.get('status') == 'success' and agent_result.get('hotels'):
            hotels = agent_result.get('hotels', [])
            
            print(f"   🏨 Agent found {len(hotels)} AI-powered recommendations")
            
            # Format for Flutter app
            formatted_hotels = []
            for hotel in hotels:
                formatted_hotels.append({
                    'name': hotel.get('name', 'Unknown Hotel'),
                    'city': city,
                    'type': hotel.get('star_rating', 'Hotel'),
                    'price_per_night': hotel.get('price_per_night', f'₹{budget}'),
                    'rating': 4.0,
                    'amenities': hotel.get('amenities', []),
                    'match_score': '95%',
                    'why_recommended': hotel.get('description', ''),
                    'highlights': hotel.get('pros', []),
                    'perfect_for': hotel.get('best_for', 'All travelers'),
                    'location_area': hotel.get('location_area', city),
                    'total_cost': hotel.get('total_estimated_cost', 'Contact for pricing')
                })
            
            print(f"✅ AI AGENT SEARCH COMPLETE: Returning {len(formatted_hotels)} hotels")
            print(f"   🤖 POWERED BY: Manager Agent (web_hotel_search) + Gemini 2.0 Flash")
            print(f"   💰 COST: AI tokens used (Gemini API calls)\n")
            
            return {
                'status': 'success',
                'powered_by': 'Manager Agent (web_hotel_search) + Gemini 2.0 Flash',
                'agent_used': 'web_hotel_search sub-agent',
                'architecture': 'Google ADK Multi-Agent System',
                'ai_used': True,
                'reason_for_ai': reason,
                'hotels': formatted_hotels,
                'count': len(formatted_hotels),
                'overall_advice': agent_result.get('ai_recommendation', 'Great choices for your stay!'),
                'travel_tips': agent_result.get('travel_tips', []),
                'location': city
            }
        
        # STEP 4: Agent failed - try Gemini fallback
        print(f"   ⚠️ Agent search failed, trying Gemini fallback...")
        
        try:
            print(f"   🤖 Calling Gemini 2.0 Flash directly...")
            
            prompt = f"""You are a hotel recommendation expert. Provide 5-8 hotel recommendations for {city} based on this request: {message}
            
Budget: ₹{budget}/night
Guests: {guests}

Return ONLY this JSON format (no markdown):
{{
  "hotels": [
    {{"name": "Hotel Name", "type": "3-star", "price_per_night": "₹2000-3000", "amenities": ["WiFi", "Pool"], "highlights": ["Feature 1"]}}
  ],
  "advice": "Recommendation summary"
}}"""
            
            model = genai.GenerativeModel('gemini-2.0-flash-exp')
            response = model.generate_content(prompt)
            
            # Parse response
            ai_text = response.text.strip()
            if '```json' in ai_text:
                ai_text = ai_text.split('```json')[1].split('```')[0].strip()
            elif '```' in ai_text:
                ai_text = ai_text.split('```')[1].split('```')[0].strip()
            
            ai_result = json.loads(ai_text)
            
            formatted_hotels = []
            for hotel in ai_result.get('hotels', []):
                formatted_hotels.append({
                    'name': hotel.get('name', 'Hotel'),
                    'city': city,
                    'type': hotel.get('type', '3-star'),
                    'price_per_night': hotel.get('price_per_night', f'₹{budget}'),
                    'rating': 4.0,
                    'amenities': hotel.get('amenities', []),
                    'match_score': '90%',
                    'why_recommended': 'AI-recommended',
                    'highlights': hotel.get('highlights', []),
                    'perfect_for': 'Travelers'
                })
            
            print(f"✅ Gemini fallback returned {len(formatted_hotels)} hotels\n")
            
            return {
                'status': 'success',
                'powered_by': 'Gemini 2.0 Flash (Fallback)',
                'ai_used': True,
                'reason_for_ai': 'Manager Agent unavailable - using Gemini fallback',
                'hotels': formatted_hotels,
                'count': len(formatted_hotels),
                'overall_advice': ai_result.get('advice', 'Great hotel options for you!'),
                'location': city
            }
            
        except Exception as gemini_error:
            print(f"   ❌ Gemini fallback also failed: {gemini_error}")
            print(f"   ⚠️ Returning empty results\n")
            
            return {
                "status": "success",
                "powered_by": "Fallback - No results",
                "ai_used": False,
                "hotels": [],
                "count": 0,
                "overall_advice": f"Sorry, couldn't find hotels in {city}. Try Mumbai, Delhi, Goa, or Bangalore.",
                "location": city
            }
        
    except Exception as e:
        print(f"❌ Error in search: {e}\n")
        import traceback
        traceback.print_exc()
        return {
            "status": "error",
            "message": str(e),
            "powered_by": "Error Handler"
        }

if __name__ == "__main__":
    import uvicorn
    print("\n" + "="*80)
    print("AI HOTEL SEARCH SERVER - MANAGER AGENT ARCHITECTURE")
    print("="*80)
    print("Server starting on: http://localhost:8001")
    print("CORS: Enabled for all origins")
    print("Architecture: Google ADK Multi-Agent System")
    print("Root Agent: Manager Agent")
    print("Sub-Agent: web_hotel_search (AI-powered hotel recommendations)")
    print("Model: Google Gemini 2.0 Flash")
    print("="*80)
    print("📡 All AI requests routed through Manager Agent")
    print("🤖 Using web_hotel_search sub-agent for intelligent recommendations")
    print("="*80 + "\n")
    
    uvicorn.run(app, host="0.0.0.0", port=8001)
