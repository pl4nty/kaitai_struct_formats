# Imported from https://github.com/GDATAAdvancedAnalytics/winreg-tasks/blob/72bc92e0623f9ed3212a04bf81bcce9efc7d7216/kaitai/dynamic_info.ksy
# Licence and copyright: see _community/README.md
# SPDX-License-Identifier: MIT

meta:
  id: windows_task_scheduler_dynamic_info
  title: Windows Task Scheduler DynamicInfo registry value
  license: MIT
  endian: le
seq:
  - id: magic
    size: 4
  - id: creation_time
    type: u8
  - id: last_run_time
    type: u8
  - id: task_state  # not used in recent Windows version; always zero
    type: u4
  - id: last_error_code
    type: u4
  - id: last_successful_run_time
    type: u8
