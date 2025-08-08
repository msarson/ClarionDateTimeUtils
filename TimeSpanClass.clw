          MEMBER    ()
  INCLUDE('TimeSpanClass.inc'),ONCE
          MAP
          ! This section is for non-class methods only
          END



!!! <summary>
!!! Allocate DateTimeClass references used by this instance.
!!! </summary>
TimeSpanClass.Construct   PROCEDURE()
  CODE
  SELF.StartDT &= NEW DateTimeClass
  SELF.EndDT   &= NEW DateTimeClass

!!! <summary>
!!! Dispose allocated DateTimeClass references.
!!! </summary>
TimeSpanClass.Destruct    PROCEDURE()
  CODE
  DISPOSE(SELF.StartDT)
  DISPOSE(SELF.EndDT)


!!! <summary>
!!! Initialize start/end values and configuration flags.
!!! </summary>
!!! <param name="pStartDate">Start DATE</param>
!!! <param name="pStartTime">Start TIME (1/100 sec since midnight)</param>
!!! <param name="pEndDate">End DATE</param>
!!! <param name="pEndTime">End TIME (1/100 sec since midnight)</param>
!!! <param name="pIncludeEnd">Include terminal boundary in results</param>
!!! <param name="pSigned">Return signed results when start > end</param>
TimeSpanClass.Init    PROCEDURE(LONG pStartDate, LONG pStartTime, LONG pEndDate, LONG pEndTime, BOOL pIncludeEnd, BOOL pSigned)
  CODE
  SELF.IncludeEnd = pIncludeEnd
  SELF.Signed     = pSigned
    ! initialize encapsulated DateTime instances
  SELF.StartDT.Init(pStartDate, pStartTime)
  SELF.EndDT.Init(pEndDate, pEndTime)

!!! <summary>
!!! Initialize from DateTimeClass instances.
!!! </summary>
!!! <param name="pStartDT">Start DateTimeClass instance</param>
!!! <param name="pEndDT">End DateTimeClass instance</param>
!!! <param name="pIncludeEnd">Include terminal boundary in results</param>
!!! <param name="pSigned">Return signed results when start > end</param>
TimeSpanClass.InitFromDateTime PROCEDURE(DateTimeClass pStartDT, DateTimeClass pEndDT, BOOL pIncludeEnd, BOOL pSigned)
  CODE
  SELF.IncludeEnd = pIncludeEnd
  SELF.Signed     = pSigned
  ! Copy values from provided DateTimeClass instances
  SELF.StartDT.Init(pStartDT.GetDate(), pStartDT.GetTime())
  SELF.EndDT.Init(pEndDT.GetDate(), pEndDT.GetTime())

!!! <summary>
!!! Return the time span in a specific unit.
!!! </summary>
!!! <param name="Unit">UNIT:Seconds|Minutes|Hours|Days|Weeks|Months|Years</param>
TimeSpanClass.GetSpan PROCEDURE(BYTE Unit)
  CODE
  CASE Unit
  OF UNIT:Seconds ; RETURN SELF.Seconds()
  OF UNIT:Minutes ; RETURN SELF.Minutes()
  OF UNIT:Hours   ; RETURN SELF.Hours()
  OF UNIT:Days    ; RETURN SELF.Days()
  OF UNIT:Weeks   ; RETURN SELF.Weeks()
  OF UNIT:Months  ; RETURN SELF.Months()
  OF UNIT:Years   ; RETURN SELF.Years()
  END
  RETURN 0

    ! ---- Core binding method: ensures sDate/sTime <= eDate/eTime, returns sign ----
!!! <summary>
!!! Normalize start/end ordering and return the sign of the original ordering.
!!! </summary>
!!! <param name="sDate">OUT normalized start DATE</param>
!!! <param name="sTime">OUT normalized start TIME</param>
!!! <param name="eDate">OUT normalized end DATE</param>
!!! <param name="eTime">OUT normalized end TIME</param>
TimeSpanClass.BindDateTimes   PROCEDURE(*LONG sDate, *LONG sTime, *LONG eDate, *LONG eTime)
sign                            SIGNED
  CODE
  IF SELF.EndDT.Compare(SELF.StartDT) >= 0
    sign   = 1
    sDate  = SELF.StartDT.GetDate()
    sTime  = SELF.StartDT.GetTime()
    eDate  = SELF.EndDT.GetDate()
    eTime  = SELF.EndDT.GetTime()
  ELSE
    sign   = -1
    sDate  = SELF.EndDT.GetDate()
    sTime  = SELF.EndDT.GetTime()
    eDate  = SELF.StartDT.GetDate()
    eTime  = SELF.StartDT.GetTime()
  END
  RETURN sign

!!! <summary>
!!! Validates that both start and end dates are non-zero.
!!! </summary>
!!! <returns>TRUE if dates are valid, FALSE otherwise</returns>
TimeSpanClass.ValidateDates   PROCEDURE()
  CODE
  IF SELF.StartDT.GetDate() <> 0 AND SELF.EndDT.GetDate() <> 0
    RETURN TRUE
  END
  RETURN FALSE

!!! <summary>
!!! Applies sign to a value based on the Signed flag.
!!! </summary>
!!! <param name="value">The value to apply sign to</param>
!!! <param name="sign">The sign value (-1 or 1)</param>
!!! <returns>Signed or absolute value based on Signed flag</returns>
TimeSpanClass.ApplySignAndReturn  PROCEDURE(LONG value, SIGNED sign)
  CODE
  IF SELF.Signed THEN RETURN value * sign.
  RETURN ABS(value)

!!! <summary>
!!! Applies sign to a real value based on the Signed flag.
!!! </summary>
!!! <param name="value">The real value to apply sign to</param>
!!! <param name="sign">The sign value (-1 or 1)</param>
!!! <returns>Signed or absolute value based on Signed flag</returns>
TimeSpanClass.ApplySignAndReturnReal PROCEDURE(REAL value, SIGNED sign)
  CODE
  IF SELF.Signed THEN RETURN value * sign.
  RETURN ABS(value)

!!! <summary>
!!! Applies the IncludeEnd adjustment to a value based on the unit.
!!! </summary>
!!! <param name="value">The value to adjust</param>
!!! <param name="unit">The unit (UNIT:Seconds, UNIT:Minutes, etc.)</param>
!!! <returns>Adjusted value if IncludeEnd is TRUE</returns>
TimeSpanClass.ApplyIncludeEnd PROCEDURE(LONG value, BYTE unit)
    CODE
    IF NOT SELF.IncludeEnd THEN RETURN value.
    
    CASE unit
    OF UNIT:Seconds ; RETURN value + 1
    OF UNIT:Minutes ; RETURN value + 1
    OF UNIT:Hours   ; RETURN value + 1
    OF UNIT:Days    ; RETURN value + 1
    OF UNIT:Weeks   ; RETURN value + 1
    OF UNIT:Months  ; RETURN value + 1
    OF UNIT:Years   ; RETURN value + 1
    ELSE             ; RETURN value
    END

    ! ---- Base difference in seconds ----
!!! <summary>
!!! Compute the span in whole seconds.
!!! </summary>
TimeSpanClass.Seconds PROCEDURE()
sDate    LONG
sTime    LONG
eDate    LONG
eTime    LONG
sign    SIGNED
secs    LONG
    CODE
    IF NOT SELF.ValidateDates() THEN RETURN 0.
    sign = SELF.BindDateTimes(sDate, sTime, eDate, eTime)
    secs = (eDate - sDate) * SECS:PerDay + (eTime - sTime) / TICKS:PerSecond
    secs = SELF.ApplyIncludeEnd(secs, UNIT:Seconds)
    RETURN SELF.ApplySignAndReturn(secs, sign)

!!! <summary>
!!! Compute the span in whole minutes.
!!! </summary>
TimeSpanClass.Minutes PROCEDURE()
  CODE
  RETURN SELF.Seconds() / SECS:PerMinute

!!! <summary>
!!! Compute the span in whole hours.
!!! </summary>
TimeSpanClass.Hours   PROCEDURE()
  CODE
  RETURN SELF.Seconds() / SECS:PerHour

!!! <summary>
!!! Compute the span in whole days (truncated).
!!! </summary>
TimeSpanClass.Days    PROCEDURE()
sDate    LONG
sTime    LONG
eDate    LONG
eTime    LONG
sign    SIGNED
secs    LONG
days    LONG
    CODE
    IF NOT SELF.ValidateDates() THEN RETURN 0.

    sign = SELF.BindDateTimes(sDate, sTime, eDate, eTime)
    secs = (eDate - sDate) * SECS:PerDay + (eTime - sTime) / TICKS:PerSecond
    days = INT(secs / SECS:PerDay)
    days = SELF.ApplyIncludeEnd(days, UNIT:Days)

    RETURN SELF.ApplySignAndReturn(days, sign)


!!! <summary>
!!! Compute the span in whole weeks.
!!! </summary>
TimeSpanClass.Weeks   PROCEDURE()
  CODE
  RETURN SELF.Days() / 7

!!! <summary>
!!! Compute the span in seconds with decimal precision.
!!! </summary>
TimeSpanClass.SecondsDecimal PROCEDURE()
sDate    LONG
sTime    LONG
eDate    LONG
eTime    LONG
sign     SIGNED
secs     REAL
  CODE
  IF NOT SELF.ValidateDates() THEN RETURN 0.
  sign = SELF.BindDateTimes(sDate, sTime, eDate, eTime)
  secs = (eDate - sDate) * SECS:PerDay + (eTime - sTime) / TICKS:PerSecond
  IF SELF.IncludeEnd THEN secs += 1.
  RETURN SELF.ApplySignAndReturnReal(secs, sign)

!!! <summary>
!!! Compute the span in minutes with decimal precision.
!!! </summary>
TimeSpanClass.MinutesDecimal PROCEDURE()
  CODE
  RETURN SELF.SecondsDecimal() / SECS:PerMinute

!!! <summary>
!!! Compute the span in hours with decimal precision.
!!! </summary>
TimeSpanClass.HoursDecimal PROCEDURE()
  CODE
  RETURN SELF.SecondsDecimal() / SECS:PerHour

!!! <summary>
!!! Compute the span in days with decimal precision.
!!! </summary>
TimeSpanClass.DaysDecimal PROCEDURE()
  CODE
  RETURN SELF.SecondsDecimal() / SECS:PerDay

!!! <summary>
!!! Compute the span in weeks with decimal precision.
!!! </summary>
TimeSpanClass.WeeksDecimal PROCEDURE()
  CODE
  RETURN SELF.DaysDecimal() / 7

!!! <summary>
!!! Compute the span in whole calendar months.
!!! </summary>
TimeSpanClass.Months  PROCEDURE()
sDate                   LONG
sTime                   LONG
eDate                   LONG
eTime                   LONG
sign                    SIGNED
y1                      LONG
m1                      LONG
y2                      LONG
m2                      LONG
months                  LONG
  CODE
  IF NOT SELF.ValidateDates() THEN RETURN 0.
  sign = SELF.BindDateTimes(sDate, sTime, eDate, eTime)

  y1 = YEAR(sDate) ; m1 = MONTH(sDate)
  y2 = YEAR(eDate) ; m2 = MONTH(eDate)

  months = (y2 * 12 + m2) - (y1 * 12 + m1)
    ! cutoff if end day/time is before start day/time
  IF (DAY(eDate) < DAY(sDate)) OR (DAY(eDate) = DAY(sDate) AND eTime < sTime)
    months -= 1
  END

  months = SELF.ApplyIncludeEnd(months, UNIT:Months)
  RETURN SELF.ApplySignAndReturn(months, sign)

!!! <summary>
!!! Compute the span in whole calendar years.
!!! </summary>
TimeSpanClass.Years   PROCEDURE()
sDate                   LONG
sTime                   LONG
eDate                   LONG
eTime                   LONG
sign                    SIGNED
years                   LONG
  CODE
  IF NOT SELF.ValidateDates() THEN RETURN 0.
  sign = SELF.BindDateTimes(sDate, sTime, eDate, eTime)

  years = YEAR(eDate) - YEAR(sDate)
    ! cutoff if end month/day/time is before start
  IF (MONTH(eDate) < MONTH(sDate)) OR (MONTH(eDate) = MONTH(sDate) AND (DAY(eDate) < DAY(sDate) OR (DAY(eDate) = DAY(sDate) AND eTime < sTime)))
    years -= 1
  END

  years = SELF.ApplyIncludeEnd(years, UNIT:Years)
  RETURN SELF.ApplySignAndReturn(years, sign)

!!! <summary>
!!! Format the time span as a human-readable string.
!!! </summary>
!!! <param name="DetailLevel">Level of detail: 1=highest unit only, 2=two highest units, 3=all units</param>
!!! <returns>Formatted string (e.g., "1 day, 2 hours, 30 minutes")</returns>
TimeSpanClass.FormatTimeSpan PROCEDURE(BYTE DetailLevel)
result      STRING(100)
years       LONG
months      LONG
days        LONG
hours       LONG
minutes     LONG
seconds     LONG
totalSecs   LONG
sign        STRING(1)
unitsAdded  BYTE
  CODE
  IF NOT SELF.ValidateDates() THEN RETURN ''.
  
  totalSecs = SELF.Seconds()
  IF totalSecs < 0
    sign = '-'
    totalSecs = -totalSecs
  ELSE
    sign = ''
  END
  
  ! Extract each unit
  years = INT(totalSecs / (SECS:PerDay * 365))
  totalSecs -= years * (SECS:PerDay * 365)
  
  months = INT(totalSecs / (SECS:PerDay * 30))
  totalSecs -= months * (SECS:PerDay * 30)
  
  days = INT(totalSecs / SECS:PerDay)
  totalSecs -= days * SECS:PerDay
  
  hours = INT(totalSecs / SECS:PerHour)
  totalSecs -= hours * SECS:PerHour
  
  minutes = INT(totalSecs / SECS:PerMinute)
  totalSecs -= minutes * SECS:PerMinute
  
  seconds = totalSecs
  
  ! Build the string based on detail level
  result = sign
  unitsAdded = 0
  
  IF years > 0 AND unitsAdded < DetailLevel
    result = result & years & ' year' & CHOOSE(years = 1, '', 's')
    unitsAdded += 1
    IF unitsAdded < DetailLevel THEN result = result & ', '.
  END
  
  IF (months > 0 OR (years > 0 AND unitsAdded < DetailLevel)) AND unitsAdded < DetailLevel
    result = result & months & ' month' & CHOOSE(months = 1, '', 's')
    unitsAdded += 1
    IF unitsAdded < DetailLevel THEN result = result & ', '.
  END
  
  IF (days > 0 OR (months > 0 AND unitsAdded < DetailLevel)) AND unitsAdded < DetailLevel
    result = result & days & ' day' & CHOOSE(days = 1, '', 's')
    unitsAdded += 1
    IF unitsAdded < DetailLevel THEN result = result & ', '.
  END
  
  IF (hours > 0 OR (days > 0 AND unitsAdded < DetailLevel)) AND unitsAdded < DetailLevel
    result = result & hours & ' hour' & CHOOSE(hours = 1, '', 's')
    unitsAdded += 1
    IF unitsAdded < DetailLevel THEN result = result & ', '.
  END
  
  IF (minutes > 0 OR (hours > 0 AND unitsAdded < DetailLevel)) AND unitsAdded < DetailLevel
    result = result & minutes & ' minute' & CHOOSE(minutes = 1, '', 's')
    unitsAdded += 1
    IF unitsAdded < DetailLevel THEN result = result & ', '.
  END
  
  IF (seconds > 0 OR (minutes > 0 AND unitsAdded < DetailLevel)) AND unitsAdded < DetailLevel
    result = result & seconds & ' second' & CHOOSE(seconds = 1, '', 's')
    unitsAdded += 1
  END
  
  IF result = sign THEN result = '0 seconds'.
  
  RETURN CLIP(result)
