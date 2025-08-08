          MEMBER()
  INCLUDE('DateTimeClass.inc'),ONCE
          MAP
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
!!! Update stored date/time values.
!!! </summary>
!!! <param name="pDate">Clarion DATE</param>
!!! <param name="pTime">Clarion TIME (1/100 sec since midnight)</param>
DateTimeClass.Set PROCEDURE(LONG pDate, LONG pTime)
  CODE
  SELF.Date = pDate
  SELF.Time = pTime

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
