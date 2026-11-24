# Imported from https://github.com/det-lab/kaitai_struct_awkward_runtime/blob/76ae1efd89757904a3ae70d19f38b85d8e665a8e/example_data/schemas/pixie4e.ksy
# Licence and copyright: see _community/README.md
meta:
  id: pixie4e_list_mode
  file-extension: b00
  license: MIT
  ks-version: 0.8
  endian: le

seq:

  - id: file_header
    type: pixie4e_header

  - id: events
    size: _io.size - 128
    type: event

  - id: file_footer
    type: pixie_eor


types:

  pixie4e_header:
    seq:
      - id: blk_size
        type: u2

      - id: mod_num
        type: u2

      - id: run_format
        type: u2

      - id: chan_head_len
        type: u2

      - id: coinc_pat
        type: u2

      - id: coinc_win
        type: u2

      - id: max_comb_event_len
        type: u2

      - id: board_version
        type: u2

      - id: event_length_0
        type: u2

      - id: event_length_1
        type: u2

      - id: event_length_2
        type: u2

      - id: event_length_3
        type: u2

      - id: serial_number
        type: u2

      - id: reserved
        type: u2


  event:
    seq:
      - id: elements
        type: element
        repeat: eos


  element:
    seq:
      - id: header
        type: channel_header

      - id: data
        type: u2
        repeat: expr
        repeat-expr: header.num_trace_blks * _root.file_header.blk_size


  channel_header:
    seq:
      - id: evt_pattern
        type: u2

      - id: evt_info
        type: u2

      - id: num_trace_blks
        type: u2

      - id: num_trace_blks_prev
        type: u2

      - id: trig_time_lo
        type: u2

      - id: trig_time_mi
        type: u2

      - id: trig_time_hi
        type: u2

      - id: trig_time_x
        type: u2

      - id: energy
        type: u2

      - id: chan_no
        type: u2

      - id: user_psa_value
        type: u2

      - id: xia_psa_value
        type: u2

      - id: extended_psa_values
        type: u2
        repeat: expr
        repeat-expr: 0x4

      - id: reserved
        type: u2
        repeat: expr
        repeat-expr: 0x10

    instances:
      timestamp_full:
        # Compose the 64-bit timestamp from the firmware's three 16-bit words.
        value: trig_time_lo + (trig_time_mi << 16) + (trig_time_hi << 32)

  pixie_eor:
    seq:
      - id: evt_pattern
        type: u2

      - id: evt_info
        type: u2

      - id: num_trace_blks
        type: u2

      - id: num_trace_blks_prev
        type: u2

      - id: reserved
        type: u2
