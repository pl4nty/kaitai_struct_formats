# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/027d.ksy
meta:
  id: gameservice_server_027d_unknown_cookies_related_response
  title: GameService Server 027d Unknown Response (Cookies Related)
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This is the response to [GameService Client 0x0195 Unknown Cookies
  Related](/packets/gameservice/client/0195.ksy).

seq:
  - id: unknown_a
    size: 4
