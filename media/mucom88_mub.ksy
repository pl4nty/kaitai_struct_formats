# Imported from https://gist.githubusercontent.com/murachue/f47cd3913944d534deb2ea218c78bc3a/raw/7b8c84359876741896eeca53efbe893e8b61e254/mub.ksy
meta:
  id: mucom88_mub
  title: openmucom88 binary format (supports only one song)
  file-extension: mub
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc-ref: https://github.com/onitama/mucom88/blob/99d0dad6d3234848876739b5775149ff0af3a782/src/cmucom.h#L118
seq:
  - id: magic
    contents: "MUC8"
  - id: dataoff
    type: u4
  - id: datasize
    type: u4
  - id: tagoff
    type: u4
  - id: tagsize
    type: u4
  - id: pcmoff
    type: u4
  - id: pcmsize
    type: u4
  - id: jumpcount
    type: u4
instances:
  data:
    pos: dataoff
    size: datasize
    type: mucomdata
    -webide-parse-mode: eager
  tags:
    pos: tagoff
    size: tagsize
    type: tags
    -webide-parse-mode: eager
  pcm:
    pos: pcmoff
    size: pcmsize
    type: pcm
    if: pcmsize > 0
    -webide-parse-mode: eager
types:
  mucomdata:
    doc-ref: >-
      https://github.com/onitama/mucom88/blob/99d0dad6d3234848876739b5775149ff0af3a782/pc8801src/ver1.0/music2.asm
      FMSUB1
    seq:
      - id: musnum # current music number
        type: u1
      - id: otodatoff # voices offset from start+1
        type: u2
      - id: ssgdatoff # unused, offset from start+1
        type: u2
      - id: timerb # some encoded value
        type: u1
      - id: fmtracks1
        type: fmtrackptr
        repeat: expr
        repeat-expr: 3
      - id: ssgtracks
        type: ssgtrackptr
        repeat: expr
        repeat-expr: 3
      - id: drumtrack
        type: drumtrackptr
      - id: fmtracks2
        type: fmtrackptr
        repeat: expr
        repeat-expr: 4
      - id: nextoff # offset from start+5, usually pointing otodat-1 (only one song)
        type: u2
    instances:
      otodat:
        pos: otodatoff # +1 really, but -1 for otodat.num
        type: otodat
        -webide-parse-mode: eager
    types:
      # TODO: merge fmtrackptr and ssgtrackptr, differs only in *trackitem.arg.type. but how?
      fmtrackptr:
        -webide-representation: '{addr}/{top}'
        seq:
          - id: addr
            type: u2
          - id: top
            type: u2
        instances:
          onetimeitems:
            pos: 5 + addr
            type: fmtrackitem
            repeat: until
            repeat-until: _.data1 == 0
            if: top == 0
            -webide-parse-mode: eager
          introitems:
            pos: 5 + addr
            size: top - addr
            type: fmtrackitemintro
            if: top != 0 and top != addr
            -webide-parse-mode: eager
          loopitems:
            pos: 5 + top
            type: fmtrackitem
            repeat: until
            repeat-until: _.data1 == 0
            if: top != 0
            -webide-parse-mode: eager
      fmtrackitemintro:
        seq:
          - id: items
            type: fmtrackitem
            repeat: eos
      fmtrackitem:
        seq:
          - id: data1 # length/cmd
            type: u1
          - id: note
            type: u1
            if: data1 > 0 and data1 < 0x80
          - id: arg
            type:
              switch-on: data1
              cases:
                0xF0: u1 # voice
                0xF1: u1 # vol
                0xF2: detune
                0xF3: u1 # q
                0xF4: swlfo
                0xF5: u2 # rptstart_off to rptend+1 from this command
                0xF6: rptend
                0xF7: fmmode # FMmodeset noargs?
                0xF8: u1 # stereo
                0xF9: u1 # flagset
                0xFA: addrbyte # regwrite
                0xFB: s1 # volupdown
                0xFC: hwlfo
                #0xFD: can't use (TIE)
                0xFE: u2 # rptskip_off to rptend.nowcount from start of this arg
                0xFF: secprc # second procedure
            if: data1 >= 0xF0
        instances:
          wait:
            value: data1 & 0x7F
            if: data1 < 0xF0
          isnote:
            value: data1 < 0x80
          isrest:
            value: data1 >= 0x80 and data1 < 0xF0
          cmd:
            value: data1
            if: data1 >= 0xF0
        -webide-representation: '{data1} {cmd} {note} {arg}'
      drumtrackptr:
        -webide-representation: '{addr}/{top}'
        seq:
          - id: addr
            type: u2
          - id: top
            type: u2
        instances:
          onetimeitems:
            pos: 5 + addr
            type: drumtrackitem
            repeat: until
            repeat-until: _.data1 == 0
            if: top == 0
            -webide-parse-mode: eager
          introitems:
            pos: 5 + addr
            size: top - addr
            type: drumtrackitemintro
            if: top != 0 and top != addr
            -webide-parse-mode: eager
          loopitems:
            pos: 5 + top
            type: drumtrackitem
            repeat: until
            repeat-until: _.data1 == 0
            if: top != 0
            -webide-parse-mode: eager
      drumtrackitemintro:
        seq:
          - id: items
            type: drumtrackitem
            repeat: eos
      drumtrackitem:
        seq:
          - id: data1 # length/cmd
            type: u1
          - id: note
            type: u1
            if: data1 > 0 and data1 < 0x80
          - id: arg
            type:
              switch-on: data1
              cases:
                0xF0: u1 # voice
                0xF1: drumvol # vol -- only differs this from fm
                0xF2: detune
                0xF3: u1 # q
                0xF4: swlfo
                0xF5: u2 # rptstart_off to rptend+1 from this command
                0xF6: rptend
                0xF7: fmmode
                0xF8: u1 # stereo
                0xF9: u1 # flagset
                0xFA: addrbyte # regwrite
                0xFB: s1 # volupdown
                0xFC: hwlfo
                #0xFD: can't use (TIE)
                0xFE: u2 # rptskip_off to rptend.nowcount from start of this arg
                0xFF: secprc # second procedure
            if: data1 >= 0xF0
        instances:
          wait:
            value: data1 & 0x7F
            if: data1 < 0xF0
          isnote:
            value: data1 < 0x80
          isrest:
            value: data1 >= 0x80 and data1 < 0xF0
          cmd:
            value: data1
            if: data1 >= 0xF0
        -webide-representation: '{data1} {cmd} {note} {arg}'
      ssgtrackptr:
        -webide-representation: '{addr}/{top}'
        seq:
          - id: addr
            type: u2
          - id: top
            type: u2
        instances:
          onetimeitems:
            pos: 5 + addr
            type: ssgtrackitem
            repeat: until
            repeat-until: _.data1 == 0
            if: top == 0
            -webide-parse-mode: eager
          introitems:
            pos: 5 + addr
            size: top - addr
            type: ssgtrackitemintro
            if: top != 0 and top != addr
            -webide-parse-mode: eager
          loopitems:
            pos: 5 + top
            type: ssgtrackitem
            repeat: until
            repeat-until: _.data1 == 0
            if: top != 0
            -webide-parse-mode: eager
      ssgtrackitemintro:
        seq:
          - id: items
            type: ssgtrackitem
            repeat: eos
      ssgtrackitem:
        seq:
          - id: data1 # length/cmd
            type: u1
          - id: note
            type: u1
            if: data1 > 0 and data1 < 0x80
          - id: arg
            type:
              switch-on: data1
              cases:
                0xF0: u1 # voice
                0xF1: u1 # vol
                0xF2: detune
                0xF3: u1 # q
                0xF4: swlfo
                0xF5: u2 # rptstart_off to rptend+1 from this command
                0xF6: rptend
                0xF7: u1 # mixportctl
                0xF8: u1 # noiseperiod
                0xF9: u1 # flagset
                0xFA: envparamset
                0xFB: s1 # volupdown
                0xFC: hwlfo
                #0xFD: can't use (TIE)
                0xFE: u2 # rptskip_off to rptend.nowcount from start of this arg
                0xFF: secprc # second procedure
            if: data1 >= 0xF0
        instances:
          wait:
            value: data1 & 0x7F
            if: data1 < 0xF0
          isnote:
            value: data1 < 0x80
          isrest:
            value: data1 >= 0x80 and data1 < 0xF0
          cmd:
            value: data1
            if: data1 >= 0xF0
        -webide-representation: '{data1} {cmd} {note} {arg}'
      detune:
        seq:
          - id: dataoff
            type: u2
          - id: isdelta
            type: u1
      swlfo:
        seq:
          - id: subcmd
            type: u1
          - id: arg
            type:
              switch-on: subcmd
              cases:
                0x00: swlfoall # setdelay+setctr+setvct+setPeaklevel
                #0x01 # lfo-off
                #0x02 # lfo-on
                0x03: u1 # setdelay
                0x04: u1 # setctr
                0x05: u2 # setvct
                0x06: u1 # setpeaklevel
                0x07: u1 # tllfo
      swlfoall:
        seq:
          - id: delay
            type: u1
          - id: counter
            type: u1
          - id: vct # velocity? Henkaryo
            type: u2
          - id: peaklevel
            type: u1
      rptend:
        seq:
          - id: nowcount
            type: u1
          - id: orgcount
            type: u1
          - id: rewbytes # rewind bytes from here (rewinding jump offset from start of this rewbytes)
            type: u2
      fmmode:
        seq:
          - id: detdat # op1-4
            type: u1
            repeat: expr
            repeat-expr: 4
      addrbyte:
        seq:
          - id: addr
            type: u1
          - id: byte
            type: u1
        -webide-representation: '{addr}={byte}'
      hwlfo:
        seq:
          - id: freqcont
            type: u1
          - id: pms
            type: u1
          - id: ams
            type: u1
      envparamset:
        seq:
          - id: initlevel
            type: u1
          - id: ar
            type: u1
          - id: dr
            type: u1
          - id: sr
            type: u1
          - id: sl
            type: u1
          - id: rr
            type: u1
      drumvol:
        seq:
          - id: tl
            type: u1
          - id: vols # bd,sd,top,hh,tom,rym
            type: u1
            repeat: expr
            repeat-expr: 6
      secprc:
        seq:
          - id: cmd2
            type: u1
          - id: data
            type:
              switch-on: cmd2 & 0x0F
              cases:
                0x00: u1 # pcm volmode
                0x01: u1 # hwenv
                0x02: hwenvperiod
                0x03: u1 # reverb
                0x04: u1 # reverb mode
                0x05: u1 # reverb sw
      hwenvperiod:
        seq:
          - id: b
            type: u1
          - id: c
            type: u1
      otodat:
        seq:
          - id: num # not examined but seems...
            type: u1
          - id: entries
            type: otodatentry
            repeat: expr
            repeat-expr: num
        types:
          otodatentry:
            seq:
              - id: dt_multi
                type: u1
                repeat: expr
                repeat-expr: 4
              - id: tl
                type: u1
                repeat: expr
                repeat-expr: 4
              - id: ks_ar
                type: u1
                repeat: expr
                repeat-expr: 4
              - id: dr
                type: u1
                repeat: expr
                repeat-expr: 4
              - id: sr
                type: u1
                repeat: expr
                repeat-expr: 4
              - id: sl_rr
                type: u1
                repeat: expr
                repeat-expr: 4
              - id: fb_alg
                type: u1
            instances:
              fb: { value: (fb_alg >> 3) & 7, -webide-parse-mode: eager }
              alg: { value: fb_alg & 7, -webide-parse-mode: eager }
              # TODO: instantiate dt|multi etc. but how to converting array?
  tags:
    seq:
      - id: tagstr
        type: strz
        encoding: UTF-8
        #size-eos: true
  pcm:
    seq:
      - id: data
        type: pcmdata
    types:
      pcmdata:
        seq:
          - id: entries
            type: pcmentry
            repeat: expr
            repeat-expr: 32
        types:
          pcmentry:
            seq:
              - id: name
                size: 16
                type: strz
                encoding: ASCII
              - id: unk
                size: 12
              - id: offw # in 4bytes
                type: u2
              - id: size # in bytes
                type: u2
            instances:
              # TODO: want to use this "off" at data.pos and webrepr, but how?
              off:
                value: 0x400 + offw * 4
                -webide-parse-mode: eager
              data:
                # TODO: want offset from this "pcm", but how?
                io: _root._io
                pos: _root.pcmoff + (0x400 + offw * 4)
                size: 0 #size
                if: size > 0
                -webide-parse-mode: eager
            -webide-representation: '{name}@{offw}+{size}'
