# Imported from https://github.com/pschmitt/Gadgetbridge/blob/7e6cbc79ac04ce4c896b9ff4cc914c804c1061be/app/src/main/ksy/duml_wifi.ksy
# Licence and copyright: see _community/README.md
meta:
  id: duml_wifi
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

  ap_ssid_get_request:
    meta:
      -duml-cmd: 0x07
    seq:
      - id: unknown
        type: u1
        doc: Meaning unknown. The app sends 0x1c.

  ap_ssid_get_response:
    meta:
      -duml-cmd: 0x07
    seq:
      - id: status
        type: u1
      - id: ssid_len
        type: u1
      - id: ssid
        size: ssid_len
        type: str
        encoding: ASCII

  ap_passphrase_get_request:
    meta:
      -duml-cmd: 0x0e
    seq:
      - id: unknown
        type: u1
        doc: Meaning unknown. The app sends 0x79.

  ap_passphrase_get_response:
    meta:
      -duml-cmd: 0x0e
    seq:
      - id: status
        type: u1
      - id: passphrase_len
        type: u1
      - id: passphrase
        size: passphrase_len
        type: str
        encoding: ASCII
