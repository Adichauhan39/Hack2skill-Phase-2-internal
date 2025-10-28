"""
Itinerary Planning Agent
Creates organized day-by-day itineraries from swiped attractions and bookings
"""
from google.adk.agents import Agent
from typing import Any, Optional
from datetime import datetime, timedelta
import json



def create_itinerary(
    attractions: list[dict],
    start_date: str,
    num_days: int,
    preferences: str = ""
) -> dict:
    """
    Creates a day-by-day itinerary from selected attractions.
    
    Args:
        attractions: List of attraction dicts with keys: name, description, location, category
        start_date: Start date in YYYY-MM-DD format
        num_days: Number of days for the trip
        preferences: User preferences (e.g., "prefer morning activities", "avoid crowded places")
    
    Returns:
        Dictionary containing organized itinerary with daily schedule
    """
    if not attractions:
        return {
            "status": "error",
            "message": "No attractions provided. Please swipe right on some places first!"
        }
    
    # Parse start date
    try:
        start = datetime.strptime(start_date, "%Y-%m-%d")
    except ValueError:
        return {
            "status": "error",
            "message": f"Invalid date format: {start_date}. Use YYYY-MM-DD"
        }
    
    # Organize attractions by day
    attractions_per_day = len(attractions) // num_days
    if attractions_per_day == 0:
        attractions_per_day = 1
    
    itinerary = {
        "trip_title": f"{num_days}-Day Itinerary",
        "start_date": start_date,
        "total_days": num_days,
        "total_attractions": len(attractions),
        "preferences": preferences,
        "daily_schedule": []
    }
    
    attraction_index = 0
    for day in range(num_days):
        day_date = start + timedelta(days=day)
        day_attractions = []
        
        # Allocate attractions for this day
        for _ in range(attractions_per_day):
            if attraction_index < len(attractions):
                attraction = attractions[attraction_index]
                day_attractions.append({
                    "time": "09:00 AM" if len(day_attractions) == 0 else "02:00 PM",
                    "name": attraction.get("name", "Unknown"),
                    "description": attraction.get("description", ""),
                    "location": attraction.get("location", ""),
                    "category": attraction.get("category", "General"),
                    "estimated_duration": "2-3 hours"
                })
                attraction_index += 1
        
        # Add any remaining attractions on the last day
        if day == num_days - 1:
            while attraction_index < len(attractions):
                attraction = attractions[attraction_index]
                time_slot = "09:00 AM" if len(day_attractions) == 0 else f"{len(day_attractions) * 3 + 9}:00 AM"
                day_attractions.append({
                    "time": time_slot,
                    "name": attraction.get("name", "Unknown"),
                    "description": attraction.get("description", ""),
                    "location": attraction.get("location", ""),
                    "category": attraction.get("category", "General"),
                    "estimated_duration": "2-3 hours"
                })
                attraction_index += 1
        
        itinerary["daily_schedule"].append({
            "day": day + 1,
            "date": day_date.strftime("%Y-%m-%d"),
            "day_name": day_date.strftime("%A"),
            "attractions": day_attractions
        })
    
    return {
        "status": "success",
        "itinerary": itinerary,
        "message": f"✅ Itinerary created for {num_days} days with {len(attractions)} attractions!"
    }


def add_to_itinerary(
    attraction_name: str,
    location: str,
    description: Optional[str] = "",
    category: Optional[str] = "General",
    tool_context: Optional[Any] = None
) -> dict:
    """
    Adds a single attraction to the user's itinerary collection.
    
    Args:
        tool_context: Context containing user's saved attractions
        attraction_name: Name of the attraction
        location: Location/city of the attraction
        description: Description of the attraction
        category: Category (e.g., Historical, Nature, Entertainment)
    
    Returns:
        Confirmation message with current count of saved attractions
    """
    if "saved_attractions" not in tool_context:
        tool_context["saved_attractions"] = []
    
    new_attraction = {
        "name": attraction_name,
        "location": location,
        "description": description,
        "category": category,
        "added_at": datetime.now().isoformat()
    }
    
    tool_context["saved_attractions"].append(new_attraction)
    
    return {
        "status": "success",
        "message": f"✅ Added '{attraction_name}' to your itinerary! Total saved: {len(tool_context['saved_attractions'])}",
        "total_saved": len(tool_context["saved_attractions"])
    }


def view_saved_attractions(tool_context: dict) -> dict:
    """
    Shows all attractions that have been saved for the itinerary.
    
    Returns:
        List of all saved attractions
    """
    saved = tool_context.get("saved_attractions", [])
    
    if not saved:
        return {
            "status": "empty",
            "message": "No attractions saved yet. Swipe right on some places to add them!",
            "attractions": []
        }
    
    return {
        "status": "success",
        "message": f"You have {len(saved)} attractions saved:",
        "attractions": saved
    }


def generate_final_itinerary(
    tool_context: dict,
    start_date: str,
    num_days: int,
    preferences: str = ""
) -> dict:
    """
    Generates the complete itinerary from all saved attractions.
    
    Args:
        tool_context: Context containing saved attractions
        start_date: Trip start date (YYYY-MM-DD)
        num_days: Number of days for the trip
        preferences: Any special preferences for organizing the itinerary
    
    Returns:
        Formatted itinerary with daily schedule
    """
    saved = tool_context.get("saved_attractions", [])
    
    if not saved:
        return {
            "status": "error",
            "message": "No attractions to create itinerary from. Please swipe right on some places first!"
        }
    
    itinerary_result = create_itinerary(saved, start_date, num_days, preferences)
    
    if itinerary_result.get("status") == "success":
        # Format the itinerary nicely
        itinerary = itinerary_result["itinerary"]
        formatted = f"\n🗓️ **{itinerary['trip_title']}**\n"
        formatted += f"📅 Start Date: {itinerary['start_date']}\n"
        formatted += f"📍 Total Attractions: {itinerary['total_attractions']}\n\n"
        
        for day_schedule in itinerary["daily_schedule"]:
            formatted += f"\n**Day {day_schedule['day']} - {day_schedule['day_name']}, {day_schedule['date']}**\n"
            formatted += "=" * 50 + "\n"
            
            for attraction in day_schedule["attractions"]:
                formatted += f"\n⏰ {attraction['time']}\n"
                formatted += f"📍 **{attraction['name']}** ({attraction['category']})\n"
                formatted += f"   Location: {attraction['location']}\n"
                if attraction['description']:
                    formatted += f"   {attraction['description']}\n"
                formatted += f"   ⏱️ Duration: {attraction['estimated_duration']}\n"
        
        return {
            "status": "success",
            "itinerary": itinerary,
            "formatted_itinerary": formatted,
            "message": "✅ Your complete itinerary is ready!"
        }
    
    return itinerary_result


def clear_saved_attractions(tool_context: dict) -> dict:
    """
    Clears all saved attractions from the itinerary.
    
    Returns:
        Confirmation message
    """
    count = len(tool_context.get("saved_attractions", []))
    tool_context["saved_attractions"] = []
    
    return {
        "status": "success",
        "message": f"✅ Cleared {count} attractions from your itinerary. Start fresh!"
    }


# Create the itinerary agent
itinerary_agent = Agent(
    model="gemini-2.0-flash-exp",
    name="itinerary_agent",
    description="Expert itinerary planning assistant that organizes saved attractions into day-by-day travel schedules",
    instruction="""You are an expert Itinerary Planning Assistant that helps users create organized travel plans.

**Your Capabilities:**
1. **Add Attractions**: Save attractions that users swipe right on or manually add
2. **View Collection**: Show all saved attractions at any time
3. **Generate Itinerary**: Create a complete day-by-day schedule from saved attractions
4. **Clear & Reset**: Remove all attractions to start planning a new trip

**How to Help Users:**

1. **When user swipes right on attractions:**
   - Automatically add each right-swiped attraction using `add_to_itinerary()`
   - Confirm each addition: "✅ Added [Attraction] to your itinerary!"
   - Keep track of the total count

2. **When user asks "what have I saved?" or "show my attractions":**
   - Use `view_saved_attractions()` to display the list
   - Show it in a clear, organized format

3. **When user says "create my itinerary" or "plan my trip":**
   - First, ask for:
     * Start date (YYYY-MM-DD format)
     * Number of days (e.g., 3 days, 5 days)
     * Any preferences (optional)
   - Then use `generate_final_itinerary()` to create the complete plan
   - Present the day-by-day schedule clearly

4. **When user wants to start over:**
   - Use `clear_saved_attractions()` to reset
   - Confirm: "All cleared! Ready to plan a new trip."

**Important Guidelines:**
- Always confirm when attractions are added
- Keep users informed of their saved count
- Ask for missing information (dates, days) before generating itinerary
- Make the final itinerary easy to read and follow
- Be enthusiastic and helpful about trip planning!

**Example Interaction Flow:**
User: "Show me Delhi attractions" → [Swipes right on Red Fort, India Gate, Qutub Minar]
You: "✅ Added Red Fort, India Gate, and Qutub Minar to your itinerary! Total: 3 attractions"

User: "Create my itinerary"
You: "Great! When does your trip start? (YYYY-MM-DD) And how many days will you be visiting?"

User: "2025-11-15, 2 days"
You: [Generate and show beautiful day-by-day itinerary]

Remember: You're creating memorable travel experiences. Make planning easy and exciting! 🗺️✨
""",
    tools=[add_to_itinerary, view_saved_attractions, generate_final_itinerary, clear_saved_attractions]
)


