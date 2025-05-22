function Get-SystemInfo {
    [CmdletBinding()]
    param (
        [string]$OutputPath = ".\SystemInfo.json"
    )

    Write-Host "Collecting system information..." -ForegroundColor Cyan

    $computerSystem = Get-CimInstance Win32_ComputerSystem | Select-Object Manufacturer, Model, TotalPhysicalMemory, NumberOfLogicalProcessors, NumberOfProcessors
    $operatingSystem = Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber, OSArchitecture, LastBootUpTime

    # Calculate memory usage
    $totalRAM = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
    $availableRAM = [math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB, 2)
    $usedRAM = [math]::Round($totalRAM - ($availableRAM / 1024), 2)
    $ramPercentUsed = [math]::Round(($usedRAM / $totalRAM) * 100, 2)

    # Get CPU information
    $cpuInfo = Get-CimInstance Win32_Processor | Select-Object Name, MaxClockSpeed, CurrentClockSpeed, LoadPercentage

    # Get disk information
    $diskInfo = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
        Select-Object DeviceID, @{Name = "Size(GB)"; Expression = { [math]::Round($_.Size / 1GB, 2) } },
        @{Name = "FreeSpace(GB)"; Expression = { [math]::Round($_.FreeSpace / 1GB, 2) } },
        @{Name = "UsedSpace(GB)"; Expression = { [math]::Round(($_.Size - $_.FreeSpace) / 1GB, 2) } },
        @{Name = "PercentUsed"; Expression = { [math]::Round((($_.Size - $_.FreeSpace) / $_.Size) * 100, 2) } }

    $report = [PSCustomObject]@{
        ComputerSystem  = $computerSystem
        OperatingSystem = $operatingSystem
        Memory          = @{
            TotalRAM_GB     = $totalRAM
            AvailableRAM_MB = $availableRAM
            UsedRAM_GB      = $usedRAM
            PercentUsed     = $ramPercentUsed
        }
        CPU             = $cpuInfo
        Disk            = $diskInfo
        Timestamp       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }

    # Convert the report to JSON format
    $jsonReport = $report | ConvertTo-Json -Depth 5

    # Output the JSON report to a file
    $jsonReport | Out-File -FilePath $OutputPath

    Write-Host "System information saved to $OutputPath" -ForegroundColor Green

    return $report
}
