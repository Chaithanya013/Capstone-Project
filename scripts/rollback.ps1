param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev","staging","prod")]
    [string]$Env
)

$composeFile = "docker-compose.$Env.yml"

Write-Host "Rolling back environment: $Env"

docker compose -f $composeFile down --remove-orphans
docker compose -f $composeFile up -d

Write-Host "Rollback completed for $Env"
