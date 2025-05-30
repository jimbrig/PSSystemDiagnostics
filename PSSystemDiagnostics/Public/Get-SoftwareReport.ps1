Function Get-SoftwareReport {
  <#
  .SYNOPSIS
      Generates a comprehensive unified software inventory report.
  .DESCRIPTION
      This function collects software information from multiple sources including registry,
      package managers (WinGet, Chocolatey, Scoop), Microsoft Store, and system components
      to create a unified software inventory report.
  .PARAMETER IncludeSystemComponents
      If specified, includes system components in the report.
  .PARAMETER IncludeStoreApps
      If specified, includes Microsoft Store applications in the report.
  .PARAMETER IncludePackageManagers
      If specified, includes packages from WinGet, Chocolatey, and Scoop.
  .PARAMETER OutputPath
      Specifies the path where the report should be saved (without extension).
  .PARAMETER ExportFormat
      Specifies the export format for the report. Valid values are JSON, CSV, and HTML.
  .INPUTS
      None. This function does not accept pipeline input.
  .OUTPUTS
      System.Collections.Hashtable
      Returns a hashtable containing the complete software inventory report with summary statistics.
  .EXAMPLE
      PS> Get-SoftwareReport -IncludeStoreApps -IncludePackageManagers
      Generates a comprehensive report including Store apps and package manager data.
  .EXAMPLE
      PS> Get-SoftwareReport -IncludeSystemComponents -OutputPath "C:\Reports\Inventory" -ExportFormat JSON
      Generates a report with system components and exports it as JSON.
  .NOTES
      This function aggregates data from multiple sources and may take some time to complete.
      Ensure all required package managers are installed for complete coverage.
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false)]
    [switch]$IncludeSystemComponents,
    [Parameter(Mandatory = $false)]
    [switch]$IncludeStoreApps,
    [Parameter(Mandatory = $false)]
    [switch]$IncludePackageManagers,
    [Parameter(Mandatory = $false)]
    [string]$OutputPath,
    [Parameter(Mandatory = $false)]
    [ValidateSet('JSON', 'CSV', 'HTML')]
    [string]$ExportFormat = 'JSON'
  )

  Begin {
    Write-Verbose "[BEGIN]: Get-SoftwareReport"
    $Report = @{
      SystemName         = $env:COMPUTERNAME
      GeneratedOn        = Get-Date
      ToolName           = "PSSystemDiagnostics"
      StandardApps       = @()
      WinGetPackages     = @()
      ChocolateyPackages = @()
      ScoopPackages      = @()
      StoreApps          = @()
      SystemComponents   = @()
      Summary            = @{}
    }
  }

  Process {
    Write-Verbose "[PROCESS]: Get-SoftwareReport"

    Write-Verbose "Collecting standard applications..."
    $Report.StandardApps = Get-InstalledSoftware

    if ($IncludePackageManagers) {
      Write-Verbose "Collecting package manager data..."
      $Report.WinGetPackages = Get-WinGetPackages
      $Report.ChocolateyPackages = Get-ChocolateyPackages
      $Report.ScoopPackages = Get-ScoopPackages
    }

    if ($IncludeStoreApps) {
      Write-Verbose "Collecting Microsoft Store apps..."
      $Report.StoreApps = Get-StoreApps -AllUsers
    }

    if ($IncludeSystemComponents) {
      Write-Verbose "Collecting system components..."
      $Report.SystemComponents = Get-SystemComponents
    }

    # Generate summary statistics
    $TotalSize = ($Report.StandardApps | Where-Object EstimatedSizeMB |
      Measure-Object EstimatedSizeMB -Sum).Sum

    $Report.Summary = @{
      TotalStandardApps       = $Report.StandardApps.Count
      TotalWinGetPackages     = $Report.WinGetPackages.Count
      TotalChocolateyPackages = $Report.ChocolateyPackages.Count
      TotalScoopPackages      = $Report.ScoopPackages.Count
      TotalStoreApps          = $Report.StoreApps.Count
      TotalSystemComponents   = $Report.SystemComponents.Count
      TotalEstimatedSizeMB    = [math]::Round($TotalSize, 2)
      TotalEstimatedSizeGB    = [math]::Round($TotalSize / 1024, 2)
    }

    if ($OutputPath) {
      Write-Verbose "Exporting report to: $OutputPath"
      switch ($ExportFormat) {
        'JSON' {
          $Report | ConvertTo-Json -Depth 10 | Out-File -FilePath "$OutputPath.json" -Encoding UTF8
          Write-Verbose "Report exported to: $OutputPath.json"
        }
        'CSV' {
          $Report.StandardApps | Export-Csv -Path "$OutputPath.csv" -NoTypeInformation
          Write-Verbose "Report exported to: $OutputPath.csv"
        }
        'HTML' {
          $Html = $Report.StandardApps | ConvertTo-Html -Title "Software Inventory Report"
          $Html | Out-File -FilePath "$OutputPath.html" -Encoding UTF8
          Write-Verbose "Report exported to: $OutputPath.html"
        }
      }
    }
  }

  End {
    Write-Verbose "[END]: Get-SoftwareReport"
    Write-Verbose "Report generation completed."
    Write-Verbose "Total applications found: $($Report.Summary.TotalStandardApps)"
    Write-Verbose "Total estimated size: $($Report.Summary.TotalEstimatedSizeGB) GB"
    Write-Verbose "Get-SoftwareReport completed."
    return $Report
  }
}
