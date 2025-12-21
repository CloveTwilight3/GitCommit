![Chocolatey Version](https://img.shields.io/chocolatey/v/gitcommit)

## Installation

### Option 1: Chocolatey (Recommended)
```bash
choco install gitcommit
```

### Option 2: Download Installer
1. Download the latest `GitCommit-Setup.exe` from [Releases](https://github.com/CloveTwilight3/GitCommit/releases)
2. Run as administrator
3. Follow the installation wizard

### Option 3: Manual PowerShell Install
1. Clone this repository
2. Run `installers/powershell/Install-GitCommit.ps1` as administrator

## Usage
1. Open a terminal in any Git repository
2. Run: `GitCommit`
3. Enter your commit message when prompted

## Uninstallation
- **Chocolatey**: `choco uninstall gitcommit`
- **Installer**: Use Windows Add/Remove Programs
- **Manual**: Run `Uninstall-GitCommit.ps1` from installation directory

## Building from Source
```bash
# Build Chocolatey package
.\build\build-chocolatey.ps1

# Build installer (requires NSIS)
.\build\build-installer.ps1
```

## Contributors
<a href="https://github.com/CloveTwilight3/GitCommit/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=CloveTwilight3/GitCommit" />
</a>

