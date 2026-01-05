param(
    [string]$Env = "dev"
)

Write-Host "Running health check for environment: $Env"

# Map ENV → PORT
switch ($Env) {
    "dev"     { $PORT = 5000 }
    "staging" { $PORT = 5001 }
    "prod"    { $PORT = 5002 }
    default {
        Write-Host "Invalid ENV value"
        exit 1
    }
}

$URL = "http://localhost:$PORT/health"

Write-Host "Checking URL: $URL"

$retries = 10
$delay = 5

for ($i = 1; $i -le $retries; $i++) {
    try {
        $response = Invoke-RestMethod -Uri $URL -TimeoutSec 5
        if ($response.status -eq "UP") {
            Write-Host "Health check PASSED for $Env"
            exit 0
        }
    }
    catch {
        Write-Host "Attempt $i failed, retrying in $delay seconds..."
        Start-Sleep -Seconds $delay
    }
}

Write-Host "Health check FAILED for $Env"
exit 1
