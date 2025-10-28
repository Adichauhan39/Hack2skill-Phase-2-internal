# Test Flutter App Connection to AI Backend
Write-Host "=== Testing AI Backend Connection ===" -ForegroundColor Cyan
Write-Host ""

# 1. Check if server is running
Write-Host "1. Checking if server is running on port 8001..." -ForegroundColor Yellow
$serverCheck = netstat -ano | findstr "8001"
if ($serverCheck) {
    Write-Host "   ✓ Server is running!" -ForegroundColor Green
    Write-Host "   $serverCheck" -ForegroundColor Gray
} else {
    Write-Host "   ✗ Server is NOT running!" -ForegroundColor Red
    Write-Host "   Run: python 7-multi-agent\test_ai_complete.py" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# 2. Test root endpoint
Write-Host "2. Testing root endpoint..." -ForegroundColor Yellow
try {
    $root = Invoke-RestMethod -Uri "http://localhost:8001/" -Method Get
    Write-Host "   ✓ Root endpoint works!" -ForegroundColor Green
    Write-Host "   Status: $($root.status)" -ForegroundColor Gray
    Write-Host "   Model: $($root.model)" -ForegroundColor Gray
} catch {
    Write-Host "   ✗ Root endpoint failed: $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 3. Test AI search endpoint
Write-Host "3. Testing AI search endpoint..." -ForegroundColor Yellow
try {
    $body = @{
        message = "romantic hotel with spa"
        context = @{
            city = "Goa"
            budget = 25000
        }
    } | ConvertTo-Json

    $result = Invoke-RestMethod -Uri "http://localhost:8001/api/hotel/search" `
        -Method Post `
        -Body $body `
        -ContentType "application/json"
    
    Write-Host "   ✓ AI search works!" -ForegroundColor Green
    Write-Host "   Status: $($result.status)" -ForegroundColor Gray
    Write-Host "   Hotels found: $($result.count)" -ForegroundColor Gray
    Write-Host "   Location: $($result.location)" -ForegroundColor Gray
    Write-Host "   Powered by: $($result.powered_by)" -ForegroundColor Gray
    
    Write-Host ""
    Write-Host "   Top 3 Hotels:" -ForegroundColor Cyan
    foreach ($hotel in $result.hotels | Select-Object -First 3) {
        Write-Host "   - $($hotel.name): $($hotel.match_score) match" -ForegroundColor White
        Write-Host "     Price: Rs.$($hotel.price_per_night) | Rating: $($hotel.rating)" -ForegroundColor Gray
    }
} catch {
    Write-Host "   ✗ AI search failed: $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 4. Check Flutter app config
Write-Host "4. Checking Flutter app config..." -ForegroundColor Yellow
$configFile = "flutter_travel_app\lib\config\app_config.dart"
if (Test-Path $configFile) {
    $content = Get-Content $configFile -Raw
    if ($content -match "localhost:8001") {
        Write-Host "   ✓ Flutter config points to correct port (8001)" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Flutter config has wrong port!" -ForegroundColor Red
        Write-Host "   Update baseUrl to: http://localhost:8001" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "   ✗ Config file not found!" -ForegroundColor Red
    exit 1
}
Write-Host ""

Write-Host "=== ALL TESTS PASSED! ===" -ForegroundColor Green
Write-Host ""
Write-Host "Your AI backend is ready! Now test in Flutter app:" -ForegroundColor Cyan
Write-Host "1. Select Goa as city" -ForegroundColor White
Write-Host "2. Set budget to 25000 rupees" -ForegroundColor White
Write-Host "3. Click AI-Powered Search button" -ForegroundColor White
Write-Host "4. Wait 3-5 seconds for AI results" -ForegroundColor White
Write-Host ""
