# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/00c9.ksy
meta:
  id: gameservice_server_00c9_notice_data
  title: GameService Server Notice Data
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet relays the text of a 'notice' message to all users on the server via
  the notice ticker at the top of the game window.
  
  This is believed to be the response to GameService Client 0x0066 Undocumented,
  but no examples currently exist to document.

seq:
  - id: user_nickname
    type: pstring
  - id: notice_text
    type: pstring
