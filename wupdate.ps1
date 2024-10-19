# Instala modulo do windows e importa 
Write-Host "Iniciando modulo do Windows update para powershell."
Install-Module PSWindowsUpdate -Force -SkipPublisherCheck
Import-Module PSWindowsUpdate

# Verifica se há atualizações
Write-Host "Verificando por atualizações disponíveis..."
$updates = Get-WindowsUpdate

# Se houver atualizações, instala
if ($updates) {
    Write-Host "Instalando atualizações..."
    Install-WindowsUpdate -AcceptAll -NoRestart
    Write-Host "As atualizações foram instaladas e o sistema será reiniciado automaticamente se necessário."
}
else {
    Write-Host "O sistema já está atualizado."
}