Function Get-StoreApps {
  <#
  .SYNOPSIS
      Retrieves a list of installed Microsoft Store applications.
  .DESCRIPTION
      This function queries the system to retrieve information about installed Microsoft Store apps.
      It can filter results based on app name, include framework packages, and query all users.
  .PARAMETER Name
      Specifies a wildcard pattern to filter the app names.
      Default is "*", which matches all apps.
  .PARAMETER IncludeFrameworks
      If specified, includes framework packages in the results.
  .PARAMETER AllUsers
      If specified, retrieves apps for all users on the system.
  .INPUTS
      None. This function does not accept pipeline input.
  .OUTPUTS
      System.Collections.Generic.List[PSCustomObject]
      Returns a list of custom objects representing Store apps, with properties such as:
      Name, DisplayName, Version, Publisher, Architecture, InstallLocation, PackageFamilyName,
      IsFramework, EstimatedSizeMB, InstallDate, PackageManager, and PSTypeName.
  .EXAMPLE
      PS> Get-StoreApps -Name "Microsoft*"
      Retrieves all Store apps with names starting with "Microsoft".
  .EXAMPLE
      PS> Get-StoreApps -IncludeFrameworks -AllUsers
      Retrieves all Store apps including frameworks for all users.
  .NOTES
      This function requires appropriate permissions to query app packages.
      Size calculation may take time for apps with large installation directories.
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
    [string]$Name = "*",
    [Parameter(Mandatory = $false)]
    [switch]$IncludeFrameworks,
    [Parameter(Mandatory = $false)]
    [switch]$AllUsers
  )

  Begin {
    Write-Verbose "[BEGIN]: Get-StoreApps"
  }

  Process {
    Write-Verbose "[PROCESS]: Get-StoreApps"
    try {
      $StoreApps = if ($AllUsers) {
        Get-AppxPackage -AllUsers | Where-Object { $_.Name -like $Name }
      } else {
        Get-AppxPackage | Where-Object { $_.Name -like $Name }
      }

      if (-not $IncludeFrameworks) {
        $StoreApps = $StoreApps | Where-Object { $_.IsFramework -eq $false }
      }

      $Results = foreach ($App in $StoreApps) {
        $SizeMB = if ($App.InstallLocation -and (Test-Path $App.InstallLocation)) {
          try {
            $Size = (Get-ChildItem $App.InstallLocation -Recurse -ErrorAction SilentlyContinue |
              Measure-Object -Property Length -Sum).Sum
            [math]::Round($Size / 1MB, 2)
          } catch { $null }
        } else { $null }

        [PSCustomObject]@{
          Name              = $App.Name
          DisplayName       = $App.PackageFullName
          Version           = $App.Version.ToString()
          Publisher         = $App.Publisher
          Architecture      = $App.Architecture.ToString()
          InstallLocation   = $App.InstallLocation
          PackageFamilyName = $App.PackageFamilyName
          IsFramework       = $App.IsFramework
          EstimatedSizeMB   = $SizeMB
          InstallDate       = $null
          PackageManager    = 'Microsoft Store'
          PSTypeName        = 'PSSystemDiagnostics.StoreApp'
        }
      }
    } catch {
      Write-Error "Failed to retrieve Microsoft Store apps: $_"
      $Results = @()
    }
  }

  End {
    Write-Verbose "[END]: Get-StoreApps"
    if ($Results) {
      $Results = $Results | Sort-Object Name
    } else {
      Write-Warning "No Microsoft Store apps found matching criteria."
    }
    Write-Verbose "Total Store apps found: $($Results.Count)"
    Write-Verbose "Get-StoreApps completed."
    return $Results
  }
}
