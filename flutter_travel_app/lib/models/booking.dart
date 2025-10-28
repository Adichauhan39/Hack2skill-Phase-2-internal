class Booking {
  final String id;
  final String type; // hotel, travel
  final String userId;
  final DateTime bookingDate;
  final DateTime checkInDate;
  final DateTime? checkOutDate;
  final double totalPrice;
  final String status; // confirmed, pending, cancelled
  final Map<String, dynamic> details;
  final String? qrCode;
  final String? pnr;

  // Calendar integration
  final bool addedToCalendar;
  final String? calendarEventId;

  Booking({
    required this.id,
    required this.type,
    required this.userId,
    required this.bookingDate,
    required this.checkInDate,
    this.checkOutDate,
    required this.totalPrice,
    required this.status,
    required this.details,
    this.qrCode,
    this.pnr,
    this.addedToCalendar = false,
    this.calendarEventId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? '',
      userId: json['user_id']?.toString() ?? '',
      bookingDate: json['booking_date'] != null
          ? DateTime.parse(json['booking_date'])
          : DateTime.now(),
      checkInDate: json['check_in_date'] != null
          ? DateTime.parse(json['check_in_date'])
          : DateTime.now(),
      checkOutDate: json['check_out_date'] != null
          ? DateTime.parse(json['check_out_date'])
          : null,
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      details: Map<String, dynamic>.from(json['details'] ?? {}),
      qrCode: json['qr_code'],
      pnr: json['pnr'],
      addedToCalendar: json['added_to_calendar'] ?? false,
      calendarEventId: json['calendar_event_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'user_id': userId,
      'booking_date': bookingDate.toIso8601String(),
      'check_in_date': checkInDate.toIso8601String(),
      'check_out_date': checkOutDate?.toIso8601String(),
      'total_price': totalPrice,
      'status': status,
      'details': details,
      'qr_code': qrCode,
      'pnr': pnr,
      'added_to_calendar': addedToCalendar,
      'calendar_event_id': calendarEventId,
    };
  }

  bool get isActive {
    return status == 'confirmed' && checkInDate.isAfter(DateTime.now());
  }

  bool get isPast {
    return checkOutDate != null && checkOutDate!.isBefore(DateTime.now());
  }

  // Helper properties for bookings screen
  String get bookingId => id;

  String get hotelName {
    // Extract hotel name from details or return a default
    if (type == 'hotel') {
      return details['hotel_name']?.toString() ??
          details['name']?.toString() ??
          'Hotel Booking';
    }
    return details['name']?.toString() ?? 'Travel Booking';
  }
}

class BudgetTracker {
  final double totalBudget;
  final double spent;
  final Map<String, double> categorySpending;
  final List<Expense> expenses;

  BudgetTracker({
    required this.totalBudget,
    required this.spent,
    required this.categorySpending,
    required this.expenses,
  });

  double get remaining => totalBudget - spent;
  double get percentageUsed => (spent / totalBudget) * 100;

  factory BudgetTracker.fromJson(Map<String, dynamic> json) {
    return BudgetTracker(
      totalBudget: (json['total_budget'] ?? 0).toDouble(),
      spent: (json['spent'] ?? 0).toDouble(),
      categorySpending: Map<String, double>.from(
        json['category_spending']?.map((k, v) => MapEntry(k, v.toDouble())) ??
            {},
      ),
      expenses: (json['expenses'] as List?)
              ?.map((e) => Expense.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Expense {
  final String id;
  final String category;
  final double amount;
  final String description;
  final DateTime date;

  Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id']?.toString() ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }
}
