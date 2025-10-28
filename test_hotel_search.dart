import 'dart:convert';
import 'dart:io';
import 'dart:async';

/// Simple test script to verify hotel search functionality
/// Run with: dart test_hotel_search.dart

void main() async {
  print('\n${'=' * 80}');
  print('🧪 HOTEL SEARCH TEST - Flutter App Debugging');
  print('=' * 80);

  // Test configuration
  const String serverUrl = 'http://localhost:8001';
  const String endpoint = '/api/hotel/search';

  print('\n📍 Configuration:');
  print('   Server URL: $serverUrl');
  print('   Endpoint: $endpoint');
  print('   Full URL: $serverUrl$endpoint');

  // Step 1: Check if server is running
  print('\n🔍 Step 1: Checking if AI server is running...');
  try {
    final healthCheck = await HttpClient()
        .getUrl(Uri.parse(serverUrl))
        .timeout(const Duration(seconds: 3));
    final healthResponse = await healthCheck.close();
    final healthBody = await healthResponse.transform(utf8.decoder).join();

    if (healthResponse.statusCode == 200) {
      print('   ✅ Server is RUNNING!');
      print('   Response: $healthBody');
    } else {
      print('   ❌ Server returned error: ${healthResponse.statusCode}');
      return;
    }
  } catch (e) {
    print('   ❌ Server is NOT running!');
    print('   Error: $e');
    print('\n💡 Solution: Run the server first with:');
    print('   cd "c:\\Hack2skill\\Hack2skill finale\\7-multi-agent"');
    print('   python simple_ai_server.py');
    return;
  }

  // Step 2: Prepare hotel search request
  print('\n🔍 Step 2: Preparing hotel search request...');

  final requestData = {
    'message': 'Find hotels in Goa under Rs.5000 with pool and wifi',
    'context': {
      'city': 'Goa',
      'min_price': 0,
      'max_price': 5000,
      'room_type': 'Deluxe',
      'ambiance': 'Luxury',
      'amenities': ['Pool', 'Wi-Fi', 'Parking'],
    },
  };

  print('   Request Data:');
  print('   ${jsonEncode(requestData)}');

  // Step 3: Send request to server
  print('\n🔍 Step 3: Sending request to server...');
  try {
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse('$serverUrl$endpoint'));

    // Set headers
    request.headers.set('Content-Type', 'application/json; charset=utf-8');

    // Write request body with UTF-8 encoding
    request.add(utf8.encode(jsonEncode(requestData)));

    print('   Request sent, waiting for response...');

    // Get response
    final response = await request.close().timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        print('   ⏰ Request timed out after 30 seconds!');
        throw TimeoutException('Server took too long to respond');
      },
    );

    print('   Response received!');
    print('   Status Code: ${response.statusCode}');
    print('   Status Message: ${response.reasonPhrase}');

    // Read response body
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode == 200) {
      print('\n✅ SUCCESS! Response received from AI server');
      print('\n📄 Full Response:');
      print('─' * 80);

      // Pretty print JSON
      try {
        final jsonResponse = jsonDecode(responseBody);
        final prettyJson = JsonEncoder.withIndent('  ').convert(jsonResponse);
        print(prettyJson);

        // Parse and display hotel data
        if (jsonResponse['status'] == 'success') {
          print('\n${'─' * 80}');
          print('🏨 HOTELS FOUND:');
          print('─' * 80);

          final hotels = jsonResponse['hotels'] as List?;
          if (hotels != null && hotels.isNotEmpty) {
            for (var i = 0; i < hotels.length; i++) {
              final hotel = hotels[i];
              print('\n${i + 1}. ${hotel['name']}');
              print('   📍 Location: ${hotel['city']}');
              print('   💰 Price: ₹${hotel['price_per_night']}/night');
              print('   ⭐ Rating: ${hotel['rating']}');
              print('   🎯 Match Score: ${hotel['match_score']}');
              print('   💡 Why Recommended: ${hotel['why_recommended']}');
              print('   ✨ Highlights:');
              final highlights = hotel['highlights'] as List?;
              if (highlights != null) {
                for (var highlight in highlights) {
                  print('      • $highlight');
                }
              }
              print('   👥 Perfect For: ${hotel['perfect_for']}');
            }

            print('\n${'─' * 80}');
            print('📊 Total Hotels: ${hotels.length}');
            print('🤖 Powered By: ${jsonResponse['powered_by']}');
            if (jsonResponse['overall_advice'] != null) {
              print('💬 Advice: ${jsonResponse['overall_advice']}');
            }
          } else {
            print('   ⚠️ No hotels found in response!');
          }
        } else {
          print('\n❌ Server returned error status');
          print('   Message: ${jsonResponse['message']}');
        }
      } catch (e) {
        print('❌ Failed to parse JSON response');
        print('Raw response: $responseBody');
        print('Parse error: $e');
      }
    } else {
      print('\n❌ FAILED! Server returned error');
      print('   Status: ${response.statusCode}');
      print('   Body: $responseBody');
    }

    print('\n${'─' * 80}');
  } catch (e, stackTrace) {
    print('\n❌ ERROR during request!');
    print('   Error: $e');
    print('   Stack trace:');
    print('   $stackTrace');
  }

  print('\n${'=' * 80}');
  print('🧪 TEST COMPLETE');
  print('=' * 80);
  print('\n');
}
