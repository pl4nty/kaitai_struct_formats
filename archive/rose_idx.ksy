# Imported from https://github.com/SevenHearts/portship.js/blob/124d26389d1f7c0bd621894f1d44a9c75c8c9c2e/src/format/IDX.ksy
meta:
  id: rose_idx
  title: ROSE Online VFS index (.idx)
  file-extension: idx
  license: LicenseRef-All-Rights-Reserved
  encoding: ASCII
  endian: le
seq:
  - id: base_version
    type: u4
  - id: current_version
    type: u4
  - id: vfs_count
    type: u4
  - id: vfs_meta
    type: vfs_meta
    repeat: expr
    repeat-expr: vfs_count
types:
  vfs_meta:
    seq:
      - id: path
        type: sstr
      - id: offset
        type: u4
    instances:
      index:
        pos: offset
        type: vfs_index
    types:
      sstr:
        seq:
          - id: len
            type: u2
          - id: data
            size: 'len - 1'
            type: str
          - size: 1
      vfs_index:
        seq:
          - id: file_count
            type: u4
          - id: delete_count
            type: u4
          - id: start_offset
            type: u4
          - id: files
            type: vfs_file
            repeat: expr
            repeat-expr: file_count
        types:
          vfs_file:
            seq:
              - id: path
                type: sstr
              - id: offset
                type: u4
              - id: length
                type: u4
              - id: block_size
                type: u4
              - id: deleted
                type: b1
              - id: compression_type
                type: u1
              - id: encryption_type
                type: u1
              - id: version
                type: u4
              - id: checksum
                type: u4
