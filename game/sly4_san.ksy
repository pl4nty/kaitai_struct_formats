# Imported from https://github.com/SK83RJOSH/SlyTools/blob/890f9458dc3a8fef702ecc7408922c25439c4218/Research/Kaitai/sly4_san.ksy
# Licence and copyright: see _community/README.md
meta:
  id: sly4_san
  title: "Sanzaru File"
  application: "Sly Cooper: Thieves in Time"
  file-extension: san san.cooked
  license: MIT
  encoding: ASCII
  endian: le
seq:
  - id: header
    type: header
  - id: body
    size: header.file_size - 4
    type: body
types:
  header:
    seq:
      - id: magic
        contents: FORM
      - id: file_size
        type: u4
  body:
    seq:
      - id: block
        type: block
        repeat: eos
  block:
    seq:
      - id: type
        size: 4
        type: str
      - id: data
        type:
          switch-on: type
          cases:
            '"PLAT"': plat
            # Segment Types
            '"PRFE"': prfe
            '"PROF"': prof
            '"PRFN"': prfn
            # Texture Types
            '"TEXR"': texr
            '"TXRH"': txrh
            '"TGXT"': tgxt
            '"TINC"': tinc
            # Material Types
            '"MATL"': matl
            '"MTLH"': mtlh
            '"MTLC"': mtlc
            # Mesh Types
            '"MESH"': mesh
            # Geometry Types
            '"GEOB"': geob
            '"GEOH"': geoh
            '"GLOD"': glod
            '"SKEL"': skel
            '"SKHD"': skhd
            '"BONS"': bons
            # Light Types
            # Emitter Types
            _: fill
  plat:
    seq:
      - id: data
        size: 8
  prof:
    seq:
      - id: unknown
        type: u4
  prfe:
    seq:
      - id: unknown
        type: u4
  prfn: # Name block?
    seq:
      - id: size
        type: u4
      - id: name
        size: size - 4
        type: strz
  texr: # Texture type...?
    seq:
      - id: unknown
        type: u4
  txrh: # Texture header?
    seq:
      - id: size
        type: u4
      - id: unknown_0
        type: u1
      - id: name_hash
        type: u4
      - id: unknown_1
        type: u1
        repeat: expr
        repeat-expr: 7
      - id: name
        size: 40
        type: str
  tgxt: # Texture GXT format
    seq:
      - id: size
        type: u4
      - id: data
        size: size - 4
  tinc: # Texture Include
    seq:
      - id: size
        type: u2
      - id: string_length
        type: u4be # This was definitely a mistake on their end... lol
      - id: string
        size: string_length
        type: str
      - id: padding
        size: size - 2 - string_length - 4
  matl:
    seq:
      - id: unknown
        type: u4
  mtlh:
    seq:
      - id: size
        type: u4
      - id: unknown
        type: u1
        repeat: expr
        repeat-expr: size - 4
  mtlc:
    seq:
      - id: size
        type: u4
      - id: unknown
        type: u1
        repeat: expr
        repeat-expr: size - 4
  mesh:
    seq:
      - id: size
        type: u4
      - id: unknown
        type: u1
        repeat: expr
        repeat-expr: size - 4
  geob:
    seq:
      - id: unknown
        type: u4
  geoh:
    seq:
      - id: size
        type: u4
      - id: unknown
        size: size - 4
  glod:
    seq:
      - id: size
        type: u4
      - id: unknown
        size: size - 4
  skel:
    seq:
      - id: unknown
        type: u4
  skhd:
    seq:
      - id: size
        type: u4
      - id: unknown
        size: size - 4
  bons:
    seq:
      - id: size
        type: u4
      - id: unknown
        size: size - 4
  fill:
    seq:
      - id: data
        size: _io.size - _io.pos
