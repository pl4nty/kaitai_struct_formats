# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/001f.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/client 001f
#pragma.parseAs GameserviceClientPacket
meta:
  id: gameservice_client_001f_unknown
  title: GameService Client 001F Unknown
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: This is a stub entry.

seq:
  - id: unknown_a
    size: 1
    doc: Known values are $00 and $01
  - id: entity_count
    type: u1
  - id: entity_list
    type: entity
    repeat: expr
    repeat-expr: entity_count

types:
  entity:
    seq:
      - id: unknown_b
        size: 5
