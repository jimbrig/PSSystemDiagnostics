Function Remove-OldDrivers {
  <#
  .SYNOPSIS
    Remove old third-party drivers from the system.
  .DESCRIPTION
    This function identifies and removes old third-party drivers that are no longer needed.
    It lists all installed third-party drivers, identifies duplicates based on the original file name,
    and removes older versions while keeping the most recent one.
  .INPUTS
    None. This function does not accept pipeline input.
  .OUTPUTS
    System.Management.Automation.PSCustomObject. Returns a summary of the removal operation.
  .PARAMETER Interactive
    If specified, the function will prompt for confirmation before removing each driver.
  .PARAMETER MinimumVersionsToKeep
    Specifies the minimum number of driver versions to keep. Default is 1 (keep only the latest).
  .EXAMPLE
    PS C:\> Remove-OldDrivers -WhatIf
    Shows what would happen if the command were to run. The command is not run.

  .EXAMPLE
    PS C:\> Remove-OldDrivers -Interactive
    Prompts for confirmation before removing each driver.

  .EXAMPLE
    PS C:\> Remove-OldDrivers -MinimumVersionsToKeep 2
    Keeps the 2 most recent versions of each driver.
  #>
  [CmdletBinding(
    SupportsShouldProcess = $true,
    ConfirmImpact = 'High'
  )]
  [OutputType([PSCustomObject])]
  Param(
    [Parameter()]
    [Switch]$Interactive,

    [Parameter()]
    [ValidateRange(1, 10)]
    [int]$MinimumVersionsToKeep = 1
  )

  Begin {
    Write-Verbose "[BEGIN]: Remove-OldDrivers"

    # Initialize result object
    $result = [PSCustomObject]@{
      TotalDriversFound = 0
      DriversToRemove   = 0
      DriversRemoved    = 0
      DriversFailed     = 0
      Errors            = @()
    }

    $OriginalFileName = @{
      Name       = "OriginalFileName"
      Expression = { ($_.OriginalFileName | Split-Path -Leaf) -replace '\s+', ' ' }
    }

    $Date = @{
      Name       = "Date"
      Expression = {
        try {
          [DateTime]$_.Date
        } catch {
          [DateTime]::MinValue
        }
      }
    }
  }

  Process {
    Write-Verbose "[PROCESS]: Remove-OldDrivers"

    try {
      # Enhanced user feedback during driver retrieval
      Write-Host "Starting driver analysis..." -ForegroundColor Yellow
      Write-Host "This process may take several minutes depending on the number of installed drivers." -ForegroundColor Cyan
      Write-Host "Please wait while we scan the system..." -ForegroundColor Cyan

      # Start progress bar for driver retrieval
      Write-Progress -Activity "Scanning system drivers" -Status "Retrieving driver information..." -PercentComplete 0

      # Start background job to show periodic updates
      $progressJob = Start-Job -ScriptBlock {
        param($parentId)
        $counter = 0
        while ($true) {
          Start-Sleep -Seconds 3
          $counter++
          $dots = "." * (($counter % 4) + 1)
          Write-Progress -ParentId $parentId -Activity "Driver Scan Progress" -Status "Still scanning$dots" -PercentComplete -1
        }
      } -ArgumentList $PID

      try {
        # Get all third-party drivers with progress updates
        Write-Verbose "Retrieving installed third-party drivers..."
        $startTime = Get-Date

        $AllDrivers = Get-WindowsDriver -Online -All -ErrorAction Stop |
        Where-Object { $_.Driver -like 'oem*.inf' } |
        Select-Object -Property $OriginalFileName, Driver, ClassDescription, ProviderName, $Date, Version

        $endTime = Get-Date
        $duration = $endTime - $startTime

      } finally {
        # Clean up progress job
        if ($progressJob) {
          Stop-Job -Job $progressJob -ErrorAction SilentlyContinue
          Remove-Job -Job $progressJob -ErrorAction SilentlyContinue
        }
        Write-Progress -Activity "Scanning system drivers" -Completed
      }

      $result.TotalDriversFound = $AllDrivers.Count

      Write-Host "Driver scan completed in $([math]::Round($duration.TotalSeconds, 1)) seconds." -ForegroundColor Green
      Write-Host "Found $($AllDrivers.Count) third-party drivers to analyze." -ForegroundColor Green

      if ($AllDrivers.Count -eq 0) {
        Write-Warning "No third-party drivers found."
        return $result
      }

      Write-Verbose "Found $($AllDrivers.Count) third-party drivers"
      Write-Verbose ($AllDrivers | Sort-Object ClassDescription | Format-Table -AutoSize | Out-String)

      # Analyze drivers for duplicates
      Write-Host "Analyzing drivers for duplicates..." -ForegroundColor Yellow
      Write-Progress -Activity "Analyzing drivers" -Status "Grouping drivers by name..." -PercentComplete 0

      # Group drivers and find duplicates with improved logic
      $DriverGroups = $AllDrivers |
      Where-Object { $_.OriginalFileName -and $_.OriginalFileName.Trim() } |
      Group-Object -Property OriginalFileName |
      Where-Object { $_.Count -gt 1 }

      Write-Progress -Activity "Analyzing drivers" -Status "Identifying old versions..." -PercentComplete 50

      Write-Host "Found $($DriverGroups.Count) driver groups with multiple versions." -ForegroundColor Green
      Write-Verbose "Found $($DriverGroups.Count) driver groups with duplicates"

      # Get drivers to remove (keep the most recent N versions)
      $DriversToRemove = foreach ($group in $DriverGroups) {
        $sortedDrivers = $group.Group | Sort-Object Date -Descending
        $sortedDrivers | Select-Object -Skip $MinimumVersionsToKeep
      }

      Write-Progress -Activity "Analyzing drivers" -Completed

      $result.DriversToRemove = $DriversToRemove.Count

      if ($DriversToRemove.Count -eq 0) {
        Write-Host "No old drivers found to remove. All drivers are current versions." -ForegroundColor Green
        return $result
      }

      Write-Host "Identified $($DriversToRemove.Count) old driver versions for removal." -ForegroundColor Yellow
      Write-Verbose "Drivers to remove:"
      Write-Verbose ($DriversToRemove | Sort-Object ClassDescription | Format-Table | Out-String)

      # Show summary before removal
      Write-Host "`nRemoval Plan:" -ForegroundColor Cyan
      Write-Host "  Total drivers found: $($result.TotalDriversFound)" -ForegroundColor White
      Write-Host "  Driver groups with duplicates: $($DriverGroups.Count)" -ForegroundColor White
      Write-Host "  Old drivers to remove: $($result.DriversToRemove)" -ForegroundColor White
      Write-Host "  Versions to keep per driver: $MinimumVersionsToKeep" -ForegroundColor White

      if ($WhatIfPreference) {
        Write-Host "`nWhatIf: The following drivers would be removed:" -ForegroundColor Magenta
        $DriversToRemove | ForEach-Object {
          Write-Host "  - $($_.Driver) ($($_.ClassDescription))" -ForegroundColor Gray
        }
        return $result
      }

      # Confirm before proceeding (if not in interactive mode)
      if (-not $Interactive) {
        Write-Host "`nThis operation will permanently remove the old driver versions." -ForegroundColor Yellow
        if (-not $PSCmdlet.ShouldContinue("Do you want to proceed with the removal?", "Remove Old Drivers")) {
          Write-Host "Operation cancelled by user." -ForegroundColor Yellow
          return $result
        }
      }

      # Process driver removal with improved progress tracking
      Write-Host "`nStarting driver removal process..." -ForegroundColor Yellow
      $totalDrivers = $DriversToRemove.Count
      $processedCount = 0

      foreach ($Driver in $DriversToRemove) {
        $processedCount++
        $percentComplete = [math]::Round(($processedCount / $totalDrivers) * 100)

        Write-Progress -Activity "Removing old drivers" `
          -Status "Processing driver $processedCount of $totalDrivers ($percentComplete%)" `
          -CurrentOperation "$($Driver.ClassDescription) - $($Driver.Driver)" `
          -PercentComplete $percentComplete

        $DriverName = Split-Path -Path $Driver.Driver -Leaf
        $shouldRemove = $true

        # Handle confirmation logic
        if ($Interactive) {
          Write-Host "`nDriver Details:" -ForegroundColor Cyan
          Write-Host "  File: $DriverName" -ForegroundColor White
          Write-Host "  Class: $($Driver.ClassDescription)" -ForegroundColor White
          Write-Host "  Provider: $($Driver.ProviderName)" -ForegroundColor White
          Write-Host "  Date: $($Driver.Date)" -ForegroundColor White

          do {
            $confirmation = Read-Host "Remove this driver? [Y/N]"
          } while ($confirmation -notmatch '^[YyNn]$')

          $shouldRemove = $confirmation -match '^[Yy]$'
        } elseif (-not $PSCmdlet.ShouldProcess($DriverName, "Remove driver")) {
          $shouldRemove = $false
        }

        if (-not $shouldRemove) {
          Write-Host "Skipping removal of driver '$DriverName'" -ForegroundColor Yellow
          continue
        }

        # Remove the driver with better error handling
        try {
          Write-Verbose "Removing driver: $DriverName"
          Write-Host "Removing: $DriverName..." -ForegroundColor Gray

          if (-not $WhatIfPreference) {
            $pnpResult = & pnputil.exe /delete-driver $DriverName /uninstall /force 2>&1

            if ($LASTEXITCODE -ne 0) {
              throw "pnputil.exe failed with exit code $LASTEXITCODE. Output: $pnpResult"
            }
          }

          Write-Host "  ✓ Driver '$DriverName' removed successfully." -ForegroundColor Green
          $result.DriversRemoved++

        } catch {
          $errorMsg = "Failed to remove driver '$DriverName': $($_.Exception.Message)"
          Write-Host "  ✗ $errorMsg" -ForegroundColor Red
          Write-Error $errorMsg
          $result.DriversFailed++
          $result.Errors += $errorMsg
        }

        Start-Sleep -Milliseconds 100
      }
    } catch {
      $errorMsg = "Failed to retrieve driver information: $($_.Exception.Message)"
      Write-Error $errorMsg
      $result.Errors += $errorMsg
    } finally {
      Write-Progress -Activity "Removing old drivers" -Completed
    }
  }

  End {
    Write-Verbose "[END]: Remove-OldDrivers"

    # Display final summary
    Write-Host "`n" + ("=" * 50) -ForegroundColor Cyan
    Write-Host "DRIVER REMOVAL SUMMARY" -ForegroundColor Cyan
    Write-Host ("=" * 50) -ForegroundColor Cyan
    Write-Host "  Total drivers found: $($result.TotalDriversFound)" -ForegroundColor White
    Write-Host "  Drivers to remove: $($result.DriversToRemove)" -ForegroundColor White
    Write-Host "  Drivers removed: $($result.DriversRemoved)" -ForegroundColor Green

    if ($result.DriversFailed -gt 0) {
      Write-Host "  Drivers failed: $($result.DriversFailed)" -ForegroundColor Red
    }

    if ($result.DriversRemoved -gt 0) {
      Write-Host "`nRecommendation: Consider restarting your computer to complete the driver removal process." -ForegroundColor Yellow
    }

    Write-Host ("=" * 50) -ForegroundColor Cyan

    return $result
  }
}
