param (
    [string]$Env = "dev"
)

Write-Host "Running health check for environment: $Env"

# Port mapping based on environment
if ($Env -eq "dev") {
    $PORT = 5000
}
elseif ($Env -eq "staging") {
    $PORT = 5001
}
elseif ($Env -eq "prod") {
    $PORT = 5002
}
else {
    Write-Host "Unknown environment"
    exit 1
}

$URL = "http://localhost:$PORT/health"

$MAX_RETRIES = 10
$SLEEP_SECONDS = 5
$attempt = 1

while ($attempt -le $MAX_RETRIES) {
    Write-Host "Health check attempt $attempt..."

    try {
        $response = Invoke-RestMethod -Uri $URL -TimeoutSec 5
        if ($response.status -eq "UP") {
            Write-Host "Health check PASSED"
            exit 0
        }
    }
    catch {
        Write-Host "Service not ready yet..."
    }

    Start-Sleep -Seconds $SLEEP_SECONDS
    $attempt++
}

Write-Host "Health check FAILED after retries"
exit 1
