# Imported from https://github.com/Game3DEE/webcarnivores/blob/b87a109d41179b1a8e8c9c78f63dda7a96339a2b/src/kaitai/vtl.ksy
# Licence and copyright: see _community/README.md
meta:
  id: carnivores_vtl
  title: VTL animation file format for Carnivores
  application: Animator 7
  license: CC0-1.0
  imports:
    - ivector
  encoding: UTF-8
  endian: le

doc-ref: https://carnivores.fandom.com/wiki/VTL

seq:
  - id: vertex_count
    type: u4
  - id: frames_per_second
    type: u4
  - id: frame_count
    type: u4
  - id: frames
    type: frame
    repeat: expr
    repeat-expr: frame_count

types:
  frame:
    seq:
      - id: vertices
        type: ivector
        repeat: expr
        repeat-expr: _root.vertex_count
