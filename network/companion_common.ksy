# Imported from https://github.com/Woodie-07/meshcore-kaitai/blob/5349249c65237e7e3722a94c0449832aae9de507/companion_common.ksy
# Licence and copyright: see _community/README.md
meta:
  id: companion_common
  title: 'MeshCore companion protocol: common types'
  license: Apache-2.0
  bit-endian: le
enums:
  txt_type:
    0: plain
    1: cli_data
    2: signed_plain
  advert_loc_policy:
    0: none
    1: share
types:
  contact_flags:
    seq:
      - id: favourite
        type: b1
      - id: telem_perm_base
        type: b1
      - id: telem_perm_location
        type: b1
      - id: telem_perm_environment
        type: b1
      - id: unused
        type: b4
