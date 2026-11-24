# Imported from https://github.com/Paint-a-Farm/glsconvert/blob/4881d611f781c3287002fb75224c9f26130df0eb/Gls.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gls
  file-extension: gls
  license: MIT
  endian: le

seq:
  - id: magic
    contents: " slg"
  - id: version
    type: u4
  - id: mode
    type: u4
  - id: bitrate
    type: u4
  - id: noop
    size: 32
  - id: number_of_engine_loops
    type: u4
  - id: number_of_exhaust_loops
    type: u4
  - id: engineloopfiles
    type: loopfile
    repeat: expr
    repeat-expr: number_of_engine_loops
  - id: startfile
    type: startstopfile
  - id: stopfile
    type: startstopfile
  - id: engine_load
    type: load
  - id: stop_fadems
    type: u4
  - id: start_fadems
    type: u4
  - id: start_rpm
    type: u4
  - id: start_use_equal_power_fade
    type: b8
  - id: ignore
    size: 3
  - id: rpm_fade_max_time_ms
    type: u4
  - id: exhaust_loops
    type: loopfile
    repeat: expr
    repeat-expr: number_of_exhaust_loops
  - id: exhaust_load
    type: load

enums:
  file_formats:
    0: wav
    1: ogg
  band_types:
    0: sinus
    1: arctan
    2: hardclip
    3: fuzzymouth
    4: inyourfuzz
    5: fuzzyboots
    6: smooth
  waveforms:
    0: triangle
    1: sinus
    2: sawtooth
    3: square

types:
  band:
    seq:
      - id: frequency
        type: f4
      - id: gaindb
        type: f4
      - id: quality_factor
        type: f4

  load:
    seq:
      - id: input_gain
        type: f4
      - id: output_gain
        type: f4
      - id: banddistortion_low_maxfrequency
        type: f4
      - id: banddistortion_mid_maxfrequency
        type: f4
      - id: banddistortion_low_type
        type: u4
      - id: banddistortion_mid_type
        type: u4
      - id: banddistortion_high_type
        type: u4
      - id: load_order_distortion_before_eq
        type: b8
      - id: load_invertwet_value
        type: b8
      - id: load_loadpoints_number_of_loadpoints
        type: u4
      - id: loadpoints
        type: loadpoint
        repeat: expr
        repeat-expr: load_loadpoints_number_of_loadpoints
      - id: waveform
        type: u4
      - id: load_lfo_harmonic
        type: u4
      - id: load_lfo_fade_start_rpm
        type: f4
      - id: load_lfo_fade_end_rpm
        type: f4
      - id: load_lfo_fade_min_scale
        type: f4

  loadpoint:
    seq:
      - id: load
        type: f4
      - id: wet
        type: f4
      - id: dry
        type: f4
      - id: gain_db
        type: f4
      - id: eq_num_bands
        type: u4
      - id: band
        type: band
        repeat: expr
        repeat-expr: eq_num_bands
      - id: banddistortion_low_drive
        type: f4
      - id: banddistortion_mid_drive
        type: f4
      - id: banddistortion_high_drive
        type: f4
      - id: lfo_amplitudedb
        type: f4
      - id: lfo_offsetb
        type: f4

  startstopfile:
    seq:
      - id: file
        type: file
      - id: gain_voltage
        type: f4

  loopfile:
    seq:
      - id: gain_db
        type: f4
        if: _root.version >= 15
      - id: rpm_min
        type: f4
      - id: rpm_max
        type: f4
      - id: rpm_root
        type: f4
      - id: curve_alpha
        type: f4
        if: _root.version >= 17
      - id: file
        type: file

  file:
    seq:
      - id: file_format
        type: u4
        enum: file_formats
      - id: number_of_samples
        type: u4
      - id: filelength
        type: u4
      - id: filecontents
        size: filelength
        if: file_format == file_formats::ogg
      - id: filecontentswav
        type: s2
        repeat: expr
        repeat-expr: filelength / 2
        if: file_format == file_formats::wav
