# Imported from https://github.com/HenryOfCarim/GameFilesTemplates/blob/f61646c9173f4f9052e2fa8421c17e4bea7776b9/albam/engines/reng/tex.ksy
# Licence and copyright: see _community/README.md
meta:
  id: reengine_tex
  title: RE Engine texture format
  file-extension: tex
  license: CC0-1.0
  ks-version: 0.8
  endian: le


seq:
  - {id: ident, contents: [0x54, 0x45, 0x58, 0x00]}
  - {id: version, type: u4}
  - {id: width, type: u2}
  - {id: height, type: u2}
  - {id: unk_00, type: u2}
  - {id: num_mipmaps, type: u1}
  - {id: unk_01, type: u1}
  - {id: format, type: u4}
  - {id: unk_02, type: u4}
  - {id: unk_03, type: u4}
  - {id: unk_04, type: u4}
  - {id: mipmaps, type: mipmap_data, repeat: expr, repeat-expr: num_mipmaps}

types:
  mipmap_data:
    seq:
      - {id: ofs_data, type: u4}
      - {id: unk_01, type: u4}
      - {id: unk_02, type: u4}
      - {id: size_data, type: u4}
    instances:
      dds_data:
        {pos: ofs_data, size: size_data}
