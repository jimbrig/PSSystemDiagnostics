Function Get-SystemServices {
  <#
  .SYNOPSIS
      Retrieves information about all system services.
  .DESCRIPTION
      This function queries all Windows services and returns their current status,
      startup type, and other relevant service information.
  .PARAMETER Name
      Specifies a wildcard pattern to filter service names.
      Default is "*", which matches all services.
  .PARAMETER Status
      Filters services by their current status (Running, Stopped, etc.).
  .INPUTS
      None. This function does not accept pipeline input.
  .OUTPUTS
      System.Collections.Generic.List[PSCustomObject]
      Returns a list of custom objects representing system services.
  .EXAMPLE
      PS> Get-SystemServices
      Retrieves information about all system services.
  .EXAMPLE
      PS> Get-SystemServices -Name "Windows*" -Status Running
      Retrieves running services with names starting with "Windows".
  .NOTES
      This function provides comprehensive service information including startup type and dependencies.
      Some service details may require administrator privileges to access.
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
    [string]$Name = "*",
    [Parameter(Mandatory = $false)]
    [ValidateSet('Running', 'Stopped', 'Paused', 'StartPending', 'StopPending', 'ContinuePending', 'PausePending')]
    [string]$Status
  )

  Begin {
    Write-Verbose "[BEGIN]: Get-SystemServices"
  }

  Process {
    Write-Verbose "[PROCESS]: Get-SystemServices"
    try {
      $Services = Get-Service -Name $Name

      if ($Status) {
        $Services = $Services | Where-Object { $_.Status -eq $Status }
      }

      $Results = foreach ($Service in $Services) {
        try {
          $ServiceWMI = Get-WmiObject -Class Win32_Service -Filter "Name='$($Service.Name)'" -ErrorAction SilentlyContinue

          [PSCustomObject]@{
            Name                = $Service.Name
            DisplayName         = $Service.DisplayName
            Status              = $Service.Status
            StartType           = $ServiceWMI.StartMode
            ServiceType         = $Service.ServiceType
            Account             = $ServiceWMI.StartName
            Description         = $ServiceWMI.Description
            PathName            = $ServiceWMI.PathName
            ProcessId           = $ServiceWMI.ProcessId
            CanPauseAndContinue = $Service.CanPauseAndContinue
            CanShutdown         = $Service.CanShutdown
            CanStop             = $Service.CanStop
            PSTypeName          = 'PSSystemDiagnostics.SystemService'
          }
        } catch {
          Write-Warning "Failed to get detailed information for service: $($Service.Name)"
          [PSCustomObject]@{
            Name                = $Service.Name
            DisplayName         = $Service.DisplayName
            Status              = $Service.Status
            StartType           = 'Unknown'
            ServiceType         = $Service.ServiceType
            Account             = 'Unknown'
            Description         = 'Unknown'
            PathName            = 'Unknown'
            ProcessId           = $null
            CanPauseAndContinue = $Service.CanPauseAndContinue
            CanShutdown         = $Service.CanShutdown
            CanStop             = $Service.CanStop
            PSTypeName          = 'PSSystemDiagnostics.SystemService'
          }
        }
      }
    } catch {
      Write-Error "Failed to retrieve system services: $_"
      $Results = @()
    }
  }

  End {
    Write-Verbose "[END]: Get-SystemServices"
    if ($Results) {
      $Results = $Results | Sort-Object Name
      Write-Verbose "System services found: $($Results.Count)"
      $RunningCount = ($Results | Where-Object { $_.Status -eq 'Running' }).Count
      Write-Verbose "Running services: $RunningCount"
    } else {
      Write-Warning "No system services found matching criteria."
    }
    Write-Verbose "Get-SystemServices completed."
    return $Results
  }
}
