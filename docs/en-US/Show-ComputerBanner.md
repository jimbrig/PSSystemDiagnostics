---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version:
schema: 2.0.0
---

# Show-ComputerBanner

## SYNOPSIS
Displays a banner with system information.

## SYNTAX

```
Show-ComputerBanner [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function displays a banner with system information that is similar to neofetch on Linux.

## EXAMPLES

### EXAMPLE 1
```
Show-ComputerBanner
```

,.=:^!^!t3Z3z.,
:tt:::tt333EE3
Et:::ztt33EEE  @Ee.,      ..,     2023-11-15 3:32:33 PM
;tt:::tt333EE7 ;EEEEEEttttt33#
:Et:::zt333EEQ.
SEEEEEttttt33QL     User: jimmy
it::::tt333EEF @EEEEEEttttt33F      Hostname: DESKTOP-CUSTOM
;3=*^\`\`\`'*4EEV :EEEEEEttttt33@. 
OS: Microsoft Windows 11 Pro Insider Preview
,.=::::it=., \` @EEEEEEtttz33QF       Kernel: NT 10.0.25992
;::::::::zt33)   '4EEEtttji3P*        Uptime: 1 days, 17 hours, 44 minutes
:t::::::::tt33.:Z3z.. 
\`\` ,..g. 
Shell: Powershell 7.4.0-rc.1
i::::::::zt33F AEEEtttt::::ztF         CPU: Intel Core i7-10750H @ 2.60GHz
;:::::::::t33V ;EEEttttt::::t3          Processes: 524
E::::::::zt33L @EEEtttt::::z3F          Current Load: 8%
{3=*^\`\`\`'*4E3) ;EEEtttt:::::tZ\`          Memory: 24968mb/32577mb Used
     \` :EEEEtttt::::z7            Disk: 711gb/900gb Used
         'VEzjt:;;z\>*\`
              \`\`

## PARAMETERS

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
The function uses WMI to query the system information.

## RELATED LINKS

[Get-CimInstance]()

