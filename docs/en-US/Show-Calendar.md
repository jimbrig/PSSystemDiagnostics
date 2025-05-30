---
external help file: PSSystemDiagnostics-help.xml
Module Name: PSSystemDiagnostics
online version: https://github.com/My-Random-Thoughts
schema: 2.0.0
---

# Show-Calendar

## SYNOPSIS
Display a small monthly calendar.

## SYNTAX

### dateTime (Default)
```
Show-Calendar [-Date <DateTime>] [-Rotate] [-HighlightDay <Int32[]>] [-HighlightDate <DateTime[]>]
 [-Position <Coordinates>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### monthYear
```
Show-Calendar -Month <Int32> [-Year <Int32>] [-Rotate] [-HighlightDay <Int32[]>] [-HighlightDate <DateTime[]>]
 [-Position <Coordinates>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Displays the specified month in calendar view with the current date highlighed. 
An optional date can also be highlighed. 
The view can also be positioned in the console window.

## EXAMPLES

### EXAMPLE 1
```
Show-Calendar
Shows the current month and year.
```

### EXAMPLE 2
```
Show-Calendar -Date (Get-Date -Date '01-2000') -HighlightDate '2000-01-20'
Shows the first month of 2000 and highlights the specific date of the 20th.
```

### EXAMPLE 3
```
Show-Calendar -Month 01 -Year 2000 -HighlightDay (11..14)
Shows the first month of 2000 and highlights the days 11th, 12th, 13th and 14th.
```

### EXAMPLE 4
```
Show-Calendar -Position ([System.Management.Automation.Host.Coordinates]::New(20, 10))
Shows the current month and year at cursor position 20 across, 10 down.
```

## PARAMETERS

### -Date
The month and year to display in DateTime format. 
If not specified the current month and year is used.

```yaml
Type: DateTime
Parameter Sets: dateTime
Aliases:

Required: False
Position: Named
Default value: (Get-Date -Day 1).Date
Accept pipeline input: False
Accept wildcard characters: False
```

### -Month
The month to display, 1 - 12.

```yaml
Type: Int32
Parameter Sets: monthYear
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Year
The year to display. 
Defaults to current year.

```yaml
Type: Int32
Parameter Sets: monthYear
Aliases:

Required: False
Position: Named
Default value: ((Get-Date).Year)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Rotate
Rotate the calendar display, similar to ncal in Linux

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

### -HighlightDay
Specifies one or more days to highlight

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HighlightDate
Specifies a particular date to highlight.

```yaml
Type: DateTime[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Position
Specified the host coordinates to display the calendar. 
Does not work with ISE or VSCode.

```yaml
Type: Coordinates
Parameter Sets: (All)
Aliases:

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

## OUTPUTS

## NOTES
For additional information please see my GitHub wiki page
Based originally on https://github.com/jdhitsolutions/PSCalendar
Which was based on https://www.leeholmes.com/blog/2008/12/03/showing-calendars-in-your-oof-messages/

## RELATED LINKS

[https://github.com/My-Random-Thoughts](https://github.com/My-Random-Thoughts)

