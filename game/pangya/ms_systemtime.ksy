# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/common/ms_systemtime.ksy
meta:
  id: ms_systemtime
  title: MS SYSTEMTIME
  license: ISC
  encoding: ASCII
  endian: le

doc: Windows-formatted local system time. For reference, see [the MSDN article on the SYSTEMTIME structure](https://learn.microsoft.com/en-us/windows/win32/api/minwinbase/ns-minwinbase-systemtime).

seq:
  - id: ms_year
    type: u2
    doc: Valid values are 1601 through 30827 (per MSDN).
  - id: ms_month
    type: u2
    doc: Valid values are 1 (January) through 12 (December).
  - id: ms_dayofweek
    type: u2
    doc: Valid values are 0 (Sunday) through 6 (Saturday).
  - id: ms_day
    type: u2
    doc: Valid values are 1 through 31.
  - id: ms_hour
    type: u2
    doc: Valid values are 0 through 23.
  - id: ms_minute
    type: u2
    doc: Valid values are 0 through 59.
  - id: ms_second
    type: u2
    doc: Valid values are 0 through 59.
  - id: ms_microsecond
    type: u2
    doc: Valid values are 0 through 999.
