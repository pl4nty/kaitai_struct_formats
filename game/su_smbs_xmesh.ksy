# Imported from https://github.com/MaouAnimus/YoteiPort/blob/7994dfaa023691469ac0f6b03a96afe55896f47c/tools/smbs_xmesh.ksy
meta:
  id: su_smbs_xmesh
  title: Sucker Punch Ghost of Yotei SMBS 3D Mesh (.xmesh)
  file-extension: xmesh
  license: MIT
  endian: le

doc: |
  Sucker Punch Productions SMBS ("SBMS" reversed) v1.0.2.0 mesh container
  used in Ghost of Yotei (`cache_ps5/meshes/*.xmesh`).
  Contains two 0xbadbad13 sentinels:
    1. After the 36-byte header, introducing `num_submeshes` (47-byte submesh
       descriptors)
    2. Before the LOD offset table (`num_lods * 5` bytes) and the contiguous
       16-bit index buffers, 8-byte quantized int16 vertex streams, and
       Oodle-compressed
       `PSR_BVHC` hardware ray-tracing BVH chunks.

seq:
  - id: magic
    contents: "SMBS"
  - id: version_major
    type: u2
  - id: version_minor
    type: u2
  - id: content_hash
    size: 16
  - id: header_size
    type: u4
  - id: reserved_1c
    type: u4
  - id: payload_size
    type: u4
  - id: sentinel_1
    contents: [0x13, 0xad, 0xdb, 0xba]
  - id: num_submeshes
    type: u4
  - id: submeshes
    type: submesh_descriptor
    repeat: expr
    repeat-expr: num_submeshes
  - id: sentinel_2
    contents: [0x13, 0xad, 0xdb, 0xba]
  - id: num_lods
    type: u4
  - id: lod_entries
    type: lod_entry
    repeat: expr
    repeat-expr: num_lods
  - id: geometry_streams
    size-eos: true

types:
  submesh_descriptor:
    seq:
      - id: submesh_hash
        type: u8
      - id: index_buffer_offset
        type: u4
      - id: lod_flags
        type: u1
      - id: vertex_format_flags
        type: u1
      - id: stream_count
        type: u1
      - id: index_end_offset
        type: u4
      - id: position_stream_offset
        type: u4
      - id: stream_offsets
        type: u4
        repeat: expr
        repeat-expr: 6

  lod_entry:
    seq:
      - id: lod_type
        type: u1
      - id: stream_base_offset
        type: u4
