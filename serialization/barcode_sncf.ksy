# Imported from https://github.com/NeoRail/train-barcode-kaitai-spec/blob/66a13883559fc7de6964570ede9252fa8eadca5a/sncf/sncf.ksy
meta:
  id: barcode_sncf
  file-extension: bin
  license: LicenseRef-All-Rights-Reserved
  encoding: "ISO-8859-1"
  endian: le
seq:
  - id: barcode_type
    size: 1
    type: str
    doc: From e to h observed historically, defines PECTAB (i is used with CV, h with FV)
  - id: media_type
    type: u1
    enum: ticket_medium
    doc: 0 = self-printed/mobile (Aztec), 1 = printed at Kiosk, E = printed at counter
  - id: ticket_type
    size: 2
    type: str
    doc: CV = "Confirmation Voyage", FV = "Fidelite de Voyaguer"? or similar
  - id: passenger_name_record
    size: 6
    type: str
    doc: Passenger Name Record (assumedly)
  - id: ticket_number
    size: 9
    type: str
    doc: Ticker number
  - id: specimen_indicator
    size: 1
    type: str
    doc: 0 = specimen, 1 = production
  - id: barcode_version
    size: 1
    type: str
    doc: Barcode version, only 2 observed
  - id: sequence_index
    size: 1
    type: str
    doc: Position in a sequence of tickets (1-based indexing)
  - id: sequence_size
    size: 1
    type: str
    doc: Number of tickets in the sequence
  - id: traveller_dob
    size: 10
    type: str
    doc: "Traveller Date of Birth (format: `%d/%m/%Y`)"
  - id: departure_station
    size: 5
    type: str
    doc: 5-character departure SNCF station ID
  - id: arrival_station
    size: 5
    type: str
    doc: 5-character arrival SNCF station ID
  - id: train_number
    size: 5
    type: str
    doc: 5-digit train number (left-zero-padded)
  - id: travel_date
    size: 5
    type: str
    doc: "Date of the travel (format: `%d/%m`)"
  - id: traveller_sncf_id
    size: 19
    type: str
    doc: SNCF Traveller ID (Internal)
  - id: traveller_surname
    size: 19
    type: str
    doc: Surname of the traveller (left-space-padded)
  - id: traveller_forename
    size: 19
    type: str
    doc: Forename of the traveller (left-space-padded)
  - id: travel_class
    size: 1
    type: str
    doc: 1-digit travel class (1, 2)
  - id: tariff_code
    size: 4
    type: str
    doc: Tariff Code
  - id: travel_class_return
    size: 1
    type: str
    doc: 1-digit travel class (0, 1, 2)
  - id: departure_station_return
    size: 5
    type: str
    doc: 5-character departure SNCF station ID
  - id: arrival_station_return
    size: 5
    type: str
    doc: 5-character arrival SNCF station ID
  - id: train_number_return
    size: 5
    type: str
    doc: 5-digit train number (left-zero-padded)

enums:
  ticket_medium:
    0x30: self_printed_or_mobile_aztec
    0x31: printed_at_kiosk
    0x45: printed_at_counter
