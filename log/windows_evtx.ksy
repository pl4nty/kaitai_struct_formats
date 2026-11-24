meta:
  id: windows_evtx
  title: Windows XML Event Log (EVTX)
  application: Microsoft Windows (Vista and later)
  file-extension: evtx
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Event log file format used by Windows Vista and later (superseding the
  EVT format). The file starts with a 4096-byte file header followed by
  64 KiB chunks. Each chunk has a 512-byte header (including a common
  string offset table and a template pointer table) followed by event
  records. Each event record holds a record identifier, a FILETIME
  timestamp and the event itself encoded as Microsoft Binary XML.

  This spec parses the file header, the chunk headers and the framing of
  the event records. The Binary XML payload of each record (which uses
  string and template references into the enclosing chunk) is exposed as
  raw bytes and is not decoded.

  The CRC-32 checksums (file header: first 120 bytes; chunk header: bytes
  0-119 and 128-511; event records: chunk bytes 512 to the free space
  offset) are not verified.
doc-ref:
  - https://github.com/libyal/libevtx/blob/main/documentation/Windows%20XML%20Event%20Log%20(EVTX).asciidoc
  - https://github.com/williballenthin/python-evtx/blob/master/Evtx/Evtx.py
seq:
  - id: header
    size: 4096
    type: file_header
  - id: chunks
    size: 0x10000
    type: chunk
    repeat: expr
    repeat-expr: header.num_chunks
    doc: |
      Chunks in use. Files may be preallocated with further (unused or
      stale) chunks after these, which are not parsed.
types:
  file_header:
    seq:
      - id: magic
        contents: ["ElfFile", 0]
      - id: first_chunk_number
        type: u8
      - id: last_chunk_number
        type: u8
        doc: Number of the current (last written) chunk.
      - id: next_record_id
        type: u8
      - id: len_header
        type: u4
        doc: Size of the meaningful part of the header (128).
      - id: minor_version
        type: u2
        doc: 1 (Vista and later) or 2 (Windows 10 2004 and later).
      - id: major_version
        type: u2
        doc: Major format version (3).
      - id: len_header_block
        type: u2
        doc: Size of the header block, i.e. offset of the first chunk (4096).
      - id: num_chunks
        type: u2
        doc: |
          Number of chunks. libevtx documents this as a 32-bit field at
          offset 42; python-evtx reads it as 16-bit, followed by unused
          bytes. Both agree on its low 16 bits.
      - id: reserved1
        size: 76
      - id: flags
        type: u4
        doc: Bit 0 = dirty, bit 1 = full.
      - id: checksum
        type: u4
        doc: CRC-32 of the first 120 bytes of the header.
    instances:
      is_dirty:
        value: flags & 1 != 0
      is_full:
        value: flags & 2 != 0
  chunk:
    seq:
      - id: header
        type: chunk_header
      - id: records
        type: record
        repeat: until
        repeat-until: _io.pos > header.ofs_last_record or _io.pos >= header.ofs_free_space
        if: header.ofs_free_space > 512
        doc: Event records, from offset 512 up to and including the last record.
  chunk_header:
    seq:
      - id: magic
        contents: ["ElfChnk", 0]
      - id: first_record_number
        type: u8
      - id: last_record_number
        type: u8
      - id: first_record_id
        type: u8
      - id: last_record_id
        type: u8
      - id: len_header
        type: u4
        doc: Size of the fixed part of the header (128).
      - id: ofs_last_record
        type: u4
        doc: Offset of the last event record, relative to the chunk start.
      - id: ofs_free_space
        type: u4
        doc: Offset of the free space, relative to the chunk start.
      - id: records_checksum
        type: u4
        doc: CRC-32 of the event records data.
      - id: reserved1
        size: 64
      - id: flags
        type: u4
      - id: checksum
        type: u4
        doc: CRC-32 of bytes 0-119 and 128-511 of the chunk.
      - id: common_string_offsets
        type: u4
        repeat: expr
        repeat-expr: 64
        doc: Offsets (relative to the chunk) of common strings used by Binary XML.
      - id: template_offsets
        type: u4
        repeat: expr
        repeat-expr: 32
        doc: Offsets (relative to the chunk) of template definitions.
  record:
    seq:
      - id: magic
        contents: [0x2a, 0x2a, 0, 0]
      - id: len_record
        type: u4
        doc: Size of the record including signature and both size fields.
      - id: record_id
        type: u8
      - id: written_time
        type: u8
        doc: Time the record was written, as a FILETIME (UTC).
      - id: event
        size: len_record - 28
        doc: Event in Microsoft Binary XML.
      - id: len_record_copy
        type: u4
        valid:
          eq: len_record
