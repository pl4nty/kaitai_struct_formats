# Imported from https://gist.githubusercontent.com/u1735067/7025b4eac8d417e2d5461ae3a4e3ce78/raw/6edbf3882c4d4eed8c74315fdfb0fa369b21a5cf/radius.ksy
meta:
  id: radius
  title: RADIUS packet
  file-extension: radius
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc-ref:
  - "https://www.iana.org/assignments/radius-types/radius-types.xhtml"
  - "https://tools.ietf.org/html/rfc2865"
  - "https://wiki.wireshark.org/SampleCaptures#RADIUS_.28RFC_2865.29"
seq:
  - id: code
    type: u1
    enum: pkt_types
  - id: identifier
    type: u1
  - id: pkt_length
    type: u2
  - id: authenticator
    size: 16
  - id: attributes
    type: attributes_section
    repeat: eos
types:
  attributes_section:
    meta:
      encoding: ASCII
    seq:
      - id: attribute_type
        type: u1
        enum: attributes_types
      - id: attribute_length
        type: u1
      - id: attribute_value
        size: attribute_length-2
        type:
          switch-on: attribute_type
          cases:
            'attributes_types::acct_session_id': str
enums:
  pkt_types:
    1: access_request
    2: access_accept
    3: access_reject
    4: accounting_request
    5: accounting_response
    6: accounting_status # (now interim accounting)
    7: password_request
    8: password_ack
    9: password_reject
    10: accounting_message
    11: access_challenge
    12: status_server # (experimental)
    13: status_client # (experimental)
    21: resource_free_request
    22: resource_free_response
    23: resource_query_request
    24: resource_query_response
    25: alternate_resource_reclaim_request
    26: nas_reboot_request
    27: nas_reboot_response
    28: reserved
    29: next_passcode
    30: new_pin
    31: terminate_session
    32: password_expired
    33: event_request
    34: event_response
    #35_39: unassigned
    40: disconnect_request
    41: disconnect_ack
    42: disconnect_nak
    43: coa_request
    44: coa_ack
    45: coa_nak
    #46_49: unassigned
    50: ip_address_allocate
    51: ip_address_release
    52: protocol_error
    #53_249: unassigned
    #250_253: experimental use
    254: reserved_254
    255: reserved_255
  attributes_types:
    1: user_name
    2: user_password
    3: chap_password
    4: nas_ip_address
    5: nas_port
    6: service_type
    7: framed_protocol
    8: framed_ip_address
    9: framed_ip_netmask
    10: framed_routing
    11: filter_id
    12: framed_mtu
    13: framed_compression
    14: login_ip_host
    15: login_service
    16: login_tcp_port
    17: unassigned
    18: reply_message
    19: callback_number
    20: callback_id
    21: unassigned_21
    22: framed_route
    23: framed_ipx_network
    24: state
    25: class
    26: vendor_specific
    27: session_timeout
    28: idle_timeout
    29: termination_action
    30: called_station_id
    31: calling_station_id
    32: nas_identifier
    33: proxy_state
    34: login_lat_service
    35: login_lat_node
    36: login_lat_group
    37: framed_appletalk_link
    38: framed_appletalk_network
    39: framed_appletalk_zone
    40: acct_status_type
    41: acct_delay_time
    42: acct_input_octets
    43: acct_output_octets
    44: acct_session_id
    45: acct_authentic
    46: acct_session_time
    47: acct_input_packets
    48: acct_output_packets
    49: acct_terminate_cause
    50: acct_multi_session_id
    51: acct_link_count
    52: acct_input_gigawords
    53: acct_output_gigawords
    54: unassigned_54
    55: event_timestamp
    56: egress_vlanid
    57: ingress_filters
    58: egress_vlan_name
    59: user_priority_table
    60: chap_challenge
    61: nas_port_type
    62: port_limit
    63: login_lat_port
    64: tunnel_type
    65: tunnel_medium_type
    66: tunnel_client_endpoint
    67: tunnel_server_endpoint
    68: acct_tunnel_connection
    69: tunnel_password
    70: arap_password
    71: arap_features
    72: arap_zone_access
    73: arap_security
    74: arap_security_data
    75: password_retry
    76: prompt
    77: connect_info
    78: configuration_token
    79: eap_message
    80: message_authenticator
    81: tunnel_private_group_id
    82: tunnel_assignment_id
    83: tunnel_preference
    84: arap_challenge_response
    85: acct_interim_interval
    86: acct_tunnel_packets_lost
    87: nas_port_id
    88: framed_pool
    89: cui
    90: tunnel_client_auth_id
    91: tunnel_server_auth_id
    92: nas_filter_rule
    93: unassigned_93
    94: originating_line_info
    95: nas_ipv6_address
    96: framed_interface_id
    97: framed_ipv6_prefix
    98: login_ipv6_host
    99: framed_ipv6_route
    100: framed_ipv6_pool
    101: error_cause # attribute
    102: eap_key_name
    103: digest_response
    104: digest_realm
    105: digest_nonce
    106: digest_response_auth
    107: digest_nextnonce
    108: digest_method
    109: digest_uri
    110: digest_qop
    111: digest_algorithm
    112: digest_entity_body_hash
    113: digest_cnonce
    114: digest_nonce_count
    115: digest_username
    116: digest_opaque
    117: digest_auth_param
    118: digest_aka_auts
    119: digest_domain
    120: digest_stale
    121: digest_ha1
    122: sip_aor
    123: delegated_ipv6_prefix
    124: mip6_feature_vector
    125: mip6_home_link_prefix
    126: operator_name
    127: location_information
    128: location_data
    129: basic_location_policy_rules
    130: extended_location_policy_rules
    131: location_capable
    132: requested_location_info
    133: framed_management_protocol
    134: management_transport_protection
    135: management_policy_id
    136: management_privilege_level
    137: pkm_ss_cert
    138: pkm_ca_cert
    139: pkm_config_settings
    140: pkm_cryptosuite_list
    141: pkm_said
    142: pkm_sa_descriptor
    143: pkm_auth_key
    144: ds_lite_tunnel_name
    145: mobile_node_identifier
    146: service_selection
    147: pmip6_home_lma_ipv6_address
    148: pmip6_visited_lma_ipv6_address
    149: pmip6_home_lma_ipv4_address
    150: pmip6_visited_lma_ipv4_address
    151: pmip6_home_hn_prefix
    152: pmip6_visited_hn_prefix
    153: pmip6_home_interface_id
    154: pmip6_visited_interface_id
    155: pmip6_home_ipv4_hoa
    156: pmip6_visited_ipv4_hoa
    157: pmip6_home_dhcp4_server_address
    158: pmip6_visited_dhcp4_server_address
    159: pmip6_home_dhcp6_server_address
    160: pmip6_visited_dhcp6_server_address
    161: pmip6_home_ipv4_gateway
    162: pmip6_visited_ipv4_gateway
    163: eap_lower_layer
    164: gss_acceptor_service_name
    165: gss_acceptor_host_name
    166: gss_acceptor_service_specifics
    167: gss_acceptor_realm_name
    168: framed_ipv6_address
    169: dns_server_ipv6_address
    170: route_ipv6_information
    171: delegated_ipv6_prefix_pool
    172: stateful_ipv6_address_pool
    173: ipv6_6rd_configuration
    174: allowed_called_station_id
    175: eap_peer_id
    176: eap_server_id
    177: mobility_domain_id
    178: preauth_timeout
    179: network_id_name
    180: eapol_announcement
    181: wlan_hessid
    182: wlan_venue_info
    183: wlan_venue_language
    184: wlan_venue_name
    185: wlan_reason_code
    186: wlan_pairwise_cipher
    187: wlan_group_cipher
    188: wlan_akm_suite
    189: wlan_group_mgmt_cipher
    190: wlan_rf_band
    191: unassigned_191
