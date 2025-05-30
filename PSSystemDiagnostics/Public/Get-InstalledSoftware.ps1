Function Get-InstalledSoftware {
    <#
    .SYNOPSIS
        Retrieves a list of installed software from the Windows registry.
    .DESCRIPTION
        This function queries the Windows registry to retrieve information about installed software.
        It can filter results based on display name, include system components, and include updates.
    .PARAMETER DisplayName
        Specifies a wildcard pattern to filter the display names of installed software.
        Default is "*", which matches all software.
    .PARAMETER IncludeSystemComponents
        If specified, includes system components in the results.
    .PARAMETER IncludeUpdates
        If specified, includes updates in the results.
    .INPUTS
        None. This function does not accept pipeline input.
    .OUTPUTS
        System.Collections.Generic.List[PSCustomObject]
        Returns a list of custom objects representing installed software, with properties such as:
        DisplayName, DisplayVersion, Publisher, InstallDate, InstallLocation, UninstallString, QuietUninstallString,
        EstimatedSizeMB, RegistryPath, Architecture, Source, and PSTypeName.
    .EXAMPLE
        PS> Get-InstalledSoftware -DisplayName "Microsoft*" -IncludeSystemComponents
        Retrieves all installed software with display names starting with "Microsoft", including system components.
    .EXAMPLE
        PS> Get-InstalledSoftware -DisplayName "Visual Studio*" -IncludeUpdates
        Retrieves all installed software with display names starting with "Visual Studio", including updates.
    .NOTES
        This function is designed to work on Windows systems and requires appropriate permissions to read the registry.
        It may not return results for software installed by non-standard methods or in non-standard locations.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string]$DisplayName = "*",
        [Parameter(Mandatory = $false)]
        [switch]$IncludeSystemComponents,
        [Parameter(Mandatory = $false)]
        [switch]$IncludeUpdates
    )

    Begin {
        Write-Verbose "[BEGIN]: Get-InstalledSoftware"
        $UninstallPaths = @(
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
            "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
        )
    }

    Process {
        Write-Verbose "[PROCESS]: Get-InstalledSoftware"
        $Results = foreach ($Path in $UninstallPaths) {
            try {
                $Items = Get-ItemProperty "$Path\*" -ErrorAction SilentlyContinue

                foreach ($Item in $Items) {
                    if ($Item.DisplayName -and $Item.DisplayName -like $DisplayName) {
                        # Filter out system components and updates if not requested
                        $SystemComponent = $Item.SystemComponent
                        $ParentKeyName = $Item.ParentKeyName
                        $IsUpdate = $Item.DisplayName -match 'Update|Hotfix|KB\d+'

                        if ((-not $SystemComponent -or $IncludeSystemComponents) -and
                            (-not $ParentKeyName -or $IncludeSystemComponents) -and
                            (-not $IsUpdate -or $IncludeUpdates)) {

                            [PSCustomObject]@{
                                DisplayName          = $Item.DisplayName
                                DisplayVersion       = $Item.DisplayVersion
                                Publisher            = $Item.Publisher
                                InstallDate          = if ($Item.InstallDate) {
                                    try { [DateTime]::ParseExact($Item.InstallDate, 'yyyyMMdd', $null).ToString('dd.MM.yyyy') }
                                    catch { $Item.InstallDate }
                                } else { $null }
                                InstallLocation      = $Item.InstallLocation
                                UninstallString      = $Item.UninstallString
                                QuietUninstallString = $Item.QuietUninstallString
                                EstimatedSizeMB      = if ($Item.EstimatedSize) {
                                    [math]::Round($Item.EstimatedSize / 1024, 2)
                                } else { $null }
                                RegistryPath         = $Item.PSPath
                                Architecture         = if ($Path -like '*WOW6432Node*') { 'x86' } elseif ($Path -like '*HKCU*') { 'User' } else { 'x64' }
                                Source               = 'Registry'
                                PSTypeName           = 'PSSystemDiagnostics.InstalledSoftware'
                            }
                        }
                    }
                }
            } catch {
                Write-Warning "Failed to query $Path`: $_"
            }
        }
    }

    End {
        Write-Verbose "[END]: Get-InstalledSoftware"
        if ($Results) {
            $Results | Sort-Object DisplayName
        } else {
            Write-Warning "No installed software found matching criteria."
        }
        Write-Verbose "Total items found: $($Results.Count)"
        if ($Results.Count -eq 0) {
            Write-Warning "No installed software found matching criteria."
        }
        Write-Verbose "Get-InstalledSoftware completed."
        return $Results
    }
}
