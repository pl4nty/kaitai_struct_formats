# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/00eb.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_00eb_unknown_lounge_related_request
  title: GameService Client 00EB Unknown Request (S-0196, Lounge Related)
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is called for each user in a lounge room in no particular order. It
  will also be called as new users join the lounge.

  The response is [Gameservice Server 0x0196 Unknown Response (Lounge
  Related)](/packets/gameservice/server/0196.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_UN_00EB`
  * `eantoniobr/UGPangya`: `PLAYER_ENTER_TO_ROOM`

seq:
  - id: connection_id
    type: u4
    doc: |
      Targer user's connection ID from [Gameservice Server 0x0046 User
      Census](/packets/gameservice/server/0046.ksy).
