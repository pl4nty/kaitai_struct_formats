# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0069.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/client 0069
#pragma.parseAs GameserviceClientPacket
meta:
  id: gameservice_client_0069_chat_macro_update
  title: GameService Client Chat Macro Update
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet updates the user's chat macros. This is so the server can
  restore the user's custom chat macros on login with [LoginService Server 0x0006
  Chat Macro List](/packets/loginservice/server/0006.ksy).
  
  Even if the user does not change the chat macros, this packet is sent anytime
  the user accepts any changes to the client settings menu.
  
  There is no response.
  
  **Aliases:**
  * `eantoniobr/UGPangya`: `PLAYER_SAVE_MACRO`

seq:
  - id: chat_macro
    size: 64
    type: strz
    repeat: expr
    repeat-expr: 9
    doc: Text string of the chat macro.
