meta:
  id: git_commit_graph
  title: Git commit-graph file
  application: Git
  file-extension: commit-graph
  license: GPL-2.0-only
  endian: be
doc: |
  The commit-graph file (`$GIT_DIR/objects/info/commit-graph`, or one layer of
  a split chain in `$GIT_DIR/objects/info/commit-graphs/graph-*.graph`) caches
  commit metadata so Git can walk history without inflating commit objects:
  the sorted list of commit OIDs, each commit's root tree, parents (as
  positions in that list), generation number and commit time, and
  optionally changed-path Bloom filters.

  The file is a header, a chunk table of contents ("chunk-based file format"),
  the chunks themselves, and a trailing checksum. All multi-byte integers are
  big-endian. The hash length H is 20 for SHA-1 and 32 for SHA-256, chosen
  by `hash_version`.

  Commit positions (in parents and extra edges) are global over a split
  chain: in a layer with base graphs, position p refers to the p-th commit of
  the concatenated chain (bases first, see `base_graphs`).

  This specification is derived from Git's own format documentation
  (gitformat-commit-graph(5) and gitformat-chunk(5)), which is licensed under
  GPL-2.0, hence the license of this file.
doc-ref:
  - https://github.com/git/git/blob/777489f9e09c8d0dd6b12f9d90de6376330577a2/Documentation/gitformat-commit-graph.txt
  - https://github.com/git/git/blob/777489f9e09c8d0dd6b12f9d90de6376330577a2/Documentation/gitformat-chunk.txt
seq:
  - id: magic
    -orig-id: signature
    contents: CGPH
  - id: version
    type: u1
    valid: 1
  - id: hash_version
    type: u1
    enum: hash_versions
    valid:
      any-of:
        - hash_versions::sha1
        - hash_versions::sha256
  - id: num_chunks
    -orig-id: C
    type: u1
  - id: num_base_graphs
    -orig-id: B
    type: u1
    doc: Number of base commit-graph files in a split chain (length of `BASE` chunk / H).
  - id: chunks
    type: chunk_entry(_index)
    repeat: expr
    repeat-expr: num_chunks + 1
    doc: |
      Table of contents: `num_chunks` entries plus a terminating entry with
      id 0, whose offset marks the end of the chunk data.
  - id: chunk_data
    size: chunks.last.offset - _io.pos
    doc: |
      All chunk bodies, contiguous in table order. Each one is parsed via
      `chunks[i].body`.
  - id: checksum
    size: len_hash
    doc: Hash (SHA-1 or SHA-256, per `hash_version`) of everything before it.
instances:
  len_hash:
    value: 'hash_version == hash_versions::sha256 ? 32 : 20'
    doc: H, the length of an object ID and of the trailing checksum.
types:
  chunk_entry:
    params:
      - id: idx
        type: s4
    seq:
      - id: chunk_id
        type: u4
        enum: chunk_ids
        doc: 0 terminates the table.
      - id: offset
        type: u8
        doc: Byte offset in the file of the chunk start.
    instances:
      is_terminator:
        value: idx == _root.num_chunks
      len_body:
        value: _parent.chunks[idx + 1].offset - offset
        if: not is_terminator
      body:
        io: _root._io
        pos: offset
        size: len_body
        if: not is_terminator
        type:
          switch-on: chunk_id
          cases:
            chunk_ids::oid_fanout: oid_fanout
            chunk_ids::oid_lookup: oid_lookup
            chunk_ids::commit_data: commit_data
            chunk_ids::generation_data: generation_data
            chunk_ids::generation_data_overflow: generation_data_overflow
            chunk_ids::extra_edge_list: extra_edge_list
            chunk_ids::bloom_filter_index: bloom_filter_index
            chunk_ids::bloom_filter_data: bloom_filter_data
            chunk_ids::base_graphs_list: base_graphs_list
  oid_fanout:
    -orig-id: OIDF
    seq:
      - id: fanout
        type: u4
        repeat: expr
        repeat-expr: 256
        doc: fanout[i] is the number of OIDs whose first byte is at most i.
    instances:
      num_commits:
        -orig-id: N
        value: fanout[255]
  oid_lookup:
    -orig-id: OIDL
    seq:
      - id: oids
        size: _root.len_hash
        repeat: eos
        doc: OIDs of all commits in this graph, sorted ascending.
  commit_data:
    -orig-id: CDAT
    seq:
      - id: commits
        type: commit
        repeat: eos
        doc: One entry per commit, in OID Lookup order.
  commit:
    seq:
      - id: tree
        size: _root.len_hash
        doc: OID of the commit's root tree.
      - id: parent1
        type: u4
        doc: Graph position of the first parent, or 0x70000000 if none.
      - id: parent2
        type: u4
        doc: |
          Graph position of the second parent, or 0x70000000 if none. If the
          commit has more than two parents, the most significant bit is set
          and the low 31 bits index the Extra Edge List chunk where the
          second through last parents are listed.
      - id: generation_and_time_hi
        type: u4
        doc: |
          Upper 30 bits: topological level (generation number v1). Lower 2
          bits: bits 32-33 of the commit time.
      - id: commit_time_lo
        type: u4
        doc: Lower 32 bits of the commit time.
    instances:
      has_parent1:
        value: parent1 != 0x7000_0000
      has_parent2:
        value: parent2 != 0x7000_0000
      is_octopus:
        value: has_parent2 and (parent2 & 0x8000_0000) != 0
        doc: True if the commit has more than two parents.
      extra_edge_index:
        value: parent2 & 0x7fff_ffff
        if: is_octopus
        doc: Index into `extra_edge_list.edges` where parents 2..n start.
      generation:
        -orig-id: topological level
        value: generation_and_time_hi >> 2
      commit_time:
        value: ((generation_and_time_hi & 0b11).as<u8> << 32) | commit_time_lo
        doc: Commit time, seconds since the Unix epoch (34 bits).
  generation_data:
    -orig-id: GDA2
    seq:
      - id: offsets
        type: u4
        repeat: eos
        doc: |
          Corrected commit date offsets, in commit data order. If the most
          significant bit is set, the low 31 bits index the Generation Data
          Overflow chunk instead.
  generation_data_overflow:
    -orig-id: GDO2
    seq:
      - id: offsets
        type: u8
        repeat: eos
  extra_edge_list:
    -orig-id: EDGE
    seq:
      - id: edges
        type: extra_edge
        repeat: eos
  extra_edge:
    seq:
      - id: raw
        type: u4
    instances:
      is_last:
        value: (raw & 0x8000_0000) != 0
        doc: Set on the last parent of an octopus merge.
      position:
        value: raw & 0x7fff_ffff
        doc: Graph position of this parent.
  bloom_filter_index:
    -orig-id: BIDX
    seq:
      - id: cumulative_sizes
        type: u4
        repeat: eos
        doc: |
          Entry i is the total byte length of the Bloom filters of commits
          0..i; filter i spans `bloom_filter_data.filters[cumulative_sizes[i-1]:cumulative_sizes[i]]`.
  bloom_filter_data:
    -orig-id: BDAT
    seq:
      - id: hash_version
        type: u4
        doc: Murmur3 variant; 2 is current, 1 has a signed-char bug.
      - id: num_hashes
        type: u4
        doc: Number of bit positions set per path.
      - id: bits_per_entry
        type: u4
        doc: Minimum bits per entry; a filter of n entries is ceil(n*b/64) 64-bit words.
      - id: filters
        size-eos: true
        doc: Concatenated Bloom filters of all commits in lexicographic order.
  base_graphs_list:
    -orig-id: BASE
    seq:
      - id: base_graphs
        size: _root.len_hash
        repeat: expr
        repeat-expr: _root.num_base_graphs
        doc: Checksums of the base commit-graph files of this split chain.
enums:
  hash_versions:
    1: sha1
    2: sha256
  chunk_ids:
    0: terminator
    0x4f494446:
      id: oid_fanout
      doc: '"OIDF"'
    0x4f49444c:
      id: oid_lookup
      doc: '"OIDL"'
    0x43444154:
      id: commit_data
      doc: '"CDAT"'
    0x47444132:
      id: generation_data
      doc: '"GDA2"'
    0x47444f32:
      id: generation_data_overflow
      doc: '"GDO2"'
    0x47444154:
      id: generation_data_v1_legacy
      doc: '"GDAT", possibly erroneous data from older Git; ignored by current Git'
    0x47444f56:
      id: generation_data_overflow_v1_legacy
      doc: '"GDOV", possibly erroneous data from older Git; ignored by current Git'
    0x45444745:
      id: extra_edge_list
      doc: '"EDGE"'
    0x42494458:
      id: bloom_filter_index
      doc: '"BIDX"'
    0x42444154:
      id: bloom_filter_data
      doc: '"BDAT"'
    0x42415345:
      id: base_graphs_list
      doc: '"BASE"'
