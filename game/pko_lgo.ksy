# Imported from https://github.com/Perseus/pko-tools/blob/87f29782b6146802283da6f9dcf64abd142940ad/formats/pko_lgo.ksy
meta:
  id: pko_lgo
  title: PKO LGO Geometry Container
  file-extension: lgo
  license: LicenseRef-All-Rights-Reserved
  imports:
    - pko_lmo
  endian: le
doc: |
  Direct lwGeomObjInfo container used by .lgo resources.
  The layout is:
    - u32 version
    - lwGeomObjInfo payload (same body parser as geometry chunks in pko_lmo)

seq:
  - id: version
    type: u4
    doc: Geometry format version
  - id: geometry
    size-eos: true
    type: pko_lmo::geometry_chunk(version, 0)
    doc: Geometry payload (delegated to pko_lmo geometry_chunk parser)
