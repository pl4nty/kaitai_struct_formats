# Imported from https://gist.githubusercontent.com/sixdub/a5361168ba7acecf7a7a214bf7e5d3d3/raw/abd2a32d22df33f70643c450c1ddc913b4e5fd72/beacon.ksy
meta:
  id: cobalt_strike_beacon_config
  title: Cobalt Strike Beacon Config
  license: LicenseRef-All-Rights-Reserved
  endian: be
  
doc: |
  Cobalt Strike Beacon is a popular offensive security tool. Beacon itself
  is a DLL that gets injected into memory and can be staged from C2 servers.
  The Beacon DLL (in unencoded form) contains a configuration section that gets
  patched by the C2 server. This section is a fixed predictable structure
  that alters the command and control traffic and contains settings for the
  RAT. 
  
doc-ref:
  - https://www.cobaltstrike.com/help-malleable-c2
  
seq:
  - id: config
    type: config
    
types:
  config:
    seq:
      - id: entries
        type: config_entry
        repeat: until
        repeat-until: _.index== index_names::done
        
  config_entry:
    seq:
      - id: index
        type: u2
        enum: index_names
      - id: fieldtype
        type: u2
        if: index!= index_names::done
      - id: fieldlength
        type: u2
        if: index != index_names::done
      - id: fieldvalue
        size: fieldlength
        type: 
          switch-on: index
          cases:
            index_names::protocol: beacon_type
            index_names::proxy_behavior: access_type
            index_names::procinj_allocator: allocmethod_type
            _: default_field
        if: index!= index_names::done
  default_field:
    seq:
      - id: value
        type:
          switch-on: _parent.fieldtype
          cases:
            1: u2
            2: u4
            3: bytes
            
  beacon_type:
    seq: 
      - id: value
        type: u2
        enum: beacon_types
        
  access_type:
    seq:
      - id: value
        type: u2
        enum: access_types
  
  allocmethod_type:
    seq: 
      - id: value
        type: u2
        enum: allocation_types

  bytes:
    seq:
      - id: byte_val
        size-eos: true
        type:
          switch-on: _parent._parent.index
          cases:
            index_names::domains: utfstring
            index_names::spawnto: utfstring
            index_names::spawnto_x86: utfstring
            index_names::spawnto_x64: utfstring
            index_names::c2_verb_get: utfstring
            index_names::c2_verb_post: utfstring
            index_names::pipename: utfstring
            index_names::useragent: utfstring
            index_names::submituri: utfstring
            index_names::ssh_host: utfstring
            index_names::ssh_username: utfstring
            index_names::ssh_password: utfstring
            index_names::host_header: utfstring
            index_names::dnsresolver: utfstring
            index_names::c2_recover: transform_blocks
            index_names::c2_request: req_malleablec2
            index_names::c2_postreq: req_malleablec2
            index_names::gargle_sections: gargle_section
            index_names::procinj_transform_x86: procinj_transform
            index_names::procinj_transform_x64: procinj_transform
            _: byte_array
  utfstring:
    seq:
      - id: value
        size: _parent._parent._parent.fieldlength
        type: str
        encoding: UTF-8
  byte_array:
    seq:
      - id: bytes
        size-eos: true
  length_val_string: 
    seq:
      - id: length
        type: u4
      - id: value
        size: length
        type: str
        encoding: UTF-8
  length_val_bytes:
    seq: 
      - id: length
        type: u4
      - id: value
        size: length
        
  req_malleablec2:
    seq:
      - id: block
        type: malleable_block
        repeat: until
        repeat-until: _.statement==transform_actions::stop
  
  malleable_block:
    seq:
      - id: statement
        type: u4
        enum: transform_actions
      - id: statement_value
        type:
          switch-on: statement
          cases:
            transform_actions::uheader: length_val_string
            transform_actions::uparameter: length_val_string
            transform_actions::build: data_transform
            transform_actions::uhostheader: length_val_string
        if: statement != transform_actions::stop 
  
  data_transform:
    seq:
      - id: type_code
        type: u4
      - id: transform_statement
        type: transform_statement
        repeat: until
        repeat-until: _.action == transform_actions::termination_header or _.action==transform_actions::termination_parameter or _.action==transform_actions::termination_uriappend or _.action==transform_actions::termination_print
  
  transform_blocks:
    seq: 
      - id: transform_statement
        type: transform_statement
        repeat: until
        repeat-until: _.action == transform_actions::termination_header or _.action==transform_actions::termination_parameter or _.action==transform_actions::termination_uriappend or _.action==transform_actions::termination_print
      
  transform_statement:
    seq:
      - id: action
        type: u4
        enum: transform_actions
      - id: action_args
        type:
          switch-on: action
          cases:
            transform_actions::append: length_val_bytes
            transform_actions::prepend: length_val_bytes
            transform_actions::termination_header: length_val_string
            transform_actions::termination_parameter: length_val_string
        if: action == transform_actions::append or action == transform_actions::prepend or action == transform_actions::termination_header or action==transform_actions::termination_parameter
        
  procinj_transform:
    seq:
      - id: prepend_length
        type: u4
      - id: prepend_bytes
        size: prepend_length
      - id: append_length
        type: u4
      - id: append_bytes
        size: append_length
        
  gargle_section:
    seq:
      - id: gargle_entry
        type: gargle_entry
        repeat: until
        repeat-until: _.start == 0 and _.end==0
  
  gargle_entry:
    seq:
      - id: start
        type: u4
      - id: end
        type: u4
enums:
  beacon_types:
    0: http
    1: hybrid
    2: smb
    4: tcp
    8: https
    10: bindtcp
  access_types:
    1: direct
    2: internetexplorer
    4: proxy
  allocation_types:
    0: virtualallocex
    1: ntmapviewofsection
  transform_actions:
    0: stop
    1: append
    2: prepend
    3: base64
    4: termination_print
    5: termination_parameter
    6: termination_header
    7: build
    8: netbios
    9: uparameter
    10: uheader
    11: netbiosu
    12: termination_uriappend
    13: base64url
    14: strrep
    15: mask
    16: uhostheader
  index_names:
    0: done
    1: protocol
    2: port
    3: sleeptime
    4: maxget
    5: jitter
    6: maxdns
    7: pubkey
    8: domains
    9: useragent
    10: submituri
    11: c2_recover
    12: c2_request
    13: c2_postreq
    14: spawnto
    15: pipename
    16: killdate_year
    17: killdate_month
    18: killdate_day
    19: dns_idle
    20: dns_sleep
    21: ssh_host
    22: ssh_port
    23: ssh_username
    24: ssh_password
    25: ssh_key
    26: c2_verb_get
    27: c2_verb_post
    28: c2_chunk_post
    29: spawnto_x86
    30: spawnto_x64
    31: crypto_scheme
    32: proxy_config
    33: proxy_user
    34: proxy_password
    35: proxy_behavior
    36: inject_options
    37: watermark
    38: cleanup
    39: cfg_caution
    40: killdate
    41: gargle_nook
    42: gargle_sections
    43: procinj_perms_i
    44: procinj_perms
    45: procinj_minalloc
    46: procinj_transform_x86
    47: procinj_transform_x64
    48: procinj_allowed
    49: bindhost
    50: http_no_cookies
    51: procinj_execute
    52: procinj_allocator
    53: procinj_stub
    54: host_header
    55: exit_funk
    57: smb_frameheader
    58: tcp_frameheader
    59: headerstoremove
    60: dns_beacon
    61: dns_get_a
    62: dns_get_aaaa
    63: dns_get_txt
    64: dns_put_metadata
    65: dns_put_output
    66: dnsresolver
        
