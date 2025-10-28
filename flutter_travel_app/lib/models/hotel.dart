class Hotel {
  final String id;
  final String name;
  final String city;
  final String type; // hotel, hostel, resort, vacation_rental
  final double pricePerNight;
  final double rating;
  final int totalReviews;
  final String? roomType;
  final List<String> amenities;
  final String? food;
  final String? ambiance;
  final String imageUrl;
  final String? address;
  final String? phone;
  final String description;
  final double? latitude;
  final double? longitude;
  final bool availability;

  // Google Maps data
  final String? googleRating;
  final String? mapsUrl;
  final List<String>? photos;

  // AI-powered fields (from Gemini 2.0 Flash)
  final String? aiMatchScore;
  final String? whyRecommended;
  final List<String>? highlights;
  final String? perfectFor;

  Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.type,
    required this.pricePerNight,
    required this.rating,
    this.totalReviews = 0,
    this.roomType,
    required this.amenities,
    this.food,
    this.ambiance,
    required this.imageUrl,
    this.address,
    this.phone,
    required this.description,
    this.latitude,
    this.longitude,
    this.availability = true,
    this.googleRating,
    this.mapsUrl,
    this.photos,
    // AI fields
    this.aiMatchScore,
    this.whyRecommended,
    this.highlights,
    this.perfectFor,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      type: json['type'] ?? 'hotel',
      pricePerNight: (json['price_per_night'] ?? json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 4.0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      roomType: json['room_type'],
      amenities: List<String>.from(json['amenities'] ?? []),
      food: json['food'],
      ambiance: json['ambiance'],
      imageUrl: json['image_url'] ?? json['image'] ?? '',
      address: json['address'],
      phone: json['phone'],
      description: json['description'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      availability: json['availability'] ?? true,
      googleRating: json['google_rating']?.toString(),
      mapsUrl: json['maps_url'],
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
      // AI fields
      aiMatchScore: json['match_score'] ?? json['ai_match_score'],
      whyRecommended: json['why_recommended'],
      highlights: json['highlights'] != null
          ? List<String>.from(json['highlights'])
          : null,
      perfectFor: json['perfect_for'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'type': type,
      'price_per_night': pricePerNight,
      'rating': rating,
      'total_reviews': totalReviews,
      'room_type': roomType,
      'amenities': amenities,
      'food': food,
      'ambiance': ambiance,
      'image_url': imageUrl,
      'address': address,
      'phone': phone,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'availability': availability,
      'google_rating': googleRating,
      'maps_url': mapsUrl,
      'photos': photos,
      // AI fields
      'ai_match_score': aiMatchScore,
      'why_recommended': whyRecommended,
      'highlights': highlights,
      'perfect_for': perfectFor,
    };
  }
}
