# Simple AI Backend Test
Write-Host "=== Testing AI Backend ===" -ForegroundColor Cyan

# Test server
Write-Host "`n1. Testing server on port 8001..." -ForegroundColor Yellow
$serverCheck = netstat -ano | findstr "8001"
if ($serverCheck) {
    Write-Host "   Server is RUNNING" -ForegroundColor Green
} else {
    Write-Host "   Server is NOT running!" -ForegroundColor Red
    exit 1
}

# Test AI endpoint
Write-Host "`n2. Testing AI search..." -ForegroundColor Yellow
$body = @{message="romantic hotel"; context=@{city="Goa"; budget=25000}} | ConvertTo-Json
$result = Invoke-RestMethod -Uri "http://localhost:8001/api/hotel/search" -Method Post -Body $body -ContentType "application/json"

Write-Host "   Status: $($result.status)" -ForegroundColor Green
Write-Host "   Hotels found: $($result.count)" -ForegroundColor Green
Write-Host "   Model: $($result.powered_by)" -ForegroundColor Green

Write-Host "`n=== Backend is WORKING! ===" -ForegroundColor Green
Write-Host "`nNow test in your Flutter app!" -ForegroundColor Cyan
