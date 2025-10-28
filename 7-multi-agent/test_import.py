"""
Test script to verify the multi-agent system works correctly
"""

import sys
import os

# Add the parent directory to path if needed
current_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, current_dir)

try:
    from manager.agent import root_agent
    print("✅ Successfully imported root_agent!")
    print(f"   Agent name: {root_agent.name}")
    print(f"   Agent model: {root_agent.model}")
    print(f"   Description: {root_agent.description}")
    
    # Check sub-agents
    from manager.sub_agents.hotel_booking.agent import hotel_booking
    from manager.sub_agents.travel_booking.agent import travel_booking
    from manager.sub_agents.destination_info.agent import destination_info
    from manager.sub_agents.budget_tracker.agent import budget_tracker
    
    print("\n✅ All sub-agents loaded successfully:")
    print(f"   - {hotel_booking.name}")
    print(f"   - {travel_booking.name}")
    print(f"   - {destination_info.name}")
    print(f"   - {budget_tracker.name}")
    
    print("\n🎉 System is ready to use!")
    print("\nTo run the agent, use: root_agent.run()")
    
except Exception as e:
    print(f"❌ Error: {e}")
    import traceback
    traceback.print_exc()
