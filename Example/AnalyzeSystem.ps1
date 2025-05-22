#Requires -Version 5.1
#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Comprehensive Windows 11 system analysis and optimization tool.
.DESCRIPTION
    This script analyzes various aspects of a Windows 11 system including processes,
    services, startup items, and resource usage, then provides optimization recommendations.
.NOTES
    File Name      : Analyze-WindowsSystem.ps1
    Author         : Jimmy Briggs
    Prerequisite   : PowerShell 5.1 or later
    Copyright      : No Clocks, LLC
.EXAMPLE
    .\Analyze-System.ps1
#>

# Script parameters
param (
    [string]$OutputFolder = ".\SystemAnalysis",
    [switch]$SkipDefenderAnalysis,
    [switch]$SkipWSLAnalysis,
    [switch]$GenerateHTML
)

# Create output folder if it doesn't exist
if (-not (Test-Path -Path $OutputFolder)) {
    New-Item -Path $OutputFolder -ItemType Directory | Out-Null
}

# Import all function files
# $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
# $functionFiles = @(
#     "Get-SystemInfo.ps1",
#     "Get-ProcessAnalysis.ps1",
#     "Get-ServiceAnalysis.ps1",
#     "Get-StartupAnalysis.ps1",
#     "Get-WSLAnalysis.ps1",
#     "Get-DefenderAnalysis.ps1",
#     "Get-SearchIndexerAnalysis.ps1",
#     "Get-OptimizationRecommendations.ps1"
# )

# foreach ($file in $functionFiles) {
#     $filePath = Join-Path -Path $scriptPath -ChildPath $file
#     if (Test-Path $filePath) {
#         . $filePath
#     }
#     else {
#         Write-Warning "Function file not found: $filePath"
#     }
# }

Import-Module .\..\PSSystemDiagnostics\PSSystemDiagnostics.psm1

# Display header
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "   Windows 11 System Analysis and Optimization Tool" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "Started at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
Write-Host "Output folder: $OutputFolder" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Warning "This script is not running as Administrator. Some data collection may be limited."
}

# Run all analysis functions and collect reports
$reports = @{}

# System Info
Write-Host "`nStep 1/7: Collecting system information..." -ForegroundColor Yellow
$systemInfoPath = Join-Path -Path $OutputFolder -ChildPath "SystemInfo.json"
$reports.SystemInfo = Get-SystemInfo -OutputPath $systemInfoPath

# Process Analysis
Write-Host "`nStep 2/7: Analyzing processes..." -ForegroundColor Yellow
$processAnalysisPath = Join-Path -Path $OutputFolder -ChildPath "ProcessAnalysis.json"
$reports.ProcessAnalysis = Get-ProcessAnalysis -OutputPath $processAnalysisPath

# Service Analysis
Write-Host "`nStep 3/7: Analyzing services..." -ForegroundColor Yellow
$serviceAnalysisPath = Join-Path -Path $OutputFolder -ChildPath "ServiceAnalysis.json"
$reports.ServiceAnalysis = Get-ServiceAnalysis -OutputPath $serviceAnalysisPath

# Startup Analysis
Write-Host "`nStep 4/7: Analyzing startup items..." -ForegroundColor Yellow
$startupAnalysisPath = Join-Path -Path $OutputFolder -ChildPath "StartupAnalysis.json"
$reports.StartupAnalysis = Get-StartupAnalysis -OutputPath $startupAnalysisPath

# Search Indexer Analysis
Write-Host "`nStep 5/7: Analyzing Search Indexer..." -ForegroundColor Yellow
$searchIndexerAnalysisPath = Join-Path -Path $OutputFolder -ChildPath "SearchIndexerAnalysis.json"
$reports.SearchIndexerAnalysis = Get-SearchIndexerAnalysis -OutputPath $searchIndexerAnalysisPath

# WSL Analysis (optional)
if (-not $SkipWSLAnalysis) {
    Write-Host "`nStep 6/7: Analyzing WSL..." -ForegroundColor Yellow
    $wslAnalysisPath = Join-Path -Path $OutputFolder -ChildPath "WSLAnalysis.json"
    $reports.WSLAnalysis = Get-WSLAnalysis -OutputPath $wslAnalysisPath
}
else {
    Write-Host "`nStep 6/7: Skipping WSL analysis..." -ForegroundColor Yellow
}

# Defender Analysis (optional)
if (-not $SkipDefenderAnalysis) {
    Write-Host "`nStep 7/7: Analyzing Windows Defender..." -ForegroundColor Yellow
    $defenderAnalysisPath = Join-Path -Path $OutputFolder -ChildPath "DefenderAnalysis.json"
    $reports.DefenderAnalysis = Get-DefenderAnalysis -OutputPath $defenderAnalysisPath
}
else {
    Write-Host "`nStep 7/7: Skipping Windows Defender analysis..." -ForegroundColor Yellow
}

# Generate optimization recommendations
Write-Host "`nGenerating optimization recommendations..." -ForegroundColor Yellow
$recommendationsPath = Join-Path -Path $OutputFolder -ChildPath "OptimizationRecommendations.json"
$recommendations = Get-OptimizationRecommendations `
    -ProcessAnalysis $reports.ProcessAnalysis `
    -ServiceAnalysis $reports.ServiceAnalysis `
    -SystemInfo $reports.SystemInfo `
    -OutputPath $recommendationsPath

# Generate HTML report if requested
if ($GenerateHTML) {
    Write-Host "`nGenerating HTML report..." -ForegroundColor Yellow
    $htmlPath = Join-Path -Path $OutputFolder -ChildPath "SystemAnalysisReport.html"

    # Simple HTML generation - in a real script, this would be more sophisticated
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>Windows 11 System Analysis Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1, h2, h3 { color: #0078d7; }
        .section { margin-bottom: 30px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .recommendation { background-color: #e6f7ff; padding: 10px; margin-bottom: 10px; border-left: 5px solid #0078d7; }
        .timestamp { color: #666; font-style: italic; }
    </style>
</head>
<body>
    <h1>Windows 11 System Analysis Report</h1>
    <p class="timestamp">Generated on: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>

    <div class="section">
        <h2>System Information</h2>
        <p>OS: $($reports.SystemInfo.OperatingSystem.Caption)</p>
        <p>Version: $($reports.SystemInfo.OperatingSystem.Version)</p>
        <p>Memory: $($reports.SystemInfo.Memory.UsedRAM_GB) GB / $($reports.SystemInfo.Memory.TotalRAM_GB) GB ($($reports.SystemInfo.Memory.PercentUsed)%)</p>
    </div>

    <div class="section">
        <h2>Optimization Recommendations</h2>
        $(foreach ($rec in $recommendations.Recommendations) {
            "<div class='recommendation'><h3>$($rec.Category): $($rec.Issue)</h3><p>$($rec.Details)</p><ul>"
            foreach ($r in $rec.Recommendations) {
                "<li>$r</li>"
            }
            "</ul></div>"
        })
    </div>
</body>
</html>
"@

    $html | Out-File -FilePath $htmlPath
    Write-Host "HTML report saved to $htmlPath" -ForegroundColor Green
}

# Summary
Write-Host "`n====================================================" -ForegroundColor Cyan
Write-Host "Analysis complete!" -ForegroundColor Green
Write-Host "All reports saved to: $OutputFolder" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

# Display key findings
Write-Host "`nKey Findings:" -ForegroundColor Yellow
Write-Host "- CPU Usage: $($reports.SystemInfo.CPU.LoadPercentage)%" -ForegroundColor White
Write-Host "- Memory Usage: $($reports.SystemInfo.Memory.PercentUsed)%" -ForegroundColor White
Write-Host "- Top CPU Consumer: $($reports.ProcessAnalysis.TopCPUConsumers[0].ProcessName) ($([math]::Round($reports.ProcessAnalysis.TopCPUConsumers[0].CPU, 2))%)" -ForegroundColor White
Write-Host "- Top Memory Consumer: $($reports.ProcessAnalysis.TopMemoryConsumers[0].ProcessName) ($($reports.ProcessAnalysis.TopMemoryConsumers[0].'Memory(MB)') MB)" -ForegroundColor White
Write-Host "- Optimizable Services: $($reports.ServiceAnalysis.OptimizableAutomaticServices.Count)" -ForegroundColor White

# Display next steps
Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "1. Review the OptimizationRecommendations.json file for detailed recommendations" -ForegroundColor White
Write-Host "2. Apply recommended optimizations as needed" -ForegroundColor White
Write-Host "3. Consider scheduling regular system analysis to maintain optimal performance" -ForegroundColor White

Write-Host "`nCompleted at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
