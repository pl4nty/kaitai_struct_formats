# Imported from https://github.com/TeamT5/MalCfgParser/blob/d62d7c38c8e92251ef194aa4988cdc4824a811dd/kaitai_structs/keyboy.ksy
meta:
  id: keyboy
  title: KeyBoy malware configuration
  license: LicenseRef-All-Rights-Reserved
  endian: be
seq:
  - id: magic
    size: 0x40
    type: str
    encoding: ASCII
  - id: reverse_host_1
    size: 0x40
    type: str
    encoding: ASCII
  - id: reverse_host_2
    size: 0x40
    type: str
    encoding: ASCII
  - id: reverse_host_3
    size: 0x40
    type: str
    encoding: ASCII
  - id: reverse_port_1
    size: 0x40
    type: str
    encoding: ASCII
  - id: reverse_port_2
    size: 0x40
    type: str
    encoding: ASCII
  - id: reverse_port_3
    size: 0x40
    type: str
    encoding: ASCII
  - id: payload_url_1
    size: 0x80
    type: str
    encoding: ASCII
  - id: payload_url_2
    size: 0x80
    type: str
    encoding: ASCII
  - id: payload_url_3
    size: 0x80
    type: str
    encoding: ASCII
  - id: control_port
    size: 0x40
    type: str
    encoding: ASCII
  - id: login_password
    size: 0x40
    type: str
    encoding: ASCII
  - id: campaign_code
    size: 0x40
    type: str
    encoding: ASCII
  - id: usb
    size: 0x40
    type: str
    encoding: ASCII
