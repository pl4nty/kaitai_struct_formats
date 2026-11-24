# Imported from https://github.com/GDATAAdvancedAnalytics/winreg-tasks/blob/72bc92e0623f9ed3212a04bf81bcce9efc7d7216/kaitai/aligned/bstr_expand_size.ksy
# Licence and copyright: see _community/README.md
# SPDX-License-Identifier: MIT

meta:
  id: aligned_bstr_expand_size
  title: Task Scheduler aligned BSTR (expanded size)
  license: MIT
  imports:
    - aligned_u4
  endian: le

seq:
  - id: string_length
    type: aligned_u4
  - id: content
    size: byte_count
    type: str
    encoding: UTF-16LE
    if: string_length.value > 0
  - id: padding
    size: (8 - (byte_count % 8)) % 8
    if: string_length.value > 0

instances:
  byte_count:
    value: string_length.value * 2 + 2
