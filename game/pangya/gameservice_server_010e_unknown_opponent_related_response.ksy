# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/010e.ksy
meta:
  id: gameservice_server_010e_unknown_opponent_related_response
  title: GameService Server 010E Unknown Response (VS Mode Opponent Related)
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet contains particulars about the current opponent(s) in VS mode.
  
  This packet is a response to [Gameservice Client 0x009C Unknown Request (VS Mode
  Opponent Related)](/packets/gameservice/client/009c.ksy).

seq:
  - id: unknown_a
    size: 4
    doc: Possibly padding.
  - id: user_nickname
    size: 22
    type: strz
  - id: user_nickname_b
    size: 22
    type: strz
    doc: Incomplete nickname in known captures.
  - id: user_id
    type: u4
  - id: unknown_b
    size: 208
    doc: Possibly padding.
