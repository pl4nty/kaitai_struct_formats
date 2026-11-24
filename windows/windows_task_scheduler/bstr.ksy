# Imported from https://github.com/GDATAAdvancedAnalytics/winreg-tasks/blob/72bc92e0623f9ed3212a04bf81bcce9efc7d7216/kaitai/util/bstr.ksy
# SPDX-License-Identifier: MIT

meta:
  id: bstr
  title: Task Scheduler BSTR
  license: MIT
  endian: le

seq:
  - id: len
    type: u4
  - id: str
    size: len
    type: str
    encoding: UTF-16LE
