# 🌀 psx-profile
psx-profile is a fully-custom, extensible PowerShell 7 profile designed to enhance your terminal experience with session logging, a clean visual banner, helpful aliases, custom theming, and future workflow improvements. Built to be modular, fast, and easy to install with just one command.

---

![License](https://img.shields.io/badge/license-MIT-green.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-7%2B-blue)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)
![Status](https://img.shields.io/badge/status-Stable-brightgreen)

---

## 📥 Installation

Just run this command in PowerShell 7:

```powershell
irm "https://raw.githubusercontent.com/<USER>/<REPO>/main/install.ps1" | iex
```

This installer will:

* Install **Oh My Posh** (if missing)
* Download the official **Paradox** theme
* Create your PowerShell profile directory (if needed)
* Install the latest PowerShell profile
* Automatically reload your environment

---

## ✨ Features

### 🔹 Custom Logging

Every PowerShell session is logged automatically
(JSON logs stored in `%LOCALAPPDATA%\PS7Logs`).

### 🔹 Dynamic Welcome Banner

Gradient text, machine info, last sessions summary.

### 🔹 Aliases & Productivity Boost

Custom aliases (e.g. `pwsh-logs`, `trae`) and more.

### 🔹 Oh My Posh Integration

Beautiful prompt using **Paradox** theme.

### 🔹 Clean, Modular, Extensible

The profile is designed to grow with future features.

---

## 🔄 Update to the Latest Version

```powershell
pwsh -NoLogo -Command "irm 'https://raw.githubusercontent.com/<USER>/<REPO>/main/update.ps1' | iex"
```

---

## 🧹 Uninstall

```powershell
pwsh -NoLogo -Command "irm 'https://raw.githubusercontent.com/<USER>/<REPO>/main/uninstall.ps1' | iex"
```

---

## 📂 Repository Structure

```
psx-profile/
│
├── install.ps1
├── Microsoft.PowerShell_profile.ps1
└── README.md
```

---

## 🛠 Requirements

* Windows 10/11
* PowerShell 7+
* Internet connection (for themes & installer)

---

## 📸 Screenshots

<img width="1181" height="665" alt="image" src="https://github.com/user-attachments/assets/9465c2aa-e81a-4ba9-b4fb-75903c029360" />
<img width="1118" height="631" alt="image" src="https://github.com/user-attachments/assets/6e4e8008-a9da-4cc7-a296-e1dcbc69d19a" />


---

## 📄 License

MIT License.

---
