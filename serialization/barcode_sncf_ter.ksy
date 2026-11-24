# Imported from https://github.com/NeoRail/train-barcode-kaitai-spec/blob/66a13883559fc7de6964570ede9252fa8eadca5a/sncf/sncf-ter.ksy
meta:
  id: barcode_sncf_ter
  title: SNCF TER ticket barcode
  license: CC0-1.0
  encoding: UTF-8

doc: Barcode used for regional trains in some areas of France.

seq:
  - id: magic
    contents: [0x32, 0x32, 0x30, 0x30]
  - id: signature
    size: 256
  - id: unknown_1
    contents: [0x30, 0x30, 0x54]
  - id: maybe_version
    size: 1
    type: str
  - id: uic_issuer_code
    size: 4
    type: str
  - id: ticket_number
    size: 9
    type: str
  - id: departure_station_code
    size: 5
    type: str
    doc: can be empty for zone passes
  - id: arrival_station_code
    size: 5
    type: str
    doc: can be empty for zone passes
  - id: via_station_code
    size: 5
    type: str
    doc: optional, filled with 0x20 when not used
  - id: zone_description
    size: 50
    type: str
    doc: unused space filled with 0x20
  - id: ticket_type
    size: 1
    type: str
    doc: "'S' for regular tickets, 'A' for multi-use passes"
  - id: travel_date
    size: 8
    type: str
    doc: "Format: ddMMyyyy"
  - id: class
    size: 1
    type: str
  - id: tariff_code
    size: 4
    type: str
  - id: ticket_name
    size: 20
    type: str
    doc: unused space filled with 0x20
  - id: traveler_family_name
    size: 19
    type: str
    doc: left-aligned and blank (0x20) padded
  - id: traveler_given_name
    size: 19
    type: str
    doc: left-aligned and blank (0x20) padded
  - id: traveler_birth_date
    size: 8
    type: str
    doc: "Format: ddMMyyyy"
  - id: traveler_type_1
    size: 10
    type: str
    doc: e.g. 'ADULTE' or 'ENFANTE'
  - id: traveler_type_amount_1
    size: 2
    type: str
    doc: left-padded with '0'
  - id: traveler_type_2
    size: 10
    type: str
    doc: e.g. 'ADULTE' or 'ENFANTE', can be empty
  - id: traveler_type_amount_2
    size: 2
    type: str
    doc: left-padded with '0'
  - id: valid_from
    size: 8
    type: str
    doc: "Format: ddMMyyyy"
  - id: valid_until
    size: 8
    type: str
    doc: "Format: ddMMyyyy"
  - id: unknown_2
    contents: [0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30]
  - id: issuing_time
    size: 12
    type: str
    doc: "Format: ddMMyyyyHHmm"
  - id: price
    size: 10
    type: str
    doc: In Euro-cent, left-padded with '0'
  - id: free_text
    size: 190
    type: str
    doc: empty space filled with 0x20
