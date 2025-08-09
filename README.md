# TimeSpanClassTest

A small Clarion project demonstrating a DateTime container and a TimeSpan calculator.

## Contents
- DateTimeClass: A minimal class that stores a DATE and TIME, with helpers to set/get, compare, and get date information (day of week, day of year).
- TimeSpanClass: Computes the span between two DateTime values in seconds, minutes, hours, days, weeks, months, and years.

## Key files
- DateTimeClass.inc / DateTimeClass.clw
- TimeSpanClass.inc / TimeSpanClass.clw
- TimeSpanClassTest.* (demo / tests)

## Documentation

### TimeSpanClass
TimeSpanClass computes the span between two DateTime values in various time units.

Key features:
- Calculate time spans in seconds, minutes, hours, days, weeks, months, and years
- Static methods to create instances with specific durations
- Decimal precision methods for more accurate calculations
- String formatting with FormatTimeSpan and ToString methods

For detailed documentation, see [TimeSpanClass Documentation](TimeSpanClass.md).

### DateTimeClass
DateTimeClass is a minimal class that stores a DATE and TIME with various helper methods.

Key features:
- Get day of week and day of year information
- Format date/time as string with customizable patterns
- Compare date/time values

For detailed documentation, see [DateTimeClass Documentation](DateTimeClass.md).

## Notes
- TIME is in 1/100 seconds since midnight (Clarion TIME).
- includeEnd: when TRUE, adds 1 unit to the result (consistently applied across all time units).
- signed: when TRUE, negative values returned when start is after end; otherwise absolute values are returned.

## Build
- Open the solution `TimeSpanClassTest.sln` in Clarion/IDE and build.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
