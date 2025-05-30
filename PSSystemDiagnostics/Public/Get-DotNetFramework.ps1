Function Get-DotNetFramework {
  <#
  .SYNOPSIS
      This function will retrieve the list of Framework Installed on the computer.
  .DESCRIPTION
      This function will retrieve the list of Framework Installed on the computer.
  #>
  [CmdletBinding()]
  Param()

  Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
  Get-ItemProperty -Name Version -EA 0 |
  Where-Object -FilterScript { $_.PSChildName -match '^(?!S)\p{L}' } |
  Select-Object -Property Version

}
