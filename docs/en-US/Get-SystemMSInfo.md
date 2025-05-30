---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version:
schema: 2.0.0
---

# Get-SystemMSInfo

## SYNOPSIS
Exports system information using MSInfo32.

## SYNTAX

```
Get-SystemMSInfo [[-OutputPath] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function generates a comprehensive system information report using the MSInfo32 utility.
The report includes hardware, software, and system configuration details.

## EXAMPLES

### EXAMPLE 1
```
Get-SystemMSInfo -OutputPath "C:\Reports"
Generates MSInfo report and saves it to C:\Reports\msinfo.txt
```

### EXAMPLE 2
```
Get-SystemMSInfo
Generates MSInfo report using default path.
```

## PARAMETERS

### -OutputPath
Specifies the path where the MSInfo report should be saved.
Default is the current user's desktop under SystemExport folder.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: "$env:USERPROFILE\Desktop\SystemExport"
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

### System.IO.FileInfo
### Returns the file information object for the generated MSInfo report.
## NOTES
This function requires MSInfo32.exe to be available on the system.
The function may take several minutes to complete depending on system complexity.

## RELATED LINKS
