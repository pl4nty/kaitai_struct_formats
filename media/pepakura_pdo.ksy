meta:
  id: pepakura_pdo
  title: Pepakura Designer 3 papercraft model
  application:
    - Pepakura Designer
    - Pepakura Viewer
  file-extension: pdo
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Pepakura Designer unfolds a 3D model into flat parts that can be printed,
  cut out and glued together into a paper model. A .pdo file stores the 3D
  geometry together with its unfolded 2D layout, the textures and the
  settings of the printed pages.

  This spec covers the files written by Pepakura Designer 3, which start
  with the line `version 3`. The format was reverse engineered; the meaning
  of most of the fields is unknown.

  Test files: <https://github.com/daeken/PepakuraReverse/tree/master/pdos>
doc-ref: https://github.com/daeken/PepakuraReverse/blob/master/Readme.md
seq:
  - id: magic
    contents: "version 3\n"
  - id: lock_status
    type: u4
    enum: lock_status
  - id: unknown1
    type: u4
  - id: version
    type: u4
  - id: creator
    type: text
    if: is_locked
    doc: |
      Name of the program that wrote the file, e.g. "Pepakura Designer 3".
      Unlike every other string of a locked file, this one is stored as is,
      because it precedes `key`.
  - id: key
    type: u4
    if: is_locked
    doc: Number added to every byte of every following string (modulo 256).
  - id: locale
    type: text
    doc: Empty in files written by the English version.
  - id: codepage
    type: text
    doc: |
      Name of the character encoding of the strings, as the program spells
      it, e.g. "Sfhit-JIS" (sic).
  - id: unknown2
    type: u4
  - id: hexstring
    type: text
  - id: unknown3
    type: u1
    repeat: expr
    repeat-expr: 2
    if: is_locked
  - id: unknown4
    type: f8
    repeat: expr
    repeat-expr: 4
  - id: num_geometries
    type: u4
  - id: geometries
    type: geometry
    repeat: expr
    repeat-expr: num_geometries
  - id: num_textures
    type: u4
  - id: textures
    type: texture
    repeat: expr
    repeat-expr: num_textures
  - id: has_layout
    type: u1
  - id: layout
    type: layout
    if: has_layout != 0
  - id: unknown5
    type: u1
    repeat: expr
    repeat-expr: 5
  - id: unknown6
    type: u4
  - id: unknown7
    type: u1
  - id: unknown8
    type: u4
    repeat: expr
    repeat-expr: 4
  - id: unknown9
    type: u4
  - id: unknown10
    type: f8
    repeat: expr
    repeat-expr: 2
    if: unknown9 == 11
  - id: unknown11
    type: u4
    repeat: expr
    repeat-expr: 3
  - id: unknown12
    type: f8
    repeat: expr
    repeat-expr: 12
  - id: unknown13
    type: u1
  - id: unknown14
    type: f8
  - id: unknown15
    type: text
    repeat: expr
    repeat-expr: 2
    if: is_locked
  - id: footer
    contents: [0x0f, 0x27, 0, 0]
instances:
  is_locked:
    value: lock_status == lock_status::locked
types:
  text:
    doc: |
      String in the encoding named by `codepage`.

      In a locked file `key` has been added to every byte of every string
      that follows `key` (modulo 256), so it must be subtracted again before
      decoding the bytes.
    seq:
      - id: len_value
        type: u4
      - id: value
        size: len_value
  geometry:
    seq:
      - id: name
        type: text
      - id: unknown1
        type: u1
      - id: num_vertices
        type: u4
      - id: vertices
        type: vec3
        repeat: expr
        repeat-expr: num_vertices
      - id: num_shapes
        type: u4
      - id: shapes
        type: shape
        repeat: expr
        repeat-expr: num_shapes
      - id: num_edges
        type: u4
      - id: edges
        type: edge
        repeat: expr
        repeat-expr: num_edges
    types:
      shape:
        doc: A face of the 3D model and its position on the paper.
        seq:
          - id: unknown1
            type: s4
          - id: part
            type: u4
            doc: Number of the part of the unfolded model the face belongs to.
          - id: unknown2
            type: f8
            repeat: expr
            repeat-expr: 4
          - id: num_points
            type: u4
          - id: points
            type: point
            repeat: expr
            repeat-expr: num_points
      point:
        seq:
          - id: idx_vertex
            type: u4
            doc: Index into `vertices` of the geometry.
          - id: coord
            type: vec2
            doc: Position of the point on the paper.
          - id: unknown1
            type: f8
            repeat: expr
            repeat-expr: 2
          - id: unknown2
            type: u1
          - id: unknown3
            type: f8
            repeat: expr
            repeat-expr: 3
          - id: unknown4
            type: u4
            repeat: expr
            repeat-expr: 3
          - id: edge_color
            type: rgb
      edge:
        seq:
          - id: unknown1
            type: u4
            repeat: expr
            repeat-expr: 4
          - id: unknown2
            type: u1
            repeat: expr
            repeat-expr: 2
          - id: unknown3
            type: u4
  texture:
    seq:
      - id: name
        type: text
      - id: unknown1
        type: f4
        repeat: expr
        repeat-expr: 20
      - id: has_image
        type: u1
      - id: image
        type: image
        if: has_image != 0
    types:
      image:
        seq:
          - id: width
            type: u4
            doc: In pixels.
          - id: height
            type: u4
            doc: In pixels.
          - id: len_pixels
            type: u4
          - id: pixels
            size: len_pixels
            process: zlib
            doc: |
              `width * height` pixels of 3 bytes each (red, green, blue),
              without any padding of the rows.
  layout:
    seq:
      - id: unknown1
        type: f8
      - id: unknown2
        type: u1
      - id: unknown3
        type: f8
        repeat: expr
        repeat-expr: 4
      - id: num_parts
        type: u4
      - id: parts
        type: part
        repeat: expr
        repeat-expr: num_parts
      - id: num_labels
        type: u4
      - id: labels
        type: label
        repeat: expr
        repeat-expr: num_labels
        doc: Text rendered on the pages.
      - id: num_unknown4
        type: u4
      - id: unknown4
        type: blob
        repeat: expr
        repeat-expr: num_unknown4
      - id: num_unknown5
        type: u4
      - id: unknown5
        type: blob
        repeat: expr
        repeat-expr: num_unknown5
    types:
      part:
        seq:
          - id: unknown1
            type: u4
          - id: unknown2
            type: f8
            repeat: expr
            repeat-expr: 4
          - id: unknown3
            type: text
            if: _root.is_locked
          - id: num_lines
            type: u4
          - id: lines
            type: line
            repeat: expr
            repeat-expr: num_lines
      line:
        seq:
          - id: unknown1
            type: u1
          - id: unknown2
            type: u4
          - id: has_unknown3
            type: u1
          - id: unknown3
            type: u4
            repeat: expr
            repeat-expr: 2
            if: has_unknown3 != 0
          - id: has_unknown4
            type: u1
          - id: unknown4
            type: u4
            repeat: expr
            repeat-expr: 2
            if: has_unknown4 != 0
      label:
        seq:
          - id: unknown1
            type: f8
            repeat: expr
            repeat-expr: 5
          - id: unknown2
            type: u4
            repeat: expr
            repeat-expr: 2
          - id: font
            type: text
          - id: num_lines
            type: u4
          - id: lines
            type: text
            repeat: expr
            repeat-expr: num_lines
      blob:
        seq:
          - id: unknown1
            type: f8
            repeat: expr
            repeat-expr: 4
          - id: unknown2
            type: u4
            repeat: expr
            repeat-expr: 2
          - id: len_data
            type: u4
          - id: data
            size: len_data
            process: zlib
  rgb:
    seq:
      - id: red
        type: f4
      - id: green
        type: f4
      - id: blue
        type: f4
  vec2:
    seq:
      - id: x
        type: f8
      - id: y
        type: f8
  vec3:
    seq:
      - id: x
        type: f8
      - id: y
        type: f8
      - id: z
        type: f8
enums:
  lock_status:
    4: unlocked
    5: locked
