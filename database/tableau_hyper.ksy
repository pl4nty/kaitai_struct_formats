# Imported from https://github.com/Hugoberry/python-hyper/blob/0d14fe4bba6a47ee3fe619ed6f5b248fd9627a59/tableau_hyper.ksy
meta:
  id: tableau_hyper
  title: Tableau Hyper database file (.hyper)
  file-extension: hyper
  license: CC0-1.0
  endian: le
  bit-endian: le

doc: |
  Reverse-engineered layout of Tableau's .hyper files.

  A .hyper file is not a flat serialisation - it is a shadow-paging database
  image with 4096-byte pages. Pages 0 and 1 hold two root records ("superblocks")
  that are written alternately; the live one is whichever carries the higher
  txn_id among those that pass validation.

  The live root record points at the storage directory: a fixed-capacity hash
  map from ObjectStoreId to {offset, length}, plus a free list. Every piece of
  content in the file - the system catalog, the per-column data blocks, the
  relation headers, the tombstone lists, the samples - is an object addressed
  through that directory. Nothing needs to be found by scanning.

  Names here follow the engine's own C++ classes (hyper::RootRecord,
  hyper::ObjectStoreIdMapEntry, hyper::DataBlockCompression), taken from the
  macOS arm64 build of hyperd, which unlike the Linux build is not stripped.

  Every integrity field is CRC-32C (poly 0x82F63B78 reflected) with **init 0 and
  no final XOR** - not the usual init/xorout of 0xFFFFFFFF. The root record uses
  seed 0; the directory and the objects use seed 0 for format version 0 and
  0x1234 from version 1 onwards.

  ## What this spec cannot do

  Kaitai describes byte layout. Five things about this format sit outside that,
  and a reader that stops here will be wrong rather than incomplete:

  1. **Object payloads need a custom `process`, and it is not the stock one.**
     `id_map_entry.body` / `.body_lz4` reach and decompress them, using the
     `hyperlz4` module in this directory. The stock `kaitai.compress.lz4` is
     the LZ4 *frame* format and fails on a Hyper object; see `body_lz4`. Perl
     cannot use any custom process, so the spec compiles on 14 of 15 targets,
     and a non-Python target needs its own three-line block decoder.
  2. **Root record selection needs validation, not just a comparison.** The
     engine discards records failing magic / struct_version / format_version /
     CRC *before* comparing txn_id. `live_root` here only compares txn_id.
  3. **Packed dictionary codes are not a byte structure.** They are 1, 2 or 4
     bit or 1, 2 or 4 byte codes, MSB-first for the sub-byte widths, and which
     applies comes from the block's `scheme`. See README.md section 4.
  4. **Deleted rows are still in the data blocks.** A relation reads correctly
     only after removing the rows its `relation_metadata` marks - those row
     indices are relation-global, not block-local.
  5. **Nothing here validates a CRC.** Every `_crc` field is the stored value.

  `kscheck.py` compiles this spec and asserts it agrees with `hyperparse.py`
  field by field over the whole corpus - container positions, and the object
  types applied to decompressed payloads. Run it after editing; an untested
  .ksy silently rots, which is how a retracted field survived in here for
  several sessions.

  A few ksy_style_guide naming warnings are declined on purpose: `dict_offset`
  is an offset the engine calls `index.dictOffset`, and `num_attributes` counts
  attributes rather than any one array.

  The spec compiles on 14 of the 15 targets of kaitai-struct-compiler 0.11 -
  every one but Perl, which does not implement custom process routines - and the
  recursive `tombstone_node`, the parametric `attribute_group` and its computed
  region ends survive into all of them. The JavaScript target has one caveat,
  see `commit_id`.

seq:
  - id: root_record_0
    size: 0x1000
    type: root_record
  - id: root_record_1
    size: 0x1000
    type: root_record

instances:
  live_root:
    value: >-
      root_record_0.txn_id >= root_record_1.txn_id
        ? root_record_0
        : root_record_1
    doc: |
      The committed state - but see caveat 2 in the file doc. The engine also
      requires the record to pass validation, which Kaitai cannot express.

  directory:
    pos: live_root.dir_offset
    size: live_root.dir_length
    type: storage_directory

  directory_crc:
    pos: live_root.dir_offset + live_root.dir_length
    type: u4
    doc: |
      CRC-32C over the directory payload, seeded per format version. It sits
      AFTER the payload, at dir_offset + dir_length, which is why looking for it
      at length - 4 reads zero.

types:

  root_record:
    doc: |
      hyper::RootRecord. One 4096-byte page. Bytes 0x68..0xFFB are zero in every
      sample; the last four bytes of the page are the CRC.
    seq:
      - id: magic
        contents: [0x48, 0x79, 0x70, 0x65, 0x72, 0x08]
        doc: '"Hyper" followed by 0x08. isValid() checks exactly these six bytes.'
      - id: magic_pad
        size: 2
      - id: struct_version
        type: u2
        doc: Must be 1. The engine rejects any other value outright.
      - id: database_format_version
        type: u2
        doc: |
          Tracks the `default_database_version` process parameter. isValid()
          accepts (v + 1) & 0xFFFF <= 5, i.e. 0..4 or 0xFFFF for "unset".
          The version gates feature capabilities - see README.md section 5.
      - id: encrypted
        type: u1
        doc: |
          Read as a bool by the StorageMetadata(RootRecord&) constructor.
          Zero in every sample; encrypted files have never been observed.
      - id: reserved_0d
        size: 11
      - id: creator_version
        type: version_triple
        doc: The Hyper build that wrote the file, e.g. 0.0.25080 or 2020.3.10980.
      - id: min_version
        type: version_triple
        doc: |
          Minimum version required to open the file. Identical to
          creator_version in every sample; never seen to diverge.
      - id: txn_id
        type: u8
        doc: |
          Monotonic commit counter. Selects which root record is live.
          NOTE: txn_id % 2 == page_index does NOT hold - samples violate it.
      - id: file_size
        type: u8
        doc: |
          Total file length as of this commit. A stale root record legitimately
          carries a smaller value than the file's real size.
      - id: dir_offset
        type: u8
        doc: hyper::Position.offset of the storage directory. Relocates every commit.
      - id: dir_length
        type: u8
        doc: |
          hyper::Position.length - the directory payload size, CRC excluded.
          Clusters around 12,400-12,600 because the hash table is fixed at 256
          slots of 48 bytes.
      - id: dir_capacity
        type: u8
        doc: Bytes allocated for the directory; >= dir_length.
      - id: reserved_58
        type: u8
      - id: commit_id
        type: u8
        doc: |
          PARTLY KNOWN. hyper::TransactionManager::createCommitID() is a plain
          counter, so this is not a hash - but the stored field steps by
          thousands per commit and tracks wall-clock time across databases, so
          it is some hybrid clock. Cosmetic; nothing validates against it.

          WARNING for the JavaScript target: this is the only field in the
          format that exceeds 2**53, so the JS runtime reads it as a rounded
          double and it comes back wrong by up to ~31. Every other u8 here
          (txn_id, file_size, offsets, lengths) is small enough to be exact.
    instances:
      checksum:
        pos: 0x0ffc
        type: u4
        doc: |
          CRC-32C over bytes 0x000..0xFFC of this page, init 0, no final XOR.
          hyper::RootRecord::computeChecksum() == crc32cIntrinsic(this, 0xFFC, 0).

  version_triple:
    doc: |
      Three u4 at 0x18 and 0x24. Reading 0x20 as a single u8, as an earlier
      revision of this spec did, straddles `build` and the next `major` and
      reports builds in the billions for Tableau-written files.
    seq:
      - id: major
        type: u4
      - id: minor
        type: u4
      - id: build
        type: u4

  storage_directory:
    doc: |
      hyper::FileStorageResource::readDirectory. Read dir_length bytes at
      dir_offset; the CRC is the u4 that follows them.
    seq:
      - id: log2_capacity
        type: u8
        doc: Hash table capacity is 1 << this. The engine rejects values above 58.
      - id: entries
        type: id_map_entry
        repeat: expr
        repeat-expr: 1 << log2_capacity
      - id: num_free_list
        type: u8
      - id: free_list
        type: position
        repeat: expr
        repeat-expr: num_free_list
      - id: sentinel
        contents: [0x1a, 0xda, 0x1a, 0xda, 0, 0, 0, 0]
        doc: u8 0xDA1ADA1A, closing the serialised directory.

  position:
    doc: hyper::Position - a byte range in the file.
    seq:
      - id: offset
        type: u8
      - id: length
        type: u8

  id_map_entry:
    doc: |
      hyper::ObjectStoreIdMapEntry, 48 bytes, memcpy'd straight out of the file
      into the in-memory hash table. Skip entries whose state is not `used`.
    seq:
      - id: index
        type: b24
        doc: |
          ObjectStoreId low field. For relation_datablock: 0 is the partition
          header, N is column N-1.
      - id: id_03
        type: b24
        doc: |
          UNKNOWN, and a trap. It equals the relation ordinal in every
          Tableau-written file and is 0 in every API-written one, so it looks
          like the relation until you meet a file where it is not. The relation
          is `relation` below. See README.md section 9, correction 24.
      - id: category
        type: u2
        enum: object_category
      - id: block
        type: u4
        doc: |
          Block number within the relation. A relation is split at 2**17 =
          131,072 rows and every column is split the same way, so a large
          column is several objects sharing `index` and differing here.
      - id: relation
        type: u4
        doc: Ordinal of the relation in the catalog's relations[] array.
      - id: size
        type: u8
        doc: Payload bytes, CRC excluded. The engine asserts size + 4 <= alloc.
      - id: pos
        type: position
        doc: Where the object lives; pos.length is the allocation, not the payload.
      - id: state
        type: u1
        enum: entry_state
      - id: compression
        type: u1
        enum: compression_method
      - id: encryption_scheme_id
        type: u1
        doc: The engine accepts 0 or 1. Only 0 observed.
      - id: pad
        size: 5
    instances:
      body:
        io: _root._io
        pos: pos.offset
        size: size
        if: compression == compression_method::none
        doc: The payload, when the entry says it is stored uncompressed.
      body_lz4:
        io: _root._io
        pos: pos.offset
        size: size
        process: hyperlz4.lz4_block
        if: compression == compression_method::lz4
        doc: |
          The DECOMPRESSED payload. `hyperlz4` ships in this directory; it is a
          three-line wrapper over python-lz4's `lz4.block`.

          It is deliberately NOT `kaitai.compress.lz4`. That package documents
          its `lz4` process as the LZ4 *block* specification, but every
          implementation in it calls the *frame* API and its own test fixtures
          carry the 0x184D2204 frame magic. Pointed at a Hyper object it fails
          with ERROR_frameType_unknown - README correction 9 all over again.

          Wrapping the block in a frame so the stock process can read it does
          not work either, and it is worth knowing why before trying:

            * a frame needs `04 22 4d 18` + FLG + BD + a header checksum, then
              a u32 *compressed* length - Hyper's leading u32 is the
              *uncompressed* one - then the block, then a 4-byte endmark;
            * a frame block caps at 4 MB, and Hyper writes single raw blocks of
              22 MB, which cannot be expressed as one frame block at all;
            * and Kaitai cannot build such a buffer regardless. `process` acts
              on bytes already in the stream; there is no concatenation of a
              literal, a computed integer and a slice.

          Measured: 644 of 646 compressed objects in the corpus round-trip
          through a hand-built 4 MB frame, and the two that do not are the
          22 MB ones.

          Feed this to `data_block`, `relation_header`, `relation_metadata` or
          `relation_sample` according to `category`.

  relation_header:
    doc: |
      Object category 3. Apply to the decompressed payload.

      An ARRAY, not a fixed pair of fields: one u4 per block, always at least
      one. 12 bytes for a single block, 16 for two, 24 for four - and 8 bytes
      with no entries at all for an empty relation, which is the case that
      proves it. Block count is (size - 8) / 4.

      `tuple_count` INCLUDES rows deleted but not reclaimed - see
      relation_metadata.
    seq:
      - id: tuple_count
        type: u8
      - id: per_block
        type: u4
        repeat: eos
        doc: 2 in every block of every file seen. Meaning unknown.

  relation_metadata:
    doc: |
      Object category 5 - the tombstone list. Apply to the decompressed payload.

      A DELETE does not rewrite the data blocks. The rows stay in place and this
      records which ones are gone, as inclusive ranges of RELATION-GLOBAL row
      index. There is one of these per relation. Ignore it and the relation
      reads back with its deleted rows still in it: right values, too many of
      them.
    seq:
      - id: present
        type: u1
        doc: 0 means this byte is the whole object and nothing is deleted.
      - id: unknown_01
        type: u1
        if: present != 0
        doc: 1 in every sample.
      - id: root
        type: tombstone_node
        if: present != 0

  tombstone_node:
    doc: |
      A B-tree node, and the depth grows with the relation: up to 100 ranges the
      root is a bare leaf, 200 ranges is one internal node over three leaves,
      and 87,055 ranges is three levels. A parser written against only the first
      two shapes handles 2,500 tombstones and then fails outright.

      The engine fills the first leaf with 100 ranges and 50 thereafter, so the
      separators support a binary search. Nothing is aligned.
    seq:
      - id: kind
        type: u1
        enum: tombstone_kind
      - id: num_entries
        type: u4
      - id: ranges
        type: row_range
        repeat: expr
        repeat-expr: num_entries
        if: kind == tombstone_kind::leaf
      - id: separators
        type: u8
        repeat: expr
        repeat-expr: num_entries
        if: kind == tombstone_kind::internal
        doc: The last row index in each child but the final one.
      - id: children
        type: tombstone_node
        repeat: expr
        repeat-expr: num_entries + 1
        if: kind == tombstone_kind::internal

  row_range:
    doc: An inclusive range of deleted row indices.
    seq:
      - id: first
        type: u8
      - id: last
        type: u8

  data_block:
    doc: |
      Object category 4 - one column of one block. Apply to the DECOMPRESSED
      payload.

      Field names come from the engine's own assertion strings in
      hyper::getPackInfoAndValidate ("index.dictOffset<=index.dataOffset",
      "is_aligned(index.dictOffset,16)"). All three offsets are relative to
      0x30, not to the start of the object, and all are 16-byte aligned.

      A 48-byte object with every offset zero is a `no_sma_single_null` block -
      every row is NULL and there is nothing else in it.
    seq:
      - id: tuple_count
        type: u4
        doc: The engine reads this as a u4, not a u8.
      - id: padding_04
        type: u4
        doc: |
          Struct padding, not a field: the next member is a u8 and needs
          8-byte alignment. getPackInfoAndValidate never reads it, and it is
          zero in all 870 block headers in the corpus.
      - id: dict_offset
        type: u8
      - id: data_offset
        type: u8
      - id: scheme
        type: u4
        enum: data_block_compression
      - id: reserved_1c
        type: u4
      - id: string_offset
        type: u8
      - id: reserved_28
        type: u8
    instances:
      sma:
        pos: 0x30
        size: dict_offset
        doc: |
          Small Materialised Aggregates: min, then max, then the PSMA (a scan
          accelerator, 2048 x value width), then the u4 domain size. The domain
          size's offset depends on the value width and is NOT a fixed distance
          from the dictionary - see README.md section 4.
      dictionary:
        pos: 0x30 + dict_offset
        size: data_offset - dict_offset
      codes:
        pos: 0x30 + data_offset
        size: string_offset - data_offset
        doc: Packed codes - see caveat 3 in the file doc. Not a byte structure.
      string_heap:
        pos: 0x30 + string_offset
        size-eos: true
        doc: |
          Begins with the SMA min, then the SMA max, then the rest of the
          dictionary payload, which is why offset(max) always equals len(min).

  relation_sample:
    doc: |
      Object category 6 - a reservoir sample of a relation, built once it spans
      more than one block (and, for Tableau-written files, for tiny relations
      too). Apply to the DECOMPRESSED payload.

      This is the multi-attribute block layout: unlike a per-column block, all
      attributes live in one object. The 32-byte preamble is the reason an
      earlier attempt failed - the data block proper starts at +0x20 and every
      offset inside it is relative to there.
    seq:
      - id: relation_rows
        type: u8
      - id: block_size
        type: u8
      - id: num_attributes
        type: u8
      - id: version
        type: u8
        doc: |
          0 for a 2021.4 writer, 1 for everything since. It changes the FOOTER:
          a v0 sample stops after the distinct estimates, with no sample row
          count and no power sums. The data block itself is identical.
      - id: block
        size: block_size
        type: multi_attribute_block(num_attributes)
      - id: distinct_estimates
        type: u8
        repeat: expr
        repeat-expr: num_attributes
        doc: |
          A relation-wide distinct-value estimate extrapolated from the sample,
          not a count: exact when the sample is all-distinct or the domain is
          tiny, and well over the truth in between. Which estimator is unknown.
      - id: sample_rows
        type: u8
        if: version >= 1
      - id: moments
        type: f8
        repeat: expr
        repeat-expr: num_attributes * 3
        if: version >= 1
        doc: |
          Power sums over the sampled values, MOMENT-major: every attribute's
          sum, then every sum of squares, then every sum of cubes. Taken over
          the storage representation - a Date contributes its Julian day
          number, a string its byte length - with NULLs skipped and NaN for a
          Bool. Recomputing these from the decoded values is a self-check that
          needs no oracle.

  multi_attribute_block:
    doc: |
      The data block inside a relation_sample. Layout is REGION-MAJOR: every
      attribute's SMA, then every dictionary, then every data region, then every
      string heap. An attribute's region therefore ends where the next
      attribute's same region begins.

      For the LAST attribute the engine takes the ends from group 0, one field
      along: end.sma = group[0].dict, end.dict = group[0].data,
      end.data = group[0].string_data, end.string_data = the block size.
      `attribute_group` computes all four.
    params:
      - id: num_attributes
        type: u8
    seq:
      - id: tuple_count
        type: u4
        doc: Rows in the SAMPLE, not in the relation.
      - id: padding_04
        type: u4
      - id: groups
        type: attribute_group(_index, num_attributes)
        repeat: expr
        repeat-expr: num_attributes
    instances:
      block_size:
        value: _io.size
        doc: Needed by the last attribute's string-heap end.

  attribute_group:
    doc: |
      40 bytes. The field order [sma, dict, data, scheme, string_data] is what
      the first branch of getPackInfoAndValidate reads, and it is the Data
      Blocks paper's Figure 3 order - the one the per-column layout does NOT
      follow.

      All offsets are relative to the start of the data block, and the first SMA
      begins exactly where the group array ends (8 + 40 x attributes).
    params:
      - id: idx
        type: s4
      - id: num_attributes
        type: u8
    seq:
      - id: ofs_sma
        type: u8
      - id: ofs_dict
        type: u8
      - id: ofs_data
        type: u8
      - id: scheme
        type: u4
        enum: data_block_compression
      - id: scheme_pad
        type: u4
      - id: ofs_string_data
        type: u8
    instances:
      is_last:
        value: idx == num_attributes - 1
      end_sma:
        value: 'is_last ? _parent.groups[0].ofs_dict : _parent.groups[idx + 1].ofs_sma'
      end_dict:
        value: 'is_last ? _parent.groups[0].ofs_data : _parent.groups[idx + 1].ofs_dict'
      end_data:
        value: 'is_last ? _parent.groups[0].ofs_string_data : _parent.groups[idx + 1].ofs_data'
      end_string_data:
        value: 'is_last ? _parent.block_size : _parent.groups[idx + 1].ofs_string_data'
      len_sma:
        value: end_sma - ofs_sma
      len_dict:
        value: end_dict - ofs_dict
      len_data:
        value: end_data - ofs_data
      len_string_data:
        value: end_string_data - ofs_string_data

enums:
  object_category:
    1: database_header          # the 48-byte "HyperDB\0" descriptor
    2: schema                   # the system catalog JSON
    3: relation_header          # u8 tuple count, then one u4 per block
    4: relation_datablock       # index 0 = partition header, index N = column N-1
    5: relation_metadata        # the tombstone list; 1 byte when nothing is deleted
    6: relation_sample          # a reservoir sample, multi-attribute layout
    7: index                    # not observed
    8: database_encryption_key  # not observed

  entry_state:
    0: empty
    1: used
    2: tombstone

  compression_method:
    0: none
    1: lz4
    2: unknown_2                # accepted by the engine, never observed

  tombstone_kind:
    0: internal
    1: leaf

  data_block_compression:
    # hyper::to_string(DataBlockCompression) - a 54-entry char* table at
    # __DATA_CONST:0x10b4c8198, indexed by the code. This is the whole enum,
    # which is why getPackInfoAndValidate asserts scheme < 54.
    #
    #   dictN / dict_bitN   dictionary with N-BYTE / N-BIT codes
    #   truncN              truncation into N bytes
    #   uncompressed        the value itself, one cell per row
    #   single / no_sma_single   one value for the block, with / without an SMA
    #   small_ / (none) / huge_  entry shape: 4-byte / 8-byte / 16-byte
    #   _null               the nullable twin; code 0 is the reserved NULL
    #
    # 34 of these are measured. dict4/dict4_null/small_dict4/small_dict4_null
    # are dead codes - at 4-byte codes an uncompressed block costs the same per
    # row and skips the dictionary, so nothing can select them. The 14 huge_*
    # codes have never been produced and their entry shape is unmeasured.
    0: single
    1: dict1
    2: dict2
    3: dict4
    4: huge_dict1
    5: huge_dict2
    6: huge_dict4
    7: trunc1
    8: trunc2
    9: trunc4
    10: uncompressed
    11: huge_uncompressed
    12: single_null
    13: dict1_null
    14: dict2_null
    15: dict4_null
    16: huge_dict1_null
    17: huge_dict2_null
    18: huge_dict4_null
    19: trunc1_null
    20: trunc2_null
    21: trunc4_null
    22: uncompressed_null
    23: huge_uncompressed_null
    24: dict_bit1
    25: dict_bit2
    26: dict_bit4
    27: huge_dict_bit1
    28: huge_dict_bit2
    29: huge_dict_bit4
    30: dict_bit1_null
    31: dict_bit2_null
    32: dict_bit4_null
    33: huge_dict_bit1_null
    34: huge_dict_bit2_null
    35: huge_dict_bit4_null
    36: small_dict1
    37: small_dict2
    38: small_dict4
    39: small_uncompressed
    40: small_dict1_null
    41: small_dict2_null
    42: small_dict4_null
    43: small_uncompressed_null
    44: small_dict_bit1
    45: small_dict_bit2
    46: small_dict_bit4
    47: small_dict_bit1_null
    48: small_dict_bit2_null
    49: small_dict_bit4_null
    50: no_sma_single
    51: no_sma_single_null
    52: trunc8
    53: trunc8_null
