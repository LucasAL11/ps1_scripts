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
$nvidiaGpu = Detect_Nvidia
$intelCpu = Detect_IntelCPU

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