# Define nova URL para baixar a Ferramenta de Implantação do Office
$officeDeploymentToolUrl = "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_17830-20162.exe"
$downloadPath = "$env:TEMP\officedeploymenttool.exe"
$configXmlPath = "$env:TEMP\configuration.xml"

# Baixar a Ferramenta de Implantação do Office
Write-Host "Baixando a Ferramenta de Implantação do Office..."
Invoke-WebRequest -Uri $officeDeploymentToolUrl -OutFile $downloadPath

# Verificar se o download foi bem-sucedido
if (-Not (Test-Path $downloadPath)) {
    Write-Host "Erro: O arquivo de download não foi encontrado. Verifique o link."
    exit
}

# Executar o instalador da Ferramenta de Implantação do Office
Write-Host "Instalando a Ferramenta de Implantação do Office..."
Start-Process -FilePath $downloadPath -ArgumentList "/quiet", "/extract:$env:TEMP" -Wait

# Verificar se o executável de instalação foi extraído corretamente
$odtExecutable = "$env:TEMP\setup.exe"
if (-Not (Test-Path $odtExecutable)) {
    Write-Host "Erro: O executável de instalação não foi encontrado após extração."
    exit
}

# Criando o arquivo de configuração XML para a instalação do Office LTSC Professional Plus 2021
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
Write-Host "Iniciando a instalação do Office LTSC Professional Plus 2021..."
Start-Process -FilePath $odtExecutable -ArgumentList "/configure", $configXmlPath -Wait

Write-Host "Instalação do Office LTSC Professional Plus 2021 concluída."
