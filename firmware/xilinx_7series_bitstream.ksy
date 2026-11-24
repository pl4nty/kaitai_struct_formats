meta:
  id: xilinx_7series_bitstream
  title: Xilinx 7 series FPGA configuration bitstream
  application:
    - Xilinx ISE BitGen
    - Xilinx Vivado
  file-extension: bin
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  Configuration data stream of Xilinx (AMD) 7 series FPGAs (Spartan-7,
  Artix-7, Kintex-7, Virtex-7) and of the programmable logic of Zynq-7000
  SoCs, as written by BitGen / Vivado `write_bitstream -bin_file` (.bin
  files), and as the body of .bit files after their header.

  The stream is a sequence of 32-bit big-endian words (the byte order of
  an unswapped bitstream). It starts with dummy pad words (0xFFFFFFFF)
  and the bus width auto detection pattern (0x000000BB, 0x11220044),
  which are ignored until the sync word 0xAA995566. After it, every
  word is a configuration packet header or a data word of the preceding
  packet:

  * Type 1 packets read or write one of the configuration registers; the
    header carries the register address and the number of data words
    (up to 2047).
  * Type 2 packets have no address: they continue the register of the
    previous Type 1 packet with a 27-bit word count, and are used to load
    the frame data (FDRI) in one block.

  Data words follow the header only for write packets; for a read packet
  the device sends the data out instead. Single-word writes of the
  documented registers are decoded into their bit fields; frame data
  (FDRI), the AES initial vector (CBC) and other blocks are left raw.

  This spec covers only this packet layer. Interpreting the stream needs
  state that is not visible here: commands take effect in order, writes
  to CTL0/CTL1 are masked by MASK, and frame data is placed according to
  the FAR register and its auto-increment. Note that, per the reports of
  the authors of Project X-Ray, debug and per-frame-CRC bitstreams from
  the vendor tools can contain words not preceded by a packet header
  (an all-zero frame after a row switch); such words show up here as
  packets with header type 0 and no data. The header of .bit files (a
  tag-length-value list with design name, part, date and time) is not
  covered; parse the data after it, or a .bin file.
doc-ref:
  - https://docs.amd.com/v/u/en-US/ug470_7Series_Config
seq:
  - id: preamble
    type: u4
    repeat: until
    repeat-until: _ == 0xaa995566
    doc: |
      Dummy pad words and the bus width auto detection pattern, up to and
      including the sync word 0xAA995566 (UG470 tables 5-2, 5-3, 5-19).
  - id: packets
    type: 'packet(_index == 0 ? 0xffff : packets[_index - 1].effective_register)'
    repeat: eos
types:
  packet:
    doc-ref: https://docs.amd.com/v/u/en-US/ug470_7Series_Config UG470 tables 5-20 to 5-22
    params:
      - id: prev_register
        type: u2
        doc: |
          Register addressed by the previous packet (0xFFFF for the first
          packet); a Type 2 packet writes to it.
    seq:
      - id: header
        type: u4
        doc: Packet header word.
      - id: data
        size: num_words * 4
        type:
          switch-on: 'num_words == 1 ? effective_register : 0xffff'
          cases:
            'register::crc.to_i': reg_word
            'register::far.to_i': reg_far
            'register::cmd.to_i': reg_cmd
            'register::ctl0.to_i': reg_ctl0
            'register::mask.to_i': reg_word
            'register::lout.to_i': reg_word
            'register::cor0.to_i': reg_cor0
            'register::idcode.to_i': reg_word
            'register::axss.to_i': reg_word
            'register::cor1.to_i': reg_cor1
            'register::wbstar.to_i': reg_wbstar
            'register::timer.to_i': reg_timer
            'register::rbcrc_sw.to_i': reg_word
            'register::ctl1.to_i': reg_word
        if: opcode == opcode::write
        doc: |
          Data words written to the register. Single-word writes of the
          registers documented in UG470 are decoded; anything else, in
          particular FDRI frame data (frames of 101 words each), is raw.
    instances:
      header_type:
        value: header >> 29
        enum: header_type
        doc: Header type, bits 31-29.
      opcode:
        value: (header >> 27) & 0b11
        enum: opcode
        doc: Opcode, bits 28-27.
      register_address:
        value: (header >> 13) & 0x3fff
        if: header_type == header_type::type1
        doc: |
          Register address, bits 26-13 of a Type 1 header; only the low 5
          bits are used in 7 series FPGAs.
      word_count:
        value: |
          header_type == header_type::type1 ? header & 0x7ff
          : header_type == header_type::type2 ? header & 0x7ffffff
          : 0
        doc: |
          Number of data words, bits 10-0 of a Type 1 header or bits 26-0
          of a Type 2 header (0 for any other header type).
      effective_register:
        value: 'header_type == header_type::type1 ? register_address : prev_register'
        doc: Register this packet reads or writes.
      register:
        value: effective_register
        enum: register
      num_words:
        value: 'opcode == opcode::write ? word_count : 0'
        doc: Number of data words present in the stream after the header.
  reg_word:
    doc: A register value without decoded fields.
    seq:
      - id: value
        type: u4
  reg_far:
    doc: Frame Address Register (FAR, UG470 table 5-24).
    seq:
      - id: reserved
        type: b6
      - id: block_type
        type: b3
        enum: block_type
      - id: is_bottom
        type: b1
        doc: Selects bottom-half rows (true) or top-half rows (false).
      - id: row
        type: b5
        doc: Row address; increments from center to top, then from center to bottom.
      - id: column
        type: b10
        doc: Major column address, starting at 0 on the left.
      - id: minor
        type: b7
        doc: Frame within the major column.
  reg_cmd:
    doc: Command Register (CMD, UG470 table 5-25).
    seq:
      - id: reserved
        type: b27
      - id: command
        type: b5
        enum: command
  reg_ctl0:
    doc: |
      Control Register 0 (CTL0, UG470 tables 5-26 and 5-27); writes are masked by
      MASK.
    seq:
      - id: efuse_key
        type: b1
        doc: AES key source; false = battery-backed RAM, true = eFUSE.
      - id: icap_select
        type: b1
        doc: false = top ICAPE2 port enabled, true = bottom ICAPE2 port enabled.
      - id: reserved1
        type: b17
      - id: over_temp_power_down
        type: b1
        doc: Enables the XADC over-temperature power down.
      - id: reserved2
        type: b1
      - id: config_fallback
        type: b1
        doc: When set, disables fallback to the default bitstream on configuration failure.
      - id: reserved3
        type: b1
      - id: glutmask_b
        type: b1
        doc: When clear, masks readback of changeable memory cells (distributed RAM, SRL).
      - id: farsrc
        type: b1
        doc: Output of FAR[23:0]; false = EFAR (ECC error frame), true = FAR (RBCRC).
      - id: dec
        type: b1
        doc: AES decryptor enable.
      - id: sbits
        type: b2
        enum: security_level
      - id: persist
        type: b1
        doc: The configuration interface remains after configuration.
      - id: reserved4
        type: b2
      - id: gts_usr_b
        type: b1
        doc: Active-low global 3-state of I/Os; false = I/Os 3-stated, true = I/Os active.
  reg_cor0:
    doc: Configuration Options Register 0 (COR0, UG470 tables 5-30 and 5-31).
    seq:
      - id: reserved1
        type: b4
      - id: pwrdwn_stat
        type: b1
        doc: Changes the DONE pin to a power-down status pin.
      - id: reserved2
        type: b1
      - id: done_pipe
        type: b1
        doc: Adds a pipeline stage for DONEIN.
      - id: drive_done
        type: b1
        doc: DONE is actively driven high instead of open drain.
      - id: single
        type: b1
        doc: Readback is single-shot.
      - id: oscfsel
        type: b6
        doc: CCLK frequency selection in master modes.
      - id: ssclksrc
        type: b2
        enum: startup_clock
      - id: done_cycle
        type: b3
        enum: startup_release_phase
        doc: Startup cycle to release the DONE pin.
      - id: match_cycle
        type: b3
        enum: startup_stall_phase
        doc: Startup cycle to stall in until DCI matches.
      - id: lock_cycle
        type: b3
        enum: startup_stall_phase
        doc: Startup cycle to stall in until MMCMs lock.
      - id: gts_cycle
        type: b3
        enum: startup_release_phase
        doc: Startup cycle to deassert GTS.
      - id: gwe_cycle
        type: b3
        enum: startup_release_phase
        doc: Startup phase to assert GWE.
  reg_cor1:
    doc: Configuration Options Register 1 (COR1, UG470 tables 5-32 and 5-33).
    seq:
      - id: reserved1
        type: b14
      - id: persist_deassert_at_desync
        type: b1
        doc: Enables deassertion of PERSIST with the DESYNC command.
      - id: rbcrc_action
        type: b2
        enum: rbcrc_action
      - id: reserved2
        type: b5
      - id: rbcrc_no_pin
        type: b1
        doc: Disables INIT_B as readback CRC error status output pin.
      - id: rbcrc_en
        type: b1
        doc: Enables continuous readback CRC.
      - id: reserved3
        type: b4
      - id: bpi_1st_read_cycle
        type: b2
        doc: First byte read timing, in CCLK cycles minus 1.
      - id: bpi_page_size
        type: b2
        enum: bpi_page_size
  reg_wbstar:
    doc: Warm Boot Start Address Register (WBSTAR, UG470 tables 5-34 and 5-35).
    seq:
      - id: rs
        type: b2
        doc: RS[1:0] pin value on next warm boot.
      - id: rs_ts_b
        type: b1
        doc: When set, RS[1:0] are driven (3-state disabled) on next warm boot.
      - id: start_addr
        type: b29
        doc: Next bitstream start address.
  reg_timer:
    doc: Watchdog Timer Register (TIMER, UG470 tables 5-36 and 5-37).
    seq:
      - id: timer_usr_mon
        type: b1
        doc: Watchdog is enabled during user mode.
      - id: timer_cfg_mon
        type: b1
        doc: Watchdog is enabled during configuration.
      - id: timer_value
        type: b30
        doc: Watchdog time-out value; the watchdog clock is about 125 to 380 kHz.
enums:
  header_type:
    1: type1
    2: type2
  opcode:
    0: nop
    1: read
    2: write
    3: reserved
  register:
    0x00:
      id: crc
      doc: CRC Register
    0x01:
      id: far
      doc: Frame Address Register
    0x02:
      id: fdri
      doc: Frame Data Register, Input (write configuration data)
    0x03:
      id: fdro
      doc: Frame Data Register, Output (read configuration data)
    0x04:
      id: cmd
      doc: Command Register
    0x05:
      id: ctl0
      doc: Control Register 0
    0x06:
      id: mask
      doc: Masking Register for CTL0 and CTL1
    0x07:
      id: stat
      doc: Status Register
    0x08:
      id: lout
      doc: Legacy Output Register for daisy chain
    0x09:
      id: cor0
      doc: Configuration Option Register 0
    0x0a:
      id: mfwr
      doc: Multiple Frame Write Register
    0x0b:
      id: cbc
      doc: Initial CBC Value Register
    0x0c:
      id: idcode
      doc: Device ID Register
    0x0d:
      id: axss
      doc: User Access Register
    0x0e:
      id: cor1
      doc: Configuration Option Register 1
    0x10:
      id: wbstar
      doc: Warm Boot Start Address Register
    0x11:
      id: timer
      doc: Watchdog Timer Register
    0x13:
      id: rbcrc_sw
      doc: Precomputed Readback CRC Register
    0x16:
      id: bootsts
      doc: Boot History Status Register
    0x18:
      id: ctl1
      doc: Control Register 1
    0x1f:
      id: bspi
      doc: BPI/SPI Configuration Options Register
  command:
    0x00: 'null'
    0x01:
      id: wcfg
      doc: Write configuration data, used prior to writing FDRI.
    0x02:
      id: mfw
      doc: Multiple frame write.
    0x03:
      id: dghigh_lfrm
      doc: Last frame; deasserts GHIGH_B.
    0x04:
      id: rcfg
      doc: Read configuration data, used prior to reading FDRO.
    0x05:
      id: start
      doc: Begin the startup sequence.
    0x06:
      id: rcap
      doc: Reset the CAPTURE signal after single-shot readback capture.
    0x07:
      id: rcrc
      doc: Reset the CRC register.
    0x08:
      id: aghigh
      doc: Assert GHIGH_B.
    0x09:
      id: switch
      doc: Switch the CCLK frequency to COR0 OSCFSEL.
    0x0a:
      id: grestore
      doc: Pulse the GRESTORE signal.
    0x0b:
      id: shutdown
      doc: Begin the shutdown sequence.
    0x0c:
      id: gcapture
      doc: Pulse GCAPTURE.
    0x0d:
      id: desync
      doc: Reset DALIGN; a new sync word is needed afterwards.
    0x0f:
      id: iprog
      doc: Internal PROG, triggers a warm boot.
    0x10:
      id: crcc
      doc: Recalculate the first readback CRC value.
    0x11:
      id: ltimer
      doc: Reload the watchdog timer.
    0x12:
      id: bspi_read
      doc: BPI/SPI re-initiate bitstream read.
    0x13:
      id: fall_edge
      doc: Switch to falling-edge capture of configuration data.
  block_type:
    0: clb_io_clk
    1: block_ram
    2: cfg_clb
  security_level:
    0: read_write
    1: readback_disabled
    2: write_read_disabled
    3: write_read_disabled_alt
  startup_clock:
    0: cclk
    1: user_clk
    2: jtag_clk
    3: jtag_clk_alt
  startup_release_phase:
    0: phase1
    1: phase2
    2: phase3
    3: phase4
    4: phase5
    5: phase6
    6:
      id: tracks_done
      doc: GTS or GWE tracks the DONE pin (not defined for DONE_CYCLE).
    7: keep
  startup_stall_phase:
    0: phase0
    1: phase1
    2: phase2
    3: phase3
    4: phase4
    5: phase5
    6: phase6
    7: no_wait
  rbcrc_action:
    0: continue_operation
    1: halt
    2: correct_and_continue
    3: correct_and_halt
  bpi_page_size:
    0: one_word
    1: four_words
    2: eight_words
