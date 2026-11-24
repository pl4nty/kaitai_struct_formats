# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0063.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_0063_user_lounge_action
  title: GameService Client User Lounge Action
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet relays an action performed by the user in a lounge.
  
  The response is [GameService Server 0x00C4 User Lounge Action
  Announce](/packets/gameservice/server/00c4.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_ACTION`
  * `eantoniobr/UGPangya`: `PLAYER_ACTION`

seq:
  - id: action_type
    type: u1
    enum: action_type
  - id: action_payload
    type:
      switch-on: action_type
      cases:
        action_type::rotation_absolute: action_rotation_absolute
        action_type::position_absolute: action_position_absolute
        action_type::position_relative: action_position_relative
        action_type::emote: action_emote
        action_type::departure: action_departure

types:
  action_rotation_absolute:
    doc: Used in VS pre-game loadout screen.
    seq:
      - id: axis_z_rotation_absolute_radians
        type: f4
        doc: |
          Unconfirmed. Default is 0.33 (0x3EA8F5C3). Counterclockwise range about -2.81
          (0.33-3.14) to +3.47 (0.33+3.14).
  action_position_absolute:
    doc: Sent when initially joining a room.
    seq:
      - id: axis_x_position_absolute
        type: f4
        doc: East+/West- axis. Absolute position.
      - id: axis_z_position_absolute
        type: f4
        doc: North+/South- axis. Absolute position.
      - id: axis_y_position_absolute
        type: f4
        doc: Up+/Down- axis. Absolute position.
  action_position_relative:
    doc: Sent when making all other movements after joining.
    seq:
      - id: axis_x_position_relative
        type: f4
        doc: East+/West- axis. Relative to current position.
      - id: axis_z_position_relative
        type: f4
        doc: North+/South- axis. Relative to current position.
      - id: axis_y_position_relative
        type: f4
        doc: Up+/Down- axis. Relative to current position.
  action_emote:
    seq:
      - id: emote_string
        type: pstring
        doc: |
          For instance, "chat_\xB4\xED\xBD\xBA" (EUC-KR encoding, "chat_[daen][seu]") is
          the "/dance" emote command.
  action_departure:
    doc: |
      This type has not been witnessed, but is included here as a stub because of its
      inclusion in the response packet.

enums:
  action_type:
    0x00: rotation_absolute
    0x04: position_absolute
    0x06: position_relative
    0x07: emote
    0x08: departure
