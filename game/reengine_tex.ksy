# Imported from https://github.com/HenryOfCarim/GameFilesTemplates/blob/f61646c9173f4f9052e2fa8421c17e4bea7776b9/albam/engines/reng/tex.ksy
# Version 30/34 mipmap header from https://github.com/Brachi/albam/blob/HEAD/albam/engines/reng/structs/tex.ksy
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
  - id: mipmap_header
    type:
      switch-on: version
      cases:
        30: mipmap_header_2
        34: mipmap_header_2
        _: mipmap_header_1 # versions 10 and 190820018
  - {id: format, type: u4}
  - {id: unk_02, type: u4}
  - {id: unk_03, type: u4}
  - {id: unk_04, type: u4}
  - {id: unk_05, type: u8, if: version == 30 or version == 34}
  - {id: mipmaps, type: mipmap_data, repeat: expr, repeat-expr: num_mipmaps}

instances:
  num_mipmaps:
    value: 'version == 30 or version == 34 ? mipmap_header.as<mipmap_header_2>.num_mipmaps : mipmap_header.as<mipmap_header_1>.num_mipmaps'

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
  mipmap_header_1:
    seq:
      - {id: num_mipmaps, type: u1}
      - {id: num_images, type: u1}
  mipmap_header_2:
    seq:
      - {id: num_images, type: u1}
      - {id: size_mipmap_header, type: u1}
    instances:
      num_mipmaps:
        value: size_mipmap_header / 16
