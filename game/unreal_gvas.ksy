# Imported from https://github.com/Mervill/project-silverfish-saves/blob/49fd065fedaa750e8b16f2361bc53a8683e119bb/gvas.ksy
meta:
  id: unreal_gvas
  file-extension: gvas
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: header
    type: save_game_header
  - id: unknown1
    size: 1
  - id: test
    type: fproperty
types:
  fproperty:
    seq:
      - id: name
        type: fstring
      - id: type_name
        type: fstring
      - id: field_length
        type: s4
      - id: field
        type:
          switch-on: type_name.content
          cases:
            '"MapProperty\0"': fmapproperty
            '"NameProperty\0"': fnameproperty
  fmapproperty:
    seq:
      - id: key_type_name
        type: fstring
      - id: value_type_name
        type: fstring
      - id: elements
        type: s4
  fnameproperty:
    seq:
      - id: content
        type: fstring
  fstring:
    seq:
      - id: len
        type: s4
      - id: content
        size: len
        type: str
        encoding: ASCII
  save_game_header:
    seq:
      - id: magic
        contents: [0x47, 0x56, 0x41, 0x53]
        doc: GVAS
      - id: save_game_file_version
        type: s4
      - id: package_file_version
        type: s4
      - id: unknown_1
        size: 4
      - id: saved_engine_version
        type: engine_version
      - id: custom_version_format
        type: s4
      - id: custom_versions
        type: custom_version_collection
      - id: save_game_class_name
        type: fstring
  engine_version:
    seq:
      - id: major
        type: s2
      - id: minor
        type: s2
      - id: patch
        type: s2
      - id: build
        type: s4
      - id: branch
        type: fstring
  custom_version:
    seq:
      - id: key
        size: 16
      - id: version
        type: s4
  custom_version_collection:
    seq:
      - id: len
        type: s4
      - id: content
        type: custom_version
        repeat: expr
        repeat-expr: len
