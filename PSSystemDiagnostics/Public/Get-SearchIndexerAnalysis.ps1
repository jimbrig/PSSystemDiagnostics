function Get-SearchIndexerAnalysis {
    [CmdletBinding()]
    param (
        [string]$OutputPath = ".\SearchIndexerAnalysis.json"
    )

    Write-Host "Analyzing Search Indexer status..." -ForegroundColor Cyan

    # Check if Search Indexer process is running
    $indexerProcess = Get-Process -Name "SearchIndexer" -ErrorAction SilentlyContinue

    # Get Search service status
    $searchService = Get-Service -Name "WSearch" -ErrorAction SilentlyContinue

    # Create optimization suggestions
    $optimizationSuggestions = @()

    if ($indexerProcess -and $indexerProcess.CPU -gt 100) {
        $optimizationSuggestions += "Search Indexer is currently using high CPU ($([math]::Round($indexerProcess.CPU, 2))%). Consider:"
        $optimizationSuggestions += "  - Temporarily pausing indexing: `$sm = New-Object -ComObject Microsoft.Search.Administration; `$sm.GetCatalog('SystemIndex').Pause()"
        $optimizationSuggestions += "  - Limiting indexed locations through Control Panel > Indexing Options"
        $optimizationSuggestions += "  - Rebuilding the index if it's corrupted: Control Panel > Indexing Options > Advanced > Rebuild"
    }

    # Try to get indexing status using alternative method
    $indexingStatus = $null
    try {
        $indexingStatus = @{
            ServiceStatus    = $searchService.Status
            ServiceStartType = $searchService.StartType
            IndexedLocations = "Use Control Panel > Indexing Options to view indexed locations"
        }
    } catch {
        Write-Warning "Could not retrieve Search Indexer status: $($_.Exception.Message)"
    }

    $report = [PSCustomObject]@{
        IndexerRunning          = ($null -ne $indexerProcess)
        Process                 = if ($indexerProcess) {
            $indexerProcess | Select-Object Id, ProcessName, CPU,
            @{Name = 'Memory(MB)'; Expression = { [math]::Round(($_.WorkingSet / 1MB), 2) } },
            StartTime
        } else { $null }
        Service                 = if ($searchService) {
            $searchService | Select-Object Name, DisplayName, Status, StartType
        } else { $null }
        IndexingStatus          = $indexingStatus
        OptimizationSuggestions = $optimizationSuggestions
        Timestamp               = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }

    # Convert the report to JSON format
    $jsonReport = $report | ConvertTo-Json -Depth 5

    # Output the JSON report to a file
    $jsonReport | Out-File -FilePath $OutputPath

    Write-Host "Search Indexer analysis saved to $OutputPath" -ForegroundColor Green

    return $report
}
