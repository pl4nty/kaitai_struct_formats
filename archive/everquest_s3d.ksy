# Imported from https://github.com/Wld-Doc/wld-doc.github.io/blob/fd9eef5fde2414478e24826dc14ddc6df7c8fd47/static/files/s3d.ksy
meta:
  id: everquest_s3d
  title: EverQuest S3D archive
  file-extension: s3d
  license: LicenseRef-All-Rights-Reserved
  endian: le

seq:
  - id: header
    type: header

instances:
  directory:
    pos: header.directory_offset
    type: directory

  # files:
  #   type: file
  #   repeat: expr


types:
  header:
    seq:
      - id: directory_offset
        type: u4
      - id: magic
        contents: 'PFS '
      - id: version
        type: u4

  directory:
    seq:
      - id: file_count
        type: u4

      - id: entries
        type: entry
        repeat: expr
        repeat-expr: file_count

      - id: magic
        contents: 'STEVE'

      # Need to research this, compare files.
      - id: date_stamp
        type: u4

  entry:
    seq:
      - id: crc
        type: u4
      - id: offset
        type: u4
      - id: size
        type: u4

    instances:
      blocks:
        io: _root._io
        pos: offset
        type: block(_index)
        repeat: until
        repeat-until: _.sum == size

  block:
    params:
      - id: i
        type: u1
    seq:
      - id: deflated_size
        type: u4
      - id: inflated_size
        type: u4
      - id: body
        size: deflated_size

    instances:
      sum:
        value: '((i > 0 ? _parent.blocks[i - 1].sum : 0.) + inflated_size).as<u4>'

# Going to stop here; i was able to get all of the compressed blocks gathered.
# filenames are stored in the last (largest offset) "file" alongside the other entries
# to keep going I need to be able to inflate the blocks, join them together,
