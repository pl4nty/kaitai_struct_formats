# Imported from https://github.com/Picoseconds/GlacierFormats/blob/5de39927e70d03edd0df0a7954d5c9c3227d87a2/hitman3_rpkg2.ksy
# Licence and copyright: see _community/README.md
meta:
  id: hitman3_rpkg2
  title: HITMAN III RPKG v2 data file
  file-extension: rpkg
  xref:
    wikidata: Q96216496
  license: CC0-1.0
  endian: le
doc: |
  HITMAN III's RPKG data files contain all of the game's data and assets,
  including maps and level data. RPKG files have a built-in patch system that
  lets you delete, modify and add new data to an existing RPKG chunk.
seq:
  - id: header
    type: header
  - id: body
    type: body
instances:
  patch_zero_test:
    pos: header.patch_entry_count * 0x8 + 0x1d + 0x7
    type: u1
  patch_value:
    pos: header.patch_entry_count * 0x8 + 0x1d + 0x8
    type: u8
  is_patch:
    value: patch_value == header.table_offset + header.table_size + header.patch_entry_count * 0x8 + 0x1d and patch_zero_test == 0x0
  input_file_size:
    value: 'is_patch ? header.table_offset + header.table_size + 0x1d + header.patch_entry_count * 0x8 : header.table_offset + header.table_size + 0x19'
  hashes_data:
    pos: header.table_offset + 29 + header.patch_entry_count * 8
    type: hash_data(_index)
    repeat: expr
    repeat-expr: header.file_count
types:
  header:
    seq:
      - id: magic
        contents: '2KPR'
      - id: header
        size: 9
      - id: file_count
        type: u4
      - id: table_offset
        type: u4
      - id: table_size
        type: u4
      - id: patch_entry_count
        type: u4
  body:
    seq:
      - id: patch_entries
        size: 8
        repeat: expr
        repeat-expr: _root.header.patch_entry_count
        if: _root.is_patch
      - id: files
        type: file(_index)
        repeat: expr
        repeat-expr: _root.header.file_count
  hash_reference:
    seq:
      - id: hash
        type: u8
  file:
    params:
      - id: i
        type: s4
    seq:
      - id: hash
        type: u8
      - id: hash_offset
        type: u8
      - id: hash_size
        type: u4
    instances:
      is_lz4ed:
        value: (hash_size & 0x3FFFFFFF) != 0
      is_xored:
        value: (hash_size & 0x80000000) == 0x80000000
      data:
        value: _root.hashes_data[i]
      resource_type:
        value: _root.hashes_data[i].resource_type.reverse
      file_name:
        value: 'hash.to_s + "." + resource_type'
  hash_data:
    params:
      - id: i
        type: s4
    seq:
      - id: resource_type
        size: 4
        type: str
        encoding: ASCII
      - id: reference_table_size
        type: u4
      - id: reference_table_dummy
        type: u4
      - id: hash_size_final
        type: u4
      - id: hash_size_in_memory
        type: u4
      - id: hash_size_in_video_memory
        type: u4
      - id: hash_reference_count
        type: u4
        if: reference_table_size != 0
      - id: reference_types
        type: u1
        repeat: expr
        repeat-expr: hash_reference_count & 0x3FFFFFFF
        if: reference_table_size != 0
      - id: references
        type: hash_reference
        repeat: expr
        repeat-expr: reference_count
        if: reference_table_size != 0
    instances:
      reference_count:
        value: hash_reference_count & 0x3FFFFFFF
