Function Get-MissingDrivers {
  <#
    .SYNOPSIS
        Identifies devices with missing or problematic drivers.
    .DESCRIPTION
        This function scans the system for devices that have driver issues,
        including missing drivers, corrupted drivers, or configuration problems.
    .PARAMETER IncludeVGABasic
        If specified, includes basic VGA devices in the results.
    .INPUTS
        None. This function does not accept pipeline input.
    .OUTPUTS
        System.Collections.Generic.List[PSCustomObject]
        Returns a list of custom objects representing devices with driver problems.
    .EXAMPLE
        PS> Get-MissingDrivers
        Identifies all devices with driver problems.
    .EXAMPLE
        PS> Get-MissingDrivers -IncludeVGABasic
        Identifies driver problems including basic VGA devices.
    .NOTES
        This function uses WMI to query device information and may require administrator privileges.
        Error codes are translated to human-readable descriptions.
    #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false)]
    [switch]$IncludeVGABasic
  )

  Begin {
    Write-Verbose "[BEGIN]: Get-MissingDrivers"

    $ErrorCodeMap = @{
      1  = "Device is not configured correctly."
      2  = "Windows cannot load the driver for this device."
      3  = "Driver for this device might be corrupted, or the system may be low on memory or other resources."
      4  = "Device is not working properly. One of its drivers or the registry might be corrupted."
      5  = "Driver for the device requires a resource that Windows cannot manage."
      6  = "Boot configuration for the device conflicts with other devices."
      7  = "Cannot filter."
      8  = "Driver loader for the device is missing."
      9  = "Device is not working properly. The controlling firmware is incorrectly reporting the resources for the device."
      10 = "Device cannot start."
      11 = "Device failed."
      12 = "Device cannot find enough free resources to use."
      13 = "Windows cannot verify the device's resources."
      14 = "Device cannot work properly until the computer is restarted."
      15 = "Device is not working properly due to a possible re-enumeration problem."
      16 = "Windows cannot identify all of the resources that the device uses."
      17 = "Device is requesting an unknown resource type."
      18 = "Device drivers must be reinstalled."
      19 = "Failure using the VxD loader."
      20 = "Registry might be corrupted."
      21 = "System failure. If changing the device driver is ineffective, see the hardware documentation. Windows is removing the device."
      22 = "Device is disabled."
      23 = "System failure. If changing the device driver is ineffective, see the hardware documentation."
      24 = "Device is not present, not working properly, or does not have all of its drivers installed."
      25 = "Windows is still setting up the device."
      26 = "Windows is still setting up the device."
      27 = "Device does not have valid log configuration."
      28 = "Device drivers are not installed."
      29 = "Device is disabled. The device firmware did not provide the required resources."
      30 = "Device is using an IRQ resource that another device is using."
      31 = "Device is not working properly. Windows cannot load the required device drivers."
    }
  }

  Process {
    Write-Verbose "[PROCESS]: Get-MissingDrivers"
    try {
      $Results = @()

      # Get devices with configuration manager errors
      $ProblemDevices = Get-WmiObject Win32_PNPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 }

      foreach ($Device in $ProblemDevices) {
        $ErrorDescription = $ErrorCodeMap[$Device.ConfigManagerErrorCode]
        if (-not $ErrorDescription) {
          $ErrorDescription = "Unknown error code: $($Device.ConfigManagerErrorCode)"
        }

        $Results += [PSCustomObject]@{
          Name                   = $Device.Name
          DeviceID               = $Device.DeviceID
          ConfigManagerErrorCode = $Device.ConfigManagerErrorCode
          ErrorDescription       = $ErrorDescription
          Status                 = $Device.Status
          PNPDeviceID            = $Device.PNPDeviceID
          DeviceType             = 'Problem Device'
          PSTypeName             = 'PSSystemDiagnostics.ProblemDevice'
        }
      }

      # Include VGA basic devices if requested
      if ($IncludeVGABasic) {
        $VGADevices = Get-WmiObject Win32_PNPEntity | Where-Object { $_.Name -match "VGA" }
        foreach ($Device in $VGADevices) {
          $Results += [PSCustomObject]@{
            Name                   = $Device.Name
            DeviceID               = $Device.DeviceID
            ConfigManagerErrorCode = $Device.ConfigManagerErrorCode
            ErrorDescription       = if ($Device.ConfigManagerErrorCode -ne 0) { $ErrorCodeMap[$Device.ConfigManagerErrorCode] } else { "No Error" }
            Status                 = $Device.Status
            PNPDeviceID            = $Device.PNPDeviceID
            DeviceType             = 'VGA Device'
            PSTypeName             = 'PSSystemDiagnostics.ProblemDevice'
          }
        }
      }
    } catch {
      Write-Error "Failed to retrieve device information: $_"
      $Results = @()
    }
  }

  End {
    Write-Verbose "[END]: Get-MissingDrivers"
    if ($Results) {
      Write-Verbose "Problem devices found: $($Results.Count)"
      $ProblemCount = ($Results | Where-Object { $_.ConfigManagerErrorCode -ne 0 }).Count
      if ($ProblemCount -gt 0) {
        Write-Warning "$ProblemCount devices have driver problems"
      }
    } else {
      Write-Verbose "No problem devices found."
    }
    Write-Verbose "Get-MissingDrivers completed."
    return $Results
  }
}
