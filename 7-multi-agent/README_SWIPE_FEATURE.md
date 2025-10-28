# 🎯 Swipe-Based Travel Recommendations

## Overview
A Tinder-like swipe interface for discovering and shortlisting travel options, hotels, and destinations! Swipe right (👍) if you're interested, swipe left (👎) to skip.

## 🎨 Features

### 1. **Swipeable Travel Options**
Browse flights, trains, and taxis between cities:
- See price, duration, amenities at a glance
- Compare multiple transport modes
- Shortlist your favorites

### 2. **Swipeable Hotel Cards**
Discover hotels and hostels:
- View rating, price per night, room types
- See amenities, ambiance, food options
- Build a shortlist of accommodations

### 3. **Swipeable Destination Discovery**
Explore Indian cities:
- Filter by: Beach, Hill Station, City, Desert
- Match travel style: Luxury, Budget, Romantic, Family
- Discover attractions, cuisine, activities

## 🚀 How to Use

### Example 1: Discover Beach Destinations
```
You: "Show me beach destinations I can explore"

Agent: *Generates swipeable cards for Goa, Mumbai, Kerala, Chennai*
- 🏖️ **Goa**: Known for beaches, nightlife, Portuguese architecture
  - Swipe right if interested, left to skip

You: *Swipes right on Goa*

Agent: "✅ Added Goa to your wishlist! Would you like to see:
- 🏨 Hotels in Goa?
- ✈️ Travel options to Goa?
- 🎯 More destinations?"
```

### Example 2: Find Hotels
```
You: "Show me hotels in Delhi for Nov 1-5"

Agent: *Generates hotel cards with details*

Card 1: Taj Palace
- Price: ₹8,500/night
- Rating: ⭐⭐⭐⭐⭐
- Room Types: Deluxe, Suite
- Amenities: Pool, Spa, WiFi
👉 Swipe right to shortlist, left to skip

You: *Swipes right on 2-3 hotels*

Agent: "You've shortlisted 3 hotels! Ready to book your favorite?"
```

### Example 3: Compare Travel Options
```
You: "Show me ways to travel from Mumbai to Goa on Nov 15"

Agent: *Shows flights, trains, taxis*

✈️ Flight AI-6231
- Price: ₹4,500
- Duration: 1h 15m
- Amenities: WiFi, Meals, Priority Boarding

🚂 Train 10103 - Mandovi Express  
- Price: ₹1,200 (AC)
- Duration: 8h 30m

You: *Swipes right on the flight*

Agent: "✅ Added AI-6231 to shortlist! Book now or see more options?"
```

## 💡 User Commands

### Generate Recommendations
- `"Show me beach destinations"`
- `"Show me hotels in [city]"`
- `"Show me luxury hotels in [city]"`
- `"Show me travel options from [origin] to [destination]"`
- `"Show me budget-friendly destinations"`

### Manage Shortlist
- `"Show my shortlist"` - View all swiped-right items
- `"Show my liked hotels"` - View shortlisted hotels
- `"What did I like?"` - View all favorites

### Booking
- `"Book the hotel I liked"` - Proceed with booking
- `"Book flight from my shortlist"` - Book travel
- `"Clear my shortlist"` - Start fresh

## 🎯 Technical Implementation

### Architecture
```
Manager Agent (Root)
    ↓
Swipe Recommendations Agent
    ↓
Tools:
- generate_travel_recommendations()
- generate_hotel_recommendations()
- generate_destination_recommendations()
- handle_swipe_action()
- get_liked_items()
```

### Data Flow
1. **User Request** → Manager routes to Swipe Agent
2. **Generate Cards** → Loads data from CSV files
3. **Present UI** → Returns structured card data
4. **User Swipes** → `handle_swipe_action()` processes
5. **Track Preferences** → Saves to tool_context.state
6. **Book Selected** → Delegates to booking agents

### State Management
```python
tool_context.state["swipe_history"] = {
    "liked": [
        {
            "card_id": "hotel_3",
            "type": "accommodation",
            "data": {...}  # Action data for booking
        }
    ],
    "disliked": [...]
}
```

## 🎨 UI/UX in ADK Web

### Card Format
Each card returns structured data:
```python
{
    "id": "hotel_1",
    "type": "accommodation",
    "title": "Taj Palace",
    "subtitle": "Hotel in Delhi",
    "rating": "⭐⭐⭐⭐⭐",
    "details": {
        "Price/Night": "₹8,500",
        "Room Types": "Deluxe, Suite",
        "Ambiance": "Luxury, Romantic"
    },
    "highlights": ["WiFi", "Pool", "Spa"],
    "action_data": {
        "accommodation_name": "Taj Palace",
        "location": "Delhi",
        ...
    }
}
```

### ADK Web Rendering
The ADK web interface automatically renders the structured card data. The agent presents cards conversationally, and users can:
1. Read the details
2. Say "I like this" / "swipe right" / "yes"
3. Say "skip" / "swipe left" / "no"
4. Ask "show me more"

## 🔧 Customization

### Add Custom Filters
Edit `swipe_recommendations.py`:
```python
# Filter by budget
if preferences.get('max_price'):
    results = [r for r in results if r['price'] <= preferences['max_price']]
```

### Change Card Display
Modify the card structure in tool functions:
```python
card = {
    "id": f"hotel_{card_id}",
    "custom_field": "your_data",
    ...
}
```

### Integrate with External APIs
Replace CSV loading with API calls:
```python
def load_hotels_from_api(location):
    response = requests.get(f"https://api.example.com/hotels?city={location}")
    return response.json()
```

## 📊 Analytics

Track user preferences:
```python
# In your tools
liked_destinations = [item for item in swipe_history['liked'] if item['type'] == 'destination']
popular_locations = Counter([d['data']['location'] for d in liked_destinations])
```

## 🎉 Benefits

1. **Engaging UX**: Fun, modern interface
2. **Quick Discovery**: Browse multiple options fast
3. **Smart Shortlisting**: Build favorites list
4. **Context Retention**: System remembers preferences
5. **Seamless Booking**: One-click from shortlist to booking

## 🚀 Next Steps

1. Run `adk web`
2. Ask: "Show me beach destinations"
3. Start swiping!
4. Build your shortlist
5. Book your favorites

Happy Swiping! 🎉✈️🏨🏖️
