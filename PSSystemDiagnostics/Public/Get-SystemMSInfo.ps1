Function Get-SystemMSInfo {
  <#
  .SYNOPSIS
      Exports system information using MSInfo32.
  .DESCRIPTION
      This function generates a comprehensive system information report using the MSInfo32 utility.
      The report includes hardware, software, and system configuration details.
  .PARAMETER OutputPath
      Specifies the path where the MSInfo report should be saved.
      Default is the current user's desktop under SystemExport folder.
  .INPUTS
      None. This function does not accept pipeline input.
  .OUTPUTS
      System.IO.FileInfo
      Returns the file information object for the generated MSInfo report.
  .EXAMPLE
      PS> Get-SystemMSInfo -OutputPath "C:\Reports"
      Generates MSInfo report and saves it to C:\Reports\msinfo.txt
  .EXAMPLE
      PS> Get-SystemMSInfo
      Generates MSInfo report using default path.
  .NOTES
      This function requires MSInfo32.exe to be available on the system.
      The function may take several minutes to complete depending on system complexity.
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$OutputPath = "$env:USERPROFILE\Desktop\SystemExport"
  )

  Begin {
    Write-Verbose "[BEGIN]: Get-SystemMSInfo"
    New-Item $OutputPath -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    $ReportPath = Join-Path $OutputPath "msinfo.txt"
  }

  Process {
    Write-Verbose "[PROCESS]: Get-SystemMSInfo"
    try {
      Write-Verbose "Generating MSInfo report to: $ReportPath"
      Start-Process 'msinfo32' -ArgumentList "/report `"$ReportPath`"" -Wait -WindowStyle Hidden | Out-Null
      $Result = Get-Item $ReportPath -ErrorAction Stop
    } catch {
      Write-Error "Failed to generate MSInfo report: $_"
      $Result = $null
    }
  }

  End {
    Write-Verbose "[END]: Get-SystemMSInfo"
    if ($Result) {
      Write-Verbose "MSInfo report generated successfully: $($Result.FullName)"
    } else {
      Write-Warning "MSInfo report generation failed."
    }
    Write-Verbose "Get-SystemMSInfo completed."
    return $Result
  }
}
