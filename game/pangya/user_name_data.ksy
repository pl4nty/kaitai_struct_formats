# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/common/user_name_data.ksy
# Licence and copyright: see _community/README.md
meta:
  id: user_name_data
  title: User Name Data
  license: ISC
  imports:
    - id_bank
  encoding: ASCII
  endian: le

doc: |
  Oft-recurring format for communicating a user's display name and guild to
  clients, including:
  * [Gameservice Server 0x0044 Unknown](/packets/gameservice/server/0044.ksy)
  * [GameService Server 0x0076 Room User
    Data](/packets/gameservice/server/0076.ksy)
  * [Gameservice Server 0x0157 User Name
    Response](/packets/gameservice/server/0157.ksy)

  **See Also**:
  * [Common Data Structures](/packets/common/index.md)

seq:
  - id: room_id
    type: u2
    doc: Unconfirmed. 0xFFFF (-1) when not in room.
  - id: username
    size: 22
    type: strz
    doc: User's account name.
  - id: user_nickname
    size: 22
    type: strz
    doc: User's display name.
  - id: guild_name
    size: 21
    type: strz
  - id: guild_emblem_id
    size: 24
    type: strz
    doc: |
      Local user's guild's emblem ID. If present, for instance "13579ace", PNG image
      is downloaded over HTTP from (PangyaTH)
      203.107.140.35:50008/_Files/GuildEmblem/13579ace.png
  - id: connection_id
    type: u4
    doc: Unused in GSS-0157.
  - id: unknown_user_name_data_a
    size: 12
    doc: All 0x00?
  - id: unknown_user_name_data_b
    type: u4
  - id: unknown_user_name_data_c
    size: 4
    doc: All 0x00?
  - id: unknown_user_name_data_d
    type: u2
  - id: unknown_user_name_data_e
    size: 6
    doc: All 0xFF?
  - id: unknown_user_name_data_f
    size: 16
  - id: username_atnt
    size: 128
    type: strz
    doc: |
      Typically the local player's username, appended with "@NT".
      Possibly some sort of email or messaging integration?
      Occasionally this field is empty.
      "faceb###############@NT" also witnessed, suggesting a link to
      Login-via-Facebook functionality.
  - id: user_id
    type: u4
    doc: Unique ID representing the user.
