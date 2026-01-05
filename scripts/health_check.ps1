param (
    [string]$Env = "dev"
)

Write-Host "Running health check for environment: $Env"

# -------- ENV → PORT MAPPING --------
switch ($Env) {
    "dev"     { $PORT = 5000 }
    "staging" { $PORT = 5001 }
    "prod"    { $PORT = 5002 }
    default {
        Write-Host "Invalid environment: $Env"
        exit 1
    }
}

$URL = "http://localhost:$PORT/health"
$MAX_RETRIES = 10
$SLEEP = 5

Write-Host "Health check URL: $URL"

for ($i = 1; $i -le $MAX_RETRIES; $i++) {
    try {
        $response = Invoke-RestMethod -Uri $URL -Method GET -TimeoutSec 5
        if ($response.status -eq "UP") {
            Write-Host "Health check PASSED"
            exit 0
        }
    }
    catch {
        Write-Host "Attempt $i failed. Retrying in $SLEEP seconds..."
        Start-Sleep -Seconds $SLEEP
    }
}

Write-Host "Health check FAILED after $MAX_RETRIES attempts"
exit 1
