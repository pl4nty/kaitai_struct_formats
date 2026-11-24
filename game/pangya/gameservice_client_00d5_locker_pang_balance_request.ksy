# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/00d5.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/client 00d5
#pragma.parseAs GameserviceClientPacket
meta:
  id: gameservice_client_00d5_locker_pang_balance_request
  title: GameService Client Locker Pang Balance Request
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet requests the pang balance currently within the locker.
  
  It has no payload.
  
  The response is [GameService Server 0x0172 Locker Pang
  Balance](/packets/gameservice/server/0172.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_REQUEST_LOCKER_PANGS`
  * `eantoniobr/UGPangya`: `PLAYER_GET_LOCKERPANG`
