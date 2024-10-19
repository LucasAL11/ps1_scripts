# Função para verificar se o App Installer está instalado
function Is_AppInstallerInstalled {
    try {
        Get-AppxPackage *AppInstaller* -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Função para verificar se já existe uma versão mais recente instalada
function Is_NewerVersionInstalled {
    $packageName = "Microsoft.VCLibs.140.00.UWPDesktop"
    $currentVersion = (Get-AppxPackage -Name "*$packageName*" -ErrorAction SilentlyContinue).Version
    $newVersion = [version]"14.0.33321.0"

    if ($currentVersion -ge $newVersion) {
        return $true
    } else {
        return $false
    }
}

# Função para instalar ou atualizar o App Installer
function InstallOrUpdate_AppInstaller {
    # URL para baixar o App Installer diretamente da Microsoft
    $installerUrl = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
    $installerPath = "$env:TEMP\AppInstaller.appx"
    
    # Verificar se uma versão mais recente já está instalada
    if (Is_NewerVersionInstalled) {
        Write-Host "Uma versão mais recente do App Installer já está instalada. Nenhuma ação necessária."
        return
    }

    # Baixar o instalador do App Installer
    Write-Host "Baixando o Instalador de Aplicativos (App Installer)..."
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
    
    # Instalar o App Installer
    Write-Host "Instalando ou atualizando o App Installer..."
    Add-AppxPackage -Path $installerPath
    
    Write-Host "O App Installer foi instalado ou atualizado com sucesso."
}

# Verifica se o App Installer está instalado e atualiza ou instala se necessário
if (-not (Is_AppInstallerInstalled)) {
    Write-Host "O App Installer não está instalado. Instalando..."
    InstallOrUpdate_AppInstaller
} else {
    Write-Host "O App Installer já está instalado. Verificando a necessidade de atualização..."
    InstallOrUpdate_AppInstaller
}

# Verifica se o App Installer foi instalado corretamente
if (Is_AppInstallerInstalled) {
    Write-Host "O App Installer está pronto para uso!"
} else {
    Write-Host "Ocorreu um erro na instalação ou atualização do App Installer."
}
