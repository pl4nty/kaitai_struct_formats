# Imported from https://github.com/redtoad/xcom-editor/blob/47e3ba29f2f3077ea9245405589459e5d3fce536/misc/kaitai-structs/BPROD.DAT.ksy
# Licence and copyright: see _community/README.md
meta:
  id: xcom_bprod_dat
  title: Format of BPROD.DAT
  file-extension: DAT
  license: MIT
  endian: le
doc: |
  BPROD.DAT holds the manufacturing progress of each base.

  The file is 2800 bytes long (8 bases * 350 bytes).
doc-ref: https://www.ufopaedia.org/index.php/BPROD.DAT
seq:
  - id: bases
    size: 350
    type: base_production
    repeat: expr
    repeat-expr: 8
types:
  base_production:
    doc: |
      The manufacturing progress of a single base. All arrays have 35 entries
      and are indexed in the same order as PRODUCT.DAT. Completed projects are
      reset to 0 in all fields.
    seq:
      - id: hours_stored
        type: s4
        repeat: expr
        repeat-expr: 35
        doc: |
          Hours of work done towards the next unit. An item is only shown as in
          production if this value is not 0.
      - id: engineers
        type: s2
        repeat: expr
        repeat-expr: 35
        doc: Engineers allocated.
      - id: total
        type: s2
        repeat: expr
        repeat-expr: 35
        doc: Total number of units to produce.
      - id: produced
        type: s2
        repeat: expr
        repeat-expr: 35
        doc: Number of units produced.
