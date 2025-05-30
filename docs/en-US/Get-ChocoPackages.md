---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version: https://github.com/lazywinadmin/PowerShell
schema: 2.0.0
---

# Get-ChocoPackages

## SYNOPSIS
Retrieves a list of installed packages from Chocolatey package manager.

## SYNTAX

```
Get-ChocoPackages [[-Name] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function queries Chocolatey to retrieve information about locally installed packages.
It can filter results based on package name.

## EXAMPLES

### EXAMPLE 1
```
Get-ChocolateyPackages -Name "git*"
Retrieves all Chocolatey packages with names starting with "git".
```

### EXAMPLE 2
```
Get-ChocolateyPackages
Retrieves all installed Chocolatey packages.
```

## PARAMETERS

### -Name
Specifies a wildcard pattern to filter the package names.
Default is "*", which matches all packages.

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
### Returns a list of custom objects representing Chocolatey packages, with properties such as:
### Name, Version, PackageManager, InstallPath, and PSTypeName.
## NOTES
This function requires Chocolatey to be installed and available in the system PATH.
The function uses 'choco list --local-only' to retrieve package information.

## RELATED LINKS
