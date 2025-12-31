param (
    [string]$Env
)

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

Write-Host "Checking health on $URL"

$maxAttempts = 10
$attempt = 1

while ($attempt -le $maxAttempts) {
    try {
        $response = Invoke-WebRequest -Uri $URL -UseBasicParsing -TimeoutSec 3
        if ($response.StatusCode -eq 200) {
            Write-Host "Health check PASSED"
            exit 0
        }
    } catch {
        Write-Host "Attempt $attempt failed. Retrying in 5 seconds..."
    }

    Start-Sleep -Seconds 5
    $attempt++
}

Write-Error "Health check FAILED after multiple attempts"
exit 1
