# Imported from https://gist.githubusercontent.com/u1735067/9c803a37be34e99600ccc1302a69bfdc/raw/3d471c04b1d98b920a8538fd1b03ea8c8f426cf6/mobi.ksy.yml
meta:
  id: mobipocket
  title: Mobipocket e-book (.mobi)
  file-extension: mobi
  license: LicenseRef-All-Rights-Reserved
  endian: be

doc-ref:
  - https://en.wikipedia.org/wiki/Amazon_Kindle#File_formats
  - https://wiki.mobileread.com/wiki/KindleUnpack
  - https://www.mobileread.com/forums/showthread.php?t=166536&page=3
  - https://web.archive.org/web/20140113152714/http://extraordinarycommons.com/creating-kindle-mobi-and-kf8-from-different-sources/
  - https://www.mobileread.com/forums/showthread.php?p=1942007#post1942007
  - https://www.mobileread.com/forums/showthread.php?t=96903
  - https://www.mobileread.com/forums/showthread.php?t=61986
  - https://www.mobileread.com/forums/showthread.php?t=171529
  - https://wiki.mobileread.com/wiki/AZW
  - https://wiki.mobileread.com/wiki/AZW1#AZW1
  - https://wiki.mobileread.com/wiki/KF8
  - https://wiki.mobileread.com/wiki/KFX
  - https://wiki.mobileread.com/wiki/JXR
  - https://wiki.mobileread.com/wiki/AZW4
  - https://wiki.mobileread.com/wiki/MOBI
  - https://wiki.mobileread.com/wiki/PalmDOC
  - http://www.hotpaw.com/rhn/palm/pdb.txt
  - https://www.epubor.com/difference-between-kindle-content-azw-azw3-prc-mobi-topaz.html
  - https://teleread.org/2017/01/29/latest-kindle-for-pc-no-longer-uses-calibre-compatible-azw-files/
  - https://github.com/kovidgoyal/calibre/tree/master/src/calibre/ebooks/mobi
  - https://github.com/kroo/mobi-python/blob/master/mobi/__init__.py
  - https://github.com/sumatrapdfreader/sumatrapdf/blob/master/src/utils/PalmDbReader.h
  - https://github.com/alphabetum/kindler/blob/master/lib/mobi/header.rb
  - https://github.com/obra/unsavory-epub-hacks/blob/master/mobiperl/lib/MobiPerl/EXTH.pm
  - http://search.cpan.org/~azed/EBook-Tools-v0.4.9/lib/EBook/Tools/Mobipocket.pm
  - https://github.com/pthcode/alexandria/blob/master/mobi.py
  - https://github.com/pwr/KSP/blob/master/tools/DumpMobiHeader.py
  - https://github.com/kevinhendricks/KindleUnpack/blob/master/DumpMobiHeader_v022.py
  - https://github.com/quiris11/ExtractCoverThumbs/blob/master/lib/kindle_unpack.py
  - http://www.fabiszewski.net/libmobi/index.html
  - http://www.fabiszewski.net/libmobi/structMOBIMobiHeader.html
  - http://www.fabiszewski.net/libmobi/mobitool_8c-example.html
  - https://github.com/kovidgoyal/calibre/blob/master/src/calibre/ebooks/mobi/langcodes.py

# https://wiki.mobileread.com/wiki/MOBI
seq:
  - id: pdb_header
    size: 78 # 0x4e
    type: pdb_header_type
  - id: pdb_record_index
    type: pdb_record_index_type
    repeat: expr
    repeat-expr: pdb_header.num_records
    # type: ressource_index
  - id: zeros # Padding probably
    contents: [ 0x00, 0x00 ]
  - id: record0
    size: pdb_record_index[1].offset - pdb_record_index[0].offset
    type: record0_type
    
types:
  # https://wiki.mobileread.com/wiki/PDB#Palm_Database_Format
  # https://en.wikipedia.org/wiki/PDB_(Palm_OS)
  # https://github.com/sumatrapdfreader/sumatrapdf/blob/master/src/utils/PalmDbReader.h
  # https://github.com/alphabetum/kindler/tree/master/lib/palm
  pdb_header_type:
    seq: 
      - id: name
        size: 0x20 # 31+0x0
        type: strz
        encoding: windows-1252
      - id: attributes
      # https://github.com/alphabetum/kindler/blob/master/lib/palm/pdb.rb
        type: u2
      - id: version
        type: u2
      - id: creation_time
        type: u4
      - id: modification_time
        type: u4
      - id: backup_time
        type: u4
      - id: modification_number
        type: u4
      - id: app_info_offset
        type: u4
      - id: sort_info_offset
        type: u4
      - id: type
        size: 4
        type: str
        encoding: ASCII
      - id: creator
        size: 4
        type: str
        encoding: ASCII
      - id: unique_id
        type: u4
      - id: next_record
        type: u4
      - id: num_records
        type: u2
    #instances:
    #  type_creator:
    #    value: type + creator
    #    enum: pdb_type_enum
  
  pdb_record_index_type:
    seq:
      - id: offset
        type: u4
      - id: packed_attributes
        type: pdb_record_index_attribute_type
      # Initially in the form id_{a,b,c} .. but num_records is only 2 bytes .. so ?
      # But next_record is 4 bits ? What if they're both 3 bits actually ?
      - id: id_h
        type: u1
      - id: id_l
        type: u2
    instances:
      id: 
        value: (id_h << 16) | id_l # (id_h << 16) + id_l
    #  content:
    #    io: _root._io
    #    pos: offset
    #    size: _parent.pdb_record_index[_index+1] - offset
  
  pdb_record_index_attribute_type: # bitmap
    seq: 
      - id: unknow
        type: b4
      - id: expunged
        type: b1
      - id: dirty
        type: b1
      - id: deleted
        type: b1
      - id: private
        type: b1
  
  record0_type:
    seq:
      - id: palm_doc_header
        type: palm_doc_header_type
      - id: mobi_header
        type: mobi_header_type
      - id: exth_header
        type: exth_header_type
        if: mobi_header.content.common.exth_flags.has_exth
      - id: rest
        size-eos: true
  
  palm_doc_header_type:
    seq:
      - id: compression
        type: u2
        enum: palm_doc_compression_enum
      - id: zeros
        contents: [ 0x00, 0x00 ]
      - id: text_length
        type: u4
      - id: record_count
        type: u2
      - id: record_size
        type: u2
      - id: encryption
        type: u2
        enum: palm_doc_encryption_enum
      - id: unknow # Probably padding too
        type: u2
  
  mobi_header_type:
    seq:
      - id: identifier
        size: 4
        type: str
        encoding: ASCII
      - id: header_length # Calibre uses 0x8e (142) for v2/6 and 0x108 (264) for v8
        type: u4
      - id: content
        size: header_length - 8
        type: mobi_header_content_type
  
  # https://github.com/kovidgoyal/calibre/blob/master/src/calibre/ebooks/mobi/writer2/main.py
  # https://github.com/kovidgoyal/calibre/blob/master/src/calibre/ebooks/mobi/writer8/mobi.py
  # https://github.com/kovidgoyal/calibre/blob/master/src/calibre/ebooks/mobi/debug/headers.py
  mobi_header_content_type:
    seq: 
      - id: common
        type: mobi_header_content_common_type
      # Is http://www.fabiszewski.net/libmobi/group__mobi__len.html correct ?
      - id: extra_v6
        type: mobi_header_content_extra_v6_type
        if: common.format_version >= 6
      - id: content_extra_v7
        type: mobi_header_content_extra_v7_type
        #if: common.format_version == 7
        if: _parent.header_length - 8 - _io.pos == 16 # There's mobi that advertises format v7 but doesn't have this ..
      - id: content_extra_v8
        type: mobi_header_content_extra_v8_type
        #if: common.format_version >= 8
        if: _parent.header_length - 8 - _io.pos == 32
      - id: rest
        size-eos: true
  
  mobi_header_content_common_type:
    seq:
      - id: book_type
        type: u4
        enum: mobi_type_enum
      - id: text_encoding
        type: u4
        enum: mobi_text_encoding_enum
      - id: unique_id
        type: u4
      - id: format_version
        type: u4
      - id: ortographic_record
        type: u4
        doc: Section index number or 0xFFFFFFFF
      - id: inflection_record
        type: u4
        doc: Section index number or 0xFFFFFFFF
      - id: index_names # Aka secondary_index_record
        type: u4
        doc: Index number or 0xFFFFFFFF
      - id: index_keys # Aka reserved
        type: u4
        doc: Index number or 0xFFFFFFFF
      - id: extra_index_0
        type: u4
        doc: Section index number or 0xFFFFFFFF
      - id: extra_index_1
        type: u4
        doc: Section index number or 0xFFFFFFFF
      - id: extra_index_2
        type: u4
        doc: Section index number or 0xFFFFFFFF
      - id: extra_index_3
        type: u4
        doc: Section index number or 0xFFFFFFFF
      - id: extra_index_4
        type: u4
        doc: Section index number or 0xFFFFFFFF
      - id: extra_index_5
        type: u4
        doc: Section index number or 0xFFFFFFFF
      - id: first_non_text_record
        type: u4
      - id: title_offset
        type: u4
        doc: Offset in record0
      - id: title_length
        type: u4
      - id: language
        type: u4
        enum: ms_lcid_enum
      - id: dictionnary_input_language
        type: u4
        enum: ms_lcid_enum
      - id: dictionnary_output_language
        type: u4
        enum: ms_lcid_enum
      - id: min_version
        type: u4
      - id: first_ressource_record
        type: u4
      - id: huffman_record
        type: u4
      - id: huffman_record_count
        type: u4
      - id: huffman_table_record # Aka datp_record
        type: u4
      - id: huffman_table_record_count # Aka datp_record_count
        type: u4
      - id: exth_flags
        type: mobi_header_content_common_exth_flags_type
        doc: bit6 / 0x40 > there's an EXTH record
      # Might cut here for files without DRM
      - id: unknow1
        size: 32
      - id: unknow2
        type: u4
      - id: drm_offset
        type: u4
        doc: Starting from record0
      - id: drm_count
        type: u4
      - id: drm_size
        type: u4
      - id: drm_flags
        type: u4
      # Might cut here for files without extra data
      - id: unknow3
        type: u8
        doc: |
          Bytes to the end of the MOBI header, including the following if the header
          length >= 228 (244 from start of record).
      - id: first_content_record
        type: u2
        if: format_version < 7
      - id: content_last_index_number
        type: u2
        if: format_version < 7
        doc: Includes images, DATP, HUFF, DRM
      - id: fdst_record
        type: u4
        if: format_version >= 7
      - id: fdst_record_count
        type: u4
      - id: fcis_record
        type: u4
      - id: fcis_record_count
        type: u4
      - id: flis_record
        type: u4
      - id: flis_record_count
        type: u4
      - id: unknow4
        type: u8
  
  mobi_header_content_common_exth_flags_type: # bitfield
    doc-ref:
      - "https://github.com/kovidgoyal/calibre/blob/e333001d31dc49102fe5178bd2a8af4f06962fac/src/calibre/ebooks/mobi/writer2/main.py#L301"
      - "https://github.com/kovidgoyal/calibre/blob/875af72918c71871e17897b5e8d13e556f6ddf17/src/calibre/ebooks/mobi/writer8/mobi.py#L293"
    seq: 
      - id: unknow1
        type: u2
      - id: unknow2
        type: b3
      - id: has_fonts   # 0b1_0000_0000_0000
        type: b1
      - id: unknow3
        type: b5
      - id: has_exth    #         0b100_0000
        type: b1
      - id: unknow4
        type: b1
      - id: unknow5     #           0b1_0000 , used by calibre
        type: b1
      - id: periodical  #             0b1000
        type: b1
      - id: unknow6
        type: b3
  
  mobi_header_content_extra_v6_type:
    seq:
      - id: srcs_record # Aka compilation_data_section_first_count
        type: u4
      - id: srcs_record_count # Aka compilation_data_section_count
        type: u4
      - id: unknow5
        type: u8
      - id: extra_data_flags
        type: mobi_header_content_extra_v6_extra_data_type
        doc-ref: "https://github.com/kovidgoyal/calibre/blob/875af72918c71871e17897b5e8d13e556f6ddf17/src/calibre/ebooks/mobi/writer8/mobi.py#L166"
      - id: ncx_record # Aka primary_index_record_idx
        type: u4
  
  mobi_header_content_extra_v6_extra_data_type: # bitfield
    seq:
      - id: unknow1
        type: u2
      - id: unknow2
        type: u1
      - id: unknow3
        type: b5
      - id: uncrossable_breaks  # 0b100 - uncrossable breaks only used in MOBI 6
        type: b1
      - id: tbs_indexing_data   # 0b010 - TBS indexing data (only used in MOBI 6)
        type: b1
      - id: extra_multibyte     # 0b001 - extra multibyte bytes after text records
        type: b1

  # Maybe just the start of the v8 version
  mobi_header_content_extra_v7_type:
    seq:
      - id: unknow
        size: 16
  
  mobi_header_content_extra_v8_type:
    seq:
      - id: chunk_record
        type: u4
      - id: skel_record
        type: u4
      - id: datp_record
        type: u4
      - id: guide_record
        type: u4
      - id: unknow1
        type: u4
      - id: unknow2
        type: u4
      - id: unknow3
        type: u4
      - id: unknow4
        type: u4
  
  exth_header_type:
    seq: 
      - id: identifier
        size: 4
        type: str
        encoding: ASCII
      - id: header_length
        type: u4
      - id: record_count
        type: u4
      - id: records
        size: header_length-12
        type: exth_records_type
  
  exth_records_type:
    seq:
      - id: record
        type: exth_record_type
        repeat: expr
        repeat-expr: _parent.record_count
      - id: padding
        size-eos: true
  
  exth_record_type:
    meta:
      #encoding: _root.record0.mobi_header.content.common.text_encoding
      encoding: UTF-8
    seq: 
      - id: type
        type: u4
        enum: exth_record_type_enum
      - id: length
        type: u4
      - id: data
        size: length - 8
        type: 
          switch-on: type
          cases: 
            exth_record_type_enum::drm_ebookbase_book_id: str
            exth_record_type_enum::title: str
            exth_record_type_enum::creator: str
            exth_record_type_enum::publisher: str
            exth_record_type_enum::imprint: str
            exth_record_type_enum::description: str
            exth_record_type_enum::isbn: str
            exth_record_type_enum::subject: str
            exth_record_type_enum::published: str
            exth_record_type_enum::review: str
            exth_record_type_enum::contributor: str
            exth_record_type_enum::rights: str
            exth_record_type_enum::type: str
            exth_record_type_enum::source: str
            exth_record_type_enum::asin_id_113: str
            #exth_record_type_enum::version_number: str
            #exth_record_type_enum::price: str
            #exth_record_type_enum::currency: str
            #exth_record_type_enum::book_type: str
            exth_record_type_enum::kf8_count_of_resources_fonts_images: u4
            exth_record_type_enum::kf8_masthead__cover_image: str
            exth_record_type_enum::dict_short_name: str
            exth_record_type_enum::creator_major_version: u4
            exth_record_type_enum::creator_minor_version: u4
            exth_record_type_enum::creator_build_number: u4
            #exth_record_type_enum::watermark: str
            exth_record_type_enum::cde_type: str # Heard it can be hex
            exth_record_type_enum::updated_title: str
            exth_record_type_enum::asin_id_504: str
            exth_record_type_enum::language: str
            exth_record_type_enum::primary_writing_mode: str
            exth_record_type_enum::creator_string: str
            exth_record_type_enum::override_kindle_fonts: str
            exth_record_type_enum::kindle_source_desc: str
            exth_record_type_enum::input_source_type: str
            exth_record_type_enum::kindlegen_build_rev_number: str
    instances:
      data_length:
        value: length - 8

enums:
  # pdb_type_enum: 
    # https://github.com/kovidgoyal/calibre/blob/master/format_docs/pdb/pdb_types.txt
    # "'.pdfADBE'": adobe_reader
    # "'TEXtREAd'": palm_doc
    # "'BVokBDIC'": b_dicty
    # "'DB99DBOS'": db # (Database program)
    # "'PNRdPPrs'": e_reader
    # "'DataPPrs'": e_reader
    # "'vIMGView'": fire_viewer # (ImageViewer)
    # "'PmDBPmDB'": han_dbase
    # "'InfoINDB'": info_view
    # "'ToGoToGo'": i_silo
    # "'SDocSilX'": i_silo_3
    # "'JbDbJBas'": j_file
    # "'JfDbJFil'": j_file_pro
    # "'DATALSdb'": list
    # "'Mdb1Mdb1'": mobile_db
    # "'BOOKMOBI'": mobi_pocket
    # "'DataPlkr'": plucker
    # "'DataSprd'": quick_sheet
    # "'SM01SMem'": super_memo
    # "'TEXtTlDc'": teal_doc
    # "'InfoTlIf'": teal_info
    # "'DataTlMl'": teal_meal
    # "'DataTlPt'": teal_paint
    # "'dataTDBP'": think_db
    # "'TdatTide'": tides
    # "'ToRaTRPW'": tome_raider
    # "'zTXTGPlm'": weasel
    # "'BDOCWrdS'": word_smith

  palm_doc_compression_enum:
    1: no
    2: palm_doc_compression
    17480: huff_cdic_compression
  
  palm_doc_encryption_enum:
    0: unencrypted
    1: old_mobipocket_encryption
    2: mobipocket_encryption
  
  mobi_type_enum:
    002: mobipocket_book # Chapter / chapter nav
    003: palmdoc_book
    004: audio
    232: mobipocket_kindle_gen1_2
    248: kf8_kindle_gen2
    257: news # News hierarchical
    258: news_feed # News (flat)
    259: news_magazine
    513: pics
    514: word
    515: xls
    516: ppt
    517: text
    518: html
  
  mobi_text_encoding_enum:
    01252: cp1252
    65001: utf8
    65002: utf16 # http://www.fabiszewski.net/libmobi/group__mobi__enc.html
  
  exth_record_type_enum:
    # https://github.com/kovidgoyal/calibre/blob/master/src/calibre/ebooks/mobi/writer8/exth.py
    # http://www.fabiszewski.net/libmobi/group__mobi__enums.html
    001: drm_server_id
    002: drm_commerce_id
    003: drm_ebookbase_book_id
    099: title
    100: creator
    101: publisher
    102: imprint
    103: description
    104: isbn
    105: subject
    106: published
    107: review
    108: contributor
    109: rights
    110: subject_code
    111: type
    112: source
    113: asin_id_113
    114: version_number
    115: sample
    116: start_offset # STARTREADING
    117: adult
    118: price
    119: currency
    121: kf8_boundary_section # KF8BOUNDARY
    122: fixed_layout
    123: book_type
    124: orientation_lock
    125: kf8_count_of_resources_fonts_images # COUNTRESOURCES
    126: original_resolution
    127: zero_gutter
    128: zero_margin
    129: kf8_masthead__cover_image # KF8COVERURI
    131: kf8_unidentified_count # RESCOFFSET
    132: region_magnification
    200: dict_short_name
    201: cover_offset
    202: thum_boffset
    203: fake_cover
    204: creator_software # http://www.fabiszewski.net/libmobi/common_8c-example.html
    205: creator_major_version
    206: creator_minor_version
    207: creator_build_number
    208: watermark
    209: tamper_proof_keys # [hex]
    300: font_signature # [hex]
    301: clipping_limit # [3xx]
    401: clipping_limit_401
    402: publisher_limit
    404: text_to_speech_disabled
    406: rental # libmobi
    501: cde_type # DOCTYPE
    502: last_update_time
    503: updated_title
    504: asin_id_504 # [5xx]
    508: unknown_title_furigana
    517: unknown_creator_furigana
    522: unknown_publisher_furigana
    524: language
    525: primary_writing_mode # ALIGNMENT
    526: creator_string # libmobi
    527: page_progression_direction
    528: override_kindle_fonts
    529: kindle_source_desc #libmobi
    531: dict_lang_in #libmobi
    532: dict_lang_out #libmobi
    534: input_source_type
    535: kindlegen_build_rev_number
    536: container_info
    538: container_resolution
    539: container_mimetype
    543: container_id
  
  ms_lcid_enum:
    # https://github.com/libyal/libfwnt/wiki/Language-Code-identifiers
    # https://msdn.microsoft.com/en-us/library/cc233965.aspx
    # https://msdn.microsoft.com/en-us/library/cc233982.aspx
    # https://msdn.microsoft.com/en-us/library/cc233968.aspx
    # https://msdn.microsoft.com/en-us/library/windows/desktop/dd318693(v=vs.85).aspx
    # https://github.com/Alexpux/mingw-w64/blob/master/mingw-w64-headers/include/winnt.h#L1250
    # https://github.com/evernote/serge/blob/master/lib/Serge/Util/LangID.pm
    # https://www.autoitscript.fr/autoit3/docs/appendix/OSLangCodes.htm
    # https://github.com/kovidgoyal/calibre/blob/master/src/calibre/ebooks/mobi/langcodes.py
    0x00: none
    0x7F: invariant
    0x02: system_default
    0x36: afrikaans
    0x1c: albanian
    0x84: alsatian
    0x5E: amharic
    0x01: arabic
    0x2B: armenian
    0x4D: assamese
    0x2C: azeri
    0x45: bangla
    0x6D: bashkir
    0x2d: basque
    0x23: belarusian
    0x1A: bosnian
    0x7E: breton
    # 0x02: bulgarian  # duplicate value
    0x92: central_kurdish
    0x5C: cherokee
    0x03: catalan
    0x04: chinese
    # 0x04: chinese_simplified  # duplicate value
    0x83: corsican
    # 0x1A: croatian  # duplicate value
    # 0x1a: croatian  # duplicate value
    0x05: czech
    0x06: danish
    0x8C: dari
    0x65: divehi
    0x13: dutch
    0x09: english
    0x25: estonian
    0x38: faeroese
    0x64: filipino
    0x0B: finnish
    0x0C: french
    0x62: frisian
    0x56: galician
    0x37: georgian
    0x07: german
    0x08: greek
    0x6F: greenlandic
    0x47: gujarati
    0x68: hausa
    0x75: hawaiian
    0x0D: hebrew
    0x39: hindi
    0x0E: hungarian
    0x0F: icelandic
    0x70: igbo
    0x21: indonesian
    0x5D: inuktitut
    0x3C: irish
    0x34: xhosa
    0x35: zulu
    0x10: italian
    0x11: japanese
    0x4B: kannada
    0x60: kashmiri
    0x3F: kazak
    0x53: khmer
    0x86: kiche
    0x87: kinyarwanda
    0x57: konkani
    0x12: korean
    0x40: kyrgyz
    0x54: lao
    0x26: latvian
    0x27: lithuanian
    0x2E: lower_sorbian
    0x6E: luxembourgish
    0x2F: macedonian
    0x3E: malay
    0x4C: malayalam
    0x3A: maltese
    0x58: manipuri
    0x81: maori
    0x7A: mapudungun
    0x4E: marathi
    0x7C: mohawk
    0x50: mongolian
    0x61: nepali
    0x14: norwegian
    0x82: occitan
    0x48: oriya
    0x63: pashto
    0x29: persian
    0x15: polish
    0x16: portuguese
    0x67: pular
    0x46: punjabi
    0x6B: quechua
    0x18: romanian
    0x17: romansh
    0x19: russian
    0x85: sakha
    0x3B: sami
    0x4F: sanskrit
    # 0x1a: serbian  # duplicate value
    0x6C: sotho
    0x32: tswana
    0x59: sindhi
    0x5B: sinhalese
    0x1b: slovak
    0x24: slovenian
    0x0A: spanish
    0x41: swahili
    0x1D: swedish
    0x5A: syriac
    0x28: tajik
    0x5F: tamazight
    0x49: tamil
    0x44: tatar
    0x4A: telugu
    0x1E: thai
    0x51: tibetan
    0x73: tigrinya
    # 0x73: tigrigna  # duplicate value
    0x1F: turkish
    0x42: turkmen
    0x22: ukrainian
    # 0x2E: upper_sorbian  # duplicate value
    0x20: urdu
    0x80: uighur
    0x43: uzbek
    # 0x03: valencian  # duplicate value
    0x2A: vietnamese
    0x52: welsh
    0x88: wolof
    0x78: yi
    0x6A: yoruba
    0x0C00: custom_default
    0x1400: ui_custom_default
    # 0x007F: neutral  # duplicate value
    0x0800: sys_default
    0x1000: custom_unspecified
    0x0400: default
    0x0436: afrikaans_south_africa
    0x041C: albanian_albania
    0x0484: alsatian_france
    0x045E: amharic_ethiopia
    0x1401: arabic_algeria
    0x3C01: arabic_bahrain
    0x0C01: arabic_egypt
    0x0801: arabic_iraq
    0x2C01: arabic_jordan
    0x3401: arabic_kuwait
    0x3001: arabic_lebanon
    0x1001: arabic_libya
    0x1801: arabic_morocco
    0x2001: arabic_oman
    0x4001: arabic_qatar
    0x0401: arabic_saudi_arabia
    0x2801: arabic_syria
    0x1C01: arabic_tunisia
    0x3801: arabic_uae
    0x2401: arabic_yemen
    0x042B: armenian_armenia
    0x044D: assamese_india
    0x082C: azeri_cyrillic
    0x042C: azeri_latin
    0x0445: bangla_bangladesh
    0x046D: bashkir_russia
    0x042D: basque_basque
    0x0423: belarusian_belarus
    0x781A: bosnian_neutral
    0x201A: bosnian_bosnia_herzegovina_cyrillic
    0x141A: bosnian_bosnia_herzegovina_latin
    0x047E: breton_france
    0x0402: bulgarian_bulgaria
    0x0492: central_kurdish_iraq
    0x045C: cherokee_cherokee
    0x0403: catalan_catalan
    0x0C04: chinese_hongkong
    0x1404: chinese_macau
    0x1004: chinese_singapore
    # 0x0004: chinese_simplified  # duplicate value
    0x7C04: chinese_traditional
    0x0483: corsican_france
    # 0x001A: croatian_neutral  # duplicate value
    0x101A: croatian_bosnia_herzegovina_latin
    0x041A: croatian_croatia
    0x0405: czech_czech_republic
    0x0406: danish_denmark
    0x048C: dari_afghanistan
    0x0465: divehi_maldives
    0x0813: dutch_belgian
    0x0413: dutch_0x0413
    0x0C09: english_aus
    0x2809: english_belize
    0x1009: english_can
    0x2409: english_caribbean
    0x4009: english_india
    0x1809: english_eire
    # 0x1809: english_ireland  # duplicate value
    0x2009: english_jamaica
    0x4409: english_malaysia
    0x1409: english_nz
    0x3409: english_philippines
    0x4809: english_singapore
    0x1c09: english_south_africa
    0x2C09: english_trinidad
    0x0809: english_uk
    0x0409: english_us
    0x3009: english_zimbabwe
    0x0425: estonian_estonia
    0x0438: faeroese_faroe_islands
    0x0464: filipino_philippines
    0x040B: finnish_finland
    0x080c: french_belgian
    0x0C0C: french_canadian
    0x040c: french_0x040c
    0x140C: french_luxembourg
    0x180C: french_monaco
    0x100C: french_swiss
    0x0462: frisian_netherlands
    0x0456: galician_galician
    0x0437: georgian_georgia
    0x0C07: german_austrian
    0x0407: german_0x0407
    0x1407: german_liechtenstein
    0x1007: german_luxembourg
    0x0807: german_swiss
    0x0408: greek_greece
    0x046F: greenlandic_greenland
    0x0447: gujarati_india
    0x0468: hausa_nigeria_latin
    0x0475: hawaiian_us
    0x040D: hebrew_israel
    0x0439: hindi_india
    0x040E: hungarian_hungary
    0x040F: icelandic_iceland
    0x0470: igbo_nigeria
    0x0421: indonesian_indonesia
    0x085D: inuktitut_canada_latin
    0x045D: inuktitut_canada
    0x083C: irish_ireland
    0x0434: xhosa_south_africa
    0x0435: zulu_south_africa
    0x0410: italian_0x0410
    0x0810: italian_swiss
    0x0411: japanese_japan
    0x044B: kannada_india
    0x043F: kazak_kazakhstan
    0x0453: khmer_cambodia
    0x0486: kiche_guatemala
    0x0487: kinyarwanda_rwanda
    0x0457: konkani_india
    0x0412: korean_0x0412
    0x0440: kyrgyz_kyrgyzstan
    0x0454: lao_lao
    0x0426: latvian_latvia
    0x0427: lithuanian_lithuania
    0x082E: lower_sorbian_germany
    0x046E: luxembourgish_luxembourg
    0x042F: macedonian_macedonia
    0x083E: malay_brunei_darussalam
    0x043e: malay_malaysia
    0x044C: malayalam_india
    0x043A: maltese_malta
    0x0481: maori_new_zealand
    0x047A: mapudungun_chile
    0x044E: marathi_india
    0x047C: mohawk_mohawk
    0x0450: mongolian_cyrillic_mongolia
    0x0850: mongolian_prc
    0x0461: nepali_nepal
    0x0414: norwegian_bokmal
    0x0814: norwegian_nynorsk
    0x0482: occitan_france
    0x0448: oriya_india
    0x0463: pashto_afghanistan
    0x0429: persian_iran
    0x0415: polish_poland
    0x0416: portuguese_brazilian
    0x0816: portuguese_0x0816
    0x0867: pular_senegal
    0x0446: punjabi_india
    0x0846: punjabi_pakistan
    0x046B: quechua_bolivia
    0x086B: quechua_ecuador
    0x0C6B: quechua_peru
    0x0418: romanian_romania
    0x0417: romansh_switzerland
    0x0419: russian_russia
    0x0485: sakha_russia
    0x243B: sami_inari_finland
    0x103B: sami_lule_norway
    0x143B: sami_lule_sweden
    0x0C3B: sami_northern_finland
    0x043B: sami_northern_norway
    0x083B: sami_northern_sweden
    0x203B: sami_skolt_finland
    0x183B: sami_southern_norway
    0x1C3B: sami_southern_sweden
    0x044F: sanskrit_india
    0x7C1A: serbian_neutral
    0x1C1A: serbian_bosnia_herzegovina_cyrillic
    0x181A: serbian_bosnia_herzegovina_latin
    0x0C1A: serbian_cyrillic
    0x081A: serbian_latin
    0x046C: sotho_northern_south_africa
    0x0832: tswana_botswana
    0x0432: tswana_south_africa
    0x0459: sindhi_india
    0x0859: sindhi_pakistan
    0x045B: sinhalese_sri_lanka
    0x041B: slovak_slovakia
    0x0424: slovenian_slovenia
    0x2C0A: spanish_argentina
    0x400A: spanish_bolivia
    0x340A: spanish_chile
    0x240A: spanish_colombia
    0x140A: spanish_costa_rica
    0x1C0A: spanish_dominican_republic
    0x300A: spanish_ecuador
    0x440A: spanish_el_salvador
    0x100A: spanish_guatemala
    0x480A: spanish_honduras
    0x080A: spanish_mexican
    0x4C0A: spanish_nicaragua
    0x180A: spanish_panama
    0x3C0A: spanish_paraguay
    0x280A: spanish_peru
    0x500A: spanish_puerto_rico
    0x0C0A: spanish_modern
    0x040A: spanish_0x040a
    0x540A: spanish_us
    0x380A: spanish_uruguay
    0x200A: spanish_venezuela
    0x0441: swahili_0x0441
    0x081D: swedish_finland
    0x041D: swedish_0x041d
    # 0x041D: swedish_sweden  # duplicate value
    0x045A: syriac_0x045a
    0x0428: tajik_tajikistan
    0x085F: tamazight_algeria_latin
    0x0449: tamil_india
    0x0849: tamil_sri_lanka
    0x0444: tatar_russia
    0x044A: telugu_india
    0x041E: thai_thailand
    0x0451: tibetan_prc
    0x0873: tigrinya_eritrea
    0x0473: tigrinya_ethiopia
    # 0x0873: tigrigna_eritrea  # duplicate value
    0x041F: turkish_turkey
    0x0442: turkmen_turkmenistan
    0x0422: ukrainian_ukraine
    0x042E: upper_sorbian_germany
    0x0820: urdu_india
    0x0420: urdu_pakistan
    0x0480: uighur_prc
    0x0843: uzbek_cyrillic
    0x0443: uzbek_latin
    0x0803: valencian_valencia
    0x042A: vietnamese_vietnam
    0x0452: welsh_united_kingdom
    0x0488: wolof_senegal
    0x0478: yi_prc
    0x046A: yoruba_nigeria
