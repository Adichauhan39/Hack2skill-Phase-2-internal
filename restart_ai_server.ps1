# Restart AI Server
Write-Host "Stopping existing AI server on port 8001..." -ForegroundColor Yellow

# Find and kill process on port 8001
$port = 8001
$processId = (Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue).OwningProcess
if ($processId) {
    Stop-Process -Id $processId -Force
    Write-Host "Stopped process $processId" -ForegroundColor Green
    Start-Sleep -Seconds 2
} else {
    Write-Host "No process found on port $port" -ForegroundColor Gray
}

# Start new server
Write-Host "Starting AI server..." -ForegroundColor Cyan
$serverPath = "c:\Hack2skill\Hack2skill finale\7-multi-agent"

Start-Process -FilePath "python" `
    -ArgumentList "simple_ai_server.py" `
    -WorkingDirectory $serverPath `
    -WindowStyle Normal

Write-Host "AI Server restarted!" -ForegroundColor Green
Write-Host "Server URL: http://localhost:8001" -ForegroundColor Cyan
