🚀 SRP Win Toolbox
==================

**SRP Win Toolbox** is a Windows-native PowerShell & Batch GUI toolkit designed for **gamers, esports players, tournament competitors, and power users**.It provides safe and reversible Windows optimization utilities that help improve system responsiveness by optimizing network settings, managing unnecessary background services, enhancing overall Windows performance, safely removing pre-installed bloatware, and keeping your files clean and organized.

> **Supported Platform:** Windows 10 & Windows 11**Built With:** PowerShell + Windows Forms + Windows Batch**License:** GPL-2.0

## 📋 Table of Contents

- [Key Features](#-features)
  - [Universal File Organizer (Optimal File Manager)](#-universal-file-organizer-optimal-file-manager)
  - [SRP Network & Smart DNS Tweaker](#-srp-network--smart-dns-tweaker)
  - [SRP Tournament & Gaming Service Tweaker](#-srp-tournament--gaming-service-tweaker)
  - [SRP Debloater](#️-srp-debloater)
- [Safety](#-safety)
- [Quick Run & Usage](#-quick-run)
- [Repository Structure](#-repository-structure)
- [User Interface](#-user-interface)
- [Disclaimer](#-disclaimer)
- [Developed by Raihan kaif (RPG.py)](https://www.instagram.com/raihan_kaif)
    

✨ Features
----------

### 📁 Universal File Organizer (Optimal File Manager)

An intelligent, highly optimized multi-category batch file manager for messy directories.

*   **Smart Category Detection:** Automatically sorts files into 14+ organized categories (Images, Videos, Documents, Archives, Code, Executables, 3D Design, etc.) covering over 200+ file extensions.
    
*   **Existing Folder Reuse Logic:** Intelligently checks for and reuses existing custom folders (e.g., Photos, Pictures, Music, Docs, Image) without duplicating directories.
    
*   **Conditional Folder Creation:** Creates new category folders only when matching files actually exist in the target directory (no empty folders).
    
*   **User Confirmation Prompt:** Prompts the user to securely confirm execution (Press 'Y' to Start Organizing, or 'N' to Cancel).
    
*   **Safe Operations:** Never overwrites files with identical names and leaves existing sub-directories completely untouched.
    

### 🌐 SRP Network & Smart DNS Tweaker

Optimize Windows networking for gaming and everyday use.

*   Disable Nagle's Algorithm (TCP Delay)
    
*   Optimize Network Throttling Index
    
*   Automatic DNS Benchmark
    
*   Smart DNS Selection
    
*   Supports: Cloudflare, Google, Quad9, AdGuard DNS
    

### 🎮 SRP Tournament & Gaming Service Tweaker

Reduce unnecessary background services for better gaming performance.

*   Disable Windows Telemetry & MapsBroker
    
*   Optional SysMain, Windows Search, and Biometric Service Control
    
*   One-click Restore to Default
    

### 🗑️ SRP Debloater

**New!** Safely remove unnecessary Windows pre-installed applications.

*   Sleek Dark Mode UI (Cyberpunk style)
    
*   **1-Click Bloatware Selection:** Pre-configured list for junk apps (Xbox, Bing, 3D Builder, etc.)
    
*   Safe uninstallation with built-in error handling
    
*   Lightweight and dependency-free
    

🛡 Safety
---------

The toolkit only changes Windows configuration settings and manages local files. It **does not** modify Windows system files or install third-party software. All changes are reversible via the built-in restore options.

## ⚡ Quick Run

### 1. Universal File Organizer (.bat)

Run or drag-and-drop a folder onto `UniversalFileOrganizer.bat`, then press **Y** when prompted.

### 2. PowerShell Tweakers (.ps1)

Launch **PowerShell** as Administrator and execute the following commands:

```powershell
# SRP Debloater
.\SRP_Debloater.ps1

# Network Tweaker
.\DNS_Tweaker.ps1

# Service Tweaker
.\Service_Tweaker.ps1
```
> **Note:** Administrator permission is required to modify system settings.

---



## 📁 Repository Structure



```text

SRP-Win-Toolbox/

│

├── DNS_Tweaker.ps1       # Network & DNS Optimization

├── Service_Tweaker.ps1   # Service Optimization

├── SRP_Debloater.ps1     # App Uninstaller

├── UniversalFileOrganizer.bat  # Smart Multi-Category File Organizer

├── README.md             # Project Documentation

└── LICENSE               # GPL-2.0 License

```



---

🚀 Getting Started
------------------

1.  Download the scripts from this repository.
    
2.  Right-click the desired script (e.g., SRP\_Debloater.ps1 or UniversalFileOrganizer.bat).
    
3.  Select **Run with PowerShell** or double-click the Batch script.
    
4.  Accept the UAC prompt if required (Administrator permission).
    
5.  Configure your settings and click **Apply**, **Uninstall**, or confirm with **Y**.
    

🎨 User Interface
-----------------

*   **Design:** Windows Native GUI with Cyberpunk Dark Theme (Black & Orange).
    
*   **Experience:** High-DPI friendly and professional layout.
    

⚠ Disclaimer
------------

This software is provided **"as is"**. Creating a **Windows System Restore Point** before applying changes is recommended.

❤️ Developed by Raihan kaif
---------------------------

**Built for Competitive Gaming • Esports • High-Performance Windows**⭐ If you find this project useful, consider giving it a **Star** on GitHub.
