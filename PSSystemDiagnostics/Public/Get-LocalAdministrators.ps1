Function Get-LocalAdministrators {
  <#
  .SYNOPSIS
      Retrieves members of the local Administrators group.
  .DESCRIPTION
      This function queries the local Administrators group to retrieve all members,
      including both local and domain accounts with administrative privileges.
  .PARAMETER IncludePowerUsers
      If specified, also retrieves members of the Power Users group.
  .INPUTS
      None. This function does not accept pipeline input.
  .OUTPUTS
      System.Collections.Generic.List[PSCustomObject]
      Returns a list of custom objects representing local administrator accounts.
  .EXAMPLE
      PS> Get-LocalAdministrators
      Retrieves all members of the local Administrators group.
  .EXAMPLE
      PS> Get-LocalAdministrators -IncludePowerUsers
      Retrieves members of both Administrators and Power Users groups.
  .NOTES
      This function requires appropriate permissions to query local group membership.
      Falls back to net.exe commands if PowerShell cmdlets are not available.
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false)]
    [switch]$IncludePowerUsers
  )

  Begin {
    Write-Verbose "[BEGIN]: Get-LocalAdministrators"
    $Results = @()
  }

  Process {
    Write-Verbose "[PROCESS]: Get-LocalAdministrators"
    try {
      Write-Verbose "Retrieving local administrators..."
      $Admins = Get-LocalGroupMember -Name "Administrators" -ErrorAction Stop

      $Results += foreach ($Admin in $Admins) {
        [PSCustomObject]@{
          Name            = $Admin.Name
          ObjectClass     = $Admin.ObjectClass
          PrincipalSource = $Admin.PrincipalSource
          SID             = $Admin.SID
          GroupType       = 'Administrators'
          PSTypeName      = 'PSSystemDiagnostics.LocalGroupMember'
        }
      }

      if ($IncludePowerUsers) {
        Write-Verbose "Retrieving power users..."
        try {
          $PowerUsers = Get-LocalGroupMember -Name "Power Users" -ErrorAction Stop
          $Results += foreach ($PowerUser in $PowerUsers) {
            [PSCustomObject]@{
              Name            = $PowerUser.Name
              ObjectClass     = $PowerUser.ObjectClass
              PrincipalSource = $PowerUser.PrincipalSource
              SID             = $PowerUser.SID
              GroupType       = 'Power Users'
              PSTypeName      = 'PSSystemDiagnostics.LocalGroupMember'
            }
          }
        } catch {
          Write-Verbose "Power Users group not found or empty"
        }
      }
    } catch {
      Write-Warning "PowerShell cmdlets failed, falling back to net.exe: $_"
      try {
        $NetOutput = & net localgroup administrators 2>$null
        $Results += foreach ($Line in $NetOutput) {
          if ($Line -match '^[A-Za-z]' -and $Line -notmatch 'command completed|members of') {
            [PSCustomObject]@{
              Name            = $Line.Trim()
              ObjectClass     = 'Unknown'
              PrincipalSource = 'Unknown'
              SID             = $null
              GroupType       = 'Administrators'
              PSTypeName      = 'PSSystemDiagnostics.LocalGroupMember'
            }
          }
        }
      } catch {
        Write-Error "Failed to retrieve local administrators: $_"
      }
    }
  }

  End {
    Write-Verbose "[END]: Get-LocalAdministrators"
    if ($Results) {
      Write-Verbose "Local group members found: $($Results.Count)"
    } else {
      Write-Warning "No local group members found."
    }
    Write-Verbose "Get-LocalAdministrators completed."
    return $Results
  }
}
