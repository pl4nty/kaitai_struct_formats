# Imported from https://gist.githubusercontent.com/generalmimon/0f202457ebe8f1556293d611a949c358/raw/8418b6d1da65bd49ca136f6252d9ab36dc032400/deflate_stream.ksy
meta:
  id: deflate_stream
  title: DEFLATE compressed data stream
  xref:
    rfc: 1951
  license: MIT
  bit-endian: le
doc-ref: https://github.com/golang/go/blob/f90e89e/src/compress/flate/inflate.go#L301
seq:
  - id: hdr
    type: header
types:
  header:
    seq:
      - id: final
        type: b1
      - id: type
        type: b2
        valid: 2
        doc: only dynamic Huffman codes are implemented
      - id: num_lit_m_257
        type: b5
      - id: num_dist_m_1
        type: b5
      - id: num_clen_m_4
        type: b4
      - id: code_lengths
        type: b3
        repeat: expr
        repeat-expr: num_clen
      - id: codebits
        type: codebit(_index)
        repeat: expr
        repeat-expr: code_order.size
      - id: next_codes
        type: 'next_code(_index, _index > 0 ? next_codes[_index - 1].code : 0)'
        repeat: expr
        repeat-expr: codebits.last.max + 1
      - id: values
        type: 'value(_index, codebits[_index].val)'
        repeat: expr
        repeat-expr: code_order.size
        
    instances:
      code_order:
        value: '[16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15]'
        doc-ref: RFC 1951 section 3.2.7.
      code_order_rev:
        value: '[3, 17, 15, 13, 11, 9, 7, 5, 4, 6, 8, 10, 12, 14, 16, 18, 0, 1, 2]'
        doc: |
          ```javascript
          var code_order_rev = []
          code_order.forEach((v, i) => { code_order_rev[v] = i; })
          ```
      num_lit:
        value: num_lit_m_257 + 257
      num_dist:
        value: num_dist_m_1 + 1
      num_clen:
        value: num_clen_m_4 + 4
    types:
      codebit:
        -webide-representation: "{val:dec}"
        params:
          - id: idx
            type: s4
        instances:
          code_idx:
            value: _parent.code_order_rev[idx]
          val:
            value: 'code_idx < _parent.num_clen ? _parent.code_lengths[code_idx] : 0'
          prev:
            value: _parent.codebits[idx - 1]
            if: 'idx > 0'
          prev_max:
            value: 'idx > 0 ? prev.max.as<s4> : 0'
          max:
            value: '(val != 0 and val > prev_max) ? val : prev_max'
          prc:
            value: 'idx > 0 ? prev.count.as<s4[]> : [0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0].as<s4[]>'
          count:
            value: |
              [
                0,
                prc[1] + (val == 1).to_i,
                prc[2] + (val == 2).to_i,
                prc[3] + (val == 3).to_i,
                prc[4] + (val == 4).to_i,
                prc[5] + (val == 5).to_i,
                prc[6] + (val == 6).to_i,
                prc[7] + (val == 7).to_i,
                prc[8] + (val == 8).to_i,
                prc[9] + (val == 9).to_i,
                prc[10] + (val == 10).to_i,
                prc[11] + (val == 11).to_i,
                prc[12] + (val == 12).to_i,
                prc[13] + (val == 13).to_i,
                prc[14] + (val == 14).to_i,
                prc[15] + (val == 15).to_i,
              ]
      next_code:
        -webide-representation: "{code:dec}"
        params:
          - id: bits
            type: s4
          - id: prev_code
            type: s4
        instances:
          code:
            value: '(prev_code + _parent.codebits.last.count[bits - 1]) << 1'
      value:
        params:
          - id: i
            type: s4
          - id: 'n'
            type: b3
