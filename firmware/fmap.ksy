meta:
  id: fmap
  title: Flashmap (FMAP) firmware layout descriptor
  application:
    - coreboot
    - ChromeOS firmware
    - flashrom
  license: CC0-1.0
  ks-version: '0.11'
  encoding: ASCII
  endian: le
doc: |
  The flashmap (FMAP) is a small table embedded in a firmware (SPI flash)
  image that describes its layout: the image's base address and size,
  and a list of named areas (offset, size, flags).

  The structure can be located anywhere in the image; tools find it by
  searching for the `__FMAP__` signature. This spec parses the
  structure starting at the signature, so parse from the offset where
  it was found. Area offsets are relative to the start of the firmware
  image.
doc-ref:
  - https://github.com/dhendrix/flashmap/blob/976420e9ecae3c3933d5e59e67a4debad751d003/lib/fmap.h
  - https://github.com/coreboot/coreboot/blob/667bb51c36342291dfcb2cf472f3fe110666ef06/src/commonlib/bsd/include/commonlib/bsd/fmap_serialized.h
seq:
  - id: signature
    contents: __FMAP__
  - id: version
    type: version
  - id: base
    type: u8
    doc: Address of the firmware binary (e.g. where it is mapped in memory).
  - id: len_image
    type: u4
    doc: Size of the firmware binary in bytes.
  - id: name
    size: 32
    type: strz
    doc: Name of this firmware binary.
  - id: num_areas
    type: u2
  - id: areas
    type: area
    repeat: expr
    repeat-expr: num_areas
types:
  version:
    seq:
      - id: major
        type: u1
      - id: minor
        type: u1
    -webide-representation: '{major:dec}.{minor:dec}'
  area:
    seq:
      - id: ofs_area
        type: u4
        doc: Offset of the area, relative to the start of the image.
      - id: len_area
        type: u4
      - id: name
        size: 32
        type: strz
      - id: flags
        type: area_flags
    -webide-representation: '{name} ofs={ofs_area} len={len_area}'
  area_flags:
    meta:
      bit-endian: le
    seq:
      - id: is_static
        -orig-id: FMAP_AREA_STATIC
        type: b1
        doc: Static area; only static areas are covered by the FMAP checksum tool.
      - id: compressed
        -orig-id: FMAP_AREA_COMPRESSED
        type: b1
      - id: read_only
        -orig-id: FMAP_AREA_RO
        type: b1
      - id: preserve
        -orig-id: FMAP_AREA_PRESERVE
        type: b1
      - id: reserved
        type: b12
