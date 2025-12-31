param (
    [string]$Env
)

$port = 5000
$url = "http://localhost:$port/health"

Write-Host "Checking health on $url"

$maxRetries = 10
$retryDelay = 5
$success = $false

for ($i = 1; $i -le $maxRetries; $i++) {
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-Host "Health check PASSED"
            $success = $true
            break
        }
    } catch {
        Write-Host "Attempt $i failed. Retrying in $retryDelay seconds..."
        Start-Sleep -Seconds $retryDelay
    }
}

if (-not $success) {
    Write-Error "Health check FAILED after multiple attempts"
    exit 1
}
