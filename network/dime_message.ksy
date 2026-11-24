meta:
  id: dime_message
  title: DIME (Direct Internet Message Encapsulation) Message
  file-extension:
    - dim
    - dime
  xref:
    mime: application/dime
    wikidata: Q1227457
  license: CC0-1.0
  encoding: ASCII
  endian: be
  bit-endian: be
doc: |
  Direct Internet Message Encapsulation (DIME)
  is an old Microsoft specification for sending and receiving
  SOAP messages along with additional attachments,
  like binary files, XML fragments, and even other
  SOAP messages, using standard transport protocols like HTTP.

  Sample file: `curl -LO
  https://github.com/kaitai-io/kaitai_struct_formats/files/5894723/scanner_withoptions.dump.gz
  && gunzip scanner_withoptions.dump.gz`
doc-ref:
  - https://datatracker.ietf.org/doc/html/draft-nielsen-dime-02
  - https://learn.microsoft.com/en-us/archive/msdn-magazine/2002/december/sending-files-attachments-and-soap-messages-via-dime
  - http://imrannazar.com/Parsing-the-DIME-Message-Format
seq:
  - id: records
    type: record
    repeat: eos
types:
  padding:
    doc: padding to the next 4-byte boundary
    seq:
      - id: boundary_padding
        size: (- _io.pos) % 4
  option_field:
    doc: the option field of the record
    seq:
      - id: option_elements
        type: option_element
        repeat: eos
  option_element:
    doc: one element of the option field
    seq:
      - id: element_format
        type: u2
      - id: len_element
        type: u2
      - id: element_data
        size: len_element
  record:
    doc: each individual fragment of the message
    seq:
      - id: version
        type: b5
        doc: DIME format version (always 1)
      - id: is_first_record
        type: b1
        doc: Set if this is the first record in the message
      - id: is_last_record
        type: b1
        doc: Set if this is the last record in the message
      - id: is_chunk_record
        type: b1
        doc: Set if the file contained in this record is chunked into multiple records
      - id: type_format
        type: b4
        enum: type_formats
        doc: Indicates the structure and format of the value of the TYPE field
      - id: reserved
        type: b4
        doc: Reserved for future use
      - id: len_options
        type: u2
        doc: Length of the Options field
      - id: len_id
        type: u2
        doc: Length of the ID field
      - id: len_type
        type: u2
        doc: Length of the Type field
      - id: len_data
        type: u4
        doc: Length of the Data field
      - id: options
        size: len_options
        type: option_field
      - id: options_padding
        type: padding
      - id: id
        size: len_id
        type: str
        doc: Unique identifier of the file (set in the first record of file)
      - id: id_padding
        type: padding
      - id: type
        size: len_type
        type: str
        doc: Specified type in the format set with type_format
      - id: type_padding
        type: padding
      - id: data
        size: len_data
        doc: The file data
      - id: data_padding
        type: padding
enums:
  type_formats:
    0: unchanged
    1: media_type
    2: absolute_uri
    3: unknown
    4: none
