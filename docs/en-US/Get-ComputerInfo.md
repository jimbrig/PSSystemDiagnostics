---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version: https://learn.microsoft.com/powershell/module/microsoft.powershell.management/get-computerinfo?view=powershell-7.5&WT.mc_id=ps-gethelp
schema: 2.0.0
---

# Get-ComputerInfo

## SYNOPSIS
This function query some basic Operating System and Hardware Information from a local or remote machine.

Gets a consolidated object of system and operating system properties.

## SYNTAX

```
Get-ComputerInfo [[-ComputerName] <String[]>] [[-ErrorLog] <String>] [[-Credential] <PSCredential>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function query some basic Operating System and Hardware Information from a local or remote machine.

The properties returned are:
  - Computer Name (ComputerName)
  - Operating System Name (OSName)
  - Operating System Version (OSVersion)
  - Memory Installed on the Computer in GigaBytes (MemoryGB)
  - Number of Processor(s) (NumberOfProcessors)
  - Number of Socket(s) (NumberOfSockets)
  - Number of Core(s) (NumberOfCores)

This function as been tested against Windows Server 2000, 2003, 2008 and 2012.

\> This cmdlet is only available on the Windows platform.
The \`Get-ComputerInfo\` cmdlet gets a consolidated object of system and operating system properties.
This cmdlet was introduced in Windows PowerShell 5.1.

## EXAMPLES

### EXAMPLE 1
```
Get-ComputerInfo
```

ComputerName       : DESKTOP-PERSONAL
OSName             : Microsoft Windows 11 Pro Insider Preview
OSVersion          : 10.0.25987
MemoryGB           : 32
NumberOfProcessors : 1
NumberOfSockets    : 1
NumberOfCores      : 6

This example return information about the localhost.
By Default, if you don't specify a ComputerName,
the function will run against the localhost.

### Example 1: Get all computer properties
```
Get-ComputerInfo
```

### Example 2: Get all computer version properties
```
Get-ComputerInfo -Property "*version"

WindowsCurrentVersion              : 6.3
WindowsVersion                     : 2009
BiosBIOSVersion                    : {LENOVO - 1380, N1FET64W (1.38 ), Lenovo - 1380}
BiosEmbeddedControllerMajorVersion : 1
BiosEmbeddedControllerMinorVersion : 17
BiosSMBIOSBIOSVersion              : N1FET64W (1.38 )
BiosSMBIOSMajorVersion             : 2
BiosSMBIOSMinorVersion             : 8
BiosSystemBiosMajorVersion         : 1
BiosSystemBiosMinorVersion         : 38
BiosVersion                        : LENOVO - 1380
OsVersion                          : 10.0.19043
OsCSDVersion                       :
OsServicePackMajorVersion          : 0
OsServicePackMinorVersion          : 0
```

## PARAMETERS

### -ComputerName
Specify a ComputerName or IP Address.
Default is Localhost.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: LocalHost
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ErrorLog
Specify the full path of the Error log file.
Default is .\Errors.log.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: .\Errors.log
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Specify the alternative credential to use

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases: RunAs

Required: False
Position: 3
Default value: [System.Management.Automation.PSCredential]::Empty
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

### System.String
### System.String[]
You can pipe a string containing the name of a property to this cmdlet.

## OUTPUTS

### System.Management.Automation.PSCustomObject
### Microsoft.PowerShell.Management.ComputerInfo
This cmdlet returns a ComputerInfo object.

## NOTES
PowerShell includes the following aliases for \`Get-ComputerInfo\`:

- Windows:   - \`gin\`

This cmdlet is only available on Windows platforms.

## RELATED LINKS
