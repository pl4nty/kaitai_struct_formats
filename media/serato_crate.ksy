# Imported from https://github.com/dalhaan/dj-migrator-electron/blob/f01fba56b6c1487538cf6389f80a1e31027862c9/lib/node/src/kaitai/schemas/serato_crate.ksy
meta:
  id: serato_crate
  title: Serato crate file
  license: LicenseRef-All-Rights-Reserved
  encoding: UTF-16BE
  endian: be

seq:
  - id: tags
    type: tag
    repeat: eos

types:
  tag:
    seq:
      - id: type
        size: 4
        type: str
        encoding: ASCII
      - id: length
        type: u4
      - id: body
        size: length
        type:
          switch-on: type
          cases:
            '"vrsn"': version_tag
            '"osrt"': first_column_tag
            '"tvcn"': column_name_tag
            '"ovct"': column_tag
            '"otrk"': track_tag
            '"ptrk"': file_path_tag
            _: unknown_tag

  version_tag:
    seq:
      - id: body
        size-eos: true
        type: str
  first_column_tag:
    seq:
      - id: tags
        type: tag
        repeat: eos
  column_name_tag:
    seq:
      - id: name
        size-eos: true
        type: str
  column_tag:
    seq:
      - id: tags
        type: tag
        repeat: eos
  track_tag:
    seq:
      - id: tags
        type: tag
        repeat: eos
  file_path_tag:
    seq:
      - id: file_path
        size-eos: true
        type: str
  unknown_tag:
    seq:
      - id: body
        size-eos: true
