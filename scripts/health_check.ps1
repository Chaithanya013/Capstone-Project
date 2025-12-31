param (
    [string]$Env
)

if ($Env -eq "prod") {
    Write-Host "Running health check INSIDE backend container (prod)"
    docker exec capstone-ci-cd-project-backend-1 curl -f http://localhost:5000/health
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Health check FAILED inside container"
        exit 1
    }
    Write-Host "Health check PASSED inside container"
    exit 0
}

# dev / staging
$url = "http://localhost:5000/health"
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
