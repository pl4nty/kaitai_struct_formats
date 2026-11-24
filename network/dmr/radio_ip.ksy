# Imported from https://github.com/OK-DMR/dmr-kaitai/blob/7489ff1a8b418e3d37e2a0268acbaf2710543d93/okdmr/kaitai/hytera/radio_ip.ksy
# Licence and copyright: see _community/README.md
meta:
  id: radio_ip
  title: Hytera radio IP address
  license: AGPL-3.0-only
doc: |
  represented as 4 bytes, each byte interpreted as number (0-255)
  10.0.0.80 means the subnet is set to 10.x.x.x (C) and radio ID is 80
  10.22.0.0 means the subnet is set to 10.x.x.x (C) and radio ID is 2200
seq:
  - id: subnet
    type: u1
  - id: radio_id_1
    type: u1
  - id: radio_id_2
    type: u1
  - id: radio_id_3
    type: u1
instances:
  radio_id:
    value: (radio_id_1 << 16) + (radio_id_2 << 8) + (radio_id_3)
  radio_ip:
    value: subnet.to_s + "." + radio_id_1.to_s + "." + radio_id_2.to_s + "." + radio_id_3.to_s
