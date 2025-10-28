import '../models/hotel.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Mock hotels data based on the CSV structure
  final List<Hotel> _allHotels = [
    // Delhi Hotels
    Hotel(
      id: '1',
      name: 'The Leela Palace New Delhi',
      city: 'Delhi',
      type: 'Hotel',
      pricePerNight: 25000,
      rating: 4.9,
      totalReviews: 2500,
      roomType: 'Deluxe|Suite|Executive',
      amenities: ['WiFi', 'Parking', 'Pool', 'Gym', 'Spa', 'Airport Pickup'],
      food: 'Veg|Non-Veg|Continental|Indian|Buffet',
      ambiance: 'Luxury|Romantic',
      imageUrl:
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      address: 'Diplomatic Enclave, New Delhi',
      phone: '+91-11-39331234',
      description: 'Luxury hotel with world-class amenities',
      availability: true,
    ),
    Hotel(
      id: '2',
      name: 'ITC Maurya',
      city: 'Delhi',
      type: 'Hotel',
      pricePerNight: 18000,
      rating: 4.7,
      totalReviews: 1800,
      roomType: 'Double|Deluxe|Executive|Suite',
      amenities: ['WiFi', 'Parking', 'Gym', 'Pool', 'Airport Pickup'],
      food: 'Veg|Non-Veg|Continental|Indian|Chinese|Buffet',
      ambiance: 'Luxury|Modern',
      imageUrl:
          'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
      address: 'Sardar Patel Marg, New Delhi',
      phone: '+91-11-26112233',
      description: 'Luxury modern hotel with excellent service',
      availability: true,
    ),
    Hotel(
      id: '3',
      name: 'Zostel Delhi',
      city: 'Delhi',
      type: 'Hostel',
      pricePerNight: 800,
      rating: 4.2,
      totalReviews: 850,
      roomType: 'Dormitory|Double',
      amenities: ['WiFi', 'Common Kitchen', 'Lounge', 'Bike Rental'],
      food: 'Veg|Non-Veg|Indian',
      ambiance: 'Budget|Modern|Party',
      imageUrl:
          'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800',
      address: 'Hauz Khas, New Delhi',
      phone: '+91-11-42424242',
      description: 'Budget-friendly hostel for backpackers',
      availability: true,
    ),
    Hotel(
      id: '4',
      name: 'Hotel Shanti Palace',
      city: 'Delhi',
      type: 'Hotel',
      pricePerNight: 3500,
      rating: 4.0,
      totalReviews: 650,
      roomType: 'Single|Double|Family',
      amenities: ['WiFi', 'Parking', 'Room Service'],
      food: 'Veg|Non-Veg|Indian',
      ambiance: 'Budget|Traditional',
      imageUrl:
          'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
      address: 'Karol Bagh, New Delhi',
      phone: '+91-11-45678901',
      description: 'Comfortable budget hotel in Karol Bagh',
      availability: true,
    ),
    Hotel(
      id: '5',
      name: 'The Imperial',
      city: 'Delhi',
      type: 'Hotel',
      pricePerNight: 30000,
      rating: 4.9,
      totalReviews: 3200,
      roomType: 'Deluxe|Suite|View Room',
      amenities: ['WiFi', 'Parking', 'Pool', 'Spa', 'Gym', 'Event Hosting'],
      food: 'Veg|Non-Veg|Vegan|Continental|Indian|Mediterranean',
      ambiance: 'Luxury|Traditional|Romantic',
      imageUrl:
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
      address: 'Janpath, New Delhi',
      phone: '+91-11-23341234',
      description: 'Historic luxury hotel with traditional charm',
      availability: true,
    ),

    // Mumbai Hotels
    Hotel(
      id: '6',
      name: 'The Taj Mahal Palace',
      city: 'Mumbai',
      type: 'Hotel',
      pricePerNight: 35000,
      rating: 4.9,
      totalReviews: 4500,
      roomType: 'Deluxe|Suite|View Room|Executive',
      amenities: ['WiFi', 'Parking', 'Pool', 'Spa', 'Gym', 'Sea View'],
      food: 'Veg|Non-Veg|Continental|Indian|Chinese|Mediterranean',
      ambiance: 'Luxury|Romantic|Traditional',
      imageUrl:
          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
      address: 'Apollo Bunder, Mumbai',
      phone: '+91-22-66653366',
      description: 'Iconic luxury hotel with sea view',
      availability: true,
    ),
    Hotel(
      id: '7',
      name: 'The Oberoi Mumbai',
      city: 'Mumbai',
      type: 'Hotel',
      pricePerNight: 28000,
      rating: 4.8,
      totalReviews: 2800,
      roomType: 'Double|Deluxe|Suite|View Room',
      amenities: ['WiFi', 'Parking', 'Pool', 'Gym', 'Spa', 'Airport Pickup'],
      food: 'Veg|Non-Veg|Continental|Indian|Buffet',
      ambiance: 'Luxury|Modern|Romantic',
      imageUrl:
          'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800',
      address: 'Nariman Point, Mumbai',
      phone: '+91-22-66325757',
      description: 'Modern luxury hotel with stunning views',
      availability: true,
    ),
    Hotel(
      id: '8',
      name: 'Backpacker Panda',
      city: 'Mumbai',
      type: 'Hostel',
      pricePerNight: 1000,
      rating: 4.3,
      totalReviews: 920,
      roomType: 'Dormitory|Double',
      amenities: ['WiFi', 'Common Area', 'Rooftop'],
      food: 'Veg|Non-Veg|Continental',
      ambiance: 'Budget|Modern|Party',
      imageUrl:
          'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800',
      address: 'Andheri, Mumbai',
      phone: '+91-22-26267777',
      description: 'Budget hostel with rooftop views',
      availability: true,
    ),
    Hotel(
      id: '9',
      name: 'Hotel Suba Palace',
      city: 'Mumbai',
      type: 'Hotel',
      pricePerNight: 5000,
      rating: 4.1,
      totalReviews: 780,
      roomType: 'Single|Double|Deluxe',
      amenities: ['WiFi', 'Parking', 'Restaurant'],
      food: 'Veg|Non-Veg|Indian',
      ambiance: 'Budget|Traditional',
      imageUrl:
          'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
      address: 'Apollo Bunder, Mumbai',
      phone: '+91-22-22840011',
      description: 'Affordable hotel near Gateway of India',
      availability: true,
    ),

    // Goa Hotels
    Hotel(
      id: '10',
      name: 'Taj Exotica Resort & Spa',
      city: 'Goa',
      type: 'Resort',
      pricePerNight: 22000,
      rating: 4.8,
      totalReviews: 3100,
      roomType: 'Deluxe|Suite|Villa',
      amenities: ['WiFi', 'Beach Access', 'Pool', 'Spa', 'Gym', 'Water Sports'],
      food: 'Veg|Non-Veg|Continental|Indian|Seafood',
      ambiance: 'Luxury|Beach|Romantic',
      imageUrl:
          'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
      address: 'Benaulim, South Goa',
      phone: '+91-832-6683333',
      description: 'Luxury beach resort with water sports',
      availability: true,
    ),
    Hotel(
      id: '11',
      name: 'Alila Diwa Goa',
      city: 'Goa',
      type: 'Resort',
      pricePerNight: 15000,
      rating: 4.7,
      totalReviews: 1950,
      roomType: 'Deluxe|Suite|Terrace Room',
      amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant', 'Beach Shuttle'],
      food: 'Veg|Non-Veg|Continental|Indian|Asian',
      ambiance: 'Luxury|Modern|Peaceful',
      imageUrl:
          'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=800',
      address: 'Majorda, South Goa',
      phone: '+91-832-2746800',
      description: 'Contemporary resort with excellent service',
      availability: true,
    ),
    Hotel(
      id: '12',
      name: 'Zostel Goa',
      city: 'Goa',
      type: 'Hostel',
      pricePerNight: 600,
      rating: 4.4,
      totalReviews: 1150,
      roomType: 'Dormitory|Double',
      amenities: ['WiFi', 'Common Area', 'Beach Access', 'Bike Rental'],
      food: 'Veg|Non-Veg|Continental|Indian',
      ambiance: 'Budget|Beach|Party',
      imageUrl:
          'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800',
      address: 'Anjuna, North Goa',
      phone: '+91-832-2274242',
      description: 'Beach hostel perfect for backpackers',
      availability: true,
    ),
    Hotel(
      id: '13',
      name: 'Beach Box Goa',
      city: 'Goa',
      type: 'Hotel',
      pricePerNight: 3000,
      rating: 4.2,
      totalReviews: 550,
      roomType: 'Single|Double|Sea View',
      amenities: ['WiFi', 'Beach Access', 'Restaurant'],
      food: 'Veg|Non-Veg|Seafood|Continental',
      ambiance: 'Budget|Beach|Casual',
      imageUrl:
          'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
      address: 'Calangute, North Goa',
      phone: '+91-832-2279999',
      description: 'Budget beach hotel with great location',
      availability: true,
    ),

    // Bangalore Hotels
    Hotel(
      id: '14',
      name: 'ITC Gardenia',
      city: 'Bangalore',
      type: 'Hotel',
      pricePerNight: 16000,
      rating: 4.7,
      totalReviews: 2200,
      roomType: 'Deluxe|Suite|Executive',
      amenities: ['WiFi', 'Parking', 'Pool', 'Gym', 'Spa', 'Restaurant'],
      food: 'Veg|Non-Veg|Continental|Indian|Chinese',
      ambiance: 'Luxury|Business',
      imageUrl:
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      address: 'Residency Road, Bangalore',
      phone: '+91-80-49992233',
      description: 'Luxury hotel in the heart of the city',
      availability: true,
    ),
    Hotel(
      id: '15',
      name: 'The Oberoi Bangalore',
      city: 'Bangalore',
      type: 'Hotel',
      pricePerNight: 18000,
      rating: 4.8,
      totalReviews: 1900,
      roomType: 'Deluxe|Premier|Suite',
      amenities: ['WiFi', 'Parking', 'Pool', 'Gym', 'Spa'],
      food: 'Veg|Non-Veg|Continental|Indian|Japanese',
      ambiance: 'Luxury|Modern|Garden',
      imageUrl:
          'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800',
      address: 'MG Road, Bangalore',
      phone: '+91-80-25585858',
      description: 'Modern luxury hotel with gardens',
      availability: true,
    ),
    Hotel(
      id: '16',
      name: 'Zostel Bangalore',
      city: 'Bangalore',
      type: 'Hostel',
      pricePerNight: 700,
      rating: 4.3,
      totalReviews: 950,
      roomType: 'Dormitory|Private',
      amenities: ['WiFi', 'Common Area', 'Rooftop', 'Cafe'],
      food: 'Veg|Non-Veg|Continental',
      ambiance: 'Budget|Social|Modern',
      imageUrl:
          'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800',
      address: 'Indiranagar, Bangalore',
      phone: '+91-80-41314242',
      description: 'Social hostel for young travelers',
      availability: true,
    ),

    // Jaipur Hotels
    Hotel(
      id: '17',
      name: 'The Oberoi Rajvilas',
      city: 'Jaipur',
      type: 'Resort',
      pricePerNight: 32000,
      rating: 4.9,
      totalReviews: 2750,
      roomType: 'Premier Room|Royal Tent|Villa',
      amenities: ['WiFi', 'Pool', 'Spa', 'Gym', 'Cultural Programs'],
      food: 'Veg|Non-Veg|Continental|Indian|Rajasthani',
      ambiance: 'Luxury|Royal|Traditional',
      imageUrl:
          'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
      address: 'Goner Road, Jaipur',
      phone: '+91-141-26803939',
      description: 'Royal resort with traditional architecture',
      availability: true,
    ),
    Hotel(
      id: '18',
      name: 'Rambagh Palace',
      city: 'Jaipur',
      type: 'Hotel',
      pricePerNight: 40000,
      rating: 4.9,
      totalReviews: 3400,
      roomType: 'Palace Room|Royal Suite|Grand Presidential Suite',
      amenities: ['WiFi', 'Pool', 'Spa', 'Gym', 'Heritage Tours'],
      food: 'Veg|Non-Veg|Continental|Indian|Rajasthani|Royal Cuisine',
      ambiance: 'Luxury|Palace|Royal',
      imageUrl:
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
      address: 'Bhawani Singh Road, Jaipur',
      phone: '+91-141-22211919',
      description: 'Former palace converted to luxury hotel',
      availability: true,
    ),
    Hotel(
      id: '19',
      name: 'Zostel Jaipur',
      city: 'Jaipur',
      type: 'Hostel',
      pricePerNight: 650,
      rating: 4.2,
      totalReviews: 820,
      roomType: 'Dormitory|Private',
      amenities: ['WiFi', 'Common Area', 'Rooftop', 'City Tours'],
      food: 'Veg|Non-Veg|Indian|Continental',
      ambiance: 'Budget|Cultural|Social',
      imageUrl:
          'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800',
      address: 'MI Road, Jaipur',
      phone: '+91-141-40642424',
      description: 'Budget hostel with cultural activities',
      availability: true,
    ),

    // Kolkata Hotels
    Hotel(
      id: '20',
      name: 'ITC Sonar',
      city: 'Kolkata',
      type: 'Hotel',
      pricePerNight: 14000,
      rating: 4.6,
      totalReviews: 1650,
      roomType: 'Deluxe|Executive|Suite',
      amenities: ['WiFi', 'Parking', 'Pool', 'Gym', 'Spa'],
      food: 'Veg|Non-Veg|Continental|Indian|Chinese|Bengali',
      ambiance: 'Luxury|Modern',
      imageUrl:
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      address: 'JBS Haldane Avenue, Kolkata',
      phone: '+91-33-23451234',
      description: 'Luxury hotel near airport',
      availability: true,
    ),
    Hotel(
      id: '21',
      name: 'The Oberoi Grand',
      city: 'Kolkata',
      type: 'Hotel',
      pricePerNight: 15000,
      rating: 4.7,
      totalReviews: 1890,
      roomType: 'Luxury|Premier|Grand Suite',
      amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant', 'Heritage'],
      food: 'Veg|Non-Veg|Continental|Indian|Bengali|International',
      ambiance: 'Luxury|Colonial|Heritage',
      imageUrl:
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
      address: 'Jawaharlal Nehru Road, Kolkata',
      phone: '+91-33-22492323',
      description: 'Historic colonial hotel',
      availability: true,
    ),

    // Chennai Hotels
    Hotel(
      id: '22',
      name: 'ITC Grand Chola',
      city: 'Chennai',
      type: 'Hotel',
      pricePerNight: 17000,
      rating: 4.7,
      totalReviews: 2100,
      roomType: 'Deluxe|Club|Suite',
      amenities: ['WiFi', 'Parking', 'Pool', 'Gym', 'Spa', 'Restaurant'],
      food: 'Veg|Non-Veg|Continental|Indian|South Indian|Chinese',
      ambiance: 'Luxury|Grand|Traditional',
      imageUrl:
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      address: 'Mount Road, Chennai',
      phone: '+91-44-22202020',
      description: 'Grand luxury hotel with excellent dining',
      availability: true,
    ),
    Hotel(
      id: '23',
      name: 'Taj Coromandel',
      city: 'Chennai',
      type: 'Hotel',
      pricePerNight: 16000,
      rating: 4.6,
      totalReviews: 1780,
      roomType: 'Superior|Deluxe|Suite',
      amenities: ['WiFi', 'Parking', 'Pool', 'Gym', 'Restaurant'],
      food: 'Veg|Non-Veg|Continental|Indian|South Indian',
      ambiance: 'Luxury|Business|Modern',
      imageUrl:
          'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
      address: 'Nungambakkam, Chennai',
      phone: '+91-44-66003030',
      description: 'Central business hotel with modern amenities',
      availability: true,
    ),

    // Hyderabad Hotels
    Hotel(
      id: '24',
      name: 'ITC Kohenur',
      city: 'Hyderabad',
      type: 'Hotel',
      pricePerNight: 15000,
      rating: 4.7,
      totalReviews: 1950,
      roomType: 'Deluxe|Executive|Suite',
      amenities: ['WiFi', 'Parking', 'Pool', 'Gym', 'Spa'],
      food: 'Veg|Non-Veg|Continental|Indian|Hyderabadi',
      ambiance: 'Luxury|Contemporary',
      imageUrl:
          'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800',
      address: 'HITEC City, Hyderabad',
      phone: '+91-40-44444444',
      description: 'Contemporary luxury hotel',
      availability: true,
    ),
    Hotel(
      id: '25',
      name: 'Taj Falaknuma Palace',
      city: 'Hyderabad',
      type: 'Hotel',
      pricePerNight: 45000,
      rating: 4.9,
      totalReviews: 2900,
      roomType: 'Deluxe|Grand Presidential|Royal Suite',
      amenities: [
        'WiFi',
        'Pool',
        'Spa',
        'Gym',
        'Heritage Tours',
        'Butler Service'
      ],
      food: 'Veg|Non-Veg|Continental|Indian|Hyderabadi|Royal Cuisine',
      ambiance: 'Luxury|Palace|Royal',
      imageUrl:
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
      address: 'Falaknuma, Hyderabad',
      phone: '+91-40-66298585',
      description: 'Palatial hotel with royal experience',
      availability: true,
    ),
  ];

  // Search hotels with filters
  Future<List<Hotel>> searchHotels({
    required String city,
    double? minPrice,
    double? maxPrice,
    String? type,
    List<String>? amenities,
    String? aiPrompt,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var results = _allHotels.where((hotel) {
      // Filter by city (case-insensitive)
      if (hotel.city.toLowerCase() != city.toLowerCase()) return false;

      // Filter by price range
      if (minPrice != null && hotel.pricePerNight < minPrice) return false;
      if (maxPrice != null && hotel.pricePerNight > maxPrice) return false;

      // Filter by type
      if (type != null &&
          type.isNotEmpty &&
          hotel.type.toLowerCase() != type.toLowerCase()) {
        return false;
      }

      // Filter by amenities (hotel must have all requested amenities)
      if (amenities != null && amenities.isNotEmpty) {
        for (var amenity in amenities) {
          if (!hotel.amenities
              .any((a) => a.toLowerCase().contains(amenity.toLowerCase()))) {
            return false;
          }
        }
      }

      return true;
    }).toList();

    // Apply AI-based smart filtering
    if (aiPrompt != null && aiPrompt.isNotEmpty) {
      results = _applyAIFiltering(results, aiPrompt);
    }

    // Sort by rating (highest first)
    results.sort((a, b) => b.rating.compareTo(a.rating));

    return results;
  }

  // Smart AI-based filtering based on natural language prompt
  List<Hotel> _applyAIFiltering(List<Hotel> hotels, String prompt) {
    final lowerPrompt = prompt.toLowerCase();

    // Score each hotel based on how well it matches the prompt
    final scoredHotels = hotels.map((hotel) {
      double score = 0.0;

      // Keywords for different preferences

      // Budget preferences
      if (lowerPrompt.contains('budget') ||
          lowerPrompt.contains('cheap') ||
          lowerPrompt.contains('affordable') ||
          lowerPrompt.contains('economical')) {
        if (hotel.pricePerNight < 5000) {
          score += 10;
        } else if (hotel.pricePerNight < 10000) score += 5;
      }

      // Luxury preferences
      if (lowerPrompt.contains('luxury') ||
          lowerPrompt.contains('premium') ||
          lowerPrompt.contains('5 star') ||
          lowerPrompt.contains('expensive') ||
          lowerPrompt.contains('high-end') ||
          lowerPrompt.contains('deluxe')) {
        if (hotel.pricePerNight > 20000) {
          score += 10;
        } else if (hotel.pricePerNight > 15000) score += 5;
        if (hotel.ambiance?.toLowerCase().contains('luxury') ?? false) {
          score += 5;
        }
      }

      // Location preferences
      if (lowerPrompt.contains('beach') || lowerPrompt.contains('sea')) {
        if (hotel.amenities.any((a) =>
            a.toLowerCase().contains('beach') ||
            a.toLowerCase().contains('sea'))) {
          score += 15;
        }
      }

      if (lowerPrompt.contains('city center') ||
          lowerPrompt.contains('downtown') ||
          lowerPrompt.contains('central')) {
        if ((hotel.address?.toLowerCase().contains('central') ?? false) ||
            (hotel.address?.toLowerCase().contains('mg road') ?? false) ||
            (hotel.address?.toLowerCase().contains('connaught') ?? false)) {
          score += 10;
        }
      }

      // Ambiance preferences
      if (lowerPrompt.contains('romantic') ||
          lowerPrompt.contains('honeymoon') ||
          lowerPrompt.contains('couple')) {
        if (hotel.ambiance?.toLowerCase().contains('romantic') ?? false) {
          score += 15;
        }
        if (hotel.amenities.any((a) => a.toLowerCase().contains('spa'))) {
          score += 5;
        }
      }

      if (lowerPrompt.contains('party') ||
          lowerPrompt.contains('nightlife') ||
          lowerPrompt.contains('social')) {
        if (hotel.ambiance?.toLowerCase().contains('party') ?? false) {
          score += 15;
        }
        if (hotel.type.toLowerCase() == 'hostel') score += 5;
      }

      if (lowerPrompt.contains('quiet') ||
          lowerPrompt.contains('peaceful') ||
          lowerPrompt.contains('relaxing')) {
        if ((hotel.ambiance?.toLowerCase().contains('peaceful') ?? false) ||
            (hotel.ambiance?.toLowerCase().contains('traditional') ?? false)) {
          score += 10;
        }
        if (hotel.type.toLowerCase() == 'resort') score += 5;
      }

      // Specific amenities
      if (lowerPrompt.contains('pool') || lowerPrompt.contains('swimming')) {
        if (hotel.amenities.any((a) => a.toLowerCase().contains('pool'))) {
          score += 10;
        }
      }

      if (lowerPrompt.contains('spa') || lowerPrompt.contains('massage')) {
        if (hotel.amenities.any((a) => a.toLowerCase().contains('spa'))) {
          score += 10;
        }
      }

      if (lowerPrompt.contains('gym') || lowerPrompt.contains('fitness')) {
        if (hotel.amenities.any((a) => a.toLowerCase().contains('gym'))) {
          score += 10;
        }
      }

      if (lowerPrompt.contains('wifi') || lowerPrompt.contains('internet')) {
        if (hotel.amenities.any((a) => a.toLowerCase().contains('wifi'))) {
          score += 5;
        }
      }

      if (lowerPrompt.contains('parking') || lowerPrompt.contains('car')) {
        if (hotel.amenities.any((a) => a.toLowerCase().contains('parking'))) {
          score += 8;
        }
      }

      if (lowerPrompt.contains('restaurant') ||
          lowerPrompt.contains('dining') ||
          lowerPrompt.contains('breakfast')) {
        if (hotel.amenities
                .any((a) => a.toLowerCase().contains('restaurant')) ||
            (hotel.food?.toLowerCase().contains('buffet') ?? false)) {
          score += 8;
        }
      }

      // Food preferences
      if (lowerPrompt.contains('vegetarian') ||
          lowerPrompt.contains('veg only')) {
        if (hotel.food?.toLowerCase().contains('veg') ?? false) score += 10;
      }

      if (lowerPrompt.contains('seafood') || lowerPrompt.contains('coastal')) {
        if (hotel.food?.toLowerCase().contains('seafood') ?? false) score += 10;
      }

      // Business travel
      if (lowerPrompt.contains('business') ||
          lowerPrompt.contains('work') ||
          lowerPrompt.contains('conference')) {
        if (hotel.ambiance?.toLowerCase().contains('business') ?? false) {
          score += 10;
        }
        if (hotel.amenities.any((a) => a.toLowerCase().contains('wifi'))) {
          score += 5;
        }
        if (hotel.amenities.any((a) => a.toLowerCase().contains('event'))) {
          score += 5;
        }
      }

      // Family travel
      if (lowerPrompt.contains('family') ||
          lowerPrompt.contains('kids') ||
          lowerPrompt.contains('children')) {
        if (hotel.roomType?.toLowerCase().contains('family') ?? false) {
          score += 10;
        }
        if (hotel.pricePerNight > 5000 && hotel.pricePerNight < 20000) {
          score += 5;
        }
      }

      // Backpackers/Solo travelers
      if (lowerPrompt.contains('backpack') ||
          lowerPrompt.contains('hostel') ||
          lowerPrompt.contains('solo')) {
        if (hotel.type.toLowerCase() == 'hostel') score += 15;
        if (hotel.pricePerNight < 2000) score += 5;
      }

      // Heritage/Cultural
      if (lowerPrompt.contains('heritage') ||
          lowerPrompt.contains('palace') ||
          lowerPrompt.contains('traditional') ||
          lowerPrompt.contains('cultural')) {
        if ((hotel.ambiance?.toLowerCase().contains('traditional') ?? false) ||
            (hotel.ambiance?.toLowerCase().contains('heritage') ?? false) ||
            (hotel.ambiance?.toLowerCase().contains('royal') ?? false) ||
            (hotel.ambiance?.toLowerCase().contains('palace') ?? false)) {
          score += 15;
        }
      }

      // Near airport
      if (lowerPrompt.contains('airport') ||
          lowerPrompt.contains('early flight') ||
          lowerPrompt.contains('late arrival')) {
        if (hotel.amenities.any((a) => a.toLowerCase().contains('airport'))) {
          score += 15;
        }
      }

      // Pet friendly
      if (lowerPrompt.contains('pet') ||
          lowerPrompt.contains('dog') ||
          lowerPrompt.contains('cat')) {
        // In real implementation, you'd have a pet-friendly flag
        if (hotel.type.toLowerCase() == 'resort' ||
            hotel.type.toLowerCase() == 'hotel') {
          score += 5;
        }
      }

      // View preferences
      if (lowerPrompt.contains('view') || lowerPrompt.contains('scenic')) {
        if (hotel.roomType?.toLowerCase().contains('view') ?? false) {
          score += 10;
        }
        if (hotel.amenities.any((a) => a.toLowerCase().contains('view'))) {
          score += 5;
        }
      }

      // High rating preference
      if (lowerPrompt.contains('best') ||
          lowerPrompt.contains('top rated') ||
          lowerPrompt.contains('highly rated')) {
        if (hotel.rating >= 4.7) {
          score += 10;
        } else if (hotel.rating >= 4.5) score += 5;
      }

      return MapEntry(hotel, score);
    }).toList();

    // Filter out hotels with score 0 (no match)
    final filteredHotels =
        scoredHotels.where((entry) => entry.value > 0).toList();

    // If we have matches, return them sorted by score
    if (filteredHotels.isNotEmpty) {
      filteredHotels.sort((a, b) => b.value.compareTo(a.value));
      return filteredHotels.map((entry) => entry.key).toList();
    }

    // If no AI matches found, return all results
    return hotels;
  }

  // Generate AI response message based on prompt
  String generateAIResponse(String prompt, int resultCount) {
    final lowerPrompt = prompt.toLowerCase();

    if (resultCount == 0) {
      return "I couldn't find hotels matching your specific requirements. Try adjusting your filters or prompt.";
    }

    String response = "Found $resultCount hotel${resultCount > 1 ? 's' : ''} ";

    if (lowerPrompt.contains('budget') || lowerPrompt.contains('cheap')) {
      response += "with affordable prices ";
    } else if (lowerPrompt.contains('luxury') ||
        lowerPrompt.contains('premium')) {
      response += "with luxury amenities ";
    }

    if (lowerPrompt.contains('beach')) {
      response += "near the beach ";
    }

    if (lowerPrompt.contains('romantic') || lowerPrompt.contains('honeymoon')) {
      response += "perfect for couples ";
    }

    if (lowerPrompt.contains('business') || lowerPrompt.contains('work')) {
      response += "suitable for business travelers ";
    }

    if (lowerPrompt.contains('family')) {
      response += "great for families ";
    }

    response += "that match your preferences!";

    return response;
  }

  // Get all hotels for a city
  Future<List<Hotel>> getHotelsByCity(String city) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _allHotels
        .where((hotel) => hotel.city.toLowerCase() == city.toLowerCase())
        .toList();
  }

  // Get hotel by ID
  Hotel? getHotelById(String id) {
    try {
      return _allHotels.firstWhere((hotel) => hotel.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get personalized recommendations based on learned preferences
  Future<List<Hotel>> getRecommendations({
    required Map<String, dynamic> preferences,
    required List<String> excludeIds,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (preferences.isEmpty) {
      // No preferences yet, return random hotels
      return _allHotels
          .where((hotel) => !excludeIds.contains(hotel.id))
          .take(limit)
          .toList();
    }

    // Score each hotel based on learned preferences
    final scoredHotels = <Map<String, dynamic>>[];

    for (var hotel in _allHotels) {
      if (excludeIds.contains(hotel.id)) continue;

      double score = 0;

      // Price similarity (30% weight)
      if (preferences.containsKey('avgPrice')) {
        final avgPrice = preferences['avgPrice'] as double;
        final priceDiff = (hotel.pricePerNight - avgPrice).abs();
        final priceScore = 100 - (priceDiff / avgPrice * 100).clamp(0, 100);
        score += priceScore * 0.3;
      }

      // Type matching (25% weight)
      if (preferences.containsKey('preferredTypes')) {
        final preferredTypes =
            (preferences['preferredTypes'] as List).cast<String>();
        if (preferredTypes.contains(hotel.type)) {
          score += 25;
        }
      }

      // Amenity matching (25% weight)
      if (preferences.containsKey('preferredAmenities')) {
        final preferredAmenities =
            (preferences['preferredAmenities'] as List).cast<String>();
        int matchingAmenities = 0;
        for (var amenity in preferredAmenities) {
          if (hotel.amenities.contains(amenity)) {
            matchingAmenities++;
          }
        }
        if (preferredAmenities.isNotEmpty) {
          score += (matchingAmenities / preferredAmenities.length) * 25;
        }
      }

      // Rating threshold (20% weight)
      if (preferences.containsKey('minRating')) {
        final minRating = preferences['minRating'] as double;
        if (hotel.rating >= minRating) {
          score += 20;
        } else {
          score += (hotel.rating / minRating) * 20;
        }
      }

      scoredHotels.add({
        'hotel': hotel,
        'score': score,
      });
    }

    // Sort by score and return top results
    scoredHotels
        .sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));

    return scoredHotels
        .take(limit)
        .map((item) => item['hotel'] as Hotel)
        .toList();
  }

  /// AI-powered hotel search using Gemini scoring
  /// Takes AI-generated scores and recommendations from Gemini service
  Future<List<Hotel>> searchHotelsWithAI({
    required String city,
    double? minPrice,
    double? maxPrice,
    Map<String, dynamic>? aiCriteria,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // First, filter by basic criteria
    var results = _allHotels.where((hotel) {
      if (hotel.city.toLowerCase() != city.toLowerCase()) return false;
      if (minPrice != null && hotel.pricePerNight < minPrice) return false;
      if (maxPrice != null && hotel.pricePerNight > maxPrice) return false;
      return true;
    }).toList();

    // If AI criteria available, use AI scoring
    if (aiCriteria != null && aiCriteria['aiPowered'] == true) {
      final hotelScores = aiCriteria['hotelScores'] as List<dynamic>? ?? [];
      final recommendations =
          aiCriteria['recommendations'] as List<dynamic>? ?? [];

      // Create a map of hotel scores
      final scoreMap = <String, double>{};
      for (var scoreData in hotelScores) {
        scoreMap[scoreData['hotelId']] = (scoreData['score'] as num).toDouble();
      }

      // Score and sort hotels
      results = results.map((hotel) {
        return hotel;
      }).toList();

      // Sort by AI recommendations first, then by score
      results.sort((a, b) {
        final aIndex = recommendations.indexOf(a.id);
        final bIndex = recommendations.indexOf(b.id);

        // If both in recommendations, sort by recommendation order
        if (aIndex != -1 && bIndex != -1) {
          return aIndex.compareTo(bIndex);
        }

        // If only one in recommendations, prioritize it
        if (aIndex != -1) return -1;
        if (bIndex != -1) return 1;

        // Otherwise, sort by AI score
        final aScore = scoreMap[a.id] ?? 0;
        final bScore = scoreMap[b.id] ?? 0;
        return bScore.compareTo(aScore);
      });

      // Apply must-have filters
      final mustHave = aiCriteria['mustHave'] as List<dynamic>? ?? [];
      if (mustHave.isNotEmpty) {
        results = results.where((hotel) {
          for (var requirement in mustHave) {
            final req = requirement.toString().toLowerCase();
            // Check in amenities
            if (!hotel.amenities.any((a) => a.toLowerCase().contains(req)) &&
                !(hotel.ambiance?.toLowerCase().contains(req) ?? false) &&
                !(hotel.food?.toLowerCase().contains(req) ?? false)) {
              return false;
            }
          }
          return true;
        }).toList();
      }
    } else {
      // Fallback to rating-based sorting
      results.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return results;
  }

  /// Get all hotels for a specific city (for AI analysis)
  List<Hotel> getAllHotelsInCity(String city) {
    return _allHotels
        .where((hotel) => hotel.city.toLowerCase() == city.toLowerCase())
        .toList();
  }
}
