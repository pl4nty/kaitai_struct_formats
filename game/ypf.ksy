# Imported from https://github.com/Forlos/vn_re/blob/cce0798ad2771034cee74d1ea92d70efd2a4d27d/ksy/ypf.ksy
# File entry decoding from https://github.com/mwzzhang/python-YU-RIS-package-file-unpacker/blob/995c67cbeda47118c7447ee8dc3e28cc583df87e/ypf.ksy
meta:
  id: ypf
  title: YU-RIS package file
  application: YU-RIS script engine
  file-extension: ypf
  license: MIT
  endian: le
doc: |
  Archive format of the YU-RIS visual novel engine. A 32-byte header is
  followed by the file entry table and then the file bodies, which are
  stored either raw or zlib-compressed.

  File names are obfuscated: the name length byte is bitwise-inverted and
  then passed through a small swap table (implemented in
  `file_entry::len_name`), and the name bytes are XORed with a key (0xC9 in
  the engine versions handled here; some other engine versions use a
  different key, e.g. 0xFF or 0x36). Decoded names are Shift_JIS.
seq:
  - id: magic
    contents: "YPF\0"
  - id: header
    type: header
  - id: entry_data
    size: header.entry_data_size
    type: file_entries
types:
  header:
    seq:
      - id: archive_version
        type: u4
        doc: Engine version that wrote the archive.
      - id: entry_count
        type: u4
      - id: entry_data_size
        type: u4
        doc: Size of the file entry table that follows this header.
      - id: padding
        size: 16
  file_entries:
    seq:
      - id: entries
        type: file_entry
        repeat: expr
        repeat-expr: _root.header.entry_count
  file_entry:
    seq:
      - id: unk0
        type: u4
        doc: Probably a hash of the file name.
      - id: name_size
        type: u1
        doc: Obfuscated name length; see `len_name`.
      - id: name
        size: len_name
        process: xor(0xc9)
        doc: File name (Shift_JIS) after XOR with 0xC9.
      - id: file_type
        type: u1
        enum: file_type
      - id: flags
        type: u1
        doc: 1 if the body is zlib-compressed, 0 if stored.
      - id: file_size
        type: u4
        doc: Uncompressed size.
      - id: len_body
        type: u4
        doc: Size of the body as stored in the archive (compressed size).
      - id: file_offset
        type: u8
        doc: Absolute offset of the body in the archive.
      - id: unk7
        type: u4
        doc: Probably a checksum of the body.
    instances:
      name_inv:
        value: 255 - name_size
      len_name:
        value: >-
          name_inv == 3 ? 72 : name_inv == 72 ? 3 :
          name_inv == 6 ? 53 : name_inv == 53 ? 6 :
          name_inv == 9 ? 11 : name_inv == 11 ? 9 :
          name_inv == 12 ? 16 : name_inv == 16 ? 12 :
          name_inv == 13 ? 19 : name_inv == 19 ? 13 :
          name_inv == 17 ? 24 : name_inv == 24 ? 17 :
          name_inv == 20 ? 46 : name_inv == 46 ? 20 :
          name_inv == 21 ? 27 : name_inv == 27 ? 21 :
          name_inv == 28 ? 30 : name_inv == 30 ? 28 :
          name_inv == 32 ? 35 : name_inv == 35 ? 32 :
          name_inv == 38 ? 41 : name_inv == 41 ? 38 :
          name_inv == 44 ? 47 : name_inv == 47 ? 44 :
          name_inv
        doc: |
          Decoded name length: `name_size` inverted, then mapped through
          the engine's symmetric swap table (the pairs match GARbro's YPF
          reader; the mwzzhang unpacker maps inverted value 3 to 10
          instead of 72).
      body:
        io: _root._io
        pos: file_offset
        size: len_body
        doc: Stored body (zlib stream when `flags` is 1).
enums:
  file_type:
    0: text
    2: png
    3: jpg
    5: wav
    6: ogg
