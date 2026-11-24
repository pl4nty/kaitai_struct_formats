# Imported from https://github.com/Xiphoseer/sdo-kaitai/blob/3f076d0cbcdf9c8d9bef70197dfd0bff878fb758/sdoc0001.ksy
meta:
  id: signum_sdoc0001
  file-extension: SDO
  license: LicenseRef-All-Rights-Reserved
  endian: be
seq:
  - id: header
    type: header
  - id: meta
    type: meta
  - id: chunks
    type: chunk
    repeat: eos
types:
  header:
    seq:
      - id: format
        contents: 'sdoc'
      - id: version
        contents: '0001'
  date:
    meta:
      bit-endian: be
    doc-ref: https://freemint.github.io/tos.hyp/en/gemdos_datetime.html#Tgetdate
    seq:
      - id: year_offset
        type: b7
      - id: month
        type: b4
      - id: day
        type: b5
    instances:
      year:
        value: 1980 + year_offset
  time:
    meta:
      bit-endian: be
    doc-ref: https://freemint.github.io/tos.hyp/en/gemdos_datetime.html#Tgettime
    seq:
      - id: hours
        type: b5
      - id: minutes
        type: b6
      - id: two_seconds
        type: b5
    instances:
      seconds:
        value: two_seconds * 2
  date_time:
    seq:
      - id: date
        type: date
      - id: time
        type: time
  meta:
    seq:
      - id: len
        type: u4
      - id: data
        size: len
        type: data
    instances:
      created:
        io: data._io
        pos: 72
        type: date_time
      modified:
        io: data._io
        pos: 76
        type: date_time
    types:
      data:
        seq: []
  cset:
    seq:
      - id: chsets
        size: 10
        type: strz
        encoding: ASCII
        repeat: expr
        repeat-expr: 8
  sysp:
    seq:
      - size: 80
      - id: space_width
        type: u2
        doc: Space between words in horizontal units
      - id: letter_spacing
        type: u2
        doc: Sperrung
      - id: line_distance
        type: u2
        doc: Hauptzeilenabstand
      - id: index_distance
        type: u2
        doc: Indexabstand
      - id: margins
        type: margins
      - id: page_length
        type: u2
        doc: Seitenlänge
      - id: page_numbering
        type: u2
        doc: 0x5800 == keine Seitennummerierung
      - id: format_options
        type: u2
        doc: 0b10011 == format. optionen
      - id: unknown
        type: u2
        doc: 0x302 == trennen
      - id: borders
        type: u2
        doc: 0 == Randausgleiche und Sperren
      - id: flags
        type: u4
        doc: 1 == nicht einrücken, Absatzabstand mitkorrigieren
  pbuf:
    seq:
      - id: page_count
        type: u4
      - id: entry_len
        type: u4
      - id: first_page_num
        type: u4
      - id: unde
        type: unde
        repeat: expr
        repeat-expr: 5
      - id: entries
        type: entry
        repeat: expr
        repeat-expr: page_count
    types:
      unde: { seq: [{ id: unde, contents: 'unde' }] }
      entry:
        seq:
          - id: index
            type: u2
          - id: phys_page_nr
            type: u2
          - id: log_page_nr
            type: u2
          - id: height # ???
            type: u2
          - id: margins
            type: margins
          - id: unknown
            size: 18
  tebu:
    doc: Text Buffer
    seq:
      - id: line_count
        type: u4
      - id: lines
        type: line
        repeat: eos
    types:
      line:
        seq:
          - id: vskip
            type: u2
          - id: length
            type: u2
          - id: data
            size: length
            type: line_data
            if: "length > 0 and length < 2048"
      line_data:
        seq:
          - id: tag
            type: line_tag
          - id: pnum
            type: u2
            if: tag.has_page_num
          - id: hskip
            type: u2
            if: tag.has_hskip
          - id: data
            type: character
            repeat: eos
      character:
        meta:
          bit-endian: be
        seq:
          - id: short
            type: b1
          - id: short_offset
            type: b6
            if: short
          - id: short_chset
            type: b2
            if: short
          - id: underlined
            type: b1
            if: not short
          - id: mark1
            type: b1
            if: not short
          - id: mark2
            type: b1
            if: not short
          - id: mark3
            type: b1
            if: not short
          - id: footnote
            type: b1
            if: not short
          - id: wide_chset
            type: b3
            if: not short
          - id: char
            type: b7
          - id: wide
            type: b1
            if: not short
          - id: bold
            type: b1
            if: not short
          - id: italic
            type: b1
            if: not short
          - id: tall
            type: b1
            if: not short
          - id: small
            type: b1
            if: not short
          - id: wide_offset
            type: b11
            if: not short
        instances:
          chset_index:
            value: 'short ? short_chset : wide_chset'
          offset:
            value: 'short ? short_offset : wide_offset'
          cset:
            value: _root.chunks[0].data.as<cset>.chsets[chset_index]
            if: short
      line_tag:
        meta:
          bit-endian: be
        seq:
          - id: page_command
            type: b1
          - id: page_start
            type: b1
          - id: page_end
            type: b1
          - id: non_text
            type: b1
          - id: paragraph
            type: b1
          - id: standard_line
            type: b1
          - id: unknown_0200
            type: b1
          - id: unknown_0100
            type: b1
          - id: has_page_num
            type: b1
          - id: unknown_0040
            type: b1
          - id: unknown_0020
            type: b1
          - id: unknown_0010
            type: b1
          - id: unknown_0008
            type: b1
          - id: unknown_0004
            type: b1
          - id: unknown_0002
            type: b1
          - id: has_hskip
            type: b1
  hcim:
    seq:
      - id: site_table_len
        type: u4
      - id: img_count
        type: u2
      - id: site_count
        type: u2
      - id: unknown
        size: 8
      - id: site_table
        size: site_table_len
        type: site_table
      - id: img_table
        type: img_table
    types:
      image:
        seq:
          - id: len
            type: u4
          - id: name
            size: 28
            type: strz
            encoding: ASCII
          - id: data
            size: len - 32
      site:
        seq:
          - id: page
            type: u2
          - id: pos_x
            type: u2
          - id: pos_y
            type: u2
          - id: site_w
            type: u2
          - id: site_h
            type: u2
          - id: unknown1
            type: u2
          - id: sel_x
            type: u2
          - id: sel_y
            type: u2
          - id: sel_w
            type: u2
          - id: sel_h
            type: u2
          - id: unknown2
            type: u2
          - id: unknown3
            type: u2
          - id: unknown4
            type: u2
          - id: img
            type: u2
          - id: unknown5
            type: u2
          - id: unknown6
            size: 2
      site_table:
        seq:
          - id: sites
            size: 32
            type: site
            repeat: expr
            repeat-expr: _parent.site_count
      img_table:
        seq:
          - id: images
            type: image
            repeat: expr
            repeat-expr: _parent.img_count
  chunk:
    seq:
      - id: tag
        type: u4
        enum: chunk_tag
      - id: size
        type: u4
      - id: data
        size: size
        type:
          switch-on: tag
          cases:
            'chunk_tag::cset': cset
            'chunk_tag::sysp': sysp
            'chunk_tag::pbuf': pbuf
            'chunk_tag::tebu': tebu
            'chunk_tag::hcim': hcim
  margins:
    seq:
      - id: left
        type: u2
      - id: right
        type: u2
      - id: header
        type: u2
      - id: footer
        type: u2
enums:
  chunk_tag:
    0x63736574: cset
    0x73797370: sysp
    0x70627566: pbuf
    0x74656275: tebu
    0x6863696d: hcim
    0x706c3031: pl01
    0x73797032: syp2
