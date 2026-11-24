# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/nulstb.ksy
meta:
  id: nulstb
  title: Bandai Namco SSBH file-name list (Super Smash Bros. Ultimate)
  file-extension: nulstb
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  SSBH NLST container (`.nulstb`), Super Smash Bros. Ultimate. Reference:
  ultimate-research/ssbh_lib `ssbh_lib/src/formats/nlst.rs` (`Nlst::V10`) --
  a flat array of file names to load.
seq:
  - id: magic
    contents: [0x48, 0x42, 0x53, 0x53] # "HBSS"
  - id: unk1
    type: u8
    doc: Always 0x40 on retail files.
  - id: sub_magic
    contents: [0x54, 0x53, 0x4c, 0x4e] # "TSLN" ("NLST" byte-reversed)
  - id: version_major
    type: u2
  - id: version_minor
    type: u2
  - id: file_names
    type: ssbh_array
    doc: SsbhArray<SsbhString>.
types:
  ssbh_array:
    seq:
      - id: ofs_rel
        type: u8
      - id: count
        type: u8
  ssbh_string:
    seq:
      - id: ofs_rel
        type: u8
