# Imported from https://github.com/cardano-foundation/CIPs/blob/03387471681166e746518d58a33e25f2ccea3d29/CIP-0165/format/format.ksy
# Licence and copyright: see _community/README.md
meta:
  id: cardano_scls
  title: Container for the cardano ledger state
  file-extension: scls
  license: CC0-1.0
  ks-version: 0.9
  endian: be

doc: |
  A seekable, versioned container for CBOR payloads whose structure is defined
  by an external CDDL schema.

seq:
  - id: record
    type: scls_record
    repeat: eos
    doc: Typed records with data

types:
  scls_record:
    seq:
      - id: len_payload
        type: u4
        doc: Size of the record, including record type
      - id: payload
        size: len_payload
        type: scls_record_data
        doc: payload of the record
  scls_record_data:
    seq:
      - id: record_type
        type: u1
        doc: Type of the record
      - id: record_data
        # size: _parent.len_payload - sizeof<record_type>
        size-eos: true
        type:
          switch-on: record_type
          cases:
            0x00: rec_header
            0x01: rec_manifest
            0x10: rec_chunk
            0x31: rec_metadata
        doc: Record payload
  rec_header:
    doc: Header record
    seq:
      - id: magic
        contents: SCLS
        doc: Magic bytes "SCLS"
      - id: version
        type: u4
        doc: Version of the file format
  rec_manifest:
    doc: |
      Manifest — is a trailer in the file that describes information of about the file
      contents
    seq:
      - id: slot_no
        type: u8
        doc: Slot number that this manifest refers to
      - id: total_entries
        type: u8
        doc: total amount of entries in the file
      - id: total_chunks
        type: u8
        doc: total amount of chunks in the file
      - id: summary
        type: summary
        doc: information about the file
      - id: namespace_info
        type: namespace_info
        repeat: until
        repeat-until: _.len_ns == 0
        doc: information about the namespaces
      - id: prev_manifest
        type: u8
        doc: absolute offset of the previous manifest, zero if there is no
      - id: root_hash
        type: digest
        doc: merkle tree root of the live entries
      - id: offset
        type: u4
        doc: |
          relative offset to the beginning of this record (this can be used to find the
          manifest by reading the last 4 bytes of the file)
  rec_chunk:
    doc: Chunk - is a record with data
    seq:
      - id: seqno
        type: u8
        doc: Sequential number of the chunk
      - id: format
        type: u1
        enum: chunk_format
      - id: len_ns
        type: u4
        doc: size of the namespace
      - id: ns
        size: len_ns
        type: str
        encoding: UTF-8
        doc: namespace name
      - id: len_key
        type: u4
        doc: key size for this namespace
      - id: data
        size: len_data                # substream; entries parse to EOS here
        type: entries_record(len_key)
        doc: payload parsed as entries
      - id: entries_count
        type: u4
        doc: Number of entries in the chunk
      - id: digest
        type: digest
        doc: blake28 hash of the entries in the record
    instances:
      # size of record_data for this scls_record (total - record_type:u1)
      rec_payload_size:
        value: _parent._parent.len_payload - 1
      ns_size:
        value: 4 + len_ns
      len_data:
        value: rec_payload_size - (8 + 1 + ns_size + 4 + 28 + 4)
        doc: seqno=8, format=1, entries_count=4, digest=28, 4=len_key.
  rec_metadata:
    doc: Metadata record containing URI-indexed entries with CBOR-encoded values
    seq:
      - id: data
        size: len_data
        type: entries_metadata_record
        doc: payload parsed as entries
      - id: footer
        type: metadata_footer
    instances:
      # size of record_data for this scls_record (total - record_type:u1)
      rec_payload_size:
        value: _parent._parent.len_payload - 1
      len_data:
        value: rec_payload_size - sizeof<metadata_footer>
        doc: entries_count=8, digest=28.
  entries_record:
    params:
      - id: len_key
        type: u2
    seq:
      - id: entries
        type: entry(len_key)
        repeat: eos
  entry:
    params:
      - id: len_key
        type: u2
    seq:
      - id: len_body
        type: u4
      - id: body
        size: len_body
        type: entry_body(len_key)
  entry_body:
    doc: Body of the entry with the key of the fixes size, that depends on the namespace
    params:
      - id: len_key
        type: u2
    seq:
      - id: key
        size: len_key
        doc: fixed size key
      - id: value
        size-eos: true
        doc: cbor encoded entry
  summary:
    doc: Summary
    seq:
      - id: created_at
        type: tstr
        doc: absolute timestamp when file was generated in ISO8601 format
      - id: tool_bytes
        type: tstr
        doc: name of the tool that has generated the file
      - id: comment
        type: tstr
        doc: optional comment
  namespace_info:
    seq:
      - id: len_ns
        type: u4
      - id: ns_info
        type: ns_info
        if: len_ns != 0
  ns_info:
    seq:
      - id: entries_count
        type: u8
        doc: number of entries in the namespace
      - id: chunks_count
        type: u8
        doc: number of chunks in the namespace
      - id: name
        size: _parent.len_ns
        type: str
        encoding: UTF-8
        doc: namespace name
      - id: digest
        type: digest
        doc: merkle-tree hash of the alive entries in the namespace
  tstr:
    seq:
      - id: len_data
        type: u4
        doc: size of the string
      - id: data
        size: len_data
        type: str
        encoding: UTF-8
        doc: value of the string
  digest:
    doc: Digest of the data
    seq:
      - id: data
        size: 28
        doc: blake28 hash of data
  entries_metadata_record:
    seq:
      - id: entries
        type: entry_metadata
        repeat: eos
  entry_metadata:
    seq:
      - id: len_subject
        type: u4
      - id: subject
        size: len_subject
        doc: subject of entry (URI)
      - id: len_value
        type: u4
      - id: value
        size: len_value
        doc: cbor encoded value
  metadata_footer:
    doc: Metadata footer with entry count and digest
    seq:
      - id: entries_count
        type: u8
        doc: Number of entries in the record
      - id: digest
        type: digest
        doc: blake28 hash of the entries in the record
enums:
  chunk_format:
    0: raw
    1: zstd
    2: zstde
