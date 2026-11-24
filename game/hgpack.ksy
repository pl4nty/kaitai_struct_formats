# Imported from https://github.com/HungryGhostsFanTranslation/hgtools/blob/ef12c410b29276aa9e3170517a292feb3dae8b86/hgtools/kaitai/hgpack.ksy
meta:
  id: hgpack
  title: Hungry Ghosts pack archive
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: directories
    size: 2048
    type: directory
    repeat: expr
    repeat-expr: 271
types:
  directory:
    seq:
      - id: id
        type: u4
      - id: num_files
        type: u4
        # Example: 
        # If num_files is 0x12 and first_flk5_reverse_index is 0x11, 
        # The game will only start passing files into the flk5 unpacker
        # at index 0x01. At that point it will continue doing so until
        # it has processed <num_flk5s> files.
      - id: first_flk5_reverse_index
        type: u4
      - id: first_file_ofs
        type: u4
      - id: first_flk5_ofs
        type: u4
      - id: total_flk5_size
        type: u4
      # These are properly an offset/file count for another file type.
      - id: unknown_a
        type: u4
      - id: unknown_b
        type: u4
      - id: num_flk5s
        type: u4
    instances:
      files:
        pos: 64
        type: file
        pad-right: 4
        repeat: expr
        repeat-expr: num_files
  file:
    seq:
      - id: ofs_data
        type: u4
      - id: len_data
        type: u4
      - id: unknown
        type: u4
      - id: unused
        type: u4
    instances:
      data:
        io: _root._io
        pos: ofs_data
        size: len_data
