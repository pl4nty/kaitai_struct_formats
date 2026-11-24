# Imported from https://codeberg.org/stf_format/stf_schema
# Licence and copyright: see _community/README.md
meta:
  id: stf
  title: Squirrel Transfer Format
  file-extension: stf
  xref:
    mime: model/stf+binary
  license: MIT OR Apache-2.0
  endian: le

doc: |
  STF is a file-format for 3d models, made to be imported into game-engine
  projects, while also being usable for further editing in 3d modeling tools.

  This file is hosted at: https://schema.stfform.at/stf.ksy

doc-ref: https://docs.stfform.at/format/stf_format.html#binary-format

seq:
  - id: magic
    contents: STF0

  - id: version
    type: u4
    doc: Version of the binary definition

  - id: padding
    type: u4
    doc: This field may be reused for other purposes in the future.

  - id: num_buffers
    type: u4
    doc: The number of buffers, including the JSON definition

  - id: len_json_definition
    type: u8
    doc: Length of the JSON definition buffer

  - id: len_buffers
    type: u8
    repeat: expr
    repeat-expr: num_buffers - 1
    doc: Lengths of all buffers after the JSON definition

  - id: json_definition
    size: len_json_definition
    type: str
    encoding: UTF-8
    doc: JSON definition
    doc-ref: https://schema.stfform.at/stf.schema.json

  - id: buffers
    size: len_buffers[_index]
    repeat: expr
    repeat-expr: num_buffers - 1
    doc: Arbitrary binary data, referenced from the JSON definition
