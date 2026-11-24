# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/nw4r/vis0.ksy
meta:
  id: nw4r_vis0
  title: NW4R VIS0 bone/node visibility animation
  file-extension: vis0
  license: LicenseRef-All-Rights-Reserved
  imports:
    - /archive/nintendo/nw4r_brres_sub_header
  endian: be
doc: |
  Visibility animation: per named scene-graph node (matched by name against
  a sibling MDL0's bones or objects), stores either a constant
  visible/hidden flag or a bit per animation frame. BrawlBox/BrawlCrate call
  this `VIS0`; on Tockdom it is documented as the format behind effects like
  blinking eyes, toggled damage decals, and multi-costume models that swap
  visible parts in and out rather than changing geometry. Because each
  stored value is a single bit, a VIS0 entry's per-frame data is far more
  compact than CHR0/SRT0/CLR0 tracks -- it is a bitstream, not a float
  array.

  Only the fixed top-level header is modeled here.
seq:
  - id: header
    type: nw4r_brres_sub_header
  - id: ofs_data
    type: s4
    doc: Offset from the start of this VIS0 to the node-entry resource group.
  - id: ofs_name
    type: s4
    doc: |
      Offset from the start of this VIS0 to the animation's own name in the string
      pool.
  - id: ofs_orig_path
    type: s4
    doc: |
      Offset to the original MDL0 file path, as recorded by the exporting
      SDK tool.
  - id: n_frames
    type: u4
    doc: |
      Length of the animation in frames, not counting the extra loop frame `loop`
      implies.
  - id: loop
    type: u4
    doc: Non-zero if the animation loops back to frame 0 after `n_frames`.
  - id: ofs_user_data
    type: s4
    if: header.version == 4
    doc: |
      Offset to a trailing user-data resource group, only present from
      version 4 onward -- matching the same version gate CLR0 and CHR0
      use for their own `ofs_user_data` fields.
instances:
  name:
    pos: ofs_name - 4
    type: pooled_string
    if: ofs_name != 0
types:
  pooled_string:
    seq:
      - id: len_name
        type: u4
      - id: name
        size: len_name
        type: str
        encoding: UTF-8
