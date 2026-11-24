# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/016f.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_016f_login_bonus_claim
  title: GameService Client Login Bonus Claim
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is to claim the Login Bonus. It's always and only called after
  [GameService Server 0x0248 Login Bonus Status
  Response](/packets/gameservice/server/0248.ksy)
  shows an unclaimed bonus.
  
  This packet contains no payload.
  
  Its responses are [GameService Server 0x0216 User Status
  Update](/packets/gameservice/server/0216.ksy) (to award the item),
  then [GameService Server 0x0249 Login Bonus Claim
  Response](/packets/gameservice/server/0249.ksy).
  
  **Aliases:**
  * `eantoniobr/UGPangya`: `PLAYER_REQUEST_ITEM_DAILY`
