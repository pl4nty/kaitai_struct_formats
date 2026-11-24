# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/archivers/cpio/cpio_new_ascii.ksy
meta:
  id: cpio_new_ascii
  title: cpio archive (new ASCII format)
  license: GPL-3.0-only
seq:
  - id: entries
    type: cpio_new_ascii_header_and_file
    repeat: until
    repeat-until: _.filename == trailing_filename and _.header.fsize == 0
instances:
  trailing_filename:
    value: '"TRAILER!!!"'
types:
  cpio_new_ascii_header_and_file:
    seq:
      - id: header
        type: cpio_new_ascii_header
      - id: filename
        size: header.nsize
        # new ascii: The pathname is followed by NUL bytes so that the total
        # size of the fixed header plus pathname is a multiple of four.
        # Likewise, the file data is padded to a multiple of four bytes. 
        type: strz
        encoding: UTF-8
      - id: filename_padding
        size: (4 - (( header.nsize + header.hsize ) % 4)) % 4
      - id: filedata 
        # TODO: only set this type if file is regular
        # type: skip_and_ignore_type
        size: header.fsize
      - id: filedata_padding
        size: (4 - (header.fsize % 4)) % 4
  cpio_new_ascii_header:
    seq:
      - id: magic
        contents: "070701"
      - id: ino
        size: 8
        type: str
        encoding: ASCII
      - id: mode
        size: 8
        type: str
        encoding: ASCII
      - id: uid
        size: 8
        type: str
        encoding: ASCII
      - id: gid
        size: 8
        type: str
        encoding: ASCII
      - id: nlink
        size: 8
        type: str
        encoding: ASCII
      - id: mtime
        size: 8
        type: str
        encoding: ASCII
      - id: filesize
        size: 8
        type: str
        encoding: ASCII
      - id: devmajor
        size: 8
        type: str
        encoding: ASCII
      - id: devminor
        size: 8
        type: str
        encoding: ASCII
      - id: rdevmajor
        size: 8
        type: str
        encoding: ASCII
      - id: rdevminor
        size: 8
        type: str
        encoding: ASCII
      - id: namesize
        size: 8
        type: str
        encoding: ASCII
      - id: check
        size: 8
        type: str
        encoding: ASCII
    instances:
      hsize:
        value: 13*8+6
      fsize:
        value: filesize.to_i(16)
      nsize:
        value: namesize.to_i(16)
      npaddingsize:
        value: '(-( nsize + hsize ) % 4)'
      fpaddingsize:
        value: (-fsize % 4)
      bsize:
        value: hsize + nsize + npaddingsize + fsize + fpaddingsize
      cpio_mode:
        value: mode.to_i(16)
