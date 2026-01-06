param(
    [string]$Env
)

$ErrorActionPreference = "Stop"

Write-Host "Running health check for environment: $Env"

# Map environment to host port
switch ($Env) {
    "dev"     { $port = 5000 }
    "staging" { $port = 5001 }
    "prod"    { $port = 5002 }
    default {
        Write-Error "Unknown environment: $Env"
        exit 1
    }
}

$url = "http://localhost:$port/health"
Write-Host "Checking $url"

$maxRetries = 12
$retry = 0

while ($retry -lt $maxRetries) {
    try {
        $response = Invoke-RestMethod -Uri $url -TimeoutSec 5

        if ($response.status -eq "UP") {
            Write-Host "Health check PASSED for $Env"
            exit 0
        } else {
            Write-Host "Service responded but status is $($response.status)"
        }
    } catch {
        Write-Host "Attempt $($retry + 1): Service not ready yet"
    }

    Start-Sleep -Seconds 5
    $retry++
}

Write-Error "Health check FAILED for $Env"
exit 1

