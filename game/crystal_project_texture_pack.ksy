# Imported from https://github.com/iconmaster5326/CrystalProjector/blob/79320b343d603aa069aa023fd54020d36419e082/schema/ksy/texture_pack.ksy
meta:
  id: crystal_project_texture_pack
  title: Crystal Project texture pack
  license: MIT
  endian: le
doc: |
  A packed bundle of textures, found in top-level `.dat` files in the `Textures`
  directory.
seq:
  - id: version
    type: u2
    doc: The version of this pack.
  - id: num_textures
    type: u4
    doc: How many textures are in this pack?
  - id: texture_headers
    type: texture_header
    repeat: expr
    repeat-expr: num_textures
    doc: Headers for each texture.
  - id: textures
    type: texture
    repeat: expr
    repeat-expr: num_textures
    doc: The textures in this pack.
types:
  texture_header:
    doc: Metadata found before a texture.
    seq:
      - id: magic1
        size: 7
        doc: Unknown.
  texture:
    doc: A named texture.
    seq:
      - id: len_name
        type: u4
        doc: How long the texture's name is.
      - id: name
        size: len_name
        type: str
        encoding: UTF-8
      - id: len_image
        type: u4
        doc: How long the texture file is.
      - id: image
        size: len_image
        doc: The actual texture. A PNG file.
