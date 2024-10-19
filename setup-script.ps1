#Verifica se usuario e administrador.
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Por favor, execute o script como administrador." -ForegroundColor Red
    exit
}

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
    Install-WindowsUpdate -AcceptAll
    Write-Host "As atualizações foram instaladas e o sistema será reiniciado automaticamente se necessário."
}
else {
    Write-Host "O sistema já está atualizado."
}

# Função para verificar se o winget está instalado
function Is_WingetInstalled {
    try {
        Get-Command winget -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Atualiza o winget caso esteja instalado, caso não, instala e atualiza
if (Is_WingetInstalled) {
    Write-Host "Winget já está instalado. Atualizando Winget..."
    
    # Update winget using winget itself
    winget upgrade --id Microsoft.Winget.Source --silent --accept-package-agreements --accept-source-agreements
    Write-Host "Winget foi atualizado com sucesso."
}
else {
    Write-Host "Winget não está instalado. Instalando Winget..."

    # Baixa e instala o App Installer, que inclui o winget
    Invoke-WebRequest -Uri "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutFile "$env:TEMP\AppInstaller.appx"
    Add-AppxPackage -Path "$env:TEMP\AppInstaller.appx"
    
    Write-Host "Winget foi instalado com sucesso."
}

# Verifica novamente se o winget foi instalado corretamente
if (Is_WingetInstalled) {
    Write-Host "Winget está pronto para ser usado!"
}
else {
    Write-Host "Ocorreu um erro na instalação do Winget."
}

function Detect_DedicatedGPU {
    $gpuInfo = Get-WmiObject win32_VideoController | Where-Object { $_.AdapterDACType -notlike "*Internal*" }
    return $gpuInfo
}

$dedicatedGpu = Detect_DedicatedGPU

# Função para solicitar confirmação de instalação de uma categoria
function Ask_ToInstallCategory {
    param (
        [string]$categoryName
    )

    $response = Read-Host "Deseja instalar os aplicativos da categoria $categoryName? (s/n)"
    if ($response -eq 's') {
        return $true
    }
    else {
        return $false
    }
}

# Verifica se o winget está disponível
if (Get-Command winget -ErrorAction SilentlyContinue) {
   
    # Lista de aplicativos a instalar
    $essentialApps = @(
        "RARLab.WinRAR",
        "Microsoft.VisualStudioCode",
        "Python.Python.3.11",
        "Rufus.Rufus",
        "Google.Chrome",
        "Microsoft.VisualStudioCode",
        "discord.discord"
        "Microsoft.VisualStudio.2022.Community"
    )

    # Instala aplicativos essenciais
    Write-Host "Instalando aplicativos essenciais..."
    foreach ($app in $essentialApps) {
        Write-Host "Instalando $app..."
        winget install --id $app --silent --accept-package-agreements --accept-source-agreements
    }

    $officeDeploymentToolUrl = "https://download.microsoft.com/download/1/7/D/17D1A1CF-46D7-48D9-B39F-1C672F5AAD29/officedeploymenttool_16026-20246.exe"
    $downloadPath = "$env:TEMP\officedeploymenttool.exe"
    $configXmlPath = "$env:TEMP\configuration.xml"

    # Baixar a Ferramenta de Implantação do Office
    Write-Host "Baixando a Ferramenta de Implantação do Office..."
    Invoke-WebRequest -Uri $officeDeploymentToolUrl -OutFile $downloadPath

    # Executar o instalador da Ferramenta de Implantação do Office
    Write-Host "Instalando a Ferramenta de Implantação do Office..."
    Start-Process -FilePath $downloadPath -ArgumentList "/quiet", "/extract:$env:TEMP" -Wait

    

    Write-Host "Criando arquivo de configuração XML..."
    @"
<Configuration>
  <Add OfficeClientEdition="64" Channel="PerpetualVL2021">
    <Product ID="ProPlus2021Volume" PIDKEY="FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH">
      <Language ID="MatchOS" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="OneDrive" />
      <ExcludeApp ID="OneNote" />
      <ExcludeApp ID="Outlook" />
      <ExcludeApp ID="Publisher" />
    </Product>
  </Add>
  <Property Name="SharedComputerLicensing" Value="0" />
  <Property Name="FORCEAPPSHUTDOWN" Value="FALSE" />
  <Property Name="DeviceBasedLicensing" Value="0" />
  <Property Name="SCLCacheOverride" Value="0" />
  <Property Name="AUTOACTIVATE" Value="1" />
  <Updates Enabled="TRUE" />
  <RemoveMSI />
  <AppSettings>
    <User Key="software\microsoft\office\16.0\excel\options" Name="defaultformat" Value="51" Type="REG_DWORD" App="excel16" Id="L_SaveExcelfilesas" />
    <User Key="software\microsoft\office\16.0\powerpoint\options" Name="defaultformat" Value="27" Type="REG_DWORD" App="ppt16" Id="L_SavePowerPointfilesas" />
    <User Key="software\microsoft\office\16.0\word\options" Name="defaultformat" Value="" Type="REG_SZ" App="word16" Id="L_SaveWordfilesas" />
  </AppSettings>
  <Display Level="Full" AcceptEULA="TRUE" />
</Configuration>
"@ | Set-Content -Path $configXmlPath

    # Executar a instalação do Office com a Ferramenta de Implantação
    $odtExecutable = "$env:TEMP\setup.exe"
    Write-Host "Iniciando a instalação do Office LTSC Professional Plus 2021..."
    Start-Process -FilePath $odtExecutable -ArgumentList "/configure", $configXmlPath -Wait

    Write-Host "Instalação do Office LTSC Professional Plus 2021 concluída."

    Write-Host "Aplicativos essenciais instalados."

    $devApps = @(
        "Microsoft.VisualStudioCode",
        "Python.Python.3.11"
    )
    
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

    if ($dedicatedGpu) {
        Write-Host "GPU dedicada detectada. Instalando aplicativos de jogos..."
        $gameApps = @(
            "Valve.Steam",
            "EpicGames.EpicGamesLauncher",
            "ElectronicArts.EADesktop",
            "Ubisoft.Connect"
        )
        
        if (Ask-ToInstallCategory "Games") {
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
    }
    else {
        Write-Host "Nenhuma GPU dedicada detectada. Aplicativos de jogos não serão instalados."
    }
        
    Write-Host "Instalação de aplicativos concluída."
    else 
    {
        Write-Host "Nenhuma GPU dedicada detectada. Aplicativos de jogos não serão instalados."
    }

    Write-Host "Todos os aplicativos foram instalados."
}
else {
    Write-Host "Winget não está instalado ou não foi reconhecido. Instale-o manualmente da Microsoft Store."
}


# Função para detectar GPU NVIDIA
function Detect_Nvidia {
    $gpuInfo = Get-WmiObject win32_VideoController | Where-Object { $_.Description -like "*NVIDIA*" }
    return $gpuInfo
}

# Função para detectar CPU Intel
function Detect_IntelCPU {
    $cpuInfo = Get-WmiObject win32_Processor | Where-Object { $_.Manufacturer -like "*Intel*" }
    return $cpuInfo
}

function Install-NvidiaDriver {
    Write-Host "Detectado GPU NVIDIA. Iniciando a instalação do driver NVIDIA e GeForce Experience..."
    $nvidiaDriverUrl = "https://us.download.nvidia.com/Windows/531.79/531.79-desktop-win10-win11-64bit-international-dch-whql.exe"
    $geforceExperienceUrl = "https://us.download.nvidia.com/GFE/GFEClient/3.26.0.154/GeForce_Experience_v3.26.0.154.exe"
    $nvidiaDriverPath = "$env:TEMP\nvidia-driver.exe"
    $geforceExperiencePath = "$env:TEMP\geforce-experience.exe"

    # Baixar o driver e o GeForce Experience
    Invoke-WebRequest -Uri $nvidiaDriverUrl -OutFile $nvidiaDriverPath
    Invoke-WebRequest -Uri $geforceExperienceUrl -OutFile $geforceExperiencePath

    # Instalar driver NVIDIA
    Write-Host "Instalando o driver NVIDIA..."
    Start-Process -FilePath $nvidiaDriverPath -ArgumentList "/S" -Wait

    # Instalar GeForce Experience
    Write-Host "Instalando GeForce Experience..."
    Start-Process -FilePath $geforceExperiencePath -ArgumentList "/S" -Wait

    Write-Host "Instalação de driver NVIDIA e GeForce Experience concluída."
}

# Função para instalar drivers Intel (com base no processador)
function Install-IntelDriver {
    Write-Host "Detectado CPU Intel. Iniciando a instalação do driver gráfico Intel..."

    # Obter o modelo do processador
    $cpuModel = (Get-WmiObject win32_Processor).Name
    Write-Host "Modelo do processador detectado: $cpuModel"

    # Definir URL para baixar o driver Intel
    # URL genérica da Intel para baixar drivers gráficos
    $intelDriverUrl = "https://downloadmirror.intel.com/784848/igfx_win_101.4311.exe"
    $intelDriverPath = "$env:TEMP\intel-driver.exe"

    # Baixar o driver Intel
    Invoke-WebRequest -Uri $intelDriverUrl -OutFile $intelDriverPath

    # Instalar driver Intel
    Write-Host "Instalando o driver gráfico Intel..."
    Start-Process -FilePath $intelDriverPath -ArgumentList "/quiet /norestart" -Wait

    Write-Host "Instalação do driver gráfico Intel concluída."
}

# Detectar GPU e processador
$nvidiaGpu = Detect-Nvidia
$intelCpu = Detect-IntelCPU

# Condicional para instalação do driver apropriado
if ($nvidiaGpu) {
    Install-NvidiaDriver
}
elseif ($intelCpu) {
    Install-IntelDriver
}
else {
    Write-Host "Nenhuma GPU NVIDIA ou CPU Intel detectada. Nenhuma ação necessária."
}


