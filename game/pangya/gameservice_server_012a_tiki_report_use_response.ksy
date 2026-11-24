# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/012a.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_012a_tiki_report_use_response
  title: GameService Server Tiki Report Use Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges the use of a Tiki Report.
  
  It is a response to:
  * [GameService Client 0x00AA Match Statistics Submit (Tiki
    Report)](/packets/gameservice/client/00aa.ksy).

seq:
  - id: unknown_gss012a
    size: 4
    doc: All 0x00?
