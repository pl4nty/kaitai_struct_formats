# Imported from https://github.com/teh-hippo/ha-govee-led-ble/blob/f5242abb27b28aa95e1c71aaeaab7f3e1e06eda7/tools/ble/kaitai/speculative/h6199_control_payload.ksy
meta:
  id: govee_h6199_control_payload
  title: H6199 installation and Gradient payloads
  license: MIT
  endian: le
doc: |
  H6199.  exact-model
  camera settings and light control behaviour plus direct register tests on
  HW3.02.01,
  FW1.10.04, WiFi HW1.03.00/FW1.00.33, Pact2/1 establish the hypothesis.
  These are NOT device-verified or schema promotion evidence.
  Direction 0/1 means clockwise/anticlockwise; camera position 0/1 top/bottom.
  Camera 0 absent and 2 incompatible are untested; only 1 healthy was tested.
  A3 and static detail expose Color > Subsection > Gradient, not HA transition
  duration or a proven visual blending algorithm.  Other revisions and unknown
  tails remain unqualified.
seq:
  - id: value
    type: u1
  - id: unknown_tail
    size-eos: true
enums:
  camera_status:
    0: absent
    1: healthy
    2: incompatible
types:
  write_value:
    seq:
      - id: value
        type: u1
      - id: unknown_tail
        size-eos: true
  camera_state:
    seq:
      - id: value
        type: u1
        enum: camera_status
      - id: unknown_tail
        size-eos: true
  static_detail:
    seq:
      - id: gradient
        type: u1
      - id: unknown_tail
        size-eos: true
