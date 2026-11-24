meta:
  id: openal_hrir
  title: OpenAL Soft HRTF data set (MHR)
  application: OpenAL Soft
  file-extension: mhr
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Head-related transfer function (HRTF) data set used by OpenAL Soft for
  binaural rendering over headphones. The file stores minimum-phase head-related
  impulse responses (HRIRs) for a grid of directions, grouped into one or more
  fields (distances), each having a number of elevations (from -90 degrees
  upwards), each having a number of azimuths (clockwise from the front, forming
  a full circle). Each HRIR is accompanied by a propagation delay.

  Four versions exist, identified by the magic: `MinPHR00` and `MinPHR01`
  (16-bit coefficients, left ear only, a single field), `MinPHR02` (multiple
  fields stored nearest first, 16- or 24-bit coefficients, optionally stereo)
  and `MinPHR03` (multiple fields stored farthest first, always 24-bit
  coefficients, optionally stereo). For left-only data sets, the right ear
  responses are obtained by mirroring the azimuths.

  This spec parses the whole file. HRIRs are listed in file order: fields in
  stored order, then elevations from the bottom up, then azimuths.
doc-ref:
  - https://github.com/kcat/openal-soft/blob/7691c238c8b80a223c27cabc99fd02e6a542217e/docs/hrtf.txt
  - https://github.com/kcat/openal-soft/blob/7691c238c8b80a223c27cabc99fd02e6a542217e/core/hrtf_loader.cpp
seq:
  - id: magic
    size: 8
    type: str
    encoding: ASCII
    valid:
      any-of:
        - '"MinPHR00"'
        - '"MinPHR01"'
        - '"MinPHR02"'
        - '"MinPHR03"'
  - id: sample_rate
    type: u4
    doc: Sample rate the data set is designed for, in Hz.
  - id: num_hrirs_v0
    type: u2
    if: version == 0
  - id: hrir_size_v0
    type: u2
    if: version == 0
  - id: sample_type_v2
    type: u1
    enum: sample_type
    if: version == 2
  - id: channel_type
    type: u1
    enum: channel_type
    if: version >= 2
  - id: hrir_size_v1
    type: u1
    if: version >= 1
  - id: num_fields
    type: u1
    if: version >= 2
  - id: single_field
    type: field(false, 0)
    if: version < 2
  - id: fields
    type: 'field(true, _index == 0 ? 0 : fields[_index - 1].ir_end)'
    repeat: expr
    repeat-expr: num_fields
    if: version >= 2
  - id: hrirs
    type: hrir
    repeat: expr
    repeat-expr: num_hrirs
  - id: delays
    type: u1
    repeat: expr
    repeat-expr: num_hrirs * num_channels
    doc: |
      Propagation delay of each HRIR in samples (interleaved left/right for
      stereo data sets). In versions 0 to 2 it is an integer number of
      samples; in version 3 it is a 6.2 fixed-point value (in quarter
      samples).
instances:
  version:
    value: magic.substring(6, 8).to_i
  hrir_size:
    value: 'version == 0 ? hrir_size_v0 : hrir_size_v1'
    doc: Number of coefficients (filter taps) of each HRIR.
  sample_type:
    value: |
      version == 3 ? sample_type::s24
        : version == 2 ? sample_type_v2
        : sample_type::s16
  num_channels:
    value: 'version >= 2 and channel_type == channel_type::left_right ? 2 : 1'
  num_hrirs:
    value: |
      version == 0 ? num_hrirs_v0
        : version == 1 ? single_field.ir_end
        : fields.last.ir_end
types:
  field:
    params:
      - id: has_header
        type: bool
      - id: ir_base
        type: u4
        doc: Index of the first HRIR of this field.
    seq:
      - id: distance
        type: u2
        if: has_header
        doc: Distance of the field from the listener, in millimeters.
      - id: num_elevations
        type: u1
      - id: elevations
        type: 'elevation(_index == 0 ? ir_base : elevations[_index - 1].ir_end)'
        repeat: expr
        repeat-expr: num_elevations
    instances:
      ir_end:
        value: |
          _root.version == 0 ? _root.num_hrirs_v0 : elevations.last.ir_end
  elevation:
    params:
      - id: ir_offset
        type: u4
        doc: Index of the first HRIR of this elevation.
    seq:
      - id: ir_offset_v0
        type: u2
        if: _root.version == 0
        doc: Index of the first HRIR of this elevation (version 0 only).
      - id: num_azimuths_v1
        type: u1
        if: _root.version != 0
    instances:
      ir_end:
        value: |
          _root.version == 0 ? 0 : ir_offset + num_azimuths_v1
        doc: |
          Index one past the last HRIR of this elevation. For version 0,
          use the `ir_offset_v0` values of consecutive elevations instead.
  hrir:
    seq:
      - id: coefficients_s16
        type: s2
        repeat: expr
        repeat-expr: _root.hrir_size * _root.num_channels
        if: _root.sample_type == sample_type::s16
        doc: |
          Signed fixed-point filter coefficients (full scale 32768),
          interleaved left/right for stereo data sets.
      - id: coefficients_s24
        type: s24le
        repeat: expr
        repeat-expr: _root.hrir_size * _root.num_channels
        if: _root.sample_type == sample_type::s24
        doc: |
          Signed fixed-point filter coefficients (full scale 8388608),
          interleaved left/right for stereo data sets.
  s24le:
    seq:
      - id: raw
        size: 3
    instances:
      value:
        value: '(raw[0] | raw[1] << 8 | raw[2] << 16) - (raw[2] >= 0x80 ? 0x100_0000 : 0)'
enums:
  sample_type:
    0: s16
    1: s24
  channel_type:
    0: left_only
    1: left_right
