function Get-ProcessAnalysis {
    [CmdletBinding()]
    param (
        [string]$OutputPath = ".\ProcessAnalysis.json",
        [int]$TopProcessCount = 15
    )

    Write-Host "Analyzing running processes..." -ForegroundColor Cyan

    # Get logical processor count for CPU percentage calculation
    $logicalProcessors = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors

    # Get all running processes with detailed information
    $processes = Get-Process | Select-Object Id, ProcessName,
    @{Name = 'CPU'; Expression = { $_.CPU } },
    @{Name = 'CPUPercent'; Expression = {
            if ($logicalProcessors) {
                [math]::Round(($_.CPU / $logicalProcessors), 2)
            } else { 0 }
        }
    },
    @{Name = 'Memory(MB)'; Expression = { [math]::Round(($_.WorkingSet / 1MB), 2) } },
    @{Name = 'PrivateMemory(MB)'; Expression = { [math]::Round(($_.PrivateMemorySize / 1MB), 2) } },
    @{Name = 'Threads'; Expression = { $_.Threads.Count } },
    @{Name = 'Handles'; Expression = { $_.HandleCount } },
    StartTime,
    @{Name = 'RunTime'; Expression = {
            if ($_.StartTime) {
                $runTime = (Get-Date) - $_.StartTime
                "$($runTime.Days)d $($runTime.Hours)h $($runTime.Minutes)m"
            } else { "N/A" }
        }
    }

    # Get top CPU consumers
    $topCPUConsumers = $processes | Sort-Object CPU -Descending | Select-Object -First $TopProcessCount

    # Get top memory consumers
    $topMemoryConsumers = $processes | Sort-Object "Memory(MB)" -Descending | Select-Object -First $TopProcessCount

    # Identify resource-intensive processes
    $highCpuProcesses = $processes | Where-Object { $_.CPU -gt 50 }
    $highMemoryProcesses = $processes | Where-Object { $_."Memory(MB)" -gt 200 }

    # Create process groups by category
    $systemProcesses = $processes | Where-Object { $_.ProcessName -match "svchost|System|Registry|csrss|wininit|services|lsass|winlogon" }
    $browserProcesses = $processes | Where-Object { $_.ProcessName -match "msedge|chrome|firefox|opera|iexplore" }
    $developerTools = $processes | Where-Object { $_.ProcessName -match "pwsh|rstudio|code|WindowsTerminal|conhost|rsession" }

    $report = [PSCustomObject]@{
        AllProcesses        = $processes
        TopCPUConsumers     = $topCPUConsumers
        TopMemoryConsumers  = $topMemoryConsumers
        HighCPUProcesses    = $highCpuProcesses
        HighMemoryProcesses = $highMemoryProcesses
        SystemProcesses     = $systemProcesses
        BrowserProcesses    = $browserProcesses
        DeveloperTools      = $developerTools
        Timestamp           = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }

    # Convert the report to JSON format
    $jsonReport = $report | ConvertTo-Json -Depth 5

    # Output the JSON report to a file
    $jsonReport | Out-File -FilePath $OutputPath

    Write-Host "Process analysis saved to $OutputPath" -ForegroundColor Green

    return $report
}
