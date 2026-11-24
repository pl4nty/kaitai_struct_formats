meta:
  id: iptc_iim
  title: IPTC Information Interchange Model (IIM) data
  application:
    - Adobe Photoshop
    - ExifTool
  license: CC0-1.0
  ks-version: '0.11'
  endian: be
doc: |
  IPTC-NAA Information Interchange Model (IIM) metadata, as stored in image
  files: in JPEG APP13 and Photoshop files it is the payload of Photoshop image
  resource 0x0404 ("IPTC-NAA record"), in TIFF it is tag 33723, in PNG it is
  hex-encoded in a "Raw profile type iptc" text chunk.

  The data is a sequence of datasets ("tags"). Each starts with the marker byte
  0x1C, followed by a record number, a dataset number and the length of the
  data field. If the top bit of the 16-bit length is set, the remaining 15 bits
  give the size of a following big-endian length field ("extended dataset").

  Records commonly found in images are 1 (envelope) and 2 (application).
  Dataset values are mostly text, by default in ASCII / ISO 8859-1; the
  envelope dataset 1:90 (coded character set) containing `ESC % G` (1B 25 47)
  declares UTF-8. A few datasets (e.g. record versions 1:0 and 2:0) are binary
  big-endian integers. Some writers pad the block with zero bytes, which are
  exposed here as `padding`.

  Dataset names in the enums follow the IIM 4.x names as used by ExifTool.
doc-ref:
  - https://iptc.org/standards/iim/
  - https://github.com/exiftool/exiftool/blob/3d7a0538324e9b04aa8930201b007009491321d2/lib/Image/ExifTool/IPTC.pm
seq:
  - id: datasets
    type: dataset
    repeat: until
    repeat-until: _io.eof or _.next_byte != 0x1c
  - id: padding
    size-eos: true
    doc: Trailing bytes that don't start a dataset (normally zero padding).
types:
  dataset:
    seq:
      - id: tag_marker
        contents: [0x1c]
      - id: record_number
        type: u1
        enum: record
      - id: dataset_number
        type: u1
      - id: len_data_short
        type: u2
        doc: |
          Size of `data`, unless the top bit is set, in which case the low 15 bits
          are the size of `len_data_extended`.
      - id: len_data_extended
        size: len_data_short & 0x7fff
        type: len_extended
        if: is_extended
      - id: data
        size: 'is_extended ? len_data_extended.value : len_data_short'
    instances:
      is_extended:
        value: len_data_short & 0x8000 != 0
      envelope_dataset:
        value: dataset_number
        enum: envelope_dataset
        if: record_number == record::envelope
      application_dataset:
        value: dataset_number
        enum: application_dataset
        if: record_number == record::application
      next_byte:
        pos: _io.pos
        type: u1
        if: not _io.eof
        doc: Peeks at the byte following this dataset.
  len_extended:
    doc: Big-endian unsigned integer of 1 to 8 bytes.
    seq:
      - id: bytes
        type: u1
        repeat: eos
    instances:
      value:
        value: |
          bytes.size == 1 ? bytes[0] :
          bytes.size == 2 ? (bytes[0] << 8 | bytes[1]) :
          bytes.size == 3 ? (bytes[0] << 16 | bytes[1] << 8 | bytes[2]) :
          (bytes[0].as<u8> << 24 | bytes[1] << 16 | bytes[2] << 8 | bytes[3])
        doc: Only lengths of up to 4 bytes are supported.
enums:
  record:
    1: envelope
    2: application
    3: newsphoto
    7: pre_object_data
    8: object_data
    9: post_object_data
    240: fotostation
  envelope_dataset:
    0: envelope_record_version
    5: destination
    20: file_format
    22: file_version
    30: service_identifier
    40: envelope_number
    50: product_id
    60: envelope_priority
    70: date_sent
    80: time_sent
    90: coded_character_set
    100: unique_object_name
    120: arm_identifier
    122: arm_version
  application_dataset:
    0: application_record_version
    3: object_type_reference
    4: object_attribute_reference
    5: object_name
    7: edit_status
    8: editorial_update
    10: urgency
    12: subject_reference
    15: category
    20: supplemental_categories
    22: fixture_identifier
    25: keywords
    26: content_location_code
    27: content_location_name
    30: release_date
    35: release_time
    37: expiration_date
    38: expiration_time
    40: special_instructions
    42: action_advised
    45: reference_service
    47: reference_date
    50: reference_number
    55: date_created
    60: time_created
    62: digital_creation_date
    63: digital_creation_time
    65: originating_program
    70: program_version
    75: object_cycle
    80: by_line
    85: by_line_title
    90: city
    92: sub_location
    95: province_state
    100: country_primary_location_code
    101: country_primary_location_name
    103: original_transmission_reference
    105: headline
    110: credit
    115: source
    116: copyright_notice
    118: contact
    120: caption_abstract
    121: local_caption
    122: writer_editor
    125: rasterized_caption
    130: image_type
    131: image_orientation
    135: language_identifier
    150: audio_type
    151: audio_sampling_rate
    152: audio_sampling_resolution
    153: audio_duration
    154: audio_outcue
    184: job_id
    185: master_document_id
    186: short_document_id
    187: unique_document_id
    188: owner_id
    200: object_preview_file_format
    201: object_preview_file_version
    202: object_preview_data
