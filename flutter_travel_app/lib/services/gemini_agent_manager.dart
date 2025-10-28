import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import '../models/hotel.dart';
import 'mock_data_service.dart';
import 'hotel_booking_agent.dart'; // Import specialized hotel agent

/// Agentic AI Manager - Mirrors the Python ADK (Agent Development Kit) architecture
/// Uses Gemini 2.0 Flash with ADK-inspired agent patterns
/// Acts as coordinator for all sub-agents (hotel, flight, destination)
class GeminiAgentManager {
  static const String _apiKey = 'AIzaSyB491Ttpz_6iQEQb5cLPDmvklvZk0Zz9E0';
  late final GenerativeModel _model;
  final MockDataService _mockDataService = MockDataService();

  // Specialized sub-agents (ADK pattern)
  final HotelBookingAgent _hotelAgent = HotelBookingAgent();

  // Conversation history for context-aware responses (ADK pattern)
  final List<Content> _conversationHistory = [];

  // ADK-style tool definitions for function calling
  final List<Tool> _tools = [
    Tool(functionDeclarations: [
      FunctionDeclaration(
        'search_hotels',
        'Search for hotels in a specific city with filters',
        Schema(SchemaType.object, properties: {
          'city': Schema(SchemaType.string,
              description: 'The city to search hotels in'),
          'min_price':
              Schema(SchemaType.number, description: 'Minimum price per night'),
          'max_price':
              Schema(SchemaType.number, description: 'Maximum price per night'),
          'ambiance': Schema(SchemaType.string,
              description:
                  'Preferred ambiance (Luxury, Romantic, Budget, etc.)'),
        }, requiredProperties: [
          'city'
        ]),
      ),
      FunctionDeclaration(
        'get_destination_info',
        'Get information about a destination',
        Schema(SchemaType.object, properties: {
          'city': Schema(SchemaType.string,
              description: 'The city to get information about'),
        }, requiredProperties: [
          'city'
        ]),
      ),
    ]),
  ];

  GeminiAgentManager() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash-exp', // Using Gemini 2.0 Flash (experimental)
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.8,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
      ),
      tools: _tools, // Enable ADK-style function calling
    );
  }

  /// Main entry point - Manager decides which sub-agent to call
  /// This is the agentic behavior: autonomous decision making
  Future<Map<String, dynamic>> processUserRequest({
    required String userMessage,
    Map<String, dynamic>? context,
  }) async {
    try {
      // Add user message to conversation history
      _conversationHistory.add(Content.text('User: $userMessage'));

      // Get manager's decision on which agent to call
      final managerDecision = await _getManagerDecision(
        userMessage: userMessage,
        context: context,
      );

      // Execute the decided action
      final result = await _executeAgentAction(managerDecision, context);

      // Add manager's response to history
      _conversationHistory.add(Content.text('Manager: ${result['response']}'));

      return result;
    } catch (e) {
      print('Manager Error: $e');
      return {
        'success': false,
        'response': 'Sorry, I encountered an error. Please try again.',
        'agent': 'manager',
      };
    }
  }

  /// Manager analyzes user intent and decides which sub-agent to invoke
  /// This implements the "Agentic AI" decision-making process
  Future<Map<String, dynamic>> _getManagerDecision({
    required String userMessage,
    Map<String, dynamic>? context,
  }) async {
    final prompt = _buildManagerPrompt(userMessage, context);

    final chat = _model.startChat(history: _conversationHistory);
    final response = await chat.sendMessage(Content.text(prompt));
    final responseText = response.text ?? '';

    // Parse manager's decision
    return _parseManagerDecision(responseText);
  }

  /// Builds the manager's system prompt (mirrors Python backend instructions)
  String _buildManagerPrompt(
      String userMessage, Map<String, dynamic>? context) {
    final currentContext = context ?? {};
    final city = currentContext['city'] ?? 'unknown';
    final budget = currentContext['hotelBudget'] ?? 0;

    return '''
You are an expert travel booking manager using Gemini 2.0 Flash with ADK-inspired agent patterns.
You coordinate multiple specialized sub-agents to provide comprehensive travel planning.

**Your Specialized Sub-Agents** (mirroring Python ADK architecture):

1. **hotel_booking** (Accommodation Agent):
   - Search and book hotels
   - Filter by: Room type, Food options, Ambiance, Price range
   - Handle: Check-in/out dates, Special requests
   - Available tools: search_hotels()
   
2. **travel_booking** (Travel Agent):
   - Search and book: Flights, Trains, Taxis
   - Filter by: Class, Preferences
   - Coming soon
   
3. **destination_info** (Planning Agent):
   - Provide: Destination information, Attractions, Activities
   - Suggest: Based on travel style
   - Available tools: get_destination_info()

**Current Context**:
- Destination: $city
- Budget: ₹$budget
- User Preferences: ${json.encode(currentContext)}

**User Request**: "$userMessage"

**Your Task**:
1. Analyze the user's request
2. Determine which sub-agent should handle it
3. Extract parameters needed for that agent
4. Return a JSON decision

**Decision Format**:
{
  "agent": "hotel_booking|travel_booking|destination_info|manager",
  "action": "search|book|provide_info|clarify",
  "parameters": {
    "city": "extracted city",
    "minPrice": 0,
    "maxPrice": 10000,
    "preferences": ["preference1", "preference2"]
  },
  "reasoning": "Why this agent and action",
  "needs_clarification": false,
  "clarification_question": "What do you need to know?"
}

**Examples**:

User: "Find me hotels in Goa under ₹5000"
Response: {
  "agent": "hotel_booking",
  "action": "search",
  "parameters": {
    "city": "Goa",
    "minPrice": 0,
    "maxPrice": 5000
  },
  "reasoning": "User wants hotel search in Goa with price filter",
  "needs_clarification": false
}

User: "I want romantic places"
Response: {
  "agent": "hotel_booking",
  "action": "search",
  "parameters": {
    "ambiance": "romantic",
    "preferences": ["romantic", "couples", "honeymoon"]
  },
  "reasoning": "User wants romantic accommodations, needs city info",
  "needs_clarification": true,
  "clarification_question": "Which city would you like to visit for a romantic getaway?"
}

Respond with ONLY valid JSON, no additional text.
''';
  }

  /// Parses manager's decision from AI response
  Map<String, dynamic> _parseManagerDecision(String responseText) {
    try {
      String cleanedResponse =
          responseText.replaceAll('```json', '').replaceAll('```', '').trim();

      return json.decode(cleanedResponse);
    } catch (e) {
      print('Error parsing manager decision: $e');
      return {
        'agent': 'manager',
        'action': 'clarify',
        'needs_clarification': true,
        'clarification_question':
            'Could you please provide more details about your travel plans?',
      };
    }
  }

  /// Executes the action decided by the manager
  /// This is where sub-agents are invoked autonomously
  Future<Map<String, dynamic>> _executeAgentAction(
    Map<String, dynamic> decision,
    Map<String, dynamic>? context,
  ) async {
    final agent = decision['agent'] ?? 'manager';
    // Action type for future use in routing logic
    // final action = decision['action'] ?? 'clarify';

    // Check if clarification needed
    if (decision['needs_clarification'] == true) {
      return {
        'success': true,
        'agent': agent,
        'action': 'clarify',
        'response': decision['clarification_question'] ??
            'Could you provide more details?',
        'needs_input': true,
      };
    }

    // Route to appropriate sub-agent
    switch (agent) {
      case 'hotel_booking':
        return await _invokeHotelAgent(decision, context);

      case 'travel_booking':
        return await _invokeTravelAgent(decision, context);

      case 'destination_info':
        return await _invokeDestinationAgent(decision, context);

      default:
        return {
          'success': true,
          'agent': 'manager',
          'response':
              decision['reasoning'] ?? 'How can I help you plan your trip?',
        };
    }
  }

  /// Hotel Booking Sub-Agent (delegates to specialized HotelBookingAgent)
  Future<Map<String, dynamic>> _invokeHotelAgent(
    Map<String, dynamic> decision,
    Map<String, dynamic>? context,
  ) async {
    print('🏨 Manager delegating to HotelBookingAgent...');

    // Extract user message from decision
    final reasoning = decision['reasoning'] ?? 'Search for hotels';

    // Delegate to specialized hotel agent (ADK sub-agent pattern)
    final result = await _hotelAgent.processRequest(
      userMessage: reasoning,
      context: context,
    );

    // If agent returned hotels via tools, format the response
    if (result['has_results'] == true) {
      return {
        'success': true,
        'agent': 'hotel_booking',
        'action': 'search_complete',
        'response': result['response'],
        'data': {
          'hotels': [], // Hotels are embedded in the AI response
          'count': result['hotels_found'] ?? 0,
          'city': context?['city'] ?? '',
        },
      };
    }

    return result;
  }

  /// Generate intelligent explanation for hotel results
  Future<String> _generateHotelExplanation(
    List<Hotel> hotels,
    Map<String, dynamic> decision,
  ) async {
    if (hotels.isEmpty) {
      return "I couldn't find any hotels matching your criteria. Would you like to adjust your search parameters?";
    }

    final params = decision['parameters'] ?? {};
    final preferences = params['preferences'] ?? [];
    final reasoning = decision['reasoning'] ?? '';

    final prompt = '''
Generate a friendly, conversational response for hotel search results.

Found: ${hotels.length} hotels
User preferences: ${preferences.join(', ')}
Context: $reasoning

Top 3 hotels:
${hotels.take(3).map((h) => '- ${h.name} (${h.type}, ₹${h.pricePerNight}/night, ${h.rating}⭐)').join('\n')}

Write a 2-3 sentence response explaining:
1. How many hotels found
2. Why these hotels match their needs
3. Ask if they want to see more or filter further

Be friendly, helpful, and conversational.
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? "I found ${hotels.length} hotels for you!";
    } catch (e) {
      return "I found ${hotels.length} great hotels matching your preferences! Would you like to explore them?";
    }
  }

  /// Travel Booking Sub-Agent (placeholder for future implementation)
  Future<Map<String, dynamic>> _invokeTravelAgent(
    Map<String, dynamic> decision,
    Map<String, dynamic>? context,
  ) async {
    return {
      'success': true,
      'agent': 'travel_booking',
      'response':
          'Flight and train booking coming soon! For now, let me help you find hotels.',
    };
  }

  /// Destination Info Sub-Agent (placeholder for future implementation)
  Future<Map<String, dynamic>> _invokeDestinationAgent(
    Map<String, dynamic> decision,
    Map<String, dynamic>? context,
  ) async {
    return {
      'success': true,
      'agent': 'destination_info',
      'response':
          'Destination information coming soon! Let me help you find accommodations first.',
    };
  }

  /// Get conversation summary (for debugging)
  List<Map<String, String>> getConversationHistory() {
    return _conversationHistory.map((content) {
      // Extract text from parts (handling different part types)
      final textParts = content.parts
          .whereType<TextPart>()
          .map((p) => (p).text)
          .join(' ');

      return {
        'role': content.role ?? 'unknown',
        'text': textParts,
      };
    }).toList();
  }

  /// Clear conversation history
  void clearHistory() {
    _conversationHistory.clear();
  }
}
