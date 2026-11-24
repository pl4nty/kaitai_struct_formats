# Imported from https://github.com/NeoRail/train-barcode-kaitai-spec/blob/66a13883559fc7de6964570ede9252fa8eadca5a/spain/renfe.ksy
# Licence and copyright: see _community/README.md
meta:
  id: barcode_renfe
  title: Renfe Ticket Barcode
  file-extension: bin
  license: CC0-1.0
  encoding: "ISO-8859-1"
  endian: le

doc: |
  Can occur stand-alone or in the vendor block of the Spanish common ticket
  container format.

seq:
  - id: ticket_number
    size: 13
    type: str
  - id: departure_station
    size: 5
    type: str
    doc: UIC code, 0-prefixed to 5 digits and omitting the leading country code
  - id: arrival_station
    size: 5
    type: str
    doc: UIC code, 0-prefixed to 5 digits and omitting the leading country code
  - id: departure_date
    size: 6
    type: str
    doc: "Format: ddMMyy"
  - id: train_number
    size: 5
    type: str
    doc: unclear which one on a multi-leg trip
  - id: coach_number
    size: 3
    type: str
    doc: last one on a mult-leg trip?
  - id: seat_number
    size: 3
    type: str
  - id: unknown
    size: 3
    type: str
  - id: localizador
    size: 6
    type: str
  - id: separator
    contents: [0x2E, 0x2E]
    if: _root._io.size > 50
    doc: optional, present if CombinadoCercanias is present
  - id: combinado_cercanias
    size: 5
    type: str
    if: _root._io.size > 50
    doc: optional
