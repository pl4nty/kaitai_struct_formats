meta:
  id: windows_prefetch
  title: Windows Prefetch file
  application: Microsoft Windows
  file-extension: pf
  license: CC0-1.0
  ks-version: '0.11'
  imports:
    - /windows/windows_filetime
  encoding: UTF-16LE
  endian: le
doc: |
  Windows Prefetch files (named `<EXECUTABLE>-<HASH>.pf` in the
  Windows `Prefetch` directory)
  are written by the Windows cache manager to speed up application
  start-up. They record which files and volumes an executable touched
  during its first seconds of running, the last run time(s) and a run
  counter, which makes them a popular forensic artifact.

  Two physical layouts exist:

  * an uncompressed file starting with a format version and the
    signature `SCCA` (Windows XP up to 8.1, versions 17, 23 and 26);
  * a compressed file starting with the signature `MAM` (Windows 10
    and later). Its payload is LZXPRESS Huffman compressed and, once
    decompressed, is an uncompressed prefetch file of version 30 or 31.
    This spec only parses the 8-byte header of the compressed form;
    decompress the payload and parse the result with this spec again.

  Coverage of the uncompressed form: file header, file information
  (all known versions, including both variants of version 30), file
  metrics array with filenames, trace chains array, volume information
  entries with device paths, file references and directory strings.

  Strings are UTF-16LE; Windows allows unpaired surrogates in them,
  which strict UTF-16 decoders may reject.
doc-ref: https://github.com/libyal/libscca/blob/main/documentation/Windows%20Prefetch%20File%20(PF)%20format.asciidoc
seq:
  - id: body
    type:
      switch-on: is_compressed
      cases:
        true: compressed_file
        false: uncompressed_file
instances:
  is_compressed:
    value: magic == [0x4d, 0x41, 0x4d]
  magic:
    pos: 0
    size: 3
types:
  compressed_file:
    seq:
      - id: signature
        contents: [0x4d, 0x41, 0x4d]
      - id: signature_flags
        type: u1
        doc: Commonly 0x04.
      - id: len_decompressed
        type: u4
        doc: Total size of the data after decompression.
      - id: compressed_data
        size-eos: true
        doc: LZXPRESS Huffman compressed uncompressed prefetch file.
  uncompressed_file:
    seq:
      - id: header
        type: file_header
      - id: file_info
        type: file_info_common
      - id: file_info_ext
        type:
          switch-on: header.version
          cases:
            format_version::windows_xp: file_info_v17
            format_version::windows_vista: file_info_v23
            format_version::windows_8: file_info_v26
            format_version::windows_10: file_info_v30(file_info.ofs_file_metrics == 296)
            format_version::windows_11: file_info_v30(file_info.ofs_file_metrics == 296)
        doc: Version-specific remainder of the file information.
    instances:
      file_metrics:
        pos: file_info.ofs_file_metrics
        type: file_metrics_entry
        repeat: expr
        repeat-expr: file_info.num_file_metrics
      trace_chains:
        pos: file_info.ofs_trace_chains
        type: trace_chain_entry
        repeat: expr
        repeat-expr: file_info.num_trace_chains
      filename_strings:
        pos: file_info.ofs_filename_strings
        size: file_info.len_filename_strings
        doc: Concatenated NUL-terminated UTF-16LE filenames.
      volumes:
        pos: file_info.ofs_volumes
        size: file_info.len_volumes
        type: volumes_information
      is_version_17:
        value: header.version == format_version::windows_xp
  file_header:
    seq:
      - id: version
        type: u4
        enum: format_version
      - id: signature
        contents: SCCA
      - id: unknown1
        type: u4
        doc: Seen 0x0f and 0x11.
      - id: len_file
        type: u4
      - id: executable_filename
        size: 60
        type: strz
        doc: |
          Executable filename, at most 29 characters. Unused bytes may
          contain remnant data.
      - id: prefetch_hash
        type: u4
        doc: Hash of the executable path; matches the hash in the filename.
      - id: unknown_flags
        type: u4
        doc: 0x01 seems to indicate a boot prefetch file.
  file_info_common:
    seq:
      - id: ofs_file_metrics
        type: u4
      - id: num_file_metrics
        type: u4
      - id: ofs_trace_chains
        type: u4
      - id: num_trace_chains
        type: u4
      - id: ofs_filename_strings
        type: u4
      - id: len_filename_strings
        type: u4
      - id: ofs_volumes
        type: u4
      - id: num_volumes
        type: u4
      - id: len_volumes
        type: u4
  file_info_v17:
    seq:
      - id: last_run_time
        type: windows_filetime
      - id: unknown1
        size: 16
      - id: run_count
        type: u4
      - id: unknown2
        type: u4
  file_info_v23:
    seq:
      - id: unknown1
        size: 8
      - id: last_run_time
        type: windows_filetime
      - id: unknown2
        size: 16
      - id: run_count
        type: u4
      - id: unknown3
        type: u4
      - id: unknown4
        size: 80
  file_info_v26:
    seq:
      - id: unknown1
        size: 8
      - id: last_run_times
        type: windows_filetime
        repeat: expr
        repeat-expr: 8
        doc: Most recent first; 0 if not set.
      - id: unknown2
        size: 16
      - id: run_count
        type: u4
      - id: unknown3
        type: u4
      - id: unknown4
        type: u4
      - id: unknown5
        size: 84
  file_info_v30:
    doc: |
      File information of versions 30 and 31. Variant 1 is 220 bytes,
      variant 2 (Windows 10 1903 and later, and version 31) is 212
      bytes; they differ only in the size of the unknown field after
      the last run times.
    params:
      - id: is_variant_2
        type: bool
    seq:
      - id: unknown1
        size: 8
      - id: last_run_times
        type: windows_filetime
        repeat: expr
        repeat-expr: 8
        doc: Most recent first; 0 if not set.
      - id: unknown2
        size: 'is_variant_2 ? 8 : 16'
      - id: run_count
        type: u4
      - id: unknown3
        type: u4
      - id: unknown4
        type: u4
      - id: ofs_hash_string
        type: u4
      - id: len_hash_string
        type: u4
      - id: unknown5
        size: 76
  file_metrics_entry:
    seq:
      - id: idx_trace_chain
        type: u4
      - id: num_trace_entries
        type: u4
      - id: num_blocks_to_prefetch
        type: u4
        if: not _parent.is_version_17
      - id: ofs_filename
        type: u4
        doc: Relative to the start of the filename strings.
      - id: num_filename_chars
        type: u4
        doc: Excluding the terminating NUL character.
      - id: flags
        type: file_metrics_flags
      - id: file_reference
        type: file_reference
        if: not _parent.is_version_17
        doc: 0 if not set.
    instances:
      filename:
        io: _parent._io
        pos: _parent.file_info.ofs_filename_strings + ofs_filename
        size: num_filename_chars * 2
        type: str
  file_metrics_flags:
    meta:
      bit-endian: le
    seq:
      - id: do_not_prefetch
        type: b1
      - id: load_as_resource
        type: b1
      - id: reserved1
        type: b7
      - id: load_as_executable
        type: b1
      - id: reserved2
        type: b22
  trace_chain_entry:
    seq:
      - id: idx_next
        type: s4
        if: _parent.header.version.to_i < 30
        doc: Index of the next entry in the chain, or -1 at the end of the chain.
      - id: num_blocks_loaded
        type: u4
        doc: Total number of 512 KiB blocks loaded (fetched).
      - id: flags
        type: trace_chain_flags
      - id: unknown1
        type: u1
      - id: block_used_bits
        type: u1
        doc: Whether the block was used in each of the last 8 runs.
      - id: block_prefetched_bits
        type: u1
        doc: Whether the block was prefetched in each of the last 8 runs.
  trace_chain_flags:
    seq:
      - id: reserved
        type: b4
      - id: must_be_prefetched
        type: b1
      - id: load_as_resource
        type: b1
      - id: load_as_executable
        type: b1
      - id: do_not_prefetch
        type: b1
  volumes_information:
    seq:
      - id: entries
        type: volume_entry
        repeat: expr
        repeat-expr: _parent.file_info.num_volumes
  volume_entry:
    seq:
      - id: ofs_device_path
        type: u4
        doc: Relative to the start of the volumes information.
      - id: num_device_path_chars
        type: u4
      - id: creation_time
        type: windows_filetime
      - id: serial_number
        type: u4
      - id: ofs_file_references
        type: u4
        doc: Relative to the start of the volumes information.
      - id: len_file_references
        type: u4
      - id: ofs_directory_strings
        type: u4
        doc: Relative to the start of the volumes information.
      - id: num_directory_strings
        type: u4
      - id: unknown1
        type: u4
      - id: unknown2
        size: 'version_num >= 30 ? 24 : 28'
        if: version_num != 17
      - id: unknown3
        type: u4
        if: version_num != 17
        doc: Possibly a copy of the number of directory strings.
      - id: unknown4
        size: 'version_num >= 30 ? 24 : 28'
        if: version_num != 17
      - id: unknown5
        type: u4
        if: version_num != 17
        doc: Possibly alignment padding; can contain remnant data.
    instances:
      version_num:
        value: _parent._parent.header.version.to_i
      device_path:
        io: _parent._io
        pos: ofs_device_path
        size: num_device_path_chars * 2
        type: str
      file_references:
        io: _parent._io
        pos: ofs_file_references
        size: len_file_references
        type: file_references(version_num == 17)
        if: len_file_references != 0
      directory_strings:
        io: _parent._io
        pos: ofs_directory_strings
        type: directory_string
        repeat: expr
        repeat-expr: num_directory_strings
  file_references:
    params:
      - id: is_version_17
        type: bool
    seq:
      - id: unknown_version
        type: u4
        doc: Seen 1 in version 17 and 3 in later versions.
      - id: num_references
        type: u4
      - id: unknown1
        type: u8
        if: not is_version_17
      - id: references
        type: file_reference
        repeat: expr
        repeat-expr: num_references
        doc: The first entry seems to be unused (0 or remnant data).
  file_reference:
    doc: NTFS file reference (MFT entry index and sequence number).
    seq:
      - id: mft_entry_index_low
        type: u4
      - id: mft_entry_index_high
        type: u2
      - id: sequence_number
        type: u2
    instances:
      mft_entry_index:
        value: mft_entry_index_high * 0x1_0000_0000 + mft_entry_index_low
  directory_string:
    seq:
      - id: num_chars
        type: u2
        doc: Excluding the terminating NUL character.
      - id: name
        size: num_chars * 2
        type: str
      - id: terminator
        size: 2
enums:
  format_version:
    17: windows_xp
    23: windows_vista
    26: windows_8
    30: windows_10
    31: windows_11
