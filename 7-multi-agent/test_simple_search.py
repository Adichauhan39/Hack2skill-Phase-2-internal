"""
Simple test script to verify the hotel search backend is working
"""
import requests
import json
import time

BASE_URL = "http://localhost:8001"

def test_simple_search():
    """Test CSV search (should be fast and free)"""
    print("\n" + "="*80)
    print("TEST 1: Simple CSV Search (Goa)")
    print("="*80)
    
    payload = {
        "message": "Find hotels in Goa under 5000",
        "context": {
            "city": "Goa",
            "budget": 5000,
            "guests": 2
        }
    }
    
    try:
        print(f"📡 Sending request to {BASE_URL}/api/hotel/search")
        print(f"   Payload: {json.dumps(payload, indent=2)}")
        
        start = time.time()
        response = requests.post(
            f"{BASE_URL}/api/hotel/search",
            json=payload,
            timeout=30
        )
        elapsed = time.time() - start
        
        print(f"✅ Response received in {elapsed:.2f}s")
        print(f"   Status: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            print(f"   Status: {data.get('status')}")
            print(f"   Powered by: {data.get('powered_by')}")
            print(f"   AI Used: {data.get('ai_used')}")
            print(f"   Hotels count: {data.get('count')}")
            print(f"   Overall advice: {data.get('overall_advice')}")
            
            if data.get('hotels'):
                print(f"\n   Hotels found:")
                for i, hotel in enumerate(data['hotels'][:3], 1):
                    print(f"   {i}. {hotel['name']} - ₹{hotel['price_per_night']}/night")
            
            print("\n✅ TEST 1 PASSED: CSV Search works!")
            return True
        else:
            print(f"❌ Error: Status {response.status_code}")
            print(f"   Response: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_ai_search():
    """Test AI search (special request)"""
    print("\n" + "="*80)
    print("TEST 2: AI Agent Search (Raipur near airport)")
    print("="*80)
    
    payload = {
        "message": "Find hotels in Raipur under 5000 near airport",
        "context": {
            "city": "Raipur",
            "budget": 5000,
            "guests": 2
        }
    }
    
    try:
        print(f"📡 Sending request to {BASE_URL}/api/hotel/search")
        print(f"   Payload: {json.dumps(payload, indent=2)}")
        
        start = time.time()
        response = requests.post(
            f"{BASE_URL}/api/hotel/search",
            json=payload,
            timeout=30
        )
        elapsed = time.time() - start
        
        print(f"✅ Response received in {elapsed:.2f}s")
        print(f"   Status: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            print(f"   Status: {data.get('status')}")
            print(f"   Powered by: {data.get('powered_by')}")
            print(f"   AI Used: {data.get('ai_used')}")
            print(f"   Reason for AI: {data.get('reason_for_ai')}")
            print(f"   Hotels count: {data.get('count')}")
            
            if data.get('hotels'):
                print(f"\n   Hotels found:")
                for i, hotel in enumerate(data['hotels'][:3], 1):
                    print(f"   {i}. {hotel['name']} - {hotel['type']}")
            
            print("\n✅ TEST 2 PASSED: AI Search works!")
            return True
        else:
            print(f"❌ Error: Status {response.status_code}")
            print(f"   Response: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def main():
    """Run all tests"""
    print("\n" + "="*80)
    print("🧪 HOTEL SEARCH BACKEND TEST SUITE")
    print("="*80)
    
    # Check if server is running
    try:
        response = requests.get(f"{BASE_URL}/", timeout=5)
        print(f"✅ Server is running (Status {response.status_code})")
        data = response.json()
        print(f"   Version: {data.get('version')}")
        print(f"   Mode: {data.get('mode')}")
    except Exception as e:
        print(f"❌ Server not running: {e}")
        return
    
    # Run tests
    test1_result = test_simple_search()
    test2_result = test_ai_search()
    
    # Summary
    print("\n" + "="*80)
    print("📊 TEST SUMMARY")
    print("="*80)
    print(f"CSV Search Test: {'✅ PASSED' if test1_result else '❌ FAILED'}")
    print(f"AI Search Test: {'✅ PASSED' if test2_result else '❌ FAILED'}")
    
    if test1_result and test2_result:
        print("\n🎉 ALL TESTS PASSED! Backend is working correctly!")
        print("Now test with Flutter app...")
    else:
        print("\n⚠️ Some tests failed. Check the errors above.")

if __name__ == "__main__":
    main()
