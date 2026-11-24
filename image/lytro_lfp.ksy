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
  - http://optics.miloush.net/lytro/TheFileFormat.aspx

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
      - id: contents
        type: section_contents
        if: is_section
      - id: alignment
        type: alignment(16)
    instances:
      is_section:
        value: marker == 0x89
    types:
      section_contents:
        seq:
          - id: type
            size: 3
            type: str
          - id: crlf
            contents: [0x0d, 0x0a]
          - id: unkn1
            type: u2
          - id: unkn0
            type: u4
          - id: size
            type: u4
          - id: identifier
            size: 80
            type: strz
            if: size != 0
            doc: Usually contains SHA-1 checksum
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
