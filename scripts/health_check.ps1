param(
    [string]$Env
)

$ErrorActionPreference = "Stop"
Write-Host "Running health check for environment: $Env"

# Get backend container dynamically (matches the name seen in your logs)
$container = docker ps --filter "name=backend" --format "{{.Names}}" | Select-Object -First 1

if (-not $container) {
    Write-Error "Backend container not running"
    exit 1
}

Write-Host "Found Container: $container"

# Get mapped host port for container port 5000
$port = docker inspect --format='{{(index (index .NetworkSettings.Ports "5000/tcp") 0).HostPort}}' $container

if (-not $port) {
    Write-Error "Could not detect mapped port for container port 5000"
    exit 1
}

$targetHost = "localhost"
# FIX: Use ${} to prevent the "Variable reference is not valid" error
Write-Host "Detected port: ${port}. Probing http://${targetHost}:${port}/health"

$maxRetries = 12
$retry = 0

while ($retry -lt $maxRetries) {
    try {
        # FIX: Use ${} here as well
        $response = Invoke-RestMethod -Uri "http://${targetHost}:${port}/health" -TimeoutSec 5 -UseBasicParsing
        
        if ($null -ne $response -and ($response.status -eq "UP" -or $response.Status -eq "UP")) {
            Write-Host "Health check PASSED"
            exit 0
        } else {
            Write-Host "Response received but status is: $($response.status)"
        }
    } catch {
        Write-Host "Attempt $($retry + 1): Waiting for backend to be ready..."
    }

    Start-Sleep -Seconds 5
    $retry++
}

Write-Error "Health check FAILED after $maxRetries retries"
exit 1