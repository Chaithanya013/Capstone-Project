param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("dev", "staging", "prod")]
    [string]$Env
)

$ErrorActionPreference = "Stop"

Write-Host "Running health check for ENV=$Env"

# Explicit port mapping per environment
switch ($Env) {
    "dev"     { $port = 5000 }
    "staging" { $port = 5001 }
    "prod"    { $port = 5002 }
}

$healthUrl = "http://localhost:$port/health"
Write-Host "Health URL: $healthUrl"

$maxRetries = 12
$retryDelay = 5

for ($i = 1; $i -le $maxRetries; $i++) {
    try {
        $response = Invoke-RestMethod -Uri $healthUrl -TimeoutSec 5 -UseBasicParsing

        if ($response.status -eq "UP") {
            Write-Host "✅ Health check PASSED for $Env"
            exit 0
        }

        Write-Host "Attempt $i: Status received but not UP"
    }
    catch {
        Write-Host "Attempt $i: Service not ready yet"
    }

    Start-Sleep -Seconds $retryDelay
}

Write-Error "❌ Health check FAILED for $Env after retries"
exit 1
