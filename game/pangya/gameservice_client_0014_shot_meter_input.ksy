# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0014.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/client 0014
#pragma.parseAs GameserviceClientPacket
meta:
  id: gameservice_client_0014_shot_meter_input
  title: GameService Client Shot Meter Input
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet relays how the user has powered their shot with the shot meter.
  
  It is sent 3 times per shot, corresponding to each of the 3 spacebar presses.
  
  For putts, 0x02-strength is skipped, 0x03-accuracy is used for power, and an
  (erroneous?) 0x00-cancel sent later. All putts are 100% accurate.
  
  There is no response.
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_ACTION_HIT`
  * `eantoniobr/UGPangya`: `PLAYER_MOVE_BAR`

seq:
  - id: input_sequence
    type: u1
    enum: input_sequence
  - id: meter_value
    type: f4
    doc: |
      Position of sliding bar.
      140 (Centred Pangya Bar), increasing linearly to 500 (Full Power).
      Types 0x00 and 0x01 always contain current location of pangya bar.

enums:
  input_sequence:
    0x00: shot_cancelled
    0x01: shot_started
    0x02: shot_strength_set
    0x03: shot_accuracy_set
