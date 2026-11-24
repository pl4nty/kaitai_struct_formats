# Imported from https://github.com/cyrozap/trendnet-teg-30284-re/blob/ceb0d271ac382d31d14b655e30781de586a66af4/trendnet_teg30284_fw.ksy
meta:
  id: trendnet_teg30284_fw
  title: TRENDnet TEG-30284 firmware update file
  file-extension: hex
  license: CC0-1.0
  endian: be
seq:
  - id: updates
    type: update
    repeat: eos
types:
  update:
    seq:
      - id: header
        size: 64
        type: header
        doc: The image header.
      - id: image
        size: header.image_len
        type: image
        doc: The image data that will be written to flash.
    types:
      header:
        seq:
          - id: image_checksum
            type: u4
            doc: Sum of all the bytes in the image.
          - id: model
            size: 16
            type: strz
            encoding: ASCII
            doc: Device model name.
          - id: unknown
            type: u4
            doc: Unknown value. Always 2.
          - id: signature
            size: 16
            type: strz
            encoding: ASCII
            doc: Partition signature/type.
          - id: partition
            type: u1
            doc: Partition number. 0-9 only.
          - id: hdr_len
            type: u1
            doc: Header length. Always 64.
          - id: customer_sig
            type: u2
            doc: Customer signature/number. 0-9 only.
          - id: board_ver
            type: u4
            doc: Board version.
          - id: image_len
            type: u4
            doc: Image length in bytes.
          - id: linux_start_address
            size: 10
            type: str
            encoding: ASCII
            if: signature == "os"
            doc: |
              If the signature is 'os', this is the Linux entrypoint as a '0x%08x'-formatted
              number. Otherwise, this is all null bytes.
      image:
        seq:
          - id: data
            size: _io.size - 32
          - id: fw_version
            size: 16
            type: strz
            encoding: ASCII
          - id: cameotag
            size: 8
            type: str
            encoding: ASCII
          - id: cameotag_ver
            type: u4
          - id: checksum
            type: u4
            doc: Sum of all the bytes in the image, excluding this checksum.
