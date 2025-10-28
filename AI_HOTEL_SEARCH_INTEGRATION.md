# 🤖 AI-Powered Hotel Search Integration Guide

## ✨ Overview
Your Flutter travel app now has **AI-powered hotel recommendations** using **Google Gemini 2.0 Flash**! The AI understands natural language queries and provides intelligent, personalized hotel suggestions with match scores and reasoning.

---

## 🚀 How It Works

### Backend (Python)
- **Server**: `test_ai_complete.py` runs on `http://127.0.0.1:8001`
- **Endpoint**: `POST /api/hotel/search`
- **AI Model**: Google Gemini 2.0 Flash
- **API Key**: AIzaSyAaC4DMxu0mHPggTp7eyEoG4rtAywCQ4z8

### Frontend (Flutter)
- **Screen**: `lib/screens/search_hotels_screen.dart`
- **Service**: `lib/services/api_service.dart` → `searchHotelsWithAI()`
- **Model**: `lib/models/hotel.dart` (enhanced with AI fields)

---

## 📱 User Experience

### 1. Search Hotels Screen
Users see **TWO search buttons**:
1. **Search Hotels** - Regular search (uses CSV data)
2. **✨ AI-Powered Search (Gemini 2.0)** - Intelligent AI search

### 2. AI Search Features
When user clicks **AI-Powered Search**:
- ✅ Sends natural language query to AI
- ✅ AI analyzes user preferences (room type, food, ambiance, budget)
- ✅ Returns **TOP 3 hotels** ranked by relevance
- ✅ Each hotel includes:
  - **Match Score** (e.g., 95%, 88%, 60%)
  - **Why Recommended** (AI explanation)
  - **Highlights** (key features)
  - **Perfect For** (ideal guest profile)
  - **Overall AI Advice**

### 3. Enhanced Hotel Cards
AI-powered results display special cards with:
- 🎨 **Purple border** and elevated shadow
- 🏆 **Match score badge** at the top
- 💬 **AI reasoning** in italicized text
- 🎯 **Highlighted features** in purple chips
- ✅ **"Perfect for"** description in green

---

## 🔧 Setup Instructions

### Step 1: Start the AI Backend Server
```powershell
cd "c:\Hack2skill\Hack2skill finale\7-multi-agent"
python test_ai_complete.py
```

You should see:
```
==============================================================================
  STARTING AI HOTEL SEARCH TEST SERVER
==============================================================================
```

Server will run on `http://127.0.0.1:8001` and stay active.

### Step 2: Run Your Flutter App
```bash
cd flutter_travel_app
flutter run
```

### Step 3: Test AI Search
1. Open the app
2. Navigate to **Search Hotels** screen
3. Select a city (e.g., Goa)
4. Click **✨ AI-Powered Search (Gemini 2.0)**
5. Wait 2-4 seconds for AI results
6. See intelligent hotel recommendations!

---

## 📊 Example AI Search Results

### Test Query: "Romantic hotel with spa and beach view" (Goa, ₹25,000)

**Results:**
1. **Taj Exotica Resort** - 95% Match
   - ₹20,000/night
   - Why: "Offers luxurious romantic ambiance, spa, and beach access"
   - Highlights: Luxury Ambiance, Spa Services, Beach Access
   - Perfect for: Couples seeking luxurious beach vacation

2. **Cidade de Goa** - 88% Match
   - ₹12,000/night
   - Why: "Traditional luxury with spa and beach access"
   - Highlights: Traditional Luxury, Spa, Beach Access
   - Perfect for: Couples preferring traditional experience

3. **Moustache Hostel Palolem** - 60% Match
   - ₹1,200/night
   - Why: "Budget-friendly beach access option"
   - Highlights: Beach Access, Budget-friendly
   - Perfect for: Budget-conscious beachfront stay

**AI Advice:** "For the most romantic experience, book Taj Exotica Resort in advance, especially during peak season."

---

## 🎯 Code Changes Summary

### 1. API Service (`api_service.dart`)
Added new method:
```dart
Future<Map<String, dynamic>> searchHotelsWithAI({
  required String message,
  required String city,
  required double budget,
  String? roomType,
  List<String>? foodTypes,
  String? ambiance,
  List<String>? extras,
})
```

### 2. Hotel Model (`hotel.dart`)
Added AI-specific fields:
```dart
final String? aiMatchScore;
final String? whyRecommended;
final List<String>? highlights;
final String? perfectFor;
```

### 3. Search Screen (`search_hotels_screen.dart`)
- Added `_searchHotelsWithAI()` method
- Added AI search button in UI
- Enhanced `_HotelCard` widget to display AI data

---

## 🔍 Request/Response Format

### Request to Backend
```json
{
  "message": "romantic hotel with spa and beach view",
  "context": {
    "city": "Goa",
    "budget": 25000,
    "room_type": "Deluxe",
    "ambiance": "Romantic"
  }
}
```

### Response from Backend
```json
{
  "status": "success",
  "powered_by": "Google Gemini 2.0 Flash",
  "hotels": [
    {
      "name": "Taj Exotica Resort",
      "city": "Goa",
      "price_per_night": 20000,
      "rating": 4.8,
      "type": "Resort",
      "match_score": "95%",
      "why_recommended": "Excellent fit with luxurious romantic ambiance...",
      "highlights": ["Luxury Ambiance", "Spa Services", "Beach Access"],
      "perfect_for": "Couples seeking luxurious beach vacation",
      "amenities": ["WiFi", "Pool", "Spa", "Restaurant"]
    }
  ],
  "count": 3,
  "overall_advice": "Book in advance during peak season",
  "location": "Goa"
}
```

---

## 🎨 UI Design Highlights

### Regular Hotel Card
- Simple white card
- Basic hotel info (name, city, price, rating)
- Standard amenities chips

### AI-Powered Hotel Card
- **Purple border** (2px with opacity)
- **Elevated shadow** (elevation: 4)
- **Match score badge** at top with gradient background
- **"AI Powered" label** in purple
- **Why recommended** section with light purple background
- **Highlights** in purple chips with border
- **"Perfect for"** section with green checkmark

---

## ⚡ Performance

- **Response Time**: 2.6 - 4.2 seconds (Google Gemini API)
- **Results**: TOP 3 hotels (not 10+)
- **Timeout**: 30 seconds (configurable)
- **Error Handling**: Falls back to regular search if AI fails

---

## 🛠️ Troubleshooting

### Problem: "AI Search unavailable"
**Solution**: 
1. Check if Python server is running on port 8001
2. Run: `python test_ai_complete.py`
3. Verify API key is valid

### Problem: Connection Refused
**Solution**:
1. Make sure port 8001 is not blocked
2. Check firewall settings
3. Use `netstat -ano | findstr ":8001"` to verify port

### Problem: No AI data displayed
**Solution**:
1. Check if `hotel.aiMatchScore != null`
2. Verify backend response format
3. Check Flutter console for errors

---

## 🎯 Future Enhancements

1. **Image Generation**: Use AI to generate hotel images
2. **Voice Search**: "Find me a romantic hotel in Goa"
3. **Chat Interface**: Conversational hotel booking
4. **Preference Learning**: AI learns user preferences over time
5. **Multi-language**: AI search in Hindi, Tamil, etc.

---

## 📝 Notes

- Keep the Python server running while testing
- AI search requires internet connection
- Regular search works offline with CSV data
- AI results are cached for better performance

---

## ✅ Test Checklist

- [ ] Python server starts successfully
- [ ] Flutter app connects to port 8001
- [ ] AI search button appears
- [ ] AI search returns results
- [ ] Match scores displayed correctly
- [ ] "Why recommended" text visible
- [ ] Highlights chips shown
- [ ] Purple border on AI cards
- [ ] Overall advice appears in snackbar
- [ ] Fallback to regular search on error

---

## 🎉 Success!

Your Flutter app now has **cutting-edge AI-powered hotel recommendations**! Users can:
- 🔍 Search naturally ("romantic spa hotel")
- 🎯 Get personalized TOP 3 matches
- 💡 Understand WHY each hotel is recommended
- ⚡ Make informed booking decisions

**Demo this at your Hack2skill presentation!** 🏆
