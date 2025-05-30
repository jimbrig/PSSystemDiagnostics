---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version: https://learn.microsoft.com/powershell/module/microsoft.powershell.management/get-computerinfo?view=powershell-7.5&WT.mc_id=ps-gethelp
schema: 2.0.0
---

# Get-InstalledSoftware

## SYNOPSIS
Retrieves a list of installed software from the Windows registry.

## SYNTAX

```
Get-InstalledSoftware [[-DisplayName] <String>] [-IncludeSystemComponents] [-IncludeUpdates]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function queries the Windows registry to retrieve information about installed software.
It can filter results based on display name, include system components, and include updates.

## EXAMPLES

### EXAMPLE 1
```
Get-InstalledSoftware -DisplayName "Microsoft*" -IncludeSystemComponents
Retrieves all installed software with display names starting with "Microsoft", including system components.
```

### EXAMPLE 2
```
Get-InstalledSoftware -DisplayName "Visual Studio*" -IncludeUpdates
Retrieves all installed software with display names starting with "Visual Studio", including updates.
```

## PARAMETERS

### -DisplayName
Specifies a wildcard pattern to filter the display names of installed software.
Default is "*", which matches all software.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -IncludeSystemComponents
If specified, includes system components in the results.

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

### -IncludeUpdates
If specified, includes updates in the results.

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

### System.Collections.Generic.List[PSCustomObject]
### Returns a list of custom objects representing installed software, with properties such as:
### DisplayName, DisplayVersion, Publisher, InstallDate, InstallLocation, UninstallString, QuietUninstallString,
### EstimatedSizeMB, RegistryPath, Architecture, Source, and PSTypeName.
## NOTES
This function is designed to work on Windows systems and requires appropriate permissions to read the registry.
It may not return results for software installed by non-standard methods or in non-standard locations.

## RELATED LINKS
