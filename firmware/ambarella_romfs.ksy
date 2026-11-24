# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/filesystem/romfs_ambarella/romfs_ambarella.ksy
meta:
  id: ambarella_romfs
  title: Ambarella ROMFS format
  license: CC0-1.0
  endian: le
doc: |
  Test files: <http://dc.p-mc.eu/0803/firmware>
doc-ref: http://web.archive.org/web/20190402224117/https://courses.cs.ut.ee/MTAT.07.022/2015_spring/uploads/Main/karl-report-s15.pdf (section 4.1)
seq:
  - id: num_files
    type: u4
  - id: magic
    contents: [0x8a, 0x32, 0xfc, 0x66]
  - id: padding
    type: padding_byte
    repeat: expr
    repeat-expr: 2040
  - id: file_headers
    type: file_header
    repeat: expr
    repeat-expr: num_files
    # TODO: padding
types:
  padding_byte:
    seq:
      - id: padding
        contents: [0xff]
  file_header:
    seq:
      - id: name
        size: 116
        type: strz
        encoding: ASCII
      - id: ofs_data
        type: u4
      - id: len_data
        type: u4
      - id: magic
        contents: [0x76, 0xab, 0x87, 0x23]
    instances:
      data:
        pos: ofs_data
        size: len_data
