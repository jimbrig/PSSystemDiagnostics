#Requires -Version 5.1
<#
.SYNOPSIS
    Validates the PSSystemDiagnostics module functionality and structure.

.DESCRIPTION
    This script performs comprehensive validation of the PSSystemDiagnostics module
    including manifest validation, function availability, and basic functionality tests.

.EXAMPLE
    .\Validate-Module.ps1

.NOTES
    Author: Jimmy Briggs
    Date: 2025-05-30
#>

[CmdletBinding()]
param(
    [string]$ModulePath = "..\PSSystemDiagnostics\PSSystemDiagnostics.psd1",
    [switch]$Detailed
)

$ErrorActionPreference = 'Stop'

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PSSystemDiagnostics Module Validation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Started: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
Write-Host ""

# Test 1: Manifest Validation
Write-Host "[1/6] Testing module manifest..." -ForegroundColor Yellow
try {
    $manifest = Test-ModuleManifest -Path $ModulePath -ErrorAction Stop
    Write-Host "✓ Manifest validation passed" -ForegroundColor Green
    Write-Host "  - Name: $($manifest.Name)" -ForegroundColor Gray
    Write-Host "  - Version: $($manifest.Version)" -ForegroundColor Gray
    Write-Host "  - Author: $($manifest.Author)" -ForegroundColor Gray
    Write-Host "  - Functions to Export: $($manifest.ExportedFunctions.Count)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Manifest validation failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 2: Module Import
Write-Host "`n[2/6] Testing module import..." -ForegroundColor Yellow
try {
    # Remove any existing versions
    Get-Module PSSystemDiagnostics | Remove-Module -Force -ErrorAction SilentlyContinue

    # Import the module
    Import-Module $ModulePath -Force -ErrorAction Stop
    $importedModule = Get-Module PSSystemDiagnostics

    Write-Host "✓ Module import successful" -ForegroundColor Green
    Write-Host "  - Exported Functions: $($importedModule.ExportedFunctions.Count)" -ForegroundColor Gray
    Write-Host "  - Module Path: $($importedModule.Path)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Module import failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 3: Core Functions Availability
Write-Host "`n[3/6] Testing core function availability..." -ForegroundColor Yellow
$coreFunctions = @(
    'Get-SystemInfo',
    'Get-ProcessAnalysis',
    'Get-ServiceAnalysis',
    'Get-DefenderAnalysis',
    'Get-OptimizationRecommendations',
    'Get-WinGetPackages',
    'Get-ChocoPackages',
    'Get-ScoopPackages'
)

$missingFunctions = @()
foreach ($func in $coreFunctions) {
    if (Get-Command $func -ErrorAction SilentlyContinue) {
        Write-Host "  ✓ $func" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $func (Missing)" -ForegroundColor Red
        $missingFunctions += $func
    }
}

if ($missingFunctions.Count -eq 0) {
    Write-Host "✓ All core functions available" -ForegroundColor Green
} else {
    Write-Host "✗ Missing functions: $($missingFunctions -join ', ')" -ForegroundColor Red
}

# Test 4: Function Help Documentation
Write-Host "`n[4/6] Testing function help documentation..." -ForegroundColor Yellow
$functionsWithoutHelp = @()
$sampleFunctions = $coreFunctions | Select-Object -First 4

foreach ($func in $sampleFunctions) {
    try {
        $help = Get-Help $func -ErrorAction Stop
        if ($help.Synopsis -like "*$func*" -or $help.Synopsis -eq $func) {
            Write-Host "  ⚠ $func (Auto-generated help)" -ForegroundColor Yellow
            $functionsWithoutHelp += $func
        } else {
            Write-Host "  ✓ $func" -ForegroundColor Green
        }
    } catch {
        Write-Host "  ✗ $func (No help found)" -ForegroundColor Red
        $functionsWithoutHelp += $func
    }
}

# Test 5: Basic Functionality Test
Write-Host "`n[5/6] Testing basic functionality..." -ForegroundColor Yellow
try {
    # Test a simple function that doesn't require admin privileges
    if (Get-Command Get-WinGetPackages -ErrorAction SilentlyContinue) {
        Write-Host "  Testing Get-WinGetPackages..." -ForegroundColor Gray
        $wingetTest = Get-WinGetPackages -ErrorAction Stop | Select-Object -First 1
        Write-Host "  ✓ Get-WinGetPackages executed successfully" -ForegroundColor Green
    }

    # Test helper functions
    if (Get-Command Test-IsAdmin -ErrorAction SilentlyContinue) {
        $isAdmin = Test-IsAdmin
        Write-Host "  ✓ Test-IsAdmin: $isAdmin" -ForegroundColor Green
    }
} catch {
    Write-Host "  ⚠ Basic functionality test warning: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Test 6: Module File Structure
Write-Host "`n[6/6] Testing module file structure..." -ForegroundColor Yellow
$moduleDir = Split-Path $ModulePath -Parent
$expectedStructure = @{
    'PSSystemDiagnostics.psm1' = 'Root module file'
    'PSSystemDiagnostics.psd1' = 'Module manifest'
    'Public' = 'Public functions directory'
    'Private' = 'Private functions directory'
}

$structureIssues = @()
foreach ($item in $expectedStructure.Keys) {
    $path = Join-Path $moduleDir $item
    if (Test-Path $path) {
        Write-Host "  ✓ $item" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $item (Missing)" -ForegroundColor Red
        $structureIssues += $item
    }
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Validation Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$overallStatus = "PASS"
if ($missingFunctions.Count -gt 0 -or $structureIssues.Count -gt 0) {
    $overallStatus = "FAIL"
    Write-Host "Overall Status: $overallStatus" -ForegroundColor Red
} else {
    Write-Host "Overall Status: $overallStatus" -ForegroundColor Green
}

Write-Host ""
Write-Host "Details:" -ForegroundColor White
Write-Host "- Module Version: $($manifest.Version)" -ForegroundColor Gray
Write-Host "- Functions Available: $($importedModule.ExportedFunctions.Count)" -ForegroundColor Gray
Write-Host "- Missing Functions: $($missingFunctions.Count)" -ForegroundColor Gray
Write-Host "- Functions Without Help: $($functionsWithoutHelp.Count)" -ForegroundColor Gray
Write-Host "- Structure Issues: $($structureIssues.Count)" -ForegroundColor Gray

if ($Detailed) {
    Write-Host "`nDetailed Information:" -ForegroundColor White
    Write-Host "Available Functions:" -ForegroundColor Gray
    $importedModule.ExportedFunctions.Keys | Sort-Object | ForEach-Object {
        Write-Host "  - $_" -ForegroundColor DarkGray
    }
}

Write-Host "`nCompleted: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
