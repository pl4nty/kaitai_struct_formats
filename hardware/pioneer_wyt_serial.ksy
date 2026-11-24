# Imported from https://github.com/squidpickles/tuya-serial/blob/61e7653130f55e13a093a512e882e1c3e47cbced/tuya.ksy
meta:
  id: pioneer_wyt_serial
  title: Pioneer WYT (TCL) mini-split serial protocol, controller to appliance
  file-extension: tuya
  license: LicenseRef-All-Rights-Reserved
  endian: be
  bit-endian: be
doc: |
  Frames sent by the Tuya wifi module ("controller") to the air conditioner
  MCU ("appliance") over 9600-8-E-1. Every frame is a 5 byte header, a
  `payload_size` byte payload, and a one byte XOR checksum, so the total frame
  length is `payload_size + 6`.

  Observed traffic pattern from the stock Tuya module: `query_state` every
  3 s, `query_ext_a` and `query_ext_b` every 9 s (`query_ext_b` with
  `request_flags` = 0x08 roughly every 2 min), `set_clock` once an hour,
  `set_state` whenever a setting changes. `set_state` carries the entire
  desired state, not just the changed fields.

  Sources: serial captures in this repo (`cmds`, `msgs`, `plot/*.log`),
  the reversed Tuya firmware, and the TCL protocol as implemented in
  https://github.com/I-am-nightingale/tclac (same 0xBB framing, slightly
  different command layout; anything only attested there is marked
  "unverified on Pioneer").

  Updated from the complete byte guide and bounded firmware analysis, 2026-10-11.
  See ../tuya-firmware/analysis/PIONEER-UART-GUIDE.md and re-spec/
  (under ../tuya-firmware/analysis/)
  for evidence, transition rules and accepted limitations. Static-derived fields
  are not proof of installed hardware or selectable app options. Preserve raw
  payloads and unknown enum values. This schema parses individual packets;
  checksum XOR, stream resynchronization, state retention, pending operations
  and field interactions must be implemented by the caller. An absent conditional
  instance means unknown, not zero/off. No rich units-write route is verified.
  Capture constancy is not a required
  default; never replay controls at boot. 8n1 captures are invalid byte evidence.
seq:
  - id: magic
    contents:
      - 187
  - id: source
    type: u2
    enum: source
    valid: source::controller
  - id: command
    type: u1
    enum: command
  - id: payload_size
    type: u1
    valid:
      expr: _ <= 249 and (command != command::set_state or _ == 29) and (command != command::query_state
        or _ == 2) and (command != command::query_ext_a or _ == 2) and (command != command::query_ext_b
        or _ == 3) and (command != command::set_clock or _ == 16) and (command != command::command_05 or
        _ == 9) and (command != command::reset_notification or _ == 9)
    doc: Number of payload bytes, excluding header and checksum
  - id: payload
    size: payload_size
    type:
      switch-on: command
      cases:
        command::set_state: set_state
        command::query_state: query_state
        command::query_ext_a: query_ext_a
        command::query_ext_b: query_ext_b
        command::set_clock: set_clock
        command::command_05: command_05
        command::reset_notification: reset_notification
  - id: checksum
    type: u1
    doc: |
      XOR of every preceding byte of the frame, including the magic byte. Parsed only;
      caller must validate
      XOR of the full frame equals zero.
types:
  query_state:
    doc: Captured `bb 00 01 04 02 01 00 bd`. Answered with a 61 byte state response.
    seq:
      - id: unknown1
        type: u1
        doc: captured 0x01
      - id: unknown2
        type: u1
        doc: captured 0x00
  query_ext_a:
    doc: Captured `bb 00 01 09 02 05 00 b4`. Answered with a constant 51 byte response.
    seq:
      - id: unknown1
        type: u1
        doc: captured 0x05
      - id: unknown2
        type: u1
        doc: captured 0x00
  query_ext_b:
    doc: |
      `bb 00 01 0a 03 05 00 00 b6` or `bb 00 01 0a 03 05 00 08 be`.
      Answered with a 51 byte response. About every two minutes the
      appliance answers with flags 0x0c and a statistics sample; the module
      then sends the next query with request_flags 0x08, after which the
      appliance goes back to flags 0x04 and restarts its counter. So 0x08 is
      an acknowledgement of the sample, not a request for one.
    seq:
      - id: unknown1
        type: u1
        doc: captured 0x05
      - id: unknown2
        type: u1
        doc: captured 0x00
      - id: request_flags
        type: u1
        doc: |
          0x00 normally; 0x08 acknowledges successfully delivered nonzero sample data.
          Static firmware
          eligibility ignores response flags.
  command_05:
    doc: 'Captured once with status02. Static40259a14 establishes module-status notification, not merely
      startup handshake: SDK status1 ->08,2/4 ->01,5 ->04,6 ->02. SDK status meanings and appliance effects
      are not fully established.'
    seq:
      - id: unknown1
        size: 8
        doc: zeroes
      - id: status
        type: u1
        doc: Captured02; static01/04/08 also possible.
  set_clock:
    doc: |
      Sent once an hour at the same minute and second, with the current local
      time. Acknowledged with `bb 01 00 0b 02 04 00 b7`. Stock sends only after
      local-time retrieval succeeds and year >= 2018.
      There is no weekday/timezone byte. Clock synchronization alone creates no timer.
    seq:
      - id: unknown1
        type: u1
        doc: captured 0x05
      - id: unknown2
        type: u1
        doc: captured 0x00
      - id: year
        type: u2le
      - id: month
        type: u1
      - id: day
        type: u1
      - id: hour
        type: u1
      - id: minute
        type: u1
      - id: second
        type: u1
      - id: unknown3
        size: 7
        doc: zeroes
  set_state:
    doc: Full desired state of the appliance. Answered with a 61 byte state response.
    seq:
      - id: unknown1
        size: 2
        doc: captured 00 00
      - id: eco
        type: b1
      - id: display
        type: b1
      - id: beeper
        type: b1
      - id: on_timer_enabled
        type: b1
        doc: |
          Static appliance timer flag; current app scheduling is local/cloud-derived and
          does not use
          these bits. Preserve unless explicitly changing appliance timer state.
      - id: off_timer_enabled
        type: b1
        doc: |
          Static appliance timer flag; current app scheduling is local/cloud-derived and
          does not use
          these bits. Preserve unless explicitly changing appliance timer state.
      - id: power
        type: b1
      - id: unknown2
        type: b2
      - id: mute
        type: b1
      - id: strong
        type: b1
        doc: Turbo. Captured together with fan_speed high.
      - id: airdry
        type: b1
        doc: Static rich route; cool/dry only, cleared by power-on.
      - id: health
        type: b1
        doc: Ionizer / plasma
      - id: mode
        type: b4
        enum: opmode
      - id: eco_target_complement
        type: b4
        doc: |
          Static complement of eco target low nibble; projection from response50 unless
          FF. Preserve
          outside explicit advanced-eco changes.
      - id: temp_set_base
        type: b4
        doc: |
          Low nibble of request lookup code. Celsius first-match code is31 minus whole C;
          F requires
          table, not linear conversion.
      - id: antifreeze
        type: b1
        doc: 8 degree heating
      - id: soft_wind
        type: b1
        doc: |
          Static rich route. Hidden by capability profile on captured product; not a
          verified timer indicator.
      - id: vertical_swing
        type: b3
        doc: |
          0b111 when the vertical louver swings, 0 otherwise. Which range it
          swings over is selected by up_down_swing.
      - id: fan_speed
        type: b3
        enum: fan_speed
      - id: unknown5
        type: b1
      - id: eco_correction
        type: b1
        doc: |
          Static corrective eco sender sets this; projection retains it, no auto-clear
          lifetime established.
      - id: unknown5_bit5
        type: b1
      - id: off_timer_cancel
        type: b1
        doc: Set when cancelling off timer. Retained in request cache, not a proved pulse.
      - id: horizontal_swing
        type: b1
        doc: |
          Set in every captured horizontal swing command and in none of the
          fixed position ones. Was called dp69 in the reversed firmware.
      - id: temp_set_code_high
        type: b1
        doc: Request table code bit4 in F mode.
      - id: temp_set_half_c
        type: b1
        doc: Celsius half-degree, independent of F code bit.
      - id: unknown6
        type: b1
      - id: display_units
        type: b1
        enum: display_units
      - id: unknown7
        type: b2
      - id: eco_strategy
        type: b3
        doc: Static0..3, profile only exposes basic eco. Preserve other values raw.
      - id: unknown7_low
        type: b2
      - id: unknown8
        size: 6
        doc: |
          Payload8 is retained; payload9..12 copy response6..9. Payload13 copies generator
          low5
          from response42 if non-FF, mirroring bits4..2 to bits7..5 only when that group
          is <4. Preserve raw.
      - id: photosensitive
        type: b1
        doc: Static generic control; not exposed by observed profile.
      - id: unknown9
        type: b1
      - id: smart_dry
        type: b1
        doc: Static generic control; not exposed by observed profile.
      - id: self_clean
        type: b1
        doc: |-
          Starts evaporator self cleaning. Seen set in exactly one captured
          command, sent (with power off) at the moment self cleaning was
          started from the app; the response then reports self_clean for
          about 30 minutes.
           Immediate reply can remain false; do not retry based only on that. Cancel is static evidence.
      - id: filter_flag
        type: b1
        doc: Static generic control; reset semantics not established.
      - id: sleep
        type: b3
        enum: sleep
        doc: 'Static: three-bit field. Value4 auto exists in firmware but is not offered by the observed
          panel; values0..3 are the local menu.'
      - id: unknown11
        size: 12
        doc: |
          Payload15..26. First ten bytes copied from response15..24; last two
          independently copied from response48/49
          only when each source byte is not FF. They encode eco amounts under specific
          strategies. Preserve raw.
      - id: cold_wind
        type: b1
        doc: Static generic airflow flag; hidden on observed profile.
      - id: hot_wind
        type: b1
        doc: Static generic airflow flag; hidden on observed profile.
      - id: up_down_swing
        type: b3
        enum: up_down_swing
      - id: up_down_position
        type: b3
        enum: up_down_position
      - id: unknown13
        type: b1
        doc: |
          Copied from response27 bit6 into request28 bit7 (capability/enable). Captured1;
          preserve, not a universal constant.
      - id: horizontal_special_position
        type: b1
        doc: Static special position8 flag, excluded from current panel choices.
      - id: left_right_swing
        type: b3
        enum: left_right_swing
      - id: left_right_position
        type: b3
        enum: left_right_position
    instances:
      temp_set_in_c:
        value: 'display_units == display_units::fahrenheit ? (temp_set_table_f - 32) * 5 / 9.0 : 31 -
          temp_set_base + (temp_set_half_c ? 0.5 : 0)'
        if: display_units == display_units::celsius or temp_set_table_f >= 0
      temp_set_in_f:
        value: 'display_units == display_units::fahrenheit ? temp_set_table_f : temp_set_in_c * 9 / 5.0
          + 32'
        if: display_units == display_units::celsius or temp_set_table_f >= 0
      raw:
        pos: 0
        size: 29
        doc: |
          Original payload, including all unknown/sentinel bits. Offsets into raw are
          payload offsets
          (wire offset minus five).
      temp_set_code:
        value: 'temp_set_base + (temp_set_code_high ? 16 : 0)'
      temp_set_table_f:
        value: 'temp_set_code == 15 ? 61 : temp_set_code == 31 ? 62 : temp_set_code == 14 ? 63 : temp_set_code
          == 13 ? 64 : temp_set_code == 29 ? 65 : temp_set_code == 12 ? 66 : temp_set_code == 28 ? 67
          : temp_set_code == 11 ? 68 : temp_set_code == 27 ? 69 : temp_set_code == 10 ? 70 : temp_set_code
          == 26 ? 71 : temp_set_code == 9 ? 72 : temp_set_code == 8 ? 73 : temp_set_code == 24 ? 74 :
          temp_set_code == 7 ? 75 : temp_set_code == 23 ? 76 : temp_set_code == 6 ? 77 : temp_set_code
          == 22 ? 78 : temp_set_code == 5 ? 79 : temp_set_code == 21 ? 80 : temp_set_code == 4 ? 81 :
          temp_set_code == 3 ? 82 : temp_set_code == 19 ? 83 : temp_set_code == 2 ? 84 : temp_set_code
          == 18 ? 85 : temp_set_code == 1 ? 86 : temp_set_code == 17 ? 87 : temp_set_code == 0 ? 88 :
          temp_set_code == 16 ? 89 : -1'
        doc: |
          Static flash40201380; -1 denotes unknown code. 89F decodable but outside
          panel61..88F range.
      generator_mirrored_group:
        value: (raw[13] >> 2) & 7
        doc: Copied from non-FF response42 bits4..2; physical meaning unresolved.
      generator_group_copy:
        value: (raw[13] >> 5) & 7
        doc: Mirror updated only when response42 bits4..2 are <4; otherwise retained.
      generator_level:
        value: raw[13] & 3
        doc: Static generic control, not exposed on this profile.
      eco_budget_raw:
        value: raw[25] + 256 * raw[26]
        doc: |
          Opaque outside static strategies; basic cool eco writes0x0160. Do not assign
          monetary/physical
          units.
  reset_notification:
    doc: 'Static-only: sent after response payload[10].7, then an SDK mode transition. Not proof of CPU/factory
      reset; no captured command06.'
    seq:
      - id: unknown1
        size: 8
      - id: status
        type: u1
        doc: Static value 0x80.
enums:
  source:
    1: controller
    256: appliance
  command:
    3: set_state
    4: query_state
    9: query_ext_a
    10: query_ext_b
    11: set_clock
    5: command_05
    6: reset_notification
  fan_speed:
    0: auto
    2: low
    3: medium
    5: high
    6: mid_low
    7: mid_high
  opmode:
    1: heat
    2: dehumidify
    3: cool
    7: fan
    8: auto
  up_down_swing:
    0: 'off'
    1: full
    2: upper
    3: lower
  up_down_position:
    0: auto
    1: top
    2: upper
    3: middle
    4: lower
    5: bottom
  left_right_swing:
    0: 'off'
    1: full
    2: left
    3: middle
    4: right
  left_right_position:
    0: auto
    1: left
    2: middle_left
    3: middle
    4: middle_right
    5: right
  sleep:
    0: 'off'
    1: standard
    2: elderly
    3: child
    4: auto
  display_units:
    0: celsius
    1: fahrenheit
