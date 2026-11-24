meta:
  id: lytro_lfp
  title: Lytro Light Field Picture
  application:
    - Lytro Cameras
    - Lytro Desktop
  file-extension: lfp
  xref:
    wikidata: Q2984629
  license: GPL-3.0-or-later # I'm sorry, but the main sources of info for this format (lfp-reader and plenopticam) are GPLed.
  ks-version: 0.9
  encoding: UTF-8
  endian: be

doc: |
  Native file format of Lytro light field cameras.

  The file is a sequence of sections. Each section has an `identifier`
  (usually a SHA-1 hex string), and the JSON metadata section (type `LFM`)
  refers to the image and metadata sections by these identifiers.
  Sample files can be downloaded from:
    https://github.com/behnam/python-lfp-reader/tree/master/samples
    https://www.irisa.fr/temics/demos/IllumDatasetLF/index_files/LytroIllum_Dataset_INRIA_SIROCCO.zip

doc-ref:
  - https://github.com/behnam/python-lfp-reader
  - https://github.com/hahnec/plenopticam
  - https://github.com/nrpatel/lfptools
  - https://eclecti.cc/computervision/reverse-engineering-the-lytro-lfp-file-format
  - https://optics.miloush.net/lytro/TheFileFormat.aspx
  - https://github.com/pathawks/Light-Field-Foundry/blob/b41df8a0cca4bb08f744be6a00c8a42f02ad7637/formats/lfp_framing.ksy

seq:
  - id: sections
    type: section
    repeat: eos

types:
  alignment:
    params:
      - id: align_by
        type: u2
    seq:
      - id: alignment
        size: size_to_read
    instances:
      size_available:
        value: _io.size - _io.pos
      size_to_read:
        value: "size_to_read_computed < size_available ? size_to_read_computed : size_available"
      size_to_read_computed:
        value: "((_io.pos + align_by_m1) & ~align_by_m1) - _io.pos"
      align_by_m1:
        value: align_by - 1
  section:
    seq:
      - id: marker
        type: u1
        doc: Signature prefix 0x89; anything else ends the section list.
      - id: contents
        type: section_contents
        if: is_section
      - id: alignment
        type: alignment(16)
        doc: NUL padding to the next 16-byte file offset.
    instances:
      is_section:
        value: marker == 0x89
    types:
      section_contents:
        seq:
          - id: type
            size: 3
            type: str
            doc: |
              `LFP` for the 16-byte package header at the start of the file,
              `LFM` for the master JSON metadata, `LFC` for any other content
              (JSON metadata, raw sensor data, images, depth maps).
          - id: crlf
            contents: [0x0d, 0x0a]
          - id: unkn1
            type: u2
            valid: 0x1a0a
            doc: Rest of the 8-byte signature, SUB LF (0x1a 0x0a).
          - id: unkn0
            type: u4
            doc: |
              In the `LFP` package header, the version (1). In `LFM`/`LFC`
              sections, the high 32 bits of a 64-bit payload length, which
              is always 0 in practice.
          - id: size
            type: u4
            doc: |
              Payload length in bytes, excluding the identifier and the
              alignment padding (0 in the `LFP` package header).
          - id: identifier
            size: 80
            type: strz
            if: size != 0
            doc: |
              Section name, NUL padded: usually `sha1-` followed by the 40
              lowercase hex digits of the SHA-1 of `data`.
          - id: data
            size: size
            type:
              switch-on: type
              cases:
                #"'LFP'": header # usually empty?
                "'LFM'": json_metadata
                #"'LFC'": chunk # cannot process it yet
        types:
          json_metadata:
            seq:
              - id: json_str
                size: _io.size
                type: strz
                doc: |
                  JSON document. Its `picture.frameArray[].frame` objects
                  refer to the other sections by their `identifier`, using the
                  `metadataRef`, `privateMetadataRef` and `imageRef` keys.
                  Resolving these references requires a JSON parser, so it is
                  left to the application.
