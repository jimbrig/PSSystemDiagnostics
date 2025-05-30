properties {
    # Set this to $true to create a module with a monolithic PSM1
    $PSBPreference.Build.CompileModule = $false
    $PSBPreference.Help.DefaultLocale = 'en-US'
    $PSBPreference.Test.OutputFile = 'out/testResults.xml'
    $PSBPreference.Test.OutputFormat = 'NUnitXml'
    $PSBPreference.General.SrcRootDir = 'PSSystemDiagnostics'
    $PSBPreference.Build.ModuleOutDir = './Output'
}

task Default -depends Test

task Clean -FromModule PowerShellBuild -minimumVersion '0.6.1'
task Build -FromModule PowerShellBuild -minimumVersion '0.6.1'
task Test -FromModule PowerShellBuild -minimumVersion '0.6.1'
task Pester -FromModule PowerShellBuild -minimumVersion '0.6.1'
task Analyze -FromModule PowerShellBuild -minimumVersion '0.6.1'
task Publish -FromModule PowerShellBuild -minimumVersion '0.6.1'
