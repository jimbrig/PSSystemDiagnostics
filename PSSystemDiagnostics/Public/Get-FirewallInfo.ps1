Function Get-FirewallInfo {
  <#
  .SYNOPSIS
      Retrieves Windows Firewall configuration and rules.
  .DESCRIPTION
      This function collects Windows Firewall profile settings and firewall rules,
      providing comprehensive firewall configuration information.
  .PARAMETER IncludeRules
      If specified, includes detailed firewall rules in addition to profile information.
  .INPUTS
      None. This function does not accept pipeline input.
  .OUTPUTS
      System.Collections.Hashtable
      Returns a hashtable containing firewall profiles and optionally rules information.
  .EXAMPLE
      PS> Get-FirewallInfo
      Retrieves firewall profile information only.
  .EXAMPLE
      PS> Get-FirewallInfo -IncludeRules
      Retrieves firewall profiles and all firewall rules.
  .NOTES
      This function requires administrator privileges to access firewall configuration.
      The NetSecurity PowerShell module must be available on the system.
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false)]
    [switch]$IncludeRules
  )

  Begin {
    Write-Verbose "[BEGIN]: Get-FirewallInfo"
    $FirewallInfo = @{
      Profiles = @()
      Rules    = @()
    }
  }

  Process {
    Write-Verbose "[PROCESS]: Get-FirewallInfo"
    try {
      Write-Verbose "Retrieving firewall profiles..."
      $FirewallInfo.Profiles = Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction, LogAllowed, LogBlocked, LogFileName

      if ($IncludeRules) {
        Write-Verbose "Retrieving firewall rules..."
        $FirewallInfo.Rules = Get-NetFirewallRule | Select-Object DisplayName, Description, DisplayGroup, Action, Direction, Enabled, Profile
      }
    } catch {
      Write-Error "Failed to retrieve firewall information: $_"
    }
  }

  End {
    Write-Verbose "[END]: Get-FirewallInfo"
    Write-Verbose "Firewall profiles found: $($FirewallInfo.Profiles.Count)"
    if ($IncludeRules) {
      Write-Verbose "Firewall rules found: $($FirewallInfo.Rules.Count)"
    }
    Write-Verbose "Get-FirewallInfo completed."
    return $FirewallInfo
  }
}
