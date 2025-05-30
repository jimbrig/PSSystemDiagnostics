---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version: https://learn.microsoft.com/powershell/module/microsoft.powershell.management/get-computerinfo?view=powershell-7.5&WT.mc_id=ps-gethelp
schema: 2.0.0
---

# Get-MissingDrivers

## SYNOPSIS
Identifies devices with missing or problematic drivers.

## SYNTAX

```
Get-MissingDrivers [-IncludeVGABasic] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function scans the system for devices that have driver issues,
including missing drivers, corrupted drivers, or configuration problems.

## EXAMPLES

### EXAMPLE 1
```
Get-MissingDrivers
Identifies all devices with driver problems.
```

### EXAMPLE 2
```
Get-MissingDrivers -IncludeVGABasic
Identifies driver problems including basic VGA devices.
```

## PARAMETERS

### -IncludeVGABasic
If specified, includes basic VGA devices in the results.

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
### Returns a list of custom objects representing devices with driver problems.
## NOTES
This function uses WMI to query device information and may require administrator privileges.
Error codes are translated to human-readable descriptions.

## RELATED LINKS
