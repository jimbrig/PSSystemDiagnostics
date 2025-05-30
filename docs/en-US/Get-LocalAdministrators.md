---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version: https://learn.microsoft.com/powershell/module/microsoft.powershell.management/get-computerinfo?view=powershell-7.5&WT.mc_id=ps-gethelp
schema: 2.0.0
---

# Get-LocalAdministrators

## SYNOPSIS
Retrieves members of the local Administrators group.

## SYNTAX

```
Get-LocalAdministrators [-IncludePowerUsers] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function queries the local Administrators group to retrieve all members,
including both local and domain accounts with administrative privileges.

## EXAMPLES

### EXAMPLE 1
```
Get-LocalAdministrators
Retrieves all members of the local Administrators group.
```

### EXAMPLE 2
```
Get-LocalAdministrators -IncludePowerUsers
Retrieves members of both Administrators and Power Users groups.
```

## PARAMETERS

### -IncludePowerUsers
If specified, also retrieves members of the Power Users group.

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
### Returns a list of custom objects representing local administrator accounts.
## NOTES
This function requires appropriate permissions to query local group membership.
Falls back to net.exe commands if PowerShell cmdlets are not available.

## RELATED LINKS
