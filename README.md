# Windows Setup Automation Script

This repository contains a PowerShell script to automate the installation of updates, essential apps, and drivers (Intel/NVIDIA). It also handles the installation of Office LTSC Professional Plus 2021 and detects dedicated GPUs to suggest gaming software.

## 📋 Features
- Verifies if the script is running as **administrator**.
- Installs and updates **winget** and **PSWindowsUpdate**.
- Automates Intel and NVIDIA driver installation.
- Detects dedicated GPU to suggest gaming apps.
- Allows optional installation of development tools.
- Installs **Office LTSC Professional Plus 2021** with custom configuration.

## 🛠️ Requirements
- **Windows 10** or **Windows 11**.
- Administrator privileges.
- Internet connection.

## 🚀 How to Use
1. **Run as Administrator:**  
   Open PowerShell as administrator before executing the script.

2. **Running the Script:**  
   Clone the repository and run the script in PowerShell:

   ```powershell
   .\setup-script.ps1
