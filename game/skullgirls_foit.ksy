# Imported from https://github.com/bodriodroid/ZGIRLSLOADER/blob/2035368a217a6d66e9b6eb5a637cd75f6fe94f7e/docs/foit.ksy
# Licence and copyright: see _community/README.md
meta:
  id: skullgirls_foit
  title: Skullgirls character file (.foit, format version 9)
  file-extension: foit
  license: MIT
  encoding: UTF-8
  endian: le
doc: |
  Kaitai Struct description of the character file of the PC build of Skullgirls
  (`<char>.foit`, "VRSN" 9),
  written for ZGirls Loader.  It describes the *layout only* (what is stored
  where); it contains no game data.

  The description is generated from static analysis of the user's own files.  It
  is checked against all
  `.foit` files of the PC build: every file is consumed to the last byte and the
  counts (states, children,
  frames, transitions) agree with the hand written reader in `src/core/foit.cpp`
  (see `tools/validate_foit_ksy.py`).

  A file is
    * a 13 byte header (offset of the body, "VRSN", version, flags),
    * a "preamble" up to the body: the move list (name + input command + the
      states that implement it),
      the palette file names and the size of the .art / .art-pt next to the file
      (only when flags bit 3 is set),
    * the character body: an *object*.  An object = slot defaults, optional layer
      (palette) object, optional frame
      list, the state machine and, recursively, child objects (projectiles /
      effects) that share the frame list.

  Conventions used in the names:
    * frame ids stored in node `refs` are 1-based (0 = none); the frame list
      itself is 0-based.
    * state ids (`state.next`, `transition.target`) are 0-based indices into the
      object's state list.
    * a "script chain" is the little slot VM of the game: `C := op(A, B)`; see
      `operand`.
    * `f<hex>` field names are named after the offset of the value inside the
      runtime structure the game fills; their
      meaning is not known (yet).

seq:
  - id: body_offset
    type: u4
    doc: |
      Absolute offset of the body.  Everything between the header and this offset is
      the preamble.
  - id: magic
    contents: 'VRSN'
  - id: version
    type: u4
    valid: 9
  - id: flags
    type: u1
    doc: |
      bit 0: character file (loadable), bit 1: (set in every playable character), bit
      3: has a preamble.
  - id: preamble
    size: body_offset - 13
    type: preamble
    if: body_offset > 13
  - id: body
    type: object

types:
  # ------------------------------------------------------------------------------------------------------------
  # preamble
  # ------------------------------------------------------------------------------------------------------------
  preamble:
    doc: |
      Index data the game reads without parsing the whole body.  Absent (zero length)
      in effect files such as the
      hit spark.  The first group (moves) is present only when `flags & 8`; every file
      seen sets it or has no preamble.
    seq:
      - id: num_moves
        type: u2
      - id: moves
        type: move
        repeat: expr
        repeat-expr: num_moves
      - id: num_extra_states
        type: u2
      - id: extra_states
        type: u2
        repeat: expr
        repeat-expr: num_extra_states
        doc: State ids (the intro / special states listed after the moves).
      - id: size0
        type: u4
        doc: Unknown size / count.
      - id: size1
        type: u4
        doc: Unknown size / count.
      - id: art_size
        type: u4
        doc: Byte size of `<char>.art`.
      - id: art_pt_size
        type: u4
        doc: |
          Byte size of the used part of `<char>.art-pt` (the file on disk may be padded a
          little).
      - id: size4
        type: u4
        doc: Unknown size / count.
      - id: num_palettes
        type: u2
      - id: palette_files
        type: pstr
        repeat: expr
        repeat-expr: num_palettes
        doc: |
          Palette file names (`<char>_<n>p.pal`), one per palette (colour variant) stored
          in the layer object.
      - id: num_palette_words
        type: u2
      - id: palette_words
        type: u4
        repeat: expr
        repeat-expr: num_palette_words
        doc: |
          One word per palette (zero in all files but a couple of palettes of two
          characters).

  move:
    doc: One entry of the character's move list.
    seq:
      - id: name
        type: pstr
      - id: command
        type: command
        doc: The input that starts the move.
      - id: kind
        type: u1
        doc: 1 or 2 mark the entries the game looks up directly (0 = ordinary).
      - id: f30
        type: u2
      - id: num_states
        type: u2
      - id: states
        type: u2
        repeat: expr
        repeat-expr: num_states
        doc: State ids that make up the move (in the order of the move's phases).

  pstr:
    doc: A string with a one byte length prefix.
    seq:
      - id: len
        type: u1
      - id: value
        size: len
        type: str
        encoding: ISO-8859-1

  # ------------------------------------------------------------------------------------------------------------
  # object (character body or child)
  # ------------------------------------------------------------------------------------------------------------
  object:
    doc: |
      The character itself or one of its children (projectiles, effects).  Children
      never own a layer object or a
      frame list (`has_layer == 0`, `has_frames == 0`): they index into the
      character's frame list.
    seq:
      - id: name
        type: pstr
      - id: v374
        type: u4
        doc: Object class / flags (stored at runtime offset 0x374).
      - id: has_layer
        type: u1
      - id: layer
        type: layer_object
        if: has_layer != 0
      - id: tail
        type: slot_table
      - id: has_frames
        type: u1
        doc: 1 = this object owns the frame list (the character), 0 = it uses the parent's.
      - id: frame_list
        type: frame_list
        if: has_frames != 0
      - id: states
        type: states
      - id: ref_be
        type: u2
        doc: |
          Frame ids (1-based, 0 = none) the object shows in two special situations
          (runtime offsets 0xbe / 0xbf / 0xc0).
      - id: ref_bf
        type: u2
      - id: has_ref_c0
        type: u1
      - id: ref_c0
        type: u2
        if: has_ref_c0 != 0
      - id: flags_dc
        type: u1
      - id: x373
        type: u1
      - id: box_top
        type: s4
        doc: Default push box (top, bottom, left, right), y grows downwards.
      - id: box_bottom
        type: s4
      - id: box_left
        type: s4
      - id: box_right
        type: s4
      - id: num_children
        type: u4
      - id: children
        type: child
        repeat: expr
        repeat-expr: num_children
      - id: state_names
        type: state_names(states.num_states)

  child:
    doc: |
      A child object is stored as a complete small "file": the same 13 byte header,
      then the object right behind it
      (`body_offset` is always the position right after the header).
    seq:
      - id: body_offset
        type: u4
      - id: magic
        contents: 'VRSN'
      - id: version
        type: u4
        valid: 9
      - id: flags
        type: u1
      - id: body
        type: object

  state_names:
    params:
      - id: num_states
        type: u2
    seq:
      - id: names
        type: pstr
        repeat: expr
        repeat-expr: num_states
        doc: One name per state, in state order (stored after everything else).

  slot_table:
    doc: |
      Slot defaults of the object: 177 float "slots" (see `src/core/foit_names.h` for
      their names) plus up to three
      optional script chains.
    seq:
      - id: num_list8
        type: u1
      - id: list8
        type: list8_entry
        repeat: expr
        repeat-expr: num_list8
      - id: slot_defaults
        type: f4
        repeat: expr
        repeat-expr: 177
        doc: Initial value of every slot when the object is created / reset.
      - id: chain_flags
        type: u1
        doc: bit k set = chain k is present.
      - id: chain0
        type: chain
        if: (chain_flags & 1) != 0
      - id: chain1
        type: chain
        if: (chain_flags & 2) != 0
      - id: chain2
        type: chain
        if: (chain_flags & 4) != 0

  list8_entry:
    seq:
      - id: a
        type: u4
      - id: b
        type: u1

  # ------------------------------------------------------------------------------------------------------------
  # script chains
  # ------------------------------------------------------------------------------------------------------------
  chain:
    doc: A list of chain nodes; every node says whether another one follows.
    seq:
      - id: nodes
        type: chain_node
        repeat: until
        repeat-until: not _.has_next

  chain_node:
    doc: |
      `C := op(A, B)` (arithmetic) or, when `is_boolean`, a comparison of A and B that
      gates the rest of the chain.
    seq:
      - id: desc_a
        type: u1
      - id: desc_b
        type: u1
      - id: desc_c
        type: u1
      - id: flags
        type: u1
        doc: bit 0 = boolean node, bit 1 = another node follows.
      - id: op
        type: u1
      - id: a
        type: operand(desc_a)
      - id: b
        type: operand(desc_b)
      - id: c
        type: operand(desc_c)
    instances:
      is_boolean:
        value: (flags & 1) != 0
      has_next:
        value: (flags & 2) != 0

  operand:
    doc: |
      `desc` bit 0: the value is a slot id (one byte), otherwise four bytes (float
      bits of a literal, or the
      range of a random number when bit 2 is set).  Bit 1: slot of the global table.
      Bit 5: a bit of the flag words.
      0x08 / 0x10 / 0x40 / 0x80 select whose object is addressed (self, enemy, target,
      attacker, parent ...).
    params:
      - id: desc
        type: u1
    seq:
      - id: slot
        type: u1
        if: (desc & 1) != 0
      - id: literal_bits
        type: u4
        if: (desc & 1) == 0
        doc: |
          Float bits (`struct.unpack('<f', ...)`) unless the operand is a random number
          (desc bit 2).
    instances:
      is_slot:
        value: (desc & 1) != 0
      is_global:
        value: (desc & 2) != 0
      is_random:
        value: (desc & 4) != 0

  script_text:
    doc: |
      The source text a chain was compiled from (e.g. `Flag27=0`,
      `StateNum:HasTag:"Super"`), kept in the file for
      the tools; the game skips it.
    seq:
      - id: len
        type: u4
      - id: text
        size: len
        type: str
        encoding: ISO-8859-1

  # ------------------------------------------------------------------------------------------------------------
  # commands (input sequences / conditions)
  # ------------------------------------------------------------------------------------------------------------
  command:
    seq:
      - id: a
        type: u2
        doc: Total window of the command, in ticks.
      - id: b
        type: u2
      - id: num_steps
        type: u2
      - id: flags
        type: u1
        doc: bit 1 = a default step precedes the list.
      - id: default_step
        type: step
        if: (flags & 2) != 0
      - id: steps
        type: step
        repeat: expr
        repeat-expr: num_steps
        doc: Stored newest first (the last direction / button of the motion comes first).

  step:
    seq:
      - id: dir0
        type: u1
        doc: Acceptable directions (0..8 = F DF D DB B UB U UF ?; 9 = any, 10 = none).
      - id: dir1
        type: u1
      - id: dir2
        type: u1
      - id: window
        type: u2
      - id: flags
        type: u1
        doc: bit 1 = a condition chain follows.
      - id: condition
        type: chain
        if: (flags & 2) != 0
      - id: buttons
        type: u1
        repeat: expr
        repeat-expr: 15
        doc: Requirement per button / direction token (10 = don't care).

  # ------------------------------------------------------------------------------------------------------------
  # states
  # ------------------------------------------------------------------------------------------------------------
  states:
    seq:
      - id: flag_x
        type: u1
      - id: num_states
        type: u2
      - id: states
        type: state
        repeat: expr
        repeat-expr: num_states

  state:
    seq:
      - id: f
        type: u1
        doc: bit 1 = name hashes follow, bit 2 / bit 3 = a u32 value follows.
      - id: v18
        type: u4
        if: (f & 4) != 0 or (f & 8) != 0
      - id: b14
        type: u1
      - id: num_hashes
        type: u1
        if: (f & 2) != 0
      - id: hashes
        type: u4
        repeat: expr
        repeat-expr: 'num_hashes.as<u1>'
        if: (f & 2) != 0
      - id: num_transitions
        type: u2
      - id: next
        type: u2
        doc: State entered when the node list ends (0-based).
      - id: header
        type: state_header
      - id: transitions
        type: transition
        repeat: expr
        repeat-expr: num_transitions
        doc: Evaluated in table order (= priority).

  transition:
    seq:
      - id: target
        type: u2
      - id: command
        type: command

  state_header:
    seq:
      - id: num_nodes
        type: u2
      - id: nodes
        type: node
        repeat: expr
        repeat-expr: num_nodes
      - id: has_command
        type: u1
      - id: command
        type: command
        if: has_command != 0
      - id: command_props
        type: node_props_list
        if: has_command != 0
      - id: has_chain
        type: u1
      - id: chain
        type: chain
        if: has_chain != 0
        doc: Header script (initial slot values of the state, e.g. the walk speed).

  node:
    doc: |
      One timeline entry.  Without frame refs it is a script node (init, loop label,
      reset).
    seq:
      - id: ref0
        type: u2
      - id: ref1
        type: u2
        doc: The body frame (1-based, 0 = none).
      - id: ref2
        type: u2
      - id: props
        type: node_props_list

  node_props_list:
    seq:
      - id: items
        type: node_props
        repeat: until
        repeat-until: _.f3 == 0

  node_props:
    seq:
      - id: b1
        type: u1
        doc: bit 0 = a 16 bit duration follows (otherwise the duration is 1 tick).
      - id: b2
        type: u1
      - id: b3
        type: u1
        doc: bit 7 = a chain follows, bit 6 = a byte (x1a) follows.
      - id: chain
        type: chain
        if: (b3 & 0x80) != 0
      - id: duration
        type: u2
        if: (b1 & 1) != 0
      - id: x1a
        type: u1
        if: (b3 & 0x40) != 0
      - id: f2
        type: u1
        doc: bit 0 = hit data, bit 1 = sub list, bit 2 = u32 list.
      - id: hit
        type: hit_data
        if: (f2 & 1) != 0
      - id: sub
        type: sub_list
        if: (f2 & 2) != 0
      - id: num_u32s
        type: u1
        if: (f2 & 4) != 0
      - id: u32s
        type: u4
        repeat: expr
        repeat-expr: 'num_u32s.as<u1>'
        if: (f2 & 4) != 0
      - id: f3
        type: u1
        doc: 'Not zero: a command header and another record follow.'
      - id: command
        type: command
        if: f3 != 0

  hit_data:
    seq:
      - id: f8
        type: u2
      - id: f4
        type: u4
      - id: f13
        type: u1
      - id: fc
        type: u2
      - id: fe
        type: u2
      - id: f18
        type: u1
      - id: f2c
        type: u4
      - id: f10
        type: u2
      - id: f12
        type: u1
      - id: f0
        type: u4
      - id: f14
        type: u1
      - id: f15
        type: u1
      - id: f16
        type: u1
      - id: f17
        type: u1
      - id: fa
        type: u1
        doc: bits 0..3 = chain k present, bit 4 = f0a present.
      - id: fb
        type: u1
      - id: chain0
        type: chain
        if: (fa & 1) != 0
      - id: chain1
        type: chain
        if: (fa & 2) != 0
      - id: chain2
        type: chain
        if: (fa & 4) != 0
      - id: chain3
        type: chain
        if: (fa & 8) != 0
      - id: f0a
        type: u2
        if: (fa & 0x10) != 0

  sub_list:
    doc: Child spawns / sub actions attached to a node.
    seq:
      - id: items
        type: sub_item
        repeat: until
        repeat-until: _.has_next == 0

  sub_item:
    seq:
      - id: a
        type: u2
      - id: b
        type: u4
      - id: c
        type: u4
      - id: flags
        type: u1
        doc: bit 1 = a chain follows.
      - id: chain
        type: chain
        if: (flags & 2) != 0
      - id: has_next
        type: u1

  # ------------------------------------------------------------------------------------------------------------
  # frames
  # ------------------------------------------------------------------------------------------------------------
  frame_list:
    seq:
      - id: num_frames
        type: u4
      - id: frames
        type: frame
        repeat: expr
        repeat-expr: num_frames

  frame:
    seq:
      - id: pivot_x
        type: s4
        doc: Canvas coordinates of the point the character stands on.
      - id: pivot_y
        type: s4
      - id: src
        type: u1
        doc: 5 = pixels in `<char>.art`, 4 = `<char>.art-pt`, 0 = no image.
      - id: num_entries
        type: u1
      - id: entries
        type: frame_entry
        repeat: expr
        repeat-expr: num_entries
      - id: slot_mask
        type: u1
        doc: bit k = image slot k is stored.
      - id: image0
        type: image
        if: (slot_mask & 0x01) != 0
      - id: image1
        type: image
        if: (slot_mask & 0x02) != 0
      - id: image2
        type: image
        if: (slot_mask & 0x04) != 0
      - id: image3
        type: image
        if: (slot_mask & 0x08) != 0
      - id: image4
        type: image
        if: (slot_mask & 0x10) != 0
      - id: image5
        type: image
        if: (slot_mask & 0x20) != 0
      - id: image6
        type: image
        if: (slot_mask & 0x40) != 0
      - id: image7
        type: image
        if: (slot_mask & 0x80) != 0
      - id: xy
        type: s4
        repeat: expr
        repeat-expr: 10
        doc: |
          Five (x, y) pairs: the top-left corner (canvas coordinates) of the images of
          slot 0/1, 2/3, 4/5, 6 and 7;
          an image is drawn at `xy - pivot`.
      - id: hit_boxes
        type: box_list
      - id: hurt_boxes
        type: box_list
      - id: push_boxes
        type: box_list

  frame_entry:
    seq:
      - id: a
        type: u4
      - id: b
        type: u4
      - id: c
        type: u4

  image:
    doc: |
      An image of 16x16 pixel cells.  The pixel planes are RLE coded: either stored
      here (`inline`) or in the .art /
      .art-pt at `art_offset` (`external`).
    seq:
      - id: cells
        type: u2
        doc: '`w * h`'
      - id: w
        type: u2
      - id: h
        type: u2
      - id: num_stored
        type: u2
        doc: Number of cells that are stored (the others are transparent).
      - id: flags
        type: u1
        doc: |
          bit 2 = 8 extra bytes, bit 4 = pixel data present, bit 5 = external, bit 6 =
          odd-row interpolation, bit 7 = silhouette.
      - id: extra
        type: u8
        if: (flags & 4) != 0
      - id: mask
        size: (cells + 7) / 8
        if: (flags & 0x10) != 0
        doc: Bit j (LSB first, row-major) = cell j is stored.
      - id: art_offset
        type: u4
        if: (flags & 0x10) != 0 and (flags & 0x20) != 0
      - id: art_sizes
        type: u4
        repeat: expr
        repeat-expr: 3
        if: (flags & 0x10) != 0 and (flags & 0x20) != 0
        doc: Compressed sizes of the normal / gradient / band planes.
      - id: planes
        type: inline_plane
        repeat: expr
        repeat-expr: 3
        if: (flags & 0x10) != 0 and (flags & 0x20) == 0

  inline_plane:
    seq:
      - id: len
        type: u4
      - id: data
        size: len

  box_list:
    seq:
      - id: num_boxes
        type: u2
      - id: boxes
        type: box
        repeat: expr
        repeat-expr: num_boxes

  box:
    doc: Relative to the pivot, y grows downwards.
    seq:
      - id: top
        type: s4
      - id: bottom
        type: s4
      - id: left
        type: s4
      - id: right
        type: s4

  # ------------------------------------------------------------------------------------------------------------
  # layer object: the palettes
  # ------------------------------------------------------------------------------------------------------------
  layer_object:
    doc: |
      The colour palettes of the character.  `groups` names the colour groups ("hair",
      "skin/hands", "eyes", ...);
      `layers` holds one palette per colour variant (the `<char>_<n>p.pal` of the
      preamble): `total_colors` ARGB
      values, laid out group after group, followed by per-palette scripted rules.
    seq:
      - id: num_layers
        type: u2
      - id: num_groups
        type: u1
      - id: first_group
        type: group(num_groups, 0)
        if: num_groups > 0
      - id: num_ranges
        type: u1
      - id: ranges
        type: group_range
        repeat: expr
        repeat-expr: num_ranges
        doc: Index of the last colour of each group (derived data, stored in the file too).
      - id: layers
        type: layer(total_colors)
        repeat: expr
        repeat-expr: num_layers
    instances:
      total_colors:
        value: 'num_groups > 0 ? first_group.total : 0'

  group:
    doc: |
      One colour group.  Groups are chained recursively only so that the total number
      of colours (the sum of
      `count`) is available to the palettes (Kaitai has no array sum).
    params:
      - id: remaining
        type: u4
      - id: before
        type: u4
    seq:
      - id: count
        type: u1
        doc: Number of colours (shades) of the group.
      - id: flag_a
        type: u1
      - id: flag_b
        type: u1
      - id: name
        type: pstr
      - id: next
        type: group(remaining - 1, before + count)
        if: remaining > 1
    instances:
      total:
        value: 'remaining > 1 ? next.total.as<u4> : before + count'

  group_range:
    seq:
      - id: last_index
        type: u4
      - id: group_index
        type: u4

  layer:
    doc: One palette.
    params:
      - id: total_colors
        type: u4
    seq:
      - id: colors
        type: u4
        repeat: expr
        repeat-expr: total_colors
        doc: ARGB colours, stored as the bytes B, G, R, A.
      - id: pair0
        type: u4
      - id: pair1
        type: u4
        doc: Two more colours of the palette (outline / highlight).
      - id: flag_a
        type: u1
      - id: flag_b
        type: u1
      - id: num_bytes
        type: u1
      - id: bytes
        type: u1
        repeat: expr
        repeat-expr: num_bytes
      - id: num_rules
        type: u1
      - id: rules
        type: layer_rule
        repeat: expr
        repeat-expr: num_rules
      - id: num_pieces
        type: u1
      - id: pieces
        type: layer_piece
        repeat: expr
        repeat-expr: num_pieces
      - id: u0
        type: u4
      - id: num_n5
        type: u1
      - id: n5
        type: layer_scripted_value
        repeat: expr
        repeat-expr: num_n5
      - id: num_ids
        type: u1
      - id: ids
        type: u2
        repeat: expr
        repeat-expr: num_ids
        doc: Colour indices (u16) the palette treats specially (e.g. 183, 186, 189, ...).
      - id: num_n7
        type: u1
      - id: n7
        type: layer_script_pair
        repeat: expr
        repeat-expr: num_n7

  layer_rule:
    doc: A colour index pair with an optional condition script.
    seq:
      - id: a
        type: u4
      - id: b
        type: u4
      - id: c
        type: u1
      - id: has_script
        type: u1
      - id: script
        type: chain
        if: has_script != 0
      - id: script_text
        type: script_text
        if: has_script != 0
      - id: script_ok
        type: u1
        if: has_script != 0

  layer_piece:
    doc: |
      A named value of the palette ("Space", "Origin", "TextureCenter", ...) with an
      optional script.
    seq:
      - id: name_len
        type: u4
      - id: name
        size: name_len
        type: str
        encoding: ISO-8859-1
      - id: hash
        type: u4
        doc: Hash of the name (djb2).
      - id: num_data
        type: u1
      - id: data
        type: u1
        repeat: expr
        repeat-expr: num_data
        doc: Short ASCII payload (e.g. the digit `1`).
      - id: x2c
        type: u1
      - id: x2d
        type: u1
      - id: x54
        size: 4
      - id: x2e
        type: u1
      - id: x30
        type: u4
      - id: x34
        type: u4
      - id: x50
        type: u4
      - id: note
        type: script_text
        doc: Text only the tools use (empty or the name of the anchor, e.g. `Origin`).
      - id: has_script
        type: u1
      - id: script
        type: chain
        if: has_script != 0
      - id: script_text
        type: script_text
        if: has_script != 0
      - id: script_ok
        type: u1
        if: has_script != 0

  layer_scripted_value:
    seq:
      - id: value
        type: u4
      - id: script
        type: chain
      - id: script_text
        type: script_text
      - id: script_ok
        type: u1

  layer_script_pair:
    seq:
      - id: a
        type: u4
      - id: b
        type: u4
      - id: script
        type: chain
      - id: script_text
        type: script_text
