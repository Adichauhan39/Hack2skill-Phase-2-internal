class Destination {
  final String id;
  final String city;
  final String description;
  final List<String> locationType;
  final List<String> activities;
  final List<String> travelStyle;
  final List<String> seasonPreference;
  final List<String> attractions;
  final List<String> nearbyAttractionsType;
  final List<String> cuisine;
  final List<String> language;
  final String famousFor;
  final List<String> nearbyPlaces;
  final String imageUrl;
  
  // Google Maps enhanced data
  final List<AttractionInfo>? topAttractionsWithMaps;
  final bool googleEnhanced;

  Destination({
    required this.id,
    required this.city,
    required this.description,
    required this.locationType,
    required this.activities,
    required this.travelStyle,
    required this.seasonPreference,
    required this.attractions,
    required this.nearbyAttractionsType,
    required this.cuisine,
    required this.language,
    required this.famousFor,
    required this.nearbyPlaces,
    required this.imageUrl,
    this.topAttractionsWithMaps,
    this.googleEnhanced = false,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    List<AttractionInfo>? attractionsInfo;
    if (json['top_attractions_with_maps'] != null) {
      attractionsInfo = (json['top_attractions_with_maps'] as List)
          .map((a) => AttractionInfo.fromJson(a))
          .toList();
    }
    
    return Destination(
      id: json['id']?.toString() ?? '',
      city: json['city'] ?? json['location'] ?? '',
      description: json['description'] ?? '',
      locationType: List<String>.from(json['location_type'] ?? []),
      activities: List<String>.from(json['activities'] ?? []),
      travelStyle: List<String>.from(json['travel_style'] ?? []),
      seasonPreference: List<String>.from(json['season_preference'] ?? []),
      attractions: List<String>.from(json['attractions'] ?? []),
      nearbyAttractionsType: List<String>.from(json['nearby_attractions_type'] ?? []),
      cuisine: List<String>.from(json['cuisine'] ?? []),
      language: List<String>.from(json['language'] ?? []),
      famousFor: json['famous_for'] ?? '',
      nearbyPlaces: List<String>.from(json['nearby_places'] ?? []),
      imageUrl: json['image_url'] ?? json['image'] ?? '',
      topAttractionsWithMaps: attractionsInfo,
      googleEnhanced: json['google_enhanced'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      'description': description,
      'location_type': locationType,
      'activities': activities,
      'travel_style': travelStyle,
      'season_preference': seasonPreference,
      'attractions': attractions,
      'nearby_attractions_type': nearbyAttractionsType,
      'cuisine': cuisine,
      'language': language,
      'famous_for': famousFor,
      'nearby_places': nearbyPlaces,
      'image_url': imageUrl,
      'google_enhanced': googleEnhanced,
    };
  }
}

class AttractionInfo {
  final String name;
  final String googleRating;
  final int totalReviews;
  final String mapsUrl;
  final String address;
  final String phone;
  final List<String> photos;

  AttractionInfo({
    required this.name,
    required this.googleRating,
    required this.totalReviews,
    required this.mapsUrl,
    required this.address,
    required this.phone,
    required this.photos,
  });

  factory AttractionInfo.fromJson(Map<String, dynamic> json) {
    return AttractionInfo(
      name: json['name'] ?? '',
      googleRating: json['google_rating']?.toString() ?? 'N/A',
      totalReviews: json['total_reviews'] ?? 0,
      mapsUrl: json['maps_url'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? 'N/A',
      photos: List<String>.from(json['photos'] ?? []),
    );
  }
}
