DateTimeClass    CLASS,TYPE,MODULE('DateTimeClass.clw'),LINK('DateTimeClass.clw')
Date                 LONG
Time                 LONG   ! TIME (1/100 sec since midnight)
Init                 PROCEDURE(LONG pDate, LONG pTime)
Set                  PROCEDURE(LONG pDate, LONG pTime)
GetDate              PROCEDURE(), LONG
GetTime              PROCEDURE(), LONG
Compare              PROCEDURE(DateTimeClass other), SIGNED   ! -1 if SELF<other, 0 if equal, 1 if SELF>other
IsZero               PROCEDURE(), BOOL                          ! TRUE if both date and time are 0
DayOfWeek            PROCEDURE(), SIGNED                        ! 1=Sunday, 2=Monday, ..., 7=Saturday
DayOfYear            PROCEDURE(), SIGNED                        ! 1-366, day of year
                 END
