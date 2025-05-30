Function Get-WinGetPackages {
  <#
  .SYNOPSIS
      Retrieves a list of installed packages from WinGet package manager.
  .DESCRIPTION
      This function queries WinGet to retrieve information about installed packages.
      It can filter results based on package name and optionally check for available updates.
  .PARAMETER Name
      Specifies a wildcard pattern to filter the package names.
      Default is "*", which matches all packages.
  .PARAMETER IncludeAvailableUpdates
      If specified, checks for available updates for each package.
  .INPUTS
      None. This function does not accept pipeline input.
  .OUTPUTS
      System.Collections.Generic.List[PSCustomObject]
      Returns a list of custom objects representing WinGet packages, with properties such as:
      Name, Id, Version, Source, UpdateAvailable, PackageManager, and PSTypeName.
  .EXAMPLE
      PS> Get-WinGetPackages -Name "Microsoft*"
      Retrieves all WinGet packages with names starting with "Microsoft".
  .EXAMPLE
      PS> Get-WinGetPackages -IncludeAvailableUpdates
      Retrieves all WinGet packages and checks for available updates.
  .NOTES
      This function requires WinGet to be installed and available in the system PATH.
      WinGet must be properly configured and have access to package sources.
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
    [string]$Name = "*",
    [Parameter(Mandatory = $false)]
    [switch]$IncludeAvailableUpdates
  )

  Begin {
    Write-Verbose "[BEGIN]: Get-WinGetPackages"
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
      Write-Warning "WinGet is not installed or not in PATH"
      return
    }
  }

  Process {
    Write-Verbose "[PROCESS]: Get-WinGetPackages"
    try {
      $WinGetOutput = winget list --accept-source-agreements | Out-String
      $Lines = $WinGetOutput -split "`n" | Where-Object {
        $_ -and $_ -notmatch '^-+$' -and $_ -notmatch 'Name.*Id.*Version' -and $_.Trim()
      }

      $Results = foreach ($Line in $Lines[2..($Lines.Count - 1)]) {
        if ($Line -match '^\s*(.+?)\s{2,}(.+?)\s{2,}(.+?)(?:\s{2,}(.+?))?\s*$') {
          $PackageName = $Matches[1].Trim()
          $PackageId = $Matches[2].Trim()
          $Version = $Matches[3].Trim()
          $Source = if ($Matches[4]) { $Matches[4].Trim() } else { "Unknown" }

          if ($PackageName -like $Name) {
            [PSCustomObject]@{
              Name            = $PackageName
              Id              = $PackageId
              Version         = $Version
              Source          = $Source
              UpdateAvailable = $false
              PackageManager  = 'WinGet'
              PSTypeName      = 'PSSystemDiagnostics.WinGetPackage'
            }
          }
        }
      }

      if ($IncludeAvailableUpdates -and $Results) {
        Write-Verbose "Checking for available updates..."
        try {
          $UpgradeOutput = winget upgrade --accept-source-agreements | Out-String
          $UpgradeLines = $UpgradeOutput -split "`n"

          foreach ($Result in $Results) {
            $UpgradeLine = $UpgradeLines | Where-Object { $_ -match [regex]::Escape($Result.Id) }
            if ($UpgradeLine) {
              $Result.UpdateAvailable = $true
            }
          }
        } catch {
          Write-Warning "Failed to check for updates: $_"
        }
      }
    } catch {
      Write-Error "Failed to retrieve WinGet packages: $_"
      $Results = @()
    }
  }

  End {
    Write-Verbose "[END]: Get-WinGetPackages"
    if ($Results) {
      $Results = $Results | Sort-Object Name
    } else {
      Write-Warning "No WinGet packages found matching criteria."
    }
    Write-Verbose "Total WinGet packages found: $($Results.Count)"
    Write-Verbose "Get-WinGetPackages completed."
    return $Results
  }
}
