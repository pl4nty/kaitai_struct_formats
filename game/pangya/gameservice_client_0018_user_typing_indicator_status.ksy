# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0018.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_0018_user_typing_indicator_status
  title: GameService Client User Typing Indicator Status
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  Sends a message to the server indicating that the client player is currently
  typing.

  For the server side response, see [GameService Server 0x005d User Typing
  Incidator Announce](/packets/gameservice/server/005d.ksy),
seq:
  - id: typing_indicator
    type: s2
    doc: |
      00 01 (1) indicates the player is typing, FF FF (-1) incidates the player is no
      longer typing.
