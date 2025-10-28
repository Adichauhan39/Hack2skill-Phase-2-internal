# 🏨 Specialized Hotel Booking Agent - ADK-Inspired Architecture

## Why We Can't Use Google ADK for Web/Flutter

### **Google ADK (Agent Development Kit) Limitations:**

❌ **Python Only** - ADK is currently available exclusively for Python
❌ **No Dart/JavaScript Port** - Google hasn't released ADK for web platforms
❌ **Backend Focus** - Designed for server-side agent orchestration
❌ **Heavy Dependencies** - Requires Python-specific libraries and frameworks

### **Our Solution:**

✅ **Gemini 2.0 Flash** - Latest model with function calling
✅ **ADK-Inspired Patterns** - Mimic ADK architecture in Flutter
✅ **Tool/Function Calling** - Use Gemini's native tool support
✅ **Specialized Sub-Agents** - Create dedicated agent classes like Python

---

## Architecture Comparison

### Python Backend (ADK):
```python
from google.adk.agents import Agent
from google.adk.tools.agent_tool import AgentTool

# Manager Agent
root_agent = Agent(
    name="manager",
    model="gemini-2.0-flash",
    sub_agents=[
        hotel_booking,      # Specialized sub-agent
        travel_booking,     # Specialized sub-agent
        destination_info    # Specialized sub-agent
    ],
    tools=[get_current_time],
)

# Hotel Sub-Agent
hotel_booking = Agent(
    name="hotel_booking",
    model="gemini-2.0-flash",
    tools=[search_accommodations, book_accommodation],
)
```

### Flutter Frontend (ADK-Inspired):
```dart
// Manager Agent
class GeminiAgentManager {
  final HotelBookingAgent _hotelAgent = HotelBookingAgent();
  final TravelBookingAgent _travelAgent = TravelBookingAgent();
  final DestinationAgent _destinationAgent = DestinationAgent();
  
  // Routes requests to appropriate sub-agent
  Future<Map<String, dynamic>> _invokeHotelAgent() {
    return _hotelAgent.processRequest(...);
  }
}

// Hotel Sub-Agent
class HotelBookingAgent {
  late final GenerativeModel _model;
  final List<Tool> _tools = [
    Tool(functionDeclarations: [
      FunctionDeclaration(
        name: 'search_accommodations',
        description: 'Search hotels with filters',
      ),
      FunctionDeclaration(
        name: 'book_accommodation',
        description: 'Book selected hotel',
      ),
    ]),
  ];
}
```

---

## Hotel Booking Agent Implementation

### File: `hotel_booking_agent.dart`

**Key Features:**
1. ✅ **Specialized Agent** - Dedicated to hotel search/booking only
2. ✅ **Tool Declarations** - search_accommodations, book_accommodation
3. ✅ **System Instructions** - Agent personality and capabilities
4. ✅ **Function Calling** - Automatic tool execution by Gemini
5. ✅ **CSV Data Integration** - Loads hotels from mock data service

### Agent Configuration:
```dart
final String name = 'hotel_booking';
final String description = 'Accommodation booking agent';

// Tools (ADK pattern)
final List<Tool> _tools = [
  Tool(functionDeclarations: [
    FunctionDeclaration(
      name: 'search_accommodations',
      parameters: {
        'location': 'City name',
        'min_price': 'Minimum price per night',
        'max_price': 'Maximum price per night',
        'accommodation_type': 'Hotel/Hostel/Resort',
        'room_type': 'Single/Double/Suite...',
        'ambiance': 'Luxury/Budget/Romantic...',
      },
    ),
  ]),
];
```

### System Instruction (Agent Personality):
```dart
String _getSystemInstruction() {
  return '''
You are a specialized hotel booking agent with expertise in accommodations.

**Your Capabilities**:
- Search hotels across Indian cities
- Filter by room type, food, ambiance, price, amenities
- Provide personalized recommendations
- Handle special requests (accessibility, pet-friendly)
- Book after user confirmation

**Response Style**:
- Friendly and professional
- Understand natural language
- Extract hidden preferences
- Provide 3-5 top recommendations
- Explain why each hotel matches
''';
}
```

### Tool Execution Flow:

```
User Request
    ↓
HotelBookingAgent.processRequest()
    ↓
Gemini 2.0 Flash (with system instruction)
    ↓
Decides to call search_accommodations()
    ↓
_handleFunctionCalls()
    ↓
_searchAccommodations() [executes tool]
    ↓
Queries MockDataService (CSV data)
    ↓
Returns results to Gemini
    ↓
Gemini generates natural language response
    ↓
Returns to Manager Agent
    ↓
Manager forwards to user
```

---

## Manager Agent Integration

### File: `gemini_agent_manager.dart`

**Updated to use specialized agent:**

```dart
class GeminiAgentManager {
  // Specialized sub-agents (ADK pattern)
  final HotelBookingAgent _hotelAgent = HotelBookingAgent();

  /// Hotel Booking Sub-Agent (delegates to specialized agent)
  Future<Map<String, dynamic>> _invokeHotelAgent(
    Map<String, dynamic> decision,
    Map<String, dynamic>? context,
  ) async {
    print('🏨 Manager delegating to HotelBookingAgent...');
    
    // Delegate to specialized hotel agent
    final result = await _hotelAgent.processRequest(
      userMessage: reasoning,
      context: context,
    );

    return result;
  }
}
```

---

## Advantages Over Generic Approach

### Before (Generic):
```dart
// Manager does everything
Future<Map<String, dynamic>> _invokeHotelAgent() {
  final hotels = await _mockDataService.searchHotels(...);
  final explanation = await _generateExplanation(...);
  return {'hotels': hotels, 'response': explanation};
}
```

### After (Specialized Agent):
```dart
// Manager delegates to specialized agent
Future<Map<String, dynamic>> _invokeHotelAgent() {
  return await _hotelAgent.processRequest(...);
}

// HotelBookingAgent handles everything
class HotelBookingAgent {
  - Own Gemini model with custom system instructions
  - Own tools (search, book)
  - Own context and state
  - Own response generation
}
```

### Benefits:
1. ✅ **Separation of Concerns** - Each agent has one responsibility
2. ✅ **Easier to Maintain** - Update hotel logic without touching manager
3. ✅ **Easier to Extend** - Add new agents (flights, destinations) independently
4. ✅ **Better AI Performance** - Specialized instructions per agent
5. ✅ **Mirrors Python Backend** - Same architecture as ADK system
6. ✅ **Function Calling** - Agent decides when to call tools automatically

---

## Demo Script for Judges

### Opening:
*"While Google ADK is Python-only, we've created an ADK-inspired architecture in Flutter using Gemini 2.0 Flash with function calling."*

### Show Code:

**1. Hotel Booking Agent** (`hotel_booking_agent.dart`)
```dart
- Line 10: Agent configuration (name, description)
- Line 18: Tool declarations (search_accommodations, book_accommodation)
- Line 100: System instruction (agent personality)
- Line 140: processRequest() - main entry point
- Line 200: _handleFunctionCalls() - automatic tool execution
- Line 250: _searchAccommodations() - tool implementation
```

**2. Manager Agent** (`gemini_agent_manager.dart`)
```dart
- Line 15: Specialized sub-agents instantiation
- Line 280: _invokeHotelAgent() - delegates to HotelBookingAgent
```

### Live Demo:

1. **Fill Form:**
   - City: Goa
   - Budget: ₹5000
   - Special Request: "romantic beachfront hotel for anniversary"

2. **Behind the Scenes (Show Logs):**
```
🏨 Manager delegating to HotelBookingAgent...
🔧 Hotel Agent calling tool: search_accommodations
🔍 Searching hotels in Goa (₹0 - ₹5000)
✅ Found 5 hotels matching criteria
🤖 Gemini generating personalized response...
```

3. **Result:**
   - AI explains why each hotel matches
   - Hotels shown in swipeable interface

### Key Points:
- ✅ **Specialized Agents** - Like Python ADK sub-agents
- ✅ **Function Calling** - Gemini decides when to call tools
- ✅ **System Instructions** - Each agent has unique personality
- ✅ **Tool Execution** - Automatic by Gemini 2.0 Flash
- ✅ **Scalable** - Easy to add flights, destinations agents

---

## Future Agents to Add

### Travel Booking Agent:
```dart
class TravelBookingAgent {
  final List<Tool> _tools = [
    search_flights(),
    search_trains(),
    book_transport(),
  ];
}
```

### Destination Info Agent:
```dart
class DestinationInfoAgent {
  final List<Tool> _tools = [
    get_attractions(),
    get_activities(),
    generate_itinerary(),
  ];
}
```

---

## Technical Stack

- **Model**: Gemini 2.0 Flash (gemini-2.0-flash-exp)
- **Package**: google_generative_ai ^0.4.6
- **Pattern**: ADK-inspired multi-agent system
- **Tools**: Function calling with FunctionDeclaration
- **Architecture**: Manager + Specialized Sub-Agents

---

## Summary

✅ **Cannot use ADK web** - Python only, no Dart/JS support  
✅ **Built ADK-inspired system** - Using Gemini 2.0 Flash  
✅ **Specialized Hotel Agent** - Mirrors Python hotel_booking.py  
✅ **Function Calling** - Automatic tool execution  
✅ **Scalable** - Easy to add more agents  
✅ **Production-Ready** - Clean separation, maintainable code  

**This is as close to ADK as possible in Flutter! 🚀**
