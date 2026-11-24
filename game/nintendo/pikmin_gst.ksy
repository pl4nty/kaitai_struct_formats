# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/pikmin_gst.ksy
meta:
  id: pikmin_gst
  title: Pikmin 1 recorded controller stream (record.gst)
  file-extension: gst
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Pikmin 1 `ghost/record.gst` (`Kontroller::write` in the decompilation). The
  all-zero tail of the fixed-size buffer is trailing padding.
seq:
  - id: frames
    type: frame
    repeat: eos
types:
  frame:
    seq:
      - id: button_mask
        type: u4
      - id: main_stick_x
        type: s1
      - id: main_stick_y
        type: s1
      - id: sub_stick_x
        type: s1
      - id: sub_stick_y
        type: s1
      - id: analog_a
        type: u1
      - id: analog_b
        type: u1
      - id: trigger_l
        type: u1
      - id: trigger_r
        type: u1
