meta:
  id: arcanum_art
  title: "Arcanum: Of Steamworks and Magick Obscura graphics"
  file-extension: art
  license: LicenseRef-All-Rights-Reserved
  endian: le
  bit-endian: le
doc: |
  Images and animations of the role-playing game Arcanum.

  An image has up to 4 palettes of 256 colours and one or more animation
  frames, either in a single view or in 8 rotations. The pixels of a frame
  are palette indices. If `len_data` of the frame is not `width * height`,
  they are run-length encoded: a control byte with the highest bit set is
  followed by as many literal pixels as its low 7 bits say, a control byte
  with the bit clear by one pixel to repeat that many times.
doc-ref:
  - https://web.archive.org/web/20160913191941/http://arcanum.game-alive.com/forums/viewtopic.php?f=6&t=53&sid=3758668148aa5a568036d9d589202176
  - https://github.com/alexbatalov/tig/blob/main/src/art.c
seq:
  - id: header
    type: header
  - id: palettes
    type: palette
    repeat: expr
    repeat-expr: header.num_palettes
  - id: frame_headers
    type: frame_header
    repeat: expr
    repeat-expr: num_frames_total
    doc: All frames of the first rotation, then those of the second etc.
  - id: frame_data
    size: frame_headers[_index].len_data
    repeat: expr
    repeat-expr: num_frames_total
    doc: Pixels of the frames, in the order of `frame_headers`.
instances:
  num_rotations:
    value: 'header.flags.is_static ? 1 : 8'
  num_frames_total:
    value: num_rotations * header.num_frames
types:
  header:
    seq:
      - id: flags
        size: 4
        type: flags
      - id: frame_rate
        type: u4
        doc: In frames per second.
      - id: bits_per_pixel
        type: u4
        doc: Always 8.
      - id: palette_ids
        type: u4
        repeat: expr
        repeat-expr: 4
        doc: A non-zero entry means that the palette is present in the file.
      - id: action_frame
        type: u4
      - id: num_frames
        type: u4
        doc: Number of frames per rotation.
      - id: info_list
        type: u4
        repeat: expr
        repeat-expr: 8
        doc: Ignored by the game when it reads the file.
      - id: size_list
        type: u4
        repeat: expr
        repeat-expr: 8
        doc: Size of the pixel data of every rotation.
      - id: data_list
        type: u4
        repeat: expr
        repeat-expr: 8
        doc: Ignored by the game when it reads the file.
    instances:
      num_palettes:
        value: >-
          (palette_ids[0] != 0 ? 1 : 0) +
          (palette_ids[1] != 0 ? 1 : 0) +
          (palette_ids[2] != 0 ? 1 : 0) +
          (palette_ids[3] != 0 ? 1 : 0)
  flags:
    seq:
      - id: is_static
        type: b1
        doc: The image has a single rotation instead of 8.
      - id: is_critter
        type: b1
      - id: is_font
        type: b1
      - id: is_facade
        type: b1
  palette:
    seq:
      - id: colors
        type: color
        repeat: expr
        repeat-expr: 256
  color:
    seq:
      - id: blue
        type: u1
      - id: green
        type: u1
      - id: red
        type: u1
      - id: reserved
        type: u1
  frame_header:
    seq:
      - id: width
        type: u4
      - id: height
        type: u4
      - id: len_data
        type: u4
      - id: hot_x
        type: s4
      - id: hot_y
        type: s4
      - id: offset_x
        type: s4
      - id: offset_y
        type: s4
