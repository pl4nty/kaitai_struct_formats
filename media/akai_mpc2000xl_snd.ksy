# Imported from https://github.com/izzyreal/mpc2000xl_kaitai/blob/d08b543e1abe96b7ecca74e09173ab8d6055bef7/mpc2000xl.snd.ksy
meta:
  id: akai_mpc2000xl_snd
  title: Akai MPC2000XL sound (.snd)
  file-extension: SND
  license: LicenseRef-All-Rights-Reserved
  bit-endian: le

# Known producers currently evidenced:
# - MPC2000XL OS 1.20

seq:
  - id: magic
    contents: [0x01, 0x04]
  - id: name
    size: 17
    type: str
    encoding: ASCII
  - id: level
    type: u1
  - id: tune
    type: s1
  - id: stereo
    type: b1
  - id: start
    type: u4le
  - id: end
    type: u4le
  - id: frame_count
    type: u4le
  - id: loop_frame_count
    type: u4le
  - id: loop_enabled
    type: b1
  - id: beat_count
    type: u1
  - id: sample_rate
    type: u2le
  - id: sample_data
    type: s2le
    repeat: expr
    repeat-expr: "stereo ? frame_count * 2 : frame_count"
