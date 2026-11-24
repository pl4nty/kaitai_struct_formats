# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/loginservice/server/0009.ksy
# Licence and copyright: see _community/README.md
meta:
  id: loginservice_server_0009_message_server_list
  title: LoginService Server Message Server List
  license: ISC
  imports:
    - message_server
  encoding: ASCII
  endian: le

doc: |
  This packet is sent shortly after a successful login, if the user already
  has an initialized player. It contains a listing of all of the message servers.

seq:
  - id: count
    type: u1
    doc: Number of servers in the response.
  - id: servers
    type: message_server
    repeat: expr
    repeat-expr: count
