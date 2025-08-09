          MEMBER()
  INCLUDE('DateTimeClass.inc'),ONCE
          MAP
DAYS:InMonth    PROCEDURE(LONG month, LONG year), LONG, PRIVATE
MIN         PROCEDURE(LONG a, LONG b),LONG,PRIVATE
Replace     PROCEDURE(STRING FindWhat, STRING ReplaceWith, STRING Source),STRING,PRIVATE
          END

    !!! <summary>
    !!! Set initial date/time values for this instance.
    !!! </summary>
    !!! <param name="pDate">Clarion DATE</param>
    !!! <param name="pTime">Clarion TIME (1/100 sec since midnight)</param>
DateTimeClass.Init    PROCEDURE(LONG pDate, LONG pTime)
  CODE
  SELF.Date = pDate
  SELF.Time = pTime

!!! <summary>
!!! Initialize date/time values using individual components.
!!! </summary>
!!! <param name="pDay">Day of month (1-31)</param>
!!! <param name="pMonth">Month (1-12)</param>
!!! <param name="pYear">Year (4-digit)</param>
!!! <param name="pHour">Hour (0-23, default 0)</param>
!!! <param name="pMins">Minutes (0-59, default 0)</param>
!!! <param name="pSeconds">Seconds (0-59, default 0)</param>
!!! <param name="pHundredths">Hundredths of a second (0-99, default 0)</param>
DateTimeClass.Init    PROCEDURE(SHORT pDay, SHORT pMonth, SHORT pYear, SHORT pHour=0, SHORT pMins=0, SHORT pSeconds=0, SHORT pHundredths=0)
TotalTicks              LONG
  CODE
  SELF.Date = DATE(pMonth, pDay, pYear)

  TotalTicks = pHour       * TICKS:PerHour   + |
    pMins       * TICKS:PerMinute + |
    pSeconds    * TICKS:PerSecond + |
    pHundredths

  ! wrap into valid Clarion TIME range (0 .. TICKS:PerDay-1)
  TotalTicks = TotalTicks % TICKS:PerDay
  IF TotalTicks < 0
    TotalTicks += TICKS:PerDay
  END

  SELF.Time = TotalTicks

  
    !!! <summary>
    !!! Get the stored Clarion DATE value.
    !!! </summary>
DateTimeClass.GetDate PROCEDURE()
  CODE
  RETURN SELF.Date

    !!! <summary>
    !!! Get the stored Clarion TIME value (1/100 seconds since midnight).
    !!! </summary>
DateTimeClass.GetTime PROCEDURE()
  CODE
  RETURN SELF.Time

    !!! <summary>
    !!! Compare this instance to another DateTime.
    !!! Returns 1 if this > other, 0 if equal, -1 if this < other.
    !!! </summary>
DateTimeClass.Compare PROCEDURE(DateTimeClass other)
  CODE
  IF SELF.Date > other.Date OR (SELF.Date = other.Date AND SELF.Time > other.Time)
    RETURN 1
  ELSIF SELF.Date = other.Date AND SELF.Time = other.Time
    RETURN 0
  ELSE
    RETURN -1
  END

    !!! <summary>
    !!! TRUE if both Date and Time are zero.
    !!! </summary>
DateTimeClass.IsZero  PROCEDURE()
  CODE
  RETURN CHOOSE(SELF.Date = 0 AND SELF.Time = 0, TRUE, FALSE)

    !!! <summary>
    !!! Get the day of week for the stored date.
    !!! </summary>
    !!! <returns>1=Sunday, 2=Monday, ..., 7=Saturday</returns>
DateTimeClass.DayOfWeek   PROCEDURE()
  CODE
    ! Clarion dates start from Dec 28, 1800 (a Sunday)
    ! Using modulo 7 gives us day of week (0=Saturday, 1=Sunday, etc.)
    ! We adjust to make 1=Sunday, 2=Monday, ..., 7=Saturday
  RETURN (SELF.Date % 7) + 1

    !!! <summary>
    !!! Get the day of year for the stored date.
    !!! </summary>
    !!! <returns>1-366, representing the day of the year</returns>
DateTimeClass.DayOfYear   PROCEDURE()
CurrentYear                 LONG
FirstDayOfYear              LONG
  CODE
    ! Get the current year
  CurrentYear = YEAR(SELF.Date)

    ! Calculate the first day of the current year (January 1)
  FirstDayOfYear = DATE(CurrentYear, 1, 1)

    ! Calculate days since January 1st of the current year, plus 1
  RETURN SELF.Date - FirstDayOfYear + 1

    !!! <summary>
    !!! Helper function to determine the number of days in a month, accounting for leap years.
    !!! </summary>
    !!! <param name="month">Month (1-12)</param>
    !!! <param name="year">Year</param>
    !!! <returns>Number of days in the specified month</returns>
DAYS:InMonth  PROCEDURE(LONG month, LONG year)
IsLeapYear      BOOL
  CODE
    ! Check if it's a leap year
  IsLeapYear = CHOOSE( (year % 4 = 0 AND year % 100 <> 0) OR (year % 400 = 0), 1, 0)


  CASE month
  OF 1 OROF 3 OROF 5 OROF 7 OROF 8 OROF 10 OROF 12
    RETURN 31
  OF 4 OROF 6 OROF 9 OROF 11
    RETURN 30
  OF 2
    IF IsLeapYear
      RETURN 29
    ELSE
      RETURN 28
    END
  ELSE
    RETURN 0  ! Invalid month
  END

!!! <summary>
!!! Helper function to return the minimum of two values.
!!! </summary>
!!! <param name="a">First value</param>
!!! <param name="b">Second value</param>
!!! <returns>The smaller of the two values</returns>
MIN       PROCEDURE(LONG a, LONG b)
  CODE
  IF a <= b
    RETURN a
  ELSE
    RETURN b
  END

    
!!! <summary>
!!! Helper function to replace all occurrences of a substring within a string.
!!! </summary>
!!! <param name="FindWhat">The substring to find</param>
!!! <param name="ReplaceWith">The replacement string</param>
!!! <param name="Source">The source string to search in</param>
!!! <returns>The modified string with all replacements</returns>
Replace   PROCEDURE(STRING FindWhat, STRING ReplaceWith, STRING Source)
sPos        LONG
CurrPos     LONG
OutStr      CSTRING(4096)   ! Adjust for expected size
ChunkLen    LONG
  CODE
  CurrPos = 1
  LOOP
    sPos = INSTRING(FindWhat, CLIP(Source), 1, CurrPos)
    IF sPos = 0
      OutStr = OutStr & SUB(Source, CurrPos, LEN(CLIP(Source)) - CurrPos + 1)
      BREAK
    END

    ChunkLen = sPos - CurrPos
    IF ChunkLen > 0
      OutStr = OutStr & SUB(Source, CurrPos, ChunkLen)
    END

    OutStr = OutStr & ReplaceWith
    CurrPos = sPos + LEN(FindWhat)
  END
  RETURN OutStr


    

    !!! <summary>
    !!! Get the year component of the stored date.
    !!! </summary>
DateTimeClass.Year    PROCEDURE()
  CODE
  RETURN YEAR(SELF.Date)

    !!! <summary>
    !!! Get the month component of the stored date (1-12).
    !!! </summary>
DateTimeClass.Month   PROCEDURE()
  CODE
  RETURN MONTH(SELF.Date)

    !!! <summary>
    !!! Get the day component of the stored date (1-31).
    !!! </summary>
DateTimeClass.Day PROCEDURE()
  CODE
  RETURN DAY(SELF.Date)

    !!! <summary>
    !!! Get the hour component of the stored time (0-23).
    !!! </summary>
DateTimeClass.Hour    PROCEDURE()
  CODE
  RETURN SELF.Time / TICKS:PerHour

    !!! <summary>
    !!! Get the minute component of the stored time (0-59).
    !!! </summary>
DateTimeClass.Minute  PROCEDURE()
TimeInHours             LONG
RemainingTime           LONG
  CODE
  TimeInHours = SELF.Time / TICKS:PerHour
  RemainingTime = SELF.Time - (TimeInHours * TICKS:PerHour)
  RETURN RemainingTime / TICKS:PerMinute

    !!! <summary>
    !!! Get the second component of the stored time (0-59).
    !!! </summary>
DateTimeClass.Second  PROCEDURE()
TimeInHours             LONG
TimeInMinutes           LONG
RemainingTime           LONG
  CODE
  TimeInHours = SELF.Time / TICKS:PerHour
  RemainingTime = SELF.Time - (TimeInHours * TICKS:PerHour)
  TimeInMinutes = RemainingTime / TICKS:PerMinute
  RemainingTime = RemainingTime - (TimeInMinutes * TICKS:PerMinute)
  RETURN RemainingTime / TICKS:PerSecond

    !!! <summary>
    !!! Add the specified number of days to the stored date.
    !!! </summary>
    !!! <param name="days">Number of days to add (can be negative)</param>
    !!! <returns>Reference to self for method chaining</returns>
DateTimeClass.AddDays PROCEDURE(LONG days)
  CODE
  SELF.Date += days
  RETURN SELF

    !!! <summary>
    !!! Add the specified number of months to the stored date.
    !!! </summary>
    !!! <param name="months">Number of months to add (can be negative)</param>
    !!! <returns>Reference to self for method chaining</returns>
DateTimeClass.AddMonths   PROCEDURE(LONG months)
CurrentYear                 LONG
CurrentMonth                LONG
CurrentDay                  LONG
NewMonth                    LONG
NewYear                     LONG
  CODE
  CurrentYear = YEAR(SELF.Date)
  CurrentMonth = MONTH(SELF.Date)
  CurrentDay = DAY(SELF.Date)

    ! Calculate new month and year
  NewMonth = CurrentMonth + months
  NewYear = CurrentYear + INT((NewMonth - 1) / 12)
  NewMonth = ((NewMonth - 1) % 12) + 1

    ! Adjust for month length (e.g., Jan 31 + 1 month = Feb 28/29)
  SELF.Date = DATE(NewYear, NewMonth, MIN(CurrentDay, DAYS:InMonth(NewMonth, NewYear)))

  RETURN SELF

    !!! <summary>
    !!! Add the specified number of years to the stored date.
    !!! </summary>
    !!! <param name="years">Number of years to add (can be negative)</param>
    !!! <returns>Reference to self for method chaining</returns>
DateTimeClass.AddYears    PROCEDURE(LONG years)
CurrentYear                 LONG
CurrentMonth                LONG
CurrentDay                  LONG
  CODE
  CurrentYear = YEAR(SELF.Date)
  CurrentMonth = MONTH(SELF.Date)
  CurrentDay = DAY(SELF.Date)

    ! Adjust for leap year (Feb 29 + 1 year = Feb 28 in non-leap year)
  SELF.Date = DATE(CurrentYear + years, CurrentMonth, MIN(CurrentDay, DAYS:InMonth(CurrentMonth, CurrentYear + years)))

  RETURN SELF

    !!! <summary>
    !!! Add the specified number of hours to the stored time.
    !!! </summary>
    !!! <param name="hours">Number of hours to add (can be negative)</param>
    !!! <returns>Reference to self for method chaining</returns>
DateTimeClass.AddHours    PROCEDURE(LONG hours)
TotalTicks                  LONG
DaysToAdd                   LONG
  CODE
  TotalTicks = SELF.Time + (hours * TICKS:PerHour)

    ! Handle overflow/underflow
  DaysToAdd = INT(TotalTicks / TICKS:PerDay)
  IF TotalTicks < 0 AND TotalTicks % TICKS:PerDay <> 0
    DaysToAdd -= 1  ! Adjust for negative values
  END

  SELF.Date += DaysToAdd
  SELF.Time = TotalTicks - (DaysToAdd * TICKS:PerDay)

    ! Ensure time is positive
  IF SELF.Time < 0
    SELF.Time += TICKS:PerDay
    SELF.Date -= 1
  END

  RETURN SELF

    !!! <summary>
    !!! Add the specified number of minutes to the stored time.
    !!! </summary>
    !!! <param name="minutes">Number of minutes to add (can be negative)</param>
    !!! <returns>Reference to self for method chaining</returns>
DateTimeClass.AddMinutes  PROCEDURE(LONG minutes)
TotalTicks                  LONG
DaysToAdd                   LONG
  CODE
  TotalTicks = SELF.Time + (minutes * TICKS:PerMinute)

    ! Handle overflow/underflow
  DaysToAdd = INT(TotalTicks / TICKS:PerDay)
  IF TotalTicks < 0 AND TotalTicks % TICKS:PerDay <> 0
    DaysToAdd -= 1  ! Adjust for negative values
  END

  SELF.Date += DaysToAdd
  SELF.Time = TotalTicks - (DaysToAdd * TICKS:PerDay)

    ! Ensure time is positive
  IF SELF.Time < 0
    SELF.Time += TICKS:PerDay
    SELF.Date -= 1
  END

  RETURN SELF

    !!! <summary>
    !!! Add the specified number of seconds to the stored time.
    !!! </summary>
    !!! <param name="seconds">Number of seconds to add (can be negative)</param>
    !!! <returns>Reference to self for method chaining</returns>
DateTimeClass.AddSeconds  PROCEDURE(LONG seconds)
TotalTicks                  LONG
DaysToAdd                   LONG
  CODE
  TotalTicks = SELF.Time + (seconds * TICKS:PerSecond)

    ! Handle overflow/underflow
  DaysToAdd = INT(TotalTicks / TICKS:PerDay)
  IF TotalTicks < 0 AND TotalTicks % TICKS:PerDay <> 0
    DaysToAdd -= 1  ! Adjust for negative values
  END

  SELF.Date += DaysToAdd
  SELF.Time = TotalTicks - (DaysToAdd * TICKS:PerDay)

    ! Ensure time is positive
  IF SELF.Time < 0
    SELF.Time += TICKS:PerDay
    SELF.Date -= 1
  END

  RETURN SELF

    !!! <summary>
    !!! Format the date/time as a string.
    !!! </summary>
    !!! <param name="format">Optional format string. If empty, uses default format.</param>
    !!! <returns>Formatted date/time string</returns>
DateTimeClass.ToString    PROCEDURE(STRING format)
Result                      CSTRING(512)
Fmt                         CSTRING(256)   ! trimmed working copy
Hour12                      BYTE
AMPM                        CSTRING(3)
ShortMonth                  CSTRING(4)
ShortDay                    CSTRING(4)
i                           LONG
n                           LONG
ch                          STRING(1)
len                         LONG
QuoteChar                   STRING(1)
BlockDepth                  LONG
  CODE
  IF format = ''
    RETURN FORMAT(SELF.Date, @D2) & ' ' & |
      FORMAT(SELF.Hour(), @N02) & ':' & |
      FORMAT(SELF.Minute(), @N02) & ':' & |
      FORMAT(SELF.Second(), @N02)
  END

  ! Precompute helpers
  Hour12     = CHOOSE(SELF.Hour() % 12 = 0, 12, SELF.Hour() % 12)
  AMPM       = CHOOSE(SELF.Hour() < 12, 'AM', 'PM')
  ShortMonth = SUB('JanFebMarAprMayJunJulAugSepOctNovDec', (SELF.Month()-1)*3+1, 3)
  ShortDay   = SUB('SunMonTueWedThuFriSat', (SELF.DayOfWeek()-1)*3+1, 3)

  ! Parser setup
  Fmt   = CLIP(format)
  len   = LEN(Fmt)
  Result = ''
  i = 1

  LOOP WHILE i <= len
    ch = Fmt[i]

        ! 1) { ... } literal block, with nesting and {{ / }} for literal braces
    IF ch = '{'
      BlockDepth = 1
      i += 1
      LOOP WHILE i <= len
        ch = Fmt[i]

        ! literal doubled open brace -> '{' (no depth change)
        IF ch = '{' AND i < len AND Fmt[i + 1] = '{'
          Result = Result & '{'
          i += 2
          CYCLE
        END

        ! literal doubled close brace -> '}' (no depth change)
        IF ch = '}' AND i < len AND Fmt[i + 1] = '}'
          Result = Result & '}'
          i += 2
          CYCLE
        END

        IF ch = '{'
          BlockDepth += 1
          Result = Result & '{'
          i += 1
          CYCLE
        ELSIF ch = '}'
          BlockDepth -= 1
          i += 1
          IF BlockDepth = 0
            BREAK   ! end of outermost { ... }
          END
          Result = Result & '}'
          CYCLE
        END

        Result = Result & ch
        i += 1
      END
      CYCLE
    END


    ! 2) Quoted literal block: support '...' and "..." with doubled quotes
    IF ch = '''' OR ch = '"'
      QuoteChar = ch
      i += 1
      LOOP WHILE i <= len
        ch = Fmt[i]
        IF ch = QuoteChar
          ! doubled quote => output one
          IF i < len AND Fmt[i + 1] = QuoteChar
            Result = Result & QuoteChar
            i += 2
            CYCLE
          END
          i += 1   ! consume closing
          BREAK
        END
        Result = Result & ch
        i += 1
      END
      CYCLE
    END

    ! 3) Normal token run-length grouping (y/Y, M, d, H, h, m, s, t) or literal fallback
    n = 1
    LOOP WHILE i + n <= len AND Fmt[i + n] = ch
      n += 1
    END

    CASE ch
    OF 'y' OROF 'Y'   ! year
      IF n = 2
        Result = Result & FORMAT(SELF.Year() % 100, @N02)
      ELSE
        Result = Result & FORMAT(SELF.Year(), @N04)    ! y, yyy, yyyy -> 4-digit
      END

    OF 'M'
      CASE n
      OF 1 ; Result = Result & CLIP(LEFT(FORMAT(SELF.Month(), @N3)))     ! was FORMAT(...)
      OF 2 ; Result = Result & FORMAT(SELF.Month(), @N02)
      OF 3 ; Result = Result & ShortMonth
      ELSE ; Result = Result & SELF.GetLongMonthName()
      END

    OF 'd'
      CASE n
      OF 1 ; Result = Result & CLIP(LEFT(FORMAT(SELF.Day(), @N3)))
      OF 2 ; Result = Result & FORMAT(SELF.Day(), @N02)
      OF 3 ; Result = Result & ShortDay
      ELSE ; Result = Result & SELF.GetLongDayName()
      END

    OF 'H'
      IF n >= 2
        Result = Result & FORMAT(SELF.Hour(), @N02)
      ELSE
        Result = Result & CLIP(LEFT(FORMAT(SELF.Hour(), @N3)))
      END

    OF 'h'
      IF n >= 2
        Result = Result & FORMAT(Hour12, @N02)
      ELSE
        Result = Result & CLIP(LEFT(FORMAT(Hour12, @N3)))
      END

    OF 'm'
      IF n >= 2
        Result = Result & FORMAT(SELF.Minute(), @N02)
      ELSE
        Result = Result & CLIP(LEFT(FORMAT(SELF.Minute(), @N3)))
      END

    OF 's'
      IF n >= 2
        Result = Result & FORMAT(SELF.Second(), @N02)
      ELSE
        Result = Result & CLIP(LEFT(FORMAT(SELF.Second(), @N3)))
      END
    OF 't'            ! AM/PM designator
      IF n >= 2
        Result = Result & AMPM
      ELSE
        Result = Result & LEFT(AMPM, 1)
      END

    ELSE
      ! literal: repeat ch n times
      LOOP n TIMES
        Result = Result & ch
      END
    END

    i += n
  END

  RETURN Result


  
!!! <summary>
!!! Get the full name of the month for the stored date.
!!! </summary>
!!! <returns>Full month name (e.g., "January", "February")</returns>
DateTimeClass.GetLongMonthName    PROCEDURE()
MonthNames                          CSTRING(144)   ! 12 x 12-char names
MonthArray                          STRING(11),DIM(12),OVER(MonthNames)
  CODE
  MonthNames = 'January    February   March      April      May        June       July       August     September  October    November   December   '
  RETURN CLIP(MonthArray[self.Month()])
  
!!! <summary>
!!! Get the full name of the day of week for the stored date.
!!! </summary>
!!! <returns>Full day name (e.g., "Sunday", "Monday")</returns>
DateTimeClass.GetLongDayName  PROCEDURE()
DayNames                        CSTRING(63)                    ! 7 x 9-char padded names
DayArray                        STRING(9),DIM(7),OVER(DayNames)
  CODE
  DayNames = 'Sunday   Monday   Tuesday  WednesdayThursday Friday   Saturday '
  RETURN CLIP(DayArray[SELF.DayOfWeek()])


    !!! <summary>
    !!! Static method to get the current date and time.
    !!! </summary>
    !!! <returns>New DateTimeClass instance with current date/time</returns>
DateTimeClass.Now PROCEDURE()
NewDateTime         &DateTimeClass
  CODE
  NewDateTime &= NEW DateTimeClass
  NewDateTime.Init(TODAY(), CLOCK())
  RETURN NewDateTime

    !!! <summary>
    !!! Static method to get the current date with time set to 0.
    !!! </summary>
    !!! <returns>New DateTimeClass instance with current date and time=0</returns>
DateTimeClass.Today   PROCEDURE()
NewDateTime             &DateTimeClass
  CODE
  NewDateTime &= NEW DateTimeClass
  NewDateTime.Init(TODAY(), 0)
  RETURN NewDateTime
