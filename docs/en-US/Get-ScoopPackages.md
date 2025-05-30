---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version: https://learn.microsoft.com/powershell/module/microsoft.powershell.management/get-computerinfo?view=powershell-7.5&WT.mc_id=ps-gethelp
schema: 2.0.0
---

# Get-ScoopPackages

## SYNOPSIS
Retrieves a list of installed packages from Scoop package manager.

## SYNTAX

```
Get-ScoopPackages [[-Name] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function queries Scoop to retrieve information about locally installed packages.
It can filter results based on package name and includes bucket and status information.

## EXAMPLES

### EXAMPLE 1
```
Get-ScoopPackages -Name "git*"
Retrieves all Scoop packages with names starting with "git".
```

### EXAMPLE 2
```
Get-ScoopPackages
Retrieves all installed Scoop packages.
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
### Returns a list of custom objects representing Scoop packages, with properties such as:
### Name, Version, Bucket, Status, PackageManager, InstallPath, and PSTypeName.
## NOTES
This function requires Scoop to be installed and available in the system PATH.
The function uses 'scoop list' to retrieve package information.

## RELATED LINKS
