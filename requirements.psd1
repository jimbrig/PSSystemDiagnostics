@{
  PSDependOptions    = @{
      Target = 'CurrentUser'
  }
  'Pester'           = @{
      Version    = 'latest'
      Parameters = @{
          SkipPublisherCheck = $true
      }
  }
  'psake'            = @{
      Version = 'latest'
  }
  'BuildHelpers'     = @{
      Version = 'latest'
  }
  'PowerShellBuild'  = @{
      Version = 'latest'
  }
  'PSScriptAnalyzer' = @{
      Version = 'latest'
  }
  'PlatyPS'          = @{
      Version = 'latest'
  }
}
