# Start AI Server
Write-Host "Starting AI Hotel Search Server..." -ForegroundColor Cyan

$serverPath = "c:\Hack2skill\Hack2skill finale\7-multi-agent"
$scriptPath = "simple_ai_server.py"

# Start server
$process = Start-Process -FilePath "python" -ArgumentList $scriptPath -WorkingDirectory $serverPath -WindowStyle Normal -PassThru

Write-Host "Server starting in PID: $($process.Id)" -ForegroundColor Green
Write-Host "Waiting for server..." -ForegroundColor Yellow
Start-Sleep -Seconds 6

# Test
$test = Invoke-RestMethod -Uri "http://localhost:8001/" -Method Get
Write-Host "Server is RUNNING!" -ForegroundColor Green
Write-Host "Model: $($test.model)" -ForegroundColor Gray
