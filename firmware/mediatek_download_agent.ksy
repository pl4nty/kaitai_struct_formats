# Imported from https://github.com/cyrozap/mediatek-lte-baseband-re/blob/8c01efae5a9784ec8c84b4a4087678860de98e20/SoC/mediatek_download_agent.ksy
meta:
  id: mediatek_download_agent
  title: MediaTek Download Agent Archive
  license: CC0-1.0
  endian: le
seq:
  - id: header
    type: header
  - id: da_list
    size: 220
    type: da_entry
    repeat: expr
    repeat-expr: header.da_count

types:
  header:
    seq:
      - id: da_description
        size: 32
        type: strz
        encoding: ASCII
      - id: da_identifier
        size: 64
        type: strz
        encoding: ASCII
      - id: info_ver
        type: u4
        doc: Should be 4
      - id: info_magic
        type: u4
        doc: Should be 0x22668899
      - id: da_count
        type: u4
  da_entry:
    seq:
      - id: magic
        contents: [0xDA, 0xDA]
      - id: bbchip_hw_code
        type: u2
      - id: bbchip_hw_sub_code
        type: u2
      - id: bbchip_hw_version
        type: u2
      - id: bbchip_sw_version
        type: u4
      - id: unk2
        type: u4
      - id: unk3
        type: u1
      - id: unk4
        type: u1
      - id: load_region_count
        type: u2
      - id: regions
        type: da_region
        repeat: expr
        repeat-expr: load_region_count
  da_region:
    seq:
      - id: buf_offset
        type: u4
      - id: len
        type: u4
      - id: start_addr
        type: u4
      - id: sig_offset
        type: u4
      - id: sig_len
        type: u4
    instances:
      buf:
        io: _root._io
        pos: buf_offset
        size: len
      sig:
        io: _root._io
        pos: buf_offset + sig_offset
        size: sig_len
