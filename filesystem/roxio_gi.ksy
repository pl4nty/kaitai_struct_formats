# Imported from https://github.com/lpreiner/roxio-global-image-format/blob/124f75c0b11d059f77dd23629147f589e0aa6019/roxio_gi.ksy
meta:
  id: roxio_gi
  title: Roxio / Prassi Global Image (.gi) container
  file-extension: gi
  license: MIT
  ks-version: '0.10'
  endian: le
doc: |
  Evidence-based layout of the Roxio/Prassi Global Image container, derived
  from 55 CD images, 7 DVD images and the metadata of a 41 GB two-layer
  Blu-ray image (see FORMAT.md).

  The file is a flat sequence of tagged chunks after an 8-byte signature
  and version prefix. Each chunk is [tag u4][content_length u8] followed by
  exactly content_length bytes; every content span ends where the next tag
  begins. Lengths are 64-bit (the Blu-ray image's root length and payload
  extents exceed 2^32). A root chunk at 0x08 (tag 0x400) spans the whole
  file. The observed sequences are:

    CD    : 11 disc_info, cc string(90), 33 pregap_table, [77 cd_text],
            22 track x N, 22 lead-out pseudo-track (footer)
    DVD/BD: 11 disc_info, cc string(filename), cc string(90), [99 layer_table],
            bb extent(media), aa track, bb extent(+payload) x layers,
            [22 lead-out pseudo-track]

  A track record is one 90-byte structure. In CD track chunks the payload
  is spliced in after its first 42 bytes; the DVD/BD variant keeps the 90
  bytes contiguous, appends 12 bytes, and stores the payload in one extent
  chunk per layer, chained by a next-extent offset. The lead-out
  pseudo-track uses the same record with storage kind 0x45, start =
  lead-out address (+150 on CD) and sector count = remaining media
  capacity; it is absent on the Blu-ray image. Unknown chunk tags are
  exposed as raw bytes.

  Payloads are exposed as opaque bytes. A CD track payload is not uniform:
  if the next track's pregap_table entry is negative, the last -entry
  sectors of this payload are the following track's Index 00 span stored
  at the following track's sector width. Generated parsers will read whole
  payloads into memory; use a streaming reader for extraction.
seq:
  - id: signature
    contents: [0xda, 0xda, 0xfe, 0xfe]
  - id: engine_prefix
    type: u1
    doc: Zero in Creator 2011 and NXT 9, one in NXT 6; meaning unknown.
  - id: px_engine_build
    type: u1
    doc: Numeric build component shown in the PX Engine About entry (14, 40, 53).
  - id: px_engine_minor
    type: u1
  - id: px_engine_major
    type: u1
  - id: root_tag
    type: u4
    doc: |
      0x400 in every observed image; not validated so that other writers' files still
      parse.
  - id: len_root
    type: u8
    doc: File size minus 20, i.e. every byte after this chunk header.
  - id: root
    size: len_root
    type: chunk_list
    doc: Bounded by len_root so trailing garbage is not parsed as chunks.
instances:
  chunks:
    value: root.chunks
  disc:
    value: root.chunks[0].body.as<disc_info>
    doc: The disc_info chunk is always first.
types:
  chunk_list:
    seq:
      - id: chunks
        type: chunk
        repeat: eos

  chunk:
    seq:
      - id: tag
        type: u4
        enum: tag
      - id: length
        type: u8
      - id: body
        size: length
        type:
          switch-on: tag
          cases:
            'tag::disc_info': disc_info
            'tag::string': string_chunk
            'tag::pregap_table': pregap_table
            'tag::cd_text': cd_text
            'tag::layer_table': layer_table
            'tag::track': cd_track
            'tag::dvd_track': dvd_track
            'tag::extent': extent
            _: raw_chunk

  raw_chunk:
    doc: Any chunk with a tag this spec does not know.
    seq:
      - id: raw
        size-eos: true

  layer_table:
    doc: |
      Tag 0x99999999, present on two-layer images (28 bytes):
      [0, 1, 16, 0, layer 0 last LBA, layer 1 first LBA, disc last LBA].
      The extents may split one ECC block after the physical boundary;
      take extent boundaries from the extents. Other fields unknown.
    seq:
      - id: values
        type: u4
        repeat: eos

  disc_info:
    doc: 82 bytes of disc-level metadata (tag 0x11111111).
    seq:
      - id: disc_class_code
        type: u4
        doc: |
          Observed 0xA1 audio, 0xA4 audio+data sessions, 0xB1 mixed mode,
          0xD1 Mode 1 data, 0xD3 (three-session Mode 1 CD-RW and two
          CUE-mounted VCDs), 0xD4 raw Mode 2, 0xF3 DVD and Blu-ray. Bit meanings unknown.
      - id: media_type_code
        type: u4
        doc: |
          4 CD-ROM (pressed or mounted), 6 CD-RW, 7 DVD-ROM (pressed, mounted or
          authored), 77 DVD+R, 95 on a pressed two-layer BD-ROM. Provisional.
      - id: disc_status_code
        type: u4
        doc: 74 on every closed disc and image; 75 on an open, appendable CD-RW.
      - id: erasable_code
        type: u4
        doc: 1 only on physical CD-RW captures. Provisional.
      - id: state_code_30
        type: u4
        doc: |
          1 on the TAO three-session CD-RW, the physical DVD+R and the pressed BD-ROM; 0
          on the other observed images. The grouping is unexplained.
      - id: address_sectors
        type: u4
        doc: Lead-out LBA minus the first track's start LBA.
      - id: program_sectors
        type: u4
        doc: address_sectors minus stored Index 00 spans and inter-session address gaps.
      - id: free_sectors
        type: u4
        doc: Remaining writable sectors on an open disc; zero when closed.
      - id: next_writable_lba
        type: u4
        doc: Next writable address on an open disc; zero when closed.
      - id: track_count
        type: u4
      - id: session_count
        type: u4
      - id: mci_media_identity
        type: u4
        doc: |
          Legacy Windows MCI audio-CD media identity: sum of packed absolute
          MSF track starts, plus the first frame component and lead-out
          minus first-track LBA when there are fewer than three tracks.
          Zero when track 1 is data.
      - id: unknown_50
        type: u4
      - id: mcn
        size: 13
        doc: |
          ASCII media catalog number. NULs (mounted sources) or thirteen '0' (physical,
          none) mean absent.
      - id: unknown_61
        size: 17

  string_chunk:
    doc: |
      Tag 0xcccccccc. CD images carry one 90-byte zero-filled instance. DVD
      images carry the UTF-16LE output filename (length includes the
      terminator) followed by the same 90-byte instance.
    seq:
      - id: raw
        size-eos: true

  pregap_table:
    doc: |
      Tag 0x33333333, 100 signed slots (99 tracks + 1). Slot 0 is the
      first track's start LBA + 150. Slot i (1..track_count) describes the
      gap after track i: a negative value is the following track's Index 00
      length, stored at the end of track i's payload; +150 marks a session
      boundary or the lead-out, whose gap sectors are not stored.
    seq:
      - id: entries
        type: s4
        repeat: expr
        repeat-expr: 100

  cd_text:
    doc: |
      Tag 0x77777777, observed only between the pregap table and the first
      track chunk. Wraps an MMC READ TOC/PMA/ATIP format 0101b response.
    seq:
      - id: mmc_response_length
        type: u4
        doc: Pack bytes plus 4.
      - id: mmc_data_length
        type: u2be
        doc: Pack bytes plus 2, big-endian as in the MMC response.
      - id: mmc_reserved
        type: u2be
      - id: packs
        size-eos: true
        doc: Consecutive 18-byte CD-Text packs, preserved verbatim including CRCs.
    instances:
      pack_count:
        value: packs.size / 18

  track_body:
    doc: |
      First 42 bytes of a track record; shared by CD, DVD and the lead-out
      pseudo-track.
    seq:
      - id: number
        type: u4
        doc: One-based track number; track_count + 1 in the lead-out pseudo-track.
      - id: session
        type: u4
      - id: start_lba
        type: u4
        doc: Index 01 start. In the lead-out pseudo-track, lead-out LBA + 150 on CD.
      - id: sectors
        type: u4
        doc: |
          Includes a stored following Index 00 span. Remaining media capacity in the
          lead-out pseudo-track.
      - id: storage_kind
        type: u4
        enum: storage_kind
      - id: unknown_14
        type: u4
      - id: unknown_18
        type: u4
      - id: ident
        size: 12
        type: track_ident
      - id: unknown_28
        type: u1
      - id: const_29
        type: u1
        doc: 1 in every observed record.

  track_ident:
    doc: |
      Audio tracks carry the ASCII ISRC here; data tracks carry a zero byte and their
      sector count.
    seq:
      - id: raw
        size: 12
    instances:
      is_data_form:
        value: _parent.storage_kind != storage_kind::audio_2352
      data_sector_count:
        pos: 1
        type: u4
        if: is_data_form
      isrc:
        value: raw.to_s("ASCII")
        if: not is_data_form
        doc: Twelve '0' characters on physical discs without an ISRC.

  track_tail:
    doc: Last 48 bytes of a track record.
    seq:
      - id: link_code
        type: u4
        doc: |
          Per-track write type: 2 on SAO/DAO-written, pressed and mounted
          tracks; 1 on TAO-written tracks (a disc with one SAO and one TAO
          track carries both); 5 on the physical DVD+R and the pressed
          BD-ROM, where it is unexplained; 0 in the
          lead-out pseudo-track.
      - id: last_index01_lba
        type: u4
        doc: |
          Last LBA of this track's Index 01 region. Zero at pressed/DAO session boundaries
          and in the lead-out pseudo-track.
      - id: next_start_lba
        type: u4
        doc: |
          Start LBA of the next session's first track at pressed/DAO session boundaries;
          repeats start_lba in the lead-out pseudo-track; otherwise zero.
      - id: unknown_0c
        size: 12
      - id: tail_18
        type: u4
        doc: 0x101e in the lead-out pseudo-track, zero elsewhere.
      - id: unknown_1c
        size: 20

  cd_track:
    doc: |
      Tag 0x22222222 (content 90 + payload bytes). The payload is spliced
      between the 42-byte body and the 48-byte tail. A zero-length payload
      with storage kind 0x45 is the lead-out pseudo-track (the "footer").
    seq:
      - id: body
        type: track_body
      - id: payload
        size: _parent.length - 90
      - id: tail
        type: track_tail
    instances:
      is_leadout:
        value: body.storage_kind == storage_kind::leadout

  dvd_track:
    doc: |
      Tag 0xaaaaaaaa (102 bytes). The contiguous 90-byte record plus a pointer to the
      first payload extent chunk.
    seq:
      - id: body
        type: track_body
      - id: tail
        type: track_tail
      - id: extent_count
        type: u4
        doc: |
          Number of payload extent chunks that follow (one per layer):
          1 on single-layer images, 2 on a pressed DVD-9 and a pressed
          two-layer BD-ROM.
      - id: payload_chunk_offset
        type: u4
        doc: File offset of the first extent chunk that carries this track's payload.
      - id: ext_62
        type: u4

  extent:
    doc: |
      Tag 0xbbbbbbbb (32 bytes, optionally followed by payload). The first
      instance has no payload and describes the last layer's region: [0,
      capacity] on single-layer media, [layer 1 start, sectors to capacity]
      on two-layer discs. Each following instance carries one contiguous
      LBA range of the track (one per layer) and its 2048-byte sectors;
      the instances are chained by next_extent_offset, zero on the last.
    seq:
      - id: next_extent_offset
        type: u8
        doc: |
          File offset of the next payload extent's tag; zero on the last extent and on the
          media extent.
      - id: start_lba
        type: u4
      - id: sectors
        type: u4
      - id: field_10
        type: u4
        doc: 114 on payload extents, zero on the media extent.
      - id: field_14
        type: u4
      - id: payload_offset
        type: u8
        doc: File offset of the first payload byte; zero on the media extent.
      - id: payload
        size-eos: true
        doc: 2048-byte sectors when present.

enums:
  tag:
    0x11111111: disc_info
    0x22222222: track
    0x33333333: pregap_table
    0x77777777: cd_text
    0x99999999: layer_table
    0xaaaaaaaa: dvd_track
    0xbbbbbbbb: extent
    0xcccccccc: string
  storage_kind:
    0: audio_2352
    1: data_2048
    2: mode2_2336
    0x45: leadout
