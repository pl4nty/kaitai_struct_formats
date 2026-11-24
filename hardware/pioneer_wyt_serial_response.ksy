# Imported from https://github.com/squidpickles/tuya-serial/blob/61e7653130f55e13a093a512e882e1c3e47cbced/tuya-response.ksy
meta:
  id: pioneer_wyt_serial_response
  title: Pioneer WYT (TCL) mini-split serial protocol, appliance to controller
  file-extension: tuya_response
  license: LicenseRef-All-Rights-Reserved
  endian: be
  bit-endian: be
doc: |
  Frames sent by the air conditioner MCU ("appliance") to the Tuya wifi
  module ("controller") over 9600-8-E-1. Every frame is a 5 byte header, a
  `payload_size` byte payload, and a one byte XOR checksum, so the total frame
  length is `payload_size + 6`. The command byte echoes the request that is
  being answered.

  Byte offsets in field docs are offsets into the whole frame, matching the
  `header` file in this repo.

  Sources: serial captures in this repo (`cmds`, `msgs`, `plot/*.log`) and
  the TCL protocol as implemented in
  https://github.com/I-am-nightingale/tclac.

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
    valid: source::appliance
  - id: command
    type: u1
    enum: command
  - id: payload_size
    type: u1
    valid:
      expr: _ <= 249 and (command != command::set_state_response or _ == 55) and (command != command::query_state_response
        or _ == 55) and (command != command::query_ext_a_response or _ == 45) and (command != command::query_ext_b_response
        or _ == 45) and (command != command::set_clock_response or _ == 2) and (command != command::command_05_response
        or _ == 11)
    doc: Number of payload bytes, excluding header and checksum. 0x37 for state.
  - id: payload
    size: payload_size
    type:
      switch-on: command
      cases:
        command::set_state_response: state
        command::query_state_response: state
        command::query_ext_a_response: ext_a
        command::query_ext_b_response: ext_b
        command::set_clock_response: ack
        command::command_05_response: response_05
  - id: checksum
    type: u1
    doc: |
      XOR of every preceding byte of the frame, including the magic byte. Parsed only;
      caller must validate
      XOR of the full frame equals zero.
types:
  ack:
    doc: Captured `bb 01 00 0b 02 04 00 b7`
    seq:
      - id: unknown1
        size: 2
        doc: captured 04 00
  ext_a:
    doc: |-
      Answer to `query_ext_a` (0x09). Constant in every capture:
      `00 00 00 00 00 ff 00 00 00 00 00 ff ff 00 00 00 00 00 00 f1 ff` followed
      by zeroes. Possibly a capability bitmap.

      Static DP110 draws bits8 and20 from payload2 bits4 and0. Generic reporter routes
      decode payload7,13..14,23..24 as below; these do not prove installed sensors.
      Observed payload21=F1 and22=FF have no established required meaning.
    seq:
      - id: unknown1
        size: 2
        doc: captured 04 00
      - id: data
        size: 43
    instances:
      raw:
        pos: 0
        size: 45
      air_quality_code:
        value: raw[7] & 7
        doc: DP125 six-entry enum code; 6/7 have no table entry (captured FF gives7).
      air_quality:
        value: air_quality_code
        enum: air_quality
        if: air_quality_code < 6
        doc: Generic route, unavailable on captured profile; not proof of installed sensor.
      diagnostic_101:
        value: 256 * raw[13] + raw[14]
        if: raw[13] != 255
        doc: Raw DP101; only high byte has FF guard. Physical meaning unresolved.
      humidity_report_percent:
        value: (256 * raw[23] + raw[24]) / 10
        doc: |
          Generic DP18 integer humidity reporting route, no FF guard. Captured00 reports0;
          no installed humidity sensor proved.
      capability_ext_bits:
        value: '((data[0] & 16) != 0 ? 256 : 0) | ((data[0] & 1) != 0 ? 1048576 : 0)'
  response_05:
    doc: Seen once, answering command 0x05. `04 00` then eight zeroes then 0x02.
    seq:
      - id: unknown1
        size: 2
        doc: captured 04 00
      - id: unknown2
        size: 8
        doc: zeroes
      - id: unknown3
        type: u1
        doc: 0x02, echoing the command
  ext_b:
    doc: |-
      Answer to `query_ext_b` (0x0a). Normally all zero apart from flags 0x04.
      About every two minutes the appliance instead sets flags 0x0c and fills
      in a statistics sample, which the module acknowledges by sending
      request_flags 0x08 in its next query.

      Keep a revisable aggregate until ACK; do not sum repeated polls or globally
      deduplicate equal payloads across cleared cycles. ACK has no tracked reply;
      captures show an ordinary clear response. Read-to-ACK race, retries, overflow
      and reboot retention need appliance tests.

      Static firmware4025b980 reports nonzero DP116,115,135 in that order. Flags do
      not gate eligibility. ACK only after successful sample delivery; all-zero data
      needs no ACK even with flags0C. Physical units remain unconfirmed; panel
      kWh/runtime formulas are inferred, not measurement validation.
    seq:
      - id: unknown1
        size: 2
      - id: flags
        type: u1
      - id: stat_fraction_high
        type: u1
        doc: Highest BCD pair of fractional quantity, payload3.
      - id: stat_integer_lo
        type: u1
      - id: stat_integer_mid
        type: u1
      - id: stat_integer_hi
        type: u1
      - id: unknown3
        size: 8
      - id: stat_value_lo
        type: u1
      - id: stat_value_hi
        type: u1
      - id: stat_intervals
        type: u2le
        doc: |
          Static binary16-bit interval count, payload17..18. Captures show low byte only;
          nominal two-minute
          samples.
      - id: unknown4
        size: 26
    instances:
      stat_value:
        value: ((stat_value_lo >> 4) * 10 + (stat_value_lo & 15)) + 100 * ((stat_value_hi >> 4) * 10 +
          (stat_value_hi & 15)) + 10000 * ((stat_fraction_high >> 4) * 10 + (stat_fraction_high & 15))
        doc: |
          Full six-digit fractional accumulator. Arithmetic matches firmware even for
          invalid BCD nibbles;
          it is not BCD validation.
      stat_fraction:
        value: stat_value % 1000000
        doc: DP116 before schema clamping.
      stat_integer:
        value: stat_value / 1000000 + ((stat_integer_lo >> 4) * 10 + (stat_integer_lo & 15)) + 100 * ((stat_integer_mid
          >> 4) * 10 + (stat_integer_mid & 15)) + 10000 * ((stat_integer_hi >> 4) * 10 + (stat_integer_hi
          & 15))
        doc: DP115 including carry for malformed BCD, before schema clamping.
      sample_has_data:
        value: stat_fraction_high != 0 or stat_integer_lo != 0 or stat_integer_mid != 0 or stat_integer_hi
          != 0 or stat_value_lo != 0 or stat_value_hi != 0 or stat_intervals != 0
  state:
    doc: Full appliance state, 55 bytes. Sent in reply to both set_state and query_state.
    seq:
      - id: unknown1
        size: 2
        doc: bytes 0x05..0x06, captured 04 00
      - id: strong
        type: b1
        doc: byte 0x07 bit 7, turbo
      - id: eco
        type: b1
      - id: display
        type: b1
      - id: power
        type: b1
      - id: mode
        type: b4
        enum: opmode
      - id: unknown3
        type: b1
        doc: byte 0x08 bit 7, captured 1
      - id: fan_speed
        type: b3
        enum: fan_speed
      - id: temp_set_base
        type: b4
        doc: |
          Low four bits of temperature response lookup code; combine with
          temp_set_code_high. Celsius
          table row is whole C, Fahrenheit uses exact lookup.
      - id: on_timer_enabled
        type: b1
        doc: Static response flag; not the app/cloud scheduler.
      - id: off_timer_enabled
        type: b1
      - id: unknown4
        type: b2
      - id: airdry
        type: b1
      - id: health
        type: b1
        doc: Generic health/ionizer route; installed hardware not proved.
      - id: temp_set_half_c
        type: b1
        doc: Celsius half degree. Synthetic/static only; all captured states are Fahrenheit.
      - id: temp_set_code_high
        type: b1
        doc: High bit of temperature table response code, not a Celsius half bit.
      - id: display_units
        type: b1
        doc: True=Fahrenheit, false=Celsius; current units, not a permanent capability.
      - id: vertical_swing
        type: b1
      - id: horizontal_swing
        type: b1
      - id: unknown7
        type: b5
        doc: captured 0
      - id: unknown8
        size: 6
        doc: bytes 0x0b..0x10, zeroes
      - id: indoor_temp_base
        type: u1
        doc: |
          Wire byte0x11. See temp_indoor_in_c for the raw formula and
          room_temperature_report_c for integer
          firmware reporting.
      - id: unknown9
        type: b2
        doc: byte 0x12 bits 7..6, captured 0
      - id: indoor_heat_exchanger_temp_half
        type: b1
        doc: |
          Toggles in lockstep with indoor_heat_exchanger_temp_base. It is the
          0.5 lost when the appliance rounds 2.5 * (degrees C + 20) down to a
          byte.
      - id: unknown10
        type: b1
        doc: captured 0
      - id: indoor_temp_fraction
        type: b2
        doc: Static firmware uses both bits3..2. Captures exercise values0 and2.
      - id: unknown12
        type: b2
        doc: captured 0b11
      - id: four_way_valve_on
        type: b1
        doc: |
          byte 0x13 bit 7. Valve identity is a capture hypothesis, not a stock field.
          Set whenever power is on and for a while after
          power off; stays clear when the unit has been off for a long time.
      - id: unknown13
        type: b3
        doc: captured 0
      - id: unknown14
        type: b1
        doc: captured 1
      - id: sleep
        type: b3
        enum: sleep
        doc: 'Static: three-bit field. Value4 auto exists in firmware but is not offered by the observed
          panel; values0..3 are the local menu.'
      - id: unknown16
        size: 10
        doc: bytes 0x14..0x1d, zeroes
      - id: indoor_heat_exchanger_temp_base
        type: u1
        doc: |
          byte 0x1e, same encoding as indoor_temp_base. Equals it when the unit has been
          off for hours.
      - id: unknown17
        type: u1
        doc: byte 0x1f, captured 0xff
      - id: antifreeze
        type: b1
        doc: byte 0x20 bit 7, 8 degree heating
      - id: unknown18
        type: b1
        doc: captured 1
      - id: unknown19
        type: b6
        doc: captured 0
      - id: mute
        type: b1
        doc: byte 0x21 bit 7
      - id: unknown20
        type: b7
        doc: captured 0
      - id: indoor_fan_speed
        type: u1
        doc: |
          byte 0x22. Actual indoor fan speed, 0 when stopped. Steady state
          values are 0x3c (60) low, 0x55 (85) medium and 0x62 (98) high, but
          0x42, 0x46, 0x48 and 0x50 also appear while ramping and during
          self clean, so retain the raw diagnostic. Units and sensor scaling are
          unconfirmed;
          this field is not consumed by the audited stock reporters.
      - id: outdoor_temp_base
        type: u1
        doc: |
          byte 0x23, observed raw minus20 in C; uncalibrated, not consumed by stock
          reporters.
      - id: condenser_coil_temp_base
        type: u1
        doc: |
          byte 0x24. Outdoor coil sensor, assumed degrees C + 20 like
          outdoor_temp_base: it tracks outdoor_temp_base when the unit is off
          and sits several degrees below it while heating.
      - id: compressor_discharge_temp_base
        type: u1
        doc: |
          byte 0x25. Assumed degrees C + 20 like outdoor_temp_base, which
          gives 55..75 degrees C while the compressor runs. Lags changes in
          condenser_coil_temp_base by a few seconds and moves the other way.
      - id: compressor_frequency
        type: u1
        doc: |
          byte 0x26, raw compressor diagnostic; 0 when stopped, 0x32..0x5c observed
          running. Hz unproved.
      - id: outdoor_fan_speed
        type: u1
        doc: byte 0x27, 0 when stopped, 0x10..0x4a when running, units unknown
      - id: unknown21
        type: b1
        doc: byte 0x28 bit 7, captured 1
      - id: heat_mode
        type: b1
        doc: |
          Set while heating, including with the compressor idle, and for
          a couple of minutes after power off. Clear during cooling and
          self clean.
      - id: unknown22
        type: b2
        doc: captured 0
      - id: outdoor_unit_running
        type: b4
        enum: outdoor_status
        doc: |
          Low nibble0A correlates with running; bits3/1 observed together. Not an exact
          test that both
          raw speeds are nonzero. No stock semantic consumer found; preserve raw.
      - id: unknown23
        size: 4
        doc: |
          Payload36..39 raw fault/status sources; use fault_bitmap for the static DP20
          projection. Captured
          zero does not mean reserved.
      - id: supply_voltage
        type: u1
        doc: |
          byte 0x2d, raw supply diagnostic; 233..244 correlates with nominal240 V, no
          calibrated meter validation.
      - id: current_used_amps
        type: u1
        doc: |
          byte 0x2e, raw current diagnostic; 0..4 observed, whole amps hypothesis
          unvalidated.
      - id: unknown24
        size: 2
        doc: |
          Payload42..43; byte42 contains generator state (FF guard), byte43 capability
          flags. Preserve
          raw.
      - id: unknown25
        type: u1
        doc: 'Wire byte0x31 / payload44: capability flags, captured0x44. Not a humidity measurement. FF
          suppresses this byte in capability packing.'
      - id: unknown26
        type: b4
        doc: byte 0x32 bits 7..4, captured 0b0100
      - id: self_clean
        type: b1
        doc: |-
          byte 0x32 bit 3. Set for the duration of evaporator self cleaning,
          which runs with power off, the compressor and outdoor fan on and
          heat_mode clear.
           Raw bit is unavailable when payload45=FF; use self_clean_active. Immediate start reply may be false before later polls become true.
      - id: unknown27
        type: b3
        doc: captured 0
      - id: unknown28
        type: b2
      - id: up_down_swing
        type: b3
        enum: up_down_swing
      - id: up_down_position
        type: b3
        enum: up_down_position
      - id: unknown29
        type: b2
        doc: byte 0x34 bits 7..6, captured 0
      - id: left_right_swing
        type: b3
        enum: left_right_swing
      - id: left_right_position
        type: b3
        enum: left_right_position
      - id: unknown30
        size: 2
        doc: bytes 0x35..0x36, zeroes
      - id: savemoney_temp
        type: u1
        doc: 'Wire byte0x37 / payload50: mixed capability flags and eco target low nibble. FF suppresses
          projection. Request q4 high nibble receives complement of low nibble; do not decode whole byte
          as degrees C.'
      - id: unknown31
        size: 2
        doc: |
          Payload51..52; byte51 contributes fault bits18..24 unless FF. Preserve byte52
          raw.
      - id: unknown32
        type: b6
        doc: byte 0x3a bits 7..2, captured 0
      - id: unknown33
        type: b1
        doc: |
          byte 0x3a bit 1. Seen set only for about 40 s near the end of a
          self clean, while the indoor coil was hot (0xb4..0xb6, about 53 C)
          and raw current diagnostic peaked at4. No physical phase/progress/completion
          meaning is established; not consumed by audited stock reporters.
      - id: unknown34
        type: b1
        doc: captured 0
      - id: unknown35
        type: u1
        doc: byte 0x3b, captured 0
    instances:
      temp_set_in_c:
        value: 'display_units ? (temp_set_table_f - 32) * 5 / 9.0 : temp_set_table_c + (temp_set_half_c
          ? 0.5 : 0)'
        if: temp_set_table_c >= 0
        doc: |
          In F mode this is a display conversion of the exact F table value, not
          saved-mode C.
      temp_set_in_f:
        value: 'display_units ? temp_set_table_f : temp_set_in_c * 9 / 5.0 + 32'
        if: temp_set_table_c >= 0
      temp_indoor_in_c:
        value: (indoor_temp_base * 4 + indoor_temp_fraction - 200) / 10.0
        doc: |
          Raw formula from static reporter; firmware truncates to integer C before schema
          clamping.
      temp_indoor_in_f:
        value: temp_indoor_in_c * 9 / 5.0 + 32
      temp_indoor_heat_exchanger_in_c:
        value: '(indoor_heat_exchanger_temp_base * 2 + (indoor_heat_exchanger_temp_half ? 1 : 0)) / 5.0
          - 20'
      temp_indoor_heat_exchanger_in_f:
        value: temp_indoor_heat_exchanger_in_c * 9 / 5.0 + 32
      temp_outdoor_in_c:
        value: outdoor_temp_base - 20
      temp_outdoor_in_f:
        value: temp_outdoor_in_c * 9 / 5.0 + 32
      temp_condenser_coil_in_c:
        value: condenser_coil_temp_base - 20
      temp_condenser_coil_in_f:
        value: temp_condenser_coil_in_c * 9 / 5.0 + 32
      temp_compressor_discharge_in_c:
        value: compressor_discharge_temp_base - 20
      temp_compressor_discharge_in_f:
        value: temp_compressor_discharge_in_c * 9 / 5.0 + 32
      raw:
        pos: 0
        size: 55
        doc: |
          Original payload, including all unknown/sentinel bits. Offsets into raw are
          payload offsets
          (wire offset minus five).
      temp_set_code:
        value: 'temp_set_base + (temp_set_code_high ? 16 : 0)'
      temp_set_table_c:
        value: 'temp_set_code == 0 ? 16 : temp_set_code == 16 ? 16 : temp_set_code == 1 ? 17 : temp_set_code
          == 2 ? 18 : temp_set_code == 18 ? 18 : temp_set_code == 3 ? 19 : temp_set_code == 19 ? 19 :
          temp_set_code == 4 ? 20 : temp_set_code == 20 ? 20 : temp_set_code == 5 ? 21 : temp_set_code
          == 21 ? 21 : temp_set_code == 6 ? 22 : temp_set_code == 7 ? 23 : temp_set_code == 23 ? 23 :
          temp_set_code == 8 ? 24 : temp_set_code == 24 ? 24 : temp_set_code == 9 ? 25 : temp_set_code
          == 25 ? 25 : temp_set_code == 10 ? 26 : temp_set_code == 26 ? 26 : temp_set_code == 11 ? 27
          : temp_set_code == 12 ? 28 : temp_set_code == 28 ? 28 : temp_set_code == 13 ? 29 : temp_set_code
          == 29 ? 29 : temp_set_code == 14 ? 30 : temp_set_code == 30 ? 30 : temp_set_code == 15 ? 31
          : temp_set_code == 31 ? 31 : -1'
        doc: Static flash40201380; -1 means unknown code.
      temp_set_table_f:
        value: 'temp_set_code == 0 ? 61 : temp_set_code == 16 ? 62 : temp_set_code == 1 ? 63 : temp_set_code
          == 2 ? 64 : temp_set_code == 18 ? 65 : temp_set_code == 3 ? 66 : temp_set_code == 19 ? 67 :
          temp_set_code == 4 ? 68 : temp_set_code == 20 ? 69 : temp_set_code == 5 ? 70 : temp_set_code
          == 21 ? 71 : temp_set_code == 6 ? 72 : temp_set_code == 7 ? 73 : temp_set_code == 23 ? 74 :
          temp_set_code == 8 ? 75 : temp_set_code == 24 ? 76 : temp_set_code == 9 ? 77 : temp_set_code
          == 25 ? 78 : temp_set_code == 10 ? 79 : temp_set_code == 26 ? 80 : temp_set_code == 11 ? 81
          : temp_set_code == 12 ? 82 : temp_set_code == 28 ? 83 : temp_set_code == 13 ? 84 : temp_set_code
          == 29 ? 85 : temp_set_code == 14 ? 86 : temp_set_code == 30 ? 87 : temp_set_code == 15 ? 88
          : temp_set_code == 31 ? 89 : -1'
        doc: |
          Static lookup, not linear conversion. 89F is decodable but above panel
          selectable maximum88F.
      room_temperature_numerator:
        value: indoor_temp_base * 4 + indoor_temp_fraction - 200
      room_temperature_report_c:
        value: 'room_temperature_numerator < 0 ? -((-room_temperature_numerator) / 10) : room_temperature_numerator
          / 10'
        doc: Explicit division toward zero, before unknown product-schema bounds.
      reset_related_flag:
        value: (raw[10] & 128) != 0
        doc: |
          Stock reset-event path sends command06; no proved appliance reset semantics. Do
          not act automatically.
      hot_cold_wind_active:
        value: (raw[27] & 24) != 0
        doc: DP132 ORs both flags and loses which was set; no FF guard.
      generator_mirrored_group:
        value: (raw[42] >> 2) & 7
        if: raw[42] != 255
        doc: Opaque group copied to request13 bits4..2, mirrored into bits7..5 only when <4.
      filter_related_active:
        value: (raw[45] & 4) != 0
        if: raw[45] != 255
        doc: Generic filter-related bit; reset semantics unresolved.
      photosensitive_active:
        value: (raw[45] & 1) != 0
        if: raw[45] != 255
      generic_dp131:
        value: (raw[45] & 2) != 0
        if: raw[45] != 255
        doc: Generic reported boolean; no accepted rich setter, physical meaning unresolved.
      eco_graph_status:
        value: (raw[46] & 64) != 0
        if: raw[46] != 255
        doc: Stock graph/status route; not another louver enable bit.
      eco_amount_low:
        value: raw[48]
        if: raw[48] != 255
        doc: Independently guarded copy to request25.
      eco_amount_high:
        value: raw[49]
        if: raw[49] != 255
        doc: Independently guarded copy to request26.
      eco_amount_raw:
        value: raw[48] + 256 * raw[49]
        doc: Raw LE pair, not physical units; copy each byte only under its own FF guard.
      eco_target_code:
        value: raw[50] & 15
        if: raw[50] != 255
        doc: Complement copied to request4 high nibble, separate from normal target.
      self_clean_active:
        value: (raw[45] & 8) != 0
        if: raw[45] != 255
      soft_wind_active:
        value: (raw[45] & 32) != 0
        if: raw[45] != 255
      health_active:
        value: (raw[4] & 4) != 0
      airdry_active:
        value: (raw[4] & 8) != 0
      eco_strategy:
        value: (raw[28] >> 4) & 7
      vertical_range:
        value: '(raw[5] & 64) != 0 ? (((raw[46] >> 3) & 7) == 0 ? 1 : ((raw[46] >> 3) & 7)) : 0'
        if: raw[46] != 255
      vertical_position:
        value: 'vertical_range != 0 ? 0 : (raw[46] & 7)'
        if: raw[46] != 255
      horizontal_range:
        value: '(raw[5] & 32) != 0 ? (((raw[47] >> 3) & 7) == 0 ? 1 : ((raw[47] >> 3) & 7)) : 0'
        if: raw[47] != 255
      horizontal_position:
        value: 'horizontal_range != 0 ? 0 : ((raw[5] & 8) == 0 and (raw[27] & 32) != 0 ? 8 : (raw[47]
          & 7))'
        if: raw[47] != 255
      fault_0:
        value: ((raw[36] & 1) != 0) or ((raw[11] & 8) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_1:
        value: ((raw[11] & 64) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_2:
        value: ((raw[11] & 128) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_3:
        value: ((raw[36] & 4) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_4:
        value: ((raw[36] & 8) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_5:
        value: ((raw[36] & 16) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_6:
        value: ((raw[11] & 32) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_7:
        value: ((raw[36] & 32) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_8:
        value: ((raw[36] & 64) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_9:
        value: ((raw[39] & 16) != 0) or ((raw[36] & 128) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_10:
        value: ((raw[37] & 2) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_11:
        value: ((raw[11] & 2) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_12:
        value: ((raw[36] & 2) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_13:
        value: ((raw[37] & 4) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_14:
        value: ((raw[37] & 1) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_15:
        value: ((raw[37] & 8) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_16:
        value: ((raw[37] & 16) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_17:
        value: ((raw[37] & 32) != 0)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_18:
        value: ((raw[51] & 1) != 0 and raw[51] != 255)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_19:
        value: ((raw[51] & 2) != 0 and raw[51] != 255)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_20:
        value: ((raw[51] & 4) != 0 and raw[51] != 255)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_21:
        value: ((raw[51] & 8) != 0 and raw[51] != 255)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_22:
        value: ((raw[51] & 16) != 0 and raw[51] != 255)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_23:
        value: ((raw[51] & 32) != 0 and raw[51] != 255)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_24:
        value: ((raw[51] & 64) != 0 and raw[51] != 255)
        doc: Unnamed static DP20 bit; no fault-active capture. Raw source bits retained.
      fault_bitmap:
        value: '(fault_0 ? 1 : 0) | (fault_1 ? 2 : 0) | (fault_2 ? 4 : 0) | (fault_3 ? 8 : 0) | (fault_4
          ? 16 : 0) | (fault_5 ? 32 : 0) | (fault_6 ? 64 : 0) | (fault_7 ? 128 : 0) | (fault_8 ? 256 :
          0) | (fault_9 ? 512 : 0) | (fault_10 ? 1024 : 0) | (fault_11 ? 2048 : 0) | (fault_12 ? 4096
          : 0) | (fault_13 ? 8192 : 0) | (fault_14 ? 16384 : 0) | (fault_15 ? 32768 : 0) | (fault_16 ?
          65536 : 0) | (fault_17 ? 131072 : 0) | (fault_18 ? 262144 : 0) | (fault_19 ? 524288 : 0) | (fault_20
          ? 1048576 : 0) | (fault_21 ? 2097152 : 0) | (fault_22 ? 4194304 : 0) | (fault_23 ? 8388608 :
          0) | (fault_24 ? 16777216 : 0)'
        doc: Static DP20; bits0 and9 merge sources. Only payload51 has an FF guard.
      capability_state_bits:
        value: '(raw[50] != 255 and (raw[50] & 64) != 0 ? 1 : 0) | (raw[50] != 255 and (raw[50] & 32)
          != 0 ? 2 : 0) | ((raw[3] & 128) != 0 ? 4 : 0) | (raw[45] != 255 and (raw[45] & 64) != 0 ? 8
          : 0) | (raw[44] != 255 and (raw[44] & 64) != 0 ? 16 : 0) | (raw[50] != 255 and (raw[50] & 16)
          != 0 ? 32 : 0) | (raw[44] != 255 and (raw[44] & 1) != 0 ? 64 : 0) | (raw[44] != 255 and (raw[44]
          & 8) != 0 ? 128 : 0) | (raw[44] != 255 and (raw[44] & 4) != 0 ? 512 : 0) | (raw[44] != 255 and
          (raw[44] & 32) != 0 ? 1024 : 0) | (raw[43] != 255 and (raw[43] & 32) != 0 ? 2048 : 0) | ((raw[27]
          & 2) != 0 ? 4096 : 0) | ((raw[27] & 4) != 0 ? 8192 : 0) | (raw[43] != 255 and (raw[43] & 64)
          != 0 ? 16384 : 0) | ((raw[5] & 8) != 0 ? 32768 : 0) | ((raw[27] & 64) != 0 ? 131072 : 0) | (raw[44]
          != 255 and (raw[44] & 2) != 0 ? 262144 : 0) | ((raw[5] & 128) != 0 ? 2097152 : 0) | (raw[44]
          != 255 and (raw[44] & 16) != 0 ? 4194304 : 0) | ((raw[27] & 1) != 0 ? 8388608 : 0)'
        doc: |
          OR with ext_a.capability_ext_bits to obtain DP110. Bit21 is mutable Fahrenheit
          state.
      extended_protocol:
        value: ((raw[3] & 128) != 0) or ((raw[27] & 7) != 0) or (raw[43] != 255 and (raw[43] & 32) !=
          0) or (raw[44] != 255 and (raw[44] & 127) != 0) or (raw[45] != 255 and (raw[45] & 64) != 0)
          or (raw[47] != 255 and (raw[47] & 64) != 0) or (raw[50] != 255 and (raw[50] & 112) != 0)
        doc: Static branch detector. Stock latches first response decision.
      generator_level:
        value: 'raw[42] == 255 ? 0 : raw[42] & 3'
        doc: |
          Stock reporting maps FF to off; this is not proof of actual generator state or
          exposed control.
      style_code:
        value: (raw[14] >> 3) & 15
      device_style:
        value: style_code / 2
        if: style_code < 4
        doc: Static artwork selector, not another control.
enums:
  air_quality:
    0: great
    1: good
    2: middle
    3: bad
    4: verybad
    5: veryverybad
  source:
    1: controller
    256: appliance
  command:
    3: set_state_response
    4: query_state_response
    9: query_ext_a_response
    10: query_ext_b_response
    11: set_clock_response
    5: command_05_response
  fan_speed:
    0: auto
    1: low
    2: medium
    3: high
    4: mid_low
    5: mid_high
  opmode:
    1: cool
    2: fan
    3: dehumidify
    4: heat
    5: auto
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
  outdoor_status:
    0: idle
    10: running
