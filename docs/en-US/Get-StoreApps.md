---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version:
schema: 2.0.0
---

# Get-StoreApps

## SYNOPSIS
Retrieves a list of installed Microsoft Store applications.

## SYNTAX

```
Get-StoreApps [[-Name] <String>] [-IncludeFrameworks] [-AllUsers] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function queries the system to retrieve information about installed Microsoft Store apps.
It can filter results based on app name, include framework packages, and query all users.

## EXAMPLES

### EXAMPLE 1
```
Get-StoreApps -Name "Microsoft*"
Retrieves all Store apps with names starting with "Microsoft".
```

### EXAMPLE 2
```
Get-StoreApps -IncludeFrameworks -AllUsers
Retrieves all Store apps including frameworks for all users.
```

## PARAMETERS

### -Name
Specifies a wildcard pattern to filter the app names.
Default is "*", which matches all apps.

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

### -IncludeFrameworks
If specified, includes framework packages in the results.

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

### -AllUsers
If specified, retrieves apps for all users on the system.

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
### Returns a list of custom objects representing Store apps, with properties such as:
### Name, DisplayName, Version, Publisher, Architecture, InstallLocation, PackageFamilyName,
### IsFramework, EstimatedSizeMB, InstallDate, PackageManager, and PSTypeName.
## NOTES
This function requires appropriate permissions to query app packages.
Size calculation may take time for apps with large installation directories.

## RELATED LINKS
