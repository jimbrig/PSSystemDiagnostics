---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version:
schema: 2.0.0
---

# Get-SystemComponents

## SYNOPSIS
Retrieves a list of installed system components and frameworks.

## SYNTAX

```
Get-SystemComponents [[-Name] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function queries the Windows registry to retrieve information about system components,
including .NET frameworks, Visual C++ redistributables, and Windows SDK components.

## EXAMPLES

### EXAMPLE 1
```
Get-SystemComponents -Name "*Framework*"
Retrieves all system components with names containing "Framework".
```

### EXAMPLE 2
```
Get-SystemComponents -Name "*Visual C++*"
Retrieves all Visual C++ redistributable components.
```

## PARAMETERS

### -Name
Specifies a wildcard pattern to filter the component names.
Default is "*", which matches all components.

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
### Returns a list of custom objects representing system components, with properties such as:
### DisplayName, DisplayVersion, Publisher, InstallDate, EstimatedSizeMB, Architecture,
### ComponentType, Source, and PSTypeName.
## NOTES
This function is designed to work on Windows systems and requires appropriate permissions to read the registry.
It focuses on system-level components that are typically hidden from standard software lists.

## RELATED LINKS
