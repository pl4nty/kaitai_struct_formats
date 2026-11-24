meta:
  id: alcohol_mds
  title: Alcohol 120% / DAEMON Tools media descriptor (MDS)
  application:
    - Alcohol 120%
    - DAEMON Tools
    - Aaru
    - CDEmu (libmirage)
  file-extension: mds
  license: CC0-1.0
  ks-version: '0.11'
  endian: le
doc: |
  Optical disc images made by Alcohol 120% (also used by DAEMON Tools)
  consist of a raw sector data file (`.mdf`) and a media descriptor
  (`.mds`) that describes the disc layout: medium type, sessions, the
  full TOC (track and lead-in entries with Q sub-channel fields),
  where each track's sectors are stored in the data file, and
  optionally DVD structures, BCA and disc metadata blocks (data
  position measurement and unreadable sector lists). This spec
  describes the `.mds` descriptor; the `.mdf` file is plain sector
  data located via `start_offset` and `sector_size`.

  Many fields are not understood and kept as unknown values.
doc-ref:
  - https://github.com/aaru-dps/Aaru/blob/79c5c9a7b5f96487da49f4efd64df4256616f876/Aaru.Images/Alcohol120/Structs.cs
  - https://github.com/aaru-dps/Aaru/blob/79c5c9a7b5f96487da49f4efd64df4256616f876/Aaru.Images/Alcohol120/Read.cs
  - https://github.com/cdemu/cdemu/blob/3b3bb8ca01f48233cc04902a0fafe60308f3961e/libmirage/images/image-mds/image-mds.h
seq:
  - id: header
    type: header
instances:
  sessions:
    pos: header.ofs_sessions
    type: session
    repeat: expr
    repeat-expr: header.num_sessions
  bca:
    pos: header.ofs_bca
    size: header.len_bca
    if: header.ofs_bca != 0 and header.len_bca != 0
    doc: Burst cutting area data (DVD).
  disc_structures:
    pos: header.ofs_disc_structures
    size: 4100
    if: header.ofs_disc_structures != 0
    doc: |
      DVD disc structures; Aaru takes the 2048-byte disc manufacturing
      information from offset 4 and the physical format information from
      offset 0x804.
  disc_metadata:
    pos: header.ofs_disc_metadata
    type: disc_metadata
    if: header.ofs_disc_metadata != 0
types:
  header:
    seq:
      - id: signature
        contents: MEDIA DESCRIPTOR
      - id: version
        size: 2
        doc: Format version (major, minor).
      - id: medium_type
        type: u2
        enum: medium_type
      - id: num_sessions
        type: u2
      - id: unknown1
        type: u2
        repeat: expr
        repeat-expr: 2
      - id: len_bca
        type: u2
      - id: unknown2
        type: u4
        repeat: expr
        repeat-expr: 2
      - id: ofs_bca
        type: u4
      - id: unknown3
        type: u4
        repeat: expr
        repeat-expr: 6
      - id: ofs_disc_structures
        type: u4
      - id: unknown4
        type: u4
        repeat: expr
        repeat-expr: 3
      - id: ofs_sessions
        type: u4
      - id: ofs_disc_metadata
        type: u4
        doc: Offset of the disc metadata (DPM) blocks, or 0.
  session:
    seq:
      - id: session_start
        type: s4
        doc: Start address of the session.
      - id: session_end
        type: s4
      - id: session_number
        type: u2
      - id: num_tracks
        type: u1
        doc: Number of track blocks, including lead-in (non-track) blocks.
      - id: num_nontrack_blocks
        type: u1
        doc: Number of lead-in blocks (TOC points 0xa0 and above).
      - id: first_track
        type: u2
      - id: last_track
        type: u2
      - id: unknown
        type: u4
      - id: ofs_tracks
        type: u4
    instances:
      tracks:
        pos: ofs_tracks
        type: track
        repeat: expr
        repeat-expr: num_tracks
  track:
    seq:
      - id: mode
        type: u1
        enum: track_mode
      - id: subchannel_mode
        type: u1
        enum: subchannel_mode
      - id: adr_ctl
        type: u1
      - id: tno
        type: u1
      - id: point
        type: u1
        doc: Track number for track entries; 0xa0 and above for lead-in entries.
      - id: min
        type: u1
      - id: sec
        type: u1
      - id: frame
        type: u1
      - id: zero
        type: u1
      - id: pmin
        type: u1
      - id: psec
        type: u1
      - id: pframe
        type: u1
      - id: ofs_extra
        type: u4
        doc: |
          Offset of the track extra block (CD). On DVD images this field
          holds the number of sectors of the track instead.
      - id: sector_size
        type: u2
        doc: Size of each sector as stored in the data file.
      - id: unknown1
        size: 18
      - id: start_sector
        type: u4
        doc: Start sector of the track (LBA).
      - id: start_offset
        type: u8
        doc: Offset of the track's first sector in the data file.
      - id: num_files
        type: u4
      - id: ofs_footer
        type: u4
      - id: unknown2
        size: 24
    instances:
      is_lead_in:
        value: point >= 0xa0
      extra:
        pos: ofs_extra
        type: track_extra
        if: >-
          not is_lead_in and ofs_extra != 0
          and mode != track_mode::dvd
      footer:
        pos: ofs_footer
        type: footer
        if: ofs_footer != 0
  track_extra:
    seq:
      - id: num_pregap_sectors
        type: u4
      - id: num_sectors
        type: u4
  footer:
    seq:
      - id: ofs_filename
        type: u4
      - id: is_widechar
        type: u4
        doc: 1 if the data file name is stored as UTF-16LE.
      - id: unknown1
        type: u4
      - id: unknown2
        type: u4
    instances:
      filename_utf16:
        pos: ofs_filename
        type: strz
        encoding: UTF-16LE
        if: ofs_filename != 0 and is_widechar == 1
      filename_ansi:
        pos: ofs_filename
        terminator: 0
        if: ofs_filename != 0 and is_widechar != 1
        doc: |
          Data file name in the writer's ANSI code page; `*.mdf` means
          "same name as the descriptor".
  disc_metadata:
    seq:
      - id: num_blocks
        type: u4
      - id: ofs_blocks
        type: u4
        repeat: expr
        repeat-expr: num_blocks
    instances:
      blocks:
        type: disc_metadata_block_ref(ofs_blocks[_index])
        repeat: expr
        repeat-expr: num_blocks
  disc_metadata_block_ref:
    params:
      - id: ofs_block
        type: u4
    instances:
      block:
        io: _root._io
        pos: ofs_block
        type: disc_metadata_block
  disc_metadata_block:
    seq:
      - id: block_type
        type: u4
        enum: disc_metadata_block_type
      - id: start_sector
        type: u4
        doc: For DPM blocks, the sector where the measurement starts.
      - id: resolution
        type: u4
        doc: For DPM blocks, the number of sectors between entries.
      - id: num_entries
        type: u4
      - id: entries
        type: u4
        repeat: expr
        repeat-expr: num_entries
        doc: |
          DPM: cumulative angles in 1/256 turn units; read errors: sector
          numbers that could not be read.
enums:
  medium_type:
    0x00: cd
    0x01: cd_r
    0x02: cd_rw
    0x10: dvd
    0x12: dvd_r
  subchannel_mode:
    0x00: none
    0x08: interleaved
  track_mode:
    0x00: no_data
    0x02: dvd
    0xa9: audio
    0xaa: mode1
    0xab: mode2
    0xac: mode2_form1_alt
    0xad: mode2_form2_alt
    0xe9: audio_alt
    0xea: mode1_alt
    0xec: mode2_form1
    0xed: mode2_form2
  disc_metadata_block_type:
    1: dpm
    2: read_errors
