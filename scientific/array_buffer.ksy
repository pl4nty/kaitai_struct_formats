# Imported from https://github.com/data-exp-lab/astro-data-formats/blob/f3caaa3e68115ee3ad5cf708fe79d163ef6ae0a2/array_buffer.ksy
# Licence and copyright: see _community/README.md
meta:
  id: array_buffer
  title: Typed numeric array buffer
  license: MIT
  endian: le
params:
  - id: field_type
    type: str
seq:
  - id: buffer
    size-eos: true
instances:
  values:
    pos: 0
    size-eos: true
    id: entries
    type:
      switch-on: field_type
      cases:
        '"f4"': f4
        '"u4"': u4
        '"f8"': f8
        '"u8"': u8
        _ : f4
    repeat: eos
