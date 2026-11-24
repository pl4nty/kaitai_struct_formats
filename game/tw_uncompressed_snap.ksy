# Imported from https://github.com/heinrich5991/libtw2/blob/060e4b6450fba9f5baa59e430dc22714f2757162/doc/uncompressed_snap.ksy
# Licence and copyright: see _community/README.md
meta:
  id: tw_uncompressed_snap
  title: Teeworlds uncompressed snapshot
  license: MIT OR Apache-2.0
  endian: be
doc-ref: https://github.com/heinrich5991/libtw2/blob/83f22dbfe713682f7c528473c2f727049928a9dd/doc/snapshot.md#snapshots
seq:
  - id: header
    type: header
  - id: offsets
    type: u4
    repeat: expr
    repeat-expr: header.num_items
  - id: items
    size: '(_index == header.num_items - 1 ? header.data_size : offsets[_index + 1]) - offsets[_index]'
    type: item
    repeat: expr
    repeat-expr: header.num_items
types:
  header:
    seq:
      - id: data_size
        type: s4
      - id: num_items
        type: s4
  item:
    seq:
      - id: type_id
        type: u2
      - id: id
        type: u2
      - id: data
        type: s4
        repeat: eos
