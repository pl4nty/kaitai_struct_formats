# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/messageservice/client/0012.ksy
# Licence and copyright: see _community/README.md
meta:
  id: messageservice_client_0012_credential_declaration
  title: MessageService Client Credential Declaration
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is sent by the PangYa client to initiate the connection with
  the Messaging Server.
  
  **See Also**: [MessageService Server 0x002F Credential Declaration
  Response](/packets/messageservice/server/002f.ksy)

seq:
  - id: user_id
    type: u4
    doc: Local user's ID
  - id: user_nickname
    type: pstring
    doc: Local user's nickname
