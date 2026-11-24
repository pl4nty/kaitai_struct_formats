# Imported from https://github.com/GDATAAdvancedAnalytics/winreg-tasks/blob/72bc92e0623f9ed3212a04bf81bcce9efc7d7216/kaitai/aligned/buffer.ksy
# SPDX-License-Identifier: MIT

meta:
  id: aligned_buffer
  title: Task Scheduler aligned buffer
  license: MIT
  imports:
    - aligned_u4
  endian: le

seq:
  - id: size
    type: aligned_u4
  - id: data
    size: size.value
  - id: padding
    size: (8 - (size.value % 8)) % 8
