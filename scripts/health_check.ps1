param(
    [string]$Env
)

# 1. Force errors to be caught by the try/catch block
$ErrorActionPreference = "Stop"

Write-Host "Running health check for environment: $Env"

# Get backend container dynamically
$container = docker ps --filter "name=backend" --format "{{.Names}}" | Select-Object -First 1

if (-not $container) {
    Write-Error "Backend container not running"
    exit 1
}

# 2. Improved Port Detection 
# Added a check to see if the port 5000 is actually mapped
try {
    $port = docker inspect --format='{{(index (index .NetworkSettings.Ports "5000/tcp") 0).HostPort}}' $container
} catch {
    Write-Error "Port 5000 is not mapped to the host. Check your docker-compose or run command."
    exit 1
}

# 3. Determine Hostname (Local vs Remote)
# If Jenkins is on a different machine than the container, replace 'localhost'
$targetHost = "localhost" 
Write-Host "Detected port: $port. Probing http://$targetHost:$port/health"

$maxRetries = 12 # Increased to 1 minute total (12 * 5s)
$retry = 0

while ($retry -lt $maxRetries) {
    try {
        # Added -UseBasicParsing for Jenkins compatibility
        $response = Invoke-RestMethod -Uri "http://$targetHost:$port/health" -TimeoutSec 5 -UseBasicParsing
        
        # Check if response is null or status isn't "UP"
        if ($null -ne $response -and ($response.status -eq "UP" -or $response.Status -eq "UP")) {
            Write-Host "Health check PASSED"
            exit 0
        } else {
            Write-Host "Response received but status is: $($response.status)"
        }
    } catch {
        $ex = $_.Exception.Message
        Write-Host "Attempt $($retry + 1): Backend not ready ($ex)"
    }

    Start-Sleep -Seconds 5
    $retry++
}

Write-Error "Health check FAILED after $maxRetries retries"
exit 1