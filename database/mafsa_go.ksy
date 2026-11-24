meta:
  id: mafsa_go
  title: Go mafsa MA-FSA serialization
  application: mafsa (Go package)
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  Binary serialization of a Minimal Acyclic Finite State Automaton
  (MA-FSA, also known as a DAWG), a compact set of strings, as written
  by the Go `mafsa` package (`BuildTree.Save` / `Encoder`) and read by
  `mafsa.Load` / `Decoder`.

  The file is a sequence of fixed-layout edge entries. It starts with a
  header entry holding the format version (2) and the size of child
  pointers in bytes (2, 4 or 8; the encoder writes 4), padded with
  zeros to `ptr_len + 2` bytes. The outgoing edges of the root node
  follow immediately. A node is stored as the list of its outgoing
  edges, sorted by character; each edge is a flags byte (end of word,
  last edge of the node, and the length of the character in bytes), one
  UTF-8 encoded character and a big-endian pointer to the edge list of
  the target node (0 if the target has no outgoing edges). Nodes may be
  shared by several edges, so the structure is a DAG.

  The set of strings is every path from the root ending at an edge
  whose `is_final` flag is set.
doc-ref:
  - https://github.com/Shugyousha/mafsa/blob/fcf5239b4c34313f16ffd5d779528ce5e011bf90/encoder.go
  - https://github.com/Shugyousha/mafsa/blob/fcf5239b4c34313f16ffd5d779528ce5e011bf90/decoder.go
seq:
  - id: version
    -orig-id: fileVer
    type: u1
    doc: Flag scheme / file format version; the encoder writes 2.
  - id: ptr_size
    -orig-id: ptrLen
    type: u1
    valid:
      any-of: [2, 4, 8]
  - id: header_padding
    size: ptr_size
  - id: root
    type: node
types:
  node:
    seq:
      - id: edges
        type: edge
        repeat: until
        repeat-until: _.is_last
  edge:
    seq:
      - id: char_len
        -orig-id: charLen
        type: b6
        doc: Length of `char` in bytes (1-4).
      - id: is_last
        -orig-id: endOfNode
        type: b1
        doc: This is the last outgoing edge of its node.
      - id: is_final
        -orig-id: endOfWord
        type: b1
        doc: A string of the set ends after this edge.
      - id: char
        size: char_len
        type: str
        encoding: UTF-8
      - id: ptr
        type:
          switch-on: _root.ptr_size
          cases:
            2: u2
            4: u4
            8: u8
        doc: Offset of the target node's edge list, or 0 if it has no outgoing edges.
    instances:
      target:
        io: _root._io
        pos: ptr
        type: node
        if: ptr != 0
