import 'package:flutter/material.dart';

class AppConfig {
  // API Configuration
  static const String baseUrl =
      'http://localhost:8001'; // AI server (test_ai_complete.py)
  static const String apiVersion = 'v1';

  // API Endpoints
  static const String chatEndpoint = '/chat';
  static const String hotelsEndpoint = '/hotels';
  static const String destinationsEndpoint = '/destinations';
  static const String travelEndpoint = '/travel';
  static const String swipeEndpoint = '/swipe';
  static const String budgetEndpoint = '/budget';

  // App Configuration
  static const String appName = 'AI Travel Booking';
  static const String appVersion = '1.0.0';

  // Colors - EaseMyTrip inspired
  static const Color primaryColor = Color(0xFF231F9E); // Deep Blue
  static const Color secondaryColor = Color(0xFFE73C33); // Red accent
  static const Color accentColor = Color(0xFFEF6C00); // Orange
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFE53935);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF231F9E), Color(0xFF3F51B5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFE73C33), Color(0xFFEF6C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeNormal = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 24.0;
  static const double fontSizeXXLarge = 32.0;

  // Animation Durations
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  // Cache Configuration
  static const int cacheMaxAge = 3600; // 1 hour in seconds
  static const int imageCacheMaxAge = 86400; // 24 hours in seconds

  // Pagination
  static const int itemsPerPage = 20;

  // Card Swipe Configuration
  static const double swipeThreshold = 0.5;
  static const int maxSwipeCards = 10;

  // Map Configuration
  static const double defaultLatitude = 28.6139; // Delhi
  static const double defaultLongitude = 77.2090;
  static const double defaultZoom = 12.0;

  // Timeout Configuration
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
