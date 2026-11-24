# Imported from https://github.com/ascenttree/kaitai-structs/blob/8cefaae9b8d13f181318f1ef35c3a9994ec6c2e3/common/net_string.ksy
meta:
  id: ktf_net_string
  title: .NET BinaryWriter length-prefixed string
  license: LicenseRef-All-Rights-Reserved
  imports:
    - /common/vlq_base128_le
  endian: le
types:
  net_string:
    seq:
      - id: length
        type: vlq_base128_le
      - id: value
        size: length.value
        type: str
        encoding: 'UTF-8'
