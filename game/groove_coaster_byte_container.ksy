# Imported from https://github.com/UrsulaProject/kaitai-groove-coaster-mobile/blob/8f3f01be4bc9470a5cde32d06329f4b189d5cc2b/byte_container.ksy
meta:
  id: groove_coaster_byte_container
  title: Groove Coaster length-prefixed byte array
  license: LicenseRef-All-Rights-Reserved
seq:
  - id: len
    type: u1
  - id: bytes
    size: len
