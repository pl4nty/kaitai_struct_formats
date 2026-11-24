# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/026a.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_026a_shot_assist_toggle_response
  title: GameService Server Shot Assist Toggle Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges the shot assist being toggled.
  
  This is one of the responses to [GameService Client 0x0184 Shot Assist
  Toggle](/packets/gameservice/client/0184.ksy).

seq:
  - id: unknown_a
    type: u4
    doc: All examples show 0 (0x00000000).
