# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/archivers/cpio/cpio_portable_ascii.ksy
meta:
  id: cpio_portable_ascii
  title: cpio archive (portable ASCII format)
  license: GPL-3.0-only
seq:
  - id: entries
    type: cpio_portable_ascii_header_and_file
    repeat: until
    repeat-until: _.filename == trailing_filename and _.header.fsize == 0
instances:
  trailing_filename:
    value: '"TRAILER!!!"'
types:
  cpio_portable_ascii_header_and_file:
    seq:
      - id: header
        type: cpio_portable_ascii_header
      - id: filename
        size: header.nsize
        type: str
        terminator: 0
        encoding: ASCII
        # Unlike the old binary format, there is no additional padding after the pathname or file contents.
      - id: filedata
        #type: skip_and_ignore_type
        size: header.fsize
  cpio_portable_ascii_header:
    seq:
      - id: magic
        contents: "070707"
      - id: dev
        size: 6
        type: str
        encoding: ASCII
      - id: ino
        size: 6
        type: str
        encoding: ASCII
      - id: mode
        size: 6
        type: str
        encoding: ASCII
      - id: uid
        size: 6
        type: str
        encoding: ASCII
      - id: gid
        size: 6
        type: str
        encoding: ASCII
      - id: nlink
        size: 6
        type: str
        encoding: ASCII
      - id: rdev
        size: 6
        type: str
        encoding: ASCII
      - id: mtime
        size: 11
        type: str
        encoding: ASCII
      - id: namesize
        size: 6
        type: str
        encoding: ASCII
      - id: filesize
        size: 11
        type: str
        encoding: ASCII
    instances:
      hsize:
        value: 2*11 + 9*6
      fsize:
        value: filesize.to_i(8)
      nsize:
        value: namesize.to_i(8)
      npaddingsize:
        value: 0
      fpaddingsize:
        value: 0
      bsize:
        value: hsize + nsize + npaddingsize + fsize + fpaddingsize
      cpio_mode:
        value: mode.to_i(8)
