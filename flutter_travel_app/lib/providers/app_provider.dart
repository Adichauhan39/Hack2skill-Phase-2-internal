import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  // User session
  String? _userId;
  String? _sessionId;

  // Search parameters
  String? _selectedCity;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guestCount = 1;


  // Filter parameters
  double _minPrice = 0;
  double _maxPrice = 50000;
  String? _hotelType;
  final List<String> _selectedAmenities = [];

  // Swipe state
  int _totalSwipes = 0;
  int _likesCount = 0;
  int _dislikesCount = 0;

  // Loading states
  bool _isLoading = false;
  String? _errorMessage;

  // Bottom navigation
  int _currentNavIndex = 0;

  // Getters
  String? get userId => _userId;
  String? get sessionId => _sessionId;
  String? get selectedCity => _selectedCity;
  DateTime? get checkInDate => _checkInDate;
  DateTime? get checkOutDate => _checkOutDate;
  int get guestCount => _guestCount;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  String? get hotelType => _hotelType;
  List<String> get selectedAmenities => _selectedAmenities;
  int get totalSwipes => _totalSwipes;
  int get likesCount => _likesCount;
  int get dislikesCount => _dislikesCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentNavIndex => _currentNavIndex;

  double get acceptanceRate =>
      _totalSwipes > 0 ? (_likesCount / _totalSwipes) * 100 : 0;

  // Setters
  void setUserId(String id) {
    _userId = id;
    notifyListeners();
  }

  void setSessionId(String id) {
    _sessionId = id;
    notifyListeners();
  }

  void setSelectedCity(String? city) {
    _selectedCity = city;
    notifyListeners();
  }

  void setCheckInDate(DateTime? date) {
    _checkInDate = date;
    notifyListeners();
  }

  void setCheckOutDate(DateTime? date) {
    _checkOutDate = date;
    notifyListeners();
  }

  void setGuestCount(int count) {
    _guestCount = count;
    notifyListeners();
  }

  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void setHotelType(String? type) {
    _hotelType = type;
    notifyListeners();
  }

  void toggleAmenity(String amenity) {
    if (_selectedAmenities.contains(amenity)) {
      _selectedAmenities.remove(amenity);
    } else {
      _selectedAmenities.add(amenity);
    }
    notifyListeners();
  }

  void recordSwipe(bool isLike) {
    _totalSwipes++;
    if (isLike) {
      _likesCount++;
    } else {
      _dislikesCount++;
    }
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  void resetFilters() {
    _minPrice = 0;
    _maxPrice = 50000;
    _hotelType = null;
    _selectedAmenities.clear();
    notifyListeners();
  }

  void resetSearchParams() {
    _selectedCity = null;
    _checkInDate = null;
    _checkOutDate = null;
    _guestCount = 1;
    notifyListeners();
  }
}
