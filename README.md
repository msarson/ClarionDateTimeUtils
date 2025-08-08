# TimeSpanClassTest

A small Clarion project demonstrating a DateTime container and a TimeSpan calculator.

Contents
- DateTimeClass: A minimal class that stores a DATE and TIME, with helpers to set/get and compare.
- TimeSpanClass: Computes the span between two DateTime values in seconds, minutes, hours, days, weeks, months, and years.

Key files
- DateTimeClass.inc / DateTimeClass.clw
- TimeSpanClass.inc / TimeSpanClass.clw
- TimeSpanClassTest.* (demo / tests)

Usage
- Create a TimeSpanClass instance. The class automatically allocates internal DateTime instances in Construct and disposes them in Destruct.
- Call Init(startDate, startTime, endDate, endTime, includeEnd, signed) to set values.
- Call GetSpan(UNIT:<Unit>) or the specific helpers (Seconds/Minutes/Hours/Days/Weeks/Months/Years).

Notes
- TIME is in 1/100 seconds since midnight (Clarion TIME).
- includeEnd: when TRUE, Seconds adds 1 second, Days adds 1 full day prior to truncation.
- signed: when TRUE, negative values returned when start is after end; otherwise absolute values are returned.

Build
- Open the solution `TimeSpanClassTest.sln` in Clarion/IDE and build.

License
- MIT (or your preferred license).
