function Ask_ToInstallCategory {
    param (
        [string]$categoryName
    )

    $response = Read-Host "Deseja instalar os aplicativos da categoria $categoryName ? (s/n)"
    if ($response -eq 's') {
        return $true
    }
    else {
        return $false
    }
}

if (Get-Command winget -ErrorAction SilentlyContinue) {
   
    # Lista de aplicativos a instalar
    $essentialApps = @(
        "RARLab.WinRAR",
        "Rufus.Rufus",
        "Google.Chrome"
    )

    $devApps = @(
        "Microsoft.VisualStudioCode",
        "Python.Python.3.11"
        "Microsoft.VisualStudio.2022.Community"
        "Microsoft.VisualStudioCode",
        "Microsoft.VisualStudioCode",
        "Python.Python.3.11"
    )

    $gameApps = @(
        "Valve.Steam",
        "EpicGames.EpicGamesLauncher",
        "ElectronicArts.EADesktop",
        "Ubisoft.Connect"
        "discord.discord"
    )

    # Instala aplicativos essenciais
    Write-Host "Instalando aplicativos essenciais..."
    foreach ($app in $essentialApps) {
        Write-Host "Instalando $app..."
        winget install --id $app --silent --accept-package-agreements --accept-source-agreements
    }

    #     $officeDeploymentToolUrl = "https://download.microsoft.com/download/1/7/D/17D1A1CF-46D7-48D9-B39F-1C672F5AAD29/officedeploymenttool_16026-20246.exe"
    #     $downloadPath = "$env:TEMP\officedeploymenttool.exe"
    #     $configXmlPath = "$env:TEMP\configuration.xml"

    #     # Baixar a Ferramenta de Implantação do Office
    #     Write-Host "Baixando a Ferramenta de Implantação do Office..."
    #     Invoke-WebRequest -Uri $officeDeploymentToolUrl -OutFile $downloadPath

    #     # Executar o instalador da Ferramenta de Implantação do Office
    #     Write-Host "Instalando a Ferramenta de Implantação do Office..."
    #     Start-Process -FilePath $downloadPath -ArgumentList "/quiet", "/extract:$env:TEMP" -Wait

    

    #     Write-Host "Criando arquivo de configuração XML..."
    #     @"
    # <Configuration>
    #   <Add OfficeClientEdition="64" Channel="PerpetualVL2021">
    #     <Product ID="ProPlus2021Volume" PIDKEY="FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH">
    #       <Language ID="MatchOS" />
    #       <ExcludeApp ID="Access" />
    #       <ExcludeApp ID="Lync" />
    #       <ExcludeApp ID="OneDrive" />
    #       <ExcludeApp ID="OneNote" />
    #       <ExcludeApp ID="Outlook" />
    #       <ExcludeApp ID="Publisher" />
    #     </Product>
    #   </Add>
    #   <Property Name="SharedComputerLicensing" Value="0" />
    #   <Property Name="FORCEAPPSHUTDOWN" Value="FALSE" />
    #   <Property Name="DeviceBasedLicensing" Value="0" />
    #   <Property Name="SCLCacheOverride" Value="0" />
    #   <Property Name="AUTOACTIVATE" Value="1" />
    #   <Updates Enabled="TRUE" />
    #   <RemoveMSI />
    #   <AppSettings>
    #     <User Key="software\microsoft\office\16.0\excel\options" Name="defaultformat" Value="51" Type="REG_DWORD" App="excel16" Id="L_SaveExcelfilesas" />
    #     <User Key="software\microsoft\office\16.0\powerpoint\options" Name="defaultformat" Value="27" Type="REG_DWORD" App="ppt16" Id="L_SavePowerPointfilesas" />
    #     <User Key="software\microsoft\office\16.0\word\options" Name="defaultformat" Value="" Type="REG_SZ" App="word16" Id="L_SaveWordfilesas" />
    #   </AppSettings>
    #   <Display Level="Full" AcceptEULA="TRUE" />
    # </Configuration>
    # "@ | Set-Content -Path $configXmlPath

    # # Executar a instalação do Office com a Ferramenta de Implantação
    # $odtExecutable = "$env:TEMP\setup.exe"
    # Write-Host "Iniciando a instalação do Office LTSC Professional Plus 2021..."
    # Start-Process -FilePath $odtExecutable -ArgumentList "/configure", $configXmlPath -Wait

    # Write-Host "Instalação do Office LTSC Professional Plus 2021 concluída."

    Write-Host "Aplicativos essenciais instalados."

   
    
    if (Ask_ToInstallCategory "DEV") {
        Write-Host "Instalando aplicativos de desenvolvimento..."
        foreach ($app in $devApps) {
            Write-Host "Instalando $app..."
            winget install --id $app --silent --accept-package-agreements --accept-source-agreements
        }
        Write-Host "Aplicativos de desenvolvimento instalados."
    }
    else {
        Write-Host "Instalação de aplicativos de desenvolvimento ignorada."
    }

        
    if (Ask_ToInstallCategory "Games") {
        Write-Host "Instalando aplicativos de jogos..."
        foreach ($app in $gameApps) {
            Write-Host "Instalando $app..."
            winget install --id $app --silent --accept-package-agreements --accept-source-agreements
        }

        # Instala Battle.net
        $battleNetInstaller = "$env:TEMP\BattleNetInstaller.exe"
        Write-Host "Baixando instalador do Battle.net..."
        Invoke-WebRequest -Uri "https://www.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe" -OutFile $battleNetInstaller
        Write-Host "Instalando Battle.net..."
        Start-Process -FilePath $battleNetInstaller -ArgumentList "/S" -Wait  # "/S" for silent installation
        Write-Host "Battle.net foi instalado."
            
        # Instala Rockstar Games Social Club
        $rockstarInstaller = "$env:TEMP\RockstarInstaller.exe"
        Write-Host "Baixando instalador do Rockstar Games Social Club..."
        Invoke-WebRequest -Uri "https://gamedownloads.rockstargames.com/public/installer/Rockstar-Games-Launcher.exe" -OutFile $rockstarInstaller
        Write-Host "Instalando Rockstar Games Social Club..."
        Start-Process -FilePath $rockstarInstaller -ArgumentList "/S" -Wait  # "/S" for silent installation
        Write-Host "Rockstar Games Social Club foi instalado."
            
            
        Write-Host "Aplicativos de jogos instalados."
    }
    else {
        Write-Host "Instalação de aplicativos de jogos ignorada."
    }
   
        
    Write-Host "Instalação de aplicativos concluída."
    
    Write-Host "Todos os aplicativos foram instalados."
}
else {
    Write-Host "Winget não está instalado ou não foi reconhecido. Instale-o manualmente da Microsoft Store."
}

