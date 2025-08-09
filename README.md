# TimeSpanClassTest

A small Clarion project demonstrating a DateTime container and a TimeSpan calculator.

## Contents
- DateTimeClass: A minimal class that stores a DATE and TIME, with helpers to set/get, compare, and get date information (day of week, day of year).
- TimeSpanClass: Computes the span between two DateTime values in seconds, minutes, hours, days, weeks, months, and years.

## Key files
- DateTimeClass.inc / DateTimeClass.clw
- TimeSpanClass.inc / TimeSpanClass.clw
- TimeSpanClassTest.* (demo / tests)

## Usage

### Basic Usage
- Create a TimeSpanClass instance. The class automatically allocates internal DateTime instances in Construct and disposes them in Destruct.
- Call Init(startDate, startTime, endDate, endTime, includeEnd, signed) to set values.
- Call GetSpan(UNIT:<Unit>) or the specific helpers (Seconds/Minutes/Hours/Days/Weeks/Months/Years).

### Static Methods
TimeSpanClass provides static methods to create instances with specific durations:
```clarion
tsRef &= ts.FromSeconds(3600)  ! Create a 1-hour timespan
tsRef &= ts.FromMinutes(60)    ! Create a 1-hour timespan
tsRef &= ts.FromHours(24)      ! Create a 1-day timespan
tsRef &= ts.FromDays(7)        ! Create a 1-week timespan
```

### Decimal Precision
For more precise calculations, use the decimal precision methods:
```clarion
realValue = ts.SecondsDecimal()  ! Returns REAL value
realValue = ts.MinutesDecimal()
realValue = ts.HoursDecimal()
realValue = ts.DaysDecimal()
realValue = ts.WeeksDecimal()
```

### String Formatting
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

Format tokens for TimeSpanClass.ToString:
- `d`: Days (no padding)
- `dd`: Days (zero-padded)
- `H`: Total hours across the entire span
- `HH`: Total hours (zero-padded)
- `h`: Hours component (0-23)
- `hh`: Hours component (zero-padded)
- `m`: Minutes (0-59)
- `mm`: Minutes (zero-padded)
- `s`: Seconds (0-59)
- `ss`: Seconds (zero-padded)
- `f`: Fractional seconds (tenths)
- `ff`: Fractional seconds (hundredths)

For detailed documentation on ToString formatting, see [ToString Documentation](ToString_Documentation.md).

## DateTimeClass Methods
- `DayOfWeek()`: Returns the day of week (1=Sunday, 2=Monday, ..., 7=Saturday)
- `DayOfYear()`: Returns the day of year (1-366)
- `ToString(format)`: Formats the date/time using a custom format string

Format tokens for DateTimeClass.ToString:
- `y` or `yyyy`: 4-digit year
- `yy`: 2-digit year
- `M`: Month number (1-12)
- `MM`: Month number (zero-padded)
- `MMM`: Short month name (e.g., "Jan")
- `MMMM`: Full month name (e.g., "January")
- `d`: Day of month (1-31)
- `dd`: Day of month (zero-padded)
- `ddd`: Short day name (e.g., "Sun")
- `dddd`: Full day name (e.g., "Sunday")
- `H`: Hour in 24-hour format (0-23)
- `HH`: Hour in 24-hour format (zero-padded)
- `h`: Hour in 12-hour format (1-12)
- `hh`: Hour in 12-hour format (zero-padded)
- `m`: Minute (0-59)
- `mm`: Minute (zero-padded)
- `s`: Second (0-59)
- `ss`: Second (zero-padded)
- `t`: AM/PM designator (first character)
- `tt`: AM/PM designator (full)

For detailed documentation on ToString formatting, see [ToString Documentation](ToString_Documentation.md).

## Notes
- TIME is in 1/100 seconds since midnight (Clarion TIME).
- includeEnd: when TRUE, adds 1 unit to the result (consistently applied across all time units).
- signed: when TRUE, negative values returned when start is after end; otherwise absolute values are returned.

## Build
- Open the solution `TimeSpanClassTest.sln` in Clarion/IDE and build.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
