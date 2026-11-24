# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/01bd.ksy
meta:
  id: gameservice_server_01bd_guild_search_response
  title: GameService Server Guild Search Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet contains search results from a query against the guild directory.
  
  The number of guilds on a page is set at 15 in PangyaTH.
  
  This packet is a response to [GameService Client 0x0109 Guild Search
  Request](/packets/gameservice/client/0109.ksy).
  
  **See Also:**
  * [GameService Server 0x01BC Guild List](/packets/gameservice/server/01bc.ksy)

seq:
  - id: unknown_a
    size: 4
  - id: page_number
    type: u4
    doc: Page number requested from the Search Results.
  - id: guild_count_total
    type: u4
    doc: Number of guilds matching the search term in total.
  - id: guild_count
    type: u2
    doc: |
      Number of guilds matching the search term on requested page. Seen maximum of 15
      (0x0F).
  - id: guilds
    type: guild
    repeat: expr
    repeat-expr: guild_count

types:
  guild:
    seq:
      - id: unknown_b
        size: 4
        doc: Possibly a guild ID?
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
        doc: If missing, "guildmark".
