function Get-DefenderAnalysis {
    [CmdletBinding()]
    param (
        [string]$OutputPath = ".\DefenderAnalysis.json"
    )

    Write-Host "Analyzing Windows Defender status..." -ForegroundColor Cyan

    # Check if Windows Defender process is running
    $defenderProcess = Get-Process -Name "MsMpEng" -ErrorAction SilentlyContinue

    # Get Defender status
    $defenderStatus = $null
    try {
        $defenderStatus = Get-MpComputerStatus
    }
    catch {
        Write-Warning "Could not retrieve Windows Defender status: $($_.Exception.Message)"
    }

    # Get Defender preferences
    $defenderPreferences = $null
    try {
        $defenderPreferences = Get-MpPreference
    }
    catch {
        Write-Warning "Could not retrieve Windows Defender preferences: $($_.Exception.Message)"
    }

    # Check if a scan is currently running
    $scanRunning = $false
    $scanType = "None"
    if ($defenderProcess -and $defenderProcess.CPU -gt 100) {
        $scanRunning = $true
        # Try to determine scan type based on CPU usage
        if ($defenderProcess.CPU -gt 400) {
            $scanType = "Full Scan (estimated)"
        }
        else {
            $scanType = "Quick Scan (estimated)"
        }
    }

    # Create optimization suggestions
    $optimizationSuggestions = @()

    if ($defenderProcess -and $defenderProcess.CPU -gt 100) {
        $optimizationSuggestions += "Windows Defender is currently using high CPU ($([math]::Round($defenderProcess.CPU, 2))%). Consider:"
        $optimizationSuggestions += "  - Scheduling scans during off-hours with: Set-MpPreference -ScanScheduleTime 02:00:00"
        $optimizationSuggestions += "  - Adding exclusions for development folders with: Add-MpPreference -ExclusionPath 'C:\DevProjects'"
    }

    if ($defenderPreferences -and $defenderPreferences.ScanScheduleTime) {
        $optimizationSuggestions += "Current scan schedule: $($defenderPreferences.ScanScheduleDay) at $($defenderPreferences.ScanScheduleTime)"
    }

    $report = [PSCustomObject]@{
        DefenderRunning = ($null -ne $defenderProcess)
        Process = if ($defenderProcess) {
            $defenderProcess | Select-Object Id, ProcessName, CPU,
                @{Name='Memory(MB)';Expression={[math]::Round(($_.WorkingSet / 1MB), 2)}},
                StartTime
        } else { $null }
        Status = $defenderStatus
        Preferences = $defenderPreferences
        ScanRunning = $scanRunning
        ScanType = $scanType
        OptimizationSuggestions = $optimizationSuggestions
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }

    # Convert the report to JSON format
    $jsonReport = $report | ConvertTo-Json -Depth 5

    # Output the JSON report to a file
    $jsonReport | Out-File -FilePath $OutputPath

    Write-Host "Windows Defender analysis saved to $OutputPath" -ForegroundColor Green

    return $report
}
