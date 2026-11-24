# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/file_io.ksy
# Licence and copyright: see _community/README.md
# Copyright (C) 2015-2023 Swift Navigation Inc.
# Contact: https://support.swiftnav.com
#
# This source is subject to the license found in the file 'LICENSE' which must
# be distributed together with this source. All other rights reserved.
#
# THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
#
# Messages for using device's onboard flash filesystem functionality. This allows
# data to be stored persistently in the device's program flash with wear-levelling
# using a simple filesystem interface. The file system interface (CFS) defines an
# abstract API for reading directories and for reading and writing files.  Note
# that some of these messages share the same message type ID for both the host
# request and the device response.
#
# Automatically generated from spec/yaml/swiftnav/sbp/file_io.yaml with generate.py.
# Do not modify by hand!

meta:
  id: file_io
  title: SBP file I/O messages
  license: MIT
  imports: [  ]
  endian: le

types:

  msg_fileio_read_req:
    doc: |
      The file read message reads a certain length (up to 255 bytes) from a
      given offset into a file, and returns the data in a MSG_FILEIO_READ_RESP
      message where the message length field indicates how many bytes were
      successfully read. The sequence number in the request will be returned
      in the response. If the message is invalid, a followup MSG_PRINT message
      will print "Invalid fileio read message". A device will only respond to
      this message when it is received from sender ID 0x42.
    seq:
      - id: sequence
        type: u4
        doc: Read sequence number
      - id: offset
        type: u4
        doc: File offset
      - id: chunk_size
        type: u1
        doc: Chunk size to read
      - id: filename
        size-eos: true
        type: str
        encoding: ASCII
        doc: Name of the file to read from
  
  msg_fileio_read_resp:
    doc: |
      The file read message reads a certain length (up to 255 bytes) from a
      given offset into a file, and returns the data in a message where the
      message length field indicates how many bytes were successfully read.
      The sequence number in the response is preserved from the request.
    seq:
      - id: sequence
        type: u4
        doc: Read sequence number
      - id: contents
        type: u1
        repeat: eos
        doc: Contents of read file
  
  msg_fileio_read_dir_req:
    doc: |
      The read directory message lists the files in a directory on the
      device's onboard flash file system.  The offset parameter can be used to
      skip the first n elements of the file list. Returns a
      MSG_FILEIO_READ_DIR_RESP message containing the directory listings as a
      NULL delimited list. The listing is chunked over multiple SBP packets.
      The sequence number in the request will be returned in the response.  If
      message is invalid, a followup MSG_PRINT message will print "Invalid
      fileio read message". A device will only respond to this message when it
      is received from sender ID 0x42.
    seq:
      - id: sequence
        type: u4
        doc: Read sequence number
      - id: offset
        type: u4
        doc: The offset to skip the first n elements of the file list
      - id: dirname
        size-eos: true
        type: str
        encoding: ASCII
        doc: Name of the directory to list
  
  msg_fileio_read_dir_resp:
    doc: |
      The read directory message lists the files in a directory on the
      device's onboard flash file system. Message contains the directory
      listings as a NULL delimited list. The listing is chunked over multiple
      SBP packets and the end of the list is identified by an packet with no
      entries. The sequence number in the response is preserved from the
      request.
    seq:
      - id: sequence
        type: u4
        doc: Read sequence number
      - id: contents
        size-eos: true
        type: str
        encoding: ASCII
        doc: Contents of read directory
  
  msg_fileio_remove:
    doc: |
      The file remove message deletes a file from the file system. If the
      message is invalid, a followup MSG_PRINT message will print "Invalid
      fileio remove message". A device will only process this message when it
      is received from sender ID 0x42.
    seq:
      - id: filename
        size-eos: true
        type: str
        encoding: ASCII
        doc: Name of the file to delete
  
  msg_fileio_write_req:
    doc: |
      The file write message writes a certain length (up to 255 bytes) of data
      to a file at a given offset. Returns a copy of the original
      MSG_FILEIO_WRITE_RESP message to check integrity of the write. The
      sequence number in the request will be returned in the response. If
      message is invalid, a followup MSG_PRINT message will print "Invalid
      fileio write message". A device will only process this message when it
      is received from sender ID 0x42.
    seq:
      - id: sequence
        type: u4
        doc: Write sequence number
      - id: offset
        type: u4
        doc: Offset into the file at which to start writing in bytes
      - id: filename
        size-eos: true
        type: str
        encoding: ASCII
        doc: Name of the file to write to
      - id: data
        type: u1
        repeat: eos
        doc: Variable-length array of data to write
  
  msg_fileio_write_resp:
    doc: |
      The file write message writes a certain length (up to 255 bytes) of data
      to a file at a given offset. The message is a copy of the original
      MSG_FILEIO_WRITE_REQ message to check integrity of the write. The
      sequence number in the response is preserved from the request.
    seq:
      - id: sequence
        type: u4
        doc: Write sequence number
  
  msg_fileio_config_req:
    doc: |
      Requests advice on the optimal configuration for a FileIO transfer.
      Newer version of FileIO can support greater throughput by supporting a
      large window of FileIO data that can be in-flight during read or write
      operations.
    seq:
      - id: sequence
        type: u4
        doc: Advice sequence number
  
  msg_fileio_config_resp:
    doc: |
      The advice on the optimal configuration for a FileIO transfer.  Newer
      version of FileIO can support greater throughput by supporting a large
      window of FileIO data that can be in-flight during read or write
      operations.
    seq:
      - id: sequence
        type: u4
        doc: Advice sequence number
      - id: window_size
        type: u4
        doc: The number of SBP packets in the data in-flight window
      - id: batch_size
        type: u4
        doc: The number of SBP packets sent in one PDU
      - id: fileio_version
        type: u4
        doc: The version of FileIO that is supported
  
