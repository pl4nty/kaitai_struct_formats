# Imported from https://github.com/neilsh/stunt-reel/blob/e2981f3da2808cb21b06ceeae9a55c85706c80f3/research/formats/auxiliary/anchorpt.dat.ksy
# Executable structural layout of `ANCHORPT.DAT`.
# Format anchor: [FMT-MAP-ANCHORPT] in anchorpt.md.
#
# Exactly 1024 records of 28 bytes (28,672 bytes) across the four corpus
# copies; positions are followed by eleven raw scalars.
meta:
  id: stunt_island_anchorpt
  title: Stunt Island terrain anchor points (`ANCHORPT.DAT`)
  file-extension: dat
  license: LicenseRef-All-Rights-Reserved
  ks-version: 0.11
  endian: le
doc: |
  The fixed 1,024-record `ANCHORPT.DAT` anchor table. Meaning is in
  `anchorpt.md`.
seq:
  - id: points
    type: point
    repeat: expr
    repeat-expr: 1024
types:
  point:
    doc: One 28-byte terrain anchor record.
    seq:
      - id: x
        type: s2
      - id: 'y'
        type: s2
        doc: Topographic elevation.
      - id: z
        type: s2
      - id: scalars
        -orig-id: "f[11]"
        type: s2
        repeat: expr
        repeat-expr: 11
        doc: |
          Surface normal components, elevation tap slopes, and ground
          clamping scalars. Individual meanings remain partially decoded.
