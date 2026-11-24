# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/blood_splat.ksy
meta:
  id: blood_splat
  title: 'Project Zomboid save: blood splat'
  license: MIT
  endian: be
types:
  # iso.IsoFloorBloodSplat.save / load
  floor:
    seq:
      - id: x_byte
        type: u1
      - id: y_byte
        type: u1
      - id: z_byte
        type: u1
      - id: type_id
        type: u1
      - id: world_age
        type: f4
      - id: index
        type: u1

  # iso.IsoWallBloodSplat.save / load
  wall:
    seq:
      - id: world_age
        type: f4
      - id: sprite_id
        type: s4
