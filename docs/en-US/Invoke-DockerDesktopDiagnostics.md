---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version:
schema: 2.0.0
---

# Invoke-DockerDesktopDiagnostics

## SYNOPSIS
Invokes the Docker Desktop Self-Diagnose Tool.

## SYNTAX

```
Invoke-DockerDesktopDiagnostics [[-Action] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Docker Desktop contains a self-diagnose tool which can help you identify some common problems.
This function invokes the self-diagnose tool performing the check and generating a report.

## EXAMPLES

### EXAMPLE 1
```
Invoke-DockerDesktopDiagnostics
```

### EXAMPLE 2
```
Invoke-DockerDesktopDiagnostics -Action check
```

## PARAMETERS

### -Action
The action to perform.
The default is 'check'.
The available actions are:
- check
- login
- gather
- upload
- check-hypervisor
- detect-host-hypervisor

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Gather
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

### The output of the Docker Desktop Self-Diagnose Tool.
## NOTES
See https://docs.docker.com/desktop/troubleshoot/overview/#self-diagnose-tool for more information.

## RELATED LINKS
