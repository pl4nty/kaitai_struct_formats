# Imported from https://github.com/P1sec/DiagNG/blob/ebff1c3d50e0872fb7db93faf9909da4954095bf/struct/qualcomm/diag/stream.ksy

meta:
  id: qualcomm_diag_stream
  title: Qualcomm DIAG stream
  license: GPL-3.0-only
  imports:
    - diag_response
  endian: le

seq:
  - id: frames
    type: diag_response
    terminator: 0x7e
    include: true
    # hdlc_decode will remove escapes
    # (0x7d 0x5e -> 0x7e, 0x7d 0x5d -> 0x7d)
    # + check and remove CRC-16
    # and trailer char at end at stream
    # if present and valid, else fail
    process: diagng.protocol.qualcomm.utils.hdlc.hdlc_decoder
    repeat: eos
