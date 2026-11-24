# Imported from https://github.com/cphyc/astrophysics_toolset/blob/5f7e7922124821c011a0407be65a33889be40371/astrophysics_toolset/io/_disperse.ksy
meta:
  id: disperse_ndskl
  file-extension: NDskl
  license: CC0-1.0
  encoding: ASCII
  endian: le
doc-ref: http://www2.iap.fr/users/sousbie/web/html/indexf83e.html?post/NDskl-format
seq:
  - id: header
    type: header
  - id: data
    type: data
types:
  header:
    seq:
      - size: 4
        contents: [16, 0, 0, 0]
      - contents: ['N', 'D', 'S', 'K', 'E', 'L', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]  # Magic
      - size: 8
        contents: [16, 0, 0, 0, 0, 0, 0, 0]
      - id: comment
        size: 80
        type: str
      - id: ndim
        type: u4
      - id: dims
        type: u4
        repeat: expr
        repeat-expr: ndim
      - type: u4  # Pad to length of 20
        repeat: expr
        repeat-expr: 20-ndim
      - id: x0
        type: f8
        repeat: expr
        repeat-expr: ndim
      - type: f8  # Pad to length of 20
        repeat: expr
        repeat-expr: 20-ndim
      - id: delta
        type: f8
        repeat: expr
        repeat-expr: ndim
      - type: f8  # Pad to length of 20
        repeat: expr
        repeat-expr: 20-ndim
      - id: nseg
        type: u4
      - id: nnode
        type: u4
      - id: nseg_data
        type: u4
      - id: nnode_data
        type: u4
      - type: u4  # Dummy
      - type: u4  # Dummy
      - id: seg_data_info
        size: 20
        type: str
        repeat: expr
        repeat-expr: nseg_data
      - type: u4  # Dummy
      - type: u4  # Dummy
      - id: node_data_info
        size: 20
        type: str
        repeat: expr
        repeat-expr: nnode_data
      - type: u4  # Dummy
      - type: u4  # Dummy
  data:
    seq:
      - id: seg_pos
        type: f4
        repeat: expr
        repeat-expr: 2*_root.header.ndim*_root.header.nseg
      - type: u4  # Dummy
      - type: u4  # Dummy
      - id: node_pos
        type: f4
        repeat: expr
        repeat-expr: _root.header.ndim*_root.header.nnode
      - type: u4  # Dummy
      - type: u4  # Dummy
      - id: seg_data
        type: f8
        repeat: expr
        repeat-expr: _root.header.nseg*_root.header.nseg_data
      - type: u4  # Dummy
      - type: u4  # Dummy
      - id: node_data
        type: f8
        repeat: expr
        repeat-expr: _root.header.nnode*_root.header.nnode_data
      - type: u4  # Dummy
      - type: u4  # Dummy
      - id: node_data_int
        type: node_struct
        repeat: expr
        repeat-expr: _root.header.nnode
      - type: u4  # Dummy
      - type: u4  # Dummy
      - id: seg_data_int
        type: seg_struct
        repeat: expr
        repeat-expr: _root.header.nseg
      - type: u4  # Dummy
  node_struct:
    seq:
      - id: pos_index
        type: u4
      - id: flags
        type: u4
        doc: Non-null if on boundary
      - id: nnext
        type: u4
        doc: Number of arcs connected
      - id: type
        type: u4
      - id: index
        type: u4
        doc: Critical index
      - id: nseg
        type: u4
        repeat: expr
        repeat-expr: nnext
      - id: seg_data
        type: seg_data_struct
        repeat: expr
        repeat-expr: nnext
  seg_data_struct:
    seq:
      - id: next_node
        type: u4
      - id: next_seg
        type: u4
  seg_struct:
    seq:
      - id: pos_index
        type: u4
      - id: node_ids
        type: u4
        repeat: expr
        repeat-expr: 2
        doc: |
          Index of the nodes at the extremity of the arc. Segment is oriented from
          nodes[0] toward nodes[1]
      - id: flags
        type: u4
        doc: Non-null if on boundary
      - id: index
        type: u4
        doc: Index of the segment in the Seg array
      - id: next_seg
        type: u4
        doc: Index of the next segment in the arc, -1 if extremity
      - id: prev_seg
        type: u4
        doc: Index of the previous segment in the arc, -1 if extremity
