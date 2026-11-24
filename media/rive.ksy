meta:
  id: rive
  title: Rive runtime file
  application:
    - Rive
  file-extension: riv
  license: CC0-1.0
  ks-version: '0.11'
  imports:
    - /common/vlq_base128_le
  endian: le
doc: |
  Binary runtime format exported by the Rive editor (interactive vector
  animations with state machines), read by the Rive runtimes.

  The file starts with the "RIVE" fingerprint, the major and minor format
  version (the current major version is 7) and a file ID, all as LEB128
  variable-length unsigned integers. A table of contents follows: a
  zero-terminated list of property keys, then 2 bits per property giving
  its backing type (how its value is serialized), so that a reader can
  skip properties it does not know. The reference reader takes these bits
  from the low byte of a 32-bit integer, so each group of 4 properties
  uses 4 bytes.

  The rest of the file is a sequence of objects, each a varuint core type
  key followed by (property key, value) pairs terminated by a 0 property
  key. Decoding a value requires knowing its backing type, which comes
  either from the table of contents or, for properties that existed when
  the major version was introduced, from Rive's core definitions only.
  This spec therefore covers the header and table of contents and keeps
  the objects as raw bytes.
doc-ref:
  - https://rive.app/docs/runtimes/advanced-topic/format
  - https://github.com/rive-app/rive-runtime/blob/07428ca90b68ca07c79d24016a32153043150a7d/include/rive/runtime_header.hpp
seq:
  - id: magic
    contents: RIVE
  - id: major_version
    type: vlq_base128_le
  - id: minor_version
    type: vlq_base128_le
  - id: file_id
    type: vlq_base128_le
    doc: Identifier of the source file; may be 0.
  - id: property_keys
    type: vlq_base128_le
    repeat: until
    repeat-until: _.value == 0
    doc: Keys of the properties listed in the table of contents, terminated by 0.
  - id: backing_type_words
    type: backing_type_word
    repeat: expr
    repeat-expr: (property_keys.size - 1 + 3) / 4
    doc: |
      Backing types of the properties in `property_keys`, 4 per word: the
      property at index `i` uses `backing_type_words[i / 4].types[i % 4]`.
  - id: objects
    size-eos: true
    doc: Serialized objects (core type key, properties, 0 terminator).
types:
  backing_type_word:
    meta:
      bit-endian: le
    seq:
      - id: types
        type: b2
        enum: backing_type
        repeat: expr
        repeat-expr: 4
        doc: Only the low byte of the 32-bit word is used.
      - id: unused
        type: b24
enums:
  backing_type:
    0: uint_or_bool
    1: string
    2: float
    3: color
