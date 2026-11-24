# Imported from https://github.com/GDATAAdvancedAnalytics/winreg-tasks/blob/72bc92e0623f9ed3212a04bf81bcce9efc7d7216/kaitai/util/filetime.ksy
# Licence and copyright: see _community/README.md
# SPDX-License-Identifier: MIT

meta:
  id: filetime
  title: Windows FILETIME
  license: MIT
  endian: le

seq:
  - id: low_date_time
    type: u4
  - id: high_date_time
    type: u4
