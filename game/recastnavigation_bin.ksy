meta:
  id: recastnavigation_bin
  title: Recast Navigation navigation mesh set
  application: Recast Navigation (Detour)
  file-extension: bin
  license: CC0-1.0
  endian: le
doc: |
  Navigation mesh set as saved by the RecastDemo sample application of Recast
  Navigation, a navigation mesh toolkit used for path finding in games: a
  small header with the dtNavMeshParams, followed by the data of each tile of a
  multi-tile Detour navigation mesh (dtNavMesh). Each tile's data is the
  blob produced by dtCreateNavMeshData. This spec assumes 32-bit polygon
  references (the default, without DT_POLYREF64).
doc-ref:
  - https://masagroup.github.io/recastdetour
  - https://github.com/recastnavigation/recastnavigation/blob/main/RecastDemo/Source/Sample_TileMesh.cpp
  - https://github.com/recastnavigation/recastnavigation/blob/main/Detour/Include/DetourNavMesh.h
seq:
  - id: magic
    contents: "TESM"
    doc: NAVMESHSET_MAGIC ('MSET' as a little-endian integer).
  - id: version
    type: s4
  - id: num_tiles
    -orig-id: numTiles
    type: s4
  - id: origin
    -orig-id: orig
    type: float3
    doc: The world space origin of the navigation mesh's tile space. [(x, y, z)]
  - id: tile_width
    -orig-id: tileWidth
    type: f4
    doc: The width of each tile. (Along the x-axis.)
  - id: tile_height
    -orig-id: tileHeight
    type: f4
    doc: The height of each tile. (Along the z-axis.)
  - id: max_tiles
    -orig-id: maxTiles
    type: s4
    doc: The maximum number of tiles the navigation mesh can contain.
  - id: max_polys
    -orig-id: maxPolys
    type: s4
    doc: The maximum number of polygons each tile can contain.
  - id: tiles
    type: navmesh_tile
    repeat: expr
    repeat-expr: num_tiles
types:
  float3:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4
      - id: z
        type: f4
  dt_mesh_header:
    seq:
      - id: magic
        contents: "VAND"
        doc: Tile magic number. (Used to identify the data format.)
      - id: version
        type: s4
        doc: Tile data format version number.
      - id: x
        type: s4
        doc: The x-position of the tile within the dtNavMesh tile grid. (x, y, layer)
      - id: y
        type: s4
        doc: The y-position of the tile within the dtNavMesh tile grid. (x, y, layer)
      - id: layer
        type: s4
        doc: The layer of the tile within the dtNavMesh tile grid. (x, y, layer)
      - id: user_id
        type: u4
        doc: The user defined id of the tile.
      - id: num_polys
        -orig-id: polyCount
        type: s4
        doc: The number of polygons in the tile.
      - id: num_verts
        -orig-id: vertCount
        type: s4
        doc: The number of vertices in the tile.
      - id: max_links
        -orig-id: maxLinkCount
        type: s4
        doc: The number of allocated links.
      - id: num_detail_meshes
        -orig-id: detailMeshCount
        type: s4
        doc: The number of sub-meshes in the detail mesh.
      - id: num_detail_verts
        -orig-id: detailVertCount
        type: s4
        doc: |
          The number of unique vertices in the detail mesh. (In addition to the polygon
          vertices.)
      - id: num_detail_tris
        -orig-id: detailTriCount
        type: s4
        doc: The number of triangles in the detail mesh.
      - id: num_bv_nodes
        -orig-id: bvNodeCount
        type: s4
        doc: The number of bounding volume nodes. (Zero if bounding volumes are disabled.)
      - id: num_off_mesh_cons
        -orig-id: offMeshConCount
        type: s4
        doc: The number of off-mesh connections.
      - id: off_mesh_base
        type: s4
        doc: The index of the first polygon which is an off-mesh connection.
      - id: walkable_height
        type: f4
        doc: The height of the agents using the tile.
      - id: walkable_radius
        type: f4
        doc: The radius of the agents using the tile.
      - id: walkable_climb
        type: f4
        doc: The maximum climb height of the agents using the tile.
      - id: bmin
        type: float3
        doc: The minimum bounds of the tile's AABB. [(x, y, z)]
      - id: bmax
        type: float3
        doc: The maximum bounds of the tile's AABB. [(x, y, z)]
      - id: bv_quant_factor
        type: f4
        doc: The bounding volume quantization factor. 
  dt_poly:
    seq:
      - id: first_link
        type: u4
        doc: |
          Index to first link in linked list, or 0xffffffff (DT_NULL_LINK) if
          there is no link.
      - id: verts
        type: u2
        repeat: expr
        repeat-expr: 6
        doc: |
          The indices of the polygon's vertices.
          The actual vertices are located in dtMeshTile::verts.
      - id: neighbours
        -orig-id: neis
        type: u2
        repeat: expr
        repeat-expr: 6
        doc: Packed data representing neighbor polygons references and flags for each edge.
      - id: flags
        type: u2
        doc: The user defined polygon flags.
      - id: num_verts
        -orig-id: vertCount
        type: u1
        doc: The number of vertices in the polygon.
      - id: area_and_type
        type: u1
        doc: The bit packed area id and polygon type.
  dt_link:
    seq:
      - id: ref
        type: u4
        doc: Neighbour polygon reference (dtPolyRef). (The neighbor that is linked to.)
      - id: next
        type: u4
        doc: Index of the next link, or 0xffffffff (DT_NULL_LINK) at the end of the list.
      - id: edge
        type: u1
        doc: Index of the polygon edge that owns this link.
      - id: side
        type: u1
        doc: If a boundary link, defines on which side the link is.
      - id: bmin
        type: u1
        doc: If a boundary link, defines the minimum sub-edge area.
      - id: bmax
        type: u1
        doc: If a boundary link, defines the maximum sub-edge area.
  dt_poly_detail:
    seq:
      - id: vert_base
        type: u4
        doc: The offset of the vertices in the dtMeshTile::detailVerts array.
      - id: tri_base
        type: u4
        doc: The offset of the triangles in the dtMeshTile::detailTris array.
      - id: num_verts
        -orig-id: vertCount
        type: u1
        doc: The number of vertices in the sub-mesh.
      - id: num_tris
        -orig-id: triCount
        type: u1
        doc: The number of triangles in the sub-mesh.
      # - id: padding
      #   size: 2
      #   doc: for align for 4 bytes
  dt_bv_node:
    doc: Bounding volume node
    seq:
      - id: bmin
        type: u2
        repeat: expr
        repeat-expr: 3
        doc: Minimum bounds of the node's AABB. [(x, y, z)]
      - id: bmax
        type: u2
        repeat: expr
        repeat-expr: 3
        doc: Maximum bounds of the node's AABB. [(x, y, z)]
      - id: i
        type: s4
        doc: The node's index. (Negative for escape sequence.)
  dt_off_mesh_connection:
    doc: |
      Defines an navigation mesh off-mesh connection within a dtMeshTile object.
      An off-mesh connection is a user defined traversable connection made up to two
      vertices.
    seq:
      - id: pos
        type: float3
        repeat: expr
        repeat-expr: 2
        doc: The endpoints of the connection. [(ax, ay, az, bx, by, bz)]
      - id: radius
        -orig-id: rad
        type: f4
        doc: "The radius of the endpoints. [Limit: >= 0]"
      - id: poly
        type: u2
        doc: The polygon reference of the connection within the tile.
      - id: flags
        type: u1
        doc: Link flags.
      - id: side
        type: u1
        doc: End point side.
      - id: user_id
        type: u4
        doc: |
          The id of the offmesh connection. (User assigned when the navigation mesh is
          built.)
  dt_mesh_tile:
    seq:
      - id: header
        type: dt_mesh_header
      - id: verts
        type: f4
        repeat: expr
        repeat-expr: header.num_verts * 3
        doc: The tile vertices.
      - id: polys
        type: dt_poly
        repeat: expr
        repeat-expr: header.num_polys
        doc: The tile polygons.
      - id: links
        type: dt_link
        repeat: expr
        repeat-expr: header.max_links
        doc: The tile links.
      - id: detail_meshes
        size: 12
        type: dt_poly_detail
        repeat: expr
        repeat-expr: header.num_detail_meshes
        doc: The tile's detail sub-meshes
      - id: detail_verts
        type: f4
        repeat: expr
        repeat-expr: header.num_detail_verts * 3
        doc: The detail mesh's unique vertices. [(x, y, z) * dtMeshHeader::detailVertCount]
      - id: detail_tris
        type: u1
        repeat: expr
        repeat-expr: header.num_detail_tris * 4
        doc: |
          The detail mesh's triangles. [(vertA, vertB, vertC, triFlags) *
          dtMeshHeader::detailTriCount].
      - id: bv_tree
        type: dt_bv_node
        repeat: expr
        repeat-expr: header.num_bv_nodes
        doc: The tile bounding volume nodes.
      - id: off_mesh_cons
        type: dt_off_mesh_connection
        repeat: expr
        repeat-expr: header.num_off_mesh_cons
        doc: The tile off-mesh connections.
  navmesh_tile:
    seq:
      - id: tile_ref
        -orig-id: tileRef
        type: u4
        doc: Reference (dtTileRef) of the tile in the navigation mesh.
      - id: len_tile
        -orig-id: dataSize
        type: s4
      - id: tile
        size: len_tile
        type: dt_mesh_tile
