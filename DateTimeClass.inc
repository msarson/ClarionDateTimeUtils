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

DateTimeClass    CLASS,TYPE,MODULE('DateTimeClass.clw'),LINK('DateTimeClass.clw')
Date                 LONG
Time                 LONG   ! TIME (1/100 sec since midnight)
Init                PROCEDURE(LONG pDate, LONG pTime)
Init                PROCEDURE(short pDay, short pMonth, short pYear, short pHour=0, short pMins=0, short pSeconds=0, short pHundreths=0)
GetDate              PROCEDURE(), LONG
GetTime              PROCEDURE(), LONG
Compare              PROCEDURE(DateTimeClass other), SIGNED   ! -1 if SELF<other, 0 if equal, 1 if SELF>other
IsZero               PROCEDURE(), BOOL                          ! TRUE if both date and time are 0
DayOfWeek            PROCEDURE(), SIGNED                        ! 1=Sunday, 2=Monday, ..., 7=Saturday
DayOfYear            PROCEDURE(), SIGNED                        ! 1-366, day of year
                     ! Date component methods
Year                 PROCEDURE(), LONG                          ! Year component of the date
Month                PROCEDURE(), LONG                          ! Month component of the date (1-12)
Day                  PROCEDURE(), LONG                          ! Day component of the date (1-31)
                     ! Time component methods
Hour                 PROCEDURE(), LONG                          ! Hour component of the time (0-23)
Minute               PROCEDURE(), LONG                          ! Minute component of the time (0-59)
Second               PROCEDURE(), LONG                          ! Second component of the time (0-59)
                     ! Date manipulation methods
AddDays              PROCEDURE(LONG days), *DateTimeClass       ! Add days to the date
AddMonths            PROCEDURE(LONG months), *DateTimeClass     ! Add months to the date
AddYears             PROCEDURE(LONG years), *DateTimeClass      ! Add years to the date
                     ! Time manipulation methods
AddHours             PROCEDURE(LONG hours), *DateTimeClass      ! Add hours to the time
AddMinutes           PROCEDURE(LONG minutes), *DateTimeClass    ! Add minutes to the time
AddSeconds           PROCEDURE(LONG seconds), *DateTimeClass    ! Add seconds to the time
                     ! Formatting method
ToString             PROCEDURE(STRING format), STRING      ! Format the date/time as a string
GetLongMonthName     PROCEDURE(), STRING
GetLongDayName       PROCEDURE(), STRING
                     ! Static methods
Now                  PROCEDURE(), *DateTimeClass        ! Get current date and time
Today                PROCEDURE(), *DateTimeClass        ! Get current date with time=0
                 END
