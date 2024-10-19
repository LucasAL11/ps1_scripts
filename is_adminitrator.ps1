If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Por favor, execute o script como administrador." -ForegroundColor Red
    exit
}

Write-Host "administrador" -ForegroundColor Green