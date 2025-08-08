          PROGRAM

          MAP
RunTimeSpanTests    PROCEDURE
AssertEq    PROCEDURE(STRING Name, LONG Got, LONG Expected, STRING Units)
MakeTime    PROCEDURE(SHORT Hours, SHORT Minutes, SHORT Seconds),LONG
          END

  include('TimeSpanClass.inc'),ONCE

span      LONG
TestCount     LONG
FailCount     LONG
FailLog   CSTRING(8192)
  CODE
  RunTimeSpanTests()
  SETCLIPBOARD('TimeSpanClass Tests: ' & TestCount & ' run, ' & (TestCount - FailCount) & ' passed, ' & FailCount & ' failed.' & |
    CHOOSE(FailCount > 0, '|Failures:' & '<13,10>' & FailLog, ''))
  MESSAGE('TimeSpanClass Tests: ' & TestCount & ' run, ' & (TestCount - FailCount) & ' passed, ' & FailCount & ' failed.' & |
    CHOOSE(FailCount > 0, '|Failures:' & '<13,10>' & FailLog, ''), 'Test Summary')


MakeTime  PROCEDURE(SHORT Hours, SHORT Minutes, SHORT Seconds)
  CODE
  RETURN Hours * TICKS:PerHour + Minutes * TICKS:PerMinute + Seconds * TICKS:PerSecond

AssertEq  PROCEDURE(STRING Name, LONG Got, LONG Expected, STRING Units )
Line        STRING(256)
  CODE
  TestCount += 1
  IF Got <> Expected
    FailCount += 1
    Line = Name & ': expected ' & Expected & Units & ', got ' & Got & Units
    IF LEN(CLIP(FailLog)) + LEN(CLIP(Line)) + 4 < SIZE(FailLog)
      FailLog = CLIP(FailLog) & Line & '<13,10>'
    END
  END

RunTimeSpanTests  PROCEDURE
ts                  TimeSpanClass
tsRef               &TimeSpanClass
got                 LONG
  CODE
    ! --- Original date-only tests ---
  ts.Init(DATE(8,1,2025), 0, DATE(8,8,2025), 0, FALSE, TRUE)
  AssertEq('Days: basic 7', ts.Days(), 7, ' days')

  ts.Init(DATE(8,1,2025), 0, DATE(8,8,2025), 0, TRUE, TRUE)
  AssertEq('Days: inclusive 8', ts.Days(), 8, ' days')

  ts.Init(DATE(8,8,2025), 0, DATE(8,1,2025), 0, FALSE, TRUE)
  AssertEq('Days: reverse signed', ts.Days(), -7, ' days')

  ts.Init(DATE(8,8,2025), 0, DATE(8,1,2025), 0, FALSE, FALSE)
  AssertEq('Days: reverse absolute', ts.Days(), 7, ' days')

  ts.Init(0,0, DATE(8,1,2025), 0, FALSE, TRUE)
  AssertEq('Days: zero start', ts.Days(), 0, ' days')

  ts.Init(DATE(8,1,2025),0, 0,0, FALSE, TRUE)
  AssertEq('Days: zero end', ts.Days(), 0, ' days')

    ! Weeks
  ts.Init(DATE(8,1,2025),0, DATE(8,16,2025),0, FALSE, TRUE)
  AssertEq('Weeks: 15 days -> 2', ts.Weeks(), 2, ' weeks')

  ts.Init(DATE(8,1,2025),0, DATE(8,17,2025),0, FALSE, TRUE)
  AssertEq('Weeks: 16 days -> 2', ts.Weeks(), 2, ' weeks')

  ts.Init(DATE(8,17,2025),0, DATE(8,1,2025),0, FALSE, TRUE)
  AssertEq('Weeks: reverse signed', ts.Weeks(), -2, ' weeks')

  ts.Init(DATE(8,17,2025),0, DATE(8,1,2025),0, FALSE, FALSE)
  AssertEq('Weeks: reverse absolute', ts.Weeks(), 2, ' weeks')

    ! Months
  ts.Init(DATE(1,15,2025),0, DATE(3,14,2025),0, FALSE, TRUE)
  AssertEq('Months: cutoff -1 day', ts.Months(), 1, ' months')

  ts.Init(DATE(1,15,2025),0, DATE(3,15,2025),0, FALSE, TRUE)
  AssertEq('Months: exact day', ts.Months(), 2, ' months')

  ts.Init(DATE(3,15,2025),0, DATE(1,15,2025),0, FALSE, TRUE)
  AssertEq('Months: reverse signed', ts.Months(), -2, ' months')

  ts.Init(DATE(3,14,2025),0, DATE(1,15,2025),0, FALSE, TRUE)
  AssertEq('Months: reverse cutoff', ts.Months(), -1, ' months')

    ! Leap-year months
  ts.Init(DATE(1,31,2020),0, DATE(2,29,2020),0, FALSE, TRUE)
  AssertEq('Months: Jan31->Feb29', ts.Months(), 0, ' months')

  ts.Init(DATE(1,31,2020),0, DATE(3,31,2020),0, FALSE, TRUE)
  AssertEq('Months: Jan31->Mar31', ts.Months(), 2, ' months')

    ! Years
  ts.Init(DATE(2,29,2020),0, DATE(2,28,2021),0, FALSE, TRUE)
  AssertEq('Years: leap to non-leap cutoff', ts.Years(), 0, ' years')

  ts.Init(DATE(2,29,2020),0, DATE(3,1,2021),0, FALSE, TRUE)
  AssertEq('Years: leap to Mar1', ts.Years(), 1, ' years')

  ts.Init(DATE(8,8,2025),0, DATE(8,8,2024),0, FALSE, TRUE)
  AssertEq('Years: reverse exact', ts.Years(), -1, ' years')

  ts.Init(DATE(8,9,2024),0, DATE(8,8,2025),0, FALSE, TRUE)
  AssertEq('Years: cutoff -1 day', ts.Years(), 0, ' years')

    ! Dispatcher
  ts.Init(DATE(8,1,2025),0, DATE(8,8,2025),0, FALSE, TRUE)
  AssertEq('GetSpan Days', ts.GetSpan(UNIT:Days), 7, ' days')

  ts.Init(DATE(8,1,2025),0, DATE(8,17,2025),0, FALSE, TRUE)
  AssertEq('GetSpan Weeks', ts.GetSpan(UNIT:Weeks), 2, ' weeks')

  ts.Init(DATE(1,15,2025),0, DATE(3,15,2025),0, FALSE, TRUE)
  AssertEq('GetSpan Months', ts.GetSpan(UNIT:Months), 2, ' months')

  ts.Init(DATE(2,29,2020),0, DATE(3,1,2021),0, FALSE, TRUE)
  AssertEq('GetSpan Years', ts.GetSpan(UNIT:Years), 1, ' years')

    ! --- New time-based tests ---
  ts.Init(DATE(8,1,2025), MakeTime(0,0,0), DATE(8,1,2025), MakeTime(0,0,30), FALSE, TRUE)
  AssertEq('Seconds: 30 sec', ts.Seconds(), 30, ' sec')

  ts.Init(DATE(8,1,2025), MakeTime(0,0,0), DATE(8,1,2025), MakeTime(0,1,0), FALSE, TRUE)
  AssertEq('Minutes: 1 min', ts.Minutes(), 1, ' min')

  ts.Init(DATE(8,1,2025), MakeTime(0,0,0), DATE(8,1,2025), MakeTime(1,0,0), FALSE, TRUE)
  AssertEq('Hours: 1 hr', ts.Hours(), 1, ' hr')

  ts.Init(DATE(8,1,2025), MakeTime(8,0,0), DATE(8,2,2025), MakeTime(8,0,0), FALSE, TRUE)
  AssertEq('Days: exact 1 day', ts.Days(), 1, ' days')

  ts.Init(DATE(8,1,2025), MakeTime(8,0,0), DATE(8,2,2025), MakeTime(7,0,0), FALSE, TRUE)
  AssertEq('Hours: 23 hrs', ts.Hours(), 23, ' hr')

  ts.Init(DATE(8,1,2025), MakeTime(8,0,0), DATE(8,2,2025), MakeTime(7,0,0), FALSE, FALSE)
  AssertEq('Hours abs: 23 hrs', ts.Hours(), 23, ' hr')
  ts.Init(DATE(8,2,2025), MakeTime(7,0,0), DATE(8,1,2025), MakeTime(8,0,0), FALSE, TRUE)
  AssertEq('Hours reverse signed: -23 hrs', ts.Hours(), -23, ' hr')

! Test static methods
  tsRef &= tsref.FromSeconds(3600)
  AssertEq('Static: 3600 seconds', tsRef.Seconds(), 3600, ' sec')
  AssertEq('Static: 3600 seconds as minutes', tsRef.Minutes(), 60, ' min')
  DISPOSE(tsRef)
  
  tsRef &= tsref.FromMinutes(60)
  AssertEq('Static: 60 minutes', tsRef.Minutes(), 60, ' min')
  AssertEq('Static: 60 minutes as hours', tsRef.Hours(), 1, ' hr')
  DISPOSE(tsRef)
  
  tsRef &= tsref.FromHours(24)
  AssertEq('Static: 24 hours', tsRef.Hours(), 24, ' hr')
  AssertEq('Static: 24 hours as days', tsRef.Days(), 1, ' days')
  DISPOSE(tsRef)
  
  tsRef &= tsref.FromDays(7)
  AssertEq('Static: 7 days', tsRef.Days(), 7, ' days')
  AssertEq('Static: 7 days as weeks', tsRef.Weeks(), 1, ' weeks')
  DISPOSE(tsRef)


