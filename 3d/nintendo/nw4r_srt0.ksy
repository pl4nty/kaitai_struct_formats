# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/nw4r/srt0.ksy
meta:
  id: nw4r_srt0
  title: NW4R SRT0 texture SRT animation
  file-extension: srt0
  license: LicenseRef-All-Rights-Reserved
  imports:
    - /archive/nintendo/nw4r_brres_sub_header
  endian: be
doc: |
  Texture SRT (Scale/Rotate/Translate) animation: animates the texture
  matrix of a material -- scale X/Y, rotation, translation X/Y per texture
  layer --. Known in BrawlBox/BrawlCrate and on Tockdom's Custom Mario Kart
  Wii Wiki as `SRT0`; it is what drives scrolling/rotating textures such as
  water, lava flows and UI marquees in Wii-era games. Each entry is named
  after a material of a sibling MDL0 and holds a bitmask of which of the 8
  ordinary + 3 indirect texture layers are animated -- a layer with no bit
  set keeps its material's static SRT values for the whole animation.

  Unlike CHR0, every animated channel always uses the I12 (raw float
  keyframe, no quantization) encoding, so there is no per-channel
  format-selector field: SRT0 tracks are small in number and low in key
  count compared to CHR0's per-bone channels, so the SDK did not bother
  with CHR0's quantized I4/I6/L1/L2 formats here.

  Only the fixed top-level header is modeled here.
seq:
  - id: header
    type: nw4r_brres_sub_header
  - id: ofs_data
    type: s4
    doc: Offset from the start of this SRT0 to the material-entry resource group.
  - id: ofs_name
    type: s4
    doc: |
      Offset from the start of this SRT0 to the animation's own name in the string
      pool.
  - id: ofs_orig_path
    type: s4
    doc: |
      Offset to the original MDL0 file path, as recorded by the exporting
      SDK tool.
  - id: n_frames
    type: u2
    doc: |
      Length of the animation in frames, not counting the extra loop frame `loop`
      implies.
  - id: n_entries
    type: u2
    doc: Number of animated material entries in the resource group below.
  - id: loop
    type: u4
    doc: Non-zero if the animation loops back to frame 0 after `n_frames`.
  - id: matrix_mode
    type: u4
    doc: |
      NW4R texture-matrix mode, mirroring the material's own
      `tex_matrix_mode`; governs how scale/rotation/translation combine
      into the final texture matrix (e.g. Maya-style vs. XSI-style
      composition order). Preserved verbatim from the source material.
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
