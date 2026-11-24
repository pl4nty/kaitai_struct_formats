meta:
  id: awdl_action_frame
  title: Apple Wireless Direct Link (AWDL) action frame
  application:
    - AirDrop
    - AirPlay
    - Apple IO80211Family
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Apple Wireless Direct Link (AWDL) is the proprietary peer-to-peer Wi-Fi
  protocol used by Apple devices for AirDrop, AirPlay and similar
  services. Nodes synchronize on short availability windows, elect a
  master and announce their channel sequence and services with IEEE
  802.11 vendor-specific action frames (category 127, Apple OUI
  00:17:f2); user data is carried in separate data frames with an
  LLC/SNAP header (not covered here).

  This spec describes the vendor-specific content of an AWDL action
  frame, starting right after the category and OUI bytes (as handed to
  the vendor-specific dissector in Wireshark): a 12-byte fixed header
  followed by TLVs with a 1-byte type and a 2-byte little-endian length.
  Two subtypes exist, the Periodic Synchronization Frame (PSF) and the
  Master Indication Frame (MIF); they differ only in the TLVs included.
  A trailing 802.11 FCS, if captured, is not part of this structure.

  The protocol is undocumented; fields follow the reverse-engineered
  Wireshark dissector and the paper by Stute, Kreitschmann and Hollick.
  Several fields are of unknown meaning.
doc-ref:
  - https://gitlab.com/wireshark/wireshark/-/blob/eab724ffbb8c25caf9a2812fa5b8b24223f787f5/epan/dissectors/packet-awdl.c
  - https://arxiv.org/abs/1808.03156
seq:
  - id: awdl_type
    contents: [0x08]
    doc: AWDL type, always 8.
  - id: version
    type: version
  - id: subtype
    type: u1
    enum: subtype
  - id: reserved
    type: u1
  - id: phy_tx_time
    type: u4
    doc: |
      Time in microseconds shortly before the frame was sent out by the
      radio.
  - id: target_tx_time
    type: u4
    doc: |
      Time in microseconds when the frame was created; the difference to
      phy_tx_time approximates the sender's transmission delay.
  - id: tlvs
    type: tlv
    repeat: eos
types:
  version:
    seq:
      - id: major
        type: b4
      - id: minor
        type: b4
  tlv:
    seq:
      - id: tag
        type: u1
        enum: tlv_type
      - id: len_value
        type: u2
      - id: value
        size: len_value
        type:
          switch-on: tag
          cases:
            'tlv_type::service_response': service_response
            'tlv_type::synchronization_parameters': synchronization_parameters
            'tlv_type::election_parameters': election_parameters
            'tlv_type::service_parameters': service_parameters
            'tlv_type::ht_capabilities': ht_capabilities
            'tlv_type::data_path_state': data_path_state
            'tlv_type::arpa': arpa
            'tlv_type::ieee80211_container': ieee80211_container
            'tlv_type::channel_sequence': channel_sequence_tlv
            'tlv_type::synchronization_tree': synchronization_tree
            'tlv_type::version': version_tlv
            'tlv_type::election_parameters_v2': election_parameters_v2
  service_response:
    doc: |
      An mDNS resource record (PTR, SRV or TXT) announced by the node, with
      names in AWDL's compressed DNS name encoding.
    seq:
      - id: len_name
        type: u2
        doc: Length of the name plus the following type byte.
      - id: name
        size: len_name - 1
        type: dns_name
      - id: rr_type
        type: u1
        enum: dns_type
      - id: len_data
        type: u2
      - id: unknown
        type: u2
      - id: data
        size: len_data
        type:
          switch-on: rr_type
          cases:
            'dns_type::ptr': dns_name
            'dns_type::txt': txt_data
            'dns_type::srv': srv_data
  txt_data:
    seq:
      - id: entries
        type: length_prefixed_string
        repeat: eos
  srv_data:
    seq:
      - id: priority
        type: u2be
      - id: weight
        type: u2be
      - id: port
        type: u2be
      - id: target
        size-eos: true
        type: dns_name
  dns_name:
    doc: |
      A domain name as a sequence of labels filling the available space.
      Each label is either a length-prefixed string, or a 2-byte value
      with the top two bits set that stands for a predefined suffix.
    seq:
      - id: labels
        type: dns_label
        repeat: eos
  dns_label:
    seq:
      - id: first
        type: u1
      - id: compressed_low
        type: u1
        if: is_compressed
      - id: text
        size: first
        type: str
        encoding: UTF-8
        if: not is_compressed
    instances:
      is_compressed:
        value: first & 0xc0 != 0
      compressed:
        value: (first << 8) | compressed_low
        enum: dns_compression
        if: is_compressed
        doc: Predefined name suffix; `null` stands for no text.
  length_prefixed_string:
    seq:
      - id: len_text
        type: u1
      - id: text
        size: len_text
        type: str
        encoding: UTF-8
  synchronization_parameters:
    doc: |
      Synchronization Parameters TLV (paper figure 6). Times are in TU (1024
      microseconds).
    seq:
      - id: next_aw_channel
        type: u1
        doc: Channel of the next availability window.
      - id: tx_counter
        type: u2
        doc: Time until the next availability window starts.
      - id: master_channel
        type: u1
      - id: guard_time
        type: u1
      - id: aw_period
        type: u2
        doc: Availability window period.
      - id: action_frame_period
        type: u2
      - id: awdl_flags
        type: u2
      - id: aw_ext_length
        type: u2
        doc: Availability window extension length.
      - id: aw_common_length
        type: u2
        doc: Availability window common length.
      - id: aw_remaining
        type: u2
        doc: Remaining availability window length.
      - id: ext_min
        type: u1
        doc: Minimum extension count.
      - id: ext_max_multicast
        type: u1
      - id: ext_max_unicast
        type: u1
      - id: ext_max_action_frame
        type: u1
      - id: master_address
        size: 6
      - id: presence_mode
        type: u1
      - id: unknown
        type: u1
      - id: aw_sequence_number
        type: u2
      - id: ap_beacon_alignment
        type: u2
        doc: AP beacon alignment delta.
      - id: channel_sequence
        type: channel_sequence
  channel_sequence_tlv:
    seq:
      - id: channel_sequence
        type: channel_sequence
  channel_sequence:
    seq:
      - id: num_channels_minus_one
        type: u1
      - id: encoding
        type: u1
        enum: channel_encoding
      - id: duplicate
        type: u1
      - id: step_count_minus_one
        type: u1
      - id: fill_channel
        type: u2
        doc: 0xffff means repeat the current channel.
      - id: channels
        type: channel(encoding)
        repeat: expr
        repeat-expr: num_channels_minus_one + 1
        if: >-
          encoding == channel_encoding::channel_number
          or encoding == channel_encoding::legacy
          or encoding == channel_encoding::operating_class
  channel:
    params:
      - id: encoding
        type: u1
        enum: channel_encoding
    seq:
      - id: legacy_flags
        type: legacy_channel_flags
        if: encoding == channel_encoding::legacy
      - id: number
        type: u1
      - id: operating_class
        type: u1
        if: encoding == channel_encoding::operating_class
  legacy_channel_flags:
    seq:
      - id: unused
        type: b2
      - id: band
        type: b2
        enum: legacy_band
      - id: bandwidth
        type: b2
        enum: legacy_bandwidth
      - id: control_channel
        type: b2
        enum: legacy_control_channel
  election_parameters:
    seq:
      - id: flags
        type: u1
        doc: Non-zero when private election fields follow.
      - id: id
        type: u2
      - id: distance_to_master
        type: u1
      - id: unknown
        type: u1
      - id: master_address
        size: 6
      - id: master_metric
        type: u4
      - id: self_metric
        type: u4
      - id: private_election
        type: private_election
        if: flags != 0
  private_election:
    seq:
      - id: unknown
        size: 2
      - id: private_master_address
        size: 6
      - id: private_master_metric
        type: u4
      - id: private_id
        type: u4
      - id: phc
        type: u2
  election_parameters_v2:
    seq:
      - id: master_address
        size: 6
      - id: other_address
        size: 6
      - id: master_counter
        type: u4
      - id: distance_to_master
        type: u4
      - id: master_metric
        type: u4
      - id: self_metric
        type: u4
      - id: unknown
        type: u4
      - id: reserved
        type: u4
      - id: self_counter
        type: u4
  service_parameters:
    seq:
      - id: unknown
        size: 3
      - id: sui
        type: u2
        doc: Changing it makes receivers flush their mDNS cache.
      - id: bitmask
        type: u4
        doc: |
          Each set bit i announces one byte in `values`, in ascending bit
          order; bit k of that byte stands for the value 8 * i + k.
      - id: values
        size-eos: true
  ht_capabilities:
    doc: A subset of the IEEE 802.11 HT Capabilities element.
    seq:
      - id: unknown1
        type: u2
      - id: ht_capabilities_info
        type: u2
      - id: ampdu_parameters
        type: u1
      - id: rx_mcs_bitmask
        size: _io.size - _io.pos - 2
        doc: Rx MCS bitmask, one byte per spatial stream.
      - id: unknown2
        type: u2
  data_path_state:
    seq:
      - id: flags
        type: data_path_state_flags
      - id: country_code
        size: 3
        type: strz
        encoding: ASCII
        if: flags.has_country_code
      - id: social_channels
        type: u2
        if: flags.has_social_channels
        doc: |
          Either a bitmap of supported social channels (bit 0 = channel 6,
          bit 1 = channel 44, bit 2 = channel 149; Wireshark assumes a map
          when bit 0 is set) or a single channel number.
      - id: infra_bssid
        size: 6
        if: flags.has_infra_bssid_channel
      - id: infra_channel
        type: u2
        if: flags.has_infra_bssid_channel
      - id: infra_address
        size: 6
        if: flags.has_infra_address
      - id: awdl_address
        size: 6
        if: flags.has_awdl_address
      - id: umi
        type: u2
        if: flags.has_umi
      - id: len_unicast_options
        type: u2
        if: flags.has_unicast_options
      - id: unicast_options
        size: len_unicast_options
        if: flags.has_unicast_options
      - id: ext_flags
        type: data_path_state_ext_flags
        if: flags.has_ext_flags
      - id: logtrigger_id
        type: u2
        if: flags.has_ext_flags and ext_flags.has_logtrigger_id
      - id: rlfc
        type: u4
        if: flags.has_ext_flags and ext_flags.has_rlfc
      - id: active_time
        type: u4
        if: flags.has_ext_flags and ext_flags.dfs_proxy_support
      - id: aw_sequence_counter
        type: u4
        if: flags.has_ext_flags and ext_flags.dfs_proxy_support
      - id: update_counter
        type: u4
        if: flags.has_ext_flags and ext_flags.dfs_proxy_support
  data_path_state_flags:
    meta:
      bit-endian: le
    seq:
      - id: has_infra_bssid_channel
        type: b1
      - id: has_infra_address
        type: b1
      - id: has_awdl_address
        type: b1
      - id: rsdb_support
        type: b1
      - id: has_umi
        type: b1
      - id: dualband_support
        type: b1
      - id: airplay_sink
        type: b1
      - id: follow_channel_sequence
        type: b1
      - id: has_country_code
        type: b1
      - id: has_social_channels
        type: b1
      - id: airplay_solo_mode
        type: b1
      - id: umi_supported
        type: b1
      - id: has_unicast_options
        type: b1
      - id: real_time
        type: b1
      - id: rangeable
        type: b1
      - id: has_ext_flags
        type: b1
  data_path_state_ext_flags:
    meta:
      bit-endian: le
    seq:
      - id: has_logtrigger_id
        type: b1
      - id: ranging_discovery
        type: b1
      - id: has_rlfc
        type: b1
      - id: social_channel_map_supported
        type: b1
      - id: dynamic_sdb_support
        type: b1
      - id: misc
        type: b1
      - id: dfs_proxy_support
        type: b1
        doc: When set, active time and two counters follow.
      - id: unknown7
        type: b1
      - id: high_efficiency_support
        type: b1
      - id: sidekick_hub
        type: b1
      - id: fast_discovery_enabled
        type: b1
      - id: wifi_6e_support
        type: b1
      - id: ultra_low_latency_infra_supported
        type: b1
      - id: in_pro_mode
        type: b1
      - id: unknown14
        type: b2
  arpa:
    doc: Host name of the node, usually completed with the compressed suffix `local`.
    seq:
      - id: flags
        type: u1
      - id: host
        size-eos: true
        type: dns_name
  ieee80211_container:
    doc: An IEEE 802.11 information element, such as VHT Capabilities (191).
    seq:
      - id: element_id
        type: u1
      - id: len_element
        type: u1
      - id: element
        size: len_element
  synchronization_tree:
    seq:
      - id: addresses
        size: 6
        repeat: expr
        repeat-expr: _io.size / 6
        doc: Path of nodes from this node up to the master.
  version_tlv:
    seq:
      - id: version
        type: version
      - id: device_class
        type: u1
        enum: device_class
enums:
  subtype:
    0:
      id: psf
      doc: Periodic Synchronization Frame
    3:
      id: mif
      doc: Master Indication Frame
  tlv_type:
    0: ssth_request
    1: service_request
    2: service_response
    3: unknown_3
    4: synchronization_parameters
    5: election_parameters
    6: service_parameters
    7: ht_capabilities
    8: enhanced_data_rate_operation
    9: infra
    10: invite
    11: debug_string
    12: data_path_state
    13: encapsulated_ip
    14: datapath_debug_packet_live
    15: datapath_debug_af_live
    16: arpa
    17: ieee80211_container
    18: channel_sequence
    19: unknown_19
    20: synchronization_tree
    21: version
    22: bloom_filter
    23: nan_sync
    24: election_parameters_v2
  dns_type:
    12: ptr
    16: txt
    33: srv
  dns_compression:
    0xc000: 'null'
    0xc001: airplay_tcp_local
    0xc002: airplay_udp_local
    0xc003: airplay
    0xc004: raop_tcp_local
    0xc005: raop_udp_local
    0xc006: raop
    0xc007: airdrop_tcp_local
    0xc008: airdrop_udp_local
    0xc009: airdrop
    0xc00a: tcp_local
    0xc00b: udp_local
    0xc00c: local
    0xc00d: ip6_arpa
    0xc00e: ip4_arpa
  channel_encoding:
    0: channel_number
    1: legacy
    3: operating_class
  legacy_band:
    1: band_5_ghz
    2: band_2_4_ghz
  legacy_bandwidth:
    1: bw_20_mhz
    3: bw_40_mhz
  legacy_control_channel:
    1: lower
    2: upper
    3: primary
  device_class:
    1: macos
    2: ios
    4: watchos
    8: tvos
