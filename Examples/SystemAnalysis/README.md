> [!NOTE]
> *The report below was generated using the results in the [SystemAnalysis](./SystemAnalysis/) folder by running the
> [AnalyzeSystem.ps1](./AnalyzeSystem.ps1) script.*

# Windows 11 System Analysis and Optimization Recommendations

After reviewing your system diagnostic data, I can see several critical areas that need optimization. Your system is experiencing significant resource usage issues that are impacting performance.

## Critical Issues

### Memory Pressure

Your system is under extreme memory pressure with 99.97% of RAM in use (31.8GB out of 31.81GB). This is causing your system to rely heavily on virtual memory, which significantly degrades performance.

### High CPU Processes

Several processes are consuming excessive CPU resources:

- **SearchIndexer**: Using an extraordinary 1677.66% CPU (indicating multi-core usage)
- **Windows Defender (MsMpEng)**: Using 781.92% CPU
- **Desktop Window Manager (dwm)**: Using 1128.75% CPU


### Disk Space Concerns

Multiple drives are approaching capacity:

- C: drive at 85.3% used (767.39GB of 899.66GB)
- G: drive at 86.03% used (774GB of 899.66GB)
- J: drive at 86.03% used (774GB of 899.66GB)


## Immediate Optimization Actions

### 1. Address Windows Search Indexer

The Search Indexer is consuming an abnormal amount of CPU resources. This is likely causing significant system slowdown.

```powershell
# Stop the Windows Search service temporarily
Stop-Service -Name WSearch -Force

# Modify indexing options to exclude large folders
$indexOpts = New-Object -ComObject Microsoft.Search.Management
try {
    $catalog = $indexOpts.GetCatalog("SystemIndex")
    $manager = $catalog.GetCrawlScopeManager()

    # View current indexed locations
    $rules = @($manager.EnumerateScopeRules())
    $rules | ForEach-Object {
        Write-Host "Path: $($_.Path) | Included: $($_.IsIncluded)"
    }
} catch {
    Write-Host "Error accessing search catalog: $($_.Exception.Message)"
}

# Restart with reduced priority
Start-Service -Name WSearch
Get-Process -Name SearchIndexer | Set-ProcessPriority -Priority BelowNormal
```


### 2. Optimize Windows Defender

Windows Defender is consuming significant CPU resources. Let's optimize its configuration:

```powershell
# Add exclusions for development folders to reduce scanning overhead
$devFolders = @(
    "$env:USERPROFILE\source",
    "$env:USERPROFILE\Documents\GitHub",
    "$env:USERPROFILE\Documents\Projects"
)

foreach ($folder in $devFolders) {
    if (Test-Path $folder) {
        Add-MpPreference -ExclusionPath $folder
        Write-Host "Added exclusion for: $folder"
    }
}

# Schedule scans during off-hours
Set-MpPreference -ScanScheduleTime 03:00
Set-MpPreference -ScanScheduleDay 6  # Saturday

# Optimize real-time protection settings
Set-MpPreference -DisableCpuThrottleOnIdleScans $true
Set-MpPreference -DisableEmailScanning $true
```


### 3. Manage WSL Resources

WSL is using 618.52MB of memory with a 185.44% CPU usage. Your current configuration limits it to 2GB:

```powershell
# Update WSL configuration for better resource management
$wslConfigPath = "$env:USERPROFILE\.wslconfig"
$wslConfig = @"
[wsl2]
memory=2GB
processors=2
swap=1GB

[experimental]
autoMemoryReclaim=gradual
"@

Set-Content -Path $wslConfigPath -Value $wslConfig -Force
Write-Host "Updated WSL configuration at $wslConfigPath"

# Shut down WSL when not actively using it
wsl --shutdown
```


### 4. Optimize Desktop Window Manager

The DWM process is consuming excessive resources:

```powershell
# Disable transparency effects
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0

# Disable visual effects for performance
$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
if (-not (Test-Path $path)) {
    New-Item -Path $path -Force | Out-Null
}
Set-ItemProperty -Path $path -Name "VisualFXSetting" -Value 2
```


## System Cleanup and Maintenance

### 1. Clean Disk Space

```powershell
# Clean up system files
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Start-Process -FilePath cleanmgr.exe -ArgumentList "/sagerun:1" -Wait

# Find large files that could be archived or removed
$largeFiles = Get-ChildItem -Path "C:\" -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.Length -gt 100MB } |
    Sort-Object Length -Descending |
    Select-Object -First 20 FullName, @{Name="SizeGB";Expression={[math]::Round($_.Length / 1GB, 2)}}

$largeFiles | Format-Table -AutoSize
```


### 2. Manage Multiple Code Instances

You have numerous VS Code instances running (20+ processes), consuming over 5GB of RAM:

```powershell
# List all Code processes with their memory usage
$codeProcesses = Get-Process -Name Code |
    Select-Object Id, @{Name='Memory(MB)';Expression={[math]::Round(($_.WorkingSet / 1MB), 2)}}, StartTime,
    @{Name='RunTime';Expression={(Get-Date) - $_.StartTime}} |
    Sort-Object "Memory(MB)" -Descending

$codeProcesses | Format-Table -AutoSize

# Optional: Close idle VS Code windows (uncomment if needed)
# Get-Process -Name Code | Where-Object { $_.MainWindowTitle -eq "" } | Stop-Process
```


### 3. Manage Command Prompt Instances

You have 30+ command prompt instances running:

```powershell
# List all command prompt instances
$cmdProcesses = Get-Process -Name cmd |
    Select-Object Id, StartTime,
    @{Name='RunTime';Expression={(Get-Date) - $_.StartTime}}

$cmdProcesses | Format-Table -AutoSize

# Close command prompts that have been idle (no CPU usage)
Get-Process -Name cmd | Where-Object { $_.CPU -eq 0 -and ((Get-Date) - $_.StartTime).TotalMinutes -gt 30 } | Stop-Process
```


## Hardware Utilization Analysis

Your system has powerful hardware that's being pushed to its limits:

- Intel Core i7-10750H (12 logical processors)
- 32GB RAM (currently at 99.97% utilization)
- Multiple storage drives (some approaching capacity)

```powershell
# Get detailed memory information
$computerSystem = Get-CimInstance Win32_ComputerSystem
$operatingSystem = Get-CimInstance Win32_OperatingSystem
$totalRAM = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
$availableRAM = [math]::Round($operatingSystem.FreePhysicalMemory / 1MB, 2)
$usedRAM = [math]::Round($totalRAM - ($availableRAM / 1024), 2)
$ramPercentUsed = [math]::Round(($usedRAM / $totalRAM) * 100, 2)

Write-Host "Memory Usage:"
Write-Host "  Total RAM: $totalRAM GB"
Write-Host "  Used RAM: $usedRAM GB ($ramPercentUsed%)"
Write-Host "  Available RAM: $($availableRAM / 1024) GB"

# Check for memory-hogging processes
Get-Process | Sort-Object -Property WorkingSet -Descending | Select-Object -First 10 Name,
    @{Name='Memory(MB)';Expression={[math]::Round(($_.WorkingSet / 1MB), 2)}},
    @{Name='CPU(%)';Expression={[math]::Round($_.CPU, 2)}} |
    Format-Table -AutoSize
```


## Long-term Recommendations

1. **Memory Upgrade or Management**:
    - Consider adding more RAM if your system supports it
    - Implement better application lifecycle management to close unused applications
2. **Storage Optimization**:
    - Move large files to external storage
    - Implement regular disk cleanup schedule
3. **Service Optimization**:
    - Review startup services and disable non-essential ones
    - Consider using a service management tool to optimize service configurations
4. **Application Review**:
    - Evaluate the need for multiple VS Code instances
    - Consider using workspace features instead of multiple windows
5. **Regular Maintenance Schedule**:
    - Implement weekly system maintenance
    - Schedule regular reboots to clear memory and process accumulation

By implementing these recommendations, you should see significant improvements in system performance, particularly in reducing CPU and memory pressure that's currently affecting your system.

## References

- [ProcessAnalysis.json](./SystemAnalysis/ProcessAnalysis.json)
- [DefenderAnalysis.json](./SystemAnalysis/DefenderAnalysis.json)
- [ServiceAnalysis.json](./SystemAnalysis/ServiceAnalysis.json)
- [StartupAnalysis.json](./SystemAnalysis/StartupAnalysis.json)
- [OptimizationRecommendations.json](./SystemAnalysis/OptimizationRecommendations.json)
