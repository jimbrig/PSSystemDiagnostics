Function Get-ChocoPackages {
  <#
  .SYNOPSIS
      Retrieves a list of installed packages from Chocolatey package manager.
  .DESCRIPTION
      This function queries Chocolatey to retrieve information about locally installed packages.
      It can filter results based on package name.
  .PARAMETER Name
      Specifies a wildcard pattern to filter the package names.
      Default is "*", which matches all packages.
  .INPUTS
      None. This function does not accept pipeline input.
  .OUTPUTS
      System.Collections.Generic.List[PSCustomObject]
      Returns a list of custom objects representing Chocolatey packages, with properties such as:
      Name, Version, PackageManager, InstallPath, and PSTypeName.
  .EXAMPLE
      PS> Get-ChocolateyPackages -Name "git*"
      Retrieves all Chocolatey packages with names starting with "git".
  .EXAMPLE
      PS> Get-ChocolateyPackages
      Retrieves all installed Chocolatey packages.
  .NOTES
      This function requires Chocolatey to be installed and available in the system PATH.
      The function uses 'choco list --local-only' to retrieve package information.
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
    [string]$Name = "*"
  )

  Begin {
    Write-Verbose "[BEGIN]: Get-ChocolateyPackages"
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
      Write-Warning "Chocolatey is not installed or not in PATH"
      return
    }
  }

  Process {
    Write-Verbose "[PROCESS]: Get-ChocolateyPackages"
    try {
      $ChocoList = choco list --local-only --limit-output

      $Results = foreach ($Line in $ChocoList) {
        if ($Line -match '^(.+)\|(.+)$') {
          $PackageName = $Matches[1]
          $Version = $Matches[2]

          if ($PackageName -like $Name) {
            [PSCustomObject]@{
              Name           = $PackageName
              Version        = $Version
              PackageManager = 'Chocolatey'
              InstallPath    = "$env:ChocolateyInstall\lib\$PackageName"
              PSTypeName     = 'PSSystemDiagnostics.ChocolateyPackage'
            }
          }
        }
      }
    } catch {
      Write-Error "Failed to retrieve Chocolatey packages: $_"
      $Results = @()
    }
  }

  End {
    Write-Verbose "[END]: Get-ChocolateyPackages"
    if ($Results) {
      $Results = $Results | Sort-Object Name
    } else {
      Write-Warning "No Chocolatey packages found matching criteria."
    }
    Write-Verbose "Total Chocolatey packages found: $($Results.Count)"
    Write-Verbose "Get-ChocolateyPackages completed."
    return $Results
  }
}
