Function Update-PSHelp {
  <#
  .SYNOPSIS
      Update PowerShell help to the latest version.
  .DESCRIPTION
      This function updates the PowerShell help files for all installed modules to the latest version.
      It uses the `Update-Help` cmdlet to download and install the latest help files.
  #>
  [CmdletBinding(SupportsShouldProcess)]
  [OutputType([Void])]
  Param()

  Begin {
    Write-Verbose -Message '[BEGIN]: Update-PSHelp'
  }

  Process {
    if ($PSCmdlet.ShouldProcess('PowerShell Help', 'Update')) {
      Write-Verbose -Message 'Updating PowerShell help files...'
      Write-Progress -Activity 'Updating PowerShell Help' -Status 'Starting...' -PercentComplete 0
      try {
        Write-Progress -Activity 'Updating PowerShell Help' -Status 'Updating for CurrentUser' -PercentComplete 25
        Update-Help -Force -Scope CurrentUser -ErrorAction Stop
        Write-Progress -Activity 'Updating PowerShell Help' -Status 'Updating for AllUsers' -PercentComplete 50
        Update-Help -Force -Scope AllUsers -ErrorAction Stop
        Write-Progress -Activity 'Updating PowerShell Help' -Status 'Finalizing...' -PercentComplete 75
        Write-Progress -Activity 'Updating PowerShell Help' -Status 'Completed' -PercentComplete 100
      } catch {
        Write-Error -Message "Failed to update PowerShell help: $_"
      }
      Write-Verbose -Message 'PowerShell help files updated successfully.'
      Write-Progress -Activity 'Updating PowerShell Help' -Completed
    } else {
      Write-Verbose -Message 'Update-PSHelp was skipped due to ShouldProcess.'
    }
  }

  End {
    Write-Verbose -Message '[END]: Update-PSHelp'
  }
}
