          PROGRAM

          MAP
RunTimeSpanTests    PROCEDURE
RunDateTimeTests    PROCEDURE
AssertEq    PROCEDURE(STRING Name, LONG Got, LONG Expected, STRING Units)
AssertEqStr PROCEDURE(STRING Name, STRING Got, STRING Expected)
MakeTime    PROCEDURE(SHORT Hours, SHORT Minutes, SHORT Seconds),LONG
          END

  include('TimeSpanClass.inc'),ONCE

span      LONG
TestCount     LONG
FailCount     LONG
FailLog   CSTRING(8192)
  CODE
  RunTimeSpanTests()
  RunDateTimeTests()
  SETCLIPBOARD('Tests: ' & TestCount & ' run, ' & (TestCount - FailCount) & ' passed, ' & FailCount & ' failed.' & |
    CHOOSE(FailCount > 0, '|Failures:' & '<13,10>' & FailLog, ''))
  MESSAGE('Tests: ' & TestCount & ' run, ' & (TestCount - FailCount) & ' passed, ' & FailCount & ' failed.' & |
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
AssertEqStr PROCEDURE(STRING Name, STRING Got, STRING Expected)
Line        STRING(256)
CODE
  TestCount += 1
  IF CLIP(Got) <> CLIP(Expected)
    FailCount += 1
    Line = Name & ': expected "' & Expected & '", got "' & Got & '"'
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

  ! Test case: 30 seconds span
  ts.Init(DATE(8,1,2025), MakeTime(0,0,0), DATE(8,1,2025), MakeTime(0,0,30), FALSE, TRUE)

  ! Core formats
  AssertEqStr('TS c', ts.ToString('c'), '0.00:00:30')
  AssertEqStr('TS d.hh:mm:ss', ts.ToString('d.hh:mm:ss'), '0.00:00:30')
  AssertEqStr('TS hh:mm:ss', ts.ToString('hh:mm:ss'), '00:00:30')
  AssertEqStr('TS m:ss', ts.ToString('m:ss'), '0:30')
  AssertEqStr('TS s', ts.ToString('s'), '30')
  AssertEqStr('TS ss', ts.ToString('ss'), '30')
  AssertEqStr('TS Literal', ts.ToString('d "days" h "hours" m "minutes" s "seconds"'), '0 days 0 hours 0 minutes 30 seconds')
  AssertEqStr('TS Fractional', ts.ToString('d.hh:mm:ss.ff'), '0.00:00:30.00')
  AssertEqStr('TS Total hours', ts.ToString('H:mm:ss'), '0:00:30')

  ! Fractional extras
  AssertEqStr('TS Tenths', ts.ToString('s.f'), '30.0')
  AssertEqStr('TS Hundredths', ts.ToString('s.ff'), '30.00')

  ! Brace literal tests
  AssertEqStr('TS Brace-literal simple', ts.ToString('{exact text}'), 'exact text')
  AssertEqStr('TS Brace-literal with tokens outside', ts.ToString('h{ hours }m{ mins }'), '0 hours 0 mins ')
  AssertEqStr('TS Brace-literal only token inside', ts.ToString('{h}'), 'h')  ! braces block tokens from being parsed
  AssertEqStr('TS Brace with nested braces literal', ts.ToString('{outer {inner} text}'), 'outer {inner} text')
  
  ! Static method tests
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

!==============================================================================
RunDateTimeTests  PROCEDURE
dt                  DateTimeClass
dt2                 DateTimeClass
  CODE
  dt.Init(DATE(1,8,2025), MakeTime(14,5,9))     ! 2025-01-08 14:05:09 (2:05:09 PM)
  dt2.Init(DATE(1,8,2025), MakeTime(0,3,4))     ! 2025-01-08 00:03:04 (AM case)

  ! --- Core token coverage ---
  AssertEqStr('DT ISO date', dt.ToString('yyyy-MM-dd'), '2025-01-08')
  AssertEqStr('DT Full date/time 24h', dt.ToString('dd/MM/yyyy HH:mm:ss'), '08/01/2025 14:05:09')
  AssertEqStr('DT 12h no pad + AMPM', dt.ToString('h:mm tt'), '2:05 PM')
  AssertEqStr('DT 12h padded + AMPM', dt.ToString('hh:mm tt'), '02:05 PM')
  AssertEqStr('DT Short day/month names', dt.ToString('ddd, MMM d'), 'Wed, Jan 8')
  AssertEqStr('DT Long day/month names',  dt.ToString('dddd, MMMM d'), 'Wednesday, January 8')
  AssertEqStr('DT Uppercase Y works',     dt.ToString('YYYY-MM-dd'), '2025-01-08')

  ! Single-character tokens (no padding)
  AssertEqStr('DT h:m:s no pad', dt.ToString('h:m:s'), '2:5:9')

  ! AM case
  AssertEqStr('DT AM tt', dt2.ToString('tt'), 'AM')
  AssertEqStr('DT AM t',  dt2.ToString('t'),  'A')
  AssertEqStr('DT AM 12h', dt2.ToString('hh:mm tt'), '12:03 AM')

  ! --- Quoted literals ---
  AssertEqStr('DT Quoted word', dt.ToString('yyyy "year"'), '2025 year')
  AssertEqStr('DT Double quotes inside', dt.ToString('"Say ""Hello"""'), 'Say "Hello"')

  ! --- Brace literal blocks ---
  AssertEqStr('DT Braces literals only', dt.ToString('{exact text}'), 'exact text')
  AssertEqStr('DT Braces with tokens outside', dt.ToString('h{ hours }m{ minutes }s{ seconds }'), '2 hours 5 minutes 9 seconds')
  AssertEqStr('DT Token-looking text inside braces is literal', dt.ToString('{hh:mm:ss}'), 'hh:mm:ss')

  ! Doubled braces inside a block
  AssertEqStr('DT Braces with doubled open',  dt.ToString('{show {{{this}}}'), 'show {this}')
  AssertEqStr('DT Braces with nesting',       dt.ToString('{outer {inner} text}'), 'outer {inner} text')

  ! Mixed braces + tokens
  AssertEqStr('DT Mixed ISO + braces', dt.ToString('yyyy-MM-dd{ at }HH:mm:ss'), '2025-01-08 at 14:05:09')

  ! --- AM/PM variations ---
  AssertEqStr('DT PM tt', dt.ToString('tt'), 'PM')
  AssertEqStr('DT PM t',  dt.ToString('t'),  'P')

  ! --- Month/day numeric variations ---
  AssertEqStr('DT M/d/y short', dt.ToString('M/d/yy'), '1/8/25')
  AssertEqStr('DT MM/dd/yyyy',  dt.ToString('MM/dd/yyyy'), '01/08/2025')

  ! --- Edge: repeated literals outside quotes/braces ---
  AssertEqStr('DT Literal colons', dt.ToString('HH:mm:ss :: {end}'), '14:05:09 :: end')
