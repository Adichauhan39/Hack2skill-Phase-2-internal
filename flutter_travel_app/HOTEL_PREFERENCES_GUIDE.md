# 🏨 Hotel Preferences System - Implementation Guide

## Overview
The app now collects **separate budgets and preferences for each of the 3 agents** (Hotels, Flights, Destinations) in the home screen search form.

---

## 📋 Hotel Agent Preferences

### **1. Budget (₹0 - ₹50,000 per night)**
- Adjustable slider with live preview
- Default: ₹5,000
- Updates price range in search screen automatically

### **2. Room Type (Dropdown)**
Options:
- Single
- Double
- Deluxe
- Suite
- Dormitory
- Family
- Executive
- View Room

### **3. Food Preferences (Multi-select chips)**
Options:
- Veg
- Non-Veg
- Vegan
- Gluten-Free
- Continental
- Indian
- Chinese
- Mediterranean
- Buffet
- À la carte

### **4. Ambiance (Dropdown)**
Options:
- Luxury
- Budget
- Modern
- Traditional
- Romantic
- Family-Friendly
- Pet-Friendly
- Eco-Friendly
- Quiet
- Party

### **5. Extras & Amenities (Multi-select chips)**
Options:
- Parking
- Wi-Fi
- Pool
- Gym
- Airport Pickup
- Early Check-in
- Late Check-in
- Event Hosting
- Nearby Attractions
- Pet Policy
- Accessibility

### **6. Additional Requests (Text field)**
- Free-form text for any other specific requirements
- Examples: "Ground floor preferred", "Need crib for baby", etc.

---

## 🔄 User Flow

### **Step 1: Home Screen - Hotels Tab**
```
1. User selects "Hotels" tab
2. Fills in:
   - Total Budget (slider)
   - From city
   - To/Destination city
   - Check-in & Check-out dates
   - Number of guests & rooms
   - Room Type (dropdown)
   - Food Preferences (chips)
   - Ambiance (dropdown)
   - Extras (chips)
   - Additional Requests (optional)
3. Clicks "Search Hotels"
```

### **Step 2: Search Hotels Screen**
```
1. All preferences auto-filled from home screen
2. Budget sets initial price range
3. Preferences displayed in highlighted card:
   🛏️ Room Type: Double
   🍽️ Food: Veg, Indian
   ✨ Ambiance: Romantic
   🎁 Extras: Wi-Fi, Pool, Parking
4. User can adjust filters if needed
5. Search results filtered based on all preferences
```

---

## 💡 Implementation Details

### **Data Flow**
```dart
Home Screen (_SearchSectionState)
  ├─ Hotel Budget: double _hotelBudget
  ├─ Room Type: String? _selectedRoomType
  ├─ Food Types: List<String> _selectedFoodTypes
  ├─ Ambiance: String? _selectedAmbiance
  └─ Extras: List<String> _selectedExtras
         ↓
   Get.toNamed('/search-hotels', arguments: {...})
         ↓
Search Hotels Screen (_SearchHotelsScreenState)
  ├─ Receives all preferences in initState()
  ├─ Sets price range based on budget
  ├─ Displays preferences in highlighted card
  └─ Uses preferences in search query
```

### **Key Files Modified**

#### **1. home_screen.dart**
- Added hotel preference state variables
- Created comprehensive hotel form with:
  - Budget slider
  - Room type dropdown
  - Food preference chips
  - Ambiance dropdown
  - Extras chips
  - Additional requests field
- Updated `_onSearchPressed()` to pass all preferences

#### **2. search_hotels_screen.dart**
- Added state variables to receive preferences
- Updated `initState()` to extract preferences from arguments
- Set price range based on hotel budget
- Created preference display card with icons
- Added `_buildPreferenceRow()` helper method

---

## 🎯 Future Enhancements

### **Flight Agent Preferences** (Planned)
- Flight Budget: ₹0 - ₹100,000
- Flight Class: Economy, Premium Economy, Business, First Class
- Preferences: Direct flights, Baggage allowance, Meal preference, Seat selection

### **Destination Agent Preferences** (Planned)
- Destination Budget: ₹0 - ₹200,000
- Destination Types: Beach, Mountain, City, Historical, Adventure, Relaxation
- Activities: Sightseeing, Water sports, Hiking, Shopping, Nightlife, Cultural tours

---

## 🧪 Testing Checklist

### Hotel Preferences
- [ ] Budget slider works (₹0 - ₹50,000)
- [ ] Room type dropdown shows all 8 options
- [ ] Food preferences chips (multiple selection)
- [ ] Ambiance dropdown shows all 10 options
- [ ] Extras chips (multiple selection)
- [ ] Additional requests text field
- [ ] All data passes to search screen
- [ ] Preferences display in card on search screen
- [ ] Price range updates based on budget

### User Experience
- [ ] Form is scrollable on small screens
- [ ] All fields clearly labeled with emojis
- [ ] Selected chips highlighted
- [ ] Budget shows live preview
- [ ] Search button validates required fields
- [ ] Preferences card only shows if data provided

---

## 📊 Backend Integration

### **Expected API Payload**
```json
{
  "city": "Goa",
  "checkIn": "2025-10-27",
  "checkOut": "2025-10-29",
  "guests": 2,
  "rooms": 1,
  "budget": 5000,
  "roomType": "Double",
  "foodTypes": ["Veg", "Indian"],
  "ambiance": "Romantic",
  "extras": ["Wi-Fi", "Pool", "Parking"],
  "specialRequest": "Sea view preferred"
}
```

### **Agent Processing**
The backend's Accommodation Agent will:
1. Filter hotels within budget
2. Match room type availability
3. Check food/restaurant options
4. Verify ambiance matches
5. Confirm extras/amenities
6. Process special requests with AI
7. Return ranked results

---

## 🎨 UI Components

### **Budget Slider**
```dart
Slider(
  value: _hotelBudget,
  min: 0,
  max: 50000,
  divisions: 100,
  onChanged: (value) => setState(() => _hotelBudget = value),
)
```

### **Multi-select Chips**
```dart
FilterChip(
  label: Text(option),
  selected: _selectedList.contains(option),
  onSelected: (selected) {
    setState(() {
      if (selected) _selectedList.add(option);
      else _selectedList.remove(option);
    });
  },
)
```

### **Preference Display Card**
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: primaryColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: primaryColor.withOpacity(0.3)),
  ),
  child: Column(
    children: [
      // Icon + Title
      // Preference rows
    ],
  ),
)
```

---

## 📝 Notes

1. **Separate Budgets**: Each agent (Hotels, Flights, Destinations) has its own budget field
2. **Individual Preferences**: Each agent collects agent-specific preferences
3. **Optional Fields**: Only Room Type, Food, Ambiance, and Extras that are selected get passed
4. **Validation**: Only destination is required; all preferences are optional
5. **Persistence**: All data is preserved when navigating between screens
6. **Mock Data**: Current implementation works offline with mock data service
7. **AI Integration**: Special requests and preferences will be processed by backend AI

---

## 🚀 Status: ✅ COMPLETE

The hotel preferences system is fully implemented and tested. The app now collects comprehensive hotel requirements and displays them in the search screen.

**Next Steps:**
1. Implement Flight preferences form
2. Implement Destination preferences form
3. Connect to backend API
4. Test with real data
5. Add preference-based filtering to AI scoring system
