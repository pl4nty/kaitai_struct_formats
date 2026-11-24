# Imported from https://github.com/P1sec/DiagNG/blob/ebff1c3d50e0872fb7db93faf9909da4954095bf/struct/qualcomm/diag/command/diag_log_f.ksy
# Licence and copyright: see _community/README.md
meta:
  id: diag_log_f
  title: Qualcomm DIAG log packet (DIAG_LOG_F)
  license: GPL-3.0-only
  imports:
    - diag_logging
    - wcdma_signaling_message
    - gsm_rr_signaling_message
    - lte_rrc_ota_packet
    - nr5g_rrc_ota_packet
  endian: le

# From _base_input.py in QCSuper

seq:
  - id: pending_msgs
    type: u1
  - id: len_inner_log
    type: u2
  - id: inner_log
    size: len_inner_log
    type: inner_log

types:
  inner_log:
    seq:
      - id: log_inner_length
        type: u2
      - id: log_code
        type: u2
        enum: diag_logging::log_code
      - id: log_time # <== Post-process this in code? See dlf_read.py
        type: u8
      - id: content
        size: log_inner_length - 12
        type:
          switch-on: log_code
          cases:
            'diag_logging::log_code::wcdma_signaling_message': wcdma_signaling_message # 0x412f
            'diag_logging::log_code::gsm_rr_signaling_message': gsm_rr_signaling_message # 0x512f
            'diag_logging::log_code::lte_rrc_ota_packet': lte_rrc_ota_packet # 0xb0c0
            'diag_logging::log_code::nr5g_rrc_ota_packet': nr5g_rrc_ota_packet # 0xb821
            # TODO process all types supported by QCSuper in "pcap_dump.py"
    instances:
      unix_ts:
        value: |
          (log_time > 946681200 and
           log_time < 4102441200) ?
          log_time :
           315964800 +
           (log_time >> 16).as<f8> / 800 +
           ((log_time & 0xffff).as<f8> / 0xC000 / 800)

    enums:
      ref_ts:
        315964800: epoch_1980 # 1980-01-06 from 1970-01-01, in seconds
        946681200: min_ts_unix # 2000-01-01 from 1970-01-01, in seconds
        4102441200: max_ts_unix # 2100-01-01 from 1970-01-01, in seconds
        33067703992320000: min_ts_16bitmantissa # 2000-01-01 from 1980-01-06, in 1/800s ticks, 16 bit matissa
        198520413880320000: max_ts_16bitmantissa # 2100-01-01 from 1980-01-06, in 1/800s ticks, 16 bit matissa
        # 33067703992320000: min_ts_20bitmantissa # 2000-01-01 from 1980-01-06, in 1/50s ticks, 20 bit matissa
        # 198520413880320000: max_ts_20bitmantissa # 2100-01-01 from 1980-01-06, in 1/50s ticks, 20 bit matissa

# WIP XX
