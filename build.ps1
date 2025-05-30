[cmdletbinding(DefaultParameterSetName = 'Task')]
param(
    # Build task(s) to execute
    [parameter(ParameterSetName = 'task', position = 0)]
    [ArgumentCompleter( {
        param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
        $psakeFile = './psakeFile.ps1'
        switch ($Parameter) {
            'Task' {
                if ([string]::IsNullOrEmpty($WordToComplete)) {
                    Get-PSakeScriptTasks -buildFile $psakeFile | Select-Object -ExpandProperty Name
                }
                else {
                    Get-PSakeScriptTasks -buildFile $psakeFile |
                        Where-Object { $_.Name -match $WordToComplete } |
                        Select-Object -ExpandProperty Name
                }
            }
            Default {
            }
        }
    })]
    [string[]]$Task = 'default',

    # Bootstrap dependencies
    [switch]$Bootstrap,

    # List available build tasks
    [parameter(ParameterSetName = 'Help')]
    [switch]$Help,

    [Parameter(Mandatory = $false)]
    [PSCredential]$PSGalleryApiKey,

    # Optional properties to pass to psake
    [hashtable]$Properties,

    # Optional parameters to pass to psake
    [hashtable]$Parameters
)

$ErrorActionPreference = 'Stop'

# Bootstrap dependencies
if ($Bootstrap.IsPresent) {
    Write-Host "Checking build dependencies..." -ForegroundColor Cyan

    # Required modules for the build process
    $requiredModules = @('psake', 'BuildHelpers', 'PowerShellBuild', 'PSScriptAnalyzer', 'PlatyPS', 'Pester')
    $missingModules = @()

    foreach ($module in $requiredModules) {
        if (-not (Get-Module -Name $module -ListAvailable)) {
            $missingModules += $module
        }
    }

    if ($missingModules.Count -gt 0) {
        Write-Host "Installing missing modules: $($missingModules -join ', ')" -ForegroundColor Yellow

        # Use PSResourceGet if available, fallback to Install-Module
        if (Get-Command Install-PSResource -ErrorAction SilentlyContinue) {
            foreach ($module in $missingModules) {
                Install-PSResource -Name $module -Repository PSGallery -Scope CurrentUser -TrustRepository
            }
        } else {
            # Fallback to traditional method
            Get-PackageProvider -Name Nuget -ForceBootstrap | Out-Null
            Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
            foreach ($module in $missingModules) {
                Install-Module -Name $module -Repository PSGallery -Scope CurrentUser -Force
            }
        }
    } else {
        Write-Host "All required modules are already installed." -ForegroundColor Green
    }

    # Import required modules
    foreach ($module in $requiredModules) {
        Import-Module -Name $module -Force -Verbose:$false
    }
}

# Execute psake task(s)
$psakeFile = './psakeFile.ps1'
if ($PSCmdlet.ParameterSetName -eq 'Help') {
    Get-PSakeScriptTasks -buildFile $psakeFile |
        Format-Table -Property Name, Description, Alias, DependsOn
} else {
    Set-BuildEnvironment -Force
    $parameters = @{}
    if ($PSGalleryApiKey) {
        $parameters['galleryApiKey'] = $PSGalleryApiKey
    }
    Invoke-psake -buildFile $psakeFile -taskList $Task -nologo -parameters $parameters
    exit ( [int]( -not $psake.build_success ) )
}
