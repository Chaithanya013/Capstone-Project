param(
    [string]$Env
)

Write-Host "Running health check for environment: $Env"

# Get backend container dynamically
$container = docker ps --filter "name=backend" --format "{{.Names}}" | Select-Object -First 1

if (-not $container) {
    Write-Error "Backend container not running"
    exit 1
}

Write-Host "Backend container: $container"

# Get mapped host port for container port 5000
$port = docker inspect `
    --format='{{(index (index .NetworkSettings.Ports "5000/tcp") 0).HostPort}}' `
    $container

if (-not $port) {
    Write-Error "Could not detect mapped port"
    exit 1
}

Write-Host "Detected backend port: $port"

# Retry logic (important for staging/prod)
$maxRetries = 10
$retry = 0

while ($retry -lt $maxRetries) {
    try {
        $response = Invoke-RestMethod "http://localhost:$port/health" -TimeoutSec 5

        if ($response.status -eq "UP") {
            Write-Host "Health check PASSED"
            exit 0
        }
    } catch {
        Write-Host "Waiting for backend to be ready..."
    }

    Start-Sleep -Seconds 5
    $retry++
}

Write-Error "Health check FAILED after retries"
exit 1
