param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev","staging","prod")]
    [string]$Env
)

$composeFile = "docker-compose.$Env.yml"

Write-Host "Deploying environment: $Env"
Write-Host "Using compose file: $composeFile"

docker compose -f $composeFile down --remove-orphans
docker compose -f $composeFile up -d --build

Write-Host "Deployment completed for $Env"
