param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev","staging","prod")]
    [string]$Env
)

switch ($Env) {
    "dev"     { $port = 5000 }
    "staging" { $port = 5001 }
    "prod"    { $port = 5002 }
}

Write-Host "Checking health on port $port"

try {
    $response = Invoke-WebRequest "http://localhost:$port/health" -UseBasicParsing
    if ($response.Content -match "UP") {
        Write-Host "Health check PASSED"
        exit 0
    } else {
        Write-Error "Health check FAILED"
        exit 1
    }
}
catch {
    Write-Error "Health check FAILED"
    exit 1
}
