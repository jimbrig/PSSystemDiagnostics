Function Get-SystemComponents {
  <#
  .SYNOPSIS
      Retrieves a list of installed system components and frameworks.
  .DESCRIPTION
      This function queries the Windows registry to retrieve information about system components,
      including .NET frameworks, Visual C++ redistributables, and Windows SDK components.
  .PARAMETER Name
      Specifies a wildcard pattern to filter the component names.
      Default is "*", which matches all components.
  .INPUTS
      None. This function does not accept pipeline input.
  .OUTPUTS
      System.Collections.Generic.List[PSCustomObject]
      Returns a list of custom objects representing system components, with properties such as:
      DisplayName, DisplayVersion, Publisher, InstallDate, EstimatedSizeMB, Architecture,
      ComponentType, Source, and PSTypeName.
  .EXAMPLE
      PS> Get-SystemComponents -Name "*Framework*"
      Retrieves all system components with names containing "Framework".
  .EXAMPLE
      PS> Get-SystemComponents -Name "*Visual C++*"
      Retrieves all Visual C++ redistributable components.
  .NOTES
      This function is designed to work on Windows systems and requires appropriate permissions to read the registry.
      It focuses on system-level components that are typically hidden from standard software lists.
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
    [string]$Name = "*"
  )

  Begin {
    Write-Verbose "[BEGIN]: Get-SystemComponents"
    $SystemPaths = @(
      "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
      "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    )
  }

  Process {
    Write-Verbose "[PROCESS]: Get-SystemComponents"
    try {
      $Results = foreach ($Path in $SystemPaths) {
        $Items = Get-ItemProperty "$Path\*" -ErrorAction SilentlyContinue

        foreach ($Item in $Items) {
          if ($Item.DisplayName -and $Item.DisplayName -like $Name) {
            if ($Item.SystemComponent -eq 1 -or
              $Item.ParentKeyName -or
              $Item.DisplayName -match 'Microsoft.*Runtime|SDK|Framework|Redistributable') {

              [PSCustomObject]@{
                DisplayName     = $Item.DisplayName
                DisplayVersion  = $Item.DisplayVersion
                Publisher       = $Item.Publisher
                InstallDate     = if ($Item.InstallDate) {
                  try { [DateTime]::ParseExact($Item.InstallDate, 'yyyyMMdd', $null).ToString('dd.MM.yyyy') }
                  catch { $Item.InstallDate }
                } else { $null }
                EstimatedSizeMB = if ($Item.EstimatedSize) {
                  [math]::Round($Item.EstimatedSize / 1024, 2)
                } else { $null }
                Architecture    = if ($Path -like '*WOW6432Node*') { 'x86' } else { 'x64' }
                ComponentType   = if ($Item.DisplayName -match 'Runtime') { 'Runtime' }
                elseif ($Item.DisplayName -match 'SDK') { 'SDK' }
                elseif ($Item.DisplayName -match 'Framework') { 'Framework' }
                elseif ($Item.DisplayName -match 'Redistributable') { 'Redistributable' }
                else { 'System Component' }
                Source          = 'System'
                PSTypeName      = 'PSSystemDiagnostics.SystemComponent'
              }
            }
          }
        }
      }
    } catch {
      Write-Error "Failed to retrieve system components: $_"
      $Results = @()
    }
  }

  End {
    Write-Verbose "[END]: Get-SystemComponents"
    if ($Results) {
      $Results = $Results | Sort-Object DisplayName
    } else {
      Write-Warning "No system components found matching criteria."
    }
    Write-Verbose "Total system components found: $($Results.Count)"
    Write-Verbose "Get-SystemComponents completed."
    return $Results
  }
}
