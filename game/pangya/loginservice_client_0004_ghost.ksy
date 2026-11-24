# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/loginservice/client/0004.ksy
meta:
  id: loginservice_client_0004_ghost
  title: LoginService Client Ghost
  license: ISC
  encoding: ASCII
  endian: le

doc: |
  This packet is sent by the PangYa client when it recieves the login error
  code 5100019 when attempting to log in. It tells the PangYa server to
  invalidate the previous session. After this packet is sent, the server
  will proceed with the login.

  This does not work if the user is still connected in another session and
  the 5100107 error code is received; attempting to ghost in this case will
  cause the client to be disconnected immediately.

seq: []
