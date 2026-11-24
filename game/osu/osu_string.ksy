meta:
  id: osu_string
  license: LicenseRef-All-Rights-Reserved
  imports:
    - /common/vlq_base128_le
  endian: le
seq:
  - id: indicator
    type: u1
  - id: string_length
    type: vlq_base128_le
    if: indicator == 0x0b
  - id: value
    size: string_length.value
    type: str
    encoding: UTF-8
    if: indicator == 0x0b
