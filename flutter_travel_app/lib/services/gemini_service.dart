import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import '../models/hotel.dart';

/// Service for integrating Google Gemini AI for intelligent hotel search
/// Uses Gemini 1.5 Flash for fast, context-aware recommendations
class GeminiService {
  static const String _apiKey = 'AIzaSyB491Ttpz_6iQEQb5cLPDmvklvZk0Zz9E0';
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048,
      ),
    );
  }

  /// Analyzes user search intent and enhances search criteria using AI
  ///
  /// Takes user form data and natural language prompt, returns AI-enhanced
  /// search criteria with intelligent scoring and recommendations
  Future<Map<String, dynamic>> analyzeSearchIntent({
    required String city,
    required double minPrice,
    required double maxPrice,
    required String roomType,
    required String food,
    required String ambiance,
    required List<String> amenities,
    required String userPrompt,
    required List<Hotel> availableHotels,
  }) async {
    try {
      // Build comprehensive prompt for Gemini
      final prompt = _buildSearchPrompt(
        city: city,
        minPrice: minPrice,
        maxPrice: maxPrice,
        roomType: roomType,
        food: food,
        ambiance: ambiance,
        amenities: amenities,
        userPrompt: userPrompt,
        availableHotels: availableHotels,
      );

      // Call Gemini API
      final response = await _model.generateContent([Content.text(prompt)]);
      final responseText = response.text ?? '';

      // Parse AI response
      final enhancedCriteria = _parseGeminiResponse(responseText);

      return enhancedCriteria;
    } catch (e) {
      print('Gemini AI Error: $e');
      // Fallback to basic criteria if AI fails
      return _getFallbackCriteria(
        city: city,
        minPrice: minPrice,
        maxPrice: maxPrice,
        roomType: roomType,
        amenities: amenities,
      );
    }
  }

  /// Builds intelligent prompt for Gemini with context and available hotels
  String _buildSearchPrompt({
    required String city,
    required double minPrice,
    required double maxPrice,
    required String roomType,
    required String food,
    required String ambiance,
    required List<String> amenities,
    required String userPrompt,
    required List<Hotel> availableHotels,
  }) {
    // Convert available hotels to JSON for AI analysis
    final hotelsJson = availableHotels
        .map((h) => {
              'id': h.id,
              'name': h.name,
              'city': h.city,
              'type': h.type,
              'price': h.pricePerNight,
              'rating': h.rating,
              'amenities': h.amenities,
              'food': h.food,
              'ambiance': h.ambiance,
              'roomType': h.roomType,
            })
        .toList();

    return '''
You are an intelligent travel assistant for a hotel booking platform. Your task is to analyze user preferences and recommend the best matching hotels.

USER SEARCH CRITERIA:
- City: $city
- Budget: ₹$minPrice - ₹$maxPrice per night
- Room Type: $roomType
- Food Preference: $food
- Ambiance: $ambiance
- Required Amenities: ${amenities.join(', ')}

USER'S NATURAL LANGUAGE REQUEST:
"$userPrompt"

AVAILABLE HOTELS IN DATABASE:
${json.encode(hotelsJson)}

YOUR TASK:
1. Analyze the user's natural language request to extract hidden preferences and context
2. Consider factors like:
   - Trip purpose (business, leisure, honeymoon, family, etc.)
   - Special occasions (anniversary, birthday, etc.)
   - Specific location preferences (beachfront, city center, etc.)
   - Activity preferences (spa, adventure, relaxation, etc.)
   - Group composition (solo, couple, family, group)
3. Score each hotel from 0-100 based on how well it matches ALL criteria
4. Provide a brief explanation for top recommendations

OUTPUT FORMAT (JSON only, no markdown):
{
  "intent": "brief description of what user wants",
  "context": {
    "tripPurpose": "business|leisure|honeymoon|family|other",
    "occasion": "anniversary|birthday|vacation|business|other|none",
    "groupType": "solo|couple|family|friends|business",
    "priorityFactors": ["location", "amenities", "price", "rating", "ambiance"]
  },
  "mustHave": ["list of mandatory requirements"],
  "niceToHave": ["list of preferred features"],
  "hotelScores": [
    {
      "hotelId": "hotel_id",
      "score": 85,
      "reason": "why this hotel matches"
    }
  ],
  "recommendations": ["3-5 hotel IDs in priority order"]
}

Respond ONLY with valid JSON, no additional text.
''';
  }

  /// Parses Gemini's response and extracts enhanced search criteria
  Map<String, dynamic> _parseGeminiResponse(String responseText) {
    try {
      // Remove markdown code blocks if present
      String cleanedResponse =
          responseText.replaceAll('```json', '').replaceAll('```', '').trim();

      final parsed = json.decode(cleanedResponse);

      return {
        'intent': parsed['intent'] ?? 'General hotel search',
        'context': parsed['context'] ?? {},
        'mustHave': List<String>.from(parsed['mustHave'] ?? []),
        'niceToHave': List<String>.from(parsed['niceToHave'] ?? []),
        'hotelScores': parsed['hotelScores'] ?? [],
        'recommendations': List<String>.from(parsed['recommendations'] ?? []),
        'aiPowered': true,
      };
    } catch (e) {
      print('Error parsing Gemini response: $e');
      print('Response was: $responseText');
      return _getFallbackCriteria(
        city: '',
        minPrice: 0,
        maxPrice: 100000,
        roomType: '',
        amenities: [],
      );
    }
  }

  /// Returns basic criteria if AI fails (fallback)
  Map<String, dynamic> _getFallbackCriteria({
    required String city,
    required double minPrice,
    required double maxPrice,
    required String roomType,
    required List<String> amenities,
  }) {
    return {
      'intent': 'Basic hotel search',
      'context': {
        'tripPurpose': 'leisure',
        'occasion': 'none',
        'groupType': 'solo',
        'priorityFactors': ['price', 'rating'],
      },
      'mustHave': amenities,
      'niceToHave': [],
      'hotelScores': [],
      'recommendations': [],
      'aiPowered': false,
    };
  }

  /// Generates conversational explanation for search results
  Future<String> explainRecommendations({
    required List<Hotel> recommendedHotels,
    required String userPrompt,
    required Map<String, dynamic> searchCriteria,
  }) async {
    try {
      final prompt = '''
You recommended these hotels to a user who searched: "$userPrompt"

Recommended Hotels:
${recommendedHotels.map((h) => '- ${h.name} (${h.type}, ₹${h.pricePerNight}/night, ${h.rating}⭐)').join('\n')}

Write a brief, friendly 2-3 sentence explanation of why these hotels are perfect for their needs.
Be conversational and highlight key matching features.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'These hotels match your preferences perfectly!';
    } catch (e) {
      return 'I found ${recommendedHotels.length} hotels that match your criteria!';
    }
  }

  /// Generates smart follow-up questions to help refine search
  Future<List<String>> generateFollowUpQuestions({
    required Map<String, dynamic> searchCriteria,
    required int resultsCount,
  }) async {
    try {
      final intent = searchCriteria['intent'] ?? 'hotel search';
      final context = searchCriteria['context'] ?? {};

      final prompt = '''
User searched for: "$intent"
Trip purpose: ${context['tripPurpose'] ?? 'general'}
Results found: $resultsCount hotels

Generate 3 helpful follow-up questions to refine their search.
Keep questions short (5-8 words each).
Format as JSON array of strings.

Example: ["Need hotels near the beach?", "Prefer hotels with spa?", "Looking for family-friendly options?"]
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final responseText = response.text ?? '[]';
      final questions = json.decode(
          responseText.replaceAll('```json', '').replaceAll('```', '').trim());

      return List<String>.from(questions);
    } catch (e) {
      return [
        'Need hotels with specific amenities?',
        'Looking for a different price range?',
        'Want to try a different location?',
      ];
    }
  }
}
