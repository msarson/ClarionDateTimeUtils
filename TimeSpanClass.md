# TimeSpanClass Documentation

TimeSpanClass computes the span between two DateTime values in seconds, minutes, hours, days, weeks, months, and years.

## Basic Usage
- Create a TimeSpanClass instance. The class automatically allocates internal DateTime instances in Construct and disposes them in Destruct.
- Call Init(startDate, startTime, endDate, endTime, includeEnd, signed) to set values.
- Call GetSpan(UNIT:<Unit>) or the specific helpers (Seconds/Minutes/Hours/Days/Weeks/Months/Years).

## Static Methods
TimeSpanClass provides static methods to create instances with specific durations:
```clarion
tsRef &= ts.FromSeconds(3600)  ! Create a 1-hour timespan
tsRef &= ts.FromMinutes(60)    ! Create a 1-hour timespan
tsRef &= ts.FromHours(24)      ! Create a 1-day timespan
tsRef &= ts.FromDays(7)        ! Create a 1-week timespan
```

## Decimal Precision
For more precise calculations, use the decimal precision methods:
```clarion
realValue = ts.SecondsDecimal()  ! Returns REAL value
realValue = ts.MinutesDecimal()
realValue = ts.HoursDecimal()
realValue = ts.DaysDecimal()
realValue = ts.WeeksDecimal()
```

## String Formatting
TimeSpanClass provides two methods for formatting time spans as strings:

1. **FormatTimeSpan**: Creates a human-readable string with specified detail level
```clarion
str = ts.FormatTimeSpan(2)  ! Format with 2 levels of detail (e.g., "1 day, 2 hours")
```

2. **ToString**: Formats the time span using a custom format string
```clarion
str = ts.ToString('d.hh:mm:ss')  ! Format as days.hours:minutes:seconds
str = ts.ToString('hh "hours" mm "minutes"')  ! Format with text
```

## ToString Method

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

### Format Tokens

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

### Special Format Features

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

### Examples

```clarion
! Assuming a timespan of 1 day, 2 hours, 30 minutes, 45 seconds

ts.ToString('d.hh:mm:ss')           ! Result: "1.02:30:45"
ts.ToString('d "days" h "hours"')    ! Result: "1 days 2 hours"
ts.ToString('H "total hours"')       ! Result: "26 total hours"
ts.ToString('d.hh:mm:ss.ff')         ! Result: "1.02:30:45.00"
ts.ToString('{Total:} d.hh:mm:ss')   ! Result: "Total: 1.02:30:45"
```

## Advanced Usage

### Combining Format Tokens with Literal Text

You can combine format tokens with literal text to create more readable output:

```clarion
ts.ToString('d "days," h "hours," m "minutes"')
! Result: "1 days, 2 hours, 30 minutes"
```

### Using Braces for Complex Formatting

Braces can be used to include complex text or to escape characters that might otherwise be interpreted as format tokens:

```clarion
ts.ToString('{Elapsed time: }d.hh:mm:ss')
! Result: "Elapsed time: 1.02:30:45"
```

### Handling Special Characters

To include special characters like quotes or braces in your output:

```clarion
! Double braces for literal braces
ts.ToString('{{Elapsed}} d.hh:mm:ss')
! Result: "{Elapsed} 1.02:30:45"
```

## Notes
- TIME is in 1/100 seconds since midnight (Clarion TIME).
- includeEnd: when TRUE, adds 1 unit to the result (consistently applied across all time units).
- signed: when TRUE, negative values returned when start is after end; otherwise absolute values are returned.