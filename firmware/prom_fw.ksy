# Imported from https://github.com/cyrozap/asmedia-xhc-re/blob/010e8a31833a159e298898da7167d3b8926a6849/doc/fw/prom_fw.ksy
meta:
  id: prom_fw
  title: Promontory Firmware Image
  license: CC0-1.0
  endian: le
seq:
  - id: header
    type: header
  - id: body
    size: header.len - 12
    type: body
types:
  header:
    seq:
      - id: magic
        contents: "_PT_"
      - id: len
        type: u4
      - id: checksum
        type: u4
        doc: 32-bit sum of all the bytes in body.firmware.
  body:
    seq:
      - id: firmware
        size: _io.size - (_io.size & 0xff)  # Exclude the signature, if present
        type: firmware
      - id: signature
        type: signature
        if: (_io.size & 0xff) != 0
        doc: An HMAC-SHA256 digest of body.firmware.
    types:
      firmware:
        seq:
          - id: code
            size-eos: true
        instances:
          version:
            pos: 0x80
            size: 6
          magic:
            pos: 0x87
            size: 8
            type: str
            encoding: ASCII
      signature:
        instances:
          encoded_start:
            pos: _root.body.firmware._io.size + 1
            type: u1
          encoded_15180_high_nybble:
            pos: _root.body.firmware._io.size + 2
            type: u1
          actual_start:
            value: '(encoded_start >> 1) & 0x3f'
          actual_15180_high_nybble:
            value: '(encoded_15180_high_nybble << 2) & 0xf0'
          data:
            pos: _root.body.firmware._io.size + actual_start
            size: 0x20
