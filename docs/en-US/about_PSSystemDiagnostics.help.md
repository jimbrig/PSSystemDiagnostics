# PSSystemDiagnostics

## about_PSSystemDiagnostics

# SHORT DESCRIPTION
PSSystemDiagnostics provides comprehensive Windows system diagnostics and optimization recommendations through PowerShell cmdlets.

# LONG DESCRIPTION
The PSSystemDiagnostics module offers a complete suite of tools for analyzing Windows system performance, security configuration, installed software, and resource utilization. It includes functions for:

- System information gathering and reporting
- Process and service analysis
- Package manager integration (WinGet, Chocolatey, Scoop)
- Windows Defender and firewall analysis
- WSL (Windows Subsystem for Linux) monitoring
- Performance optimization recommendations
- Registry and system component analysis

## Key Features
- **Comprehensive Analysis**: Covers CPU, memory, disk, and network diagnostics
- **Package Management**: Support for WinGet, Chocolatey, Scoop, and Store apps
- **Security Analysis**: Windows Defender, firewall, and local administrator reporting
- **Performance Optimization**: Automated recommendations for system improvements
- **JSON Output**: Structured data output for integration with other tools
- **Administrative Tasks**: Utilities for cache clearing, driver management, and updates

## Primary Functions
- Get-SystemInfo: Comprehensive system information gathering
- Get-ProcessAnalysis: Process performance and resource analysis
- Get-ServiceAnalysis: Windows service optimization analysis
- Get-OptimizationRecommendations: Automated performance recommendations
- Get-DefenderAnalysis: Windows Defender configuration analysis
- Get-WSLAnalysis: Windows Subsystem for Linux monitoring

# EXAMPLES

```powershell
# Get comprehensive system information
Get-SystemInfo -OutputPath ".\SystemInfo.json"

# Analyze running processes for optimization opportunities
Get-ProcessAnalysis -OutputPath ".\ProcessAnalysis.json"

# Get optimization recommendations based on system analysis
Get-OptimizationRecommendations -ProcessAnalysis $processData -ServiceAnalysis $serviceData -SystemInfo $systemData

# Check Windows Defender status and performance impact
Get-DefenderAnalysis -OutputPath ".\DefenderAnalysis.json"

# Analyze WSL resource usage
Get-WSLAnalysis -OutputPath ".\WSLAnalysis.json"

# Get installed packages from multiple package managers
Get-WinGetPackages | Format-Table Name, Version, Source
Get-ChocoPackages | Format-Table Name, Version
Get-ScoopPackages | Format-Table Name, Version, Status
```

# NOTE
This module requires PowerShell 5.1 or later. Some functions require administrative privileges for complete data collection. Administrative functions will display warnings when not running as administrator.

# TROUBLESHOOTING NOTE
If you encounter permission errors, ensure PowerShell is running as Administrator for functions that require elevated privileges. Some antivirus software may flag system analysis activities - add exclusions if necessary.

# SEE ALSO
- Get-Help Get-SystemInfo
- Get-Help Get-ProcessAnalysis
- Get-Help Get-OptimizationRecommendations
- Project Repository: https://github.com/jimbrig/PSSystemDiagnostics

# KEYWORDS
{{List alternate names or titles for this topic that readers might use.}}

- {{ Keyword Placeholder }}
- {{ Keyword Placeholder }}
- {{ Keyword Placeholder }}
- {{ Keyword Placeholder }}
