---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version:
schema: 2.0.0
---

# Get-SystemServices

## SYNOPSIS
Retrieves information about all system services.

## SYNTAX

```
Get-SystemServices [[-Name] <String>] [-Status <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function queries all Windows services and returns their current status,
startup type, and other relevant service information.

## EXAMPLES

### EXAMPLE 1
```
Get-SystemServices
Retrieves information about all system services.
```

### EXAMPLE 2
```
Get-SystemServices -Name "Windows*" -Status Running
Retrieves running services with names starting with "Windows".
```

## PARAMETERS

### -Name
Specifies a wildcard pattern to filter service names.
Default is "*", which matches all services.

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

### -Status
Filters services by their current status (Running, Stopped, etc.).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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
### Returns a list of custom objects representing system services.
## NOTES
This function provides comprehensive service information including startup type and dependencies.
Some service details may require administrator privileges to access.

## RELATED LINKS
