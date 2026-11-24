# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/008b.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_008b_request_message_server_list
  title: GameService Client Request Message Server List
  license: ISC
  encoding: ASCII
  endian: le

doc: |
  This packet is sent occasionally sent by the Pangya client to get the
  message server list.  This message is only sent if the client has failed
  to connect to the message server at login.
  
  Response is GameServer 0x00fc

  **See Also**: [Game Server 0x00fc Message Server
  List](/packets/gameservice/server/00fc.ksy)
  
  This Packet has no payload.
