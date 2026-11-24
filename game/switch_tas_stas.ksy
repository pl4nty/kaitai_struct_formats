# Imported from https://github.com/MonsterDruide1/STAS-file-format/blob/b3f79a7b9d5e38d84ba1f6846588fd09e452c4b8/stas.ksy
# NOTE: this version corresponds to v0 emitted by TAS-Editor.
# it was badly hacked together and did not even adhere to the specification made up beforehand.
# this is now declared as v0, as it has been public for almost 3 years
# and is the only existing implementation of STAS files up to this point.
# If you plan on adding STAS support to any program,
# please wait a few days until v1 has been finalized and
# this file has been updated accordingly.

meta:
  id: switch_tas_stas
  title: (Nintendo) Switch Tool Assisted Speedruns
  file-extension: stas
  license: LicenseRef-All-Rights-Reserved
  endian: le

doc: |
  STAS is a file format developed by Nintendo Switch TASing enthusiasts,
  capable of providing not only controller input data to games for scripting
  purposes.

seq:
  - id: header
    type: header
    doc: Generic information about version and game
  - id: scriptheader
    type: scriptheader
    doc: Metadata about this script
  - id: commands
    type: command
    repeat: expr
    repeat-expr: scriptheader.command_count

types:

  header:
    seq:
      - id: magic
        contents: STAS
      - id: version_stas
        contents: [0x00, 0x00]
      - id: version_game_addon
        type: u2
        doc: Version of game-specific commands
      - id: version_editor
        type: u2
        doc: Version of editor-specific commands
      - id: padding
        size: 2
      - id: game_titleid
        type: u8
        doc: TitleID of the game this script should be played back on.
        doc-ref: https://switchbrew.org/wiki/Title_list/Games
  
  scriptheader:
    seq:
      - id: command_count
        type: u4
        doc: |
          Total number of commands stored in this file.
          Note: This contains no information about playback length!
      - id: seconds_editing
        type: u4
        doc: Total time users spent editing this script, counted in seconds.
      - id: controller_count
        type: u1
        doc: |
          Number of controllers that input is provided for in this playback.
          Note: May not be used to change number of active controllers in a game!
          An explicit command should be used for that purpose.
      - id: padding
        size: 3
      - id: controller_type
        type: u1
        enum: controller_type
        repeat: expr
        repeat-expr: 4
        doc: Type of controller for each active controller.
      - id: author_name_len
        type: u2
      - id: author_name
        size: author_name_len
        type: str
        pad-right: 4
        encoding: UTF-8
        doc: |
          Author(s) of this script. Collaborative work may use any delimiter to
          specify multiple authors.
  
  command:
    seq:
      - id: type
        type: u2
        enum: command_type
        doc: |
          Type of the command.
          [00000 - 32767] / [0x0000 - 0x7fff]: generic commands
          [32768 - 49151] / [0x8000 - 0xbfff]: editor-specific commands
          [49152 - 65535] / [0xc000 - 0xffff]: game-specific commands
      - id: size
        type: u2
        valid:
          expr: _ % 4 == 0
      - id: data
        size: size
        type:
          switch-on: type
          cases:
            'command_type::frame': command_frame
            'command_type::controller': command_controller
    
    types:
      command_frame:
        doc: |
          Waits until the given frame has been reached.
          Further commands will only be parsed/played back afterwards.
          Note: counting method may be game-specific and may be different
          between different versions of the game addon (for example
          including/excluding load time)
        seq:
          - id: frame
            type: u4
        
      command_controller:
        doc: |
          Change controller inputs for one specific controller. This new state
          will be held until a new command overrides the state again. Whether inputs
          are held at the end of a script is implementation-defined - keep in mind
          that the protocol does not have a clear end though, so inputs may be held
          indefinitely there.
        seq:
          - id: controller_id
            type: u1
            doc: |
              Indicates which controller's input data should be changed.
              Must be within range of controller number, specified by
              the script header.
          - id: padding
            size: 3
          - id: buttons
            type: u8
            doc: |
              Bitmap, where each bit stands for one specific button on the controller.
              Position/Button-mappings follow the interface between nnsdk and games.
              Example: 1=A, 2=B, 4=X, 8=Y, 16=StickL, ...
            doc-ref: https://github.com/open-ead/nnheaders/blob/92b288975ad26a089dac4c0a405cfaec06d81297/include/nn/hid.h#L22-L56
          - id: left_stick
            type: stick_data
          - id: right_stick
            type: stick_data
        types:
          stick_data:
            doc: |
              Position of a joystick.
              Range is from -32768 to 32767 for each dimension, with
              (0,0) being perfectly centered.
            seq:
              - id: x
                type: s4
              - id: 'y'
                type: s4

enums:
  controller_type:
    0x00: pro_controller
    0x01: dual_joycon
    0x02: left_joycon
    0x03: right_joycon
    0x04: handheld
  
  command_type:
    0x0000: frame
    0x0001: controller
