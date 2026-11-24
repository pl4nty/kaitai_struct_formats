# Imported from https://github.com/Brachi/albam/blob/6242aaff6c4145732b9b78213f2d7cf9b84d4545/albam/engines/mtfw/structs/arc.ksy
meta:
  id: mtframework_arc
  title: MTFramework archive format
  file-extension: arc
  license: MIT
  ks-version: '0.11'
  endian: le
  bit-endian: le


seq:
  - {id: header, type: arc_header}
  - {id: file_entries, type: file_entry, repeat: expr, repeat-expr: _root.header.num_files}
  - {id: padding, size: 32760 - (_root.header.num_files * 80) % 32768}

types:
  arc_header:
    seq:
      - {id: ident, contents: [0x41, 0x52, 0x43, 0x00]}
      - {id: version, type: s2}
      - {id: num_files, type: s2}
    instances:
      size_:
        value: 8 
  file_entry:
    seq:
      - {id: file_path, type: str, encoding: ASCII, size: 64, terminator: 0}
      - {id: file_type, type: s4}
      - {id: zsize, type: u4}
      - {id: size, type: b29}
      - {id: flags, type: b3}
      - {id: offset, type: u4}
    instances:
      raw_data:
        {io: _root._io, pos: offset, size: zsize}
