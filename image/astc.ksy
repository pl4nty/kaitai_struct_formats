meta:
  id: astc
  title: ASTC compressed texture file
  application: ARM ASTC Encoder (astcenc)
  file-extension: astc
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Container for textures compressed with Adaptive Scalable Texture
  Compression (ASTC), as read and written by the ARM `astcenc` reference
  encoder. The file is a 16-byte header (magic 0x5CA1AB13, block
  footprint in texels, image dimensions as 24-bit little-endian integers)
  followed by the compressed data: one 128-bit (16-byte) block per block
  footprint, for ceil(dim_x / block_x) * ceil(dim_y / block_y) *
  ceil(dim_z / block_z) blocks.

  The internal bit-level encoding of the ASTC blocks themselves (as
  defined in the Khronos ASTC specification) is not decoded here; each
  block is exposed as 16 raw bytes.
doc-ref: https://github.com/ARM-software/astc-encoder/blob/main/Source/astcenccli_image_load_store.cpp
seq:
  - id: magic
    contents: [0x13, 0xab, 0xa1, 0x5c]
  - id: block_x
    type: u1
    doc: Block footprint width in texels.
  - id: block_y
    type: u1
    doc: Block footprint height in texels.
  - id: block_z
    type: u1
    doc: Block footprint depth in texels (1 for 2D textures).
  - id: dim_x
    type: b24le
    doc: Image width in texels.
  - id: dim_y
    type: b24le
    doc: Image height in texels.
  - id: dim_z
    type: b24le
    doc: Image depth in texels (1 for 2D textures).
  - id: blocks
    size: 16
    repeat: expr
    repeat-expr: num_blocks
    doc: Compressed 128-bit ASTC blocks.
instances:
  num_blocks_x:
    value: '(dim_x + (block_x == 0 ? 1 : block_x) - 1) / (block_x == 0 ? 1 : block_x)'
  num_blocks_y:
    value: '(dim_y + (block_y == 0 ? 1 : block_y) - 1) / (block_y == 0 ? 1 : block_y)'
  num_blocks_z:
    value: '(dim_z + (block_z == 0 ? 1 : block_z) - 1) / (block_z == 0 ? 1 : block_z)'
  num_blocks:
    value: num_blocks_x * num_blocks_y * num_blocks_z
