# Imported from https://github.com/eset/malware-research/blob/f879e217b726ff883e2c23fb5d8c5f5d69a9cacf/oceanlotus/ol_backdoor_conf.ksy
meta:
  id: oceanlotus_backdoor_config
  title: OceanLotus backdoor configuration
  license: BSD-2-Clause
  endian: le
seq:
  - id: total_length
    type: u4
  - id: data_n
    type: data_struct
types:
  utf16_str:
    seq:
      - id: str_len
        type: u4
      - id: str_buf
        size: str_len
        type: str
        encoding: UTF-16LE
  data_struct:
    seq:
      - id: reg_part_len
        type: u4
      - id: domain_encoding_str
        type: utf16_str
      - id: first_reg
        type: utf16_str
      - id: second_reg
        type: utf16_str
      - id: reg_value
        type: utf16_str
      - id: mutex_encoding_str
        type: utf16_str
      - id: domain_part_len
        type: u4
      - id: domains_str
        type: utf16_str
        repeat: expr
        repeat-expr: 3
      - id: httpprov_len
        type: u4
      - id: httpprov
        size: httpprov_len
      - id: backdoor_version_len
        type: u4
      - id: backdoor_version
        size: backdoor_version_len
      - id: unknown_len
        type: u4
      - id: unknown
        size: unknown_len
