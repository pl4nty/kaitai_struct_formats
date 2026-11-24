meta:
  id: luks
  title: Linux Unified Key Setup
  xref:
    forensicswiki: linux_unified_key_setup_(luks)
    justsolve: LUKS
    wikidata: Q29000504
  tags:
    - filesystem
    - linux
  license: CC0-1.0
  encoding: ASCII
  endian: be
doc: |
  Linux Unified Key Setup (LUKS) is a format specification for storing disk
  encryption parameters and up to 8 user keys (which can unlock the master key).
  Both LUKS1 and LUKS2 binary headers are supported; for LUKS2, the JSON
  metadata areas are read as strings.
doc-ref:
  - https://gitlab.com/cryptsetup/cryptsetup/-/wikis/LUKS-standard/on-disk-format.pdf
  - https://gitlab.com/cryptsetup/cryptsetup/-/blob/v2.5.0/docs/on-disk-format-luks2.pdf
seq:
  - id: primary_binary_header
    type: binary_header
  - id: primary_json_area
    type: json_area
    if: primary_binary_header.version == 2
  - id: secondary_binary_header
    type: binary_header
    if: primary_binary_header.version == 2
  - id: secondary_json_area
    type: json_area
    if: primary_binary_header.version == 2
instances:
  payload:
    pos: primary_binary_header.luks1_fields.payload_offset * 512
    size-eos: true
    if: primary_binary_header.version == 1
    doc: |
      LUKS1 encrypted payload. For LUKS2, the data segments are described
      in the JSON metadata.
types:
  binary_header:
    seq:
      - id: magic1
        size: 4
        type: str
        valid:
          any-of:
            - '"LUKS"'
            - '"SKUL"'
        doc: |
          "LUKS" for a LUKS1 header or a primary LUKS2 header, "SKUL" for a
          secondary LUKS2 header.
      - id: magic2
        contents: [0xBA, 0xBE]
      - id: version
        type: u2
        valid:
          min: 1
          max: 2
      - id: luks1_fields
        type: luks1_fields
        if: version == 1
      - id: luks2_fields
        type: luks2_fields
        if: version == 2
      - id: uuid
        size: 40
        type: strz
      - id: key_slots
        type: key_slot
        repeat: expr
        repeat-expr: 8
        if: version == 1
      - id: luks2_fields_after_uuid
        type: luks2_fields_after_uuid
        if: version == 2
    types:
      luks1_fields:
        seq:
          - id: cipher_name
            -orig-id: cipher-name
            size: 32
            type: strz
          - id: cipher_mode
            -orig-id: cipher-mode
            size: 32
            type: strz
          - id: hash
            -orig-id: hash-spec
            size: 32
            type: strz
          - id: payload_offset
            -orig-id: payload-offset
            type: u4
            doc: Start offset of the bulk data, in 512-byte sectors.
          - id: num_key_bytes
            -orig-id: key-bytes
            type: u4
          - id: master_key_checksum
            -orig-id: mk-digest
            size: 20
          - id: master_key_salt
            -orig-id: mk-digest-salt
            size: 32
          - id: master_key_iterations
            -orig-id: mk-digest-iter
            type: u4
      luks2_fields:
        seq:
          - id: hdr_size
            type: u8
            doc: Size of the binary header plus JSON area, in bytes.
          - id: seq_id
            -orig-id: seqid
            type: u8
            doc: Sequence ID, increased on every update.
          - id: label
            size: 48
            type: strz
          - id: checksum_algorithm
            -orig-id: csum_alg
            size: 32
            type: strz
          - id: salt
            size: 64
            doc: Salt, unique for every header.
      luks2_fields_after_uuid:
        seq:
          - id: subsystem
            size: 48
            type: strz
          - id: hdr_offset
            type: u8
            doc: Offset of this header from the device start, in bytes.
          - id: padding184
            size: 184
            doc: Must be zeroed.
          - id: checksum
            -orig-id: csum
            size: 64
            doc: Header checksum.
          - id: padding4096
            size: 7 * 512
            doc: Padding, must be zeroed.
      key_slot:
        seq:
          - id: state_of_key_slot
            type: u4
            enum: key_slot_states
          - id: iteration_parameter
            type: u4
          - id: salt_parameter
            size: 32
          - id: start_sector_of_key_material
            type: u4
          - id: number_of_anti_forensic_stripes
            type: u4
        instances:
          key_material:
            pos: start_sector_of_key_material * 512
            size: _parent.luks1_fields.num_key_bytes * number_of_anti_forensic_stripes
        enums:
          key_slot_states:
            0x0000DEAD: disabled_key_slot
            0x00AC71F3: enabled_key_slot
  json_area:
    seq:
      - id: json
        size: _root.primary_binary_header.luks2_fields.hdr_size - 4096
        type: strz
        encoding: UTF-8
