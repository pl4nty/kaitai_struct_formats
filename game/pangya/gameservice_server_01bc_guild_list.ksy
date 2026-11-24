# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/01bc.ksy
meta:
  id: gameservice_server_01bc_guild_list
  title: GameService Server Guild List
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet contains a page of the guild directory.
  
  The number of guilds on a page is set at 15 in PangyaTH.
  
  This packet is a response to [GameService Client 0x0108 Guild List
  Request](/packets/gameservice/client/0108.ksy).
  
  **See Also:**
  * [GameService Server 0x01BD Guild Search
    Response](/packets/gameservice/server/01bd.ksy)

seq:
  - id: unknown_a
    size: 4
  - id: page_number
    type: u4
    doc: Page number requested from the Guild Directory.
  - id: page_number_max
    type: u4
    doc: Unconfirmed. Total page count in Guild Directory.
  - id: guild_count
    type: u2
  - id: guilds
    type: guild
    repeat: expr
    repeat-expr: guild_count

types:
  guild:
    seq:
      - id: unknown_b
        size: 4
      - id: guild_name
        size: 21
        type: strz
      - id: guild_pang_amount
        type: u4
      - id: guild_point_amount
        type: u4
      - id: guild_member_amount
        type: u4
      - id: unknown_c
        size: 16
      - id: guild_description
        size: 105
        type: strz
      - id: guild_leader_user_id
        type: u4
      - id: guild_leader_user_nickname
        size: 22
        type: strz
      - id: guild_emblem_id
        size: 12
        type: strz
        doc: If missing, "GUILDMARK"
