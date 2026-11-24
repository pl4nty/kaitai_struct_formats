meta:
  id: mario_builder_64_level
  title: Mario Builder 64 level
  application: Mario Builder 64
  file-extension: mb64
  license: CC0-1.0
  ks-version: '0.9'
  encoding: ASCII
  endian: be
doc: |
  Level file of Mario Builder 64, a Super Mario 64 ROM hack with a level
  editor that stores levels on the flash cart's SD card.

  The file is a raw dump of the game's in-memory structures as laid out by
  the N64 (big-endian MIPS) compiler: a fixed 12320-byte header
  (`struct mb64_level_save_header`, including its alignment padding),
  followed by `tile_count` 4-byte tiles and `object_count` 8-byte objects.
  Format versions 0 (1.0) and 1 (1.1) share this layout; they differ only in
  some tile and object ID numbering.
doc-ref:
  - https://github.com/arthurtilly/Mario-Builder-64/blob/9718a939e90dbc906b18a4bee6c51285e7bc32b1/src/mb64/file.h
  - https://github.com/arthurtilly/Mario-Builder-64/blob/9718a939e90dbc906b18a4bee6c51285e7bc32b1/src/mb64/file.c
  - https://github.com/arthurtilly/Mario-Builder-64/blob/9718a939e90dbc906b18a4bee6c51285e7bc32b1/src/mb64/compatibility.c
seq:
  - id: header
    size: 12320
    type: header
  - id: tiles
    type: tile
    repeat: expr
    repeat-expr: header.num_tiles
  - id: objects
    type: object
    repeat: expr
    repeat-expr: header.num_objects
types:
  header:
    -orig-id: mb64_level_save_header
    seq:
      - id: file_header
        size: 10
        type: strz
        doc: '"MB64-v1.1" in files written by version 1.1.'
      - id: version
        type: u1
        doc: 0 = 1.0, 1 = 1.1.
      - id: author
        size: 31
        type: strz
      - id: thumbnail
        size: 64 * 64 * 2
        doc: 64x64 thumbnail, RGBA5551 big-endian 16-bit pixels, row by row.
      - id: costume
        type: u1
      - id: seq
        size: 5
        doc: Music sequence selections.
      - id: envfx
        type: u1
      - id: theme
        type: u1
      - id: bg
        type: u1
      - id: boundary_mat
        type: u1
      - id: boundary
        type: u1
      - id: boundary_height
        type: u1
      - id: coinstar
        type: u1
      - id: size
        type: u1
      - id: waterlevel
        type: u1
      - id: secret
        type: u1
      - id: game
        type: u1
      - id: toolbar
        size: 9
      - id: toolbar_params
        size: 9
      - id: padding1
        size: 1
        doc: Alignment padding before `tile_count`.
      - id: num_tiles
        -orig-id: tile_count
        type: u2
      - id: num_objects
        -orig-id: object_count
        type: u2
      - id: custom_theme
        type: custom_theme
      - id: trajectories
        type: trajectory
        repeat: expr
        repeat-expr: 20
      - id: padding2
        size: 4
        doc: Alignment padding before the 64-bit `pad` field.
      - id: pad
        type: u8
  custom_theme:
    seq:
      - id: mats
        size: 10
      - id: topmats
        size: 10
      - id: topmats_enabled
        size: 10
      - id: fence
        type: u1
      - id: pole
        type: u1
      - id: bars
        type: u1
      - id: water
        type: u1
  trajectory:
    seq:
      - id: points
        type: trajectory_point
        repeat: expr
        repeat-expr: 50
  trajectory_point:
    -orig-id: mb64_comptraj
    seq:
      - id: t
        type: s1
      - id: x
        type: u1
      - id: y
        type: u1
      - id: z
        type: u1
  tile:
    -orig-id: mb64_tile
    doc: 32-bit bit field, allocated from the most significant bit.
    seq:
      - id: x
        type: b6
      - id: y
        type: b6
      - id: z
        type: b6
      - id: type
        type: b5
      - id: mat
        type: b4
      - id: rot
        type: b2
      - id: waterlogged
        type: b1
      - id: unused
        type: b2
  object:
    -orig-id: mb64_obj
    seq:
      - id: bparam
        type: u1
      - id: x
        type: u1
      - id: y
        type: u1
      - id: z
        type: u1
      - id: type
        type: u1
      - id: rot
        type: u1
      - id: imbue
        type: u1
      - id: pad
        type: u1
