# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/017a.ksy
meta:
  id: gameservice_client_017a_event_room_leave
  title: GameService Client Event Room Leave
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet signals the user leaving a room and returning to the Grand Prix
  event lobby.
  
  The response is [GameService Server 0x0254 Event Room Leave
  Response](/packets/gameservice/server/0254.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `LEAVE_GRAND_PRIX_EVENT`
  * `eantoniobr/UGPangya`: `PLAYER_LEAVE_GRANDPRIX`

seq:
  - id: unknown_a
    type: u1
    doc: All examples are 0 (0x00).
  - id: room_number
    type: s2
    doc: The new room number, which is always -1 (0xFFFF) for the lobby.
  - id: unknown_b
    type: u4
  - id: unknown_c
    size: 4
  - id: unknown_d
    type: u4
  - id: unknown_e
    size: 4
