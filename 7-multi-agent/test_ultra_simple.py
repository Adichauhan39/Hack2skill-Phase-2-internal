import requests
import time

BASE_URL = "http://localhost:8001"

print("\n" + "="*60)
print("ULTRA-SIMPLE SERVER TEST")
print("="*60)

# Test 1: Server status
print("\n1️⃣ Testing server status...")
try:
    r = requests.get(f"{BASE_URL}/", timeout=5)
    print(f"✅ Server OK: {r.json()}")
except Exception as e:
    print(f"❌ Server error: {e}")
    exit(1)

# Test 2: CSV search
print("\n2️⃣ Testing CSV search (Goa, ₹5000)...")
try:
    start = time.time()
    r = requests.post(
        f"{BASE_URL}/api/hotel/search",
        json={
            'message': 'Find hotels in Goa',
            'context': {'city': 'Goa', 'budget': 5000}
        },
        timeout=10
    )
    elapsed = time.time() - start
    data = r.json()
    print(f"⏱️  Time: {elapsed:.2f}s")
    print(f"✅ Result: {data['powered_by']} - {data['count']} hotels")
    if data['hotels']:
        print(f"   - {data['hotels'][0]['name']}: ₹{data['hotels'][0]['price_per_night']}")
except Exception as e:
    print(f"❌ Error: {e}")

# Test 3: AI search
print("\n3️⃣ Testing AI search (special request)...")
try:
    start = time.time()
    r = requests.post(
        f"{BASE_URL}/api/hotel/search",
        json={
            'message': 'Find luxury beach hotels near airport in Mumbai',
            'context': {'city': 'Mumbai', 'budget': 10000}
        },
        timeout=15
    )
    elapsed = time.time() - start
    data = r.json()
    print(f"⏱️  Time: {elapsed:.2f}s")
    print(f"✅ Result: {data['powered_by']} - {data['count']} hotels")
    if data['hotels']:
        print(f"   - {data['hotels'][0]['name']}: ₹{data['hotels'][0].get('price_per_night', 'N/A')}")
except Exception as e:
    print(f"❌ Error: {e}")

print("\n" + "="*60)
print("✅ ALL TESTS COMPLETE")
print("="*60 + "\n")
