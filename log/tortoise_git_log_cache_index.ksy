meta:
  id: tortoise_git_log_cache_index
  title: TortoiseGit git log cache index
  application: TortoiseGit
  -filename-regexp: "^tortoisegit\\.index$"
  xref:
    wikidata: Q178572
  license: GPL-3.0+
  ks-version: 0.9
  encoding: UTF-16LE
  endian: le

doc: |
  TortoiseGit is a GUI frontend for git SCM. It caches some data to `tortoisegit.data` file in `.git` dir. `tortoisegit.index is an index for that file.

doc-ref:
  - https://gitlab.com/tortoisegit/tortoisegit/raw/master/src/TortoiseProc/gitlogcache.h
  - https://gitlab.com/tortoisegit/tortoisegit/raw/master/src/TortoiseProc/GitLogCache.cpp

seq:
  - id: signature
    -orig-id: m_Magic
    contents: [0x66, 0x55, 0xAA, 0x88]
  - id: version
    -orig-id: m_Version
    type: u4
    doc: "current one is 0x11"
  - id: item_count
    -orig-id: m_ItemCount
    type: u4
  - id: items
    type: item
    repeat: expr
    repeat-expr: item_count
types:
  c_git_hash:
    seq:
      - id: hash
        size: 20
  item:
    -orig-id: SLogCacheIndexItem
    seq:
      - id: hash
        -orig-id: m_Hash
        type: c_git_hash
      - id: offset
        -orig-id: m_Offset
        type: u8 # ULONGLONG
