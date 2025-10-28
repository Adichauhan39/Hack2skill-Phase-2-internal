# Quick Start - AI Hotel Search Demo
# This script starts both the AI backend and gives instructions for Flutter

Write-Host "`n" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  AI-POWERED HOTEL SEARCH - QUICK START" -ForegroundColor Cyan
Write-Host "  Google Gemini 2.0 Flash + Flutter Integration" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "`n"

# Step 1: Start Python AI Server
Write-Host "[1/3] Starting AI Backend Server..." -ForegroundColor Yellow
Write-Host "      Server: http://127.0.0.1:8001" -ForegroundColor Gray
Write-Host "      Model: Google Gemini 2.0 Flash`n" -ForegroundColor Gray

$scriptPath = Join-Path $PSScriptRoot "7-multi-agent\test_ai_complete.py"

# Start server in background
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\7-multi-agent' ; python test_ai_complete.py"

Write-Host "      Server starting in new window...`n" -ForegroundColor Green
Start-Sleep -Seconds 3

# Step 2: Instructions for Flutter
Write-Host "[2/3] Flutter App Setup" -ForegroundColor Yellow
Write-Host "      Run these commands in a new terminal:`n" -ForegroundColor Gray
Write-Host "      cd flutter_travel_app" -ForegroundColor White
Write-Host "      flutter run`n" -ForegroundColor White

# Step 3: Usage Instructions
Write-Host "[3/3] How to Test AI Search" -ForegroundColor Yellow
Write-Host "      1. Open the Flutter app" -ForegroundColor Gray
Write-Host "      2. Navigate to 'Search Hotels'" -ForegroundColor Gray
Write-Host "      3. Select a city (e.g., Goa)" -ForegroundColor Gray
Write-Host "      4. Click the purple 'AI-Powered Search' button" -ForegroundColor Gray
Write-Host "      5. See intelligent recommendations!`n" -ForegroundColor Gray

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  READY! AI Backend is running" -ForegroundColor Green
Write-Host "  Now start your Flutter app and test the AI search!" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "`n"

Write-Host "Press Ctrl+C in the Python server window to stop it." -ForegroundColor Yellow
Write-Host "`n"
