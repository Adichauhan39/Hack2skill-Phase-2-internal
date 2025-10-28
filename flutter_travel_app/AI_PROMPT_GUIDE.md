# AI Prompt System - Complete Guide

## 🎯 Overview
The AI prompt system uses **Natural Language Processing (NLP)** with intelligent keyword matching and scoring algorithms to understand user requirements and filter hotels accordingly.

## 🧠 How It Works

### 1. **User Input Processing**
```
User types: "I need a budget hotel near the beach with WiFi"
              ↓
System extracts keywords: [budget, beach, wifi]
              ↓
Applies smart scoring algorithm
              ↓
Returns best matching hotels
```

### 2. **Scoring Algorithm**
Each hotel is scored based on how well it matches the prompt:
- **0-5 points**: Weak match
- **5-10 points**: Good match
- **10-15 points**: Excellent match
- **15+ points**: Perfect match

Hotels with **score = 0** are filtered out.
Results are sorted by **score (descending)** then **rating**.

## 📝 Supported Keywords & Categories

### 💰 **Budget Preferences**
| User Says | System Understands | Scoring Logic |
|-----------|-------------------|---------------|
| "budget hotel" | Price < ₹5,000 | +10 points if < ₹5k, +5 if < ₹10k |
| "cheap accommodation" | Affordable options | Prioritizes lower prices |
| "affordable stay" | Economy hotels | Budget-friendly results |
| "economical" | Best value | Cost-effective options |

**Examples:**
```
✅ "Need a budget hotel with parking"
✅ "Looking for cheap accommodation near airport"
✅ "Affordable stay for backpackers"
```

### 💎 **Luxury Preferences**
| User Says | System Understands | Scoring Logic |
|-----------|-------------------|---------------|
| "luxury hotel" | Price > ₹20,000 | +10 points if > ₹20k |
| "5 star" | Premium hotels | Luxury amenities priority |
| "high-end" | Deluxe properties | Top-tier hotels |
| "premium stay" | Luxury experience | Best hotels first |

**Examples:**
```
✅ "I want a luxury hotel with spa"
✅ "Book me a 5 star property"
✅ "Looking for high-end accommodation"
```

### 🏖️ **Location Preferences**

#### Beach/Coastal
```
Keywords: beach, sea, coastal, waterfront, ocean
Scoring: +15 points for beach access
Examples:
  ✅ "Hotel near the beach"
  ✅ "Beachfront property"
  ✅ "Sea view room"
```

#### City Center
```
Keywords: city center, downtown, central, mg road
Scoring: +10 points for central location
Examples:
  ✅ "Hotel in city center"
  ✅ "Downtown accommodation"
  ✅ "Central location preferred"
```

#### Airport Proximity
```
Keywords: airport, early flight, late arrival, near airport
Scoring: +15 points for airport shuttle
Examples:
  ✅ "Hotel near airport"
  ✅ "Need stay for early morning flight"
  ✅ "Late night arrival"
```

### 💕 **Ambiance & Purpose**

#### Romantic/Honeymoon
```
Keywords: romantic, honeymoon, couple, anniversary
Scoring: +15 for romantic ambiance, +5 for spa
Examples:
  ✅ "Romantic getaway for anniversary"
  ✅ "Honeymoon suite with spa"
  ✅ "Couple-friendly hotel"
```

#### Party/Nightlife
```
Keywords: party, nightlife, social, bar, club
Scoring: +15 for party ambiance, +5 for hostels
Examples:
  ✅ "Hotel with nightlife"
  ✅ "Social hostel for solo travelers"
  ✅ "Party destination"
```

#### Quiet/Peaceful
```
Keywords: quiet, peaceful, relaxing, calm, serene
Scoring: +10 for peaceful ambiance, +5 for resorts
Examples:
  ✅ "Quiet hotel for relaxation"
  ✅ "Peaceful resort away from city"
  ✅ "Calm environment for reading"
```

### 🏊 **Amenity Preferences**

#### Pool/Swimming
```
Keywords: pool, swimming, swim
Scoring: +10 points
Examples:
  ✅ "Hotel with swimming pool"
  ✅ "Need pool for kids"
```

#### Spa/Wellness
```
Keywords: spa, massage, wellness, relaxation
Scoring: +10 points
Examples:
  ✅ "Hotel with spa facilities"
  ✅ "Massage services available"
```

#### Gym/Fitness
```
Keywords: gym, fitness, workout, exercise
Scoring: +10 points
Examples:
  ✅ "Hotel with gym"
  ✅ "Fitness center required"
```

#### WiFi/Internet
```
Keywords: wifi, internet, work from hotel
Scoring: +5 points
Examples:
  ✅ "Need good WiFi for work"
  ✅ "High-speed internet"
```

#### Parking
```
Keywords: parking, car, vehicle
Scoring: +8 points
Examples:
  ✅ "Hotel with parking"
  ✅ "Need space for car"
```

#### Restaurant/Dining
```
Keywords: restaurant, dining, breakfast, food
Scoring: +8 points
Examples:
  ✅ "Hotel with restaurant"
  ✅ "Breakfast included"
  ✅ "Good dining options"
```

### 🍽️ **Food Preferences**

```
Vegetarian: "veg only", "vegetarian"
Seafood: "seafood", "coastal cuisine"
Buffet: "buffet", "all you can eat"

Examples:
  ✅ "Vegetarian food options"
  ✅ "Hotel with seafood restaurant"
  ✅ "Breakfast buffet"
```

### 💼 **Travel Purpose**

#### Business Travel
```
Keywords: business, work, conference, meeting
Scoring: +10 for business ambiance, +5 WiFi, +5 events
Examples:
  ✅ "Business hotel with conference room"
  ✅ "Work-friendly accommodation"
  ✅ "Need WiFi for meetings"
```

#### Family Travel
```
Keywords: family, kids, children, family room
Scoring: +10 for family rooms, +5 mid-range price
Examples:
  ✅ "Family-friendly hotel"
  ✅ "Rooms for kids"
  ✅ "Family vacation"
```

#### Solo/Backpacker
```
Keywords: backpack, hostel, solo, dorm
Scoring: +15 for hostels, +5 for < ₹2k price
Examples:
  ✅ "Backpacker hostel"
  ✅ "Solo traveler friendly"
  ✅ "Dormitory accommodation"
```

### 🏰 **Heritage/Cultural**

```
Keywords: heritage, palace, traditional, cultural, royal
Scoring: +15 for heritage properties
Examples:
  ✅ "Heritage hotel with history"
  ✅ "Palace hotel in Jaipur"
  ✅ "Traditional Rajasthani stay"
```

### ⭐ **Rating Preferences**

```
Keywords: best, top rated, highly rated, excellent
Scoring: +10 for 4.7+ rating, +5 for 4.5+
Examples:
  ✅ "Best hotels in the city"
  ✅ "Top rated properties"
  ✅ "Highly recommended"
```

## 🎨 Advanced Combinations

### Example 1: Luxury Beach Honeymoon
```
Prompt: "Luxury beachfront hotel with spa for honeymoon"

Matched Keywords:
  - luxury (+10)
  - beach (+15)
  - spa (+10)
  - honeymoon (+15)

Total Score: 50 points
Result: Taj Exotica Resort & Spa, Goa (₹22,000/night)
```

### Example 2: Budget Business Travel
```
Prompt: "Budget hotel with WiFi and parking for business trip"

Matched Keywords:
  - budget (+10)
  - wifi (+5)
  - parking (+8)
  - business (+10)

Total Score: 33 points
Result: Hotel Shanti Palace, Delhi (₹3,500/night)
```

### Example 3: Family Beach Vacation
```
Prompt: "Family-friendly beach resort with pool and restaurant"

Matched Keywords:
  - family (+10)
  - beach (+15)
  - pool (+10)
  - restaurant (+8)

Total Score: 43 points
Result: Alila Diwa Goa (₹15,000/night)
```

## 🔧 Technical Implementation

### Scoring System
```dart
double score = 0.0;

// Check each keyword category
if (prompt.contains('budget')) {
  if (hotel.price < 5000) score += 10;
}

if (prompt.contains('beach')) {
  if (hotel.hasBeachAccess) score += 15;
}

// ... more checks

return score;
```

### Filtering Logic
```dart
1. Score all hotels (0-100+ points possible)
2. Filter out hotels with score = 0
3. Sort by score (descending)
4. Sort by rating (for same scores)
5. Return top results
```

## 💡 Smart Features

### 1. **Fallback Mechanism**
If no hotels match the AI prompt, returns all results based on standard filters.

### 2. **Multi-keyword Support**
Handles multiple requirements in one prompt:
```
✅ "Budget hotel near beach with WiFi and parking"
```

### 3. **Synonym Recognition**
Understands variations:
- "cheap" = "budget" = "affordable" = "economical"
- "luxury" = "premium" = "5 star" = "high-end"
- "pool" = "swimming" = "swim"

### 4. **Context Awareness**
Combines filters intelligently:
```
"Romantic hotel" + "Goa" → Beach resorts with spa
"Business hotel" + "Bangalore" → Central hotels with WiFi
"Family hotel" + "Jaipur" → Heritage hotels with family rooms
```

## 📊 Response Generation

The system generates smart responses based on matched criteria:

```dart
Input: "budget beach hotel"
Output: "Found 2 hotels with affordable prices near the beach that match your preferences!"

Input: "luxury spa resort"
Output: "Found 3 hotels with luxury amenities that match your preferences!"

Input: "family-friendly hotel"
Output: "Found 5 hotels great for families that match your preferences!"
```

## 🎯 Best Practices

### ✅ DO:
- Be specific: "Budget hotel with pool" (not just "hotel")
- Combine requirements: "Business hotel with WiFi and parking"
- Mention purpose: "Romantic getaway" or "Family vacation"
- Specify location: "Near beach" or "City center"

### ❌ DON'T:
- Be too vague: "Good hotel"
- Use conflicting terms: "Luxury budget hotel"
- Expect exact matches: System uses intelligent scoring
- Forget standard filters: Price range, dates, guests still apply

## 🚀 Future Enhancements

1. **Machine Learning**: Train on user preferences
2. **Sentiment Analysis**: Understand tone ("really need", "must have")
3. **Negation Handling**: "Not too expensive", "Avoid party areas"
4. **Voice Input**: Speak your requirements
5. **Image Recognition**: "Find hotels like this picture"
6. **Chat Interface**: Back-and-forth conversation
7. **Preference Memory**: Remember past searches
8. **Smart Suggestions**: Auto-complete prompts

## 📱 Usage in App

### Home Screen
```dart
TextField(
  controller: _specialRequestController,
  decoration: InputDecoration(
    labelText: 'Special Requests (Optional)',
    hintText: 'E.g., Budget hotel near beach with WiFi...',
  ),
)
```

### Search Results
```dart
// AI response shown in SnackBar
"AI: Found 4 hotels with affordable prices near the beach!"

// Badge showing offline mode
"Found 4 hotels in Goa (Using offline data)"
```

## 🎓 Example Prompts Library

Copy-paste these for testing:

### Budget Travelers
```
1. "Budget hotel with WiFi for work"
2. "Cheap accommodation near station"
3. "Affordable backpacker hostel"
4. "Economical stay with breakfast"
```

### Luxury Seekers
```
1. "5 star hotel with spa and pool"
2. "Luxury beachfront property"
3. "Premium hotel with butler service"
4. "High-end resort for anniversary"
```

### Business Travelers
```
1. "Business hotel with conference room"
2. "Central hotel with good WiFi"
3. "Airport hotel for early flight"
4. "Work-friendly accommodation with desk"
```

### Families
```
1. "Family-friendly resort with kids activities"
2. "Hotel with family rooms and pool"
3. "Safe neighborhood for family vacation"
4. "Spacious rooms for 4 people"
```

### Couples
```
1. "Romantic beachfront resort for honeymoon"
2. "Secluded hotel with spa"
3. "Couple-friendly property with privacy"
4. "Luxury suite for anniversary"
```

## 🏆 Success Metrics

The AI system is considered successful when:
- ✅ Relevance: Top results match user intent
- ✅ Diversity: Mix of price ranges and types
- ✅ Personalization: Learns from interactions
- ✅ Speed: Returns results < 1 second
- ✅ Accuracy: 80%+ user satisfaction

---

**Built with ❤️ for Hack2Skill Finale**
*Powered by Google Gemini AI & Flutter*
