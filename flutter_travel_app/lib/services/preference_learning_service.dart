import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hotel.dart';

class PreferenceLearningService {
  static const String _likedHotelsKey = 'liked_hotels';
  static const String _dislikedHotelsKey = 'disliked_hotels';
  static const String _preferencesKey = 'learned_preferences';

  // Record a liked hotel
  Future<void> recordLike(Hotel hotel) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> likedHotels = prefs.getStringList(_likedHotelsKey) ?? [];

    // Store hotel data
    final hotelJson = json.encode({
      'id': hotel.id,
      'name': hotel.name,
      'type': hotel.type,
      'price': hotel.pricePerNight,
      'rating': hotel.rating,
      'amenities': hotel.amenities,
      'city': hotel.city,
    });

    likedHotels.add(hotelJson);
    await prefs.setStringList(_likedHotelsKey, likedHotels);

    // Update learned preferences
    await _updatePreferences();
  }

  // Record a disliked hotel
  Future<void> recordDislike(Hotel hotel) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> dislikedHotels =
        prefs.getStringList(_dislikedHotelsKey) ?? [];

    final hotelJson = json.encode({
      'id': hotel.id,
      'name': hotel.name,
      'type': hotel.type,
      'price': hotel.pricePerNight,
      'rating': hotel.rating,
      'amenities': hotel.amenities,
      'city': hotel.city,
    });

    dislikedHotels.add(hotelJson);
    await prefs.setStringList(_dislikedHotelsKey, dislikedHotels);

    // Update learned preferences
    await _updatePreferences();
  }

  // Analyze patterns and update preferences
  Future<void> _updatePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final likedHotels = await _getLikedHotels();

    if (likedHotels.isEmpty) return;

    // Analyze price range
    final prices = likedHotels.map((h) => h['price'] as double).toList();
    final avgPrice = prices.reduce((a, b) => a + b) / prices.length;
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);

    // Analyze preferred types
    final types = <String, int>{};
    for (var hotel in likedHotels) {
      final type = hotel['type'] as String;
      types[type] = (types[type] ?? 0) + 1;
    }
    final preferredTypes = types.entries
        .where((e) => e.value > likedHotels.length * 0.3)
        .map((e) => e.key)
        .toList();

    // Analyze preferred amenities
    final amenities = <String, int>{};
    for (var hotel in likedHotels) {
      final hotelAmenities = (hotel['amenities'] as List).cast<String>();
      for (var amenity in hotelAmenities) {
        amenities[amenity] = (amenities[amenity] ?? 0) + 1;
      }
    }
    final preferredAmenities = amenities.entries
        .where((e) => e.value > likedHotels.length * 0.5)
        .map((e) => e.key)
        .toList();

    // Analyze rating preference
    final ratings = likedHotels.map((h) => h['rating'] as double).toList();
    final avgRating = ratings.reduce((a, b) => a + b) / ratings.length;

    // Store preferences
    final preferences = {
      'avgPrice': avgPrice,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'preferredTypes': preferredTypes,
      'preferredAmenities': preferredAmenities,
      'minRating': avgRating - 0.5, // Prefer similar or better ratings
      'updated': DateTime.now().toIso8601String(),
    };

    await prefs.setString(_preferencesKey, json.encode(preferences));
  }

  // Get learned preferences
  Future<Map<String, dynamic>> getLearnedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final prefsString = prefs.getString(_preferencesKey);

    if (prefsString == null) {
      return {};
    }

    return json.decode(prefsString) as Map<String, dynamic>;
  }

  // Get liked hotels
  Future<List<Map<String, dynamic>>> _getLikedHotels() async {
    final prefs = await SharedPreferences.getInstance();
    final likedHotels = prefs.getStringList(_likedHotelsKey) ?? [];

    return likedHotels
        .map((h) => json.decode(h) as Map<String, dynamic>)
        .toList();
  }

  // Get disliked hotels
  Future<List<Map<String, dynamic>>> _getDislikedHotels() async {
    final prefs = await SharedPreferences.getInstance();
    final dislikedHotels = prefs.getStringList(_dislikedHotelsKey) ?? [];

    return dislikedHotels
        .map((h) => json.decode(h) as Map<String, dynamic>)
        .toList();
  }

  // Clear all learning data
  Future<void> clearLearningData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_likedHotelsKey);
    await prefs.remove(_dislikedHotelsKey);
    await prefs.remove(_preferencesKey);
  }

  // Get statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final liked = await _getLikedHotels();
    final disliked = await _getDislikedHotels();
    final preferences = await getLearnedPreferences();

    return {
      'totalLiked': liked.length,
      'totalDisliked': disliked.length,
      'hasPreferences': preferences.isNotEmpty,
      'preferences': preferences,
    };
  }
}
