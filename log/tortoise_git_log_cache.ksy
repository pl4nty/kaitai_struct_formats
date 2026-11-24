meta:
  id: tortoise_git_log_cache
  title: TortoiseGit git log cache
  application: TortoiseGit
  -filename-regexp: "^tortoisegit\\.data$"
  xref:
    wikidata: Q178572
  license: GPL-3.0-or-later
  encoding: UTF-16LE
  endian: le
  #ks-version: 0.9

doc: |
  TortoiseGit is a GUI frontend for git SCM. It caches some data to
  `tortoisegit.data` file in `.git` dir.

doc-ref:
  - https://gitlab.com/tortoisegit/tortoisegit/raw/master/src/TortoiseProc/gitlogcache.h
  - https://gitlab.com/tortoisegit/tortoisegit/raw/master/src/TortoiseProc/GitLogCache.cpp

seq:
  - id: signature
    -orig-id: m_Magic
    contents: [0xFF, 0x0F, 0xBB, 0x99]
  - id: version
    -orig-id: m_Version
    type: u4
    doc: current one is 0x11
  - id: items
    type: item
    repeat: eos
types:
  item:
    -orig-id: CLogCache::SaveOneItem
    seq:
      - id: signature
        -orig-id: m_Magic
        contents: [0xCC, 0x9A, 0xCC, 0x0F]
      - id: count
        -orig-id: m_FileCount
        type: u4
      - id: files
        type: file
        repeat: expr
        repeat-expr: count
    types:
      file:
        seq:
          - id: signature
            -orig-id: m_Magic
            contents: [0xFF, 0x9D, 0xEE, 0x19]
          - id: action
            -orig-id: m_Action
            type: action
          - id: stage
            -orig-id: m_Stage
            type: u4
          - id: parent_no
            -orig-id: m_ParentNo
            type: u4
          - id: added
            -orig-id: m_Add
            type: u4
          - id: deleted
            -orig-id: m_Del
            type: u4
          - id: is_submodule
            -orig-id: m_IsSubmodule
            type: u4
          - id: file_name_size
            -orig-id: m_FileNameSize
            type: u4
          - id: old_file_name_size
            -orig-id: m_OldFileNameSize
            type: u4
          - id: file_name
            -orig-id: m_FileName, name
            size: file_name_size * 2
            type: str
          - id: old_file_name
            -orig-id: oldname
            size: old_file_name_size * 2
            type: str
        types:
          action:
            meta:
              endian: be # to prevent breakage when upstream issue 155 is implemented
            doc-ref: https://gitlab.com/tortoisegit/tortoisegit/raw/master/src/Git/TGitPath.h
            seq:
              - id: merged
                type: b1
              - id: copy
                type: b1
              - id: reserved0
                type: b1
              - id: unmerged
                type: b1
              - id: deleted
                type: b1
              - id: replaced
                type: b1
              - id: modified
                type: b1
              - id: added
                type: b1

              - id: reserved1
                type: b3
              - id: missing
                type: b1
              - id: reserved2
                type: b1
              - id: skip_work_tree
                type: b1
              - id: assume_valid
                type: b1
              - id: reserved3
                type: b1

              - id: reserved4
                type: u1

              - id: unver
                type: b1
              - id: ignore
                type: b1
              - id: hide
                type: b1
              - id: gray
                type: b1
              - id: reserved5
                type: b4
