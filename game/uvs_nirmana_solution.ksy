# Imported from https://gist.github.com/yut23/1a85cf1dd2650bf37c1951c73f654609
# author: https://github.com/yut23, @yut23 on discord
meta:
  id: uvs_nirmana_solution
  application: U.V.S. Nirmana
  file-extension: solution
  license: MIT
  endian: le

seq:
  - id: version
    type: s4
    valid:
      any-of: [1]
  - id: level_id
    type: s4
    enum: level_id
  - id: name_len
    type: s4
  - id: name
    size: name_len
    type: str
    encoding: UTF-8
    if: name_len > 0
  - id: solved
    type: u1
  - id: width
    type: s4
  - id: height
    type: s4
  - id: flux
    type: s4
  - id: num_parts
    type: s4
  - id: parts
    type: part
    repeat: expr
    repeat-expr: num_parts
  - id: num_matrix_parts
    type: s4
  - id: matrix_parts
    type: matrix_part
    repeat: expr
    repeat-expr: num_matrix_parts

types:
  position:
    seq:
      - id: column
        type: s4
      - id: row
        type: s4
  offset:
    seq:
      - id: cols
        type: s4
      - id: rows
        type: s4
  part:
    seq:
      - id: tool
        type: s4
        enum: tool_id
      - id: pos
        type: position
      - id: num_pipes
        type: s4
      - id: pipe_offsets
        type: offset
        repeat: expr
        repeat-expr: num_pipes
    -webide-representation: "{tool} @ ({pos.column:dec},{pos.row:dec})"
  matrix_part:
    seq:
      - id: pos
        type: position
      - id: type
        type: s4
        enum: matrix_part_id

enums:
  tool_id:
    1: valve
    2: demux
    3: mux
    4: sense
    5: buffer
    6: input
    7: output
    8: pipe
    9: negation
    10: delay
    11: mixer
    12: demux_flipped
    13: mux_flipped
    14: toggle
    15: red
    16: green
    17: cleaner
    18: translate
    19: yellow
  matrix_part_id:
    0: driver
    1: relay
  level_id:
    26: komidai2
    9: b7_mimohe
    21: hrumsimigan
    25: nagarahara
    1: j9_takka
    8: atali4
    14: syghinan_prime
    13: d7_balura
    22: object_jaguda
    11: udyana3
    24: ns_huoh
    2: kita_oriens
    12: wakhsh_prime
    17: mathura_nova
    5: maha_talakan
    3: nalanda1
    15: the_batira_object
    7: kamarupa
    4: uvs_nayuta
    16: invakan3
    19: kn_uda
    18: smo
    10: gostana1
    20: n2_kurana
    6: tamra_occidens
    23: s1_varnu
    27: z0_yani
    28: unknown_1
    29: unknown_2
    30: nirodha
