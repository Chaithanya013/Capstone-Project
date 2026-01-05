param (
    [string]$Env
)

Write-Host "Running health check for environment: $Env"

# Get backend container name dynamically
$container = docker ps --filter "name=backend" --format "{{.Names}}" | Select-Object -First 1

if (-not $container) {
    Write-Error "Backend container not found"
    exit 1
}

Write-Host "Backend container: $container"

# Get mapped host port for container port 5000
$portInfo = docker port $container 5000/tcp

if (-not $portInfo) {
    Write-Error "Backend port not exposed"
    exit 1
}

$PORT = ($portInfo -split ":")[1]
$URL = "http://localhost:$PORT/health"

Write-Host "Health check URL: $URL"

$MAX_RETRIES = 12
$SLEEP = 5

for ($i = 1; $i -le $MAX_RETRIES; $i++) {
    try {
        $response = Invoke-RestMethod -Uri $URL -TimeoutSec 5
        if ($response.status -eq "UP") {
            Write-Host "Health check PASSED"
            exit 0
        }
    } catch {
        Write-Host "Attempt $i failed, retrying..."
    }
    Start-Sleep -Seconds $SLEEP
}

Write-Error "Health check FAILED"
exit 1
