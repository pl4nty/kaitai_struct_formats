# Imported from https://github.com/GDATAAdvancedAnalytics/winreg-tasks/blob/72bc92e0623f9ed3212a04bf81bcce9efc7d7216/kaitai/util/tstime.ksy
# Licence and copyright: see _community/README.md
# SPDX-License-Identifier: MIT

meta:
  id: tstime
  title: Task Scheduler TSTIME
  license: MIT
  imports:
    - ../windows_filetime
  endian: le

seq:
  - id: is_localized
    type: u1
  - id: pad
    size: 7
  - id: filetime
    type: windows_filetime
