Function Invoke-DockerDesktopDiagnostics {
  <#
  .SYNOPSIS
      Invokes the Docker Desktop Self-Diagnose Tool.
  .DESCRIPTION
      Docker Desktop contains a self-diagnose tool which can help you identify some common problems.
      This function invokes the self-diagnose tool performing the check and generating a report.
  .PARAMETER Action
      The action to perform. The default is 'check'. The available actions are:
      - check
      - login
      - gather
      - upload
      - check-hypervisor
      - detect-host-hypervisor
  .EXAMPLE
      Invoke-DockerDesktopDiagnostics
  .EXAMPLE
      Invoke-DockerDesktopDiagnostics -Action check
  .OUTPUTS
      The output of the Docker Desktop Self-Diagnose Tool.
  .NOTES
      See https://docs.docker.com/desktop/troubleshoot/overview/#self-diagnose-tool for more information.
  #>
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory = $false)]
    [ValidateSet('gather', 'upload', 'check-hypervisor', 'detect-host-hypervisor')]
    [String]$Action = 'gather'
  )

  Begin {

    Write-Verbose "[BEGIN]: Invoke-DockerDesktopDiagnostics"

    # Ensure Docker Desktop is installed
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
      Write-Error 'Docker Desktop is not installed or not in the PATH'
      return
    }

    # Ensure Docker Desktop is running
    if (-not (Get-Service com.docker.service -ErrorAction SilentlyContinue)) {
      Write-Error 'Docker Desktop is not running'
      return
    }

    # Specify the path to the Docker Desktop Diagnose Tool
    $DockerDiagnosticToolPath = "$Env:PROGRAMFILES\Docker\Docker\resources\com.docker.diagnose.exe"

    # Ensure Docker Desktop Diagnose Tool is installed
    if (-not (Test-Path $DockerDiagnosticToolPath)) {
      Write-Error "Docker Desktop Diagnose Tool not found at $DockerDiagnosticToolPath"
      return
    }
  }

  Process {

    Write-Verbose "[PROCESS]: Invoke-DockerDesktopDiagnostics"

    & "$DockerDiagnosticToolPath" $Action

  }

  End {
    Write-Verbose "[END]: Invoke-DockerDesktopDiagnostics"
  }

}
