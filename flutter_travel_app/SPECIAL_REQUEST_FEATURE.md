# Special Request / AI Prompt Feature

## Overview
The app now supports AI-powered special requests where users can ask for specific preferences, and the AI will help filter and recommend hotels accordingly.

## How It Works

### 1. **User Interface**
- Located in the home screen search form (all tabs: Hotels, Flights, Destinations)
- Multi-line text field labeled "Special Requests (Optional)"
- Placeholder: "E.g., Early check-in, high floor, quiet room..."

### 2. **AI Processing Flow**
When a user enters a special request and clicks "Search Hotels":

```
User Input → Home Screen → Search Hotels Screen → AI Agent → Hotel Search → Results
```

**Example Requests:**
- "I need a hotel with sea view and near the beach"
- "Looking for budget-friendly hotel with good breakfast"
- "I want a luxury hotel with spa facilities"
- "Need a hotel near the airport with late check-out"
- "Pet-friendly hotel with parking space"

### 3. **Backend Integration**
```dart
// In search_hotels_screen.dart
if (_specialRequest.isNotEmpty) {
  final aiResponse = await _api.sendMessage(
    'I am looking for hotels in $_selectedCity. Special request: $_specialRequest. '
    'Check-in: ${_checkIn}, Check-out: ${_checkOut}, '
    'Guests: $_guests, Rooms: $_rooms',
  );
  // AI processes the request and provides recommendations
}
```

### 4. **Data Flow**

#### Home Screen → Search Hotels
```dart
Get.toNamed('/search-hotels', arguments: {
  'from': _fromController.text,
  'city': _toController.text,
  'checkIn': _checkInDate,
  'checkOut': _checkOutDate,
  'guests': _guests,
  'rooms': _rooms,
  'specialRequest': _specialRequestController.text, // ← AI Prompt
});
```

#### Search Hotels Screen Receives
```dart
_specialRequest = arguments['specialRequest'] as String? ?? '';
```

#### AI Agent Processing
```dart
await _api.sendMessage(
  'Hotel search query with special request'
);
```

## Features

### ✅ **Implemented**
1. **Text Input Field** - Multi-line TextField for special requests
2. **Data Passing** - Special request passed from home to search screen
3. **AI Integration** - Sends request to backend AI agent before search
4. **User Feedback** - Shows AI response in SnackBar
5. **Context Aware** - Includes all search parameters (city, dates, guests, rooms)

### 🔄 **How AI Enhances Search**
The AI agent can:
- Understand natural language requests
- Filter hotels based on specific requirements
- Recommend hotels matching preferences
- Consider amenities, location, price, ratings
- Provide personalized suggestions

### 📝 **Example Conversations**

**User:** "I need a quiet hotel with good WiFi for work"
**AI:** "I'll search for hotels in Mumbai with excellent WiFi and quieter locations, avoiding party areas..."

**User:** "Budget hotel near railway station"
**AI:** "Searching for affordable hotels (₹1000-₹3000) within 2km of Mumbai Central Station..."

**User:** "Luxury hotel with pool and spa"
**AI:** "Finding premium hotels in Mumbai with swimming pool and spa facilities..."

## Technical Details

### Modified Files
1. **home_screen.dart**
   - Added `_specialRequestController`
   - Added TextField for special requests
   - Passes `specialRequest` in navigation arguments

2. **search_hotels_screen.dart**
   - Receives `_specialRequest` from arguments
   - Calls AI agent with special request before search
   - Shows AI response to user
   - Uses `_rooms` and `_specialRequest` variables

### API Endpoint Used
```dart
// POST http://localhost:8000/chat
{
  "message": "Hotel search query with special request",
  "session_id": "unique_session_id",
  "timestamp": "2025-10-26T..."
}
```

## Benefits

### For Users
- ✅ Natural language input (no technical terms needed)
- ✅ Personalized recommendations
- ✅ Context-aware search
- ✅ Intelligent filtering
- ✅ Better hotel matches

### For Demo
- 🎯 Showcases AI integration
- 🎯 Unique selling point (AI-powered search)
- 🎯 Google Gemini AI usage
- 🎯 Natural language processing
- 🎯 Competitive advantage over traditional booking apps

## Future Enhancements
1. **Voice Input** - "Tap to speak" for hands-free requests
2. **Smart Suggestions** - Auto-complete based on popular requests
3. **Chat Interface** - Full conversation with AI agent
4. **Image-based Search** - "Find hotels similar to this image"
5. **Preference Learning** - Remember user preferences across sessions

## Testing

### Test Cases
1. **Empty Request** - Should work normally (skip AI)
2. **Simple Request** - "wifi" → AI finds hotels with WiFi
3. **Complex Request** - "budget hotel near beach with parking" → AI filters accordingly
4. **Invalid Request** - "xyz123" → AI handles gracefully

### Backend Requirement
- Backend must be running on `http://localhost:8000`
- `/chat` endpoint must be available
- AI agent should handle hotel-related queries

## Summary
The Special Request feature transforms the app from a simple booking platform into an **intelligent travel assistant** that understands and responds to natural language queries, providing a superior user experience powered by Google Gemini AI.
