function Get-StartupAnalysis {
    [CmdletBinding()]
    param (
        [string]$OutputPath = ".\StartupAnalysis.json"
    )

    Write-Host "Analyzing startup items..." -ForegroundColor Cyan

    # Get startup items from registry
    $startupItems = @()

    # Current user startup items
    $currentUserStartupPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    if (Test-Path $currentUserStartupPath) {
        $currentUserStartupItems = Get-ItemProperty -Path $currentUserStartupPath
        foreach ($prop in $currentUserStartupItems.PSObject.Properties) {
            if ($prop.Name -notin @('PSPath', 'PSParentPath', 'PSChildName', 'PSProvider')) {
                $startupItems += [PSCustomObject]@{
                    Name     = $prop.Name
                    Command  = $prop.Value
                    Location = "HKCU\Run"
                    User     = $env:USERNAME
                }
            }
        }
    }

    # All users startup items
    $allUsersStartupPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
    if (Test-Path $allUsersStartupPath) {
        $allUsersStartupItems = Get-ItemProperty -Path $allUsersStartupPath
        foreach ($prop in $allUsersStartupItems.PSObject.Properties) {
            if ($prop.Name -notin @('PSPath', 'PSParentPath', 'PSChildName', 'PSProvider')) {
                $startupItems += [PSCustomObject]@{
                    Name     = $prop.Name
                    Command  = $prop.Value
                    Location = "HKLM\Run"
                    User     = "All Users"
                }
            }
        }
    }

    # Get startup items from WMI
    try {
        $wmiStartupItems = Get-CimInstance Win32_StartupCommand
        foreach ($item in $wmiStartupItems) {
            # Check if this item is already in our list (to avoid duplicates)
            $exists = $false
            foreach ($existingItem in $startupItems) {
                if ($existingItem.Command -eq $item.Command) {
                    $exists = $true
                    break
                }
            }

            if (-not $exists) {
                $startupItems += [PSCustomObject]@{
                    Name     = $item.Name
                    Command  = $item.Command
                    Location = $item.Location
                    User     = $item.User
                }
            }
        }
    } catch {
        Write-Warning "Could not retrieve WMI startup items: $($_.Exception.Message)"
    }

    # Identify non-essential startup items
    $nonEssentialStartupItems = $startupItems | Where-Object {
        $_.Name -match "Adobe|Update|OneDrive|Teams|Spotify|Dropbox|Google|Keeper" -or
        $_.Command -match "Adobe|Update|OneDrive|Teams|Spotify|Dropbox|Google|Keeper"
    }

    $report = [PSCustomObject]@{
        AllStartupItems          = $startupItems
        NonEssentialStartupItems = $nonEssentialStartupItems
        Timestamp                = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }

    # Convert the report to JSON format
    $jsonReport = $report | ConvertTo-Json -Depth 5

    # Output the JSON report to a file
    $jsonReport | Out-File -FilePath $OutputPath

    Write-Host "Startup analysis saved to $OutputPath" -ForegroundColor Green

    return $report
}
