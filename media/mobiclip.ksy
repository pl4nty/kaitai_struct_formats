# Imported from https://github.com/RiiConnect24/Kaitai-Files/blob/86568af7c4f29040c178ab627c68be707a829829/Kaitais/mobiclip.ksy
# Generic tag-section header model as in https://github.com/spotlightishere/kaitais/blob/b08d4add98d0c1e27f64cc2b431797d56cc65d78/mobiclip.ksy
# and https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/media/mobiclip.ksy
meta:
  id: mobiclip
  file-extension: mo
  license: AGPL-3.0-only
  endian: le
doc: |
  Wii Mobiclip video container (.mo, MOC5). The header is a sequence of
  tag sections, each a 2-character tag, a u2 length in 32-bit words and
  that many words of payload, ending with an empty "HE" section. Known
  tags: TL (timeline), V2 (video), VC (video codec), pc (RSA-1280
  signature), cc (64 bytes), A0/A2/A3/A8/A9/AP/AV/AM (audio), KI (keyframe
  index), LM (MediaLock DRM enable), VF (VerifyFrames), P. (frame-rate
  numerator/denominator). Interleaved audio/video chunks follow the
  header.

  Used by the Nintendo Channel, Wii no Ma, WiiLink and in-game FMV.
seq:
  - id: magic
    contents: "MO"
  - id: stream_type
    contents: "C5"
  - id: header_size
    type: u4
    doc: Add 8 for the actual header size.
  - id: tag_sections
    type: tag_section
    repeat: until
    repeat-until: _.tag == "HE"
instances:
  timeline:
    value: tag_sections[0].payload.as<timeline>
    if: tag_sections[0].tag == "TL"
    doc: The timeline section, which comes first in known files.
  chunk:
    pos: header_size + 8
    type: chunk
    repeat: expr
    repeat-expr: timeline.chunk_count
    if: tag_sections[0].tag == "TL"
  fps:
    value: timeline.fps
    if: tag_sections[0].tag == "TL"
    doc: |
      Compatibility alias for `timeline.fps` (a root field in older versions of this
      spec).
  chunk_count:
    value: timeline.chunk_count
    if: tag_sections[0].tag == "TL"
    doc: Compatibility alias for `timeline.chunk_count`.
  video_info:
    value: tag_sections[1].payload.as<video>
    if: tag_sections.size >= 2 and tag_sections[1].tag == "V2"
    doc: The video section, which comes second (after TL) in known files.
  width:
    value: video_info.width
    if: tag_sections.size >= 2 and tag_sections[1].tag == "V2"
    doc: Compatibility alias for the width in the V2 section.
  height:
    value: video_info.height
    if: tag_sections.size >= 2 and tag_sections[1].tag == "V2"
    doc: Compatibility alias for the height in the V2 section.
types:
  tag_section:
    -webide-representation: "{tag}"
    seq:
      - id: tag
        size: 2
        type: str
        encoding: ISO-8859-1
      - id: word_len
        type: u2
        doc: Length of the payload in 32-bit words.
      - id: payload
        size: word_len * 4
        type:
          switch-on: tag
          cases:
            "'TL'": timeline
            "'V2'": video
            "'pc'": rsa_signature
            "'A2'": audio_chunk_standard
            "'A3'": audio_chunk_standard
            "'A8'": audio_chunk_standard
            "'A9'": audio_chunk_standard
            "'AM'": audio_chunk_multitrack
            "'AP'": audio_chunk_standard
            "'KI'": keyframe_index
        doc: |
          A0 -> None
          A2 -> FastAudio
          A3 -> FastAudio Stereo
          A8 -> IMA ADPCM
          A9 -> IMA ADPCM Stereo
          AM -> Multitrack
          AP -> PCM S16
          AV -> Vorbis
          KI -> Keyframe Index
          cc -> 64 bytes, seemingly unused (Wii-Kaitai: RSA-512 clip certificate)
          LM -> MediaLock DRM enable
          VF -> VerifyFrames
          HE -> end of header (empty)
  timeline:
    seq:
      - id: fps
        type: u4
        doc: Frames per second.
      - id: chunk_count
        type: u4
      - id: unknown_5
        type: u2
      - id: unknown_6
        type: u2
  video:
    seq:
      - id: width
        type: u4
      - id: height
        type: u4
  rsa_signature:
    seq:
      - id: rsa_signature
        size: 160
        doc: RSA-1280 with Barrett reduction.
  chunk:
    doc: |
      One interleaved audio/video frame chunk. Retail files may contain
      audio-less "skip frame" chunks (all-0xFF P-frames) where
      `chunk_size == video_chunk_size + 4`. Video data is a MobiClip
      bitstream, read MSB-first over 16-bit little-endian words.
    seq:
      - id: chunk_size
        type: u4
      - id: video_chunk_size
        type: u4
      - id: video_chunk
        size: video_chunk_size
      - id: audio_chunk
        size: chunk_size - video_chunk_size - 8
        if: chunk_size - video_chunk_size - 8 > 0
      - id: unknown
        size: (_io.pos + 4 - (_io.pos % 4)) - _io.pos
        if: chunk_size - video_chunk_size - 8 > 0
  audio_chunk_standard:
    seq:
      - id: frequency
        type: u4
      - id: channel_number
        type: u4
  audio_chunk_multitrack:
    seq:
      - id: audio_stream_count
        type: u4
      - id: audio_stream_features
        type: audio_chunk_standard
        repeat: expr
        repeat-expr: audio_stream_count
  keyframe_index:
    seq:
      - id: keyframe
        type: keyframe
        repeat: eos
  keyframe:
    seq:
      - id: chunk_offset
        type: u4
      - id: frame_index
        type: u4
