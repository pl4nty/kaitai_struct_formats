meta:
  id: kerberos_pac
  title: Microsoft Kerberos PAC
  application: Active Directory KDC
  file-extension:
    - pac
    - bin
  license: MIT
  endian: le
doc: |
  The Privilege Attribute Certificate (PAC) Data Structure is used by
  authentication protocols (protocols
  that verify identities) to transport authorization information, which controls
  access to resources.
  To fetch PAC file from KDC easily, you may use samba net utility:
  sudo net ads kerberos pac save -U test_user filename=test_user.pac
doc-ref: https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-pac/c38cc307-f3e6-4ed4-8c81-dc550d96223c
seq:
  - id: pac
    -orig-id: PACTYPE
    type: pactype
    doc: |
      The PACTYPE structure is the topmost structure of the PAC and specifies the
      number of elements in
      the PAC_INFO_BUFFER array. The PACTYPE structure serves as the header for the
      complete PAC data.
types:
  pactype:
    doc: See [MS-PAC] 2.3 PACTYPE
    seq:
      - id: num_buffers
        -orig-id: cBuffers
        type: u4
        doc: Number of entries in the buffers array
      - id: version
        -orig-id: Version
        type: u4
        if: num_buffers != logon_info_magic_number
        doc: PAC version; MUST be 0x00000000
      - id: buffers
        -orig-id: Buffers
        type: pac_info_buffer
        repeat: expr
        repeat-expr: num_buffers
        if: num_buffers != logon_info_magic_number
        doc: |
          Following the PACTYPE structure is an array of PAC_INFO_BUFFER structures each
          of
          which defines the type and byte offset to a buffer of the PAC
    instances:
      logon_info_magic_number:
        value: 0x81001
        doc: |
          A magic number formed by pre-defined fields of common_type_header
          for KERB_VALIDATION_INFO structure. Used to detect partial format of the file
          See [MS-RPCE] 2.2.6.1 Common Type Header for the Serialization Stream
      direct_logon_info:
        pos: 0
        type: kerb_validation_info
        if: num_buffers == logon_info_magic_number
        doc: |
          To auto-detect file content in case of reduced data (logon_info only) we use
          version+endianness fields as the magic
  pac_info_buffer:
    doc: See [MS-PAC] 2.4 PAC_INFO_BUFFER
    seq:
      - id: ul_type
        -orig-id: ulType
        type: u4
        enum: pac_type
      - id: len_buffer
        -orig-id: cbBufferSize
        type: u4
      - id: ofs_buffer
        -orig-id: Offset
        type: u8
    instances:
      buffer:
        pos: ofs_buffer
        size: len_buffer
        type:
          switch-on: ul_type
          cases:
            'pac_type::pac_type_logon_info':   kerb_validation_info
            'pac_type::pac_type_logon_name':   pac_client_info
            'pac_type::pac_type_upn_dns_info': upn_dns_info
            'pac_type::pac_type_srv_checksum': pac_signature_data
            'pac_type::pac_type_kdc_checksum': pac_signature_data
        -webide-parse-mode: eager
    enums:
      pac_type:
        1:  pac_type_logon_info
        2:  pac_type_credentials_info
        6:  pac_type_srv_checksum
        7:  pac_type_kdc_checksum
        10: pac_type_logon_name
        11: pac_type_constrained_delegation
        12: pac_type_upn_dns_info
        13: pac_type_client_claims_info
        14: pac_type_device_info
        15: pac_type_device_claims_info
        16: pac_type_ticket_checksum
  rpc_unicode_string:
    doc: See [MS-DTYP] 2.3.10 RPC_UNICODE_STRING
    seq:
      - id: len_buffer
        -orig-id: Length
        type: u2
        doc: |
          Length of the string pointed to by the Buffer member, not including the
          terminating null character if any
      - id: max_len_buffer
        -orig-id: MaximumLength
        type: u2
        doc: Maximum size of the string pointed to by Buffer
      - id: buffer_ptr_referent
        -orig-id: Buffer
        type: u4
  unicode_string_body:
    doc: See [MS-RPCE] 4.7 UNICODE_STRING Representation
    -webide-representation: "{str_body}"
    seq:
      - id: maximum_count
        -orig-id: MaximumCount
        type: u4
      - id: offset
        -orig-id: Offset
        type: u4
      - id: actual_count
        -orig-id: ActualCount
        type: u4
      - id: str_body
        size: actual_count * 2
        type: str
        encoding: UTF-16LE
      - id: str_padding
        type: u2
        if: actual_count & 1 != 0
  rpc_sid:
    doc: See [MS-DTYP] 2.4.2.3 RPC_SID
    -webide-representation: "S-{revision:dec}-{identifier_authority:dec}-"
    seq:
      - id: revision
        -orig-id: Revision
        type: u1
      - id: num_sub_authorities
        -orig-id: RpcSubAuthorityCount
        type: u1
      - id: identifier_authority
        -orig-id: IdentifierAuthority
        type: b48be
        doc: 48-bit big-endian value (6 bytes, most significant first)
      - id: sub_authority
        -orig-id: SubAuthority
        type: u4
        repeat: expr
        repeat-expr: num_sub_authorities
  sid:
    -webide-representation: "{sid_body}"
    seq:
      - id: sub_authority_count
        -orig-id: SubAuthorityCount
        type: u4
      - id: sid_body
        -orig-id: SidBody
        type: rpc_sid
  attributes_type:
    seq:
      - id: attributes
        -orig-id: Attributes
        type: u4
    instances:
      se_group_resource:
        value: (attributes & 0x20000000) != 0
      se_group_owner:
        value: (attributes & 0x8) != 0
      se_group_enabled:
        value: (attributes & 0x4) != 0
      se_group_enabled_by_default:
        value: (attributes & 0x2) != 0
      se_group_mandatory:
        value: (attributes & 0x1) != 0
  group_membership:
    doc: See [MS-PAC] 2.2.2 GROUP_MEMBERSHIP
    seq:
      - id: relative_id
        -orig-id: RelativeId
        type: u4
      - id: attributes
        -orig-id: Attributes
        type: attributes_type
  rpc_group_membership:
    seq:
      - id: num_group_ids
        -orig-id: GroupIdsCount
        type: u4
      - id: group_ids
        -orig-id: GroupIds
        type: group_membership
        repeat: expr
        repeat-expr: num_group_ids
  kerb_sid_and_attributes:
    doc: See [MS-PAC] 2.2.1 KERB_SID_AND_ATTRIBUTES
    seq:
      - id: sid_referent
        -orig-id: SidReferent
        type: u4
      - id: attributes
        -orig-id: Attributes
        type: attributes_type
  rpc_extra_sids:
    seq:
      - id: num_extra_sids
        -orig-id: ExtraSidsCount
        type: u4
      - id: extra_sids_attributes
        -orig-id: ExtraSidsAttributes
        type: kerb_sid_and_attributes
        repeat: expr
        repeat-expr: num_extra_sids
      - id: extra_sids
        -orig-id: ExtraSids
        type: sid
        repeat: expr
        repeat-expr: num_extra_sids
  rpc_resource_group_ids:
    seq:
      - id: num_resource_group_ids
        -orig-id: ResourceGroupIdsCount
        type: u4
      - id: resource_group_ids
        -orig-id: ResourceGroupIds
        type: group_membership
        repeat: expr
        repeat-expr: num_resource_group_ids
  common_type_header:
    doc: See [MS-RPCE] 2.2.6.1 Common Type Header for the Serialization Stream
    doc-ref: "https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-rpce/6d75d40e-e2d2-4420-b9e9-8508a726a9ae"
    seq:
      - id: version
        -orig-id: Version
        type: u1
      - id: endianness
        -orig-id: Endianness
        type: u1
        enum: endianness
      - id: common_header_length
        -orig-id: CommonHeaderLength
        type: u2
      - id: common_header_filler
        -orig-id: Filler
        type: u4
    enums:
      endianness:
        0:    big_endian
        0x10: little_endian
  private_type_header:
    doc: See [MS-RPCE] 2.2.6.2 Private Header for Constructed Type
    doc-ref: "https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-rpce/63949ba8-bc88-4c0c-9377-23f14b197827"
    seq:
      - id: object_buffer_length
        -orig-id: ObjectBufferLength
        type: u4
      - id: private_header_filler
        -orig-id: Filler
        type: u4
  filetime:
    doc: See [MS-DTYP] 2.3.3 FILETIME
    -webide-representation: "low_date_time={low_date_time}, high_date_time={high_date_time}"
    seq:
      - id: low_date_time
        -orig-id: dwLowDateTime
        type: u4
      - id: high_date_time
        -orig-id: dwHighDateTime
        type: u4
  kerb_validation_info:
    doc: See [MS-PAC] 2.5 KERB_VALIDATION_INFO
    seq:
      - id: common_header
        type: common_type_header
      - id: private_header
        type: private_type_header
      - id: kerb_validation_info_referent
        -orig-id: KerbValidationInfoReferent
        type: u4
      - id: logon_time
        -orig-id: LogonTime
        type: filetime
        doc: User account's lastLogon attribute ([MS-ADA1] section 2.351) value
      - id: logoff_time
        -orig-id: LogoffTime
        type: filetime
        doc: Time the client's logon session is set to expire.
      - id: kickoff_time
        -orig-id: KickOffTime
        type: filetime
        doc: |
          LogoffTime minus the user account's forceLogoff attribute ([MS-ADA1]
          section 2.233) value
      - id: password_last_set
        -orig-id: PasswordLastSet
        type: filetime
        doc: |
          User account's pwdLastSet attribute ([MS-ADA3] section 2.175)
          value.
      - id: password_can_change
        -orig-id: PasswordCanChange
        type: filetime
        doc: Time at which the client's password is allowed to change.
      - id: password_must_change
        -orig-id: PasswordMustChange
        type: filetime
        doc: Time at which the client's password expires.
      - id: effective_name
        -orig-id: EffectiveName
        type: rpc_unicode_string
        doc: |
          User account's samAccountName attribute ([MS-ADA3] section 2.222)
          value.
      - id: full_name
        -orig-id: FullName
        type: rpc_unicode_string
        doc: |
          User account's full name for interactive logon and is set to zero for
          network logon.
      - id: logon_script
        -orig-id: LogonScript
        type: rpc_unicode_string
        doc: |
          User account's scriptPath attribute ([MS-ADA3] section 2.232) value
          for interactive logon
      - id: profile_path
        -orig-id: ProfilePath
        type: rpc_unicode_string
        doc: |
          User account's profilePath attribute ([MS-ADA3] section 2.167) value
          for interactive logon
      - id: home_directory
        -orig-id: HomeDirectory
        type: rpc_unicode_string
        doc: |
          User account's HomeDirectory attribute ([MS-ADA1] section 2.295) value
          for interactive logon
      - id: home_directory_drive
        -orig-id: HomeDirectoryDrive
        type: rpc_unicode_string
        doc: |
          User account's HomeDrive attribute ([MS-ADA1] section 2.296) value for
          interactive logon
      - id: logon_count
        -orig-id: LogonCount
        type: u2
        doc: |
          User account's LogonCount attribute ([MS-ADA1] section 2.375)
          value.
      - id: bad_password_count
        -orig-id: BadPasswordCount
        type: u2
        doc: |
          User account's badPwdCount attribute ([MS-ADA1] section 2.83) value
          for interactive logon
      - id: user_id
        -orig-id: UserId
        type: u4
        doc: RID of the account
      - id: primary_group_id
        -orig-id: PrimaryGroupId
        type: u4
        doc: RID for the primary group to which this account belongs
      - id: group_count
        -orig-id: GroupCount
        type: u4
        doc: |
          Number of groups within the account domain to which the account
          belongs
      - id: group_ids_referent
        -orig-id: GroupIdsReferent
        type: u4
      - id: user_flags
        -orig-id: UserFlags
        type: u4
        doc: Set of bit flags that describe the user's logon information
      - id: user_session_key
        -orig-id: UserSessionKey
        size: 16
        doc: A session key that is used for cryptographic operations on a session
      - id: logon_server
        -orig-id: LogonServer
        type: rpc_unicode_string
        doc: |
          NetBIOS name of the Kerberos KDC that performed the authentication
          server (AS) ticket request
      - id: logon_domain_name
        -orig-id: LogonDomainName
        type: rpc_unicode_string
        doc: NetBIOS name of the domain to which this account belongs
      - id: logon_domain_id_referent
        -orig-id: LogonDomainIdReferent
        type: u4
      - id: reserved1
        -orig-id: Reserved1
        type: u8
      - id: user_account_control
        -orig-id: UserAccountControl
        type: u4
        doc: Set of bit flags that represent information about this account
      - id: sub_auth_status
        -orig-id: SubAuthStatus
        type: u4
        doc: |
          Subauthentication package's ([MS-APDS] section 3.1.5.2.1) status
          code
      - id: last_successful_i_logon
        -orig-id: LastSuccessfulILogon
        type: filetime
        doc: |
          User account's msDS-LastSuccessfulInteractiveLogonTime ([MS-ADA2]
          section 2.359)
      - id: last_failed_i_logon
        -orig-id: LastFailedILogon
        type: filetime
        doc: |
          User account's msDS-LastFailedInteractiveLogonTime ([MS-ADA2] section
          2.357)
      - id: failed_i_logon_count
        -orig-id: LastFailedILogon
        type: u4
        doc: |
          User account's msDS-FailedInteractiveLogonCountAtLastSuccessfulLogon
          ([MS-ADA2] section 2.315)
      - id: reserved3
        -orig-id: Reserved3
        type: u4
      - id: sid_count
        -orig-id: SidCount
        type: u4
        doc: |
          Total number of SIDs present in the ExtraSids member. If this member
          is not zero then the D bit MUST be set in the UserFlags member
      - id: extra_sids_referent
        -orig-id: ExtraSidsReferent
        type: u4
      - id: resource_group_domain_sid_referent
        -orig-id: ResourceGroupDomainSidReferent
        type: u4
      - id: resource_group_count
        -orig-id: ResourceGroupCount
        type: u4
        doc: Number of resource group identifiers stored in ResourceGroupIds
      - id: resource_group_ids_referent
        -orig-id: ResourceGroupIdsReferent
        type: u4
      - id: effective_name_body
        type: unicode_string_body
      - id: full_name_body
        type: unicode_string_body
      - id: logon_script_body
        type: unicode_string_body
      - id: profile_path_body
        type: unicode_string_body
      - id: home_directory_body
        type: unicode_string_body
      - id: home_directory_drive_body
        type: unicode_string_body
      - id: group_ids
        -orig-id: GroupIds
        type: rpc_group_membership
        if: group_count > 0
      - id: logon_server_body
        type: unicode_string_body
      - id: logon_domain_name_body
        type: unicode_string_body
      - id: logon_domain_id
        type: sid
      - id: extra_sids
        type: rpc_extra_sids
        if: (sid_count > 0) and (user_flags & netlogon_extra_sids_user_flag != 0)
      - id: resource_group_domain_sid
        -orig-id: ResourceGroupDomainSid
        type: sid
        if: user_flags & netlogon_resource_groups_user_flag != 0
      - id: resource_group_ids
        -orig-id: ResourceGroupIds
        type: rpc_resource_group_ids
        if: (user_flags & netlogon_resource_groups_user_flag != 0) and (resource_group_count > 0)
    instances:
      netlogon_extra_sids_user_flag:
        value: 0x20
        doc: |
          Indicates that the ExtraSids field is populated and contains additional SIDs
          A flag (bit) of UserFlags field (KERB_VALIDATION_INFO structure)
          [MS-PAC] 2.5 KERB_VALIDATION_INFO
      netlogon_resource_groups_user_flag:
        value: 0x200
        doc: |
          Indicates that the ResourceGroupIds field is populated
          A flag (bit) of UserFlags field (KERB_VALIDATION_INFO structure)
          [MS-PAC] 2.5 KERB_VALIDATION_INFO
  pac_client_info:
    doc: See [MS-PAC] 2.7 PAC_CLIENT_INFO
    seq:
      - id: client_id
        -orig-id: ClientId
        type: filetime
        doc: Kerberos initial ticket-granting ticket (TGT) authentication time
      - id: len_name
        -orig-id: NameLength
        type: u2
      - id: name
        -orig-id: Name
        size: len_name
        type: str
        encoding: UTF-16LE
        doc: |
          An array of 16-bit Unicode characters in little-endian format that contains the
          client's account name
  upn_dns_info:
    doc: See [MS-PAC] 2.10 UPN_DNS_INFO
    seq:
      - id: len_upn
        -orig-id: UpnLength
        type: u2
      - id: ofs_upn
        -orig-id: UpnOffset
        type: u2
        doc: Offset from the beginning of the UPN_DNS_INFO structure
      - id: len_dns_domain_name
        -orig-id: DnsDomainNameLength
        type: u2
      - id: ofs_dns_domain_name
        -orig-id: DnsDomainNameOffset
        type: u2
        doc: Offset from the beginning of the UPN_DNS_INFO structure
      - id: flags
        -orig-id: Flags
        type: u4
      - id: len_sam_name
        -orig-id: SamNameLength
        type: u2
        if: has_sam_name_and_sid
      - id: ofs_sam_name
        -orig-id: SamNameOffset
        type: u2
        if: has_sam_name_and_sid
        doc: Offset from the beginning of the UPN_DNS_INFO structure
      - id: len_sid
        -orig-id: SidLength
        type: u2
        if: has_sam_name_and_sid
      - id: ofs_sid
        -orig-id: SidOffset
        type: u2
        if: has_sam_name_and_sid
        doc: Offset from the beginning of the UPN_DNS_INFO structure
    instances:
      is_upn_constructed:
        value: (flags & 1) != 0
        doc: |
          U flag: the user account has no UPN set explicitly, so the UPN was
          constructed from the account name and the DNS domain name
      has_sam_name_and_sid:
        value: (flags & 2) != 0
        doc: |
          S flag: the structure is extended with the SAM name and SID of the
          account
      upn:
        pos: ofs_upn
        size: len_upn
        type: str
        encoding: UTF-16LE
      dns_domain_name:
        pos: ofs_dns_domain_name
        size: len_dns_domain_name
        type: str
        encoding: UTF-16LE
      sam_name:
        pos: ofs_sam_name
        size: len_sam_name
        type: str
        encoding: UTF-16LE
        if: has_sam_name_and_sid
      sid:
        pos: ofs_sid
        size: len_sid
        type: rpc_sid
        if: has_sam_name_and_sid
  pac_signature_data:
    doc: See [MS-PAC] 2.8 PAC_SIGNATURE_DATA
    seq:
      - id: signature_type
        -orig-id: SignatureType
        type: u4
        enum: signature_type_enum
        doc: The cryptographic system used to calculate the checksum
      - id: signature
        -orig-id: Signature
        size: len_signature
      - id: ro_dc_identifier
        -orig-id: RODCIdentifier
        type: u2
        if: not _io.eof
        doc: |
          First 16 bits of the key version number ([MS-KILE] section 3.1.5.8)
          when the KDC is an RODC
    instances:
      len_signature:
        value: |
          signature_type == signature_type_enum::kerb_checksum_hmac_md5 ? 16 :
          (
            signature_type == signature_type_enum::hmac_sha1_96_aes128 or
            signature_type == signature_type_enum::hmac_sha1_96_aes256
          ) ? 12 :
          _io.size - 4
        doc: |
          16 for HMAC-MD5 and 12 for the AES types; for an unknown signature
          type, the rest of the buffer.
    enums:
      signature_type_enum:
        0xFFFFFF76: kerb_checksum_hmac_md5
        0x0000000F: hmac_sha1_96_aes128
        0x00000010: hmac_sha1_96_aes256
