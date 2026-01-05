param(
    [string]$Env
)

$ErrorActionPreference = "Stop"

Write-Host "Running health check for environment: $Env"

$container = docker ps --filter "name=backend" --format "{{.Names}}" | Select-Object -First 1

if (-not $container) {
    Write-Error "Backend container not running"
    exit 1
}

$port = docker inspect --format='{{(index (index .NetworkSettings.Ports "5000/tcp") 0).HostPort}}' $container

$maxRetries = 12
$retry = 0

while ($retry -lt $maxRetries) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:$port/health" -TimeoutSec 5 -UseBasicParsing
        if ($response.status -eq "UP") {
            Write-Host "Health check PASSED"
            exit 0
        }
    } catch {
        Write-Host "Attempt $($retry + 1): Service not ready yet"
    }

    Start-Sleep -Seconds 5
    $retry++
}

Write-Error "Health check FAILED"
exit 1
