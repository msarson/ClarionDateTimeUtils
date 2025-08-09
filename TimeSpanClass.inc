


  INCLUDE('DateTimeClass.inc'),ONCE

TimeSpanClass CLASS,TYPE,MODULE('TimeSpanClass.clw'),LINK('TimeSpanClass.clw')

StartDT         &DateTimeClass
EndDT           &DateTimeClass
IncludeEnd      BOOL
Signed          BOOL
Construct       PROCEDURE()
Destruct        PROCEDURE()

Init            PROCEDURE(LONG pStartDate, LONG pStartTime, LONG pEndDate, LONG pEndTime, BOOL pIncludeEnd = FALSE, BOOL pSigned = TRUE)
InitFromDateTime    PROCEDURE(DateTimeClass pStartDT, DateTimeClass pEndDT, BOOL pIncludeEnd = FALSE, BOOL pSigned = TRUE)
GetSpan         PROCEDURE(BYTE Unit), LONG
Seconds         PROCEDURE(), LONG
Minutes         PROCEDURE(), LONG
Hours           PROCEDURE(), LONG
Days            PROCEDURE(), LONG
Weeks           PROCEDURE(), LONG
Months          PROCEDURE(), LONG
Years           PROCEDURE(), LONG
! Decimal precision methods
SecondsDecimal  PROCEDURE(), REAL
MinutesDecimal  PROCEDURE(), REAL
HoursDecimal    PROCEDURE(), REAL
DaysDecimal     PROCEDURE(), REAL
WeeksDecimal    PROCEDURE(), REAL
! Core methods
BindDateTimes   PROCEDURE(*LONG sDate, *LONG sTime, *LONG eDate, *LONG eTime), SIGNED
! String representation
FormatTimeSpan  PROCEDURE(BYTE DetailLevel = 2), STRING
! Helper methods
ValidateDates   PROCEDURE(), BOOL, PRIVATE
ApplySignAndReturn  PROCEDURE(LONG value, SIGNED sign), LONG, PRIVATE
ApplySignAndReturnReal  PROCEDURE(REAL value, SIGNED sign), REAL, PRIVATE
ApplyIncludeEnd PROCEDURE(LONG value, BYTE unit), LONG, PRIVATE
! Static methods
FromSeconds     PROCEDURE(LONG seconds), *TimeSpanClass
FromMinutes     PROCEDURE(LONG minutes), *TimeSpanClass
FromHours       PROCEDURE(LONG hours), *TimeSpanClass
FromDays        PROCEDURE(LONG days), *TimeSpanClass
ToString        PROCEDURE(STRING format),STRING
              END

