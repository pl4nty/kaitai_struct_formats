# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0196.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 0196
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_0196_unknown_lounge_related_response
  title: GameService Server 0196 Unknown Response (C-00EB, Lounge Related)
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This is the response to [Gameservice Client 0x00EB Unknown Request (Lounge
  Related)](/packets/gameservice/client/00eb.ksy).
  
  It is also sent once with the local user's connection ID upon joining a lounge
  without prompting.

seq:
  - id: connection_id
    type: u4
    doc: |
      Targer user's connection ID from [Gameservice Server 0x0046 User
      Census](/packets/gameservice/server/0046.ksy).
  - id: unknown_a
    type: f4
    doc: All examples show 1 (0x3F800000).
  - id: unknown_b
    type: f4
    doc: All examples show 1 (0x3F800000).
  - id: unknown_c
    type: f4
    doc: All examples show 1 (0x3F800000).
  - id: unknown_d
    type: f4
    doc: All examples show 1 (0x3F800000).
  - id: unknown_e
    type: f4
    doc: All examples show 1 (0x3F800000).
