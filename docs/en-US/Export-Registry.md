---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version:
schema: 2.0.0
---

# Export-Registry

## SYNOPSIS
Exports a registry key item properties to a .reg file.

## SYNTAX

### PrintOnly (Default)
```
Export-Registry [-RegistryKeyPath] <String[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Export
```
Export-Registry [-RegistryKeyPath] <String[]> [-ExportFormat <String>] -ExportPath <String> [-NoBinaryData]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function exports a registry key item properties to a .reg file.
The export format can also be altered via
the -ExportFormat parameter.

By default, results are written to the native pipeline unless the -ExportPath parameter is used.

## EXAMPLES

### EXAMPLE 1
```
Export-Registry -RegistryKeyPath 'HKLM:\SOFTWARE\Microsoft' -ExportPath 'C:\Temp\Microsoft.reg'
```

# Exports the registry key 'HKLM:\SOFTWARE\Microsoft' to 'C:\Temp\Microsoft.reg' in .reg format.

## PARAMETERS

### -RegistryKeyPath
A string representing the registry key path to export.
Uses PSDrive fotmatting (e.g.
HKLM:\SOFTWARE\Microsoft).

```yaml
Type: String[]
Parameter Sets: PrintOnly
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

```yaml
Type: String[]
Parameter Sets: Export
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ExportFormat
(Optional) A string representing the format to export the registry key to.

Valid values are:
    - 'reg' (default)
    - 'csv'
    - 'xml'

Parameter is used in conjunction with the -ExportPath parameter.

```yaml
Type: String
Parameter Sets: Export
Aliases:

Required: False
Position: Named
Default value: Reg
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExportPath
(Optional) A string representing the path to export the registry key to.
If the path does not exist, it will be created.

```yaml
Type: String
Parameter Sets: Export
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoBinaryData
A switch parameter that will exclude binary data from the export.

```yaml
Type: SwitchParameter
Parameter Sets: Export
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

## OUTPUTS

## NOTES

## RELATED LINKS
