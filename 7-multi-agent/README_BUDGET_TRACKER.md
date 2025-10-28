# Budget Tracker Agent - Complete Guide

## Overview
The Budget Tracker Agent is a comprehensive expense management system integrated into the multi-agent travel booking platform. It helps travelers monitor their spending, manage budgets, and split expenses for group travel.

## Features

### 1. Budget Setup
- Set total travel budget
- Configure group size
- Automatic per-person budget calculation

### 2. Expense Tracking
**Booking Expenses** (Automatic):
- Hotel/Accommodation bookings
- Flight bookings
- Train bookings
- Taxi/Transport bookings

**Additional Expenses** (Manual):
- Food & Dining
- Shopping & Souvenirs
- Activities & Entertainment
- Local Transport
- Miscellaneous

### 3. Group Expense Management
- Equal split for booking expenses
- Flexible split for additional expenses
- Per-person cost calculations
- Detailed expense breakdown

### 4. Budget Monitoring
- Real-time spending tracking
- Remaining budget calculation
- Budget utilization percentage
- Category-wise expense breakdown
- Booking type breakdown

## Available Tools

### `set_budget(total_budget, group_size)`
Initialize budget tracking for the trip.

**Parameters:**
- `total_budget` (float): Total budget in INR
- `group_size` (int): Number of people traveling (default: 1)

**Example:**
```
Set a budget of ₹50,000 for 4 people
```

**Returns:**
- Budget confirmation
- Per-person budget allocation
- Setup status

---

### `track_booking_expense(booking_type, booking_id, amount, description)`
Track expenses from bookings (hotels, flights, trains, taxis).

**Parameters:**
- `booking_type` (str): Type of booking (hotel, flight, train, taxi)
- `booking_id` (str, optional): Booking ID to fetch from bookings state
- `amount` (float, optional): Manual amount entry
- `description` (str, optional): Expense description

**Example:**
```
Track the hotel booking expense for booking ID BK123456
```

**Returns:**
- Expense confirmation
- Per-person cost
- Updated budget status

---

### `add_expense(category, amount, description, shared_by)`
Add additional expenses outside of bookings.

**Parameters:**
- `category` (str): Food, Shopping, Activities, Transport, Miscellaneous
- `amount` (float): Amount spent in INR
- `description` (str): Description of expense
- `shared_by` (int, optional): Number of people sharing (default: all members)

**Example:**
```
Add ₹2,000 for dinner at a restaurant shared by 3 people
```

**Returns:**
- Expense confirmation
- Per-person split
- Updated budget status

---

### `get_budget_summary()`
Get complete budget overview with all expenses.

**Example:**
```
Show me the budget summary
What's my current spending status?
```

**Returns:**
- Total budget and spent amount
- Remaining budget
- Budget utilization percentage
- Booking expenses total
- Additional expenses total
- Category-wise breakdown
- Booking type breakdown
- Total expense count

---

### `calculate_split()`
Calculate how expenses should be split among group members.

**Example:**
```
Calculate how we should split the expenses
How much does each person owe?
```

**Returns:**
- Per-person total cost
- Per-person booking expenses
- Per-person additional expenses
- Detailed expense list with splits
- Remaining per-person budget

---

### `get_expense_list(expense_type)`
Get filtered list of all expenses.

**Parameters:**
- `expense_type` (str, optional): Filter by "booking" or "additional" (default: all)

**Example:**
```
Show all booking expenses
List all additional expenses
```

**Returns:**
- Filtered expense list
- Expense count
- Total amount

## Usage Workflow

### 1. Setting Up Budget
```
User: "I have a budget of ₹80,000 for 5 people"
Agent: Uses set_budget(80000, 5)
Result: Budget set, per-person budget = ₹16,000
```

### 2. Booking Travel & Accommodation
```
User: "Book Hotel Taj Palace in Delhi"
hotel_booking agent: Creates booking BK123456
User: "Track this hotel expense"
budget_tracker: Uses track_booking_expense("hotel", "BK123456")
Result: Hotel expense ₹8,000 tracked (₹1,600 per person)
```

### 3. Adding Additional Expenses
```
User: "We spent ₹3,000 on dinner, shared by 4 people"
budget_tracker: Uses add_expense("Food", 3000, "Dinner at restaurant", 4)
Result: Expense tracked (₹750 per person who shared)
```

### 4. Checking Budget Status
```
User: "What's my budget status?"
budget_tracker: Uses get_budget_summary()
Result: Shows spent/remaining, utilization %, category breakdown
```

### 5. Splitting Expenses
```
User: "Calculate how much each person should pay"
budget_tracker: Uses calculate_split()
Result: Detailed per-person breakdown with all expenses
```

## Integration with Other Agents

### Hotel Booking Agent
When a hotel is booked:
1. Booking details stored in shared state
2. Budget tracker can fetch booking_id to get price
3. Automatic expense tracking available

### Flight/Train/Taxi Booking Agent
When travel is booked:
1. Booking details stored in shared state
2. Budget tracker can fetch price from booking
3. Automatic expense tracking available

### Destination Info Agent
When planning destinations:
1. Budget tracker provides spending insights
2. Can help estimate costs for activities
3. Suggests budget-friendly options

## Data Storage

Budget data is stored in `tool_context.state["budget"]`:

```python
{
    "total_budget": 80000,
    "group_size": 5,
    "per_person_budget": 16000,
    "spent": 15000,
    "remaining": 65000,
    "expenses": [...],           # All expenses
    "booking_expenses": [...],   # Booking-related
    "additional_expenses": [...], # Manual entries
    "timestamp": "2024-01-15T10:30:00"
}
```

## Example Conversation Flow

```
User: "I want to plan a trip to Goa with 3 friends. Our budget is ₹100,000"

Manager → budget_tracker.set_budget(100000, 4)
Response: "Budget set! ₹100,000 total, ₹25,000 per person"

User: "Book Hotel Taj in Goa for 3 nights"

Manager → hotel_booking.book_accommodation(...)
Response: "Booked! Hotel Taj - ₹9,000 total"

User: "Track this hotel expense"

Manager → budget_tracker.track_booking_expense("hotel", "BK123456")
Response: "Expense tracked! ₹9,000 (₹2,250 per person). Remaining: ₹91,000"

User: "We went shopping and spent ₹8,000 total"

Manager → budget_tracker.add_expense("Shopping", 8000, "Shopping at local market")
Response: "Expense added! ₹8,000 shared by 4 people (₹2,000 each). Remaining: ₹83,000"

User: "Show me budget summary"

Manager → budget_tracker.get_budget_summary()
Response: Shows complete breakdown with categories, utilization, etc.

User: "Calculate how much each person owes"

Manager → budget_tracker.calculate_split()
Response: Detailed per-person breakdown with all expenses listed
```

## Key Benefits

✅ **Real-time Tracking**: Know your spending status at any moment
✅ **Group Management**: Handle expenses for multiple travelers
✅ **Flexible Splitting**: Not all expenses need equal split
✅ **Automatic Integration**: Bookings automatically available for tracking
✅ **Comprehensive Reports**: Category-wise, booking-type, per-person breakdowns
✅ **Budget Alerts**: Monitor utilization and remaining budget
✅ **Fair Splitting**: Calculate accurate per-person costs

## Tips for Best Use

1. **Set Budget First**: Always start by setting your budget before making bookings
2. **Track Immediately**: Track booking expenses right after confirming bookings
3. **Be Specific**: Use clear descriptions for additional expenses
4. **Regular Checks**: Check budget summary periodically during trip
5. **Group Clarity**: Specify shared_by for expenses not split equally
6. **Calculate at End**: Use calculate_split() at trip end for final settlement

## Technical Details

- **Model**: Gemini 2.0 Flash Exp
- **Storage**: Shared state dictionary (tool_context.state)
- **Currency**: Indian Rupees (INR)
- **Precision**: 2 decimal places for all amounts
- **Expense IDs**: Auto-generated (EXP + 6-digit random)
- **Timestamps**: ISO 8601 format for all entries

---

**Status**: ✅ Fully Integrated and Ready to Use

**Last Updated**: January 2025
