meta:
  id: mapi_tags
  title: MAPI property identifiers
  application:
    - Microsoft Outlook
    - Microsoft Exchange
  license: CC0-1.0
  endian: le
doc: |
  MAPI property identifiers: the upper 16 bits of a MAPI property tag
  (PropTag), whose lower 16 bits are the property type. Each name is the
  canonical MS-OXPROPS name (PidTag...) with the prefix dropped, in snake
  case; the canonical name is kept in `-orig-id` and the property type in
  `doc`. Where several canonical properties share an identifier with
  different types, the one MFCMAPI ranks first is used and the others are
  listed in `doc`.

  Covers the tagged properties (identifiers below 0x8000). Identifiers from
  0x8000 up are named properties, mapped per message store, and are not
  listed. 0x6001, 0x6003 and 0x6004 are the Outlook nickname cache (NK2)
  properties, which are not in MS-OXPROPS.

  Generated from the MFCMAPI property tag table (`g_PropTagArray`, entries
  named PidTag*) plus the NK2 identifiers from nk2props.h; see doc-ref for
  the pinned sources.
doc-ref:
  - https://learn.microsoft.com/en-us/openspecs/exchange_server_protocols/ms-oxprops/f6ab1613-aefe-447d-a49c-18217230b148
  - https://github.com/stephenegriffin/mfcmapi/blob/2941bb88629bca4a351f066f9918302b0cca838d/core/interpret/genTagArray.h
  - https://github.com/nektra/outlook-autocomplete/blob/3412b7ffe55a2e8a6153a1555a6798fae91fcf5e/OlAutoComplete/nk2props.h
seq:
  - id: property_id
    type: u2
    enum: property_id
enums:
  property_id:
    0x0001:
      id: acknowledgement_mode
      -orig-id: PidTagAcknowledgementMode
      doc: |
        PtypInteger32. Also used as:
        * PidTagTemplateData (PtypBinary)
    0x0002:
      id: alternate_recipient_allowed
      -orig-id: PidTagAlternateRecipientAllowed
      doc: PtypBoolean.
    0x0003:
      id: authorizing_users
      -orig-id: PidTagAuthorizingUsers
      doc: PtypBinary.
    0x0004:
      id: auto_forward_comment
      -orig-id: PidTagAutoForwardComment
      doc: |
        PtypString. Also used as:
        * PidTagScriptData (PtypBinary)
    0x0005:
      id: auto_forwarded
      -orig-id: PidTagAutoForwarded
      doc: PtypBoolean.
    0x0006:
      id: content_confidentiality_algorithm_id
      -orig-id: PidTagContentConfidentialityAlgorithmId
      doc: PtypBinary.
    0x0007:
      id: content_correlator
      -orig-id: PidTagContentCorrelator
      doc: PtypBinary.
    0x0008:
      id: content_identifier
      -orig-id: PidTagContentIdentifier
      doc: PtypString.
    0x0009:
      id: content_length
      -orig-id: PidTagContentLength
      doc: PtypInteger32.
    0x000a:
      id: content_return_requested
      -orig-id: PidTagContentReturnRequested
      doc: PtypBoolean.
    0x000b:
      id: conversation_key
      -orig-id: PidTagConversationKey
      doc: PtypBinary.
    0x000c:
      id: conversion_eits
      -orig-id: PidTagConversionEits
      doc: PtypBinary.
    0x000d:
      id: conversion_with_loss_prohibited
      -orig-id: PidTagConversionWithLossProhibited
      doc: PtypBoolean.
    0x000e:
      id: converted_eits
      -orig-id: PidTagConvertedEits
      doc: PtypBinary.
    0x000f:
      id: deferred_delivery_time
      -orig-id: PidTagDeferredDeliveryTime
      doc: PtypTime.
    0x0010:
      id: deliver_time
      -orig-id: PidTagDeliverTime
      doc: PtypTime.
    0x0011:
      id: discard_reason
      -orig-id: PidTagDiscardReason
      doc: PtypInteger32.
    0x0012:
      id: disclosure_of_recipients
      -orig-id: PidTagDisclosureOfRecipients
      doc: PtypBoolean.
    0x0013:
      id: distribution_list_expansion_history
      -orig-id: PidTagDistributionListExpansionHistory
      doc: PtypBinary.
    0x0014:
      id: distribution_list_expansion_prohibited
      -orig-id: PidTagDistributionListExpansionProhibited
      doc: PtypBoolean.
    0x0015:
      id: expiry_time
      -orig-id: PidTagExpiryTime
      doc: PtypTime.
    0x0016:
      id: implicit_conversion_prohibited
      -orig-id: PidTagImplicitConversionProhibited
      doc: PtypBoolean.
    0x0017:
      id: importance
      -orig-id: PidTagImportance
      doc: PtypInteger32.
    0x0018:
      id: ipm_id
      -orig-id: PidTagIpmId
      doc: PtypBinary.
    0x0019:
      id: latest_delivery_time
      -orig-id: PidTagLatestDeliveryTime
      doc: PtypTime.
    0x001a:
      id: message_class
      -orig-id: PidTagMessageClass
      doc: PtypString.
    0x001b:
      id: message_delivery_id
      -orig-id: PidTagMessageDeliveryId
      doc: PtypBinary.
    0x001e:
      id: message_security_label
      -orig-id: PidTagMessageSecurityLabel
      doc: PtypBinary.
    0x001f:
      id: obsoleted_message_ids
      -orig-id: PidTagObsoletedMessageIds
      doc: PtypBinary.
    0x0020:
      id: originally_intended_recipient_name
      -orig-id: PidTagOriginallyIntendedRecipientName
      doc: PtypBinary.
    0x0021:
      id: original_eits
      -orig-id: PidTagOriginalEits
      doc: PtypBinary.
    0x0022:
      id: originator_certificate
      -orig-id: PidTagOriginatorCertificate
      doc: PtypBinary.
    0x0023:
      id: originator_delivery_report_requested
      -orig-id: PidTagOriginatorDeliveryReportRequested
      doc: PtypBoolean.
    0x0024:
      id: originator_return_address
      -orig-id: PidTagOriginatorReturnAddress
      doc: PtypBinary.
    0x0025:
      id: parent_key
      -orig-id: PidTagParentKey
      doc: PtypBinary.
    0x0026:
      id: priority
      -orig-id: PidTagPriority
      doc: PtypInteger32.
    0x0027:
      id: origin_check
      -orig-id: PidTagOriginCheck
      doc: PtypBinary.
    0x0028:
      id: proof_of_submission_requested
      -orig-id: PidTagProofOfSubmissionRequested
      doc: PtypBoolean.
    0x0029:
      id: read_receipt_requested
      -orig-id: PidTagReadReceiptRequested
      doc: PtypBoolean.
    0x002a:
      id: receipt_time
      -orig-id: PidTagReceiptTime
      doc: PtypTime.
    0x002b:
      id: recipient_reassignment_prohibited
      -orig-id: PidTagRecipientReassignmentProhibited
      doc: PtypBoolean.
    0x002c:
      id: redirection_history
      -orig-id: PidTagRedirectionHistory
      doc: PtypBinary.
    0x002d:
      id: related_message_ids
      -orig-id: PidTagRelatedMessageIds
      doc: PtypBinary.
    0x002e:
      id: original_sensitivity
      -orig-id: PidTagOriginalSensitivity
      doc: PtypInteger32.
    0x002f:
      id: languages
      -orig-id: PidTagLanguages
      doc: PtypString.
    0x0030:
      id: reply_time
      -orig-id: PidTagReplyTime
      doc: PtypTime.
    0x0031:
      id: report_tag
      -orig-id: PidTagReportTag
      doc: PtypBinary.
    0x0032:
      id: report_time
      -orig-id: PidTagReportTime
      doc: PtypTime.
    0x0033:
      id: returned_messageid
      -orig-id: PidTagReturnedMessageid
      doc: PtypBoolean.
    0x0034:
      id: security
      -orig-id: PidTagSecurity
      doc: PtypInteger32.
    0x0035:
      id: incomplete_copy
      -orig-id: PidTagIncompleteCopy
      doc: PtypBoolean.
    0x0036:
      id: sensitivity
      -orig-id: PidTagSensitivity
      doc: PtypInteger32.
    0x0037:
      id: subject
      -orig-id: PidTagSubject
      doc: PtypString.
    0x0038:
      id: subject_message_id
      -orig-id: PidTagSubjectMessageId
      doc: PtypBinary.
    0x0039:
      id: client_submit_time
      -orig-id: PidTagClientSubmitTime
      doc: PtypTime.
    0x003a:
      id: report_name
      -orig-id: PidTagReportName
      doc: PtypString.
    0x003b:
      id: sent_representing_search_key
      -orig-id: PidTagSentRepresentingSearchKey
      doc: PtypBinary.
    0x003c:
      id: x400_content_type
      -orig-id: PidTagX400ContentType
      doc: PtypBinary.
    0x003d:
      id: subject_prefix
      -orig-id: PidTagSubjectPrefix
      doc: PtypString.
    0x003e:
      id: non_receipt_reason
      -orig-id: PidTagNonReceiptReason
      doc: PtypInteger32.
    0x003f:
      id: received_by_entry_id
      -orig-id: PidTagReceivedByEntryId
      doc: PtypBinary.
    0x0040:
      id: received_by_name
      -orig-id: PidTagReceivedByName
      doc: PtypString.
    0x0041:
      id: sent_representing_entry_id
      -orig-id: PidTagSentRepresentingEntryId
      doc: PtypBinary.
    0x0042:
      id: sent_representing_name
      -orig-id: PidTagSentRepresentingName
      doc: PtypString.
    0x0043:
      id: received_representing_entry_id
      -orig-id: PidTagReceivedRepresentingEntryId
      doc: PtypBinary.
    0x0044:
      id: received_representing_name
      -orig-id: PidTagReceivedRepresentingName
      doc: PtypString.
    0x0045:
      id: report_entry_id
      -orig-id: PidTagReportEntryId
      doc: PtypBinary.
    0x0046:
      id: read_receipt_entry_id
      -orig-id: PidTagReadReceiptEntryId
      doc: PtypBinary.
    0x0047:
      id: message_submission_id
      -orig-id: PidTagMessageSubmissionId
      doc: PtypBinary.
    0x0048:
      id: provider_submit_time
      -orig-id: PidTagProviderSubmitTime
      doc: PtypTime.
    0x0049:
      id: original_subject
      -orig-id: PidTagOriginalSubject
      doc: PtypString.
    0x004a:
      id: disc_val
      -orig-id: PidTagDiscVal
      doc: PtypBoolean.
    0x004b:
      id: original_message_class
      -orig-id: PidTagOriginalMessageClass
      doc: PtypString.
    0x004c:
      id: original_author_entry_id
      -orig-id: PidTagOriginalAuthorEntryId
      doc: PtypBinary.
    0x004d:
      id: original_author_name
      -orig-id: PidTagOriginalAuthorName
      doc: PtypString.
    0x004e:
      id: original_submit_time
      -orig-id: PidTagOriginalSubmitTime
      doc: PtypTime.
    0x004f:
      id: reply_recipient_entries
      -orig-id: PidTagReplyRecipientEntries
      doc: PtypBinary.
    0x0050:
      id: reply_recipient_names
      -orig-id: PidTagReplyRecipientNames
      doc: PtypString.
    0x0051:
      id: received_by_search_key
      -orig-id: PidTagReceivedBySearchKey
      doc: PtypBinary.
    0x0052:
      id: received_representing_search_key
      -orig-id: PidTagReceivedRepresentingSearchKey
      doc: PtypBinary.
    0x0053:
      id: read_receipt_search_key
      -orig-id: PidTagReadReceiptSearchKey
      doc: PtypBinary.
    0x0054:
      id: report_search_key
      -orig-id: PidTagReportSearchKey
      doc: PtypBinary.
    0x0055:
      id: original_delivery_time
      -orig-id: PidTagOriginalDeliveryTime
      doc: PtypTime.
    0x0056:
      id: original_author_search_key
      -orig-id: PidTagOriginalAuthorSearchKey
      doc: PtypBinary.
    0x0057:
      id: message_to_me
      -orig-id: PidTagMessageToMe
      doc: PtypBoolean.
    0x0058:
      id: message_cc_me
      -orig-id: PidTagMessageCcMe
      doc: PtypBoolean.
    0x0059:
      id: message_recipient_me
      -orig-id: PidTagMessageRecipientMe
      doc: PtypBoolean.
    0x005a:
      id: original_sender_name
      -orig-id: PidTagOriginalSenderName
      doc: PtypString.
    0x005b:
      id: original_sender_entry_id
      -orig-id: PidTagOriginalSenderEntryId
      doc: PtypBinary.
    0x005c:
      id: original_sender_search_key
      -orig-id: PidTagOriginalSenderSearchKey
      doc: PtypBinary.
    0x005d:
      id: original_sent_representing_name
      -orig-id: PidTagOriginalSentRepresentingName
      doc: PtypString.
    0x005e:
      id: original_sent_representing_entry_id
      -orig-id: PidTagOriginalSentRepresentingEntryId
      doc: PtypBinary.
    0x005f:
      id: original_sent_representing_search_key
      -orig-id: PidTagOriginalSentRepresentingSearchKey
      doc: PtypBinary.
    0x0060:
      id: start_date
      -orig-id: PidTagStartDate
      doc: PtypTime.
    0x0061:
      id: end_date
      -orig-id: PidTagEndDate
      doc: PtypTime.
    0x0062:
      id: owner_appointment_id
      -orig-id: PidTagOwnerAppointmentId
      doc: PtypInteger32.
    0x0063:
      id: response_requested
      -orig-id: PidTagResponseRequested
      doc: PtypBoolean.
    0x0064:
      id: sent_representing_address_type
      -orig-id: PidTagSentRepresentingAddressType
      doc: PtypString.
    0x0065:
      id: sent_representing_email_address
      -orig-id: PidTagSentRepresentingEmailAddress
      doc: PtypString.
    0x0066:
      id: original_sender_address_type
      -orig-id: PidTagOriginalSenderAddressType
      doc: PtypString.
    0x0067:
      id: original_sender_email_address
      -orig-id: PidTagOriginalSenderEmailAddress
      doc: PtypString.
    0x0068:
      id: original_sent_representing_address_type
      -orig-id: PidTagOriginalSentRepresentingAddressType
      doc: PtypString.
    0x0069:
      id: original_sent_representing_email_address
      -orig-id: PidTagOriginalSentRepresentingEmailAddress
      doc: PtypString.
    0x0070:
      id: conversation_topic
      -orig-id: PidTagConversationTopic
      doc: PtypString.
    0x0071:
      id: conversation_index
      -orig-id: PidTagConversationIndex
      doc: PtypBinary.
    0x0072:
      id: original_display_bcc
      -orig-id: PidTagOriginalDisplayBcc
      doc: PtypString.
    0x0073:
      id: original_display_cc
      -orig-id: PidTagOriginalDisplayCc
      doc: PtypString.
    0x0074:
      id: original_display_to
      -orig-id: PidTagOriginalDisplayTo
      doc: PtypString.
    0x0075:
      id: received_by_address_type
      -orig-id: PidTagReceivedByAddressType
      doc: PtypString.
    0x0076:
      id: received_by_email_address
      -orig-id: PidTagReceivedByEmailAddress
      doc: PtypString.
    0x0077:
      id: received_representing_address_type
      -orig-id: PidTagReceivedRepresentingAddressType
      doc: PtypString.
    0x0078:
      id: received_representing_email_address
      -orig-id: PidTagReceivedRepresentingEmailAddress
      doc: PtypString.
    0x0079:
      id: original_author_address_type
      -orig-id: PidTagOriginalAuthorAddressType
      doc: PtypString.
    0x007a:
      id: original_author_email_address
      -orig-id: PidTagOriginalAuthorEmailAddress
      doc: PtypString.
    0x007b:
      id: originally_intended_recip_addrtype
      -orig-id: PidTagOriginallyIntendedRecipAddrtype
      doc: PtypString.
    0x007c:
      id: originally_intended_recip_email_address
      -orig-id: PidTagOriginallyIntendedRecipEmailAddress
      doc: PtypString.
    0x007d:
      id: transport_message_headers
      -orig-id: PidTagTransportMessageHeaders
      doc: PtypString.
    0x007e:
      id: delegation
      -orig-id: PidTagDelegation
      doc: PtypBinary.
    0x007f:
      id: tnef_correlation_key
      -orig-id: PidTagTnefCorrelationKey
      doc: PtypBinary.
    0x0080:
      id: report_disposition
      -orig-id: PidTagReportDisposition
      doc: PtypString.
    0x0081:
      id: report_disposition_mode
      -orig-id: PidTagReportDispositionMode
      doc: PtypString.
    0x0082:
      id: report_original_sender
      -orig-id: PidTagReportOriginalSender
      doc: PtypString.
    0x0083:
      id: report_disposition_to_names
      -orig-id: PidTagReportDispositionToNames
      doc: PtypMultipleString.
    0x0084:
      id: report_disposition_to_email_addresses
      -orig-id: PidTagReportDispositionToEmailAddresses
      doc: PtypMultipleString.
    0x0085:
      id: report_disposition_options
      -orig-id: PidTagReportDispositionOptions
      doc: PtypString.
    0x0418:
      id: spam_trusted_senders
      -orig-id: PidTagSpamTrustedSenders
      doc: PtypString.
    0x0419:
      id: spam_trusted_recipients
      -orig-id: PidTagSpamTrustedRecipients
      doc: PtypString.
    0x041a:
      id: spam_junk_senders
      -orig-id: PidTagSpamJunkSenders
      doc: PtypString.
    0x041b:
      id: spam_threshold
      -orig-id: PidTagSpamThreshold
      doc: PtypInteger32.
    0x0807:
      id: address_book_room_capacity
      -orig-id: PidTagAddressBookRoomCapacity
      doc: PtypInteger32.
    0x0809:
      id: address_book_room_description
      -orig-id: PidTagAddressBookRoomDescription
      doc: PtypString.
    0x0c00:
      id: content_integrity_check
      -orig-id: PidTagContentIntegrityCheck
      doc: PtypBinary.
    0x0c01:
      id: explicit_conversion
      -orig-id: PidTagExplicitConversion
      doc: PtypInteger32.
    0x0c02:
      id: ipm_return_requested
      -orig-id: PidTagIpmReturnRequested
      doc: PtypBoolean.
    0x0c03:
      id: message_token
      -orig-id: PidTagMessageToken
      doc: PtypBinary.
    0x0c04:
      id: non_delivery_report_reason_code
      -orig-id: PidTagNonDeliveryReportReasonCode
      doc: PtypInteger32.
    0x0c05:
      id: non_delivery_report_diag_code
      -orig-id: PidTagNonDeliveryReportDiagCode
      doc: PtypInteger32.
    0x0c06:
      id: non_receipt_notification_requested
      -orig-id: PidTagNonReceiptNotificationRequested
      doc: PtypBoolean.
    0x0c07:
      id: delivery_point
      -orig-id: PidTagDeliveryPoint
      doc: PtypInteger32.
    0x0c08:
      id: originator_non_delivery_report_requested
      -orig-id: PidTagOriginatorNonDeliveryReportRequested
      doc: PtypBoolean.
    0x0c09:
      id: originator_requested_alternate_recipient
      -orig-id: PidTagOriginatorRequestedAlternateRecipient
      doc: PtypBinary.
    0x0c0a:
      id: physical_delivery_bureau_fax_delivery
      -orig-id: PidTagPhysicalDeliveryBureauFaxDelivery
      doc: PtypBoolean.
    0x0c0b:
      id: physical_delivery_mode
      -orig-id: PidTagPhysicalDeliveryMode
      doc: PtypInteger32.
    0x0c0c:
      id: physical_delivery_report_request
      -orig-id: PidTagPhysicalDeliveryReportRequest
      doc: PtypInteger32.
    0x0c0d:
      id: physical_forwarding_address
      -orig-id: PidTagPhysicalForwardingAddress
      doc: PtypBinary.
    0x0c0e:
      id: physical_forwarding_address_requested
      -orig-id: PidTagPhysicalForwardingAddressRequested
      doc: PtypBoolean.
    0x0c0f:
      id: physical_forwarding_prohibited
      -orig-id: PidTagPhysicalForwardingProhibited
      doc: PtypBoolean.
    0x0c10:
      id: physical_rendition_attributes
      -orig-id: PidTagPhysicalRenditionAttributes
      doc: PtypBinary.
    0x0c11:
      id: proof_of_delivery
      -orig-id: PidTagProofOfDelivery
      doc: PtypBinary.
    0x0c12:
      id: proof_of_delivery_requested
      -orig-id: PidTagProofOfDeliveryRequested
      doc: PtypBoolean.
    0x0c13:
      id: recipient_certificate
      -orig-id: PidTagRecipientCertificate
      doc: PtypBinary.
    0x0c14:
      id: recipient_number_for_advice
      -orig-id: PidTagRecipientNumberForAdvice
      doc: PtypString.
    0x0c15:
      id: recipient_type
      -orig-id: PidTagRecipientType
      doc: PtypInteger32.
    0x0c16:
      id: registered_mail_type
      -orig-id: PidTagRegisteredMailType
      doc: PtypInteger32.
    0x0c17:
      id: reply_requested
      -orig-id: PidTagReplyRequested
      doc: PtypBoolean.
    0x0c18:
      id: requested_delivery_method
      -orig-id: PidTagRequestedDeliveryMethod
      doc: PtypInteger32.
    0x0c19:
      id: sender_entry_id
      -orig-id: PidTagSenderEntryId
      doc: PtypBinary.
    0x0c1a:
      id: sender_name
      -orig-id: PidTagSenderName
      doc: PtypString.
    0x0c1b:
      id: supplementary_info
      -orig-id: PidTagSupplementaryInfo
      doc: PtypString.
    0x0c1c:
      id: type_of_x400_user
      -orig-id: PidTagTypeOfX400User
      doc: PtypInteger32.
    0x0c1d:
      id: sender_search_key
      -orig-id: PidTagSenderSearchKey
      doc: PtypBinary.
    0x0c1e:
      id: sender_address_type
      -orig-id: PidTagSenderAddressType
      doc: PtypString.
    0x0c1f:
      id: sender_email_address
      -orig-id: PidTagSenderEmailAddress
      doc: PtypString.
    0x0c20:
      id: non_delivery_report_status_code
      -orig-id: PidTagNonDeliveryReportStatusCode
      doc: PtypInteger32.
    0x0c21:
      id: remote_message_transfer_agent
      -orig-id: PidTagRemoteMessageTransferAgent
      doc: PtypString.
    0x0e00:
      id: current_version
      -orig-id: PidTagCurrentVersion
      doc: PtypInteger64.
    0x0e01:
      id: delete_after_submit
      -orig-id: PidTagDeleteAfterSubmit
      doc: PtypBoolean.
    0x0e02:
      id: display_bcc
      -orig-id: PidTagDisplayBcc
      doc: PtypString.
    0x0e03:
      id: display_cc
      -orig-id: PidTagDisplayCc
      doc: PtypString.
    0x0e04:
      id: display_to
      -orig-id: PidTagDisplayTo
      doc: PtypString.
    0x0e05:
      id: parent_display
      -orig-id: PidTagParentDisplay
      doc: PtypString.
    0x0e06:
      id: message_delivery_time
      -orig-id: PidTagMessageDeliveryTime
      doc: PtypTime.
    0x0e07:
      id: message_flags
      -orig-id: PidTagMessageFlags
      doc: PtypInteger32.
    0x0e08:
      id: message_size
      -orig-id: PidTagMessageSize
      doc: |
        PtypInteger32. Also used as:
        * PidTagMessageSizeExtended (PtypInteger64)
    0x0e09:
      id: parent_entry_id
      -orig-id: PidTagParentEntryId
      doc: PtypBinary.
    0x0e0a:
      id: sent_mail_entry_id
      -orig-id: PidTagSentMailEntryId
      doc: PtypBinary.
    0x0e0c:
      id: correlate
      -orig-id: PidTagCorrelate
      doc: PtypBoolean.
    0x0e0d:
      id: correlate_mtsid
      -orig-id: PidTagCorrelateMtsid
      doc: PtypBinary.
    0x0e0e:
      id: discrete_values
      -orig-id: PidTagDiscreteValues
      doc: PtypBoolean.
    0x0e0f:
      id: responsibility
      -orig-id: PidTagResponsibility
      doc: PtypBoolean.
    0x0e10:
      id: spooler_status
      -orig-id: PidTagSpoolerStatus
      doc: PtypInteger32.
    0x0e11:
      id: transport_status
      -orig-id: PidTagTransportStatus
      doc: PtypInteger32.
    0x0e12:
      id: message_recipients
      -orig-id: PidTagMessageRecipients
      doc: PtypObject.
    0x0e13:
      id: message_attachments
      -orig-id: PidTagMessageAttachments
      doc: PtypObject.
    0x0e14:
      id: submit_flags
      -orig-id: PidTagSubmitFlags
      doc: PtypInteger32.
    0x0e15:
      id: recipient_status
      -orig-id: PidTagRecipientStatus
      doc: PtypInteger32.
    0x0e16:
      id: transport_key
      -orig-id: PidTagTransportKey
      doc: PtypInteger32.
    0x0e17:
      id: message_status
      -orig-id: PidTagMessageStatus
      doc: PtypInteger32.
    0x0e18:
      id: message_download_time
      -orig-id: PidTagMessageDownloadTime
      doc: PtypInteger32.
    0x0e19:
      id: creation_version
      -orig-id: PidTagCreationVersion
      doc: PtypInteger64.
    0x0e1a:
      id: modify_version
      -orig-id: PidTagModifyVersion
      doc: PtypInteger64.
    0x0e1b:
      id: has_attachments
      -orig-id: PidTagHasAttachments
      doc: PtypBoolean.
    0x0e1c:
      id: body_crc
      -orig-id: PidTagBodyCrc
      doc: PtypInteger32.
    0x0e1d:
      id: normalized_subject
      -orig-id: PidTagNormalizedSubject
      doc: PtypString.
    0x0e1f:
      id: rtf_in_sync
      -orig-id: PidTagRtfInSync
      doc: PtypBoolean.
    0x0e20:
      id: attach_size
      -orig-id: PidTagAttachSize
      doc: PtypInteger32.
    0x0e21:
      id: attach_number
      -orig-id: PidTagAttachNumber
      doc: PtypInteger32.
    0x0e22:
      id: preprocess
      -orig-id: PidTagPreprocess
      doc: PtypBoolean.
    0x0e23:
      id: internet_article_number
      -orig-id: PidTagInternetArticleNumber
      doc: PtypInteger32.
    0x0e25:
      id: originating_mta_certificate
      -orig-id: PidTagOriginatingMtaCertificate
      doc: PtypBinary.
    0x0e26:
      id: proof_of_submission
      -orig-id: PidTagProofOfSubmission
      doc: PtypBinary.
    0x0e28:
      id: primary_send_account
      -orig-id: PidTagPrimarySendAccount
      doc: PtypString.
    0x0e29:
      id: next_send_acct
      -orig-id: PidTagNextSendAcct
      doc: PtypString.
    0x0e2a:
      id: exchange_remote_header
      -orig-id: PidTagExchangeRemoteHeader
      doc: PtypBoolean.
    0x0e2b:
      id: to_do_item_flags
      -orig-id: PidTagToDoItemFlags
      doc: PtypInteger32.
    0x0e2c:
      id: swapped_to_do_store
      -orig-id: PidTagSwappedToDoStore
      doc: PtypBinary.
    0x0e2d:
      id: swapped_to_do_data
      -orig-id: PidTagSwappedToDoData
      doc: PtypBinary.
    0x0e30:
      id: repl_itemid
      -orig-id: PidTagReplItemid
      doc: PtypBinary.
    0x0e33:
      id: repl_changenum
      -orig-id: PidTagReplChangenum
      doc: PtypInteger64.
    0x0e34:
      id: repl_version_history
      -orig-id: PidTagReplVersionHistory
      doc: PtypBinary.
    0x0e38:
      id: repl_flags
      -orig-id: PidTagReplFlags
      doc: PtypInteger32.
    0x0e3c:
      id: repl_copiedfrom_versionhistory
      -orig-id: PidTagReplCopiedfromVersionhistory
      doc: PtypBinary.
    0x0e3d:
      id: repl_copiedfrom_itemid
      -orig-id: PidTagReplCopiedfromItemid
      doc: PtypBinary.
    0x0e69:
      id: read
      -orig-id: PidTagRead
      doc: PtypBoolean.
    0x0e6a:
      id: security_descriptor_as_xml
      -orig-id: PidTagSecurityDescriptorAsXml
      doc: PtypString.
    0x0e79:
      id: trust_sender
      -orig-id: PidTagTrustSender
      doc: PtypInteger32.
    0x0e84:
      id: exchange_nt_security_descriptor
      -orig-id: PidTagExchangeNTSecurityDescriptor
      doc: PtypBinary.
    0x0e99:
      id: extended_rule_message_actions
      -orig-id: PidTagExtendedRuleMessageActions
      doc: PtypBinary.
    0x0e9a:
      id: extended_rule_message_condition
      -orig-id: PidTagExtendedRuleMessageCondition
      doc: PtypBinary.
    0x0e9b:
      id: extended_rule_size_limit
      -orig-id: PidTagExtendedRuleSizeLimit
      doc: PtypInteger32.
    0x0e9c:
      id: tnef_unprocessed_props
      -orig-id: PidTagTnefUnprocessedProps
      doc: PtypBinary.
    0x0ea0:
      id: associated_sharing_provider
      -orig-id: PidTagAssociatedSharingProvider
      doc: PtypGuid.
    0x0ea3:
      id: provider_item_id
      -orig-id: PidTagProviderItemId
      doc: PtypBinary.
    0x0ea4:
      id: provider_parent_item_id
      -orig-id: PidTagProviderParentItemId
      doc: PtypBinary.
    0x0ff4:
      id: access
      -orig-id: PidTagAccess
      doc: PtypInteger32.
    0x0ff5:
      id: row_type
      -orig-id: PidTagRowType
      doc: PtypInteger32.
    0x0ff6:
      id: instance_key
      -orig-id: PidTagInstanceKey
      doc: PtypBinary.
    0x0ff7:
      id: access_level
      -orig-id: PidTagAccessLevel
      doc: PtypInteger32.
    0x0ff8:
      id: mapping_signature
      -orig-id: PidTagMappingSignature
      doc: PtypBinary.
    0x0ff9:
      id: record_key
      -orig-id: PidTagRecordKey
      doc: PtypBinary.
    0x0ffa:
      id: store_record_key
      -orig-id: PidTagStoreRecordKey
      doc: PtypBinary.
    0x0ffb:
      id: store_entry_id
      -orig-id: PidTagStoreEntryId
      doc: PtypBinary.
    0x0ffc:
      id: mini_icon
      -orig-id: PidTagMiniIcon
      doc: PtypBinary.
    0x0ffd:
      id: icon
      -orig-id: PidTagIcon
      doc: PtypBinary.
    0x0ffe:
      id: object_type
      -orig-id: PidTagObjectType
      doc: PtypInteger32.
    0x0fff:
      id: entry_id
      -orig-id: PidTagEntryId
      doc: |
        PtypBinary. Also used as:
        * PidTagMemberEntryId (PtypBinary)
    0x1000:
      id: body
      -orig-id: PidTagBody
      doc: PtypString.
    0x1001:
      id: report_text
      -orig-id: PidTagReportText
      doc: PtypString.
    0x1002:
      id: originator_and_distribution_list_expansion_history
      -orig-id: PidTagOriginatorAndDistributionListExpansionHistory
      doc: PtypBinary.
    0x1003:
      id: reporting_distribution_list_name
      -orig-id: PidTagReportingDistributionListName
      doc: PtypBinary.
    0x1004:
      id: reporting_message_transfer_agent_certificate
      -orig-id: PidTagReportingMessageTransferAgentCertificate
      doc: PtypBinary.
    0x1006:
      id: rtf_sync_body_crc
      -orig-id: PidTagRtfSyncBodyCrc
      doc: PtypInteger32.
    0x1007:
      id: rtf_sync_body_count
      -orig-id: PidTagRtfSyncBodyCount
      doc: PtypInteger32.
    0x1008:
      id: rtf_sync_body_tag
      -orig-id: PidTagRtfSyncBodyTag
      doc: PtypString.
    0x1009:
      id: rtf_compressed
      -orig-id: PidTagRtfCompressed
      doc: PtypBinary.
    0x1010:
      id: rtf_sync_prefix_count
      -orig-id: PidTagRtfSyncPrefixCount
      doc: PtypInteger32.
    0x1011:
      id: rtf_sync_trailing_count
      -orig-id: PidTagRtfSyncTrailingCount
      doc: PtypInteger32.
    0x1012:
      id: originally_intended_recip_entry_id
      -orig-id: PidTagOriginallyIntendedRecipEntryId
      doc: PtypBinary.
    0x1013:
      id: html
      -orig-id: PidTagHtml
      doc: |
        PtypBinary. Also used as:
        * PidTagBodyHtml (PtypString)
    0x1014:
      id: body_content_location
      -orig-id: PidTagBodyContentLocation
      doc: PtypString.
    0x1015:
      id: body_content_id
      -orig-id: PidTagBodyContentId
      doc: PtypString.
    0x1016:
      id: native_body
      -orig-id: PidTagNativeBody
      doc: PtypInteger32.
    0x1030:
      id: internet_approved
      -orig-id: PidTagInternetApproved
      doc: PtypString.
    0x1031:
      id: internet_control
      -orig-id: PidTagInternetControl
      doc: PtypString.
    0x1032:
      id: internet_distribution
      -orig-id: PidTagInternetDistribution
      doc: PtypString.
    0x1033:
      id: internet_followup_to
      -orig-id: PidTagInternetFollowupTo
      doc: PtypString.
    0x1034:
      id: internet_lines
      -orig-id: PidTagInternetLines
      doc: PtypInteger32.
    0x1035:
      id: internet_message_id
      -orig-id: PidTagInternetMessageId
      doc: PtypString.
    0x1037:
      id: internet_organization
      -orig-id: PidTagInternetOrganization
      doc: PtypString.
    0x1038:
      id: internet_nntp_path
      -orig-id: PidTagInternetNntpPath
      doc: PtypString.
    0x1039:
      id: internet_references
      -orig-id: PidTagInternetReferences
      doc: PtypString.
    0x1042:
      id: in_reply_to_id
      -orig-id: PidTagInReplyToId
      doc: PtypString.
    0x1043:
      id: list_help
      -orig-id: PidTagListHelp
      doc: PtypString.
    0x1044:
      id: list_subscribe
      -orig-id: PidTagListSubscribe
      doc: PtypString.
    0x1045:
      id: list_unsubscribe
      -orig-id: PidTagListUnsubscribe
      doc: PtypString.
    0x1046:
      id: internet_return_path
      -orig-id: PidTagInternetReturnPath
      doc: |
        PtypString. Also used as:
        * PidTagOriginalMessageId (PtypString)
    0x1080:
      id: icon_index
      -orig-id: PidTagIconIndex
      doc: PtypInteger32.
    0x1081:
      id: last_verb_executed
      -orig-id: PidTagLastVerbExecuted
      doc: PtypInteger32.
    0x1082:
      id: last_verb_execution_time
      -orig-id: PidTagLastVerbExecutionTime
      doc: PtypTime.
    0x1090:
      id: flag_status
      -orig-id: PidTagFlagStatus
      doc: PtypInteger32.
    0x1091:
      id: flag_complete_time
      -orig-id: PidTagFlagCompleteTime
      doc: PtypTime.
    0x1095:
      id: followup_icon
      -orig-id: PidTagFollowupIcon
      doc: PtypInteger32.
    0x1096:
      id: block_status
      -orig-id: PidTagBlockStatus
      doc: PtypInteger32.
    0x1097:
      id: item_temporaryflags
      -orig-id: PidTagItemTemporaryflags
      doc: PtypInteger32.
    0x1098:
      id: conflict_items
      -orig-id: PidTagConflictItems
      doc: PtypMultipleBinary.
    0x10c3:
      id: i_calendar_start_time
      -orig-id: PidTagICalendarStartTime
      doc: PtypTime.
    0x10c4:
      id: i_calendar_end_time
      -orig-id: PidTagICalendarEndTime
      doc: PtypTime.
    0x10c5:
      id: cdo_recurrenceid
      -orig-id: PidTagCdoRecurrenceid
      doc: PtypTime.
    0x10ca:
      id: i_calendar_reminder_next_time
      -orig-id: PidTagICalendarReminderNextTime
      doc: PtypTime.
    0x10f0:
      id: imap_cached_msgsize
      -orig-id: PidTagImapCachedMsgsize
      doc: PtypBinary.
    0x10f3:
      id: url_component_name
      -orig-id: PidTagUrlComponentName
      doc: |
        PtypString. Also used as:
        * PidTagUrlCompName (PtypString)
    0x10f4:
      id: attribute_hidden
      -orig-id: PidTagAttributeHidden
      doc: PtypBoolean.
    0x10f6:
      id: attribute_read_only
      -orig-id: PidTagAttributeReadOnly
      doc: PtypBoolean.
    0x3000:
      id: rowid
      -orig-id: PidTagRowid
      doc: PtypInteger32.
    0x3001:
      id: display_name
      -orig-id: PidTagDisplayName
      doc: PtypString.
    0x3002:
      id: address_type
      -orig-id: PidTagAddressType
      doc: PtypString.
    0x3003:
      id: email_address
      -orig-id: PidTagEmailAddress
      doc: PtypString.
    0x3004:
      id: comment
      -orig-id: PidTagComment
      doc: PtypString.
    0x3005:
      id: depth
      -orig-id: PidTagDepth
      doc: PtypInteger32.
    0x3006:
      id: provider_display
      -orig-id: PidTagProviderDisplay
      doc: PtypString.
    0x3007:
      id: creation_time
      -orig-id: PidTagCreationTime
      doc: PtypTime.
    0x3008:
      id: last_modification_time
      -orig-id: PidTagLastModificationTime
      doc: PtypTime.
    0x3009:
      id: resource_flags
      -orig-id: PidTagResourceFlags
      doc: PtypInteger32.
    0x300a:
      id: provider_dll_name
      -orig-id: PidTagProviderDllName
      doc: PtypString.
    0x300b:
      id: search_key
      -orig-id: PidTagSearchKey
      doc: PtypBinary.
    0x300c:
      id: provider_uid
      -orig-id: PidTagProviderUid
      doc: PtypBinary.
    0x300d:
      id: provider_ordinal
      -orig-id: PidTagProviderOrdinal
      doc: PtypInteger32.
    0x3010:
      id: target_entry_id
      -orig-id: PidTagTargetEntryId
      doc: PtypBinary.
    0x3013:
      id: conversation_id
      -orig-id: PidTagConversationId
      doc: PtypBinary.
    0x3016:
      id: conversation_index_tracking
      -orig-id: PidTagConversationIndexTracking
      doc: PtypBoolean.
    0x3018:
      id: archive_tag
      -orig-id: PidTagArchiveTag
      doc: PtypBinary.
    0x3019:
      id: policy_tag
      -orig-id: PidTagPolicyTag
      doc: PtypBinary.
    0x301a:
      id: retention_period
      -orig-id: PidTagRetentionPeriod
      doc: PtypInteger32.
    0x301b:
      id: start_date_etc
      -orig-id: PidTagStartDateEtc
      doc: PtypBinary.
    0x301c:
      id: retention_date
      -orig-id: PidTagRetentionDate
      doc: PtypTime.
    0x301d:
      id: retention_flags
      -orig-id: PidTagRetentionFlags
      doc: PtypInteger32.
    0x301e:
      id: archive_period
      -orig-id: PidTagArchivePeriod
      doc: PtypInteger32.
    0x301f:
      id: archive_date
      -orig-id: PidTagArchiveDate
      doc: PtypTime.
    0x3301:
      id: form_version
      -orig-id: PidTagFormVersion
      doc: PtypString.
    0x3302:
      id: form_class_id
      -orig-id: PidTagFormClassId
      doc: PtypGuid.
    0x3303:
      id: form_contact_name
      -orig-id: PidTagFormContactName
      doc: PtypString.
    0x3304:
      id: form_category
      -orig-id: PidTagFormCategory
      doc: PtypString.
    0x3305:
      id: form_category_sub
      -orig-id: PidTagFormCategorySub
      doc: PtypString.
    0x3306:
      id: form_host_map
      -orig-id: PidTagFormHostMap
      doc: PtypMultipleInteger32.
    0x3307:
      id: form_hidden
      -orig-id: PidTagFormHidden
      doc: PtypBoolean.
    0x3308:
      id: form_designer_name
      -orig-id: PidTagFormDesignerName
      doc: PtypString.
    0x3309:
      id: form_designer_guid
      -orig-id: PidTagFormDesignerGuid
      doc: PtypGuid.
    0x330a:
      id: form_message_behavior
      -orig-id: PidTagFormMessageBehavior
      doc: PtypInteger32.
    0x3400:
      id: default_store
      -orig-id: PidTagDefaultStore
      doc: PtypBoolean.
    0x340d:
      id: store_support_mask
      -orig-id: PidTagStoreSupportMask
      doc: PtypInteger32.
    0x340e:
      id: store_state
      -orig-id: PidTagStoreState
      doc: PtypInteger32.
    0x340f:
      id: store_unicode_mask
      -orig-id: PidTagStoreUnicodeMask
      doc: PtypInteger32.
    0x3410:
      id: ipm_subtree_search_key
      -orig-id: PidTagIpmSubtreeSearchKey
      doc: PtypBinary.
    0x3411:
      id: ipm_outbox_search_key
      -orig-id: PidTagIpmOutboxSearchKey
      doc: PtypBinary.
    0x3412:
      id: ipm_wastebasket_search_key
      -orig-id: PidTagIpmWastebasketSearchKey
      doc: PtypBinary.
    0x3413:
      id: ipm_sent_mail_search_key
      -orig-id: PidTagIpmSentMailSearchKey
      doc: PtypBinary.
    0x3414:
      id: store_provider
      -orig-id: PidTagStoreProvider
      doc: PtypBinary.
    0x3415:
      id: receive_folder_settings
      -orig-id: PidTagReceiveFolderSettings
      doc: PtypObject.
    0x3417:
      id: provider_icon
      -orig-id: PidTagProviderIcon
      doc: PtypString.
    0x3418:
      id: provider_display_name
      -orig-id: PidTagProviderDisplayName
      doc: PtypString.
    0x35df:
      id: valid_folder_mask
      -orig-id: PidTagValidFolderMask
      doc: PtypInteger32.
    0x35e0:
      id: ipm_subtree_entry_id
      -orig-id: PidTagIpmSubtreeEntryId
      doc: PtypBinary.
    0x35e2:
      id: ipm_outbox_entry_id
      -orig-id: PidTagIpmOutboxEntryId
      doc: PtypBinary.
    0x35e3:
      id: ipm_wastebasket_entry_id
      -orig-id: PidTagIpmWastebasketEntryId
      doc: PtypBinary.
    0x35e4:
      id: ipm_sent_mail_entry_id
      -orig-id: PidTagIpmSentMailEntryId
      doc: PtypBinary.
    0x35e5:
      id: views_entry_id
      -orig-id: PidTagViewsEntryId
      doc: PtypBinary.
    0x35e6:
      id: common_views_entry_id
      -orig-id: PidTagCommonViewsEntryId
      doc: PtypBinary.
    0x35e7:
      id: finder_entry_id
      -orig-id: PidTagFinderEntryId
      doc: PtypBinary.
    0x3600:
      id: container_flags
      -orig-id: PidTagContainerFlags
      doc: PtypInteger32.
    0x3601:
      id: folder_type
      -orig-id: PidTagFolderType
      doc: PtypInteger32.
    0x3602:
      id: content_count
      -orig-id: PidTagContentCount
      doc: PtypInteger32.
    0x3603:
      id: content_unread_count
      -orig-id: PidTagContentUnreadCount
      doc: PtypInteger32.
    0x3604:
      id: create_templates
      -orig-id: PidTagCreateTemplates
      doc: PtypObject.
    0x3605:
      id: details_table
      -orig-id: PidTagDetailsTable
      doc: PtypObject.
    0x3607:
      id: search
      -orig-id: PidTagSearch
      doc: PtypObject.
    0x3609:
      id: selectable
      -orig-id: PidTagSelectable
      doc: PtypBoolean.
    0x360a:
      id: subfolders
      -orig-id: PidTagSubfolders
      doc: PtypBoolean.
    0x360b:
      id: status
      -orig-id: PidTagStatus
      doc: PtypInteger32.
    0x360c:
      id: anr
      -orig-id: PidTagAnr
      doc: PtypString.
    0x360d:
      id: content_sort_order
      -orig-id: PidTagContentSortOrder
      doc: PtypMultipleInteger32.
    0x360e:
      id: container_hierarchy
      -orig-id: PidTagContainerHierarchy
      doc: PtypObject.
    0x360f:
      id: container_contents
      -orig-id: PidTagContainerContents
      doc: PtypObject.
    0x3610:
      id: folder_associated_contents
      -orig-id: PidTagFolderAssociatedContents
      doc: PtypObject.
    0x3611:
      id: def_create_dl
      -orig-id: PidTagDefCreateDl
      doc: PtypBinary.
    0x3612:
      id: def_create_mailuser
      -orig-id: PidTagDefCreateMailuser
      doc: PtypBinary.
    0x3613:
      id: container_class
      -orig-id: PidTagContainerClass
      doc: PtypString.
    0x3614:
      id: container_modify_version
      -orig-id: PidTagContainerModifyVersion
      doc: PtypInteger64.
    0x3615:
      id: ab_provider_id
      -orig-id: PidTagAbProviderId
      doc: PtypBinary.
    0x3616:
      id: default_view_entry_id
      -orig-id: PidTagDefaultViewEntryId
      doc: PtypBinary.
    0x3617:
      id: associated_content_count
      -orig-id: PidTagAssociatedContentCount
      doc: PtypInteger32.
    0x36d0:
      id: ipm_appointment_entry_id
      -orig-id: PidTagIpmAppointmentEntryId
      doc: PtypBinary.
    0x36d1:
      id: ipm_contact_entry_id
      -orig-id: PidTagIpmContactEntryId
      doc: PtypBinary.
    0x36d2:
      id: ipm_journal_entry_id
      -orig-id: PidTagIpmJournalEntryId
      doc: PtypBinary.
    0x36d3:
      id: ipm_note_entry_id
      -orig-id: PidTagIpmNoteEntryId
      doc: PtypBinary.
    0x36d4:
      id: ipm_task_entry_id
      -orig-id: PidTagIpmTaskEntryId
      doc: PtypBinary.
    0x36d5:
      id: reminders_online_entry_id
      -orig-id: PidTagRemindersOnlineEntryId
      doc: PtypBinary.
    0x36d7:
      id: ipm_drafts_entry_id
      -orig-id: PidTagIpmDraftsEntryId
      doc: PtypBinary.
    0x36d8:
      id: additional_ren_entry_ids
      -orig-id: PidTagAdditionalRenEntryIds
      doc: PtypMultipleBinary.
    0x36d9:
      id: additional_ren_entry_ids_ex
      -orig-id: PidTagAdditionalRenEntryIdsEx
      doc: PtypBinary.
    0x36da:
      id: extended_folder_flags
      -orig-id: PidTagExtendedFolderFlags
      doc: PtypBinary.
    0x36df:
      id: folder_webviewinfo
      -orig-id: PidTagFolderWebviewinfo
      doc: PtypBinary.
    0x36e2:
      id: ordinal_most
      -orig-id: PidTagOrdinalMost
      doc: PtypInteger32.
    0x36e3:
      id: user_fields
      -orig-id: PidTagUserFields
      doc: PtypBinary.
    0x36e4:
      id: free_busy_entry_ids
      -orig-id: PidTagFreeBusyEntryIds
      doc: PtypMultipleBinary.
    0x36e5:
      id: default_post_message_class
      -orig-id: PidTagDefaultPostMessageClass
      doc: PtypString.
    0x3700:
      id: attachment_x400_parameters
      -orig-id: PidTagAttachmentX400Parameters
      doc: PtypBinary.
    0x3701:
      id: attach_data_binary
      -orig-id: PidTagAttachDataBinary
      doc: |
        PtypBinary. Also used as:
        * PidTagAttachDataObject (PtypObject)
    0x3702:
      id: attach_encoding
      -orig-id: PidTagAttachEncoding
      doc: PtypBinary.
    0x3703:
      id: attach_extension
      -orig-id: PidTagAttachExtension
      doc: PtypString.
    0x3704:
      id: attach_filename
      -orig-id: PidTagAttachFilename
      doc: PtypString.
    0x3705:
      id: attach_method
      -orig-id: PidTagAttachMethod
      doc: PtypInteger32.
    0x3707:
      id: attach_long_filename
      -orig-id: PidTagAttachLongFilename
      doc: PtypString.
    0x3708:
      id: attach_pathname
      -orig-id: PidTagAttachPathname
      doc: PtypString.
    0x3709:
      id: attach_rendering
      -orig-id: PidTagAttachRendering
      doc: PtypBinary.
    0x370a:
      id: attach_tag
      -orig-id: PidTagAttachTag
      doc: PtypBinary.
    0x370b:
      id: rendering_position
      -orig-id: PidTagRenderingPosition
      doc: PtypInteger32.
    0x370c:
      id: attach_transport_name
      -orig-id: PidTagAttachTransportName
      doc: PtypString.
    0x370d:
      id: attach_long_pathname
      -orig-id: PidTagAttachLongPathname
      doc: PtypString.
    0x370e:
      id: attach_mime_tag
      -orig-id: PidTagAttachMimeTag
      doc: PtypString.
    0x370f:
      id: attach_additional_information
      -orig-id: PidTagAttachAdditionalInformation
      doc: PtypBinary.
    0x3710:
      id: attach_mime_sequence
      -orig-id: PidTagAttachMimeSequence
      doc: PtypInteger32.
    0x3711:
      id: attach_content_base
      -orig-id: PidTagAttachContentBase
      doc: PtypString.
    0x3712:
      id: attach_content_id
      -orig-id: PidTagAttachContentId
      doc: PtypString.
    0x3713:
      id: attach_content_location
      -orig-id: PidTagAttachContentLocation
      doc: PtypString.
    0x3714:
      id: attach_flags
      -orig-id: PidTagAttachFlags
      doc: PtypInteger32.
    0x3719:
      id: attach_payload_provider_guid_string
      -orig-id: PidTagAttachPayloadProviderGuidString
      doc: PtypString.
    0x371a:
      id: attach_payload_class
      -orig-id: PidTagAttachPayloadClass
      doc: PtypString.
    0x371b:
      id: text_attachment_charset
      -orig-id: PidTagTextAttachmentCharset
      doc: PtypString.
    0x3900:
      id: display_type
      -orig-id: PidTagDisplayType
      doc: PtypInteger32.
    0x3902:
      id: templateid
      -orig-id: PidTagTemplateid
      doc: PtypBinary.
    0x3904:
      id: primary_capability
      -orig-id: PidTagPrimaryCapability
      doc: PtypBinary.
    0x3905:
      id: display_type_ex
      -orig-id: PidTagDisplayTypeEx
      doc: PtypInteger32.
    0x39fe:
      id: smtp_address
      -orig-id: PidTagSmtpAddress
      doc: PtypString.
    0x39ff:
      id: address_book_display_name_printable
      -orig-id: PidTagAddressBookDisplayNamePrintable
      doc: PtypString.
    0x3a00:
      id: account
      -orig-id: PidTagAccount
      doc: PtypString.
    0x3a01:
      id: alternate_recipient
      -orig-id: PidTagAlternateRecipient
      doc: PtypBinary.
    0x3a02:
      id: callback_telephone_number
      -orig-id: PidTagCallbackTelephoneNumber
      doc: PtypString.
    0x3a03:
      id: conversion_prohibited
      -orig-id: PidTagConversionProhibited
      doc: PtypBoolean.
    0x3a05:
      id: generation
      -orig-id: PidTagGeneration
      doc: PtypString.
    0x3a06:
      id: given_name
      -orig-id: PidTagGivenName
      doc: PtypString.
    0x3a07:
      id: government_id_number
      -orig-id: PidTagGovernmentIdNumber
      doc: PtypString.
    0x3a08:
      id: business_telephone_number
      -orig-id: PidTagBusinessTelephoneNumber
      doc: PtypString.
    0x3a09:
      id: home_telephone_number
      -orig-id: PidTagHomeTelephoneNumber
      doc: PtypString.
    0x3a0a:
      id: initials
      -orig-id: PidTagInitials
      doc: PtypString.
    0x3a0b:
      id: keyword
      -orig-id: PidTagKeyword
      doc: PtypString.
    0x3a0c:
      id: language
      -orig-id: PidTagLanguage
      doc: PtypString.
    0x3a0d:
      id: location
      -orig-id: PidTagLocation
      doc: PtypString.
    0x3a0e:
      id: mail_permission
      -orig-id: PidTagMailPermission
      doc: PtypBoolean.
    0x3a0f:
      id: message_handling_system_common_name
      -orig-id: PidTagMessageHandlingSystemCommonName
      doc: PtypString.
    0x3a10:
      id: organizational_id_number
      -orig-id: PidTagOrganizationalIdNumber
      doc: PtypString.
    0x3a11:
      id: surname
      -orig-id: PidTagSurname
      doc: PtypString.
    0x3a12:
      id: original_entry_id
      -orig-id: PidTagOriginalEntryId
      doc: PtypBinary.
    0x3a13:
      id: original_display_name
      -orig-id: PidTagOriginalDisplayName
      doc: PtypString.
    0x3a14:
      id: original_search_key
      -orig-id: PidTagOriginalSearchKey
      doc: PtypBinary.
    0x3a15:
      id: postal_address
      -orig-id: PidTagPostalAddress
      doc: PtypString.
    0x3a16:
      id: company_name
      -orig-id: PidTagCompanyName
      doc: PtypString.
    0x3a17:
      id: title
      -orig-id: PidTagTitle
      doc: PtypString.
    0x3a18:
      id: department_name
      -orig-id: PidTagDepartmentName
      doc: PtypString.
    0x3a19:
      id: office_location
      -orig-id: PidTagOfficeLocation
      doc: PtypString.
    0x3a1a:
      id: primary_telephone_number
      -orig-id: PidTagPrimaryTelephoneNumber
      doc: PtypString.
    0x3a1b:
      id: business2_telephone_number
      -orig-id: PidTagBusiness2TelephoneNumber
      doc: |
        PtypString. Also used as:
        * PidTagBusiness2TelephoneNumbers (PtypMultipleString)
    0x3a1c:
      id: mobile_telephone_number
      -orig-id: PidTagMobileTelephoneNumber
      doc: PtypString.
    0x3a1d:
      id: radio_telephone_number
      -orig-id: PidTagRadioTelephoneNumber
      doc: PtypString.
    0x3a1e:
      id: car_telephone_number
      -orig-id: PidTagCarTelephoneNumber
      doc: PtypString.
    0x3a1f:
      id: other_telephone_number
      -orig-id: PidTagOtherTelephoneNumber
      doc: PtypString.
    0x3a20:
      id: transmittable_display_name
      -orig-id: PidTagTransmittableDisplayName
      doc: PtypString.
    0x3a21:
      id: pager_telephone_number
      -orig-id: PidTagPagerTelephoneNumber
      doc: PtypString.
    0x3a22:
      id: user_certificate
      -orig-id: PidTagUserCertificate
      doc: PtypBinary.
    0x3a23:
      id: primary_fax_number
      -orig-id: PidTagPrimaryFaxNumber
      doc: PtypString.
    0x3a24:
      id: business_fax_number
      -orig-id: PidTagBusinessFaxNumber
      doc: PtypString.
    0x3a25:
      id: home_fax_number
      -orig-id: PidTagHomeFaxNumber
      doc: PtypString.
    0x3a26:
      id: country
      -orig-id: PidTagCountry
      doc: PtypString.
    0x3a27:
      id: locality
      -orig-id: PidTagLocality
      doc: PtypString.
    0x3a28:
      id: state_or_province
      -orig-id: PidTagStateOrProvince
      doc: PtypString.
    0x3a29:
      id: street_address
      -orig-id: PidTagStreetAddress
      doc: PtypString.
    0x3a2a:
      id: postal_code
      -orig-id: PidTagPostalCode
      doc: PtypString.
    0x3a2b:
      id: post_office_box
      -orig-id: PidTagPostOfficeBox
      doc: PtypString.
    0x3a2c:
      id: telex_number
      -orig-id: PidTagTelexNumber
      doc: PtypString.
    0x3a2d:
      id: isdn_number
      -orig-id: PidTagIsdnNumber
      doc: PtypString.
    0x3a2e:
      id: assistant_telephone_number
      -orig-id: PidTagAssistantTelephoneNumber
      doc: PtypString.
    0x3a2f:
      id: home2_telephone_number
      -orig-id: PidTagHome2TelephoneNumber
      doc: |
        PtypString. Also used as:
        * PidTagHome2TelephoneNumbers (PtypMultipleString)
    0x3a30:
      id: assistant
      -orig-id: PidTagAssistant
      doc: PtypString.
    0x3a40:
      id: send_rich_info
      -orig-id: PidTagSendRichInfo
      doc: PtypBoolean.
    0x3a41:
      id: wedding_anniversary
      -orig-id: PidTagWeddingAnniversary
      doc: PtypTime.
    0x3a42:
      id: birthday
      -orig-id: PidTagBirthday
      doc: PtypTime.
    0x3a43:
      id: hobbies
      -orig-id: PidTagHobbies
      doc: PtypString.
    0x3a44:
      id: middle_name
      -orig-id: PidTagMiddleName
      doc: PtypString.
    0x3a45:
      id: display_name_prefix
      -orig-id: PidTagDisplayNamePrefix
      doc: PtypString.
    0x3a46:
      id: profession
      -orig-id: PidTagProfession
      doc: PtypString.
    0x3a47:
      id: preferred_by_name
      -orig-id: PidTagPreferredByName
      doc: |
        PtypString. Also used as:
        * PidTagReferredByName (PtypString)
    0x3a48:
      id: spouse_name
      -orig-id: PidTagSpouseName
      doc: PtypString.
    0x3a49:
      id: computer_network_name
      -orig-id: PidTagComputerNetworkName
      doc: PtypString.
    0x3a4a:
      id: customer_id
      -orig-id: PidTagCustomerId
      doc: PtypString.
    0x3a4b:
      id: telecommunications_device_for_deaf_telephone_number
      -orig-id: PidTagTelecommunicationsDeviceForDeafTelephoneNumber
      doc: PtypString.
    0x3a4c:
      id: ftp_site
      -orig-id: PidTagFtpSite
      doc: PtypString.
    0x3a4d:
      id: gender
      -orig-id: PidTagGender
      doc: PtypInteger16.
    0x3a4e:
      id: manager_name
      -orig-id: PidTagManagerName
      doc: PtypString.
    0x3a4f:
      id: nickname
      -orig-id: PidTagNickname
      doc: PtypString.
    0x3a50:
      id: personal_home_page
      -orig-id: PidTagPersonalHomePage
      doc: PtypString.
    0x3a51:
      id: business_home_page
      -orig-id: PidTagBusinessHomePage
      doc: PtypString.
    0x3a52:
      id: contact_version
      -orig-id: PidTagContactVersion
      doc: PtypGuid.
    0x3a54:
      id: contact_address_types
      -orig-id: PidTagContactAddressTypes
      doc: PtypMultipleString.
    0x3a57:
      id: company_main_telephone_number
      -orig-id: PidTagCompanyMainTelephoneNumber
      doc: PtypString.
    0x3a58:
      id: childrens_names
      -orig-id: PidTagChildrensNames
      doc: PtypMultipleString.
    0x3a59:
      id: home_address_city
      -orig-id: PidTagHomeAddressCity
      doc: PtypString.
    0x3a5a:
      id: home_address_country
      -orig-id: PidTagHomeAddressCountry
      doc: PtypString.
    0x3a5b:
      id: home_address_postal_code
      -orig-id: PidTagHomeAddressPostalCode
      doc: PtypString.
    0x3a5c:
      id: home_address_state_or_province
      -orig-id: PidTagHomeAddressStateOrProvince
      doc: PtypString.
    0x3a5d:
      id: home_address_street
      -orig-id: PidTagHomeAddressStreet
      doc: PtypString.
    0x3a5e:
      id: home_address_post_office_box
      -orig-id: PidTagHomeAddressPostOfficeBox
      doc: PtypString.
    0x3a5f:
      id: other_address_city
      -orig-id: PidTagOtherAddressCity
      doc: PtypString.
    0x3a60:
      id: other_address_country
      -orig-id: PidTagOtherAddressCountry
      doc: PtypString.
    0x3a61:
      id: other_address_postal_code
      -orig-id: PidTagOtherAddressPostalCode
      doc: PtypString.
    0x3a62:
      id: other_address_state_or_province
      -orig-id: PidTagOtherAddressStateOrProvince
      doc: PtypString.
    0x3a63:
      id: other_address_street
      -orig-id: PidTagOtherAddressStreet
      doc: PtypString.
    0x3a64:
      id: other_address_post_office_box
      -orig-id: PidTagOtherAddressPostOfficeBox
      doc: PtypString.
    0x3a70:
      id: user_x509_certificate
      -orig-id: PidTagUserX509Certificate
      doc: PtypMultipleBinary.
    0x3a71:
      id: send_internet_encoding
      -orig-id: PidTagSendInternetEncoding
      doc: PtypInteger32.
    0x3d00:
      id: store_providers
      -orig-id: PidTagStoreProviders
      doc: PtypBinary.
    0x3d01:
      id: ab_providers
      -orig-id: PidTagAbProviders
      doc: PtypBinary.
    0x3d02:
      id: transport_providers
      -orig-id: PidTagTransportProviders
      doc: PtypBinary.
    0x3d04:
      id: default_profile
      -orig-id: PidTagDefaultProfile
      doc: PtypBoolean.
    0x3d05:
      id: ab_search_path
      -orig-id: PidTagAbSearchPath
      doc: PtypMultipleBinary.
    0x3d06:
      id: ab_default_dir
      -orig-id: PidTagAbDefaultDir
      doc: PtypBinary.
    0x3d07:
      id: ab_default_pab
      -orig-id: PidTagAbDefaultPab
      doc: PtypBinary.
    0x3d08:
      id: filtering_hooks
      -orig-id: PidTagFilteringHooks
      doc: PtypBinary.
    0x3d09:
      id: service_name
      -orig-id: PidTagServiceName
      doc: PtypString.
    0x3d0a:
      id: service_dll_name
      -orig-id: PidTagServiceDllName
      doc: PtypString.
    0x3d0b:
      id: service_entry_name
      -orig-id: PidTagServiceEntryName
      doc: PtypString.
    0x3d0c:
      id: service_uid
      -orig-id: PidTagServiceUid
      doc: PtypBinary.
    0x3d0d:
      id: service_extra_uids
      -orig-id: PidTagServiceExtraUids
      doc: PtypBinary.
    0x3d0e:
      id: services
      -orig-id: PidTagServices
      doc: PtypBinary.
    0x3d0f:
      id: service_support_files
      -orig-id: PidTagServiceSupportFiles
      doc: PtypMultipleString.
    0x3d10:
      id: service_delete_files
      -orig-id: PidTagServiceDeleteFiles
      doc: PtypMultipleString.
    0x3d11:
      id: ab_search_path_update
      -orig-id: PidTagAbSearchPathUpdate
      doc: PtypBinary.
    0x3d12:
      id: profile_name
      -orig-id: PidTagProfileName
      doc: PtypString.
    0x3d13:
      id: service_install_id
      -orig-id: PidTagServiceInstallId
      doc: PtypString.
    0x3d15:
      id: exchange_profile_section_id
      -orig-id: PidTagExchangeProfileSectionId
      doc: PtypBinary.
    0x3d1b:
      id: ab_search_path_customization
      -orig-id: PidTagAbSearchPathCustomization
      doc: PtypInteger32.
    0x3d1c:
      id: ab_choose_directory_automatically
      -orig-id: PidTagAbChooseDirectoryAutomatically
      doc: PtypBoolean.
    0x3e00:
      id: identity_display
      -orig-id: PidTagIdentityDisplay
      doc: PtypString.
    0x3e01:
      id: identity_entry_id
      -orig-id: PidTagIdentityEntryId
      doc: PtypBinary.
    0x3e02:
      id: resource_methods
      -orig-id: PidTagResourceMethods
      doc: PtypInteger32.
    0x3e03:
      id: resource_type
      -orig-id: PidTagResourceType
      doc: PtypInteger32.
    0x3e04:
      id: status_code
      -orig-id: PidTagStatusCode
      doc: PtypInteger32.
    0x3e05:
      id: identity_search_key
      -orig-id: PidTagIdentitySearchKey
      doc: PtypBinary.
    0x3e06:
      id: own_store_entry_id
      -orig-id: PidTagOwnStoreEntryId
      doc: PtypBinary.
    0x3e07:
      id: resource_path
      -orig-id: PidTagResourcePath
      doc: PtypString.
    0x3e08:
      id: status_string
      -orig-id: PidTagStatusString
      doc: PtypString.
    0x3e09:
      id: x400_deferred_delivery_cancel
      -orig-id: PidTagX400DeferredDeliveryCancel
      doc: PtypBoolean.
    0x3e0a:
      id: header_folder_entry_id
      -orig-id: PidTagHeaderFolderEntryId
      doc: PtypBinary.
    0x3e0b:
      id: remote_progress
      -orig-id: PidTagRemoteProgress
      doc: PtypInteger32.
    0x3e0c:
      id: remote_progress_text
      -orig-id: PidTagRemoteProgressText
      doc: PtypString.
    0x3e0d:
      id: remote_validate_ok
      -orig-id: PidTagRemoteValidateOk
      doc: PtypBoolean.
    0x3f00:
      id: control_flags
      -orig-id: PidTagControlFlags
      doc: PtypInteger32.
    0x3f01:
      id: control_structure
      -orig-id: PidTagControlStructure
      doc: PtypBinary.
    0x3f02:
      id: control_type
      -orig-id: PidTagControlType
      doc: PtypInteger32.
    0x3f03:
      id: delta_x
      -orig-id: PidTagDeltaX
      doc: PtypInteger32.
    0x3f04:
      id: delta_y
      -orig-id: PidTagDeltaY
      doc: PtypInteger32.
    0x3f05:
      id: x_coordinate
      -orig-id: PidTagXCoordinate
      doc: PtypInteger32.
    0x3f06:
      id: y_coordinate
      -orig-id: PidTagYCoordinate
      doc: PtypInteger32.
    0x3f07:
      id: control_id
      -orig-id: PidTagControlId
      doc: PtypBinary.
    0x3f08:
      id: initial_details_pane
      -orig-id: PidTagInitialDetailsPane
      doc: PtypInteger32.
    0x3f20:
      id: temporary_default_document
      -orig-id: PidTagTemporaryDefaultDocument
      doc: PtypString.
    0x3fde:
      id: internet_codepage
      -orig-id: PidTagInternetCodepage
      doc: PtypInteger32.
    0x3fdf:
      id: auto_response_suppress
      -orig-id: PidTagAutoResponseSuppress
      doc: PtypInteger32.
    0x3fe0:
      id: access_control_list_table
      -orig-id: PidTagAccessControlListTable
      doc: |
        PtypObject. Also used as:
        * PidTagAccessControlListData (PtypBinary)
    0x3fe1:
      id: rules_table
      -orig-id: PidTagRulesTable
      doc: PtypObject.
    0x3fe3:
      id: delegated_by_rule
      -orig-id: PidTagDelegatedByRule
      doc: PtypBoolean.
    0x3fe7:
      id: resolve_method
      -orig-id: PidTagResolveMethod
      doc: PtypInteger32.
    0x3fea:
      id: has_deferred_action_messages
      -orig-id: PidTagHasDeferredActionMessages
      doc: PtypBoolean.
    0x3feb:
      id: deferred_send_number
      -orig-id: PidTagDeferredSendNumber
      doc: PtypInteger32.
    0x3fec:
      id: deferred_send_units
      -orig-id: PidTagDeferredSendUnits
      doc: PtypInteger32.
    0x3fed:
      id: expiry_number
      -orig-id: PidTagExpiryNumber
      doc: PtypInteger32.
    0x3fee:
      id: expiry_units
      -orig-id: PidTagExpiryUnits
      doc: PtypInteger32.
    0x3fef:
      id: deferred_send_time
      -orig-id: PidTagDeferredSendTime
      doc: PtypTime.
    0x3ff0:
      id: conflict_entry_id
      -orig-id: PidTagConflictEntryId
      doc: PtypBinary.
    0x3ff1:
      id: message_locale_id
      -orig-id: PidTagMessageLocaleId
      doc: PtypInteger32.
    0x3ff8:
      id: creator_name
      -orig-id: PidTagCreatorName
      doc: PtypString.
    0x3ff9:
      id: creator_entry_id
      -orig-id: PidTagCreatorEntryId
      doc: PtypBinary.
    0x3ffa:
      id: last_modifier_name
      -orig-id: PidTagLastModifierName
      doc: PtypString.
    0x3ffb:
      id: last_modifier_entry_id
      -orig-id: PidTagLastModifierEntryId
      doc: PtypBinary.
    0x3ffd:
      id: message_codepage
      -orig-id: PidTagMessageCodepage
      doc: PtypInteger32.
    0x401a:
      id: sent_representing_flags
      -orig-id: PidTagSentRepresentingFlags
      doc: PtypInteger32.
    0x4029:
      id: read_receipt_address_type
      -orig-id: PidTagReadReceiptAddressType
      doc: PtypString.
    0x402a:
      id: read_receipt_email_address
      -orig-id: PidTagReadReceiptEmailAddress
      doc: PtypString.
    0x402b:
      id: read_receipt_name
      -orig-id: PidTagReadReceiptName
      doc: PtypString.
    0x403e:
      id: org_email_address
      -orig-id: PidTagOrgEmailAddress
      doc: PtypString.
    0x4076:
      id: content_filter_spam_confidence_level
      -orig-id: PidTagContentFilterSpamConfidenceLevel
      doc: PtypInteger32.
    0x4079:
      id: sender_id_status
      -orig-id: PidTagSenderIdStatus
      doc: PtypInteger32.
    0x4082:
      id: hier_rev
      -orig-id: PidTagHierRev
      doc: PtypTime.
    0x4083:
      id: purported_sender_domain
      -orig-id: PidTagPurportedSenderDomain
      doc: PtypString.
    0x5902:
      id: internet_mail_override_format
      -orig-id: PidTagInternetMailOverrideFormat
      doc: PtypInteger32.
    0x5909:
      id: message_editor_format
      -orig-id: PidTagMessageEditorFormat
      doc: PtypInteger32.
    0x5d01:
      id: sender_smtp_address
      -orig-id: PidTagSenderSmtpAddress
      doc: PtypString.
    0x5d02:
      id: sent_representing_smtp_address
      -orig-id: PidTagSentRepresentingSmtpAddress
      doc: PtypString.
    0x5d05:
      id: read_receipt_smtp_address
      -orig-id: PidTagReadReceiptSmtpAddress
      doc: PtypString.
    0x5d07:
      id: received_by_smtp_address
      -orig-id: PidTagReceivedBySmtpAddress
      doc: PtypString.
    0x5d08:
      id: received_representing_smtp_address
      -orig-id: PidTagReceivedRepresentingSmtpAddress
      doc: PtypString.
    0x5fde:
      id: recipient_resource_state
      -orig-id: PidTagRecipientResourceState
      doc: PtypInteger32.
    0x5fdf:
      id: recipient_order
      -orig-id: PidTagRecipientOrder
      doc: PtypInteger32.
    0x5fe1:
      id: recipient_proposed
      -orig-id: PidTagRecipientProposed
      doc: PtypBoolean.
    0x5fe3:
      id: recipient_proposed_start_time
      -orig-id: PidTagRecipientProposedStartTime
      doc: PtypTime.
    0x5fe4:
      id: recipient_proposed_end_time
      -orig-id: PidTagRecipientProposedEndTime
      doc: PtypTime.
    0x5ff6:
      id: recipient_display_name
      -orig-id: PidTagRecipientDisplayName
      doc: PtypString.
    0x5ff7:
      id: recipient_entry_id
      -orig-id: PidTagRecipientEntryId
      doc: PtypBinary.
    0x5ffb:
      id: recipient_track_status_time
      -orig-id: PidTagRecipientTrackStatusTime
      doc: PtypTime.
    0x5ffd:
      id: recipient_flags
      -orig-id: PidTagRecipientFlags
      doc: PtypInteger32.
    0x5fff:
      id: recipient_track_status
      -orig-id: PidTagRecipientTrackStatus
      doc: PtypInteger32.
    0x6001:
      id: nick_name
      -orig-id: PR_NICK_NAME_W
      doc: NK2 only, PtypString.
    0x6003:
      id: dropdown_display_name
      -orig-id: PR_DROPDOWN_DISPLAY_NAME_W
      doc: NK2 only, PtypString.
    0x6004:
      id: nickname_weight
      -orig-id: PR_NICKNAME_WEIGHT
      doc: NK2 only, PtypInteger32.
    0x6100:
      id: junk_include_contacts
      -orig-id: PidTagJunkIncludeContacts
      doc: PtypInteger32.
    0x6101:
      id: junk_threshold
      -orig-id: PidTagJunkThreshold
      doc: PtypInteger32.
    0x6102:
      id: junk_permanently_delete
      -orig-id: PidTagJunkPermanentlyDelete
      doc: PtypInteger32.
    0x6103:
      id: junk_add_recipients_to_safe_senders_list
      -orig-id: PidTagJunkAddRecipientsToSafeSendersList
      doc: PtypInteger32.
    0x6107:
      id: junk_phishing_enable_links
      -orig-id: PidTagJunkPhishingEnableLinks
      doc: PtypBoolean.
    0x64f0:
      id: mime_skeleton
      -orig-id: PidTagMimeSkeleton
      doc: PtypBinary.
    0x65c2:
      id: reply_template_id
      -orig-id: PidTagReplyTemplateId
      doc: PtypBinary.
    0x65c6:
      id: secure_submit_flags
      -orig-id: PidTagSecureSubmitFlags
      doc: PtypInteger32.
    0x65e0:
      id: source_key
      -orig-id: PidTagSourceKey
      doc: PtypBinary.
    0x65e1:
      id: parent_source_key
      -orig-id: PidTagParentSourceKey
      doc: PtypBinary.
    0x65e2:
      id: change_key
      -orig-id: PidTagChangeKey
      doc: PtypBinary.
    0x65e3:
      id: predecessor_change_list
      -orig-id: PidTagPredecessorChangeList
      doc: PtypBinary.
    0x65e9:
      id: rule_message_state
      -orig-id: PidTagRuleMessageState
      doc: PtypInteger32.
    0x65ea:
      id: rule_message_user_flags
      -orig-id: PidTagRuleMessageUserFlags
      doc: PtypInteger32.
    0x65eb:
      id: rule_message_provider
      -orig-id: PidTagRuleMessageProvider
      doc: |
        PtypString. Also used as:
        * PidTagRuleMsgProvider (PtypString)
    0x65ec:
      id: rule_message_name
      -orig-id: PidTagRuleMessageName
      doc: |
        PtypString. Also used as:
        * PidTagRuleMsgName (PtypString)
    0x65ed:
      id: rule_message_level
      -orig-id: PidTagRuleMessageLevel
      doc: PtypInteger32.
    0x65ee:
      id: rule_message_provider_data
      -orig-id: PidTagRuleMessageProviderData
      doc: PtypBinary.
    0x65f3:
      id: rule_message_sequence
      -orig-id: PidTagRuleMessageSequence
      doc: PtypInteger32.
    0x6601:
      id: contact_address_book_uid
      -orig-id: PidTagContactAddressBookUid
      doc: PtypBinary.
    0x6602:
      id: contact_address_book_sort_flag
      -orig-id: PidTagContactAddressBookSortFlag
      doc: PtypBoolean.
    0x660a:
      id: profile_type
      -orig-id: PidTagProfileType
      doc: PtypInteger32.
    0x6610:
      id: contact_address_book_folder_entry_id
      -orig-id: PidTagContactAddressBookFolderEntryId
      doc: PtypBinary.
    0x6611:
      id: contact_address_book_store_support_mask
      -orig-id: PidTagContactAddressBookStoreSupportMask
      doc: PtypInteger32.
    0x6612:
      id: contact_address_book_store_name
      -orig-id: PidTagContactAddressBookStoreName
      doc: PtypString8.
    0x6613:
      id: contact_address_book_folder_name
      -orig-id: PidTagContactAddressBookFolderName
      doc: PtypString8.
    0x6614:
      id: contact_address_book_multiple_address_flag
      -orig-id: PidTagContactAddressBookMultipleAddressFlag
      doc: PtypBoolean.
    0x6619:
      id: user_entry_id
      -orig-id: PidTagUserEntryId
      doc: PtypBinary.
    0x661b:
      id: mailbox_owner_entry_id
      -orig-id: PidTagMailboxOwnerEntryId
      doc: PtypBinary.
    0x661c:
      id: mailbox_owner_name
      -orig-id: PidTagMailboxOwnerName
      doc: PtypString.
    0x661d:
      id: out_of_office_state
      -orig-id: PidTagOutOfOfficeState
      doc: |
        PtypBoolean. Also used as:
        * PidTagPstBestBodyProptag (PtypInteger32)
    0x6620:
      id: non_ipm_subtree_entry_id
      -orig-id: PidTagNonIpmSubtreeEntryId
      doc: |
        PtypBinary. Also used as:
        * PidTagContactAddressBookFolderEntryIds (PtypMultipleBinary)
    0x6621:
      id: contact_address_book_store_support_masks
      -orig-id: PidTagContactAddressBookStoreSupportMasks
      doc: PtypMultipleInteger32.
    0x6622:
      id: contact_address_book_store_names
      -orig-id: PidTagContactAddressBookStoreNames
      doc: |
        PtypMultipleString8. Also used as:
        * PidTagSchedulePlusFreeBusyEntryId (PtypBinary)
    0x6623:
      id: contact_address_book_folder_names
      -orig-id: PidTagContactAddressBookFolderNames
      doc: PtypMultipleString8.
    0x6624:
      id: contact_address_book_display_names
      -orig-id: PidTagContactAddressBookDisplayNames
      doc: PtypMultipleString8.
    0x6625:
      id: contact_address_book_multiple_address_flags
      -orig-id: PidTagContactAddressBookMultipleAddressFlags
      doc: PtypMultipleInteger32.
    0x6626:
      id: contact_address_book_store_entry_ids
      -orig-id: PidTagContactAddressBookStoreEntryIds
      doc: PtypMultipleBinary.
    0x6633:
      id: pst_lr_no_restrictions
      -orig-id: PidTagPstLrNoRestrictions
      doc: PtypBoolean.
    0x6635:
      id: profile_oab_count_attempted_fulldn
      -orig-id: PidTagProfileOabCountAttemptedFulldn
      doc: |
        PtypInteger32. Also used as:
        * PidTagPstHiddenCount (PtypInteger32)
    0x6636:
      id: pst_hidden_unread
      -orig-id: PidTagPstHiddenUnread
      doc: |
        PtypInteger32. Also used as:
        * PidTagProfileOabCountAttemptedIncrdn (PtypInteger32)
    0x6638:
      id: serialized_replid_guid_map
      -orig-id: PidTagSerializedReplidGuidMap
      doc: PtypBinary.
    0x6639:
      id: rights
      -orig-id: PidTagRights
      doc: PtypInteger32.
    0x663a:
      id: has_rules
      -orig-id: PidTagHasRules
      doc: PtypBoolean.
    0x663b:
      id: address_book_entry_id
      -orig-id: PidTagAddressBookEntryId
      doc: PtypBinary.
    0x663e:
      id: hierarchy_change_number
      -orig-id: PidTagHierarchyChangeNumber
      doc: PtypInteger32.
    0x6645:
      id: client_actions
      -orig-id: PidTagClientActions
      doc: PtypBinary.
    0x6646:
      id: dam_original_entry_id
      -orig-id: PidTagDamOriginalEntryId
      doc: PtypBinary.
    0x6647:
      id: dam_back_patched
      -orig-id: PidTagDamBackPatched
      doc: PtypBoolean.
    0x6648:
      id: rule_error
      -orig-id: PidTagRuleError
      doc: PtypInteger32.
    0x6649:
      id: rule_action_type
      -orig-id: PidTagRuleActionType
      doc: PtypInteger32.
    0x664a:
      id: has_named_properties
      -orig-id: PidTagHasNamedProperties
      doc: PtypBoolean.
    0x6650:
      id: rule_action_number
      -orig-id: PidTagRuleActionNumber
      doc: PtypInteger32.
    0x6651:
      id: rule_folder_entry_id
      -orig-id: PidTagRuleFolderEntryId
      doc: PtypBinary.
    0x6662:
      id: recipient_number
      -orig-id: PidTagRecipientNumber
      doc: PtypInteger32.
    0x666a:
      id: prohibit_receive_quota
      -orig-id: PidTagProhibitReceiveQuota
      doc: PtypInteger32.
    0x666c:
      id: in_conflict
      -orig-id: PidTagInConflict
      doc: PtypBoolean.
    0x666d:
      id: maximum_submit_message_size
      -orig-id: PidTagMaximumSubmitMessageSize
      doc: PtypInteger32.
    0x666e:
      id: prohibit_send_quota
      -orig-id: PidTagProhibitSendQuota
      doc: PtypInteger32.
    0x6670:
      id: long_term_entry_id_from_table
      -orig-id: PidTagLongTermEntryIdFromTable
      doc: PtypBinary.
    0x6671:
      id: member_id
      -orig-id: PidTagMemberId
      doc: |
        PtypInteger64. Also used as:
        * PidTagShortTermEntryIdFromObject (PtypBinary)
    0x6672:
      id: short_term_parent_entry_id_from_object
      -orig-id: PidTagShortTermParentEntryIdFromObject
      doc: |
        PtypBinary. Also used as:
        * PidTagMemberName (PtypString)
    0x6673:
      id: member_rights
      -orig-id: PidTagMemberRights
      doc: PtypInteger32.
    0x6674:
      id: rule_id
      -orig-id: PidTagRuleId
      doc: PtypInteger64.
    0x6675:
      id: rule_ids
      -orig-id: PidTagRuleIds
      doc: PtypBinary.
    0x6676:
      id: rule_sequence
      -orig-id: PidTagRuleSequence
      doc: PtypInteger32.
    0x6677:
      id: rule_state
      -orig-id: PidTagRuleState
      doc: PtypInteger32.
    0x6678:
      id: rule_user_flags
      -orig-id: PidTagRuleUserFlags
      doc: PtypInteger32.
    0x6679:
      id: rule_condition
      -orig-id: PidTagRuleCondition
      doc: PtypRestriction.
    0x6680:
      id: rule_actions
      -orig-id: PidTagRuleActions
      doc: PtypRuleAction.
    0x6681:
      id: rule_provider
      -orig-id: PidTagRuleProvider
      doc: PtypString.
    0x6682:
      id: rule_name
      -orig-id: PidTagRuleName
      doc: PtypString.
    0x6683:
      id: rule_level
      -orig-id: PidTagRuleLevel
      doc: PtypInteger32.
    0x6684:
      id: rule_provider_data
      -orig-id: PidTagRuleProviderData
      doc: PtypBinary.
    0x668f:
      id: deleted_on
      -orig-id: PidTagDeletedOn
      doc: PtypTime.
    0x66a1:
      id: locale_id
      -orig-id: PidTagLocaleId
      doc: PtypInteger32.
    0x66a8:
      id: folder_flags
      -orig-id: PidTagFolderFlags
      doc: PtypInteger32.
    0x66b3:
      id: normal_message_size
      -orig-id: PidTagNormalMessageSize
      doc: PtypInteger32.
    0x66c3:
      id: code_page_id
      -orig-id: PidTagCodePageId
      doc: PtypInteger32.
    0x66fa:
      id: latest_pst_ensure
      -orig-id: PidTagLatestPstEnsure
      doc: PtypInteger32.
    0x6700:
      id: pst_path
      -orig-id: PidTagPstPath
      doc: |
        PtypString. Also used as:
        * PidTagWizardNoPstPage (PtypBoolean)
    0x6701:
      id: pst_remember_password
      -orig-id: PidTagPstRememberPassword
      doc: |
        PtypBoolean. Also used as:
        * PidTagWizardNoPabPage (PtypBoolean)
    0x6703:
      id: pst_password_sz_old
      -orig-id: PidTagPstPasswordSzOld
      doc: PtypString.
    0x6704:
      id: pst_password_sz_new
      -orig-id: PidTagPstPasswordSzNew
      doc: |
        PtypString. Also used as:
        * PidTagAddressBookManageDistributionList (PtypObject)
    0x6705:
      id: sort_locale_id
      -orig-id: PidTagSortLocaleId
      doc: |
        PtypInteger32. Also used as:
        * PidTagPstIpmsubTreeDescendant (PtypBoolean)
    0x6707:
      id: url_name
      -orig-id: PidTagUrlName
      doc: PtypString.
    0x6708:
      id: subfolder
      -orig-id: PidTagSubfolder
      doc: PtypBoolean.
    0x6709:
      id: local_commit_time
      -orig-id: PidTagLocalCommitTime
      doc: PtypTime.
    0x670a:
      id: local_commit_time_max
      -orig-id: PidTagLocalCommitTimeMax
      doc: PtypTime.
    0x670b:
      id: deleted_count_total
      -orig-id: PidTagDeletedCountTotal
      doc: PtypInteger32.
    0x670e:
      id: flat_url_name
      -orig-id: PidTagFlatUrlName
      doc: PtypString.
    0x671c:
      id: public_folder_administrative_description
      -orig-id: PidTagPublicFolderAdministrativeDescription
      doc: PtypString.
    0x671d:
      id: public_folder_proxy
      -orig-id: PidTagPublicFolderProxy
      doc: PtypBinary.
    0x6740:
      id: sent_mail_svr_eid
      -orig-id: PidTagSentMailSvrEID
      doc: PtypServerId.
    0x6741:
      id: deferred_action_message_original_entry_id
      -orig-id: PidTagDeferredActionMessageOriginalEntryId
      doc: PtypServerId.
    0x6748:
      id: folder_id
      -orig-id: PidTagFolderId
      doc: PtypInteger64.
    0x6749:
      id: parent_folder_id
      -orig-id: PidTagParentFolderId
      doc: PtypInteger64.
    0x674a:
      id: mid
      -orig-id: PidTagMid
      doc: PtypInteger64.
    0x674d:
      id: inst_id
      -orig-id: PidTagInstID
      doc: PtypInteger64.
    0x674e:
      id: instance_num
      -orig-id: PidTagInstanceNum
      doc: PtypInteger32.
    0x674f:
      id: address_book_message_id
      -orig-id: PidTagAddressBookMessageId
      doc: PtypInteger64.
    0x6770:
      id: pst_configuration_flags
      -orig-id: PidTagPstConfigurationFlags
      doc: PtypInteger32.
    0x6771:
      id: pst_path_hint
      -orig-id: PidTagPstPathHint
      doc: PtypString.
    0x6772:
      id: pst_sub_tree_container
      -orig-id: PidTagPstSubTreeContainer
      doc: PtypInteger32.
    0x67a4:
      id: change_number
      -orig-id: PidTagChangeNumber
      doc: PtypInteger64.
    0x67aa:
      id: associated
      -orig-id: PidTagAssociated
      doc: PtypBoolean.
    0x67f1:
      id: ltp_parent_nid
      -orig-id: PidTagLtpParentNid
      doc: PtypInteger32.
    0x67f2:
      id: ltp_row_id
      -orig-id: PidTagLtpRowId
      doc: PtypInteger32.
    0x67f3:
      id: ltp_row_ver
      -orig-id: PidTagLtpRowVer
      doc: PtypInteger32.
    0x67ff:
      id: pst_password
      -orig-id: PidTagPstPassword
      doc: PtypInteger32.
    0x6800:
      id: offline_address_book_name
      -orig-id: PidTagOfflineAddressBookName
      doc: PtypString.
    0x6801:
      id: offline_address_book_sequence
      -orig-id: PidTagOfflineAddressBookSequence
      doc: |
        PtypInteger32. Also used as:
        * PidTagVoiceMessageDuration (PtypInteger32)
    0x6802:
      id: offline_address_book_container_guid
      -orig-id: PidTagOfflineAddressBookContainerGuid
      doc: |
        PtypString8. Also used as:
        * PidTagSenderTelephoneNumber (PtypString)
        * PidTagRwRulesStream (PtypBinary)
    0x6803:
      id: send_outlook_recall_report
      -orig-id: PidTagSendOutlookRecallReport
      doc: |
        PtypBoolean. Also used as:
        * PidTagOfflineAddressBookMessageClass (PtypInteger32)
        * PidTagVoiceMessageSenderName (PtypString)
    0x6804:
      id: offline_address_book_distinguished_name
      -orig-id: PidTagOfflineAddressBookDistinguishedName
      doc: |
        PtypString8. Also used as:
        * PidTagFaxNumberOfPages (PtypInteger32)
    0x6805:
      id: offline_address_book_truncated_properties
      -orig-id: PidTagOfflineAddressBookTruncatedProperties
      doc: |
        PtypMultipleInteger32. Also used as:
        * PidTagVoiceMessageAttachmentOrder (PtypString)
    0x6806:
      id: call_id
      -orig-id: PidTagCallId
      doc: PtypString.
    0x6820:
      id: reporting_message_transfer_agent
      -orig-id: PidTagReportingMessageTransferAgent
      doc: PtypString.
    0x682f:
      id: mapi_form_compose_command
      -orig-id: PidTagMapiFormComposeCommand
      doc: PtypString.
    0x6834:
      id: search_folder_last_used
      -orig-id: PidTagSearchFolderLastUsed
      doc: PtypInteger32.
    0x683a:
      id: search_folder_expiration
      -orig-id: PidTagSearchFolderExpiration
      doc: PtypInteger32.
    0x6841:
      id: search_folder_template_id
      -orig-id: PidTagSearchFolderTemplateId
      doc: |
        PtypInteger32. Also used as:
        * PidTagScheduleInfoResourceType (PtypInteger32)
    0x6842:
      id: schedule_info_delegator_wants_copy
      -orig-id: PidTagScheduleInfoDelegatorWantsCopy
      doc: |
        PtypBoolean. Also used as:
        * PidTagSearchFolderId (PtypBinary)
        * PidTagWlinkGroupHeaderID (PtypBinary)
    0x6843:
      id: schedule_info_dont_mail_delegates
      -orig-id: PidTagScheduleInfoDontMailDelegates
      doc: PtypBoolean.
    0x6844:
      id: search_folder_recreate_info
      -orig-id: PidTagSearchFolderRecreateInfo
      doc: |
        PtypBinary. Also used as:
        * PidTagScheduleInfoDelegateNames (PtypMultipleString)
    0x6845:
      id: search_folder_definition
      -orig-id: PidTagSearchFolderDefinition
      doc: |
        PtypBinary. Also used as:
        * PidTagScheduleInfoDelegateEntryIds (PtypMultipleBinary)
    0x6846:
      id: search_folder_storage_type
      -orig-id: PidTagSearchFolderStorageType
      doc: |
        PtypInteger32. Also used as:
        * PidTagGatewayNeedsToRefresh (PtypBoolean)
    0x6847:
      id: search_folder_tag
      -orig-id: PidTagSearchFolderTag
      doc: |
        PtypInteger32. Also used as:
        * PidTagFreeBusyPublishStart (PtypInteger32)
        * PidTagWlinkSaveStamp (PtypInteger32)
    0x6848:
      id: search_folder_efp_flags
      -orig-id: PidTagSearchFolderEfpFlags
      doc: |
        PtypInteger32. Also used as:
        * PidTagFreeBusyPublishEnd (PtypInteger32)
    0x6849:
      id: wlink_type
      -orig-id: PidTagWlinkType
      doc: |
        PtypInteger32. Also used as:
        * PidTagFreeBusyMessageEmailAddress (PtypString)
    0x684a:
      id: schedule_info_delegate_names_w
      -orig-id: PidTagScheduleInfoDelegateNamesW
      doc: |
        PtypMultipleString. Also used as:
        * PidTagWlinkFlags (PtypInteger32)
    0x684b:
      id: schedule_info_delegator_wants_info
      -orig-id: PidTagScheduleInfoDelegatorWantsInfo
      doc: |
        PtypBoolean. Also used as:
        * PidTagWlinkOrdinal (PtypBinary)
    0x684c:
      id: wlink_entry_id
      -orig-id: PidTagWlinkEntryId
      doc: PtypBinary.
    0x684d:
      id: wlink_record_key
      -orig-id: PidTagWlinkRecordKey
      doc: PtypBinary.
    0x684e:
      id: wlink_store_entry_id
      -orig-id: PidTagWlinkStoreEntryId
      doc: PtypBinary.
    0x684f:
      id: schedule_info_months_merged
      -orig-id: PidTagScheduleInfoMonthsMerged
      doc: |
        PtypMultipleInteger32. Also used as:
        * PidTagWlinkFolderType (PtypBinary)
    0x6850:
      id: schedule_info_free_busy_merged
      -orig-id: PidTagScheduleInfoFreeBusyMerged
      doc: |
        PtypMultipleBinary. Also used as:
        * PidTagWlinkGroupClsid (PtypBinary)
    0x6851:
      id: schedule_info_months_tentative
      -orig-id: PidTagScheduleInfoMonthsTentative
      doc: |
        PtypMultipleInteger32. Also used as:
        * PidTagWlinkGroupName (PtypString)
    0x6852:
      id: schedule_info_free_busy_tentative
      -orig-id: PidTagScheduleInfoFreeBusyTentative
      doc: |
        PtypMultipleBinary. Also used as:
        * PidTagWlinkSection (PtypInteger32)
    0x6853:
      id: schedule_info_months_busy
      -orig-id: PidTagScheduleInfoMonthsBusy
      doc: |
        PtypMultipleInteger32. Also used as:
        * PidTagWlinkCalendarColor (PtypInteger32)
    0x6854:
      id: schedule_info_free_busy_busy
      -orig-id: PidTagScheduleInfoFreeBusyBusy
      doc: |
        PtypMultipleBinary. Also used as:
        * PidTagWlinkAddressBookEID (PtypBinary)
    0x6855:
      id: schedule_info_months_away
      -orig-id: PidTagScheduleInfoMonthsAway
      doc: PtypMultipleInteger32.
    0x6856:
      id: schedule_info_free_busy_away
      -orig-id: PidTagScheduleInfoFreeBusyAway
      doc: PtypMultipleBinary.
    0x6868:
      id: free_busy_range_timestamp
      -orig-id: PidTagFreeBusyRangeTimestamp
      doc: PtypTime.
    0x6869:
      id: free_busy_count_months
      -orig-id: PidTagFreeBusyCountMonths
      doc: PtypInteger32.
    0x686a:
      id: schedule_info_appointment_tombstone
      -orig-id: PidTagScheduleInfoAppointmentTombstone
      doc: PtypBinary.
    0x686b:
      id: delegate_flags
      -orig-id: PidTagDelegateFlags
      doc: PtypMultipleInteger32.
    0x686c:
      id: schedule_info_free_busy
      -orig-id: PidTagScheduleInfoFreeBusy
      doc: PtypBinary.
    0x686d:
      id: schedule_info_auto_accept_appointments
      -orig-id: PidTagScheduleInfoAutoAcceptAppointments
      doc: PtypBoolean.
    0x686e:
      id: schedule_info_disallow_recurring_appts
      -orig-id: PidTagScheduleInfoDisallowRecurringAppts
      doc: PtypBoolean.
    0x686f:
      id: schedule_info_disallow_overlapping_appts
      -orig-id: PidTagScheduleInfoDisallowOverlappingAppts
      doc: PtypBoolean.
    0x6890:
      id: wlink_client_id
      -orig-id: PidTagWlinkClientID
      doc: PtypBinary.
    0x6891:
      id: wlink_address_book_store_eid
      -orig-id: PidTagWlinkAddressBookStoreEID
      doc: PtypBinary.
    0x6892:
      id: wlink_ro_group_type
      -orig-id: PidTagWlinkROGroupType
      doc: PtypInteger32.
    0x6904:
      id: non_delivery_report_from_entry_id
      -orig-id: PidTagNonDeliveryReportFromEntryId
      doc: PtypBinary.
    0x6905:
      id: non_delivery_report_from_name
      -orig-id: PidTagNonDeliveryReportFromName
      doc: PtypString.
    0x6906:
      id: non_delivery_report_from_search_key
      -orig-id: PidTagNonDeliveryReportFromSearchKey
      doc: PtypBinary.
    0x7001:
      id: view_descriptor_binary
      -orig-id: PidTagViewDescriptorBinary
      doc: PtypBinary.
    0x7002:
      id: view_descriptor_strings
      -orig-id: PidTagViewDescriptorStrings
      doc: PtypString.
    0x7003:
      id: view_descriptor_flags
      -orig-id: PidTagViewDescriptorFlags
      doc: PtypInteger32.
    0x7004:
      id: view_descriptor_link_to
      -orig-id: PidTagViewDescriptorLinkTo
      doc: PtypBinary.
    0x7005:
      id: view_descriptor_view_folder
      -orig-id: PidTagViewDescriptorViewFolder
      doc: PtypBinary.
    0x7006:
      id: view_descriptor_name
      -orig-id: PidTagViewDescriptorName
      doc: PtypString.
    0x7007:
      id: view_descriptor_version
      -orig-id: PidTagViewDescriptorVersion
      doc: PtypInteger32.
    0x7c06:
      id: roaming_datatypes
      -orig-id: PidTagRoamingDatatypes
      doc: PtypInteger32.
    0x7c07:
      id: roaming_dictionary
      -orig-id: PidTagRoamingDictionary
      doc: PtypBinary.
    0x7c08:
      id: roaming_xml_stream
      -orig-id: PidTagRoamingXmlStream
      doc: PtypBinary.
    0x7c09:
      id: roaming_binary
      -orig-id: PidTagRoamingBinary
      doc: PtypBinary.
    0x7c24:
      id: osc_sync_enabled
      -orig-id: PidTagOscSyncEnabled
      doc: PtypBoolean.
    0x7d01:
      id: processed
      -orig-id: PidTagProcessed
      doc: PtypBoolean.
    0x7ff9:
      id: exception_replace_time
      -orig-id: PidTagExceptionReplaceTime
      doc: PtypTime.
    0x7ffa:
      id: attachment_link_id
      -orig-id: PidTagAttachmentLinkId
      doc: PtypInteger32.
    0x7ffb:
      id: exception_start_time
      -orig-id: PidTagExceptionStartTime
      doc: PtypTime.
    0x7ffc:
      id: exception_end_time
      -orig-id: PidTagExceptionEndTime
      doc: PtypTime.
    0x7ffd:
      id: attachment_flags
      -orig-id: PidTagAttachmentFlags
      doc: PtypInteger32.
    0x7ffe:
      id: attachment_hidden
      -orig-id: PidTagAttachmentHidden
      doc: PtypBoolean.
    0x7fff:
      id: attachment_contact_photo
      -orig-id: PidTagAttachmentContactPhoto
      doc: PtypBoolean.
