meta:
  id: evil_islands_mob
  title: Evil Islands, MOB file (map entities)
  application: Evil Islands
  file-extension: mob
  license: MIT
  endian: le
doc: Map entities tree
doc-ref: https://github.com/aspadm/EIrepack/wiki/mob
seq:
  - id: root_node
    type: node
    doc: Root node
types:
  node:
    doc: Entity node
    seq:
      - id: type_id
        type: u4
        doc: Children type ID
      - id: size
        type: u4
        doc: Node full size
      - id: data
        size: size - 8
        type:
          switch-on: type_id
          cases:
            0x00001E00: node_list
            0x00001E01: node_list
            0x00001E02: node_list
            0x00001E03: node_list
            0x00001E0B: node_list
            0x00001E0E: node_list
            0x0000A000: node_list
            0x0000AA01: node_list
            0x0000ABD0: node_list
            0x0000B000: node_list
            0x0000B001: node_list
            0x0000CC01: node_list
            0x0000DD01: node_list
            0x0000E000: node_list
            0x0000E001: node_list
            0x0000F000: node_list
            0x0000FF00: node_list
            0x0000FF01: node_list
            0x0000FF02: node_list
            0xBBAB0000: node_list
            0xBBAC0000: node_list
            0xBBBB0000: node_list
            0xBBBC0000: node_list
            0xBBBD0000: node_list
            0xBBBE0000: node_list
            0xBBBF0000: node_list
            0xDDDDDDD1: node_list
        doc: |
          Stored data: a list of child nodes for the known container type
          IDs, raw bytes otherwise
  node_list:
    doc: Child nodes of a container node
    seq:
      - id: nodes
        type: node
        repeat: eos
