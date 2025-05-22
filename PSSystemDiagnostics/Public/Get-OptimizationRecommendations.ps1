function Get-OptimizationRecommendations {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$ProcessAnalysis,
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$ServiceAnalysis,
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$SystemInfo,
        [string]$OutputPath = ".\OptimizationRecommendations.json"
    )

    Write-Host "Generating optimization recommendations..." -ForegroundColor Cyan

    $recommendations = @()

    # CPU optimization recommendations
    $highCpuProcesses = $ProcessAnalysis.HighCPUProcesses
    if ($highCpuProcesses) {
        $recommendations += [PSCustomObject]@{
            Category        = "CPU Usage"
            Issue           = "High CPU processes detected"
            Details         = "The following processes are using significant CPU resources: $($highCpuProcesses.ProcessName -join ', ')"
            Recommendations = @(
                "Investigate these processes to determine if they are necessary",
                "Consider updating or reinstalling applications that are consuming excessive resources",
                "Check for malware or unwanted background processes"
            )
            Commands        = @(
                "Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 ProcessName, CPU, ID"
            )
        }

        # Specific recommendations for known high CPU processes
        foreach ($process in $highCpuProcesses) {
            switch -Wildcard ($process.ProcessName) {
                "SearchIndexer" {
                    $recommendations += [PSCustomObject]@{
                        Category        = "Windows Search"
                        Issue           = "SearchIndexer using high CPU ($([math]::Round($process.CPU, 2))%)"
                        Details         = "Windows Search Indexer is consuming excessive CPU resources"
                        Recommendations = @(
                            "Limit indexed locations through Control Panel > Indexing Options",
                            "Schedule indexing during off-hours",
                            "Rebuild the search index if it appears corrupted"
                        )
                        Commands        = @(
                            "# Restart Windows Search service",
                            "Restart-Service -Name WSearch -Force",
                            "",
                            "# To rebuild index (requires admin):",
                            "# Control Panel > Indexing Options > Advanced > Rebuild"
                        )
                    }
                }
                "MsMpEng" {
                    $recommendations += [PSCustomObject]@{
                        Category        = "Windows Defender"
                        Issue           = "Windows Defender using high CPU ($([math]::Round($process.CPU, 2))%)"
                        Details         = "Windows Defender antivirus scanning is consuming excessive CPU resources"
                        Recommendations = @(
                            "Schedule scans during off-hours",
                            "Add exclusions for development folders",
                            "Ensure you're not running multiple antivirus solutions simultaneously"
                        )
                        Commands        = @(
                            "# Set scan schedule to run during off-hours (e.g., 2 AM)",
                            "Set-MpPreference -ScanScheduleTime 02:00:00",
                            "",
                            "# Add exclusions for development folders if needed",
                            "# Add-MpPreference -ExclusionPath 'C:\DevProjects'"
                        )
                    }
                }
                "OneDrive" {
                    $recommendations += [PSCustomObject]@{
                        Category        = "OneDrive"
                        Issue           = "OneDrive using high CPU ($([math]::Round($process.CPU, 2))%)"
                        Details         = "OneDrive sync is consuming excessive CPU resources"
                        Recommendations = @(
                            "Limit synced folders to essential ones",
                            "Use Files On-Demand to keep files in the cloud until needed",
                            "Pause sync during resource-intensive work"
                        )
                        Commands        = @(
                            "# No direct PowerShell commands for OneDrive optimization",
                            "# Use OneDrive settings interface to configure sync options"
                        )
                    }
                }
                "PowerToys*" {
                    $recommendations += [PSCustomObject]@{
                        Category        = "PowerToys"
                        Issue           = "$($process.ProcessName) using high CPU ($([math]::Round($process.CPU, 2))%)"
                        Details         = "PowerToys module is consuming excessive CPU resources"
                        Recommendations = @(
                            "Disable unused PowerToys modules",
                            "Update to the latest version of PowerToys",
                            "Check for conflicts with other utilities"
                        )
                        Commands        = @(
                            "# No direct PowerShell commands for PowerToys optimization",
                            "# Use PowerToys settings interface to disable unused modules"
                        )
                    }
                }
            }
        }
    }

    # Memory optimization recommendations
    $highMemoryProcesses = $ProcessAnalysis.HighMemoryProcesses
    if ($highMemoryProcesses) {
        $recommendations += [PSCustomObject]@{
            Category        = "Memory Usage"
            Issue           = "High memory processes detected"
            Details         = "The following processes are using significant memory resources: $($highMemoryProcesses.ProcessName -join ', ')"
            Recommendations = @(
                "Close applications that are not currently needed",
                "Restart memory-intensive applications periodically",
                "Consider increasing system RAM if consistently at high usage"
            )
            Commands        = @(
                "Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 ProcessName, @{Name='Memory(MB)';Expression={[math]::Round((`$_.WorkingSet / 1MB), 2)}}, ID"
            )
        }
    }

    # WSL recommendations
    $wslProcess = $ProcessAnalysis.AllProcesses | Where-Object { $_.ProcessName -eq "vmmemWSL" }
    if ($wslProcess) {
        $recommendations += [PSCustomObject]@{
            Category        = "WSL"
            Issue           = "WSL using significant memory ($([math]::Round($wslProcess."Memory(MB)", 2)) MB)"
            Details         = "Windows Subsystem for Linux is consuming substantial memory resources"
            Recommendations = @(
                "Create a .wslconfig file to limit WSL resource usage",
                "Shut down WSL when not in use",
                "Use lightweight Linux distributions"
            )
            Commands        = @(
                "# Create or modify .wslconfig in your user profile",
                "# Example content for $env:USERPROFILE\.wslconfig:",
                "# [wsl2]",
                "# memory=4GB",
                "# processors=2",
                "# swap=2GB",
                "",
                "# Shut down WSL when not in use",
                "wsl --shutdown"
            )
        }
    }

    # Service optimization recommendations
    $optimizableServices = $ServiceAnalysis.OptimizableAutomaticServices
    if ($optimizableServices) {
        $recommendations += [PSCustomObject]@{
            Category        = "Services"
            Issue           = "Non-essential services running automatically"
            Details         = "The following services are set to automatic startup but may not be essential: $($optimizableServices.Name -join ', ')"
            Recommendations = @(
                "Set non-essential services to Manual startup",
                "Disable services that are never used",
                "Review third-party services for necessity"
            )
            Commands        = $ServiceAnalysis.OptimizationCommands
        }
    }

    # System-wide optimization recommendations
    $recommendations += [PSCustomObject]@{
        Category        = "System Performance"
        Issue           = "General system optimization"
        Details         = "System-wide performance optimizations"
        Recommendations = @(
            "Disable visual effects for performance",
            "Manage startup programs",
            "Schedule regular system maintenance"
        )
        Commands        = @(
            "# Set visual effects to best performance",
            "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 2",
            "",
            "# View startup programs",
            "Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location, User"
        )
    }

    $report = [PSCustomObject]@{
        Recommendations = $recommendations
        Timestamp       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }

    # Convert the report to JSON format
    $jsonReport = $report | ConvertTo-Json -Depth 5

    # Output the JSON report to a file
    $jsonReport | Out-File -FilePath $OutputPath

    Write-Host "Optimization recommendations saved to $OutputPath" -ForegroundColor Green

    return $report
}
