# Função para verificar a compatibilidade do hardware para Hyper-V
function Check_HyperVHardwareCompatibility {
    $cpuInfo = Get-WmiObject Win32_Processor
    $firmwareSupport = systeminfo | Select-String -Pattern "Hyper-V"

    # Verifica se o processador suporta virtualização assistida por hardware (Intel VT-x ou AMD-V)
    if ($cpuInfo.VirtualizationFirmwareEnabled -eq $true) {
        Write-Host "Virtualização assistida por hardware está habilitada no firmware (BIOS)."
    }
    else {
        Write-Host "Virtualização assistida por hardware NÃO está habilitada no firmware (BIOS). Verifique as configurações da BIOS e habilite a virtualização." -ForegroundColor Yellow
        return $false
    }

    # Verifica se o processador suporta SLAT (Second Level Address Translation)
    if ($cpuInfo.SecondLevelAddressTranslationExtensions -eq $true) {
        Write-Host "O processador suporta SLAT (Second Level Address Translation)."
    }
    else {
        Write-Host "O processador NÃO suporta SLAT. Hyper-V requer um processador com SLAT." -ForegroundColor Red
        return $false
    }

    # Verifica suporte de DEP (Data Execution Prevention)
    if ($firmwareSupport -like "*Prevenção de execução de dados disponível: Sim*") {
        Write-Host "DEP (Prevenção de execução de dados) está habilitada."
    }
    else {
        Write-Host "DEP (Prevenção de execução de dados) NÃO está habilitada. Verifique as configurações do sistema." -ForegroundColor Yellow
        return $false
    }

    # Verifica suporte de Modo Monitor de Máquina Virtual (VMM)
    if ($firmwareSupport -like "*Monitor de Máquina Virtual: Sim*") {
        Write-Host "Modo de Monitor de Máquina Virtual está disponível."
    }
    else {
        Write-Host "Modo de Monitor de Máquina Virtual NÃO está disponível. Hyper-V requer esse modo." -ForegroundColor Red
        return $false
    }

    # Se todas as verificações forem positivas
    return $true
}

# Verifica se o hardware suporta Hyper-V
$compatibility = Check_HyperVHardwareCompatibility

if ($compatibility) {
    Write-Host "O hardware é compatível com Hyper-V. Prosseguindo com a verificação de configurações do Windows..."
    
    # Função para verificar se o Hyper-V está habilitado no Windows
    function Is_HyperVEnabled {
        $feature = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
        return $feature.State -eq "Enabled"
    }

    # Verificar se o Hyper-V está ativado no Windows
    if (Is_HyperVEnabled) {
        Write-Host "Hyper-V já está habilitado no Windows."
    }
    else {
        Write-Host "Hyper-V não está habilitado no Windows. Habilitando Hyper-V..."
        # Habilitar Hyper-V no Windows
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All -NoRestart
        Write-Host "Hyper-V foi habilitado. Reinicie o sistema para concluir a ativação."
    }
} else {
    Write-Host "O hardware não é compatível com Hyper-V ou algumas configurações do BIOS estão incorretas. Verifique as mensagens acima."
}
