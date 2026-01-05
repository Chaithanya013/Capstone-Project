param(
    [Parameter(Mandatory = $true)]
    [string]$Env
)

$ErrorActionPreference = "Stop"

Write-Host "Starting health check for ENV = $Env"

# FIXED, EXPLICIT PORT MAPPING (NO MAGIC)
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
    Write-Error "Invalid ENV value: $Env"
    exit 1
}

$URL = "http://localhost:$PORT/health"
Write-Host "Health check URL: $URL"

$MAX_RETRIES = 15
$SLEEP = 4

for ($i = 1; $i -le $MAX_RETRIES; $i++) {
    try {
        $response = Invoke-RestMethod -Uri $URL -TimeoutSec 5 -UseBasicParsing

        if ($response.status -eq "UP") {
            Write-Host "✅ HEALTH CHECK PASSED for $Env"
            exit 0
        }
        else {
            Write-Host "Attempt $i: Service responded but status not UP"
        }
    }
    catch {
        Write-Host "Attempt $i: Backend not ready yet"
    }

    Start-Sleep -Seconds $SLEEP
}

Write-Error "❌ HEALTH CHECK FAILED for $Env after retries"
exit 1
