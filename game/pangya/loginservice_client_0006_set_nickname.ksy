# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/loginservice/client/0006.ksy
# Licence and copyright: see _community/README.md
#pragma.examples loginservice/client 0006
#pragma.parseAs LoginserviceClientPacket
meta:
  id: loginservice_client_0006_set_nickname
  title: LoginService Client Set Nickname
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is sent by the PangYa client to set the player's nickname.
  
  In `hsreina/pangya-server`, the packet ID is `TCLPID.PLAYER_SET_NICKNAME`.

seq:
  - id: nickname
    type: pstring
    doc: Nickname to set.
