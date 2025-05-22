function Get-ServiceAnalysis {
    [CmdletBinding()]
    param (
        [string]$OutputPath = ".\ServiceAnalysis.json"
    )

    Write-Host "Analyzing services..." -ForegroundColor Cyan

    # Define known non-essential services that can be optimized
    $optimizableServices = @(
        "AdobeARMservice",
        "AdobeUpdateService",
        "DSAService",
        "DSAUpdateService",
        "FoxitPDFReaderUpdateService",
        "Intel(R) TPM Provisioning Service",
        "Intel(R) Management and Security Application Local Management Service",
        "Intel(R) Management and Security Application User Notification Service",
        "Intel(R) Dynamic Application Loader Host Interface Service",
        "Intel(R) PROSet/Wireless Service",
        "igfxCUIService",
        "jhi_service",
        "KillerAnalyticsService",
        "KillerNetworkService",
        "logi_lamparray_service",
        "NahimicService",
        "NVDisplay.ContainerLocalSystem",
        "RtkAudioUniversalService"
    )

    # Get all services
    $allServices = Get-Service

    # Find automatic services that could be set to manual
    $automaticServices = $allServices | Where-Object {
        $_.StartType -eq 'Automatic' -and
        ($optimizableServices -contains $_.Name -or $_.DisplayName -match 'Adobe|Intel|Killer|Nahimic|Realtek|Update|Logitech')
    }

    # Find running services that could be stopped
    $runningOptimizableServices = $allServices | Where-Object {
        $_.Status -eq 'Running' -and
        ($optimizableServices -contains $_.Name -or $_.DisplayName -match 'Adobe|Intel|Killer|Nahimic|Realtek|Update|Logitech')
    }

    # Get all running services
    $runningServices = $allServices | Where-Object { $_.Status -eq 'Running' }

    # Get automatic services that are stopped (potential issues)
    $stoppedAutoServices = $allServices | Where-Object { $_.Status -eq 'Stopped' -and $_.StartType -eq 'Automatic' }

    # Generate optimization commands
    $optimizationCommands = @()
    foreach ($service in $automaticServices) {
        $optimizationCommands += "Set-Service -Name '$($service.Name)' -StartupType Manual # $($service.DisplayName)"
    }

    $report = [PSCustomObject]@{
        AllServices                  = $allServices | Select-Object Name, DisplayName, Status, StartType
        RunningServices              = $runningServices | Select-Object Name, DisplayName, Status, StartType
        OptimizableAutomaticServices = $automaticServices | Select-Object Name, DisplayName, Status, StartType
        RunningOptimizableServices   = $runningOptimizableServices | Select-Object Name, DisplayName, Status, StartType
        StoppedAutomaticServices     = $stoppedAutoServices | Select-Object Name, DisplayName, Status, StartType
        OptimizationCommands         = $optimizationCommands
        Timestamp                    = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }

    # Convert the report to JSON format
    $jsonReport = $report | ConvertTo-Json -Depth 5

    # Output the JSON report to a file
    $jsonReport | Out-File -FilePath $OutputPath

    Write-Host "Service analysis saved to $OutputPath" -ForegroundColor Green

    return $report
}
