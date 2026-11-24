# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/messageservice/client/0023.ksy
meta:
  id: messageservice_client_0023_server_declaration
  title: MessageService Client Server Declaration
  license: ISC
  encoding: ASCII
  endian: le

doc: |
  This packet is sent by the PangYa client to announce to which game server the
  user is connected.
  
  **See Also**: [MessageService Server Game Server List
  Packet](/packets/loginservice/server/0002.ksy)
  
seq:
  - id: unknown_a
    size: 2
  - id: unknown_b
    size: 4
  - id: server_id
    type: u4
    doc: Connected Server ID
  - id: sub_server_id
    type: u1
    doc: Connected Sub-Server (0xFF is none; 0x00 is First, etc.)
  - id: sub_server_name
    size: 64
    type: strz
    doc: Connected Sub-Server Name ('NONE', 'Free#1', 'Rookie', etc.)
