# Imported from https://github.com/NetherlandsForensicInstitute/teslalogs/blob/150e1906a7e3d452a5c00faffed5764177e62b64/teslalogs/model_3/Model3_CLB.ksy
# Licence and copyright: see _community/README.md
meta:
  id: tesla_model_3_clb
  title: Model3 CLB
  license: Apache-2.0
  imports:
    - /common/vlq_base128_le
  endian: be

seq:
  - id: obj
    type: log_object
    repeat: eos

types:
  log_object:
    seq:
      - id: number
        type: u1
      - id: len
        type: u2
      - id: crc
        type: u4
      - id: body
        size: len
        type: body
    instances:
      raw_body:
        pos: _io.pos - len  # Rewind stream back to start
        size: len  # Consume up to the next one
  body:
    seq:
      - id: varints
        type: vlq_base128_le
        repeat: eos
