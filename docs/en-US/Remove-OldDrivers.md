---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version:
schema: 2.0.0
---

# Remove-OldDrivers

## SYNOPSIS
Remove old third-party drivers from the system.

## SYNTAX

```
Remove-OldDrivers [-Interactive] [[-MinimumVersionsToKeep] <Int32>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function identifies and removes old third-party drivers that are no longer needed.
It lists all installed third-party drivers, identifies duplicates based on the original file name,
and removes older versions while keeping the most recent one.

Delete old drivers using the \`Get-WindowsDriver\` CmdLet.

## EXAMPLES

### EXAMPLE 1
```
Remove-OldDrivers -WhatIf
Shows what would happen if the command were to run. The command is not run.
```

### EXAMPLE 2
```
Remove-OldDrivers -Interactive
Prompts for confirmation before removing each driver.
```

### EXAMPLE 3
```
Remove-OldDrivers -MinimumVersionsToKeep 2
Keeps the 2 most recent versions of each driver.
```

## PARAMETERS

### -Interactive
If specified, the function will prompt for confirmation before removing each driver.

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

### -MinimumVersionsToKeep
Specifies the minimum number of driver versions to keep.
Default is 1 (keep only the latest).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Show what would be removed without actually removing anything.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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

### System.Management.Automation.PSCustomObject. Returns a summary of the removal operation.
## NOTES

## RELATED LINKS
