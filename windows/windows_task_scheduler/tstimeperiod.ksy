# Imported from https://github.com/GDATAAdvancedAnalytics/winreg-tasks/blob/72bc92e0623f9ed3212a04bf81bcce9efc7d7216/kaitai/util/tstimeperiod.ksy
# Licence and copyright: see _community/README.md
# SPDX-License-Identifier: MIT

meta:
  id: tstimeperiod
  title: Task Scheduler TSTIMEPERIOD
  license: MIT
  endian: le

seq:
  - id: year
    type: u2
  - id: month
    type: u2
  - id: week
    type: u2
  - id: day  # if used in conjunction with week this is "day of week"
    type: u2
  - id: hour
    type: u2
  - id: minute
    type: u2
  - id: second
    type: u2
