# Imported from https://github.com/NeoRail/train-barcode-kaitai-spec/blob/66a13883559fc7de6964570ede9252fa8eadca5a/mav/mav.ksy
# Envelope signature, enums and field notes from https://github.com/pjuhasz/mav_train_ticket/tree/12bbcf3534f86f7c8acf59029f657630cb06a82f/kaitai
meta:
  id: barcode_mav
  title: MÁV domestic ticket barcode
  license: CC0-1.0
  encoding: UTF-8
  endian: be

doc: |
  MÁV (Hungarian State Railways) and Volánbusz ticket barcodes, versions
  4-6 (versions 2 and 3 are also seen in the wild). The barcode is an
  envelope made of a short header, the compressed ticket data and a
  trailing digital signature (56 bytes from version 5, 256 bytes before).
  The pjuhasz/mav_train_ticket decoder describes the compressed blob as
  gzip; this spec unpacks it with zlib.

seq:
  - id: version
    type: u1
  - id: signing_key
    type: u1
  - id: ticket_number
    size: 18
    type: str
    if: version > 4
  - id: issuer
    size: 4
    type: str
    if: version > 4
  - id: content
    size: '_io.size - _io.pos - (version >= 5 ? 56 : 256)'
    type: compressed_content
    process: zlib
  - id: signature
    size: 'version >= 5 ? 56 : 256'
    doc: Digital signature over the barcode contents.

types:
  compressed_content:
    seq:
      - id: header
        type: header
      - id: person_block
        type: person_block
        if: header.flags.person_block_present == true
      - id: trip_block
        type: trip_block
        if: header.flags.trip_block_present == true
      - id: supplement_blocks
        type: supplement_block
        repeat: expr
        repeat-expr: header.supplement_block_count
      - id: reservation_blocks
        type: reservation_block
        repeat: expr
        repeat-expr: header.reservation_block_count
      - id: pass_blocks
        type: pass_block
        repeat: expr
        repeat-expr: header.pass_block_count

  mav_timestamp:
    doc: Number of seconds since 2017-01-01T00:00:00+01:00 (CET).
    seq:
      - id: seconds_since_2017
        type: u4
    instances:
      unix_timestamp:
        value: seconds_since_2017 + 1483225200
  header_flags:
    seq:
      - id: person_block_present
        type: b1
      - id: reserved
        type: b6
      - id: trip_block_present
        type: b1
  header:
    seq:
      - id: ticket_number
        size: 18
        type: str
        if: _root.version < 5
      - id: issuer
        type: u2
        if: _root.version < 5
        doc: Numeric RICS code
      - id: issuing_time
        type: mav_timestamp
      - id: price
        type: f4
      - id: flags
        type: header_flags
      - id: supplement_block_count
        type: u1
      - id: reservation_block_count
        type: u1
      - id: pass_block_count
        type: u1
      - id: reserved_2
        size: 3
      - id: ticket_medium
        type: u4
        enum: ticket_medium

  mav_birth_date:
    doc: Encoded as year * 10000 + month * 100 + day
    seq:
      - id: packed
        type: u4
    instances:
      year:
        value: packed / 10000
      month:
        value: (packed - year*10000)/100
      day:
        value: packed - year*10000 - month*100
  person_block:
    seq:
      - id: name
        size: 45
        type: str
      - id: birth_date
        type: mav_birth_date
      - id: id_card_number
        size: 15
        type: str

  station_id:
    doc: |
      7 digit UIC station code (version < 5) or numeric Hungarian station code
      (version >= 5),
      presumably https://www.wikidata.org/wiki/Property:P11451.
    seq:
      - id: station_id
        type: b24
  validity_length:
    doc: Length of a validity period in minutes.
    seq:
      - id: minutes
        type:
          switch-on: _root.version
          cases:
            2: u2
            3: u2
            _: b24
        doc: Raw value; in versions 2 and 3 this counts days, not minutes.
    instances:
      length_minutes:
        value: '_root.version > 3 ? minutes : minutes * 1440 - 1'
        doc: Validity length in minutes for all versions.
  trip_block:
    seq:
      - id: ticket_name
        type: u4
        enum: ticket_kind
        doc: Ticket type tag; known values are listed in the enum.
      - id: departure_station
        type: station_id
      - id: destination_station
        type: station_id
      - id: via_stations
        type: station_id
        repeat: expr
        repeat-expr: 15
      - id: via_stations_return
        type: station_id
        repeat: expr
        repeat-expr: 15
      - id: travel_class
        size: 1
        type: str
      - id: specimen
        type: u1
        doc: |
          0x1 for production tickets, 0x0 for specimens. The
          pjuhasz/mav_train_ticket decoder reads this byte as the number of
          trips instead.
      - id: departure_time
        type: mav_timestamp
      - id: validity_length
        type: validity_length
      - id: number_of_passengers
        type: u1
      - id: discount_name
        type: u4
        enum: discount

  supplement_block:
    seq:
      - id: departure_station
        type: station_id
      - id: destination_station
        type: station_id
      - id: travel_class
        size: 1
        type: str
      - id: ticket_name
        type: u4
        enum: ticket_kind
      - id: valid_from
        type: mav_timestamp
      - id: validity_length
        type: validity_length
      - id: number_of_passengers
        type: u1
      - id: discount_name
        type: u4
        enum: discount

  reservation_block:
    seq:
      - id: departure_station
        type: station_id
      - id: destination_station
        type: station_id
      - id: ticket_name
        type: u4
        enum: ticket_kind
        doc: Ticket type tag; known values are listed in the enum.
      - id: departure_time
        type: mav_timestamp
      - id: operator
        type: u2
        doc: Numeric RICS code
      - id: train_number
        size: '_root.version >= 6 ? 20 : 5'
        type: str
      - id: unknown
        size: 1
        doc: Number of passengers, according to the pjuhasz/mav_train_ticket decoder.
      - id: coach_number
        size: 3
        type: str
      - id: seat_number1
        type: u2
      - id: seat_number2
        type: u2
      - id: reserved
        size: 28
        doc: |
          Four more coach/seat ranges of 7 bytes each (coach number, two
          seat numbers), according to the pjuhasz/mav_train_ticket decoder.

  pass_block:
    seq:
      - id: pass_name
        type: u4
        enum: ticket_kind
        doc: Pass type tag; known values are listed in the enum.
      - id: discount_name_1
        type: u4
        enum: discount
      - id: discount_name_2
        type: u4
        enum: discount
      - id: valid_from
        type: mav_timestamp
      - id: valid_until
        type: validity_length
      - id: number_of_passengers
        type: u1

enums:
  ticket_medium:
    0x236d0520: electronic_pdf_from_app
    0x54a5b34d: thermal_paper_from_emke
    0x691b8d67: hologram_paper_from_volanbusz
    0xa7d59ea6: paper_from_vending_machine
    0xc785b60c: paper_bkk_pass
    0x338797fe: electronic_pdf_from_web
    0xf8b405cd: thermal_paper_from_ticket_inspector
    0xbaabd261: hologram_paper_from_volanbusz_driver
  ticket_kind:
    0xf1694467: surcharge
    0x73b2da6d: seat_reservation
    0x639fe49e: train_ticket
    0x1271cee2: bike_ticket
    0xd9338c49: dog_pass
    0x9364de3e: smart_ticket
    0x1378587b: x30_day_pass
    0x294b183d: baz_county_pass
    0x9b591ad2: budapest_72_hour_pass
    0xb35523bc: hajdu_bihar_county_pass
    0x2d31b61f: heves_county_pass
    0xb438e7a5: nograd_county_pass
    0x2487fa34: pest_county_pass
    0xf2afd8fb: pest_county_pass2
    0x2402e074: all_country_pass
    0x66e219a3: tram_train_ticket
    0x9194c6e8: airport_bus_ticket
  discount:
    0xd4e77f4b: full_price
    0x1c89f297: x50pct_start_club_card
    0xc29c077e: x50pct_by_age
    0xca918a13: x50pct_by_age2
    0xc99ee756: x50pct_employee_voucher
    0x0344c689: x50pct_employee_voucher2
    0x4f1584ed: pass_full_price
    0x13213fca: pass_student_id
    0xffd50016: penalty_fee
