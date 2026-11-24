# Imported from https://github.com/iconmaster5326/CrystalProjector/blob/79320b343d603aa069aa023fd54020d36419e082/schema/ksy/map_meta.ksy
# Licence and copyright: see _community/README.md
meta:
  id: crystal_project_map_meta
  title: Crystal Project map metadata
  license: MIT
  endian: le
doc: |
  Metadata for a particular map. This file is at `maps/map_MAPNAME/meta.dat`,
  where `MAPNAME` is either `biomeX` or `world`, in the world ZIP.
seq:
  - id: version
    type: u1
    doc: The version number of this map.
  - id: pos_y
    type: s4
    doc: The Y level this map should be rendered at in the world map.
  - id: pos_x
    type: s4
    doc: The X coordinate the map starts at, in voxel coordinates.
  - id: pos_z
    type: s4
    doc: The Z coordinate the map starts at, in voxel coordinates.
  - id: size_x
    type: u4
    doc: The size of this map along the X axis.
  - id: size_z
    type: u4
    doc: The size of this map along the Z axis.
  - id: region_size_x
    type: u4
    valid: 64
    doc: The maximum size a map region can cover along the X axis. Always 64.
  - id: region_size_z
    type: u4
    valid: 64
    doc: The maximum size a map region can cover along the Z axis. Always 64.
  - id: num_regions_x
    type: u4
    doc: The number of regions this map contains along the X axis.
  - id: num_regions_z
    type: u4
    doc: The number of regions this map contains along the Z axis.
