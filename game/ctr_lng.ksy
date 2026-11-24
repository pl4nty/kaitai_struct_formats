# Imported from https://github.com/CTR-tools/CTR-tools/blob/8edc826ccab49099776f6431e25b4136a2ecbec3/formats/ctr_lng.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ctr_lng
  title: Crash Team Racing (PS1) localization file
  application: Crash Team Racing
  file-extension: lng
  license: GPL-2.0-only
  endian: le

seq:
  - id: num_entries
    type: u4
  - id: ptr_offsets
    type: u4
    
instances:
  entries:
    pos: ptr_offsets
    type: entry
    repeat: expr
    repeat-expr: num_entries
      
  missingmsg:
    pos: ptr_offsets + 4 * num_entries
    type: strz
    encoding: ASCII

types:
  entry:
    seq:
      - id: offset
        type: u4
    instances:
      text:
        pos: offset
        type: strz
        encoding: ASCII
