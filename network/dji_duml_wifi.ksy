# Imported from https://github.com/atc1441/Gadgetbridge-BLE-OpenEpaperLink/blob/806c981e4fcdc4126de99ec25af02493fa313f01/app/src/main/ksy/duml_wifi.ksy
# Licence and copyright: see _community/README.md
meta:
  id: dji_duml_wifi
  title: DUML Wi-Fi command set
  license: AGPL-3.0-only
  endian: le
  -duml-cmdset: 0x07

doc: Commands under cmdSet=WIFI(0x07).

types:
  set_pairing_pin_request:
    meta:
      -duml-cmd: 0x45
    doc: Phone sends a hardcoded app-identifier string plus a PIN.
    seq:
      - id: id_len
        type: u1
      - id: id
        size: id_len
        type: str
        encoding: UTF-8
      - id: pin_len
        type: u1
      - id: pin
        size: pin_len
        type: str
        encoding: UTF-8

  set_pairing_pin_response:
    meta:
      -duml-cmd: 0x45
    doc: |
      Device replies with a status byte and a "pairing state" flag. If that flag is
      0x01, no further pairing stages are needed - otherwise the app waits for a
      separate pairing_pin_approved push once a human confirms pairing on the device
      itself.
    seq:
      - id: status
        type: u1
        doc: usually 0x00
      - id: pairing_state
        type: u1
        doc: 0x01 if already paired, 0x02 if the user must approve the pairing.

  pairing_pin_approved:
    meta:
      -duml-cmd: 0x46
    seq:
      - id: status
        type: u1
