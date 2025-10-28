# Multi-Agent Travel Booking System - Complete Documentation

## System Overview

A comprehensive AI-powered travel booking system with 4 specialized agents working together to provide complete travel planning, booking, and budget management services for Indian destinations.

## Architecture

```
Manager Agent (Root)
├── Hotel Booking Agent (Accommodation)
├── Flight Booking Agent (Travel - Flight/Train/Taxi)
├── Destination Info Agent (Planning)
└── Budget Tracker Agent (Expense Management)
```

## Agents Overview

### 1. Manager Agent
**Model**: Gemini 2.0 Flash
**Role**: Root coordinator that delegates tasks to specialized agents
**Responsibilities**:
- Route user requests to appropriate agent
- Coordinate cross-agent communication
- Manage shared state
- Provide unified response

### 2. Hotel Booking Agent (Accommodation Agent)
**Model**: Gemini 2.0 Flash Exp
**Data Source**: `data/hotels_india.csv` (80 accommodations)
**Capabilities**:
- Search hotels and hostels
- Filter by type, room, food, ambiance
- Book accommodations with special requests
- Check for existing travel bookings
- Provide recommendations

**Features**:
- 80 accommodations across 15 Indian cities
- Hotels and Hostels
- Room types: Single, Double, Deluxe, Suite, Dormitory, Family, Executive, View Room
- Food options: Veg, Non-Veg, Vegan, Gluten-Free, Continental, Indian, Chinese, Mediterranean, Buffet, À la carte
- Ambiance: Luxury, Budget, Modern, Traditional, Romantic, Family-Friendly, Pet-Friendly, Eco-Friendly
- Extras: Parking, WiFi, Pool, Gym, Spa, Airport Pickup, Early/Late Check-in, Events, Pet Policy, Accessibility

### 3. Flight Booking Agent (Travel Agent)
**Model**: Gemini 2.0 Flash Exp
**Data Source**: `data/travel_bookings_india.csv` (56 bookings)
**Capabilities**:
- Search and book flights
- Search and book trains
- Search and book taxis
- Filter by class, preferences
- Check for existing hotel bookings
- Provide recommendations

**Features**:
- 56 travel options across multiple modes
- Modes: Flight, Train, Taxi (Bus, Car Rental, Bike/Scooter in CSV)
- Classes: Economy, Business, First Class, Sleeper, AC, Non-AC
- Preferences: Window seat, Aisle seat, Veg meal, Non-veg meal
- Extras: WiFi, Entertainment, Priority boarding, Lounge access
- Travel types: Business, Leisure, Family
- Accessibility features included

### 4. Destination Info Agent
**Model**: Gemini 2.0 Flash
**Data Source**: `data/destinations_india.csv` (15 cities)
**Capabilities**:
- Provide destination information
- Suggest activities and attractions
- Recommend travel styles
- Seasonal planning advice
- Nearby attractions

**Features**:
- 15 major Indian destinations
- Location types: Beach, Hill Station, City, Countryside, Desert, Island
- Activities: Sightseeing, Adventure Sports, Trekking, Shopping, Cultural Tours, Water Sports, Wildlife Safari
- Travel styles: Luxury, Budget, Backpacking, Family, Romantic
- Season preferences: Summer, Winter, Monsoon, All-Year
- Nearby attractions with types
- Local cuisine and language info

### 5. Budget Tracker Agent (NEW!)
**Model**: Gemini 2.0 Flash Exp
**Data Source**: Shared state (tool_context.state)
**Capabilities**:
- Set and manage travel budget
- Track booking expenses
- Track additional expenses
- Calculate group expense splits
- Provide budget summaries
- Generate expense reports

**Features**:
- Budget setup for groups
- Automatic booking expense tracking
- Manual expense entry (Food, Shopping, Activities, Transport, Miscellaneous)
- Flexible expense splitting
- Real-time budget monitoring
- Category-wise breakdown
- Per-person cost calculation
- Budget utilization tracking

## Data Files

### 1. `data/travel_bookings_india.csv`
**Entries**: 56 travel options
**Columns**:
- mode, origin, destination
- operator, service_number
- class, departure_time, arrival_time
- price, duration
- ac_nonac, preferences, extras
- travel_type, accessibility

### 2. `data/hotels_india.csv`
**Entries**: 80 accommodations
**Columns**:
- city, accommodation_type, name
- price_per_night, rating
- room_types, food_options
- ambiance, extras
- nearby_attractions, accessibility

### 3. `data/destinations_india.csv`
**Entries**: 15 destinations
**Columns**:
- city, description
- location_type, activities
- travel_style, season_preference
- attractions, nearby_attractions_type
- cuisine, language, famous_for, nearby_places

## Shared State Management

All agents share state through `tool_context.state`:

```python
{
    "bookings": [
        {
            "booking_type": "hotel",  # or "flight", "train", "taxi"
            "booking_id": "BK123456",
            "location": "Delhi",
            "accommodation_name": "Hotel Taj Palace",
            "price_per_night": 3000,
            # ... other booking details
        }
    ],
    "destinations_visited": ["delhi", "mumbai"],
    "budget": {
        "total_budget": 100000,
        "group_size": 4,
        "per_person_budget": 25000,
        "spent": 35000,
        "remaining": 65000,
        "expenses": [...],
        "booking_expenses": [...],
        "additional_expenses": [...]
    }
}
```

## Complete Workflow Example

### Scenario: Group Trip to Goa

**Step 1: Set Budget**
```
User: "We're 4 people with a budget of ₹120,000 for Goa trip"
Manager → budget_tracker.set_budget(120000, 4)
Result: Budget set (₹30,000 per person)
```

**Step 2: Get Destination Info**
```
User: "Tell me about Goa"
Manager → destination_info.get_destinations("Goa")
Result: Beach destination, activities, best time, attractions
```

**Step 3: Book Flight**
```
User: "Book Mumbai to Goa flight for 4 people on Dec 25"
Manager → flight_booking.search_travel("flight", "Mumbai", "Goa")
Manager → flight_booking.book_travel("flight", "AI502", ...)
Result: Flight booked, recommends checking hotels
```

**Step 4: Track Flight Expense**
```
User: "Track the flight expense"
Manager → budget_tracker.track_booking_expense("flight", "FL123456")
Result: ₹16,000 tracked (₹4,000 per person), ₹104,000 remaining
```

**Step 5: Book Hotel**
```
User: "Book a beach resort in Goa with pool"
Manager → hotel_booking.search_accommodations("Goa", ambiance="Beach Resort")
Manager → hotel_booking.book_accommodation("Goa Beach Resort", ...)
Result: Hotel booked for 3 nights
```

**Step 6: Track Hotel Expense**
```
User: "Add the hotel expense to budget"
Manager → budget_tracker.track_booking_expense("hotel", "BK789012")
Result: ₹24,000 tracked (₹6,000 per person), ₹80,000 remaining
```

**Step 7: Add Additional Expenses**
```
User: "We spent ₹8,000 on dinner at beach shack"
Manager → budget_tracker.add_expense("Food", 8000, "Beach shack dinner")
Result: ₹8,000 added (₹2,000 per person), ₹72,000 remaining
```

**Step 8: Budget Summary**
```
User: "Show budget summary"
Manager → budget_tracker.get_budget_summary()
Result: Detailed breakdown by category and booking type
```

**Step 9: Calculate Split**
```
User: "How much does each person owe?"
Manager → budget_tracker.calculate_split()
Result: Per-person breakdown: ₹12,000 each
```

## Key Features

✅ **Multi-Modal Travel**: Flights, Trains, Taxis
✅ **Comprehensive Accommodation**: Hotels, Hostels with detailed options
✅ **Destination Planning**: 15 cities with activity recommendations
✅ **Budget Management**: Track, monitor, and split expenses
✅ **Group Travel**: Handle multiple travelers and fair splitting
✅ **Cross-Agent Communication**: Agents work together seamlessly
✅ **Real-time Tracking**: Budget status updates instantly
✅ **Flexible Filtering**: Search by multiple criteria
✅ **Special Requests**: Accessibility, dietary, preferences
✅ **CSV-Based Data**: Easy to update and maintain

## Agent Tools Summary

### Hotel Booking Agent
1. `load_accommodations_from_csv()` - Load accommodation data
2. `search_accommodations()` - Search with filters
3. `book_accommodation()` - Book with special requests

### Flight Booking Agent (Travel Agent)
1. `load_travel_data_from_csv()` - Load travel data
2. `search_travel()` - Search by mode and criteria
3. `book_travel()` - Book transport

### Destination Info Agent
1. `load_destinations_from_csv()` - Load destination data
2. `get_destinations()` - Get comprehensive destination info

### Budget Tracker Agent
1. `set_budget()` - Initialize budget
2. `track_booking_expense()` - Track booking costs
3. `add_expense()` - Add additional expenses
4. `get_budget_summary()` - Get complete overview
5. `calculate_split()` - Calculate per-person costs
6. `get_expense_list()` - List all expenses

## Starting the System

```powershell
cd "c:\Hack2skill\Hack2skill finale"
.\venv\Scripts\Activate.ps1
cd "7-multi-agent"
adk web
```

Then open: http://localhost:8000

## Technology Stack

- **Framework**: Google ADK 0.3.0
- **Models**: 
  - Gemini 2.0 Flash (Manager, Destination Info)
  - Gemini 2.0 Flash Exp (Hotel, Travel, Budget)
- **Language**: Python 3.11
- **Environment**: Virtual Environment (venv)
- **Data Storage**: CSV files
- **State Management**: Shared dictionary

## Project Structure

```
7-multi-agent/
├── data/
│   ├── travel_bookings_india.csv (56 entries)
│   ├── hotels_india.csv (80 entries)
│   └── destinations_india.csv (15 entries)
├── manager/
│   ├── agent.py (root agent)
│   ├── __init__.py
│   ├── tools/
│   │   ├── tools.py (get_current_time)
│   │   └── __init__.py
│   └── sub_agents/
│       ├── hotel_booking/
│       │   ├── agent.py (accommodation agent)
│       │   └── __init__.py
│       ├── flight_booking/
│       │   ├── agent.py (travel agent)
│       │   └── __init__.py
│       ├── destination_info/
│       │   ├── agent.py (planning agent)
│       │   └── __init__.py
│       └── budget_tracker/
│           ├── agent.py (expense agent) ← NEW!
│           └── __init__.py
├── README_BUDGET_TRACKER.md (budget tracker guide)
└── SYSTEM_DOCUMENTATION.md (this file)
```

## Status: ✅ COMPLETE

All 4 agents fully implemented and integrated:
- ✅ Manager Agent
- ✅ Hotel Booking Agent (Enhanced)
- ✅ Flight Booking Agent (Enhanced to Travel Agent)
- ✅ Destination Info Agent (Enhanced)
- ✅ Budget Tracker Agent (NEW - Just Completed!)

**Ready for Production Use!**

---

**Last Updated**: January 2025
**Version**: 1.0
**Status**: Production Ready
