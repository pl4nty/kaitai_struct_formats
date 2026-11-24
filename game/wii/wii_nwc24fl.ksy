# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/system/nwc24fl.ksy
meta:
  id: wii_nwc24fl
  application: Wii Menu
  file-extension: bin
  license: LicenseRef-All-Rights-Reserved
  endian: be
seq:
  - id: magic
    type: u4
  - id: unknown
    type: u4
  - id: max_entries
    type: u4
  - id: friend_entries
    type: u4
  - id: padding
    size: 48
  - id: friend_codes
    type: u8
    repeat: expr
    repeat-expr: max_entries
  - id: friend_list
    type: friend_list
    repeat: expr
    repeat-expr: max_entries
types:
  friend_list:
    seq:
      - id: address_type
        type: u4
        doc: 1 if Wii Number. 2 if E-Mail.
      - id: friend_relation_status
        type: u4
        doc: 1 if unconfirmed (E-mail is always 1). 2 if confirmed. 3 if declined.
      - id: nickname
        size: 24
        type: str
        encoding: UTF-16BE
      - id: mii_id
        type: u4
      - id: system_id
        type: u4
      - id: reserved
        type: u4
        repeat: expr
        repeat-expr: 6
      - id: mail_address
        size: 256
