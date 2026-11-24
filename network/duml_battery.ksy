# Imported from https://github.com/pschmitt/Gadgetbridge/blob/7e6cbc79ac04ce4c896b9ff4cc914c804c1061be/app/src/main/ksy/duml_battery.ksy
# Licence and copyright: see _community/README.md
meta:
  id: duml_battery
  title: DUML Battery command set
  license: AGPL-3.0-only
  endian: le
  -duml-cmdset: 0x0d

doc: Commands under cmdSet=BATTERY(0x0d).

types:
  dynamic_data:
    meta:
      -duml-cmd: 0x02
    seq:
      - id: result
        type: u1
      - id: voltage
        type: u4
        doc: Millivolts.
      - id: current
        type: s4
        doc: Milliamperes. Positive while charging, negative while discharging.
      - id: full_capacity
        type: u4
      - id: remaining_capacity
        type: u4
      - id: temperature
        type: u2
        doc: Tenths of a degree Celsius.
      - id: cell_count
        type: u1
      - id: state_of_charge
        type: u1
        doc: Percent.
      - id: status
        type: u8
