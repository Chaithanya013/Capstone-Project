param([string]$Env)
$ErrorActionPreference = "Stop"
Write-Host "Running health check for environment: $Env"

# Dynamically find the backend container name
$container = docker ps --filter "name=backend" --format "{{.Names}}" | Select-Object -First 1
if (-not $container) {
    Write-Error "Backend container not running"
    exit 1
}
Write-Host "Found Container: $container"

# Detect host port mapped to container port 5000 (detected as 5001 in your case)
$port = docker inspect --format='{{(index (index .NetworkSettings.Ports "5000/tcp") 0).HostPort}}' $container
if (-not $port) {
    Write-Error "Could not detect mapped port for container port 5000"
    exit 1
}

$targetHost = "localhost"
# FIX: Using ${} ensures PowerShell reads the variable correctly before the colon
Write-Host "Detected port: ${port}. Probing http://${targetHost}:${port}/health"

$maxRetries = 10
$retry = 0
while ($retry -lt $maxRetries) {
    try {
        $response = Invoke-RestMethod -Uri "http://${targetHost}:${port}/health" -TimeoutSec 5 -UseBasicParsing
        if ($null -ne $response -and ($response.status -eq "UP" -or $response.Status -eq "UP")) {
            Write-Host "Health check PASSED"
            exit 0
        }
    } catch {
        Write-Host "Attempt $($retry + 1): Backend not ready yet..."
    }
    Start-Sleep -Seconds 5
    $retry++
}
Write-Error "Health check FAILED after $maxRetries retries"
exit 1