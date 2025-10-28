# Hotel Search Response Guide - Google ADK Integration

## Overview
When you click "Search Hotels" in the Flutter app, here's what happens and the response format you receive.

## Flow of Execution

### 1. Flutter App Request
When user clicks "Search Hotels" button, the Flutter app sends a request to the Python backend:

```dart
// From search_hotels_screen.dart
Future<List<Hotel>> getHotels({
  String? city,
  double? minPrice,
  double? maxPrice,
  String? type,
  List<String>? amenities,
}) async {
  final queryParams = {
    if (city != null) 'city': city,
    if (minPrice != null) 'min_price': minPrice.toString(),
    if (maxPrice != null) 'max_price': maxPrice.toString(),
    if (type != null) 'type': type,
    if (amenities != null) 'amenities': amenities.join(','),
  };
  
  final response = await http.get(uri, headers: _headers);
  // ... process response
}
```

### 2. Python Backend API (api_server.py)

The request hits the FastAPI backend endpoint:

```python
@app.post("/api/hotel/search")
async def search_hotels(request: AgentRequest):
    """
    Request Format:
    {
        "message": "Find hotels in Goa under ₹5000",
        "context": {
            "city": "Goa",
            "budget": 5000,
            "ambiance": "romantic"
        }
    }
    """
    
    # Calls Google ADK root agent
    response = root_agent.send_message(message)
    
    return AgentResponse(
        success=True,
        response=response.content[0].text,
        agent="hotel_booking"
    )
```

### 3. Google ADK Multi-Agent Response

The Google ADK system processes through the hotel booking agent and returns:

## Response Format

### API Response Structure
```json
{
  "success": true,
  "response": "Found 5 accommodation(s) from CSV matching your criteria...",
  "agent": "hotel_booking",
  "data": {
    "city": "Goa",
    "budget": 5000
  }
}
```

### Detailed Hotel Search Response (from hotel agent)

```json
{
  "status": "found",
  "location": "Goa",
  "check_in": "2025-10-27",
  "check_out": "2025-10-28",
  "guests": 2,
  "count": 5,
  "message": "Found 5 accommodation(s) from CSV matching your criteria",
  "accommodations": [
    {
      "type": "Hotel",
      "name": "Taj Exotica Resort & Spa",
      "price_per_night": "₹8,500",
      "rating": "4.8",
      "room_types": [
        "Deluxe Room",
        "Premium Suite",
        "Villa with Private Pool"
      ],
      "food_options": [
        "Multi-Cuisine Restaurant",
        "Veg & Non-Veg",
        "Seafood Speciality"
      ],
      "ambiance": [
        "Luxury",
        "Romantic",
        "Beach Resort"
      ],
      "extras": [
        "Private Beach Access",
        "Spa & Wellness Center",
        "Infinity Pool",
        "Water Sports"
      ],
      "nearby_attractions": [
        "Calangute Beach",
        "Baga Beach",
        "Fort Aguada"
      ],
      "accessibility": [
        "Wheelchair Accessible",
        "Elevator Access"
      ]
    },
    {
      "type": "Hotel",
      "name": "The Leela Goa",
      "price_per_night": "₹7,200",
      "rating": "4.7",
      "room_types": [
        "Classic Room",
        "Club Room",
        "Suite"
      ],
      "food_options": [
        "Continental",
        "Indian Cuisine",
        "Bar & Lounge"
      ],
      "ambiance": [
        "Luxury",
        "Family-Friendly",
        "Beach Resort"
      ],
      "extras": [
        "Golf Course",
        "Kids Club",
        "Multiple Pools",
        "Casino"
      ],
      "nearby_attractions": [
        "Mobor Beach",
        "Butterfly Beach",
        "Cola Beach"
      ],
      "accessibility": [
        "Wheelchair Accessible"
      ]
    }
  ]
}
```

## Response Flow in Flutter

### When Search Succeeds:

1. **API Response Parsing** (api_service.dart):
```dart
if (response.statusCode == 200) {
  final List<dynamic> data = jsonDecode(response.body)['hotels'] ?? [];
  return data.map((json) => Hotel.fromJson(json)).toList();
}
```

2. **Display in UI** (search_hotels_screen.dart):
```dart
setState(() {
  _searchResults = results;
  _searched = true;
  _loading = false;
});

// Show success message
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Found ${results.length} hotels in $_selectedCity'),
    backgroundColor: Colors.green,
  ),
);
```

### When Using AI-Powered Search:

If the user provides special requests or uses AI features:

```dart
// AI-Enhanced Response
if (_aiPowered && _aiCriteria != null) {
  results = await _mockData.searchHotelsWithAI(
    city: _selectedCity!,
    minPrice: _priceRange.start,
    maxPrice: _priceRange.end,
    aiCriteria: _aiCriteria,
  );
  
  // Shows AI intent message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('✨ AI found ${results.length} hotels: ${_aiCriteria!['intent']}'),
      backgroundColor: Colors.deepPurple,
    ),
  );
}
```

## Complete Response Example with AI

### User Input:
- City: "Goa"
- Special Request: "I want a romantic beachfront hotel with spa facilities"
- Budget: ₹5000

### Google ADK Agent Response:
```json
{
  "success": true,
  "response": "I found 3 perfect romantic hotels in Goa with spa facilities...\n\n1. **Taj Exotica Resort & Spa** (₹8,500/night)\n   - Rating: 4.8⭐\n   - Romantic beachfront property with luxury spa\n   - Private beach access & couples' spa packages\n   - Near Calangute Beach\n\n2. **The Leela Goa** (₹7,200/night)\n   - Rating: 4.7⭐\n   - Luxury beach resort with world-class spa\n   - Romantic ambiance with sea views\n   - Multiple dining options\n\n3. **Grand Hyatt Goa** (₹6,800/night)\n   - Rating: 4.6⭐\n   - Romantic setting with spa & wellness center\n   - Poolside dining & private beaches\n   - Perfect for couples\n\nAll properties offer:\n✅ Beach access\n✅ Spa & wellness facilities\n✅ Romantic ambiance\n✅ Fine dining options\n\nWould you like to book any of these or see more options?",
  "agent": "hotel_booking",
  "data": {
    "status": "found",
    "location": "Goa",
    "accommodations": [/* detailed hotel objects */],
    "filters_applied": {
      "ambiance": "romantic",
      "extras": ["spa", "beach"],
      "budget": 5000
    }
  }
}
```

## Error Handling

### When City Not Found:
```json
{
  "success": true,
  "response": "I couldn't find hotels in that location. Here are available cities...",
  "agent": "hotel_booking",
  "data": {
    "status": "not_found",
    "location": "InvalidCity",
    "message": "No accommodations in CSV for InvalidCity",
    "available_cities": "Mumbai, Delhi, Goa, Bangalore, Jaipur, Kolkata, Chennai, Hyderabad"
  }
}
```

### When API Fails (Fallback to Mock Data):
```dart
try {
  results = await _api.getHotels(/* params */);
} catch (apiError) {
  print('Backend API failed, using mock data: $apiError');
  results = await _mockData.searchHotels(/* params */);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Found ${results.length} hotels (Using offline data)'),
      backgroundColor: Colors.orange,
    ),
  );
}
```

## Key Features of the Response

### 1. **Comprehensive Hotel Data**
- Name, type, rating
- Price per night
- Room types available
- Food options (Veg/Non-Veg/Vegan)
- Ambiance categories
- Extra amenities
- Nearby attractions
- Accessibility features

### 2. **Smart Filtering**
The Google ADK agent automatically filters based on:
- Budget constraints
- Ambiance preferences
- Room type requirements
- Food preferences
- Special amenities

### 3. **Contextual Recommendations**
The agent provides:
- Alternative suggestions if exact match not found
- Travel booking recommendations
- Nearby attractions information
- Best value options

### 4. **Natural Language Understanding**
The ADK agent can understand queries like:
- "Find romantic hotels in Goa under ₹5000"
- "I need a budget-friendly hostel with good food"
- "Show me luxury resorts with spa facilities"
- "Pet-friendly hotels near beaches"

## UI Response Display

The Flutter app displays the response as:

1. **Loading State**: Shows spinner with "Searching hotels..."
2. **Success State**: 
   - Displays hotel cards with images
   - Shows filtered results count
   - Enables swipe mode for browsing
3. **AI Badge**: Shows AI-powered search indicator
4. **Snackbar Messages**: 
   - Success: Green snackbar with count
   - AI-powered: Purple snackbar with intent
   - Offline: Orange snackbar indicating mock data
   - Error: Red snackbar with retry option

## Summary

When you click "Search Hotels" in the Flutter app:

1. ✅ Flutter sends HTTP request to Python backend
2. ✅ Python FastAPI forwards to Google ADK multi-agent system
3. ✅ Hotel Booking Agent searches CSV database with smart filtering
4. ✅ Response includes detailed hotel information with all amenities
5. ✅ Flutter displays results in beautiful UI with swipe capability
6. ✅ AI-powered responses include natural language explanations
7. ✅ Fallback to mock data ensures app always works offline

The response is **context-aware**, **intelligent**, and provides **comprehensive hotel information** powered by Google's ADK (Agent Development Kit)! 🎉
