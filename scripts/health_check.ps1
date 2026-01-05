param (
    [string]$Env
)

Write-Host "Running health check for environment: $Env"

# Map backend ports per environment
switch ($Env) {
    "dev"     { $PORT = 5000 }
    "staging" { $PORT = 5001 }
    "prod"    { $PORT = 5002 }
    default {
        Write-Error "Unknown environment: $Env"
        exit 1
    }
}

$URL = "http://localhost:$PORT/health"
Write-Host "Checking backend health at $URL"

$MAX_RETRIES = 12
$SLEEP_SECONDS = 5

for ($i = 1; $i -le $MAX_RETRIES; $i++) {
    try {
        $response = Invoke-RestMethod -Uri $URL -Method Get -TimeoutSec 5
        if ($response.status -eq "UP") {
            Write-Host "✅ Health check PASSED for $Env"
            exit 0
        }
    } catch {
        Write-Host "⏳ Attempt $i/$MAX_RETRIES failed, retrying..."
    }
    Start-Sleep -Seconds $SLEEP_SECONDS
}

Write-Error "Health check FAILED for $Env after retries"
exit 1
