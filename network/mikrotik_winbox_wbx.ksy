# Imported from https://gist.githubusercontent.com/jabb3rd/a66ba26dc34ebbc6fb285452ce57f52e/raw/0e52c07fca1cfee4e59b818c2af68de3746a0a6b/wbx.ksy
meta:
  id: mikrotik_winbox_wbx
  title: MikroTik Winbox saved sessions (.wbx)
  file-extension: wbx
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: magic
    contents: [0x0f, 0x10, 0xc0, 0xbe]
  - id: records
    type: record
    repeat: eos
types:
  record:
    seq:
      - id: record_size
        type: u2
      - id: name_size
        type: u1
        if: record_size != 0
      - id: name
        size: name_size
        type: str
        encoding: windows-1251
        if: record_size != 0
      - id: data
        size: record_size - name_size - 1
        if: record_size > 0
