# ToString Methods Documentation

This document provides detailed information about the `ToString` methods available in the TimeSpanClass and DateTimeClass libraries.

## Table of Contents
- [TimeSpanClass.ToString](#timespanclasstostring)
  - [Format Tokens](#timespan-format-tokens)
  - [Special Format Features](#timespan-special-format-features)
  - [Examples](#timespan-examples)
- [DateTimeClass.ToString](#datetimeclasstostring)
  - [Format Tokens](#datetime-format-tokens)
  - [Special Format Features](#datetime-special-format-features)
  - [Examples](#datetime-examples)

## TimeSpanClass.ToString

The `TimeSpanClass.ToString` method formats a time span as a string using a custom format pattern.

```clarion
FUNCTION TimeSpanClass.ToString(STRING format) : STRING
```

If no format is provided (empty string) or the format is "c", a default format is used: `[-]d.hh:mm:ss` where:
- `[-]` is the negative sign (if applicable and Signed=TRUE)
- `d` is the number of days
- `hh` is the hours component (00-23) with zero-padding
- `mm` is the minutes component (00-59) with zero-padding
- `ss` is the seconds component (00-59) with zero-padding

### Timespan Format Tokens

| Token | Description |
|-------|-------------|
| `d` | Days (no padding) |
| `dd` | Days (zero-padded to at least 2 digits) |
| `H` | Total hours across the entire span (no padding) |
| `HH` | Total hours (zero-padded to at least 2 digits) |
| `h` | Hours component (0-23, no padding) |
| `hh` | Hours component (zero-padded to at least 2 digits) |
| `m` | Minutes component (0-59, no padding) |
| `mm` | Minutes component (zero-padded to at least 2 digits) |
| `s` | Seconds component (0-59, no padding) |
| `ss` | Seconds component (zero-padded to at least 2 digits) |
| `f` | Fractional seconds (tenths, 0-9) |
| `ff` | Fractional seconds (hundredths, 00-99) |

### Timespan Special Format Features

The `ToString` method supports several special formatting features:

1. **Literal Text Blocks**: Text enclosed in braces `{...}` is treated as literal text.
   - To include a literal brace character, double it: `{{` for `{` and `}}` for `}`.
   - Braces can be nested within literal blocks.

2. **Quoted Text**: Text enclosed in single quotes `'...'` or double quotes `"..."` is treated as literal text.
   - To include a literal quote character within quotes, double it: `''` for `'` and `""` for `"`.

3. **Run-Length Grouping**: Consecutive identical format tokens are treated as a group.
   - For example, `dd` means "days with zero-padding" while `d` means "days without padding".

4. **Automatic Sign Handling**: The sign of the timespan is automatically applied based on the `Signed` property.
   - If `Signed` is TRUE and the timespan is negative, a minus sign is prepended to the result.

### Timespan Examples

```clarion
! Assuming a timespan of 1 day, 2 hours, 30 minutes, 45 seconds

ts.ToString('d.hh:mm:ss')           ! Result: "1.02:30:45"
ts.ToString('d "days" h "hours"')    ! Result: "1 days 2 hours"
ts.ToString('H "total hours"')       ! Result: "26 total hours"
ts.ToString('d.hh:mm:ss.ff')         ! Result: "1.02:30:45.00"
ts.ToString('{Total:} d.hh:mm:ss')   ! Result: "Total: 1.02:30:45"
```

## DateTimeClass.ToString

The `DateTimeClass.ToString` method formats a date and time as a string using a custom format pattern.

```clarion
FUNCTION DateTimeClass.ToString(STRING format) : STRING
```

If no format is provided (empty string), a default format is used: `MM/DD/YYYY HH:MM:SS` (standard date/time format).

### DateTime Format Tokens

| Token | Description |
|-------|-------------|
| `y` or `yyyy` | 4-digit year |
| `yy` | 2-digit year (00-99) |
| `M` | Month number (1-12, no padding) |
| `MM` | Month number (01-12, zero-padded) |
| `MMM` | Short month name (e.g., "Jan", "Feb") |
| `MMMM` | Full month name (e.g., "January", "February") |
| `d` | Day of month (1-31, no padding) |
| `dd` | Day of month (01-31, zero-padded) |
| `ddd` | Short day name (e.g., "Sun", "Mon") |
| `dddd` | Full day name (e.g., "Sunday", "Monday") |
| `H` | Hour in 24-hour format (0-23, no padding) |
| `HH` | Hour in 24-hour format (00-23, zero-padded) |
| `h` | Hour in 12-hour format (1-12, no padding) |
| `hh` | Hour in 12-hour format (01-12, zero-padded) |
| `m` | Minute (0-59, no padding) |
| `mm` | Minute (00-59, zero-padded) |
| `s` | Second (0-59, no padding) |
| `ss` | Second (00-59, zero-padded) |
| `t` | AM/PM designator (first character: "A" or "P") |
| `tt` | AM/PM designator (full: "AM" or "PM") |

### DateTime Special Format Features

The `ToString` method supports several special formatting features:

1. **Literal Text Blocks**: Text enclosed in braces `{...}` is treated as literal text.
   - To include a literal brace character, double it: `{{` for `{` and `}}` for `}`.
   - Braces can be nested within literal blocks.

2. **Quoted Text**: Text enclosed in single quotes `'...'` or double quotes `"..."` is treated as literal text.
   - To include a literal quote character within quotes, double it: `''` for `'` and `""` for `"`.

3. **Run-Length Grouping**: Consecutive identical format tokens are treated as a group.
   - For example, `MM` means "month with zero-padding" while `M` means "month without padding".

### DateTime Examples

```clarion
! Assuming a date/time of January 15, 2023, 14:30:45

dt.ToString('MM/dd/yyyy')                ! Result: "01/15/2023"
dt.ToString('MMMM d, yyyy')              ! Result: "January 15, 2023"
dt.ToString('ddd, MMM d, yyyy')          ! Result: "Sun, Jan 15, 2023"
dt.ToString('HH:mm:ss')                  ! Result: "14:30:45"
dt.ToString('h:mm tt')                   ! Result: "2:30 PM"
dt.ToString('dddd, MMMM d, yyyy h:mm tt') ! Result: "Sunday, January 15, 2023 2:30 PM"
dt.ToString('{Date:} yyyy-MM-dd')        ! Result: "Date: 2023-01-15"
```

## Advanced Usage

### Combining Format Tokens with Literal Text

You can combine format tokens with literal text to create more readable output:

```clarion
ts.ToString('d "days," h "hours," m "minutes"')
! Result: "1 days, 2 hours, 30 minutes"

dt.ToString('dddd "the" d "of" MMMM, yyyy')
! Result: "Sunday the 15 of January, 2023"
```

### Using Braces for Complex Formatting

Braces can be used to include complex text or to escape characters that might otherwise be interpreted as format tokens:

```clarion
ts.ToString('{Elapsed time: }d.hh:mm:ss')
! Result: "Elapsed time: 1.02:30:45"

dt.ToString('{Today is: }dddd, {the date is: }MM/dd/yyyy')
! Result: "Today is: Sunday, the date is: 01/15/2023"
```

### Handling Special Characters

To include special characters like quotes or braces in your output:

```clarion
! Double quotes within quoted text
dt.ToString('"Today is: "dddd"" (day of week)"')
! Result: "Today is: Sunday" (day of week)"

! Double braces for literal braces
ts.ToString('{{Elapsed}} d.hh:mm:ss')
! Result: "{Elapsed} 1.02:30:45"