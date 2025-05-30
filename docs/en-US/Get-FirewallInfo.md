---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version: https://learn.microsoft.com/powershell/module/microsoft.powershell.management/get-computerinfo?view=powershell-7.5&WT.mc_id=ps-gethelp
schema: 2.0.0
---

# Get-FirewallInfo

## SYNOPSIS
Retrieves Windows Firewall configuration and rules.

## SYNTAX

```
Get-FirewallInfo [-IncludeRules] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function collects Windows Firewall profile settings and firewall rules,
providing comprehensive firewall configuration information.

## EXAMPLES

### EXAMPLE 1
```
Get-FirewallInfo
Retrieves firewall profile information only.
```

### EXAMPLE 2
```
Get-FirewallInfo -IncludeRules
Retrieves firewall profiles and all firewall rules.
```

## PARAMETERS

### -IncludeRules
If specified, includes detailed firewall rules in addition to profile information.

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

### System.Collections.Hashtable
### Returns a hashtable containing firewall profiles and optionally rules information.
## NOTES
This function requires administrator privileges to access firewall configuration.
The NetSecurity PowerShell module must be available on the system.

## RELATED LINKS
