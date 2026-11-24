# Imported from https://gist.githubusercontent.com/WhyIsEvery4thYearAlwaysBad/40646b480680ff31be12f88ff178f808/raw/d5b27c74f14f127b219491979dcfa6f8b9cb4bad/valve_binary_space_partition_format.ksy
meta:
  id: valve_vbsp
  title: "Valve Binary Space Partition"
  file-extension: bsp
  tags:
    - bsp
    - source
    - valve
    - vbsp
  license: LicenseRef-All-Rights-Reserved
  endian: le

doc: |
  Valve Binary Space Partition, or VBSP, is a file format for levels; it is a
  variant of the Binary Space Partition level format used by Quake.

  VBSP are primarily created through the `vbsp` executable, made by Valve that is
  packaged in the Source Engine.

  **TODO: Handle LZMA data.**
  
doc-ref: https://developer.valvesoftware.com/wiki/VBSP

seq:
  - id: signature
    contents: "VBSP"
    doc: The format signature to identify VBSP files.
    
  - id: version
    type: u4
    doc: File format version.
  - id: lump_header_array
    type: lump_header
    repeat: expr
    repeat-expr: 64
    doc: 64-dimension array of lump metadata.

  - id: map_revision_number
    type: u4
    doc: An integer that stores the map's iteration and version.
      
types:
  lump_header:
    seq:
      - id: file_offset
        type: u4
        doc: Location of the data lump.
          
      - id: byte_length
        type: u4
        doc: Byte length of the data lump.

      - id: version
        type: u4
        doc: Format version of the data lump.

      - id: identifier
        size: 4
        doc: 4th-dimensional byte array to identify the data lump.
          
    instances:
      lump:
        pos: file_offset
        size: byte_length
        doc: The data stored by the lump.

# SUGGESTION: Should I add preset lump types.
