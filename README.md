# 🚀 SRP Win Toolbox

**SRP Win Toolbox** is a Windows-native PowerShell GUI toolkit designed for **gamers, esports players, tournament competitors, and power users**.

It provides safe and reversible Windows optimization utilities that help improve system responsiveness by optimizing network settings, managing unnecessary background services, and enhancing overall Windows performance.

> **Supported Platform:** Windows 10 & Windows 11
> **Built With:** PowerShell + Windows Forms
> **License:** GPL-2.0

---

## ✨ Features

### 🌐 SRP Network & Smart DNS Tweaker

Optimize Windows networking for gaming and everyday use.

* Disable Nagle's Algorithm (TCP Delay)
* Optimize Network Throttling Index
* Automatic DNS Benchmark
* Smart DNS Selection
* Supports:

  * Cloudflare DNS
  * Google DNS
  * Quad9 DNS
  * AdGuard DNS
* One-click Restore to DHCP

---

### 🎮 SRP Tournament & Gaming Service Tweaker

Reduce unnecessary background services for better gaming performance.

Features include:

* Disable Windows Telemetry
* Disable MapsBroker
* Optional SysMain Control
* Optional Windows Search Control
* Optional Biometric Service Control
* One-click Restore to Default

---

## 🛡 Safety

The toolkit only changes Windows configuration settings.

It **does not**:

* Modify Windows system files
* Install third-party software
* Run background processes after closing
* Permanently disable Windows features

All supported changes can be restored using the built-in restore options.

---

## ⚡ Quick Run

Launch **PowerShell** and execute one of the following commands.

### 🌐 Network Tweaker

```powershell
comein soom
```

### 🎮 Service Tweaker

```powershell
comein soom
```

> **Important:** Only execute remote PowerShell scripts from sources you trust. Administrator permission is required because the toolkit modifies Windows networking and service settings.

---

## 📁 Repository Structure

```text
SRP-Win-Toolbox/
│
├── DNS_Tweaker.ps1
├── Service_Tweaker.ps1
├── README.md
└── LICENSE
```

---

## 🚀 Getting Started

### Method 1

1. Download the desired PowerShell script.
2. Right-click the file.
3. Select **Run with PowerShell**.
4. Accept the UAC prompt.
5. Configure your preferred settings.
6. Click **Apply**.

### Method 2

Run directly using one of the Quick Run commands above.

---

## 🔄 Restore Default Settings

### Network

Click:

```text
RESTORE DEFAULT (DHCP)
```

to restore Windows network settings.

### Services

Select all available services and click:

```text
ENABLE SELECTED
```

to restore Windows default service configuration.

---

## 🎨 User Interface

* Windows Native GUI
* Cyberpunk Dark Theme
* Segoe UI Font
* High-DPI Friendly
* Automatic Administrator Elevation
* Automatic Execution Policy Handling

---

## ⚠ Disclaimer

This software is provided **"as is"** without warranty of any kind.

Performance improvements may vary depending on:

* Hardware
* Windows Version
* Network Environment
* Internet Service Provider (ISP)
* Installed Drivers
* Individual Applications and Games

Creating a **Windows System Restore Point** before applying changes is recommended.

---

## 📜 License

This project is licensed under the **GNU General Public License v2.0 (GPL-2.0)**.

You may use, modify, and distribute this software under the terms of the GPL-2.0 License.

See the **LICENSE** file for complete license details.

---

## ❤️ Developed by SRP Team

**Built for Competitive Gaming • Esports • High-Performance Windows**

⭐ If you find this project useful, consider giving it a **Star** on GitHub.
