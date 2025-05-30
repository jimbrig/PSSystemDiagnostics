---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version:
schema: 2.0.0
---

# Get-SourceCode

## SYNOPSIS
Get the source code of a cmdlet.

## SYNTAX

```
Get-SourceCode [-Name] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function takes the name of a provided function or cmdlet and attempts to return the source code.
See the NOTES section for more information.

## EXAMPLES

### EXAMPLE 1
```
Get-SourceCode Get-ChildItem
```

This will return the source code for the \`Get-ChildItem\` cmdlet.

### EXAMPLE 2
```
Get-SourceCode Get-ChildItem | Out-File -FilePath C:\Temp\Get-ChildItem.ps1
```

This will return the source code for the \`Get-ChildItem\` cmdlet and save it to \`C:\Temp\Get-ChildItem.ps1\`.

## PARAMETERS

### -Name
(Required | String) The name of the cmdlet or function to retrieve the source code for.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### System.String
## OUTPUTS

### System.String
## NOTES
This function utilizes the \`CommandMetadata\` and \`ProxyCommand\` classes of the \`System.Management.Automation\`
namespace to return the source code of a cmdlet.

This is not guaranteed to work for all cmdlets, as some cmdlets are written in C# (or packed into binary .DLL's
and do not have an easily accessible "source code" representation.

## RELATED LINKS

[Originally implemented based off details found here:
https://stackoverflow.com/questions/266250/can-we-see-the-source-code-for-powershell-cmdlets/20484505#20484505]()

