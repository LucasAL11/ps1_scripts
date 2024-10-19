# Windows Setup Automation Script

Este repositório contém um script PowerShell para automatizar a instalação de atualizações, aplicativos essenciais e drivers (Intel/NVIDIA). Ele também gerencia a instalação do Office LTSC Professional Plus 2021 e detecta a presença de GPU dedicada para sugerir softwares de jogos.

## 📋 Recursos
- Verifica se o script está sendo executado como administrador.
- Instala e atualiza o **winget** e **PSWindowsUpdate**.
- Automatiza a instalação de drivers Intel e NVIDIA.
- Detecta GPU dedicada para sugerir a instalação de aplicativos de jogos.
- Permite instalação opcional de aplicativos de desenvolvimento.
- Instalação do **Office LTSC Professional Plus 2021** com configuração personalizada.

## 🛠️ Requisitos
- **Windows 10** ou **Windows 11**.
- Permissões de administrador.
- Conexão com a internet.

## 🚀 Como Usar
1. **Executar como Administrador:**  
   Abra o PowerShell como administrador antes de executar o script.

2. **Executando o Script:**  
   Clone o repositório e execute o script no PowerShell:

   ```powershell
   .\setup-script.ps1
