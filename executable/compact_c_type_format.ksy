meta:
  id: compact_c_type_format
  title: Compact C Type Format (CTF)
  application:
    - FreeBSD
    - illumos
    - DTrace
  license: CC0-1.0
  ks-version: '0.9'
doc: |
  Compact C Type Format (CTF), as used by FreeBSD, illumos and DTrace to
  describe the C types of an ELF object in a compact form. A CTF container
  is normally stored in the `.SUNW_ctf` section of an ELF file. This spec
  parses such a section's contents.

  A container starts with a 4-byte preamble (magic 0xcff1, version,
  flags) and a header with the parent container's label and name and the
  offsets of the label, object, function, type and string sections. The
  offsets are relative to the end of the 36-byte header; if the
  `CTF_F_COMPRESS` flag is set, everything after the header is zlib
  compressed and the offsets refer to the decompressed data.

  The byte order is that of the enclosing ELF object; it is detected here
  from the order of the magic bytes. Versions 2 and 3 are supported. The
  type section is fully decoded. The object and function sections are
  exposed as raw bytes, as they can only be interpreted alongside the ELF
  symbol table. Names are offsets into the string section (table 0) or,
  with the high bit set, into the ELF string table (table 1).

  Note that this is not the GNU binutils CTF format (magic 0xdff2), which
  diverged from it.
doc-ref:
  - https://man.freebsd.org/cgi/man.cgi?query=ctf&sektion=5
  - https://github.com/freebsd/freebsd-src/blob/e035f2783661085545d2d0ea8b9cf58f7fb3de7e/sys/sys/ctf.h
seq:
  - id: magic
    size: 2
    valid:
      any-of:
        - '[0xf1, 0xcf]'
        - '[0xcf, 0xf1]'
    doc: 0xcff1 in the byte order of the container.
  - id: container
    type: container(magic == [0xf1, 0xcf])
types:
  container:
    meta:
      endian:
        switch-on: is_le
        cases:
          true: le
          false: be
    params:
      - id: is_le
        type: bool
    seq:
      - id: version
        type: u1
        valid:
          any-of: [2, 3]
      - id: flags
        type: u1
      - id: ofs_parent_label
        type: u4
        doc: String reference to the name of the parent label (0 if none).
      - id: ofs_parent_name
        type: u4
        doc: String reference to the basename of the parent container (0 if none).
      - id: ofs_labels
        type: u4
      - id: ofs_objects
        type: u4
      - id: ofs_functions
        type: u4
      - id: ofs_types
        type: u4
      - id: ofs_strings
        type: u4
      - id: len_strings
        type: u4
      - id: data_compressed
        size-eos: true
        type: sections(is_v2)
        process: zlib
        if: is_compressed
      - id: data
        size: ofs_strings + len_strings
        type: sections(is_v2)
        if: not is_compressed
    instances:
      is_compressed:
        value: flags & 1 != 0
      is_v2:
        value: version == 2
    types:
      sections:
        params:
          - id: is_v2
            type: bool
        seq:
          - id: labels
            size: _parent.ofs_objects - _parent.ofs_labels
            type: labels
          - id: objects
            size: _parent.ofs_functions - _parent.ofs_objects
            doc: |
              Type identifiers of data objects, in the order of the matching
              STT_OBJECT symbols of the ELF symbol table.
          - id: functions
            size: _parent.ofs_types - _parent.ofs_functions
            doc: |
              Return and argument types of functions, in the order of the
              matching STT_FUNC symbols of the ELF symbol table.
          - id: types
            size: _parent.ofs_strings - _parent.ofs_types
            type: types(is_v2)
          - id: strings
            size: _parent.len_strings
            doc: String table of NUL-terminated strings; offset 0 is the empty string.
      labels:
        seq:
          - id: labels
            type: label
            repeat: eos
      label:
        seq:
          - id: name
            type: u4
          - id: type_index
            type: u4
            doc: Last type identifier covered by this label.
      types:
        params:
          - id: is_v2
            type: bool
        seq:
          - id: types
            type: type_entry(is_v2)
            repeat: eos
            doc: Types in order; the first one has identifier 1 (0x8000 / 0x80000000 in a child).
      type_entry:
        params:
          - id: is_v2
            type: bool
        seq:
          - id: name
            type: u4
            doc: String reference to the type name.
          - id: info
            type:
              switch-on: is_v2
              cases:
                true: u2
                false: u4
            doc: Encoded kind, root flag and variable length count.
          - id: size_or_type
            type:
              switch-on: is_v2
              cases:
                true: u2
                false: u4
            doc: |
              Size in bytes (integers, floats, structs, unions, enums), or type
              identifier of the referenced type (pointers, typedefs, qualifiers,
              return type of functions).
          - id: lsize_hi
            type: u4
            if: is_large_size
          - id: lsize_lo
            type: u4
            if: is_large_size
          - id: encoding
            type: u4
            if: kind == kind::integer or kind == kind::float
            doc: |
              Bits 24-31: encoding (integer flags or float kind), bits 16-23:
              offset in bits, bits 0-15: size in bits.
          - id: array
            type: array_info(is_v2)
            if: kind == kind::array
          - id: args
            type:
              switch-on: is_v2
              cases:
                true: u2
                false: u4
            repeat: expr
            repeat-expr: vlen
            if: kind == kind::function
            doc: Argument type identifiers; a trailing 0 marks varargs.
          - id: args_padding
            type: u2
            if: kind == kind::function and is_v2 and vlen % 2 == 1
            doc: Padding to 4-byte alignment (version 2 only).
          - id: members
            type: member(is_v2, is_large_struct)
            repeat: expr
            repeat-expr: vlen
            if: kind == kind::struct or kind == kind::union
          - id: enumerators
            type: enumerator
            repeat: expr
            repeat-expr: vlen
            if: kind == kind::enum
        instances:
          kind:
            value: '(is_v2 ? (info >> 11) & 0x1f : (info >> 26) & 0x3f)'
            enum: kind
          is_root:
            value: '(is_v2 ? (info >> 10) & 1 : (info >> 25) & 1) != 0'
            doc: Whether the type is visible at the top level (named types).
          vlen:
            value: 'is_v2 ? info & 0x3ff : info & 0xffffff'
            doc: Number of variable length entries (arguments, members, enumerators).
          is_large_size:
            value: 'size_or_type == (is_v2 ? 0xffff : 0xffffffff)'
            doc: Whether the size does not fit and is stored in `lsize_hi` / `lsize_lo`.
          size:
            value: 'is_large_size ? (lsize_hi.as<u8> << 32) | lsize_lo : size_or_type'
            doc: Size of the type in bytes, where applicable.
          is_large_struct:
            value: 'size >= (is_v2 ? 8192 : 536870912)'
            doc: Whether struct/union members use the large member encoding.
      array_info:
        params:
          - id: is_v2
            type: bool
        seq:
          - id: contents_type
            type:
              switch-on: is_v2
              cases:
                true: u2
                false: u4
          - id: index_type
            type:
              switch-on: is_v2
              cases:
                true: u2
                false: u4
          - id: num_elements
            type: u4
      member:
        params:
          - id: is_v2
            type: bool
          - id: is_large
            type: bool
        seq:
          - id: name
            type: u4
          - id: member_type
            type:
              switch-on: is_v2
              cases:
                true: u2
                false: u4
          - id: offset_bits_short
            type: u2
            if: is_v2 and not is_large
          - id: padding
            type: u2
            if: is_v2 and is_large
          - id: offset_bits_v3
            type: u4
            if: not is_v2 and not is_large
          - id: offset_bits_hi
            type: u4
            if: is_large
          - id: offset_bits_lo
            type: u4
            if: is_large
        instances:
          offset_bits:
            value: >-
              is_large ? (offset_bits_hi.as<u8> << 32) | offset_bits_lo :
              is_v2 ? offset_bits_short : offset_bits_v3
            doc: Offset of the member from the start of the structure, in bits.
      enumerator:
        seq:
          - id: name
            type: u4
          - id: value
            type: s4
enums:
  kind:
    0: unknown
    1: integer
    2: float
    3: pointer
    4: array
    5: function
    6: struct
    7: union
    8: enum
    9: forward
    10: typedef
    11: volatile
    12: const
    13: restrict
