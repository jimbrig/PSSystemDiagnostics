---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version:
schema: 2.0.0
---

# Get-WinGetPackages

## SYNOPSIS
Retrieves a list of installed packages from WinGet package manager.

## SYNTAX

```
Get-WinGetPackages [[-Name] <String>] [-IncludeAvailableUpdates] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function queries WinGet to retrieve information about installed packages.
It can filter results based on package name and optionally check for available updates.

## EXAMPLES

### EXAMPLE 1
```
Get-WinGetPackages -Name "Microsoft*"
Retrieves all WinGet packages with names starting with "Microsoft".
```

### EXAMPLE 2
```
Get-WinGetPackages -IncludeAvailableUpdates
Retrieves all WinGet packages and checks for available updates.
```

## PARAMETERS

### -Name
Specifies a wildcard pattern to filter the package names.
Default is "*", which matches all packages.

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

### -IncludeAvailableUpdates
If specified, checks for available updates for each package.

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
### Returns a list of custom objects representing WinGet packages, with properties such as:
### Name, Id, Version, Source, UpdateAvailable, PackageManager, and PSTypeName.
## NOTES
This function requires WinGet to be installed and available in the system PATH.
WinGet must be properly configured and have access to package sources.

## RELATED LINKS
