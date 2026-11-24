# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/common/version.ksy
# Licence and copyright: see _community/README.md
meta:
  id: packet_version
  title: 'PangYa packet: client version'
  license: ISC
  endian: le

enums:
  # Add new client versions here. We do not need to maintain compatibility when
  # updating indices. Only include clients that are preserved and do not
  # include unnecessarily specific versions (if we don't have multiple of a
  # given major version, don't include the minor version.)
  version:
    0: eu_301
    1: eu_500
    2: in_212
    3: jp_977
    4: kr_326
    5: sg_216
    6: th_580
    7: th_829
    8: us_431
    9: us_500
    10: us_824
    11: us_852
