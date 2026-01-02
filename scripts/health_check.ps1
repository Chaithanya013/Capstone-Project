param (
    [string]$Env = "dev"
)

Write-Host "Running health check for environment: $Env"

# Decide port based on environment
switch ($Env) {
    "dev"     { $PORT = 5000 }
    "staging" { $PORT = 5001 }
    "prod"    { $PORT = 5002 }
    default {
        Write-Error "Invalid environment: $Env"
        exit 1
    }
}

$URL = "http://localhost:$PORT/health"
$MAX_RETRIES = 10
$SLEEP_TIME = 5

for ($i = 1; $i -le $MAX_RETRIES; $i++) {
    try {
        Write-Host "Attempt $i: Checking $URL"
        $response = Invoke-WebRequest -Uri $URL -UseBasicParsing -TimeoutSec 5

        if ($response.StatusCode -eq 200) {
            Write-Host "Health check PASSED for $Env"
            exit 0
        }
    }
    catch {
        Write-Host "Service not ready yet. Retrying in $SLEEP_TIME seconds..."
    }

    Start-Sleep -Seconds $SLEEP_TIME
}

Write-Error "Health check FAILED for $Env after $MAX_RETRIES attempts"
exit 1
