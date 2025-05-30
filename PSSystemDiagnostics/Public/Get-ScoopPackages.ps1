Function Get-ScoopPackages {
  <#
  .SYNOPSIS
      Retrieves a list of installed packages from Scoop package manager.
  .DESCRIPTION
      This function queries Scoop to retrieve information about locally installed packages.
      It can filter results based on package name and includes bucket and status information.
  .PARAMETER Name
      Specifies a wildcard pattern to filter the package names.
      Default is "*", which matches all packages.
  .INPUTS
      None. This function does not accept pipeline input.
  .OUTPUTS
      System.Collections.Generic.List[PSCustomObject]
      Returns a list of custom objects representing Scoop packages, with properties such as:
      Name, Version, Bucket, Status, PackageManager, InstallPath, and PSTypeName.
  .EXAMPLE
      PS> Get-ScoopPackages -Name "git*"
      Retrieves all Scoop packages with names starting with "git".
  .EXAMPLE
      PS> Get-ScoopPackages
      Retrieves all installed Scoop packages.
  .NOTES
      This function requires Scoop to be installed and available in the system PATH.
      The function uses 'scoop list' to retrieve package information.
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
    [string]$Name = "*"
  )

  Begin {
    Write-Verbose "[BEGIN]: Get-ScoopPackages"
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
      Write-Warning "Scoop is not installed or not in PATH"
      return
    }
  }

  Process {
    Write-Verbose "[PROCESS]: Get-ScoopPackages"
    try {
      $ScoopApps = & scoop list 6>&1

      $Results = foreach ($Line in $ScoopApps) {
        if ($Line -match '^\s*(\S+)\s+(\S+)(?:\s+\[(\S+)\])?\s*(\S+)?\s*$') {
          $PackageName = $Matches[1]
          $Version = $Matches[2]
          $Bucket = $Matches[3]
          $Status = $Matches[4]

          if ($PackageName -like $Name) {
            [PSCustomObject]@{
              Name           = $PackageName
              Version        = $Version
              Bucket         = $Bucket
              Status         = $Status
              PackageManager = 'Scoop'
              InstallPath    = "$env:USERPROFILE\scoop\apps\$PackageName"
              PSTypeName     = 'PSSystemDiagnostics.ScoopPackage'
            }
          }
        }
      }
    } catch {
      Write-Error "Failed to retrieve Scoop packages: $_"
      $Results = @()
    }
  }

  End {
    Write-Verbose "[END]: Get-ScoopPackages"
    if ($Results) {
      $Results = $Results | Sort-Object Name
    } else {
      Write-Warning "No Scoop packages found matching criteria."
    }
    Write-Verbose "Total Scoop packages found: $($Results.Count)"
    Write-Verbose "Get-ScoopPackages completed."
    return $Results
  }
}
