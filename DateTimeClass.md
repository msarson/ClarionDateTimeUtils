# DateTimeClass Documentation

DateTimeClass is a minimal class that stores a DATE and TIME, with helpers to set/get, compare, and get date information (day of week, day of year).

## Methods
- `DayOfWeek()`: Returns the day of week (1=Sunday, 2=Monday, ..., 7=Saturday)
- `DayOfYear()`: Returns the day of year (1-366)
- `ToString(format)`: Formats the date/time using a custom format string

## ToString Method

The `DateTimeClass.ToString` method formats a date and time as a string using a custom format pattern.

```clarion
FUNCTION DateTimeClass.ToString(STRING format) : STRING
```

If no format is provided (empty string), a default format is used: `MM/DD/YYYY HH:MM:SS` (standard date/time format).

### Format Tokens

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

### Special Format Features

The `ToString` method supports several special formatting features:

1. **Literal Text Blocks**: Text enclosed in braces `{...}` is treated as literal text.
   - To include a literal brace character, double it: `{{` for `{` and `}}` for `}`.
   - Braces can be nested within literal blocks.

2. **Quoted Text**: Text enclosed in single quotes `'...'` or double quotes `"..."` is treated as literal text.
   - To include a literal quote character within quotes, double it: `''` for `'` and `""` for `"`.

3. **Run-Length Grouping**: Consecutive identical format tokens are treated as a group.
   - For example, `MM` means "month with zero-padding" while `M` means "month without padding".

### Examples

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
dt.ToString('dddd "the" d "of" MMMM, yyyy')
! Result: "Sunday the 15 of January, 2023"
```

### Using Braces for Complex Formatting

Braces can be used to include complex text or to escape characters that might otherwise be interpreted as format tokens:

```clarion
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
dt.ToString('{{Date}} yyyy-MM-dd')
! Result: "{Date} 2023-01-15"
```

## Notes
- TIME is in 1/100 seconds since midnight (Clarion TIME).