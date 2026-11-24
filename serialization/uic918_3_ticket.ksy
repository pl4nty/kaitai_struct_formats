# Imported from https://github.com/joushx/Online-Ticket-Code/blob/593f5c73991be7061d36400a184a531adfb3e2f2/definitions/ticket.ksy
meta:
  id: uic918_3_ticket
  file-extension: ticket
  license: MIT
  encoding: ISO-8859-1
seq:
  - id: header
    size: 3
    type: str
  - id: version
    size: 2
    type: str
  - id: issuer
    size: 4
    type: str
  - id: key_id
    size: 5
    type: str
  - id: signature
    size: 47
  - id: payload_size
    size: 7
    type: str
  - id: payload
    size-eos: true
    type: payload
    process: zlib
types:
  payload:
    seq:
      - id: section
        type: section
        repeat: expr
        repeat-expr: 2
    types:
      section:
        seq:
          - id: name
            size: 6
            type: str
          - id: version
            size: 2
            type: str
          - id: length
            size: 4
            type: str
          - id: data
            size: length.to_i - 12
