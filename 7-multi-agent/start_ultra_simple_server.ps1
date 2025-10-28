# Ultra-Simple Hotel Search Server Launcher
# Run this script to start the backend on port 8001

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  ULTRA-SIMPLE HOTEL SEARCH BACKEND" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Navigate to backend directory
Set-Location "c:\Hack2skill\Hack2skill finale\7-multi-agent"

Write-Host "📍 Current directory: $(Get-Location)" -ForegroundColor Yellow
Write-Host ""

# Check if port 8001 is already in use
Write-Host "🔍 Checking port 8001..." -ForegroundColor Yellow
$portCheck = netstat -ano | findstr :8001
if ($portCheck) {
    Write-Host "⚠️  Port 8001 is already in use!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Running processes on port 8001:" -ForegroundColor Red
    Write-Host $portCheck -ForegroundColor Red
    Write-Host ""
    $response = Read-Host "Kill existing process and restart? (y/n)"
    if ($response -eq "y") {
        $pid = $portCheck.Split()[4]
        Write-Host "Killing process $pid..." -ForegroundColor Yellow
        taskkill /PID $pid /F
        Start-Sleep -Seconds 2
    } else {
        Write-Host "Cancelled. Exiting." -ForegroundColor Red
        exit
    }
}

Write-Host "✅ Port 8001 is free" -ForegroundColor Green
Write-Host ""

# Verify data file exists
if (-not (Test-Path "data/hotels_india.csv")) {
    Write-Host "❌ Error: Data file not found at data/hotels_india.csv" -ForegroundColor Red
    Write-Host "Cannot start server without hotel database" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Data file found" -ForegroundColor Green

# Verify ultra_simple_server.py exists
if (-not (Test-Path "ultra_simple_server.py")) {
    Write-Host "❌ Error: Server file not found" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🚀 Starting Backend Server..." -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Server will be available at: http://localhost:8001" -ForegroundColor Cyan
Write-Host "📝 Logs will appear below" -ForegroundColor Cyan
Write-Host "⏹️  Press Ctrl+C to stop the server" -ForegroundColor Cyan
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Start the server
python ultra_simple_server.py

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "✅ Server Stopped" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
