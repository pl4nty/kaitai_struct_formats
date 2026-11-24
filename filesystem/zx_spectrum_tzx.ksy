meta:
  id: zx_spectrum_tzx
  title: ZX Spectrum TZX tape image
  file-extension:
    - tzx
    - cdt
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  TZX is a tape image format for the ZX Spectrum (and, with the `.cdt`
  extension, the Amstrad CPC) designed to preserve tapes with turbo and
  custom loaders. After a 10-byte header (`ZXTape!`, 0x1a, major and minor
  revision), the file is a sequence of blocks, each starting with an ID
  byte. Data blocks describe the signal (pilot tones, sync pulses, bit
  timings, direct sample recordings, CSW pulse streams or "generalized"
  symbol-based encodings); other blocks control playback (pauses, groups,
  loops, jumps, calls) or carry metadata (text, archive info, hardware
  info).

  All blocks of revision 1.20 are parsed, including the deprecated C64,
  emulation info and snapshot blocks. Any unknown block ID is assumed to
  follow the general extension rule (32-bit length after the ID). Data in
  standard/turbo/pure data blocks is the same as a block in a `.tap` file
  (flag byte, payload, checksum) and is kept raw.
doc-ref:
  - https://worldofspectrum.net/TZXformat.html
  - https://github.com/MoleskiCoder/spectrum/blob/master/documentation/TZX%20technical%20specifications.html
seq:
  - id: header
    type: header
  - id: blocks
    type: block
    repeat: eos
types:
  header:
    seq:
      - id: magic
        contents: ["ZXTape!", 0x1a]
      - id: version_major
        type: u1
      - id: version_minor
        type: u1
  block:
    seq:
      - id: block_id
        type: u1
        enum: block_type
      - id: body
        type:
          switch-on: block_id
          cases:
            block_type::standard_speed_data: standard_speed_data
            block_type::turbo_speed_data: turbo_speed_data
            block_type::pure_tone: pure_tone
            block_type::pulse_sequence: pulse_sequence
            block_type::pure_data: pure_data
            block_type::direct_recording: direct_recording
            block_type::c64_rom_data: c64_data
            block_type::c64_turbo_data: c64_data
            block_type::csw_recording: csw_recording
            block_type::generalized_data: generalized_data
            block_type::pause: pause
            block_type::group_start: text_u1
            block_type::group_end: empty
            block_type::jump: jump
            block_type::loop_start: loop_start
            block_type::loop_end: empty
            block_type::call_sequence: call_sequence
            block_type::return_from_sequence: empty
            block_type::select: select
            block_type::stop_if_48k: extension_block
            block_type::set_signal_level: set_signal_level
            block_type::text_description: text_u1
            block_type::message: message
            block_type::archive_info: archive_info
            block_type::hardware_type: hardware_type
            block_type::emulation_info: emulation_info
            block_type::custom_info: custom_info
            block_type::snapshot: snapshot
            block_type::glue: glue
            _: extension_block
  empty:
    doc: Block without body.
    seq: []
  extension_block:
    doc: |
      Block following the general extension rule: a 32-bit length
      (excluding itself) followed by the body.
    seq:
      - id: len_body
        type: u4
      - id: body
        size: len_body
  text_u1:
    seq:
      - id: len_text
        type: u1
      - id: text
        size: len_text
        type: str
        encoding: ISO-8859-1
  standard_speed_data:
    doc: Data block replayed with the standard ROM timings (ID 0x10).
    seq:
      - id: pause_after
        type: u2
        doc: Pause after this block in ms.
      - id: len_data
        type: u2
      - id: data
        size: len_data
        doc: Data as in a `.tap` file block (flag, payload, checksum).
  turbo_speed_data:
    doc: Data block with custom timings (ID 0x11).
    seq:
      - id: len_pilot_pulse
        type: u2
        doc: Length of a pilot pulse in T-states (ROM default 2168).
      - id: len_sync1_pulse
        type: u2
        doc: Length of the first sync pulse (ROM default 667).
      - id: len_sync2_pulse
        type: u2
        doc: Length of the second sync pulse (ROM default 735).
      - id: len_zero_pulse
        type: u2
        doc: Length of a pulse of a zero bit (ROM default 855).
      - id: len_one_pulse
        type: u2
        doc: Length of a pulse of a one bit (ROM default 1710).
      - id: num_pilot_pulses
        type: u2
        doc: Number of pilot pulses (ROM default 8063 for headers, 3223 for data).
      - id: used_bits_last_byte
        type: u1
        doc: Number of used bits (from the MSb) in the last data byte.
      - id: pause_after
        type: u2
        doc: Pause after this block in ms.
      - id: len_data
        type: b24le
      - id: data
        size: len_data
        doc: Data as in a `.tap` file block.
  pure_tone:
    doc: Pure tone (ID 0x12).
    seq:
      - id: len_pulse
        type: u2
        doc: Length of one pulse in T-states.
      - id: num_pulses
        type: u2
  pulse_sequence:
    doc: Sequence of pulses of various lengths (ID 0x13).
    seq:
      - id: num_len_pulses
        type: u1
      - id: len_pulses
        type: u2
        repeat: expr
        repeat-expr: num_len_pulses
        doc: Pulse lengths in T-states.
  pure_data:
    doc: Data block without pilot and sync pulses (ID 0x14).
    seq:
      - id: len_zero_pulse
        type: u2
      - id: len_one_pulse
        type: u2
      - id: used_bits_last_byte
        type: u1
      - id: pause_after
        type: u2
        doc: Pause after this block in ms.
      - id: len_data
        type: b24le
      - id: data
        size: len_data
  direct_recording:
    doc: 1-bit sampled recording (ID 0x15); MSb of each byte is played first.
    seq:
      - id: tstates_per_sample
        type: u2
      - id: pause_after
        type: u2
        doc: Pause after this block in ms.
      - id: used_bits_last_byte
        type: u1
        doc: Number of used samples (1-8) in the last byte.
      - id: len_samples
        type: b24le
      - id: samples
        size: len_samples
  c64_data:
    doc: |
      Deprecated C64 ROM type (ID 0x16) or C64 turbo tape (ID 0x17) data
      block. The leading length covers the whole block including itself.
    seq:
      - id: len_block
        type: u4
        doc: Length of the whole block, including these 4 bytes.
      - id: body
        size: len_block - 4
  csw_recording:
    doc: Pulses in Compressed Square Wave v2 encoding (ID 0x18).
    seq:
      - id: len_body
        type: u4
      - id: body
        size: len_body
        type: csw_recording_body
  csw_recording_body:
    seq:
      - id: pause_after
        type: u2
        doc: Pause after this block in ms.
      - id: sampling_rate
        type: b24le
      - id: compression
        type: u1
        enum: csw_compression
      - id: num_pulses
        type: u4
        doc: Number of pulses after decompression.
      - id: csw_data
        size-eos: true
  generalized_data:
    doc: Generalized data block (ID 0x19) using symbol alphabets.
    seq:
      - id: len_body
        type: u4
      - id: body
        size: len_body
        type: generalized_data_body
  generalized_data_body:
    seq:
      - id: pause_after
        type: u2
        doc: Pause after this block in ms.
      - id: num_pilot_stream
        type: u4
        doc: Number of entries in the pilot/sync RLE stream (TOTP).
      - id: max_pulses_pilot
        type: u1
        doc: Maximum number of pulses per pilot/sync symbol (NPP).
      - id: num_pilot_alphabet_raw
        type: u1
        doc: Number of pilot/sync symbols in the alphabet (ASP); 0 means 256.
      - id: num_data_symbols
        type: u4
        doc: Total number of symbols in the data stream (TOTD).
      - id: max_pulses_data
        type: u1
        doc: Maximum number of pulses per data symbol (NPD).
      - id: num_data_alphabet_raw
        type: u1
        doc: Number of data symbols in the alphabet (ASD); 0 means 256.
      - id: pilot_alphabet
        type: symbol_def(max_pulses_pilot)
        repeat: expr
        repeat-expr: num_pilot_alphabet
        if: num_pilot_stream > 0
      - id: pilot_stream
        type: pilot_rle
        repeat: expr
        repeat-expr: num_pilot_stream
        if: num_pilot_stream > 0
      - id: data_alphabet
        type: symbol_def(max_pulses_data)
        repeat: expr
        repeat-expr: num_data_alphabet
        if: num_data_symbols > 0
      - id: data_stream
        size-eos: true
        doc: Data symbols, each stored in ceil(log2(ASD)) bits, MSb first.
    instances:
      num_pilot_alphabet:
        value: 'num_pilot_alphabet_raw == 0 ? 256 : num_pilot_alphabet_raw'
      num_data_alphabet:
        value: 'num_data_alphabet_raw == 0 ? 256 : num_data_alphabet_raw'
  symbol_def:
    params:
      - id: num_len_pulses
        type: u1
        doc: Maximum number of pulses per symbol (NPP or NPD).
    seq:
      - id: flags
        type: u1
        doc: |
          Bits 0-1: starting polarity (0 = opposite to current level,
          1 = same as current level, 2 = force low, 3 = force high).
      - id: len_pulses
        type: u2
        repeat: expr
        repeat-expr: num_len_pulses
        doc: Pulse lengths; shorter symbols are terminated by a 0 length.
  pilot_rle:
    seq:
      - id: symbol
        type: u1
      - id: num_repeats
        type: u2
  pause:
    doc: Pause (ID 0x20); a duration of 0 means "stop the tape".
    seq:
      - id: duration
        type: u2
        doc: Pause duration in ms.
  jump:
    doc: Jump to block (ID 0x23).
    seq:
      - id: relative_jump
        type: s2
        doc: Relative block offset (1 = next block).
  loop_start:
    doc: Loop start (ID 0x24).
    seq:
      - id: num_repeats
        type: u2
  call_sequence:
    doc: Call sequence (ID 0x26).
    seq:
      - id: num_calls
        type: u2
      - id: calls
        type: s2
        repeat: expr
        repeat-expr: num_calls
        doc: Relative block offsets to call.
  select:
    doc: Select block (ID 0x28).
    seq:
      - id: len_body
        type: u2
      - id: body
        size: len_body
        type: select_body
  select_body:
    seq:
      - id: num_selections
        type: u1
      - id: selections
        type: selection
        repeat: expr
        repeat-expr: num_selections
  selection:
    seq:
      - id: relative_offset
        type: s2
      - id: description
        type: text_u1
  set_signal_level:
    doc: Set signal level (ID 0x2b).
    seq:
      - id: len_body
        type: u4
        valid: 1
      - id: level
        type: u1
        doc: 0 = low, 1 = high.
  message:
    doc: Message block (ID 0x31).
    seq:
      - id: display_time
        type: u1
        doc: Time to display the message in seconds; 0 = wait for a key.
      - id: message
        type: text_u1
  archive_info:
    doc: Archive info (ID 0x32).
    seq:
      - id: len_body
        type: u2
      - id: body
        size: len_body
        type: archive_info_body
  archive_info_body:
    seq:
      - id: num_texts
        type: u1
      - id: texts
        type: archive_text
        repeat: expr
        repeat-expr: num_texts
  archive_text:
    seq:
      - id: text_id
        type: u1
        enum: archive_text_id
      - id: text
        type: text_u1
  hardware_type:
    doc: Hardware type (ID 0x33).
    seq:
      - id: num_entries
        type: u1
      - id: entries
        type: hardware_info
        repeat: expr
        repeat-expr: num_entries
  hardware_info:
    seq:
      - id: hw_type
        type: u1
        doc: Hardware type (0 = computers, 1 = external storage, 3 = sound devices, ...).
      - id: hw_id
        type: u1
        doc: Hardware ID within the type.
      - id: info
        type: u1
        enum: hardware_compat
  emulation_info:
    doc: Deprecated emulation info (ID 0x34).
    seq:
      - id: body
        size: 8
  custom_info:
    doc: Custom info (ID 0x35).
    seq:
      - id: identification
        size: 16
        type: str
        encoding: ISO-8859-1
      - id: len_info
        type: u4
      - id: info
        size: len_info
  snapshot:
    doc: Deprecated snapshot block (ID 0x40).
    seq:
      - id: snapshot_type
        type: u1
        doc: 0 = .Z80, 1 = .SNA.
      - id: len_snapshot
        type: b24le
      - id: snapshot
        size: len_snapshot
  glue:
    doc: |
      Glue block (ID 0x5a) left by concatenating two TZX files: the rest of
      the second file's header.
    seq:
      - id: magic
        contents: ["XTape!", 0x1a]
      - id: version_major
        type: u1
      - id: version_minor
        type: u1
enums:
  block_type:
    0x10: standard_speed_data
    0x11: turbo_speed_data
    0x12: pure_tone
    0x13: pulse_sequence
    0x14: pure_data
    0x15: direct_recording
    0x16: c64_rom_data
    0x17: c64_turbo_data
    0x18: csw_recording
    0x19: generalized_data
    0x20: pause
    0x21: group_start
    0x22: group_end
    0x23: jump
    0x24: loop_start
    0x25: loop_end
    0x26: call_sequence
    0x27: return_from_sequence
    0x28: select
    0x2a: stop_if_48k
    0x2b: set_signal_level
    0x30: text_description
    0x31: message
    0x32: archive_info
    0x33: hardware_type
    0x34: emulation_info
    0x35: custom_info
    0x40: snapshot
    0x5a: glue
  csw_compression:
    1: rle
    2: z_rle
  archive_text_id:
    0x00: full_title
    0x01: publisher
    0x02: authors
    0x03: year
    0x04: language
    0x05: type
    0x06: price
    0x07: protection
    0x08: origin
    0xff: comment
  hardware_compat:
    0: runs
    1: uses
    2: runs_not_uses
    3: does_not_run
