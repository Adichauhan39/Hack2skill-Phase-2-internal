import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../config/app_config.dart';
// import '../services/gemini_service.dart';
// import '../services/gemini_agent_manager.dart';
// import '../services/mock_data_service.dart';
import '../services/python_adk_service.dart';
import 'swipe_screen.dart';
import 'hotel_swipe_screen.dart';
import 'bookings_screen.dart';
import 'tinder_hotel_swipe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const SwipeScreen(),
    const BookingsScreen(),
    const BudgetTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppConfig.primaryColor,
        unselectedItemColor: AppConfig.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swipe_outlined),
            activeIcon: Icon(Icons.swipe),
            label: 'Swipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // Search results
  List<Map<String, dynamic>> _searchResults = [];
  bool _hasSearched = false;

  void updateSearchResults(List<Map<String, dynamic>> results) {
    setState(() {
      _searchResults = results;
      _hasSearched = true;
    });
  }

  void clearSearchResults() {
    setState(() {
      _searchResults = [];
      _hasSearched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppConfig.primaryGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConfig.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Welcome to',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'AI Travel Booking',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Where would you like to go?',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConfig.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Section
                  const SizedBox(height: 8),
                  _SearchSection(),

                  const SizedBox(height: 24),

                  // Search Results Section (if available)
                  if (_hasSearched && _searchResults.isNotEmpty) ...[
                    const _SearchResultsSection(),
                    const SizedBox(height: 24),
                  ],

                  // Quick Actions
                  _QuickActions(),

                  const SizedBox(height: 24),

                  // Popular Destinations
                  _PopularDestinations(),

                  const SizedBox(height: 24),

                  // Features Section
                  _FeaturesSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchSection extends StatefulWidget {
  @override
  State<_SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<_SearchSection> {
  int _selectedTabIndex = 0;

  // Controllers for text fields
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _specialRequestController =
      TextEditingController();

  DateTime _checkInDate = DateTime.now();
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 1));
  int _guests = 2;
  int _rooms = 1;

  // Hotel-specific preferences
  double _hotelBudget = 5000;
  String? _selectedRoomType;
  final List<String> _selectedFoodTypes = [];
  String? _selectedAmbiance;
  final List<String> _selectedExtras = [];

  // Flight-specific preferences
  final double _flightBudget = 10000;
  String? _flightClass;
  final List<String> _flightPreferences = [];

  // Destination-specific preferences
  final double _destinationBudget = 20000;
  final List<String> _destinationTypes = [];
  final List<String> _destinationActivities = [];

  // AI Service - Using Python ADK Backend Only
  // final GeminiService _geminiService = GeminiService();
  // final GeminiAgentManager _agentManager = GeminiAgentManager();
  // final MockDataService _mockDataService = MockDataService();
  final PythonADKService _pythonADK = PythonADKService();
  bool _isSearching = false;
  final bool _usePythonBackend =
      true; // Toggle to switch between direct Gemini and Python ADK

  @override
  void dispose() {
    _cityController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _specialRequestController.dispose();
    super.dispose();
  }

  /// Builds a natural language request for the AI Manager
  String _buildUserRequestMessage() {
    final parts = <String>[];

    // Base request
    parts.add('Find hotels in ${_toController.text}');

    // Budget
    parts.add('under ₹${_hotelBudget.toStringAsFixed(0)}');

    // Room type
    if (_selectedRoomType != null && _selectedRoomType!.isNotEmpty) {
      parts.add('with $_selectedRoomType room');
    }

    // Food preferences
    if (_selectedFoodTypes.isNotEmpty) {
      parts.add('serving ${_selectedFoodTypes.join(", ")}');
    }

    // Ambiance
    if (_selectedAmbiance != null && _selectedAmbiance!.isNotEmpty) {
      parts.add('with $_selectedAmbiance ambiance');
    }

    // Extras/Amenities
    if (_selectedExtras.isNotEmpty) {
      parts.add('with ${_selectedExtras.join(", ")}');
    }

    // Special request (most important - user's natural language)
    if (_specialRequestController.text.isNotEmpty) {
      parts.add('Special request: ${_specialRequestController.text}');
    }

    return parts.join('. ');
  }

  Future<void> _selectDate(bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate.isBefore(_checkInDate)) {
            _checkOutDate = _checkInDate.add(const Duration(days: 1));
          }
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  void _onSearchPressed() async {
    // Validate inputs based on selected tab
    if (_selectedTabIndex == 0) {
      // Hotels
      if (_toController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a destination')),
        );
        return;
      }

      // Show loading state
      setState(() {
        _isSearching = true;
      });

      try {
        Map<String, dynamic> managerResponse;

        // Use Python ADK Backend (Full Multi-Agent System)
        print('🚀 Using Python ADK Backend');
        managerResponse = await _pythonADK.searchHotels(
          city: _toController.text,
          minPrice: 0,
          maxPrice: _hotelBudget,
          roomType: _selectedRoomType,
          ambiance: _selectedAmbiance,
          amenities: [..._selectedFoodTypes, ..._selectedExtras],
          specialRequest: _specialRequestController.text,
        );

        setState(() {
          _isSearching = false;
        });

        // Show which backend was used
        final source = managerResponse['source'] ?? 'unknown';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              source == 'python_adk'
                  ? '🐍 Using Python ADK Multi-Agent System'
                  : '⚠️ Backend Error - Check if server is running',
            ),
            duration: const Duration(seconds: 2),
            backgroundColor:
                source == 'python_adk' ? Colors.green : Colors.blue,
          ),
        );

        // Handle manager's response
        if (managerResponse['needs_input'] == true) {
          // Manager needs clarification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(managerResponse['response'] ?? 'Need more info'),
              duration: const Duration(seconds: 4),
            ),
          );
          return;
        }

        // Manager successfully found hotels
        print('🔍 FULL RESPONSE: ${managerResponse.toString()}');
        print('🔍 RESPONSE TYPE: ${managerResponse.runtimeType}');
        print('🔍 SUCCESS: ${managerResponse['success']}');
        print('🔍 DATA: ${managerResponse['data']}');
        
        if (managerResponse['success'] == true) {
          final hotelData = managerResponse['data'] as Map<String, dynamic>?;
          print('🔍 HOTEL DATA: $hotelData');
          print('🔍 HOTEL DATA TYPE: ${hotelData.runtimeType}');
          
          final hotels = hotelData?['hotels'] ?? [];
          print('✅ HOTELS: $hotels');
          print('✅ HOTELS TYPE: ${hotels.runtimeType}');
          print('✅ HOTELS LENGTH: ${hotels.length}');

          // Cast hotels to proper type
          final List<Map<String, dynamic>> typedHotels = (hotels as List<dynamic>?)
              ?.map((hotel) => hotel as Map<String, dynamic>)
              .toList() ?? [];

          // Check if hotels were found
          if (typedHotels.isEmpty) {
            // No hotels found - show AI advice
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(managerResponse['response'] ?? 'No hotels found'),
                duration: const Duration(seconds: 5),
                backgroundColor: Colors.orange,
              ),
            );
            setState(() {
              _isSearching = false;
            });
            return;
          }

          // Hotels found - navigate to swipe screen immediately
          // Navigate FIRST, before setState
          print('🚀 NAVIGATING TO SWIPE SCREEN WITH: $typedHotels');
          print('🚀 HOTELS IS EMPTY? ${typedHotels.isEmpty}');
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TinderHotelSwipeScreen(hotels: typedHotels),
            ),
          ).then((_) {
            // After returning from swipe screen, reset loading state
            setState(() {
              _isSearching = false;
            });
          });

          // Don't show snackbar - user will see results screen instead
          return;
        } else {
          // Show manager's response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(managerResponse['response'] ?? 'Searching...'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isSearching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } else if (_selectedTabIndex == 1) {
      // Flights
      if (_fromController.text.isEmpty || _toController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter From and To locations')),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Flights search coming soon!')),
      );
    } else {
      // Destinations
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Destinations coming soon!')),
      );
    }
  }

  String _getButtonText() {
    switch (_selectedTabIndex) {
      case 0:
        return 'Search Hotels';
      case 1:
        return 'Search Flights';
      case 2:
        return 'Explore Destinations';
      default:
        return 'Search';
    }
  }

  Widget _buildHotelForm() {
    final roomTypes = [
      'Single',
      'Double',
      'Deluxe',
      'Suite',
      'Dormitory',
      'Family',
      'Executive',
      'View Room'
    ];
    final foodTypes = [
      'Veg',
      'Non-Veg',
      'Vegan',
      'Gluten-Free',
      'Continental',
      'Indian',
      'Chinese',
      'Mediterranean',
      'Buffet',
      'À la carte'
    ];
    final ambianceTypes = [
      'Luxury',
      'Budget',
      'Modern',
      'Traditional',
      'Romantic',
      'Family-Friendly',
      'Pet-Friendly',
      'Eco-Friendly',
      'Quiet',
      'Party'
    ];
    final extras = [
      'Parking',
      'Wi-Fi',
      'Pool',
      'Gym',
      'Airport Pickup',
      'Early Check-in',
      'Late Check-in',
      'Event Hosting',
      'Nearby Attractions',
      'Pet Policy',
      'Accessibility'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Budget Section
        const Text(
          '💰 Hotel Budget',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppConfig.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('₹0', style: TextStyle(color: AppConfig.textSecondary)),
            Text(
              '₹${_hotelBudget.toStringAsFixed(0)} per night',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppConfig.primaryColor,
              ),
            ),
            const Text('₹50,000',
                style: TextStyle(color: AppConfig.textSecondary)),
          ],
        ),
        Slider(
          value: _hotelBudget,
          min: 0,
          max: 50000,
          divisions: 100,
          activeColor: AppConfig.primaryColor,
          onChanged: (value) => setState(() => _hotelBudget = value),
        ),
        const SizedBox(height: 16),

        // From
        TextField(
          controller: _fromController,
          decoration: InputDecoration(
            labelText: 'From',
            hintText: 'Your current city',
            prefixIcon: const Icon(Icons.my_location),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Destination (To)
        TextField(
          controller: _toController,
          decoration: InputDecoration(
            labelText: 'Where to?',
            hintText: 'Enter destination city',
            prefixIcon: const Icon(Icons.location_city),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Date Row
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(true),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Check-in',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppConfig.radiusMedium),
                    ),
                  ),
                  child: Text(
                    '${_checkInDate.day}/${_checkInDate.month}/${_checkInDate.year}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(false),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Check-out',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppConfig.radiusMedium),
                    ),
                  ),
                  child: Text(
                    '${_checkOutDate.day}/${_checkOutDate.month}/${_checkOutDate.year}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Guests and Rooms Row
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.person, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text('$_guests ${_guests == 1 ? 'Guest' : 'Guests'}'),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon:
                              const Icon(Icons.remove_circle_outline, size: 20),
                          onPressed: () => setState(
                              () => _guests = (_guests - 1).clamp(1, 20)),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          onPressed: () => setState(
                              () => _guests = (_guests + 1).clamp(1, 20)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.hotel, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text('$_rooms ${_rooms == 1 ? 'Room' : 'Rooms'}'),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon:
                              const Icon(Icons.remove_circle_outline, size: 20),
                          onPressed: () => setState(
                              () => _rooms = (_rooms - 1).clamp(1, 10)),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          onPressed: () => setState(
                              () => _rooms = (_rooms + 1).clamp(1, 10)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Room Type Dropdown
        const Text(
          '🛏️ Room Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppConfig.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedRoomType,
          decoration: InputDecoration(
            hintText: 'Select room type',
            prefixIcon: const Icon(Icons.bed),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
            ),
          ),
          items: roomTypes.map((type) {
            return DropdownMenuItem(value: type, child: Text(type));
          }).toList(),
          onChanged: (value) => setState(() => _selectedRoomType = value),
        ),
        const SizedBox(height: 16),

        // Food Preferences
        const Text(
          '🍽️ Food Preferences',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppConfig.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: foodTypes.map((food) {
            final isSelected = _selectedFoodTypes.contains(food);
            return FilterChip(
              label: Text(food),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedFoodTypes.add(food);
                  } else {
                    _selectedFoodTypes.remove(food);
                  }
                });
              },
              selectedColor: AppConfig.primaryColor.withOpacity(0.3),
              checkmarkColor: AppConfig.primaryColor,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Ambiance
        const Text(
          '✨ Ambiance',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppConfig.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedAmbiance,
          decoration: InputDecoration(
            hintText: 'Select ambiance',
            prefixIcon: const Icon(Icons.mood),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
            ),
          ),
          items: ambianceTypes.map((ambiance) {
            return DropdownMenuItem(value: ambiance, child: Text(ambiance));
          }).toList(),
          onChanged: (value) => setState(() => _selectedAmbiance = value),
        ),
        const SizedBox(height: 16),

        // Extras
        const Text(
          '🎁 Extras & Amenities',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppConfig.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: extras.map((extra) {
            final isSelected = _selectedExtras.contains(extra);
            return FilterChip(
              label: Text(extra),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedExtras.add(extra);
                  } else {
                    _selectedExtras.remove(extra);
                  }
                });
              },
              selectedColor: AppConfig.primaryColor.withOpacity(0.3),
              checkmarkColor: AppConfig.primaryColor,
            );
          }).toList(),
        ),
        const SizedBox(height: 12),

        // Special Requests
        TextField(
          controller: _specialRequestController,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Additional Requests',
            hintText: 'Any other specific requirements...',
            prefixIcon: const Icon(Icons.message),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFlightForm() {
    return Column(
      children: [
        // From
        TextField(
          controller: _fromController,
          decoration: InputDecoration(
            labelText: 'From',
            hintText: 'Departure city',
            prefixIcon: const Icon(Icons.flight_takeoff),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // To
        TextField(
          controller: _toController,
          decoration: InputDecoration(
            labelText: 'To',
            hintText: 'Arrival city',
            prefixIcon: const Icon(Icons.flight_land),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Date
        InkWell(
          onTap: () => _selectDate(true),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Travel Date',
              prefixIcon: const Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
              ),
            ),
            child: Text(
              '${_checkInDate.day}/${_checkInDate.month}/${_checkInDate.year}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Passengers
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.person, color: Colors.grey),
              const SizedBox(width: 8),
              Text('$_guests ${_guests == 1 ? 'Passenger' : 'Passengers'}'),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: () =>
                        setState(() => _guests = (_guests - 1).clamp(1, 9)),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    onPressed: () =>
                        setState(() => _guests = (_guests + 1).clamp(1, 9)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationForm() {
    return Column(
      children: [
        TextField(
          controller: _cityController,
          decoration: InputDecoration(
            labelText: 'Search Destinations',
            hintText: 'Enter city or country',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          // Tabs
          Container(
            decoration: BoxDecoration(
              color: AppConfig.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConfig.radiusMedium),
                topRight: Radius.circular(AppConfig.radiusMedium),
              ),
            ),
            child: Row(
              children: [
                _SearchTab(
                  icon: Icons.hotel,
                  label: 'Hotels',
                  isSelected: _selectedTabIndex == 0,
                  onTap: () => setState(() => _selectedTabIndex = 0),
                ),
                _SearchTab(
                  icon: Icons.flight,
                  label: 'Flights',
                  isSelected: _selectedTabIndex == 1,
                  onTap: () => setState(() => _selectedTabIndex = 1),
                ),
                _SearchTab(
                  icon: Icons.place,
                  label: 'Destinations',
                  isSelected: _selectedTabIndex == 2,
                  onTap: () => setState(() => _selectedTabIndex = 2),
                ),
              ],
            ),
          ),

          // Search Form
          Padding(
            padding: const EdgeInsets.all(AppConfig.paddingMedium),
            child: Column(
              children: [
                // Dynamic form based on selected tab
                if (_selectedTabIndex == 0)
                  _buildHotelForm()
                else if (_selectedTabIndex == 1)
                  _buildFlightForm()
                else
                  _buildDestinationForm(),

                const SizedBox(height: 16),

                // Search Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSearching ? null : _onSearchPressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConfig.radiusMedium),
                      ),
                    ),
                    child: _isSearching
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                '✨ AI is finding perfect hotels...',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.auto_awesome, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                _getButtonText(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SearchTab({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppConfig.primaryColor : Colors.transparent,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppConfig.radiusMedium),
              topRight: Radius.circular(AppConfig.radiusMedium),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : AppConfig.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppConfig.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.swipe,
                title: 'Swipe to\nDiscover',
                gradient: AppConfig.accentGradient,
                onTap: () => Get.toNamed('/swipe'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.bookmark,
                title: 'My\nBookings',
                gradient: AppConfig.primaryGradient,
                onTap: () => Get.toNamed('/bookings'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.account_balance_wallet,
                title: 'Budget\nTracker',
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                ),
                onTap: () => Get.toNamed('/budget'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularDestinations extends StatelessWidget {
  final List<Map<String, String>> destinations = [
    {'name': 'Delhi', 'image': '🏛️'},
    {'name': 'Mumbai', 'image': '🌊'},
    {'name': 'Goa', 'image': '🏖️'},
    {'name': 'Jaipur', 'image': '🏰'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Destinations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/destinations'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final dest = destinations[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _DestinationCard(
                  name: dest['name']!,
                  emoji: dest['image']!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final String name;
  final String emoji;

  const _DestinationCard({required this.name, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        gradient: AppConfig.primaryGradient,
        borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Why Choose Us?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        _FeatureItem(
          icon: FontAwesomeIcons.brain,
          title: 'AI-Powered Recommendations',
          description: 'Machine learning adapts to your preferences',
        ),
        _FeatureItem(
          icon: FontAwesomeIcons.map,
          title: 'Google Maps Integration',
          description: 'Real-time ratings and live photos',
        ),
        _FeatureItem(
          icon: FontAwesomeIcons.language,
          title: 'Multilingual Support',
          description: 'Speak in Hindi, Tamil, Telugu, and more',
        ),
        _FeatureItem(
          icon: FontAwesomeIcons.calendar,
          title: 'Calendar Sync',
          description: 'Auto-add bookings with reminders',
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConfig.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConfig.radiusSmall),
            ),
            child: FaIcon(
              icon,
              color: AppConfig.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppConfig.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder tabs
class BudgetTab extends StatelessWidget {
  const BudgetTab({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Budget Screen (Coming Soon)'));
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Profile Screen (Coming Soon)'));
}

// Search Results Section Widget
class _SearchResultsSection extends StatelessWidget {
  const _SearchResultsSection();

  @override
  Widget build(BuildContext context) {
    // Access parent state
    final homeTabState = context.findAncestorStateOfType<_HomeTabState>();
    if (homeTabState == null || homeTabState._searchResults.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Found ${homeTabState._searchResults.length} Hotels',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                homeTabState.clearSearchResults();
              },
              child: const Text('Clear'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: homeTabState._searchResults.length,
          itemBuilder: (context, index) {
            final hotel = homeTabState._searchResults[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppConfig.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.hotel, color: AppConfig.primaryColor),
                ),
                title: Text(
                  hotel['name'] ?? 'Hotel',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${hotel['city'] ?? ''} • ₹${hotel['price_per_night']}/night'),
                    if (hotel['why_recommended'] != null)
                      Text(
                        hotel['why_recommended'],
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.purple[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${hotel['rating'] ?? 4.0}'),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
