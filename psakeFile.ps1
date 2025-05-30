properties {
    # Set this to $true to create a module with a monolithic PSM1
    $PSBPreference.Build.CompileModule = $false
    $PSBPreference.Help.DefaultLocale = 'en-US'
    $PSBPreference.Test.OutputFile = 'out/testResults.xml'
    $PSBPreference.Test.OutputFormat = 'NUnitXml'
    $PSBPreference.General.SrcRootDir = 'PSSystemDiagnostics'
    $PSBPreference.Build.ModuleOutDir = './Output'

    # Publish settings
    if ($galleryApiKey) {
      $PSBPreference.Publish.PSRepositoryApiKey = $galleryApiKey.GetNetworkCredential().password
    }
}

task Default -depends Test

task Clean -FromModule PowerShellBuild
task Build -FromModule PowerShellBuild
task Test -FromModule PowerShellBuild
task Pester -FromModule PowerShellBuild
task Analyze -FromModule PowerShellBuild
task Publish -FromModule PowerShellBuild

Task GenerateYAMLHelp -depends GenerateMarkdown {
	If (-not (Get-Command New-YamlHelp -CommandType Function -ErrorAction SilentlyContinue)) {
		Install-Module -name platyPS -Repository PSGallery -Scope CurrentUser -Force
	}
	New-YamlHelp -Path './Docs/en-US' -OutputFolder './Docs/en-US' -Force
}
