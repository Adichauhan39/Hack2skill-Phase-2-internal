"""
Ultra-Simple Hotel Search Server - Stable Version
CSV + Gemini (no ADK complexity)
"""
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Get API key from environment
GOOGLE_API_KEY = os.getenv('GOOGLE_API_KEY')
if not GOOGLE_API_KEY:
    raise ValueError("GOOGLE_API_KEY not found in environment variables. Please set it in a .env file.")

os.environ['GOOGLE_API_KEY'] = GOOGLE_API_KEY

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Dict, Any
import pandas as pd
import json
import google.generativeai as genai

# Configure
genai.configure(api_key=os.environ['GOOGLE_API_KEY'])
hotels_df = pd.read_csv('data/hotels_india.csv')

# Create app
app = FastAPI()
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])

def _create_hotel_description(hotel_name, hotel_type, amenities, city, rating):
    """Create a detailed description for the hotel"""
    type_descriptions = {
        'Hotel': 'a premium accommodation',
        'Resort': 'a luxurious resort experience',
        'Hostel': 'a budget-friendly shared accommodation',
        'Homestay': 'a cozy home-like stay',
        'Villa': 'a private villa experience',
        'Boutique Hotel': 'a stylish boutique hotel',
        'Guesthouse': 'a charming guesthouse',
    }
    
    description = f"{hotel_name} is {type_descriptions.get(hotel_type, 'an excellent accommodation')} located in {city}, India. "
    
    # Add rating description
    if rating >= 4.5:
        description += f"This highly-rated property ({rating}/5) offers exceptional service and quality. "
    elif rating >= 4.0:
        description += f"This well-rated property ({rating}/5) provides good value and comfort. "
    else:
        description += f"This property ({rating}/5) offers basic amenities at an affordable price. "
    
    # Add amenities description
    if 'Pool' in amenities:
        description += "Enjoy the refreshing swimming pool and relax in style. "
    if 'Spa' in amenities:
        description += "Unwind with spa treatments and wellness facilities. "
    if 'Beach Access' in amenities:
        description += "Direct beach access makes it perfect for beach lovers. "
    if 'WiFi' in amenities:
        description += "Stay connected with complimentary high-speed WiFi. "
    if 'Gym' in amenities:
        description += "Maintain your fitness routine with the on-site gym. "
    
    return description

def _create_recommendation(hotel_name, hotel_type, amenities, city, price, rating):
    """Create a personalized recommendation for why this hotel is good"""
    recommendation = ""
    
    if rating >= 4.5:
        recommendation += f"⭐ Excellent choice! {hotel_name} boasts outstanding reviews and premium amenities. "
    elif rating >= 4.0:
        recommendation += f"👍 Great value! {hotel_name} offers reliable service with good amenities. "
    
    # Price-based recommendation
    if price < 2000:
        recommendation += "Perfect for budget travelers looking for essential comforts. "
    elif price < 5000:
        recommendation += "Ideal for mid-range travelers seeking quality and convenience. "
    elif price < 10000:
        recommendation += "Excellent for those wanting premium experiences without breaking the bank. "
    else:
        recommendation += "Luxury experience for special occasions and discerning travelers. "
    
    # Location-based recommendation
    city_recommendations = {
        'Goa': "Perfect for beach vacations and water sports enthusiasts. ",
        'Mumbai': "Ideal for business travelers and city explorers. ",
        'Delhi': "Great for cultural experiences and historical sightseeing. ",
        'Jaipur': "Excellent for heritage lovers and palace enthusiasts. ",
        'Agra': "Perfect for Taj Mahal visitors and history buffs. ",
    }
    recommendation += city_recommendations.get(city, f"Well-located in {city} for local attractions. ")
    
    # Amenity-based recommendation
    if 'Pool' in amenities and 'Spa' in amenities:
        recommendation += "Relaxation paradise with pool and spa facilities. "
    elif 'Beach Access' in amenities:
        recommendation += "Direct beach access makes it unbeatable for coastal getaways. "
    elif 'Gym' in amenities:
        recommendation += "Fitness-focused travelers will appreciate the gym facilities. "
    
    return recommendation

def _get_nearby_attractions(city):
    """Get nearby attractions for the city"""
    attractions = {
        'Goa': ['Baga Beach', 'Anjuna Beach', 'Calangute Beach', 'Dudhsagar Falls', 'Fort Aguada'],
        'Mumbai': ['Gateway of India', 'Marine Drive', 'Elephanta Caves', 'Chor Bazaar', 'Juhu Beach'],
        'Delhi': ['Red Fort', 'India Gate', 'Qutub Minar', 'Lotus Temple', 'Akshardham Temple'],
        'Jaipur': ['Amber Fort', 'City Palace', 'Hawa Mahal', 'Jantar Mantar', 'Nahargarh Fort'],
        'Agra': ['Taj Mahal', 'Agra Fort', 'Fatehpur Sikri', 'Itmad-ud-Daulah', 'Mehtab Bagh'],
        'Kolkata': ['Victoria Memorial', 'Howrah Bridge', 'Marble Palace', 'South City Mall', 'Princep Ghat'],
        'Chennai': ['Marina Beach', 'Kapaleeshwarar Temple', 'Fort St. George', 'San Thome Basilica', 'Guindy National Park'],
        'Bangalore': ['Lalbagh Botanical Garden', 'Cubbon Park', 'Bangalore Palace', 'Vidhana Soudha', 'UB City'],
        'Hyderabad': ['Charminar', 'Golconda Fort', 'Hussain Sagar Lake', 'Salar Jung Museum', 'Birla Mandir'],
        'Pune': ['Shaniwar Wada', 'Aga Khan Palace', 'Sinhagad Fort', 'Parvati Hill', 'Bund Garden'],
    }
    return attractions.get(city, [f'Local attractions in {city}'])

class HotelSearchRequest(BaseModel):
    message: str
    context: Dict[str, Any]

@app.get("/")
def root():
    return {"status": "OK", "mode": "CSV + Gemini"}

@app.post("/api/hotel/search")
def search_hotels(request: HotelSearchRequest):
    try:
        city = request.context.get('city', 'Goa')
        budget = request.context.get('budget', 25000)
        message = request.message
        
        print(f"\n🔍 Search: {city}, ₹{budget}")
        
        # Try CSV
        city_hotels = hotels_df[
            (hotels_df['city'].str.lower() == city.lower()) &
            (hotels_df['price_per_night'] <= budget)
        ]
        
        has_special = any(word in message.lower() for word in ['near', 'airport', 'beach', 'luxury', 'special'])
        has_special_request = 'special request:' in message.lower()
        
        if len(city_hotels) > 0 and not has_special and not has_special_request:
            print(f"✅ CSV: {len(city_hotels)} hotels")
            hotels = []
            for _, h in city_hotels.iterrows():
                amenities = h['extras'].split('|') if '|' in str(h['extras']) else [h['extras']]
                
                # Create detailed description based on hotel type and amenities
                description = _create_hotel_description(h['name'], h['accommodation_type'], amenities, city, float(h['rating']))
                why_recommended = _create_recommendation(h['name'], h['accommodation_type'], amenities, city, float(h['price_per_night']), float(h['rating']))
                nearby_attractions = _get_nearby_attractions(city)
                
                hotels.append({
                    'name': h['name'],
                    'city': h['city'],
                    'price_per_night': float(h['price_per_night']),
                    'type': h['accommodation_type'],
                    'rating': float(h['rating']),
                    'amenities': amenities,
                    'description': description,
                    'why_recommended': why_recommended,
                    'nearby_attractions': nearby_attractions,
                })
            return {'status': 'success', 'powered_by': 'CSV', 'ai_used': False, 'hotels': hotels, 'count': len(hotels)}
        
        # Use Gemini
        print(f"🤖 Using Gemini AI...")
        prompt = f"""Find 5-8 hotels in {city}, India under ₹{budget}/night. Request: {message}

Return JSON with 'hotels' array. Each hotel must have:
- name: string
- type: string (Hotel/Resort/Hostel/etc.)
- price_per_night: number
- rating: number (1-5)
- amenities: array of strings
- description: detailed description (2-3 sentences)
- why_recommended: why this hotel is good for the user (2-3 sentences)
- nearby_attractions: array of 3-5 nearby attractions

Format: {{"hotels": [{{"name": "...", "type": "...", "price_per_night": 5000, "rating": 4.2, "amenities": ["WiFi", "Pool"], "description": "...", "why_recommended": "...", "nearby_attractions": ["Attraction1", "Attraction2"]}}]}}"""
        
        model = genai.GenerativeModel('gemini-2.0-flash-exp')
        response = model.generate_content(prompt)
        text = response.text
        
        if '```json' in text:
            text = text.split('```json')[1].split('```')[0]
        elif '```' in text:
            text = text.split('```')[1].split('```')[0]
        
        result = json.loads(text.strip())
        hotels = result.get('hotels', [])
        
        # Ensure all required fields are present
        for hotel in hotels:
            if 'description' not in hotel:
                hotel['description'] = _create_hotel_description(hotel['name'], hotel.get('type', 'Hotel'), hotel.get('amenities', []), city, hotel.get('rating', 4.0))
            if 'why_recommended' not in hotel:
                hotel['why_recommended'] = _create_recommendation(hotel['name'], hotel.get('type', 'Hotel'), hotel.get('amenities', []), city, hotel.get('price_per_night', 5000), hotel.get('rating', 4.0))
            if 'nearby_attractions' not in hotel:
                hotel['nearby_attractions'] = _get_nearby_attractions(city)
        
        print(f"✅ Gemini: {len(hotels)} hotels")
        
        return {'status': 'success', 'powered_by': 'Gemini AI', 'ai_used': True, 'hotels': hotels, 'count': len(hotels)}
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return {"status": "error", "message": str(e)}

@app.post("/api/hotel/images")
def get_hotel_images(request: HotelSearchRequest):
    try:
        hotel_name = request.context.get('hotel_name', '')
        city = request.context.get('city', 'Goa')

        print(f"\n🖼️ Fetching images for: {hotel_name}, {city}")

        # Use Gemini to generate specific image search terms
        prompt = f"""
        Generate 10 specific search terms for finding authentic photos of "{hotel_name}" hotel in {city}, India.
        Focus on unique features like:
        - Hotel exterior and architecture
        - Lobby and reception
        - Rooms and suites
        - Restaurants and dining areas
        - Pool and spa areas
        - Unique amenities or nearby attractions

        Return ONLY a JSON array of specific search terms.
        Format: ["luxury hotel lobby {city}", "{hotel_name} presidential suite", "{hotel_name} infinity pool", ...]
        """

        model = genai.GenerativeModel('gemini-2.0-flash-exp')
        response = model.generate_content(prompt)
        text = response.text

        if '```json' in text:
            text = text.split('```json')[1].split('```')[0]
        elif '```' in text:
            text = text.split('```')[1].split('```')[0]

        search_terms = json.loads(text.strip())

        # Generate image URLs using search terms
        image_urls = []
        for term in search_terms[:10]:
            # Create Unsplash source URLs (no API key needed)
            encoded_term = f"{term} {city} India hotel".replace(' ', '-').lower()
            url = f"https://source.unsplash.com/800x600/?{encoded_term}"
            image_urls.append(url)

        # Ensure we have 10 images
        while len(image_urls) < 10:
            fallback_term = f"luxury-hotel-{city.lower()}"
            url = f"https://source.unsplash.com/800x600/?{fallback_term}"
            image_urls.append(url)

        return {
            'status': 'success',
            'hotel_name': hotel_name,
            'city': city,
            'images': image_urls[:10],
            'powered_by': 'Gemini AI + Unsplash'
        }

    except Exception as e:
        print(f"❌ Image fetch error: {e}")
        # Return fallback images
        fallback_images = [
            'https://source.unsplash.com/800x600/?luxury-hotel-lobby',
            'https://source.unsplash.com/800x600/?luxury-hotel-room',
            'https://source.unsplash.com/800x600/?luxury-hotel-pool',
            'https://source.unsplash.com/800x600/?luxury-hotel-restaurant',
            'https://source.unsplash.com/800x600/?luxury-hotel-spa',
            'https://source.unsplash.com/800x600/?luxury-hotel-bar',
            'https://source.unsplash.com/800x600/?luxury-hotel-garden',
            'https://source.unsplash.com/800x600/?luxury-hotel-suite',
            'https://source.unsplash.com/800x600/?luxury-hotel-exterior',
            'https://source.unsplash.com/800x600/?luxury-hotel-bathroom',
        ]

        return {
            'status': 'fallback',
            'hotel_name': hotel_name,
            'city': city,
            'images': fallback_images,
            'message': 'Using curated hotel images'
        }

if __name__ == "__main__":
    import uvicorn
    print("🚀 Starting Ultra-Simple Hotel Search Server...")
    print("📍 Server will run on http://localhost:8001")
    print("🔧 Mode: CSV + Gemini AI")
    uvicorn.run(app, host="0.0.0.0", port=8001)
