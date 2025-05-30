#Requires -Modules Microsoft.PowerShell.PSResourceGet

<#
.SYNOPSIS
    Install build dependencies using PSResourceGet (modern approach)
.DESCRIPTION
    This script installs the required modules for building PSSystemDiagnostics using PSResourceGet
    instead of the older PowerShellGet/PSDepend approach.
#>

[CmdletBinding()]
param(
    [switch]$Force
)

$requiredModules = @(
    @{ Name = 'Pester'; Version = '5.5.0' }
    @{ Name = 'psake'; Version = 'latest' }
    @{ Name = 'BuildHelpers'; Version = 'latest' }
    @{ Name = 'PowerShellBuild'; Version = 'latest' }
    @{ Name = 'PSScriptAnalyzer'; Version = 'latest' }
    @{ Name = 'PlatyPS'; Version = 'latest' }
)

Write-Host "Checking build dependencies..." -ForegroundColor Cyan

foreach ($module in $requiredModules) {
    $installed = Get-InstalledPSResource -Name $module.Name -ErrorAction SilentlyContinue

    if (-not $installed -or $Force) {
        Write-Host "Installing $($module.Name)..." -ForegroundColor Yellow

        $installParams = @{
            Name = $module.Name
            Repository = 'PSGallery'
            Scope = 'CurrentUser'
            TrustRepository = $true
        }

        if ($module.Version -ne 'latest') {
            $installParams.Version = $module.Version
        }

        Install-PSResource @installParams
    } else {
        Write-Host "$($module.Name) is already installed." -ForegroundColor Green
    }
}

Write-Host "All dependencies are ready!" -ForegroundColor Green
