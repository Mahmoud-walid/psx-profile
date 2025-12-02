# 🌀 psx-profile

**psx-profile** is a production-ready, cross-platform PowerShell 7 profile designed to supercharge your terminal. It brings robust session logging, a beautiful prompt via Oh My Posh, useful utility commands, and a built-in CLI manager to keep everything updated.

Built to be **fast**, **safe** (thread-safe logging), and **easy to install**.

---

![License](https://img.shields.io/badge/license-MIT-green.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-7.2%2B-blue)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey)
[![PSX CI](https://github.com/Mahmoud-walid/psx-profile/actions/workflows/pester.yml/badge.svg)](https://github.com/Mahmoud-walid/psx-profile/actions/workflows/pester.yml)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://github.com/Mahmoud-walid/psx-profile/pulls)
![Last Commit](https://img.shields.io/github/last-commit/Mahmoud-walid/psx-profile)

---

## 🚀 Installation

### Windows

Run this command in PowerShell 7:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; irm "https://raw.githubusercontent.com/Mahmoud-walid/psx-profile/main/installer.ps1" | iex
```

### Linux / macOS

**Step 1: Install PowerShell (if missing)**

- **macOS (via Homebrew):**
  ```bash
  brew install powershell/tap/powershell
  ```
- **Linux (Ubuntu/Debian):**
  ```bash
  sudo apt-get update && sudo apt-get install -y powershell
  ```
  _(For other distros, see the [Microsoft Guide](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux))_

**Step 2: Run the Installer**

```bash
pwsh -c "irm 'https://raw.githubusercontent.com/Mahmoud-walid/psx-profile/main/installer.ps1' | iex"
```

> **Note:** The installer will automatically setup **Oh My Posh**, download the theme, and configure your profile.

---

## ⚡ Important: Fonts

This profile uses **Oh My Posh** with the _Paradox_ theme. To see icons correctly (instead of rectangles `[]`), you **must** install a "Nerd Font".

1. Download and install **[Cascadia Code NF](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip)** (or any Nerd Font).
2. Set it as your terminal font in Windows Terminal, VSCode, or your preferred emulator.

---

## 🎮 The `psx` CLI Manager

This profile comes with a built-in command `psx` to manage your environment easily.

| Command           | Alias    | Description                                                         |
| :---------------- | :------- | :------------------------------------------------------------------ |
| `psx -status`     | `psx -s` | View profile paths, version, and last 3 sessions.                   |
| `psx -update`     | `psx -u` | Update the profile script from GitHub.                              |
| `psx -pwshupdate` | `psx -p` | Check and install the latest PowerShell 7 version (Cross-platform). |
| `psx -clearlogs`  | `psx -d` | Clear the session log history.                                      |
| `psx -remove`     | `psx -r` | Uninstall psx-profile, themes, and logs.                            |
| `psx -help`       | `psx -h` | Show help menu.                                                     |

---

## ✨ Key Features

### 📊 Advanced Session Logging

Every session is logged to a JSON file with thread-safety (using Mutex to prevent conflicts when multiple tabs are open).

- View logs: `Get-PowerShell7-Open-Logs` (or alias `pwsh-logs`).
- Location: `%LOCALAPPDATA%\PS7Logs` (Windows) or `~/.local/share/PS7Logs` (Linux/macOS).

### 📂 Folder Tree Visualization

Use the built-in `Show-FolderTree` command to visualize directories.

```powershell
Show-FolderTree -Path . -IgnoreFolders node_modules,.git,bin
```

### 🎨 Beautiful Terminal

- **Dynamic Banner:** Shows user, machine, and time with a gradient effect.
- **Oh My Posh:** Pre-configured with the `Paradox` theme.

---

## 🛠 Requirements

- **PowerShell 7+** (The installer can update this for you).
- **Nerd Font** installed (Recommended: _Cascadia Code NF_ or _MesloLGS NF_).
- **Internet Connection** (For initial install and updates).

---

## 📂 File Structure

The profile creates the following structure:

```text
# Windows
Documents/PowerShell/Microsoft.PowerShell_profile.ps1
AppData/Local/PS7Logs/ps7_open_logs.json
AppData/Local/oh-my-posh-themes/paradox.omp.json

# Linux / macOS
~/.config/powershell/Microsoft.PowerShell_profile.ps1
~/.local/share/PS7Logs/ps7_open_logs.json
~/.local/share/oh-my-posh-themes/paradox.omp.json
```

---

## 📸 Screenshots

<img width="1181" height="665" alt="image" src="https://github.com/user-attachments/assets/9465c2aa-e81a-4ba9-b4fb-75903c029360" />
<img width="1118" height="631" alt="image" src="https://github.com/user-attachments/assets/6e4e8008-a9da-4cc7-a296-e1dcbc69d19a" />

---

## 🤝 Contributing

Pull requests are welcome!

1. Fork the repo.
2. Create a feature branch.
3. Submit a PR.

## 📄 License

MIT License.
