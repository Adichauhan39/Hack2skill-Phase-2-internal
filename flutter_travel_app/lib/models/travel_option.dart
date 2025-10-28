class TravelOption {
  final String id;
  final String mode; // flight, train, taxi, bus, car_rental
  final String origin;
  final String destination;
  final DateTime departureTime;
  final DateTime? arrivalTime;
  final double price;
  final String className; // economy, business, first, ac, non-ac
  final String provider;
  final int duration; // in minutes
  final List<String> amenities;
  final bool availability;
  final String? seatNumber;
  final String? pnr;

  TravelOption({
    required this.id,
    required this.mode,
    required this.origin,
    required this.destination,
    required this.departureTime,
    this.arrivalTime,
    required this.price,
    required this.className,
    required this.provider,
    required this.duration,
    required this.amenities,
    this.availability = true,
    this.seatNumber,
    this.pnr,
  });

  factory TravelOption.fromJson(Map<String, dynamic> json) {
    return TravelOption(
      id: json['id']?.toString() ?? '',
      mode: json['mode'] ?? json['type'] ?? 'flight',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      departureTime: json['departure_time'] != null
          ? DateTime.parse(json['departure_time'])
          : DateTime.now(),
      arrivalTime: json['arrival_time'] != null
          ? DateTime.parse(json['arrival_time'])
          : null,
      price: (json['price'] ?? 0).toDouble(),
      className: json['class'] ?? json['class_name'] ?? 'economy',
      provider: json['provider'] ?? json['operator'] ?? '',
      duration: json['duration'] ?? 0,
      amenities: List<String>.from(json['amenities'] ?? []),
      availability: json['availability'] ?? true,
      seatNumber: json['seat_number'],
      pnr: json['pnr'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mode': mode,
      'origin': origin,
      'destination': destination,
      'departure_time': departureTime.toIso8601String(),
      'arrival_time': arrivalTime?.toIso8601String(),
      'price': price,
      'class': className,
      'provider': provider,
      'duration': duration,
      'amenities': amenities,
      'availability': availability,
      'seat_number': seatNumber,
      'pnr': pnr,
    };
  }

  String get formattedDuration {
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    return '${hours}h ${minutes}m';
  }

  String get modeIcon {
    switch (mode.toLowerCase()) {
      case 'flight':
        return '✈️';
      case 'train':
        return '🚆';
      case 'taxi':
      case 'car_rental':
        return '🚗';
      case 'bus':
        return '🚌';
      case 'bike':
      case 'scooter':
        return '🏍️';
      default:
        return '🚗';
    }
  }
}
