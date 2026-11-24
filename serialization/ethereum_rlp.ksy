meta:
  id: ethereum_rlp
  title: Ethereum Recursive Length Prefix (RLP) serialization
  application: Ethereum
  file-extension: rlp
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  Recursive Length Prefix (RLP) is the serialization format used by
  Ethereum for transactions, blocks, account state and network messages.
  An item is either a byte string or a list of items. The first byte of an
  item tells which one it is and how its length is encoded:

  * 0x00-0x7f: the byte itself is a one-byte string;
  * 0x80-0xb7: a string of 0-55 bytes, length = prefix - 0x80;
  * 0xb8-0xbf: a longer string; the next (prefix - 0xb7) bytes hold the
    big-endian length;
  * 0xc0-0xf7: a list whose items take 0-55 bytes, length = prefix - 0xc0;
  * 0xf8-0xff: a longer list; the next (prefix - 0xf7) bytes hold the
    big-endian length of its payload.

  RLP has no notion of integers or other types: integers are encoded as
  big-endian byte strings without leading zeros, and interpreting items is
  up to the application. Canonical encodings use the shortest form; this
  spec does not reject non-canonical ones.

  This spec parses a file containing a single top-level RLP item.
doc-ref:
  - https://ethereum.org/developers/docs/data-structures-and-encoding/rlp/
  - https://github.com/ethereum/pyrlp/blob/main/rlp/codec.py
seq:
  - id: item
    type: rlp_item
types:
  rlp_item:
    seq:
      - id: prefix
        type: u1
      - id: len_payload_long
        type:
          switch-on: len_len_payload
          cases:
            1: b8
            2: b16
            3: b24
            4: b32
            5: b40
            6: b48
            7: b56
            8: b64
        if: is_long
        doc: Big-endian length of the payload, for long strings and lists.
      - id: string_payload
        size: len_payload
        if: not is_list and not is_single_byte
      - id: list_payload
        size: len_payload
        type: rlp_list
        if: is_list
    instances:
      is_single_byte:
        value: prefix < 0x80
        doc: The prefix byte is itself the value (a one-byte string).
      is_list:
        value: prefix >= 0xc0
      is_long:
        value: (prefix >= 0xb8 and prefix < 0xc0) or prefix >= 0xf8
      len_len_payload:
        value: 'is_list ? prefix - 0xf7 : prefix - 0xb7'
        doc: Number of length bytes following the prefix (only for long forms).
      len_payload:
        value: |
          (is_long ? len_payload_long : (is_list ? prefix - 0xc0 : prefix - 0x80)).as<u8>
        doc: Length of the payload in bytes (not meaningful for single bytes).
  rlp_list:
    seq:
      - id: items
        type: rlp_item
        repeat: eos
