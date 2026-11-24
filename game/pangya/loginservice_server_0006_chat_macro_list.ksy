# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/loginservice/server/0006.ksy
meta:
  id: loginservice_server_0006_chat_macro_list
  title: LoginService Server Chat Macro List
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet defines the user's 9 in-game chat macros.
  It is sent after a successful login.
  
  This list is altered with [GameService Client 0x0069 Chat Macro
  Update](/packets/gameservice/client/0069.ksy).

seq:
  - id: chat_macro
    size: 64
    type: strz
    repeat: expr
    repeat-expr: 9
    doc: Text string of the chat macro.
