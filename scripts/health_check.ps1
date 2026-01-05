param(
    [string]$Env
)

$ErrorActionPreference = "Stop"

Write-Host "Running health check for environment: $Env"

# Map env to port
switch ($Env) {
    "dev"     { $port = 5000 }
    "staging" { $port = 5001 }
    "prod"    { $port = 5002 }
    default {
        Write-Error "Invalid environment: $Env"
        exit 1
    }
}

$targetHost = "localhost"
$url = "http://$targetHost:$port/health"

Write-Host "Probing $url"

$maxRetries = 12
$retry = 0

while ($retry -lt $maxRetries) {
    try {
        $response = Invoke-RestMethod -Uri $url -TimeoutSec 5 -UseBasicParsing

        if ($response.status -eq "UP") {
            Write-Host "Health check PASSED for $Env"
            exit 0
        } else {
            Write-Host "Service responding but not UP"
        }
    } catch {
        Write-Host "Attempt $($retry + 1): Service not ready"
    }

    Start-Sleep -Seconds 5
    $retry++
}

Write-Error "Health check FAILED for $Env"
exit 1
