# Imported from https://github.com/anvilsecure/SAPCARve/blob/5bcb35def66ba5a8541aa882b29cce8f3e5138cf/sar.ksy
meta:
  id: sapcar
  file-extension: sar
  license: LicenseRef-All-Rights-Reserved
  endian: le

# Adapted from https://github.com/OWASP/pysap/blob/d930e400f1949577c6bfb494cd8525f27ef4f32d/pysap/SAPCAR.py
seq:
  - id: header
    type: header
  - id: files
    type: file
    repeat: eos

types:
  header:
    doc: SAP CAR archive format
    seq:
      - id: magic
        size: 4
        type: str
        encoding: UTF-8
      - id: version
        size: 4
        type: str
        encoding: UTF-8
  
  file:
    doc: SAP CAR file format inside the archive
    seq:
      - id: type
        size: 2
        type: str
        encoding: UTF-8
      - id: perm_mode
        type: u4
      - id: file_length_low
        type: u8
      - id: file_length_high
        type: u4
      - id: timestamp
        type: u8
      - id: code_page
        type: u4
      - id: len_user_info
        type: u2
      - id: len_filename
        type: u2
      - id: filename
        size: len_filename
        type: str
        encoding: UTF-8
      - id: user_info
        size: len_user_info
      - id: blocks
        type: block
        repeat: until
        repeat-until: _.type == "ED" or _.type == "UE"
        if: type == 'RG'
        
  block:
    doc: SAP CAR block format
    seq:
      - id: type
        size: 2
        type: str
        encoding: UTF-8
      - id: compressed
        type: block_compressed
        if: type == "ED" or type == "DA"
      - id: checksum
        type: u4
        if: type == "ED"
    instances:
      is_compressed:
        value: type == "ED" or type == "DA"
        
  block_compressed:
    doc: SAP CAR compressed block
    seq:
      - id: compressed_length
        type: u4
      - id: uncompressed_length
        type: u4
      - id: algorithm_and_version
        type: u1
      - id: magic_bytes
        contents: [0x1f, 0x9d]
      - id: special
        type: u1
      - id: blob
        size: compressed_length - 8
    instances:
      algorithm:
        value: algorithm_and_version & 0x0F
        enum: algorithms
      version:
        value: (algorithm_and_version >> 4) & 0x0F
    enums:
      algorithms:
        0: alg_lzc
        2: alg_lzh
