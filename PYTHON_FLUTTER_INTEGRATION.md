# Python ADK + Flutter Integration Guide

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter Frontend (Dart)                  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Home Screen → Search Form                            │  │
│  │  Hotels Tab | Flights Tab | Destinations Tab         │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────┬────────────────────────────────────────┘
                     │ HTTP REST API
                     │ (JSON over HTTP)
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              FastAPI Backend (api_server.py)                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  POST /api/agent          → Manager Agent            │  │
│  │  POST /api/hotel/search   → Hotel Booking Agent      │  │
│  │  POST /api/flight/search  → Travel Booking Agent     │  │
│  │  POST /api/destination    → Destination Info Agent   │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────┬────────────────────────────────────────┘
                     │ Python ADK API
                     │ (root_agent.send_message)
                     ▼
┌─────────────────────────────────────────────────────────────┐
│        Python Google ADK Multi-Agent System                  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │           Manager Agent (root_agent)                  │  │
│  │  ┌──────────┬──────────┬────────────┬──────────────┐│  │
│  │  │  Hotel   │  Flight  │ Destination│   Budget     ││  │
│  │  │ Booking  │ Booking  │    Info    │   Tracker    ││  │
│  │  └──────────┴──────────┴────────────┴──────────────┘│  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────┬────────────────────────────────────────┘
                     │ Gemini API
                     │ (gemini-2.0-flash-exp)
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                  Google Gemini 2.0 Flash                     │
│                  (AI Model + Function Calling)               │
└─────────────────────────────────────────────────────────────┘
```

## Why This Integration is Needed

### The Problem: ADK is Python-Only

**Google ADK** (Agent Development Kit) is a **Python-only framework** for building multi-agent AI systems. It:
- ✅ Runs on Python servers (backend)
- ❌ **CANNOT run in web browsers**
- ❌ **NO Dart/JavaScript/TypeScript version exists**
- ❌ **CANNOT be embedded in Flutter web apps**

### Why ADK Cannot Run in Browsers

1. **Python Runtime Required**: ADK needs Python interpreter
2. **Heavy Dependencies**: NumPy, pandas, TensorFlow (not browser-compatible)
3. **File System Access**: ADK reads CSV files, model weights
4. **Security**: Direct Gemini API access from browser = exposed API keys
5. **Complex State Management**: ADK maintains conversation state, agent coordination

### "ADK Web" Does NOT Exist

**Important Clarification:**
- There is **NO "ADK Web" framework** from Google
- ADK = Backend agent orchestration framework (Python servers only)
- Not designed for frontend/browser/web applications
- Cannot be converted to JavaScript or Dart

## The Solution: FastAPI Backend Bridge

### Architecture Pattern
```
Flutter Web App → HTTP REST API → Python FastAPI → Python ADK → Gemini
```

### Why FastAPI?
1. **Bridge**: Connects Flutter (frontend) with Python ADK (backend)
2. **REST API**: Universal HTTP protocol (any frontend can use it)
3. **Async**: Non-blocking I/O for performance
4. **CORS**: Allows Flutter web to call backend
5. **Security**: API keys stay on server (not exposed to browser)

## Setup Instructions

### 1. Install Python Dependencies

```bash
cd "c:\Hack2skill\Hack2skill finale\7-multi-agent"
pip install fastapi uvicorn pydantic google-generativeai
```

### 2. Configure API Keys

In `7-multi-agent` directory, create `.env` file:
```env
GEMINI_API_KEY=AIzaSyB491Ttpz_6iQEQb5cLPDmvklvZk0Zz9E0
```

### 3. Start FastAPI Backend

```bash
cd "c:\Hack2skill\Hack2skill finale\7-multi-agent"
uvicorn api_server:app --reload --host 0.0.0.0 --port 8000
```

Expected output:
```
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
INFO:     Started reloader process [XXXX] using WatchFiles
INFO:     Started server process [XXXX]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

### 4. Test Backend (Optional)

Visit: http://localhost:8000/docs

Test with curl:
```bash
curl http://localhost:8000/api/agent -X POST -H "Content-Type: application/json" -d "{\"message\":\"Find hotels in Goa\"}"
```

### 5. Add HTTP Package to Flutter

```bash
cd "c:\Hack2skill\Hack2skill finale\flutter_travel_app"
flutter pub add http
```

### 6. Use Python Backend in Flutter

Two approaches available:

#### Option A: Direct Gemini (Current - ADK-Inspired)
```dart
// lib/services/gemini_agent_manager.dart
final result = await _agentManager.processUserRequest(request);
```

**Pros:**
- No backend required
- Faster (no HTTP overhead)
- Works offline (once models cached)

**Cons:**
- Limited to Flutter implementation
- No full ADK features
- API key in frontend (security risk)

#### Option B: Python ADK Backend (Recommended for Hackathon)
```dart
// lib/services/python_adk_service.dart
final result = await _pythonADK.searchHotels(
  city: city,
  maxPrice: budget,
  roomType: roomType,
);
```

**Pros:**
- Full Python ADK functionality
- True multi-agent coordination
- Secure (API keys on server)
- Scalable (backend handles load)
- Production-ready architecture

**Cons:**
- Requires running Python backend
- HTTP latency (negligible)

## Integration Examples

### Example 1: Hotel Search via Python ADK

```dart
// In home_screen.dart
import 'package:flutter_travel_app/services/python_adk_service.dart';

class _HomeScreenState extends State<HomeScreen> {
  final _pythonADK = PythonADKService();

  Future<void> _onSearchPressed() async {
    setState(() => _isSearching = true);

    try {
      // Check if Python backend is available
      final isAvailable = await _pythonADK.isBackendAvailable();
      
      if (isAvailable) {
        // Use Python ADK backend
        final result = await _pythonADK.searchHotels(
          city: _selectedCity,
          maxPrice: _maxPrice,
          roomType: _selectedRoomType,
          ambiance: _selectedAmbiance,
          amenities: _selectedAmenities,
          specialRequest: _searchController.text,
        );

        if (result['success']) {
          _showSnackbar('Python ADK: ${result['response']}');
          // Parse and display hotels
        } else {
          _showSnackbar('Backend Error: ${result['error']}');
        }
      } else {
        // Fallback to direct Gemini
        final result = await _agentManager.processUserRequest(request);
        _showSnackbar('Direct Gemini: ${result['response']}');
      }
    } finally {
      setState(() => _isSearching = false);
    }
  }
}
```

### Example 2: Manager Agent (General Query)

```dart
// Send any travel-related query to manager
final result = await _pythonADK.sendToManager(
  message: 'Plan a 3-day trip to Goa under ₹20000',
  context: {
    'budget': 20000,
    'duration': 3,
    'destination': 'Goa',
  },
);

// Manager decides which agent(s) to use:
// - destination_info: Get Goa attractions
// - hotel_booking: Find hotels under budget
// - travel_booking: Find flights/trains
// - budget_tracker: Track spending
// - itinerary: Create day-by-day plan
```

### Example 3: Destination Info

```dart
final result = await _pythonADK.getDestinationInfo(city: 'Jaipur');

if (result['success']) {
  print('Agent: ${result['agent']}'); // destination_info
  print('Info: ${result['response']}'); // Jaipur attractions, weather, etc.
}
```

## API Endpoints Reference

### POST /api/agent
**Purpose**: Send message to Manager Agent (routes to appropriate sub-agent)

**Request:**
```json
{
  "message": "Find luxury hotels in Mumbai",
  "context": {
    "budget": 10000,
    "preferences": ["sea view", "pool"]
  }
}
```

**Response:**
```json
{
  "response": "I found 5 luxury hotels in Mumbai...",
  "agent": "hotel_booking",
  "data": {...}
}
```

### POST /api/hotel/search
**Purpose**: Direct access to Hotel Booking Agent

**Request:**
```json
{
  "message": "Find hotels in Goa under ₹5000",
  "context": {
    "city": "Goa",
    "max_price": 5000
  }
}
```

### POST /api/flight/search
**Purpose**: Direct access to Travel Booking Agent

### POST /api/destination/info
**Purpose**: Direct access to Destination Info Agent

### GET /api/conversation/history
**Purpose**: Retrieve conversation context

### DELETE /api/conversation/clear
**Purpose**: Clear conversation state

## For Hackathon Demo

### Show Both Approaches to Judges

**1. Direct Gemini Approach (Current)**
```
✅ Works in browser without backend
✅ ADK-inspired architecture (Manager + Sub-agents)
✅ Function calling with Gemini 2.0 Flash
✅ Fast response time

❌ Limited to Flutter implementation
❌ No full Python ADK features
```

**2. Python ADK Backend Approach (Recommended)**
```
✅ Full Python Google ADK functionality
✅ True multi-agent coordination
✅ Production-ready architecture
✅ Scalable and secure
✅ Shows advanced backend integration

❌ Requires running Python backend
```

### Demo Script

1. **Show Python Backend Running**
   ```bash
   uvicorn api_server:app --reload
   ```
   Visit: http://localhost:8000/docs (Swagger UI)

2. **Demonstrate Multi-Agent System**
   - Show `7-multi-agent/manager/agent.py` (Manager)
   - Show sub-agents: hotel_booking, travel_booking, etc.
   - Explain: "This is the Python ADK backend"

3. **Show Flutter Frontend**
   - Open Flutter app
   - Search for hotels
   - Explain: "Flutter sends request to FastAPI"

4. **Show Integration Flow**
   ```
   Flutter → api_server.py → root_agent → hotel_booking → Gemini
   ```

5. **Highlight Key Points**
   - "ADK is Python-only, cannot run in browsers"
   - "FastAPI bridges Flutter with Python ADK"
   - "Full multi-agent coordination on backend"
   - "Secure, scalable, production-ready"

## Deployment Options

### Local Development (Current)
```bash
Backend: http://localhost:8000
Frontend: http://localhost:3000 (flutter run -d chrome)
```

### Production Deployment (Optional)

**Backend:**
- Deploy to Google Cloud Run
- Use Cloud Secret Manager for API keys
- Enable Cloud Logging

**Frontend:**
- Build Flutter web: `flutter build web`
- Deploy to Firebase Hosting
- Update API URL in `python_adk_service.dart`

## Troubleshooting

### Backend Not Starting
```bash
# Check Python version
python --version  # Should be 3.8+

# Reinstall dependencies
pip install --upgrade fastapi uvicorn pydantic
```

### CORS Errors
In `api_server.py`, ensure:
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # For development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### Connection Refused
- Ensure backend is running: `uvicorn api_server:app --reload`
- Check firewall: Allow port 8000
- Verify URL in Flutter: `http://localhost:8000` (not HTTPS)

## Key Takeaways

1. **ADK is Python-Only**: No web/Dart/JavaScript version exists
2. **FastAPI = Bridge**: Connects any frontend with Python ADK backend
3. **Two Approaches**: Direct Gemini (simple) vs Python ADK (advanced)
4. **Production-Ready**: Backend approach scales to millions of users
5. **Hackathon Winner**: Shows full-stack AI integration skills

## Next Steps

1. ✅ FastAPI backend created (`api_server.py`)
2. ✅ Flutter service created (`python_adk_service.dart`)
3. ⏳ Install FastAPI dependencies
4. ⏳ Start backend server
5. ⏳ Test integration
6. ⏳ Update home_screen.dart to use backend
7. ⏳ Prepare demo for judges
