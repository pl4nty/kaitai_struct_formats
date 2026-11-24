# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/common/pstring.ksy
meta:
  id: pstring
  title: PString
  license: ISC
  encoding: ASCII
  endian: le

doc: Pascal-style length prefix string, with a 2-byte prefix.

seq:
  - id: length
    type: u2
    doc: Length of the string, in bytes.

  - id: data
    size: length
    type: str
    doc: Content of the string, with no null terminator.
