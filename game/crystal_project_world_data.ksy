# Imported from https://github.com/iconmaster5326/CrystalProjector/blob/79320b343d603aa069aa023fd54020d36419e082/schema/ksy/world_data.ksy
meta:
  id: crystal_project_world_data
  title: Crystal Project world data
  license: MIT
  endian: le
doc: |
  A world data file contains information about the `WORLDNAME.dat` file nested in
  a world file called WORLDNAME in the world ZIP.
seq:
  - id: len_metadata
    type: u4
    doc: How long is the metadata field?
  - id: metadata
    size: len_metadata
    type: str
    encoding: UTF-8
    doc: |
      A string containing /r/n separated key=value pairs, representing global map
      information.
  - id: len_warp_points
    type: u4
    doc: How long is the warp-points field?
  - id: warp_points
    size: len_warp_points
    type: str
    encoding: UTF-8
    doc: |
      A string containing /r/n separated I:X1,Y1,Z1:X2,Y2,Z2; pairs, representing
      teleport points on the map.
  - id: num_layer_infos
    type: u4
    doc: How many chunk layers are there in this map?
  - id: layer_infos
    type: layer_info
    repeat: expr
    repeat-expr: num_layer_infos
    doc: Basic chunk layer information used to find the chunk layer archives.
  - id: magic1
    size: 4
    doc: Unknown.
  - id: len_layers
    type: u4
    doc: The total size of all the layer archives in bytes.
  - id: layers
    size: len_layers
    doc: |
      The chunk layer archive files. ZIP format. Use the `offset` and `length` fields
      in `layer_info`s to read these.
instances:
  start_of_layers:
    value: 4 + len_metadata + 4 + len_warp_points + 4 + num_layer_infos*16 + 4 + 4
    doc: The address of the start of `layers`.
types:
  layer_info:
    doc: Basic chunk layer information used to find a chunk layer archive.
    seq:
      - id: x
        type: s4
        doc: The X coordinate of the chunk layer.
      - id: z
        type: s4
        doc: The Z coordinate of the chunk layer.
      - id: offset
        type: u4
        doc: |
          The relative offset from the beginning of `layers` into which you can find this
          archive.
        # valid:
        #   max: _parent.len_layers
      - id: length
        type: u4
        doc: The size of the archive.
        # valid:
        #   max: _parent.len_layers
    instances:
      layer:
        io: _parent._io
        pos: _parent.start_of_layers + offset
        size: length
        doc: The layer archive. A ZIP file.
