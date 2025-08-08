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
Format a timespan as a human-readable string:
```clarion
str = ts.FormatTimeSpan(2)  ! Format with 2 levels of detail (e.g., "1 day, 2 hours")
```

## DateTimeClass Methods
- `DayOfWeek()`: Returns the day of week (1=Sunday, 2=Monday, ..., 7=Saturday)
- `DayOfYear()`: Returns the day of year (1-366)

## Notes
- TIME is in 1/100 seconds since midnight (Clarion TIME).
- includeEnd: when TRUE, adds 1 unit to the result (consistently applied across all time units).
- signed: when TRUE, negative values returned when start is after end; otherwise absolute values are returned.

## Build
- Open the solution `TimeSpanClassTest.sln` in Clarion/IDE and build.

## License
- MIT (or your preferred license).
