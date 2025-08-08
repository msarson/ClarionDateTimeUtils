! ---- Time Unit Equates ----
SECS:PerMinute    EQUATE(60)
SECS:PerHour    EQUATE(60 * SECS:PerMinute)    ! 3600
SECS:PerDay    EQUATE(24 * SECS:PerHour)      ! 86400

TICKS:PerSecond    EQUATE(100)                    ! Clarion TIME is in 1/100 sec
TICKS:PerMinute    EQUATE(TICKS:PerSecond * SECS:PerMinute) ! 6000
TICKS:PerHour    EQUATE(TICKS:PerMinute * 60)              ! 360000
TICKS:PerDay    EQUATE(TICKS:PerHour * 24)                 ! 8640000

    ! ---- Units for GetSpan() ----
UNIT:Seconds    EQUATE(1)
UNIT:Minutes    EQUATE(2)
UNIT:Hours    EQUATE(3)
UNIT:Days    EQUATE(4)
UNIT:Weeks    EQUATE(5)
UNIT:Months    EQUATE(6)
UNIT:Years    EQUATE(7)


    INCLUDE('DateTimeClass.inc'),ONCE

TimeSpanClass    CLASS,TYPE,MODULE('TimeSpanClass.clw'),LINK('TimeSpanClass.clw')

StartDT              &DateTimeClass
EndDT                &DateTimeClass
IncludeEnd           BOOL
Signed               BOOL
Construct            PROCEDURE()
Destruct             PROCEDURE()
Init                 PROCEDURE(LONG pStartDate, LONG pStartTime, LONG pEndDate, LONG pEndTime, BOOL pIncludeEnd = FALSE, BOOL pSigned = TRUE)
GetSpan              PROCEDURE(BYTE Unit), LONG
Seconds              PROCEDURE(), LONG
Minutes              PROCEDURE(), LONG
Hours                PROCEDURE(), LONG
Days                 PROCEDURE(), LONG
Weeks                PROCEDURE(), LONG
Months               PROCEDURE(), LONG
Years                PROCEDURE(), LONG
BindDateTimes        PROCEDURE(*LONG sDate, *LONG sTime, *LONG eDate, *LONG eTime), SIGNED
                 END

