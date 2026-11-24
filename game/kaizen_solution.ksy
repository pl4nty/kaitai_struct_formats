# Imported from https://gist.github.com/yut23/8092d812e4067372d24188ee7ebc859f
# author: https://github.com/yut23, @yut23 on discord
meta:
  id: kaizen_solution
  application: 'Kaizen: A Factory Story'
  file-extension: solution
  license: MIT
  endian: le

seq:
  - id: version
    type: s4
    valid:
      any-of: [10, 11]
  - id: level_id
    type: s4
  - id: name_len
    type: s4
  - id: name
    size: name_len
    type: str
    encoding: UTF-8
  - id: solved
    type: b1le
  - id: time
    type: s4
  - id: cost
    type: s4
  - id: area
    type: s4
  - id: num_tools
    type: s4
  - id: tools
    type: tool
    repeat: expr
    repeat-expr: num_tools
  - id: num_instructions
    type: u4
  - id: instructions
    type: instruction
    repeat: expr
    repeat-expr: num_instructions

types:
  position:
    doc: +x is right, +y is up
    seq:
      - id: x
        type: s4
      - id: y
        type: s4
    -webide-representation: '({x:dec}, {y:dec})'
  tool:
    seq:
      - id: type
        type: u4
        enum: tool_type
      - id: label
        type: s4
        valid:
          expr: 'type == tool_type::arm or type == tool_type::drill ? _ < 26 : _ == -1'
        doc: starts at index 0 for A, -1 for everything other than arms and drills
      - id: pos
        type: position
        doc: |
          position of the lower-left corner for parts, and the non-draggable tile for
          tools
      - id: end_offset
        type: position
        doc: position of the draggable tile for everything except parts and cutters
      - id: part_index
        type: s4
        valid:
          expr: 'type == tool_type::part ? true : _ == -1'
        doc: |
          starts at index 0, goes left to right, top to bottom, -1 for everything other
          than parts
  instruction:
    seq:
      - id: column
        type: s4
        doc: starts at index 0 (equal to the number in the timeline minus 1)
      - id: row
        type: s4
        doc: starts at index 0, max of 3
      - id: type
        type: s4
        enum: instr_type
      - id: target_label
        type: s4
      - id: distance
        type: s4
        # note: values that are too large are clamped to the max value
      - id: grab
        type: b1le
        doc: only used for push/pull and slide
      - id: unknown
        type: s4
        if: _root.version == 11
        doc: mystery value to be used in a future update

enums:
  tool_type:
    1: arm
    2: track
    3: welder
    4: riveter
    5: cutter
    6: part
    8: drill
  instr_type:
    1: push_pull
    2: slide
    3: flip
    4: poke
