# Imported from https://github.com/teh-hippo/ha-govee-led-ble/blob/f5242abb27b28aa95e1c71aaeaab7f3e1e06eda7/tools/ble/kaitai/h6199_diy_selector.ksy
# Licence and copyright: see _community/README.md
meta:
  id: h6199_diy_selector
  title: Govee H6199 native DIY item selector
  license: MIT
  endian: le
doc: |
  H6199 native DIY mode carries the selected item code as a little-endian word.
  Direct register and visual evidence on HW3.02.01, FW1.10.04, Pact2/1 qualify
  selection and status readback. The remaining bytes are opaque.
types:
  diy_selector:
    seq:
      - id: code
        type: u2le
      - id: unknown_tail
        size-eos: true
