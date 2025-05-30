---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version: https://learn.microsoft.com/powershell/module/microsoft.powershell.management/get-computerinfo?view=powershell-7.5&WT.mc_id=ps-gethelp
schema: 2.0.0
---

# Get-SoftwareReport

## SYNOPSIS
Generates a comprehensive unified software inventory report.

## SYNTAX

```
Get-SoftwareReport [-IncludeSystemComponents] [-IncludeStoreApps] [-IncludePackageManagers]
 [[-OutputPath] <String>] [[-ExportFormat] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function collects software information from multiple sources including registry,
package managers (WinGet, Chocolatey, Scoop), Microsoft Store, and system components
to create a unified software inventory report.

## EXAMPLES

### EXAMPLE 1
```
Get-SoftwareReport -IncludeStoreApps -IncludePackageManagers
Generates a comprehensive report including Store apps and package manager data.
```

### EXAMPLE 2
```
Get-SoftwareReport -IncludeSystemComponents -OutputPath "C:\Reports\Inventory" -ExportFormat JSON
Generates a report with system components and exports it as JSON.
```

## PARAMETERS

### -IncludeSystemComponents
If specified, includes system components in the report.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeStoreApps
If specified, includes Microsoft Store applications in the report.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludePackageManagers
If specified, includes packages from WinGet, Chocolatey, and Scoop.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
Specifies the path where the report should be saved (without extension).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExportFormat
Specifies the export format for the report.
Valid values are JSON, CSV, and HTML.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: JSON
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. This function does not accept pipeline input.
## OUTPUTS

### System.Collections.Hashtable
### Returns a hashtable containing the complete software inventory report with summary statistics.
## NOTES
This function aggregates data from multiple sources and may take some time to complete.
Ensure all required package managers are installed for complete coverage.

## RELATED LINKS
