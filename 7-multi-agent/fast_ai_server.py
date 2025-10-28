"""
Fast & Stable AI Hotel Search Server
Hybrid approach: CSV + Direct Gemini (no ADK imports for faster startup)
"""
import os
os.environ['GOOGLE_API_KEY'] = 'AIzaSyAaC4DMxu0mHPggTp7eyEoG4rtAywCQ4z8'

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Dict, Any
import pandas as pd
import json
import google.generativeai as genai

# Configure Gemini
genai.configure(api_key=os.environ['GOOGLE_API_KEY'])

# Create FastAPI app
app = FastAPI(
    title="AI Hotel Search - Fast & Stable",
    description="Hybrid CSV + AI with instant startup"
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
        "version": "2.0 - Fast & Stable",
        "mode": "Hybrid CSV + Gemini AI",
        "model": "Gemini 2.0 Flash",
        "cors_enabled": True
    }

@app.post("/chat")
def chat(request: dict):
    """Simple chat endpoint"""
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
    type: str = None
):
    """GET endpoint for simple CSV filtering"""
    try:
        print(f"\n📊 CSV SEARCH: {city}, ₹{min_price}-{max_price}")
        
        filtered_hotels = hotels_df[
            (hotels_df['city'].str.lower() == city.lower()) &
            (hotels_df['price_per_night'] >= min_price) &
            (hotels_df['price_per_night'] <= max_price)
        ]
        
        if type and type.lower() != 'all':
            filtered_hotels = filtered_hotels[
                filtered_hotels['accommodation_type'].str.lower() == type.lower()
            ]
        
        hotels_list = []
        for _, hotel in filtered_hotels.head(20).iterrows():
            hotels_list.append({
                'name': hotel['name'],
                'city': hotel['city'],
                'type': hotel['accommodation_type'],
                'price_per_night': float(hotel['price_per_night']),
                'rating': float(hotel['rating']),
                'amenities': hotel['extras'].split('|') if '|' in str(hotel['extras']) else hotel['extras'].split(', '),
            })
        
        print(f"✅ Found {len(hotels_list)} hotels\n")
        
        return {
            'status': 'success',
            'hotels': hotels_list,
            'count': len(hotels_list)
        }
    except Exception as e:
        print(f"❌ Error: {e}\n")
        return {'status': 'error', 'message': str(e), 'hotels': []}

@app.post("/api/hotel/search")
def search_hotels(request: HotelSearchRequest):
    """
    Hybrid hotel search: CSV first, Gemini AI for special requests
    """
    try:
        city = request.context.get('city', 'Goa')
        budget = request.context.get('budget', 25000)
        message = request.message
        
        print(f"\n🔍 HOTEL SEARCH:")
        print(f"   City: {city}, Budget: ₹{budget}")
        print(f"   Query: {message}")
        
        # Detect special requests
        has_special_request = any([
            keyword in message.lower() 
            for keyword in ['near', 'airport', 'station', 'beach', 'mall', 'spa', 'pool', 
                           'gym', 'romantic', 'luxury', 'family', 'business', 'special']
        ])
        
        # STEP 1: Try CSV first
        print(f"   📊 Step 1: Checking CSV...")
        city_hotels = hotels_df[
            (hotels_df['city'].str.lower() == city.lower()) &
            (hotels_df['price_per_night'] <= budget)
        ]
        
        csv_count = len(city_hotels)
        print(f"   📊 CSV found: {csv_count} hotels")
        
        # Use CSV if available and no special request
        if csv_count > 0 and not has_special_request:
            print(f"   ✅ Using CSV (cost-free)\n")
            
            formatted_hotels = []
            for _, hotel in city_hotels.head(15).iterrows():
                formatted_hotels.append({
                    'name': hotel['name'],
                    'city': hotel['city'],
                    'type': hotel['accommodation_type'],
                    'price_per_night': float(hotel['price_per_night']),
                    'rating': float(hotel['rating']),
                    'amenities': hotel['extras'].split('|') if '|' in str(hotel['extras']) else hotel['extras'].split(', '),
                    'match_score': '90%',
                    'why_recommended': f"Available in {city}",
                    'highlights': ['Verified', 'Available'],
                    'perfect_for': 'All travelers'
                })
            
            return {
                'status': 'success',
                'powered_by': 'CSV Database',
                'ai_used': False,
                'cost': '₹0',
                'hotels': formatted_hotels,
                'count': len(formatted_hotels),
                'overall_advice': f'Found {len(formatted_hotels)} hotels in {city}',
                'location': city
            }
        
        # STEP 2: Use Gemini AI for special requests or missing cities
        print(f"   🤖 Step 2: Using Gemini AI...")
        
        reason = "Special request" if has_special_request else "City not in database"
        print(f"   💰 Reason: {reason}\n")
        
        # If CSV has some hotels, use them as context for AI
        context_hotels = ""
        if csv_count > 0:
            hotels_list = []
            for _, hotel in city_hotels.iterrows():
                hotels_list.append(f"- {hotel['name']} (₹{hotel['price_per_night']}/night, {hotel['accommodation_type']})")
            context_hotels = "\n".join(hotels_list[:10])
        
        prompt = f"""You are a travel hotel recommendation expert. Based on this request, provide hotel recommendations:

REQUEST: {message}
LOCATION: {city}, India
BUDGET: ₹{budget}/night
GUESTS: {request.context.get('guests', 2)}

{f"Available in our database:{context_hotels}" if context_hotels else "No hotels currently in our database for this city."}

Return ONLY valid JSON with no markdown:
{{
  "hotels": [
    {{
      "name": "Hotel Name",
      "type": "3-star/4-star/5-star",
      "price_per_night": "₹2000-3000",
      "amenities": ["WiFi", "Pool", "Gym"],
      "highlights": ["Location 1", "Highlight 2"],
      "perfect_for": "Type of guest",
      "location_area": "Area name"
    }}
  ],
  "overall_advice": "Summary recommendation"
}}

Provide 5-10 realistic hotel recommendations."""
        
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
                'match_score': '95%',
                'why_recommended': hotel.get('highlights', [''])[0] if hotel.get('highlights') else '',
                'highlights': hotel.get('highlights', []),
                'perfect_for': hotel.get('perfect_for', 'All travelers'),
                'location_area': hotel.get('location_area', city)
            })
        
        print(f"✅ Gemini AI returned {len(formatted_hotels)} hotels\n")
        
        return {
            'status': 'success',
            'powered_by': 'Gemini 2.0 Flash AI',
            'ai_used': True,
            'reason_for_ai': reason,
            'hotels': formatted_hotels,
            'count': len(formatted_hotels),
            'overall_advice': ai_result.get('overall_advice', 'Great choices!'),
            'location': city
        }
        
    except Exception as e:
        print(f"❌ Error: {e}\n")
        import traceback
        traceback.print_exc()
        return {
            "status": "error",
            "message": str(e)
        }

if __name__ == "__main__":
    import uvicorn
    print("\n" + "="*80)
    print("🚀 FAST AI HOTEL SEARCH SERVER - STARTED")
    print("="*80)
    print("Mode: Hybrid CSV + Gemini AI (No ADK - Ultra-Fast)")
    print("Server: http://0.0.0.0:8001")
    print("="*80 + "\n")
    
    uvicorn.run(app, host="0.0.0.0", port=8001)
