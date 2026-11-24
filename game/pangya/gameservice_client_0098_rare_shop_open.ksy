# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0098.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/client 0098
#pragma.parseAs GameserviceClientPacket
meta:
  id: gameservice_client_0098_rare_shop_open
  title: GameService Client Rare Shop Open
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet opens the rare shop ('Black Papel', 'Memorial', etc.)
  
  This packet has no payload.
  
  The response is [GameService Server 0x010B Rare Shop Open
  Response](/packets/gameservice/server/010b.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_OPEN_RARE_SHOP`
  * `eantoniobr/UGPangya`: `PLAYER_OPEN_PAPEL`
