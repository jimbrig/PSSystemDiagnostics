# PSSystemDiagnostics

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/jimbrig/PSSystemDiagnostics)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PSSystemDiagnostics.svg)](https://www.powershellgallery.com/packages/PSSystemDiagnostics)
[![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/PSSystemDiagnostics.svg)](https://www.powershellgallery.com/packages/PSSystemDiagnostics)

> [!NOTE]
> *See the [Examples](./Examples/) folder for the resulting diagnostics reports generated!*

Perform comprehensive system diagnostics reporting tasks for Windows systems using PowerShell.

![image](https://github.com/user-attachments/assets/48f917ac-e41d-474e-9da6-d7fc6e087953)

## Overview

PSSystemDiagnostics is a comprehensive PowerShell module designed to provide detailed system analysis and optimization recommendations for Windows environments. It offers a complete suite of diagnostic tools covering system performance, security configuration, installed software analysis, and resource utilization monitoring.

### Key Features

- **🔍 System Analysis**: Comprehensive CPU, memory, disk, and network diagnostics
- **📦 Package Management**: Integration with WinGet, Chocolatey, Scoop, and Microsoft Store
- **🛡️ Security Analysis**: Windows Defender, firewall, and administrator account reporting
- **⚡ Performance Optimization**: Automated recommendations for system improvements
- **🐧 WSL Monitoring**: Windows Subsystem for Linux resource analysis
- **📊 Structured Output**: JSON-formatted reports for integration with other tools
- **🔧 Administrative Tools**: Cache clearing, driver management, and system updates

## Installation

### From PowerShell Gallery (Recommended)

```powershell
Install-Module -Name PSSystemDiagnostics -Scope CurrentUser
```

### From Source

```powershell
git clone https://github.com/jimbrig/PSSystemDiagnostics.git
cd PSSystemDiagnostics
.\build.ps1 -Task Build
Import-Module .\Output\PSSystemDiagnostics
```

## Quick Start

```powershell
# Import the module
Import-Module PSSystemDiagnostics

# Get comprehensive system information
Get-SystemInfo -OutputPath ".\SystemInfo.json"

# Analyze running processes
Get-ProcessAnalysis -OutputPath ".\ProcessAnalysis.json"

# Get optimization recommendations
$systemInfo = Get-SystemInfo
$processAnalysis = Get-ProcessAnalysis
$serviceAnalysis = Get-ServiceAnalysis
Get-OptimizationRecommendations -SystemInfo $systemInfo -ProcessAnalysis $processAnalysis -ServiceAnalysis $serviceAnalysis
```

## Examples

### System Analysis Example

```powershell
# Complete system analysis workflow
$outputFolder = ".\SystemAnalysis"
New-Item -Path $outputFolder -ItemType Directory -Force

# Collect all diagnostic data
$systemInfo = Get-SystemInfo -OutputPath "$outputFolder\SystemInfo.json"
$processAnalysis = Get-ProcessAnalysis -OutputPath "$outputFolder\ProcessAnalysis.json"
$serviceAnalysis = Get-ServiceAnalysis -OutputPath "$outputFolder\ServiceAnalysis.json"
$defenderAnalysis = Get-DefenderAnalysis -OutputPath "$outputFolder\DefenderAnalysis.json"
$wslAnalysis = Get-WSLAnalysis -OutputPath "$outputFolder\WSLAnalysis.json"

# Generate optimization recommendations
$recommendations = Get-OptimizationRecommendations `
    -SystemInfo $systemInfo `
    -ProcessAnalysis $processAnalysis `
    -ServiceAnalysis $serviceAnalysis `
    -OutputPath "$outputFolder\OptimizationRecommendations.json"

Write-Host "Analysis complete! Check $outputFolder for detailed reports."
```

### Package Management Examples

```powershell
# Get all installed packages from different sources
$wingetPackages = Get-WinGetPackages
$chocoPackages = Get-ChocoPackages
$scoopPackages = Get-ScoopPackages
$storeApps = Get-StoreApps

# Generate software report
Get-SoftwareReport -OutputPath ".\SoftwareInventory.json"

# Check for available updates
Get-WinGetPackages -IncludeAvailableUpdates | Where-Object UpdateAvailable
```

### Security Analysis Examples

```powershell
# Security posture assessment
Get-DefenderAnalysis -OutputPath ".\DefenderStatus.json"
Get-FirewallInfo -IncludeRules -OutputPath ".\FirewallConfig.json"
Get-LocalAdministrators -OutputPath ".\AdminAccounts.json"

# System component analysis
Get-SystemComponents -OutputPath ".\SystemComponents.json"
Get-MissingDrivers -OutputPath ".\MissingDrivers.json"
```

## Core Functions

### System Information & Analysis
- **Get-SystemInfo**: Comprehensive system information collection
- **Get-ProcessAnalysis**: Process performance and resource analysis
- **Get-ServiceAnalysis**: Windows service optimization analysis
- **Get-StartupAnalysis**: Startup program analysis and recommendations

### Package Management
- **Get-WinGetPackages**: Windows Package Manager (WinGet) package inventory
- **Get-ChocoPackages**: Chocolatey package management integration
- **Get-ScoopPackages**: Scoop package manager analysis
- **Get-StoreApps**: Microsoft Store application inventory

### Security & Configuration
- **Get-DefenderAnalysis**: Windows Defender status and performance analysis
- **Get-FirewallInfo**: Windows Firewall configuration assessment
- **Get-LocalAdministrators**: Local administrator account inventory
- **Export-Registry**: Registry backup and export utilities

### Performance & Optimization
- **Get-OptimizationRecommendations**: Automated performance optimization suggestions
- **Get-SearchIndexerAnalysis**: Windows Search indexer performance analysis
- **Get-WSLAnalysis**: Windows Subsystem for Linux resource monitoring
- **Remove-OldDrivers**: Driver cleanup and management

### Utilities & Maintenance
- **Clear-NugetCache**: NuGet cache cleanup
- **Update-PSHelp**: PowerShell help system updates
- **Update-StoreApps**: Microsoft Store application updates
- **Show-ComputerBanner**: System information display

## Requirements

- **PowerShell**: 5.1 or later
- **Operating System**: Windows 10/11 (some functions require Windows 10 1903+)
- **Permissions**: Administrator privileges recommended for complete functionality
- **Dependencies**: Automatically managed through module manifest

## Contributing

Contributions are welcome! Please read our [Contributing Guidelines](./docs/CONTRIBUTING.md) and [Code of Conduct](./CODE_OF_CONDUCT.md).

### Development Setup

```powershell
# Clone the repository
git clone https://github.com/jimbrig/PSSystemDiagnostics.git
cd PSSystemDiagnostics

# Install development dependencies
.\build.ps1 -Bootstrap

# Run tests
.\build.ps1 -Task Test

# Build module
.\build.ps1 -Task Build
```

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## Support

- 📖 **Documentation**: [Module Help](./docs/)
- 🐛 **Issues**: [GitHub Issues](https://github.com/jimbrig/PSSystemDiagnostics/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/jimbrig/PSSystemDiagnostics/discussions)
- 📧 **Contact**: [jimmy.briggs@jimbrig.com](mailto:jimmy.briggs@jimbrig.com)

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for release history and updates.
