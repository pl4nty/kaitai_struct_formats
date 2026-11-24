# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/003d.ksy
meta:
  id: gameservice_client_003d_cookie_balance_request
  title: GameService Client Cookie Balance Request
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is sent when clicking the 'Add/Buy Cookies' item in the menu.
  
  It has no payload.
  
  The response is [GameService Server 0x0096 Cookie
  Balance](/packets/gameservice/server/0096.ksy).

  **See Also:**
  * [GameService Client 0x00A2 Unknown (Cookies
    Related)](/packets/gameservice/client/00a2.ksy)
  * [GameService Client 0x0195 Unknown (Cookies
    Related)](/packets/gameservice/client/0195.ksy)
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_REQUEST_COOKIES_COUNT`
