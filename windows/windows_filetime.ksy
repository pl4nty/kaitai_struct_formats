meta:
  id: windows_filetime
  title: Microsoft Windows FILETIME structure
  license: Unlicense
  endian: le
  imports:
    - /common/calendar
doc: |
  Microsoft Windows FILETIME structure
doc-ref: https://learn.microsoft.com/en-us/windows/win32/api/minwinbase/ns-minwinbase-filetime
-webide-representation: "{date} {time}"
-affected-by: upstream kaitai_struct_webide issue 155
instances:
  date:
    type: calendar::cobol_date(splitted.day)
  hundreds_nanoseconds_per_second:
    value: 10000000
  nanoseconds:
    doc: nanoseconds passed since the beginning of the second
    value: (raw % hundreds_nanoseconds_per_second) * 100
  splitted:
    type: calendar::split_day_time(raw / hundreds_nanoseconds_per_second)
  time:
    value: splitted.time

seq:
  - id: raw
    type: u8
