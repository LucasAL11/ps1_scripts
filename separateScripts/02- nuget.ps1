# Verifica se o winget está disponível
if (Get-Command winget -ErrorAction SilentlyContinue) {
    # (seu código existente para instalar aplicativos essenciais)

    # Verifica se o NuGet está instalado
    function Is_NuGetInstalled {
        try {
            Get-Command nuget -ErrorAction Stop | Out-Null
            return $true
        }
        catch {
            return $false
        }
    }

    # Instala NuGet se não estiver instalado
    if (-not (Is_NuGetInstalled)) {
        Write-Host "NuGet não está instalado. Instalando NuGet..."
        winget install --id NuGet.NuGetCLI --silent --accept-package-agreements --accept-source-agreements
        Write-Host "NuGet instalado com sucesso."
    } else {
        Write-Host "NuGet já está instalado."
    }
}
