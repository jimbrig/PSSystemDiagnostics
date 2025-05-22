function Get-WSLAnalysis {
    [CmdletBinding()]
    param (
        [string]$OutputPath = ".\WSLAnalysis.json"
    )

    Write-Host "Analyzing WSL usage..." -ForegroundColor Cyan

    $wslProcess = Get-Process -Name "vmmemWSL" -ErrorAction SilentlyContinue

    if (-not $wslProcess) {
        $report = [PSCustomObject]@{
            Status    = "WSL is not currently running"
            IsRunning = $false
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }

        # Convert the report to JSON format
        $jsonReport = $report | ConvertTo-Json -Depth 5

        # Output the JSON report to a file
        $jsonReport | Out-File -FilePath $OutputPath

        Write-Host "WSL analysis saved to $OutputPath" -ForegroundColor Green

        return $report
    }

    # Check for .wslconfig file
    $wslConfigPath = "$env:USERPROFILE\.wslconfig"
    $wslConfigExists = Test-Path $wslConfigPath
    $wslConfigContent = if ($wslConfigExists) { Get-Content $wslConfigPath -Raw } else { $null }

    # Get WSL distros
    $wslDistros = $null
    try {
        $wslDistros = (wsl --list --verbose) -join "`n"
    } catch {
        $wslDistros = "Unable to get WSL distros: $($_.Exception.Message)"
    }

    $report = [PSCustomObject]@{
        Status                  = "WSL is running"
        IsRunning               = $true
        Process                 = $wslProcess | Select-Object Id, ProcessName, CPU,
        @{Name = 'Memory(MB)'; Expression = { [math]::Round(($_.WorkingSet / 1MB), 2) } },
        StartTime
        ConfigFileExists        = $wslConfigExists
        ConfigFilePath          = $wslConfigPath
        ConfigFileContent       = $wslConfigContent
        Distros                 = $wslDistros
        OptimizationSuggestions = @(
            "To limit WSL memory usage, create or modify $wslConfigPath with content:",
            "[wsl2]",
            "memory=4GB",
            "processors=2",
            "swap=2GB",
            "",
            "To shut down WSL when not in use, run: wsl --shutdown"
        )
        Timestamp               = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }

    # Convert the report to JSON format
    $jsonReport = $report | ConvertTo-Json -Depth 5

    # Output the JSON report to a file
    $jsonReport | Out-File -FilePath $OutputPath

    Write-Host "WSL analysis saved to $OutputPath" -ForegroundColor Green

    return $report
}
