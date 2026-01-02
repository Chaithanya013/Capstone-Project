param(
    [string]$Env
)

if ($Env -eq "dev") { $port = 5000 }
elseif ($Env -eq "staging") { $port = 5001 }
elseif ($Env -eq "prod") { $port = 5002 }

Write-Host "Checking backend health on port $port"

$maxRetries = 10
$retry = 0

while ($retry -lt $maxRetries) {
    try {
        $response = Invoke-RestMethod "http://localhost:$port/health" -TimeoutSec 5
        if ($response.status -eq "UP") {
            Write-Host "Health check PASSED"
            exit 0
        }
    } catch {
        Write-Host "Waiting for service..."
    }

    Start-Sleep -Seconds 5
    $retry++
}

Write-Error "Health check FAILED"
exit 1
