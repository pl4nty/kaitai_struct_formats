# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/loginservice/client/0007.ksy
meta:
  id: loginservice_client_0007_check_nickname
  title: LoginService Client Check Nickname
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is sent by the PangYa client to check if a given nickname is
  allowed, prior to setting the nickname.
  
  In `hsreina/pangya-server`, the packet ID is `TCLPID.PLAYER_CONFIRM`.

seq:
  - id: nickname
    type: pstring
    doc: Nickname to check.
