# Imported from https://github.com/tomwhite/zx81-p-file-kaitai/blob/99d3937a8fa4cffcfc2d624017397d8cce9a509a/zx81_p_file.ksy
# Licence and copyright: see _community/README.md
meta:
  id: zx81_p_file
  title: ZX81 P file
  file-extension: P
  license: CC0-1.0
  endian: le
doc: |
  P files are used by ZX81 emulators. They consist of a memory dump
  from address 16393 (inclusive) to the E_LINE address (exclusive).
  See chapters 27 and 28 of the ZX81 Basic Programming manual.
  For system variables that don't have a name (e.g. 16423, debounce),
  the name used in ZX81SysVars from the Java ZX81 Tape Converter
  (http://www.zx81stuff.org.uk/zx81/tapeutils/overview.html) is used.
doc-ref: http://otremolet.free.fr/otnet/otzx/zx81/basic-progr/
seq:
  - id: system_variables
    type: system_variables
    doc: The system variables that are saved in a P file, from address 16393 onwards.
  - id: program
    size: system_variables.d_file - 16509 # 16509 is the start of program
    type: program
  - id: display_file
    size: system_variables.vars - system_variables.d_file
  - id: variables
    size: system_variables.e_line - system_variables.vars - 1
  - id: terminator
    contents: [0x80]
types:
  system_variables:
    seq:
      - id: versn
        -orig-id: VERSN
        type: u1
      - id: e_ppc
        -orig-id: E_PPC
        type: u2
      - id: d_file
        -orig-id: D_FILE
        type: u2
      - id: df_cc
        -orig-id: DF_CC
        type: u2
      - id: vars
        -orig-id: VARS
        type: u2
      - id: dest
        -orig-id: DEST
        type: u2
      - id: e_line
        -orig-id: E_LINE
        type: u2
      - id: ch_add
        -orig-id: CH_ADD
        type: u2
      - id: x_ptr
        -orig-id: X_PTR
        type: u2
      - id: stkbot
        -orig-id: STKBOT
        type: u2
      - id: stkend
        -orig-id: STKEND
        type: u2
      - id: berg
        -orig-id: BERG
        type: u1
      - id: mem
        -orig-id: MEM
        type: u2
      - id: un1
        type: u1
      - id: df_sz
        -orig-id: DF_SZ
        type: u1
      - id: s_top
        -orig-id: S_TOP
        type: u2
      - id: last_k
        -orig-id: LAST_K
        type: u2
      - id: deboun
        type: u1
      - id: margin
        -orig-id: MARGIN
        type: u1
      - id: nxtlin
        -orig-id: NXTLIN
        type: u2
      - id: oldppc
        -orig-id: OLDPPC
        type: u2
      - id: flagx
        -orig-id: FLAGX
        type: u1
      - id: strlen
        -orig-id: STRLEN
        type: u2
      - id: t_addr
        -orig-id: T_ADDR
        type: u2
      - id: seed
        -orig-id: SEED
        type: u2
      - id: frames
        -orig-id: FRAMES
        type: u2
      - id: coords
        -orig-id: COORDS
        type: u1
      - id: coordy
        type: u1
      - id: pr_cc
        -orig-id: PR_CC
        type: u1
      - id: s_posn
        -orig-id: S_POSN
        type: u1
      - id: s_posl
        type: u1
      - id: cdflag
        -orig-id: CDFLAG
        type: u1
      - id: prbuff
        -orig-id: PRBUFF
        size: 33
      - id: membot
        -orig-id: MEMBOT
        size: 30
      - id: un2
        type: u2
  program:
    seq:
      - id: program_lines
        type: program_line
        repeat: eos
  program_line:
    seq:
      - id: line_number
        type: u2be # line numbers are big endian, unlike most other two-byte integers
      - id: line_length
        type: u2
      - id: line
        size: line_length
