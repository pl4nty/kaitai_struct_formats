# Imported from https://github.com/UrsulaProject/kaitai-groove-coaster-mobile/blob/8f3f01be4bc9470a5cde32d06329f4b189d5cc2b/str_container.ksy
meta:
  id: groove_coaster_str_container
  title: Groove Coaster length-prefixed string
  license: LicenseRef-All-Rights-Reserved
seq:
  - id: len
    type: u1
  - id: string
    size: len
    type: str
    encoding: UTF-8
