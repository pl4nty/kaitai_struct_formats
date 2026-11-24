# Imported from https://github.com/kenrinzero/palimpsest/blob/6d3d9a577e19ebd344da420ecda1aad594a5bc5c/formats/thp.ksy
# Frame chain model from https://github.com/quatric/Wii-Kaitai/blob/HEAD/media/thp.ksy
meta:
  id: thp
  title: Nintendo GameCube THP header and component table
  license: MIT
  endian: be
doc: |
  Nintendo GameCube THP container — header unit.

  Layout (FFmpeg 6.1.1 libavformat/thp.c):

  * 48-byte file header (magic, version, buffer/sample maxima,
    fps float, frame count, frame/data offsets)
  * component table at `component_data_offset`: count, 16-byte
    type list, then one record per listed component
  * video (type 0): width, height; version 0x11000 adds a pad u32
  * audio (type 1): channels, sample rate, sample count
  * frames from `first_frame_offset`, walked as a linked chain from
    `first_frame` (see `frame`); video and audio payloads are kept raw

  This unit requires one video and one audio component.

  Proven against ffprobe 6.1.1-3ubuntu5 on FATE
  `thp/pikmin2-opening1-partial.thp` (608×320 thp + adpcm_thp
  32000 Hz/2 ch, 6500 declared frames).  Gallery: **net-new**.
  Independence: **third-party**.

seq:
  - id: magic
    contents: [0x54, 0x48, 0x50, 0x00]
    doc: THP signature ("THP" + NUL).
  - id: version
    type: u4
    doc: Container version.  0x00011000 adds a u32 after video geometry.
  - id: max_buffer_size
    type: u4
    doc: Maximum per-frame buffer size.
  - id: max_audio_samples
    type: u4
    doc: Maximum audio samples per frame.
  - id: fps
    type: f4
    valid:
      expr: _ > 0.1 and _ < 1000.0
    doc: Frames per second as IEEE-754 float (FFmpeg reduces it via av_d2q).
  - id: num_frames
    type: u4
    valid:
      min: 1
    doc: Declared video frame count (ffprobe nb_frames, not duration_ts).
  - id: first_frame_size
    type: u4
    valid:
      min: 1
    doc: Size of the first frame record.
  - id: movie_data_size
    type: u4
    doc: Declared movie data size.  Lies on truncated FATE partials.
  - id: component_data_offset
    type: u4
    valid:
      min: 48
    doc: Absolute file offset of the component table.
  - id: offsets_data_offset
    type: u4
    doc: Offset table pointer (0 when unused).
  - id: first_frame_offset
    type: u4
    valid:
      min: 48
    doc: Absolute file offset of the first frame.
  - id: last_frame_offset
    type: u4
    doc: Absolute file offset of the last frame.

instances:
  component_table:
    pos: component_data_offset
    type: component_table
    doc: Component count, type list, and per-component records.
  width:
    value: >
      component_table.components[0].is_video ?
        component_table.components[0].width :
        component_table.components[1].width
    doc: Frame width from the video component.
  height:
    value: >
      component_table.components[0].is_video ?
        component_table.components[0].height :
        component_table.components[1].height
    doc: Frame height from the video component.
  audio_sample_rate:
    value: >
      component_table.components[0].is_audio ?
        component_table.components[0].sample_rate :
        component_table.components[1].sample_rate
    doc: Audio sample rate from the audio component.
  audio_channels:
    value: >
      component_table.components[0].is_audio ?
        component_table.components[0].channels :
        component_table.components[1].channels
    doc: Audio channel count from the audio component.
  audio_num_samples:
    value: >
      component_table.components[0].is_audio ?
        component_table.components[0].num_samples :
        component_table.components[1].num_samples
    doc: Declared audio sample count (ffprobe audio duration_ts).
  walked_component_count:
    value: component_table.components.size
    doc: Number of component records actually walked.
  first_frame:
    pos: first_frame_offset
    type: frame(first_frame_offset, first_frame_size, 0)
    doc: |
      First frame. Follow `next` (bounded by `num_frames`) to reach the
      later frames.
  codec_label:
    value: '"thp"'
    doc: ffprobe video codec_name.  THP video has no fourcc.
  audio_codec_label:
    value: '"adpcm_thp"'
    doc: ffprobe audio codec_name.  THP audio is always ADPCM THP.

types:
  component_table:
    seq:
      - id: num_components
        type: u4
        valid:
          eq: 2
        doc: Number of components that follow the 16-byte type list.
      - id: component_types
        type: u1
        repeat: expr
        repeat-expr: 16
        doc: Type bytes.  0 = video, 1 = audio; remaining slots are 0xFF.
      - id: av_pair
        size: 0
        valid:
          expr: >
            (component_types[0] == 0 and component_types[1] == 1) or
            (component_types[0] == 1 and component_types[1] == 0)
        doc: This unit requires one video and one audio component.
      - id: components
        type: component(component_types[_index])
        repeat: expr
        repeat-expr: num_components
        doc: Per-component records in type-list order.
    instances:
      has_audio:
        value: component_types[0] == 1 or component_types[1] == 1

  component:
    params:
      - id: kind
        type: u1
    seq:
      - id: width
        type: u4
        valid:
          min: 1
        if: is_video
        doc: Frame width in pixels.
      - id: height
        type: u4
        valid:
          min: 1
        if: is_video
        doc: Frame height in pixels.
      - id: version_pad
        type: u4
        if: is_video and _root.version == 0x11000
        doc: Extra word present only on version 0x11000 (skipped by FFmpeg).
      - id: channels
        type: u4
        valid:
          min: 1
        if: is_audio
        doc: Audio channel count.
      - id: sample_rate
        type: u4
        valid:
          min: 1
        if: is_audio
        doc: Audio sample rate in Hz.
      - id: num_samples
        type: u4
        valid:
          min: 1
        if: is_audio
        doc: Declared audio sample count.
    instances:
      is_video:
        value: kind == 0
      is_audio:
        value: kind == 1

  frame:
    doc: |
      Frame header, followed by the video payload and, if there is an
      audio component, the audio payload. A frame's own header does not
      give its total size: the size of frame 0 is the file header's
      `first_frame_size`, and every frame's `next_frame_size` gives the
      size of the frame after it, so frame k+1 starts at frame k's start
      plus that size (FFmpeg libavformat/thp.c). The chain is therefore
      modelled as a linked list through `next`.
    params:
      - id: ofs_frame
        type: u4
        doc: Absolute file offset of this frame.
      - id: len_frame
        type: u4
        doc: Size of this frame, as given by the previous frame (or header).
      - id: idx
        type: u4
        doc: Zero-based frame number.
    seq:
      - id: next_frame_size
        type: u4
        doc: Total size of the next frame.
      - id: prev_frame_size
        type: u4
        doc: Total size of the previous frame.
      - id: len_video
        type: u4
        doc: Size of the video payload.
      - id: len_audio
        type: u4
        if: _root.component_table.has_audio
        doc: Size of the audio payload.
      - id: video
        size: len_video
      - id: audio
        size: len_audio
        if: _root.component_table.has_audio
    instances:
      next:
        pos: ofs_frame + len_frame
        type: frame(ofs_frame + len_frame, next_frame_size, idx + 1)
        if: idx + 1 < _root.num_frames
