meta:
  id: android_tzdata
  title: Android time zone data (tzdata)
  application:
    - Android
    - bionic libc
  license: CC0-1.0
  ks-version: '0.11'
  imports:
    - /common/tzif
  encoding: ASCII
  endian: be
doc: |
  Android does not ship the IANA time zone database as one TZif file
  per zone; instead the `tzdata` file (in `/system/usr/share/zoneinfo/`
  or `/apex/com.android.tzdata/etc/tz/`) concatenates the TZif files
  of all zones behind a sorted index of zone names, built by the
  ZoneCompactor tool.

  Layout: a header with the tzdata version (e.g. `tzdata2014g`) and
  three offsets, an index of 52-byte entries (zone name, offset of its
  TZif data relative to the data area, length), the concatenated TZif
  data, and finally a copy of `zone.tab` without comment lines (newer
  bionic calls this last offset `final_offset` and does not read the
  data at it). Zone links share the TZif data of their target.
doc-ref:
  - https://github.com/aosp-mirror/platform_bionic/blob/android-5.0.0_r1/libc/tools/zoneinfo/ZoneCompactor.java
  - https://github.com/aosp-mirror/platform_bionic/blob/731631f300090436d7f5df80d50b6275c8c60a93/libc/tzcode/bionic.cpp
seq:
  - id: header
    type: header
instances:
  index:
    pos: header.ofs_index
    size: header.ofs_data - header.ofs_index
    type: index_entries
  zone_tab:
    pos: header.ofs_zone_tab
    size-eos: true
    type: str
    doc: Contents of zone.tab without comment lines.
types:
  header:
    seq:
      - id: magic
        contents: tzdata
      - id: version
        size: 6
        type: strz
        doc: IANA release, e.g. "2014g".
      - id: ofs_index
        type: u4
      - id: ofs_data
        type: u4
      - id: ofs_zone_tab
        type: u4
        doc: Called `final_offset` in newer bionic.
  index_entries:
    seq:
      - id: entries
        type: index_entry
        repeat: eos
  index_entry:
    seq:
      - id: name
        size: 40
        type: strz
        doc: Olson zone ID, e.g. "Europe/Paris".
      - id: ofs_tzif
        type: u4
        doc: Offset of the TZif data, relative to the data area.
      - id: len_tzif
        type: u4
      - id: unused
        type: u4
        doc: Formerly the raw GMT offset; always 0 since tzdata2014f.
    instances:
      tzif:
        io: _root._io
        pos: _root.header.ofs_data + ofs_tzif
        size: len_tzif
        type: tzif
    -webide-representation: '{name}'
