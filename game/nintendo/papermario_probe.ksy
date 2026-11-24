# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/switch/papermario_probe.ksy
meta:
  id: papermario_probe
  title: Paper Mario (Switch) light probe.header
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  "probe.header" light-probe binary from Paper Mario: The Origami King
  / The Thousand-Year Door (Switch), ported from `pmprobe_t` and
  IsPMProbe()/ScanPMProbe() in lib-papermario.h/.c (native port of
  KillzXGaming/Paper-Mario-Tools' LightConverter ProbeHeader.cs).
  Fixed 156-byte body plus 4 bytes per axis-texture entry.
seq:
  - id: magic
    contents: [0x64, 0x00, 0x00, 0x00]
    doc: Constant 100 (PMPROBE_MAGIC).
  - id: num_axis
    type: u4
  - id: axis
    type: u4
    repeat: expr
    repeat-expr: num_axis
  - id: pos
    type: f4
    repeat: expr
    repeat-expr: 3
  - id: box_scale
    type: f4
    repeat: expr
    repeat-expr: 3
  - id: unk
    type: f4
    repeat: expr
    repeat-expr: 4
  - id: param1
    type: f4
  - id: param2
    type: f4
  - id: color
    type: f4
    repeat: expr
    repeat-expr: 3
  - id: unk2
    type: f4
    repeat: expr
    repeat-expr: 3
  - id: type_name
    size: 64
    type: str
    terminator: 0
    encoding: UTF-8
  - id: unk_a0
    type: u4
  - id: unk_a4
    type: f4
  - id: unk_a8
    type: f4
  - id: unk_ac
    type: u4
