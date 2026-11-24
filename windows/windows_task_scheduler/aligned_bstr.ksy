# Imported from https://github.com/GDATAAdvancedAnalytics/winreg-tasks/blob/72bc92e0623f9ed3212a04bf81bcce9efc7d7216/kaitai/aligned/bstr.ksy
# Licence and copyright: see _community/README.md
# SPDX-License-Identifier: MIT

meta:
  id: aligned_bstr
  title: Task Scheduler aligned BSTR
  license: MIT
  imports:
    - aligned_u4
  endian: le

seq:
  - id: byte_count
    type: aligned_u4
  - id: string
    size: byte_count.value
    type: str
    encoding: UTF-16LE
  - id: block_padding
    size: (8 - (byte_count.value % 8)) % 8
