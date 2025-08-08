MEMBER    ()
    INCLUDE('TimeSpanClass.inc'),ONCE
    MAP


    END




!!! <summary>
!!! Allocate DateTimeClass references used by this instance.
!!! </summary>
TimeSpanClass.Construct    PROCEDURE()
    CODE
    SELF.StartDT &= NEW DateTimeClass
    SELF.EndDT   &= NEW DateTimeClass

!!! <summary>
!!! Dispose allocated DateTimeClass references.
!!! </summary>
TimeSpanClass.Destruct     PROCEDURE()
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
!!! Return the time span in a specific unit.
!!! </summary>
!!! <param name="Unit">UNIT:Seconds|Minutes|Hours|Days|Weeks|Months|Years</param>
TimeSpanClass.GetSpan    PROCEDURE(BYTE Unit)
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
TimeSpanClass.BindDateTimes    PROCEDURE(*LONG sDate, *LONG sTime, *LONG eDate, *LONG eTime)
sign    SIGNED
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
    IF SELF.StartDT.GetDate() = 0 OR SELF.EndDT.GetDate() = 0 THEN RETURN 0.
    sign = SELF.BindDateTimes(sDate, sTime, eDate, eTime)
    secs = (eDate - sDate) * SECS:PerDay + (eTime - sTime) / TICKS:PerSecond
    IF SELF.IncludeEnd THEN secs += 1.
    IF SELF.Signed THEN RETURN secs * sign.
    RETURN ABS(secs)

!!! <summary>
!!! Compute the span in whole minutes.
!!! </summary>
TimeSpanClass.Minutes    PROCEDURE()
    CODE
    RETURN SELF.Seconds() / SECS:PerMinute

!!! <summary>
!!! Compute the span in whole hours.
!!! </summary>
TimeSpanClass.Hours    PROCEDURE()
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
    IF SELF.StartDT.GetDate() = 0 OR SELF.EndDT.GetDate() = 0 THEN RETURN 0.

    sign = SELF.BindDateTimes(sDate, sTime, eDate, eTime)
    secs = (eDate - sDate) * SECS:PerDay + (eTime - sTime) / TICKS:PerSecond

    IF SELF.IncludeEnd THEN secs += SECS:PerDay.  ! add a full day, not 1 second

    days = INT(secs / SECS:PerDay)

    IF SELF.Signed THEN RETURN days * sign.
    RETURN ABS(days)


!!! <summary>
!!! Compute the span in whole weeks.
!!! </summary>
TimeSpanClass.Weeks    PROCEDURE()
    CODE
    RETURN SELF.Days() / 7

!!! <summary>
!!! Compute the span in whole calendar months.
!!! </summary>
TimeSpanClass.Months  PROCEDURE()
sDate    LONG
sTime    LONG
eDate    LONG
eTime    LONG
sign    SIGNED
y1    LONG
m1    LONG
y2    LONG
m2    LONG
months    LONG
    CODE
    IF SELF.StartDT.GetDate() = 0 OR SELF.EndDT.GetDate() = 0 THEN RETURN 0.
    sign = SELF.BindDateTimes(sDate, sTime, eDate, eTime)

    y1 = YEAR(sDate) ; m1 = MONTH(sDate)
    y2 = YEAR(eDate) ; m2 = MONTH(eDate)

    months = (y2 * 12 + m2) - (y1 * 12 + m1)
    ! cutoff if end day/time is before start day/time
    IF (DAY(eDate) < DAY(sDate)) OR (DAY(eDate) = DAY(sDate) AND eTime < sTime)
        months -= 1
    END

    IF SELF.Signed THEN RETURN months * sign.
    RETURN ABS(months)

!!! <summary>
!!! Compute the span in whole calendar years.
!!! </summary>
TimeSpanClass.Years   PROCEDURE()
sDate    LONG
sTime    LONG
eDate    LONG
eTime    LONG
sign    SIGNED
years    LONG
    CODE
    IF SELF.StartDT.GetDate() = 0 OR SELF.EndDT.GetDate() = 0 THEN RETURN 0.
    sign = SELF.BindDateTimes(sDate, sTime, eDate, eTime)

    years = YEAR(eDate) - YEAR(sDate)
    ! cutoff if end month/day/time is before start
    IF (MONTH(eDate) < MONTH(sDate)) OR (MONTH(eDate) = MONTH(sDate) AND (DAY(eDate) < DAY(sDate) OR (DAY(eDate) = DAY(sDate) AND eTime < sTime)))
        years -= 1
    END

    IF SELF.Signed THEN RETURN years * sign.
    RETURN ABS(years)
