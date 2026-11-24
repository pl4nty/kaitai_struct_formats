meta:
  id: animated_cursor_windows
  title: Windows animated cursor (ANI)
  application: Microsoft Windows
  file-extension: ani
  xref:
    justsolve: ANI
  tags:
    - windows
  license: CC0-1.0
  ks-version: '0.9'
  encoding: ASCII
  endian: le
doc: |
  Animated cursor (and animated icon) format of Microsoft Windows. It is a RIFF
  file of form type `ACON` containing:

  * an `anih` chunk with the animation header;
  * an optional `rate` chunk with the display duration of each step;
  * an optional `seq ` chunk mapping each step to a frame;
  * a `LIST` chunk of type `fram` holding one `icon` chunk per frame, each
    containing a complete ICO or CUR file (when the icon flag is set in the
    header);
  * optionally a `LIST` chunk of type `INFO` with the title (`INAM`) and the
    author (`IART`) as null-terminated strings.

  Durations are given in jiffies (1/60 s). Winamp skins also use this format
  for their `.cur` files.
doc-ref:
  - https://github.com/wine-mirror/wine/blob/ff2631c6ed3d1721cd050d951671c307ade32b90/dlls/user32/cursoricon.c#L1000-L1239
  - https://github.com/captbaritone/webamp/blob/99a31e26f9dbbc4351a9df33179fd99f951eecb1/packages/ani-cursor/src/parser.ts
seq:
  - id: magic
    contents: RIFF
  - id: len_body
    type: u4
    doc: |
      Size of the RIFF body. Some files in the wild (e.g. from Winamp skins)
      wrongly store the size of the whole file here, so the body is limited
      to the end of the file.
  - id: body
    size: 'len_body <= _io.size - 8 ? len_body : _io.size - 8'
    type: acon_body
types:
  acon_body:
    seq:
      - id: form_type
        contents: ACON
      - id: chunks
        type: chunk
        repeat: eos
  chunk:
    seq:
      - id: id
        size: 4
        type: str
      - id: len_body
        type: u4
      - id: body
        size: len_body
        type:
          switch-on: id
          cases:
            '"anih"': ani_header
            '"rate"': u4_array
            '"seq "': u4_array
            '"LIST"': list_body
            '"INAM"': strz_body
            '"IART"': strz_body
      - id: padding
        size: len_body % 2
        if: not _io.eof
        doc: Chunks are padded to an even size.
  ani_header:
    -orig-id: ANIHEADER
    seq:
      - id: len_header
        -orig-id: cbSize
        type: u4
        doc: Size of this structure, 36.
      - id: num_frames
        -orig-id: nFrames
        type: u4
        doc: Number of frames stored in the `fram` list.
      - id: num_steps
        -orig-id: nSteps
        type: u4
        doc: Number of steps of the animation (entries in `rate` and `seq `).
      - id: width
        -orig-id: iWidth
        type: u4
      - id: height
        -orig-id: iHeight
        type: u4
      - id: bits_per_pixel
        -orig-id: iBitCount
        type: u4
      - id: num_planes
        -orig-id: nPlanes
        type: u4
      - id: display_rate
        -orig-id: iDispRate
        type: u4
        doc: |
          Default display duration of each step in jiffies (1/60 s), used when there is no
          `rate` chunk.
      - id: flags
        type: ani_flags
  ani_flags:
    meta:
      bit-endian: le
    seq:
      - id: is_icon
        type: b1
        doc: |
          AF_ICON: frames are complete ICO/CUR files; otherwise they are raw
          bitmap data (not supported by Wine).
      - id: has_sequence
        type: b1
        doc: 'AF_SEQUENCE: a `seq ` chunk defines the order of the frames.'
      - id: reserved
        type: b30
  u4_array:
    seq:
      - id: entries
        type: u4
        repeat: eos
  list_body:
    seq:
      - id: list_type
        size: 4
        type: str
        doc: '`fram` for the frame list, `INFO` for metadata.'
      - id: chunks
        type: chunk
        repeat: eos
  strz_body:
    seq:
      - id: value
        size-eos: true
        type: strz
