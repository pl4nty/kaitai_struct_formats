# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/loginservice/client/0003.ksy
# Licence and copyright: see _community/README.md
meta:
  id: loginservice_client_0003_select_server
  title: LoginService Client Select Server
  license: ISC
  encoding: ASCII
  endian: le

doc: |
  This packet is sent when the user clicks on a server on the left-hand side
  of the PangYa serverlist.

  There are two bytes that appear to be unused. The outcome of this packet
  does not vary regardless of what bit pattern is present in these bytes.

  In `hsreina/pangya-server`, the packet ID is `TCLPID.PLAYER_SELECT_SERVER`.

seq:
  - id: server_id
    type: u2
    doc: ID of server to connect to.

  - id: unused
    type: u2
    doc: This field appears to always be zero.
