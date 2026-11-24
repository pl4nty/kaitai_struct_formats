# Imported from https://github.com/NetherlandsForensicInstitute/tffsmount/blob/8c962d4ca7d875b4d59ad8bbcbf5dbb58b366ee6/tffsmount/parser.ksy
meta:
  id: tffs
  title: tffs_parser
  file-extension: tffs
  xref:
    headers: https://www.sciencedirect.com/science/article/pii/S266628172300001X
  license: Apache-2.0
  endian: le

doc: |
  On-disk layout of the TFFS filesystem, cross-checked against the driver.
  A note here is the driver's behaviour where it matters to a parser.

seq:
  - id: boot
    size: 0x200
    type: bootsector

instances:
  indirect_inodes_dir_name:
    value: '"$TFFS_Indirect_Inodes"'
    doc: |
      Directory the driver creates in the root for the real entries of
      hard-linked inodes, each named by its byte offset within it. Created on
      demand, so a volume with no hard links does not have it.

types:
  bootsector:
    seq:
      - id: jmp_opcode
        type: u1
        valid:
          any-of: [0xe9, 0xeb, 0x49]
        doc: |
          The driver validates only this byte. The two that follow
          are never examined, so they are not part of a magic value.
      - id: jmp_displacement
        size: 2
      - id: magic
        contents: 'TFFS    '
      - id: zeros_bios_param_block
        size: 0x35
      - id: reserved1
        size: 1
      - id: bytes_per_sector_shift
        type: u1
        valid:
          min: 9
          max: 12
      - id: sectors_per_cluster_shift
        type: u1
      - id: bits_per_cam_entry
        type: u1
        valid: 32
        doc: Rejected unless 32, which is what lets the CAM be an array of u4.
      - id: reverved2
        size: 4
      - id: num_reserved_sectors
        type: u4
      - id: num_reserved_plus_cam_sectors
        type: u4
      - id: total_sector_count
        type: u8
      - id: num_cam_entries
        type: u8
        doc: Not trustworthy on its own; use num_clusters, which clamps it.
      - id: root_dirent_offset
        type: u8
      - id: backup_boot_sector_number
        type: u4
        doc: |
          Sector holding a copy of this boot sector, 0x6000 on both real images.
          The driver falls back to it when the primary fails its crc; this
          reader stays on the primary and only reports where it is.
      - id: volume_flags
        type: volume_flags
      - id: next_free_cluster_hint
        type: u8
        doc: Only meaningful when volume_flags.no_free_cluster_hint is false.
      - id: reserved3
        size: 8
      - id: next_inode_number
        type: u4
      - id: reserved4
        size: 0xc
      - id: encrypt_pw_salt
        size: 0x10
        doc: |
          ext4-compatible scaffolding for userspace password derivation, handed
          out by FS_IOC_GET_ENCRYPTION_PWSALT. No file key derives from it.
      - id: checksum_type
        type: u1
        enum: checksum_algorithm
        doc: |
          Meaningful only alongside the flag for the checksums in question, so
          ask checksums_enabled or has_boot_sector_crc rather than this.
      - id: reserved5
        size: 0x15b
      - id: crc
        type: u4
        doc: crc32c over the preceding 0x1fc bytes of this sector.
    instances:
      sector_size:
        value: 1 << bytes_per_sector_shift
      cluster_size:
        value: (1 << sectors_per_cluster_shift) * sector_size
      num_cam_sectors:
        value: num_reserved_plus_cam_sectors - num_reserved_sectors
      data_start:
        value: num_reserved_plus_cam_sectors * sector_size
      page_shift:
        value: 12
        doc: log2 of PAGE_SIZE on every target the driver is built for.
      block_shift_cap:
        value: >-
          bytes_per_sector_shift + sectors_per_cluster_shift < page_shift
          ? bytes_per_sector_shift + sectors_per_cluster_shift
          : page_shift
      block_shift:
        value: >-
          data_start % (1 << block_shift_cap) == 0 ? block_shift_cap
          : data_start % (1 << (block_shift_cap - 1)) == 0 ? block_shift_cap - 1
          : data_start % (1 << (block_shift_cap - 2)) == 0 ? block_shift_cap - 2
          : block_shift_cap - 3
        doc: |
          log2 of the filesystem block size, and so of an fscrypt data unit.
          The driver takes the largest power of two that is at most
          min(cluster_size, page size) and still divides the start of the data
          area. Four arms cover its loop and the last always lands: data_start
          is a whole number of sectors, and bytes_per_sector_shift is validated
          as 9..12 against a cap of at most page_shift.
      block_size:
        value: 1 << block_shift
      checksummed_bytes:
        pos: 0
        size: 0x1fc
        doc: The range covered by `crc`.
      checksums_enabled:
        value: >-
          volume_flags.has_checksums
          and checksum_type == checksum_algorithm::crc32c
        doc: |
          The driver forces the checksum type to 0 when has_checksums is clear,
          so entry and symlink checksums exist only when this is true.
      has_boot_sector_crc:
        value: >-
          volume_flags.boot_sector_crc_present
          and checksum_type == checksum_algorithm::crc32c
        doc: |
          Whether `crc` holds a checksum to verify. The driver's gate may also
          require volume_flags.has_checksums; all three images set both bits, so
          nothing available separates the two. Confirm that before tightening
          this one.
      device_sector_count:
        value: _root._io.size >> bytes_per_sector_shift
      usable_sector_count:
        value: 'total_sector_count < device_sector_count ? total_sector_count : device_sector_count'
      has_valid_geometry:
        value: >-
          num_reserved_sectors <= num_reserved_plus_cam_sectors
          and num_reserved_plus_cam_sectors <= usable_sector_count
      cam_capacity:
        value: num_cam_sectors << (bytes_per_sector_shift - 2)
        doc: How many 4-byte CAM entries physically fit in the CAM region.
      data_area_cluster_count:
        value: (usable_sector_count - num_reserved_plus_cam_sectors) >> sectors_per_cluster_shift
      num_clusters_capped_by_cam:
        value: 'num_cam_entries < cam_capacity ? num_cam_entries : cam_capacity'
      num_clusters:
        value: >-
          num_clusters_capped_by_cam < data_area_cluster_count
          ? num_clusters_capped_by_cam
          : data_area_cluster_count
        doc: |
          Clamped as the driver does:
          min(num_cam_entries, cam_capacity, data_area_cluster_count).
      cam:
        io: _root._io
        pos: num_reserved_sectors * sector_size
        size: num_cam_sectors * sector_size
        type: cam_entries
        if: has_valid_geometry
      root:
        io: _root._io
        pos: root_dirent_offset
        type: direntry_set

  volume_flags:
    doc: |
      The driver rejects any bit above 4. Bit 3 (0x08) is accepted and
      unnamed: images/ivi_adb.bin sets it (0x1d, against 0x14 on
      the other two images) and what it means has not been traced.
    seq:
      - id: val
        type: u4
    instances:
      is_dirty:
        value: (val & 0x01) != 0
      no_free_cluster_hint:
        value: (val & 0x02) != 0
      has_checksums:
        value: (val & 0x04) != 0
      boot_sector_crc_present:
        value: (val & 0x10) != 0
      is_supported:
        value: (val & 0xffffffe0) == 0

  direntry:
    seq:
      - id: len_name_raw
        type: u1
        doc: Length of name_raw in bytes; name_length in the driver.
      - id: name_hash
        type: u2
        doc: |
          interface.name_hash over the on-disk name, so over the ciphertext
          in an encrypted directory, and zero for the nameless real entries in
          $TFFS_Indirect_Inodes. Only ever used to accelerate lookups and never
          validated, so a mismatch is not fatal.
      - id: type
        type: dirent_type
      - id: inode_number
        type: u8
      - id: generation
        type: u4
        doc: |
          i_generation, except in an indirect set, where it is the offset of
          this inode's real entry instead -- see indirect_offset.
      - id: nlink
        type: u4
      - id: uid
        type: u4
      - id: gid
        type: u4
      - id: size
        type: u8
        doc: |
          i_size for regular files and symlinks. Always zero for a directory,
          which the driver measures by its chain, and the device
          number rather than a length for a device node.
      - id: cluster_count
        type: u4
        doc: Allocated clusters. Zero for directories and for device nodes.
      - id: first_cluster
        type: cluster
        doc: |
          Where this inode's contents begin, and 0xFFFFFFFF when it has no
          clusters at all, which is not a cluster -- see has_allocation.
      - id: extended_flags
        type: extended_flags
      - id: first_extended_attr_cluster
        type: cluster
        doc: |
          First cluster of this inode's extended attribute chain, and
          `is_unallocated` for an inode with no attributes. An encrypted inode
          whose set has no inline context keeps its fscrypt context here, as
          "crypto.context". Nothing reads it: xattrs are not implemented.
      - id: reserved
        type: u4
      - id: atime_ns
        type: u4
      - id: mtime_ns
        type: u4
      - id: ctime_ns
        type: u4
      - id: atime_s
        type: u8
      - id: mtime_s
        type: u8
      - id: ctime_s
        type: u8
      - id: name_raw
        size: len_name_raw
        doc: |
          Exactly len_name_raw bytes, no terminator, and raw because in an
          encrypted directory it is ciphertext rather than text.
    instances:
      flags:
        value: _parent.flags
        doc: The set's flag word; some of its bits describe the inode.
      is_indirect:
        value: flags.is_indirect
      is_encrypted:
        value: flags.is_encrypted
      hidden_from_listing:
        value: flags.hidden_from_listing
      crypto_context:
        value: _parent.inline_crypto_context
        doc: The inode's fscrypt context, or null when it is not encrypted.
      is_dir:
        value: type.is_dir
      is_root:
        value: inode_number == 2
        doc: |
          The root holds an entry for itself, carrying the volume label, which
          both of the driver's walks skip.
      allocated_size:
        value: cluster_count * _root.boot.cluster_size
        doc: |
          Zero for a directory, whose cluster_count is not maintained:
          the driver measures one by the length of its chain.
      has_allocation:
        value: not first_cluster.is_unallocated
        doc: |
          Whether the inode has any clusters. Having none is legal -- a
          zero-length file -- where the same value as a *link* is corruption.
      indirect_offset:
        value: generation
        doc: Offset of the real entry in $TFFS_Indirect_Inodes, if is_indirect.
      rdev_major:
        value: size & 0xffffffff
        doc: Only meaningful when type.is_device.
      rdev_minor:
        value: size >> 32
        doc: Only meaningful when type.is_device.
      symlink_target_size:
        value: 'extended_flags.has_crc_prefix ? size - 4 : size'
        if: has_valid_symlink_size
        doc: |
          What stat() reports as a symlink's size: `size` counts the
          optional crc prefix the target is stored behind, which is not part of
          the target. Needs no read of the chain. Only meaningful for a symlink.
      stat_size:
        value: 'type.is_symlink ? symlink_target_size : type.is_regular ? size : 0'
        if: has_valid_symlink_size
        doc: |
          stat()'s size, for every inode that can answer from its own entry: a
          special inode keeps an i_size of zero and a device node's `size` is a
          device number, so neither reports it. A directory is the kind left
          out, since only a walk of its chain can measure it.
      has_valid_symlink_size:
        value: not type.is_symlink or not extended_flags.has_crc_prefix or size >= 4

  cam_entries:
    doc: |
      The allocation map: entry i holds the number of the cluster that cluster i
      links to, so entry i is cluster i's `next`. bits_per_cam_entry is
      validated as 32, so an entry is four bytes and the map is this array.
    seq:
      - id: entries
        type: cluster
        repeat: expr
        repeat-expr: _root.boot.num_clusters

  cluster:
    doc: |
      One cluster: the number that names it, where its bytes are, and the
      cluster it links to. It is read from those four bytes, which is how a
      cluster appears on disk in both places it appears --
      direntry.first_cluster and every entry of the allocation map.

      Whether its bytes are contents or directory records is the caller's
      context and nothing the cluster can tell, so neither is read until asked
      for. Following a chain is clusters.cluster_chain's: the two guards that
      make it safe, a cycle and a link that is corrupt rather than terminal,
      cannot be expressed here.
    seq:
      - id: number
        type: u4
    instances:
      size:
        value: _root.boot.cluster_size
      start:
        value: _root.boot.data_start + number * _root.boot.cluster_size
        doc: |
          Where this cluster's bytes begin in the image: the one place geometry
          becomes a position, shared by both ways of reading them.
      data:
        io: _root._io
        pos: start
        size: _root.boot.cluster_size
        if: is_in_volume
        doc: |
          Null for a number that is not a cluster: the map is full of numbers
          that end a chain rather than name one, and seeking to where those
          would begin lands far outside the volume.
      as_direntry_sets:
        io: _root._io
        pos: start
        size: _root.boot.cluster_size
        type: direntry_sets
        if: is_in_volume
        doc: |
          These bytes as the directory records they hold, for a cluster of a
          directory's chain. Bounded by the cluster, which is sound because no
          entry set straddles one -- see direntry_sets.
      is_in_volume:
        value: number < _root.boot.num_clusters
        doc: |
          Whether this is a cluster at all, which `next` and `data` need asked
          first: a number past the last cluster has no entry in the map, and
          the two markers below are not clusters either.
      is_end_of_chain:
        value: number == 0xfffffffe
        doc: |
          The end-of-chain marker, and the only one: any other number past the
          last cluster is corruption rather than a terminator.
      is_unallocated:
        value: number == 0xffffffff
        doc: |
          "Nothing allocated", which is legal as an inode's first cluster and
          nowhere else, so as a link it is corruption.
      next:
        value: _root.boot.cam.entries[number]
        if: is_in_volume
        doc: |
          This cluster's entry in the allocation map: the cluster that follows
          it in a chain, and null for a number that is not a cluster. A walk
          asks the link itself what it is, since a terminator is a number like
          any other.

  symlink_target:
    doc: |
      What a symlink stores in its data: the target, behind a crc32c over it
      when the volume has checksums enabled. Read over the chain rather than
      cluster by cluster, no record rule keeping a target inside one.

      The driver verifies the prefix and passes on the rest, whose length
      stat() reports as the symlink's size. In an
      encrypted directory that rest is ciphertext under the symlink's own
      filenames key, the checksum covering it as stored.
    params:
      - id: stored_size
        type: u8
        doc: direntry.size, which counts the prefix when there is one.
      - id: has_crc_prefix
        type: bool
        doc: direntry.extended_flags.has_crc_prefix of this symlink.
    seq:
      - size: 0
        valid:
          expr: not has_crc_prefix or stored_size >= 4
        doc: Validate the size parameter before reading or subtracting the prefix.
      - id: crc
        type: u4
        if: has_crc_prefix
        doc: crc32c over `target`, computed as direntry_set.crc is.
      - id: target
        size: 'has_crc_prefix ? stored_size - 4 : stored_size'

  direntry_sets:
    doc: |
      One cluster of a directory: its entry sets, in the order the driver walks
      them. interface._entry_sets strings a chain's clusters together.

      Sets are laid down from the start of each 512-byte record, and the space
      left at the end of one is filled with a not-in-use set whose num_slots
      advances exactly to the boundary -- so a sequential read lands on every
      boundary and no set straddles one. A cluster boundary is a record
      boundary too, since bytes_per_sector_shift is validated as 9..12 and the
      record size therefore divides the cluster size. That is what makes a
      cluster a place a parse can start and stop.

      Offsets here are relative to the cluster. The driver measures a directory
      as one flat run of bytes, which is how a hard link's indirect_offset is
      written, and where a cluster sits in its chain is Python's to add.
    seq:
      - id: entries
        type: direntry_set
        repeat: until
        repeat-until: _.num_slots == 0 or not _.fits_in_record or not _.has_room_for_name or _io.eof
        doc: |
          `num_slots == 0` is the end-of-directory marker, where the driver's
          walk ends. Free and padding sets have a non-zero num_slots and are
          skipped, not stopped at.

          `_io.eof` is a cluster packed exactly full, which the walk continues
          past into the next cluster; a directory whose last cluster ends that
          way is one the driver ends at i_size.

          A set whose length breaks either rule stops the parse rather than
          being read, since reading it would run over the following set or off
          the end of the cluster. interface._entry_sets raises when it meets one.

  direntry_set:
    doc: |
      A directory entry occupying num_slots consecutive 32-byte slots, packed
      into 512-byte records and never straddling one. A mounted driver can
      resynchronise to the next record past one that does, where this reader
      stops.

      The allocator grants ((len_name_raw + 0x7f) >> 5) + 1 slots: enough for the
      0x60-byte header plus the name, and one more holding the 28-byte inline
      fscrypt context at +0x00 and/or the 4-byte checksum at +0x1c.
    seq:
      - size: 0
        if: offset_in_cluster < 0     # trick to cache start offset in an instance: upstream kaitai_struct issue 868
      - id: flags
        type: direntry_flags
      - id: num_slots
        type: u1
      - id: entry
        size: num_slots * tffs_dir_slot_size - 3
        type:
          switch-on: flags.in_use
          cases:
            true: direntry
        if: is_readable
        doc: |
          A free or padding set keeps its slots as raw bytes, which is as much
          as the driver makes of one too.
    instances:
      tffs_dir_slot_size:
        value: 0x20
      record_size:
        value: 0x200
      offset_in_cluster:
        value: _io.pos
        doc: |
          This set's offset within its cluster, which the `pos:` instances below
          are relative to. Add where the cluster sits in its chain and it is the
          offset the driver reports and indirect_offset is measured in.
      entry_len_name_raw:
        pos: offset_in_cluster + 3
        type: u1
        if: has_entry_header
        doc: |
          `entry.len_name_raw`, three bytes into the set, read ahead of `entry`
          because how many slots a name needs says whether `entry` is readable.
      slots_for_name:
        value: 'has_entry_header ? (entry_len_name_raw + 0x7f) >> 5 : 0'
        doc: |
          Slots enough for the 0x60-byte header and the name, which is the part
          of the allocator's rule the parse itself depends on.
      has_room_for_name:
        value: 'not flags.in_use or (has_entry_header and num_slots >= slots_for_name)'
        doc: |
          Whether `entry` is big enough for the name it claims, so that an
          in-use set reaches `direntry` only when `direntry` fits; without it
          the parse raises EndOfStreamError from inside the name.

          The driver may require a further slot where the set carries an inline
          context or a checksum. That is unconfirmed, so it is not enforced.
      has_entry_header:
        value: flags.in_use and num_slots > 0 and fits_in_record
      is_readable:
        value: num_slots > 0 and fits_in_record and has_room_for_name
      fits_in_record:
        value: (offset_in_cluster % record_size) + (num_slots * tffs_dir_slot_size) <= record_size
        doc: |
          The containment rule the driver enforces when it allocates a set and
          checks wherever it reads one. Holds on all 7166 in-use sets of the
          three available images.

          It is also what keeps a cluster-bounded parse inside its cluster: a
          set is read only where it fits in its record, and one that does not
          stops the parse instead. No cluster can fail to parse, whatever its
          bytes hold.
      raw:
        pos: offset_in_cluster
        size: num_slots * tffs_dir_slot_size - 4
        if: is_readable
      crc:
        pos: offset_in_cluster + num_slots * tffs_dir_slot_size - 4
        type: u4
        if: is_readable and flags.in_use and flags.has_checksum
        doc: CRC-32C over `raw`, but with a zero seed and no final XOR.
      inline_crypto_context:
        pos: offset_in_cluster + (num_slots - 1) * tffs_dir_slot_size
        size: 0x1c
        type: fscrypt_context
        if: is_readable and flags.in_use and flags.has_inline_crypto_context
        doc: |
          The fscrypt context, in the extra slot. The driver writes it here
          whenever it fits in 0x1c bytes and the set has a spare slot -- which
          it always does, the context being exactly 0x1c and the slot always
          allocated when the entry is created. So the "crypto.context" xattr
          fallback is unreachable on any volume the driver wrote, and all 31
          encrypted entries of ivi_adb.bin are inline.

  fscrypt_context:
    doc: |
      The on-disk fscrypt encryption context, 28 bytes. fscrypt requires
      exactly this size, a `format` of 1 and no `flags` bit outside the low two.

          derived = AES-128-ECB-Encrypt(key = nonce, plaintext = master_key)

      Note the inversion: the nonce is the AES key, the master key the
      plaintext. The driver looks the master key up in the keyring under
      "fscrypt:" plus master_key_descriptor in lowercase hex.
    seq:
      - id: format
        type: u1
      - id: contents_encryption_mode
        type: u1
        enum: encryption_mode
      - id: filenames_encryption_mode
        type: u1
        enum: encryption_mode
      - id: flags
        type: u1
      - id: master_key_descriptor
        size: 8
      - id: nonce
        size: 16
    instances:
      filename_padding:
        value: 4 << (flags & 3)
        doc: Encrypted names are padded to a multiple of this, with a floor of 16 bytes.
      is_supported_format:
        value: format == 1
        doc: FS_ENCRYPTION_CONTEXT_FORMAT_V1, the only one the driver reads.
      has_supported_flags:
        value: (flags & 0xfc) == 0
        doc: |
          Any flag outside the low two -- the padding filename_padding reads --
          is rejected by fscrypt.
      is_supported_mode_pair:
        value: >-
          (contents_encryption_mode == encryption_mode::aes_256_xts
          and filenames_encryption_mode == encryption_mode::aes_256_cts)
          or (contents_encryption_mode == encryption_mode::aes_128_cbc
          and filenames_encryption_mode == encryption_mode::aes_128_cts)
        doc: |
          The two pairings fscrypt accepts. Only the first has been seen on
          media, on every encrypted entry of images/ivi_adb.bin.
      contents_is_xts:
        value: contents_encryption_mode == encryption_mode::aes_256_xts
      contents_is_cbc:
        value: contents_encryption_mode == encryption_mode::aes_128_cbc
      contents_key_size:
        value: 'contents_is_xts ? 64 : contents_is_cbc ? 16 : 0'
        doc: |
          Leading bytes of the derived key the contents cipher takes, and zero
          for a mode fscrypt does not define.
      filenames_key_size:
        value: >-
          filenames_encryption_mode == encryption_mode::aes_256_cts ? 32
          : filenames_encryption_mode == encryption_mode::aes_128_cts ? 16
          : 0
        doc: The same, for the filenames cipher, which shares the derived key.

  dirent_type:
    doc: |
      An inode's mode word, stored exactly as POSIX defines it, so `mode` is
      st_mode as stat() reports it with nothing rebuilt.
    seq:
      - id: mode
        type: u2
    instances:
      file_type:
        value: mode & 0xf000
        enum: posix_file_type
        doc: |
          S_IFMT. An unnamed value comes back as the number rather than
          raising, so an inode of no known type answers false to all of these.
      permissions:
        value: mode & 0x0fff
        doc: 'The low twelve bits: setuid, setgid, sticky and rwx for the three classes.'
      is_fifo:
        value: file_type == posix_file_type::fifo
      is_chardev:
        value: file_type == posix_file_type::chardev
      is_dir:
        value: file_type == posix_file_type::dir
      is_blockdev:
        value: file_type == posix_file_type::blockdev
      is_regular:
        value: file_type == posix_file_type::regular
      is_symlink:
        value: file_type == posix_file_type::symlink
      is_device:
        value: is_chardev or is_blockdev
        doc: |
          A device node, whose `size` field holds the device number rather than
          a length. No is_socket: nothing treats a socket as other than one of
          the kinds stat_size reports as zero.

  direntry_flags:
    doc: |
      The flag word at the head of an entry set, which is about the set rather
      than the inode in it; extended_flags is the inode's own.
    seq:
      - id: val
        type: u2
    instances:
      in_use:
        value: (val & 0x8000) != 0
        doc: Otherwise TFFS_FREE_ENTRY or TFFS_NEVER_USED_ENTRY.
      is_indirect:
        value: (val & 0x4000) != 0
        doc: |
          The real entry is in $TFFS_Indirect_Inodes at indirect_offset; this
          set carries only the link's name.
      hidden_from_listing:
        value: (val & 0x2000) != 0
        doc: Left out of listings; in practice only the indirect store.
      is_encrypted:
        value: (val & 0x1000) != 0
      has_inline_crypto_context:
        value: (val & 0x0800) != 0
      has_checksum:
        value: (val & 0x0400) != 0
        doc: |
          A crc32c in the last four bytes of the final slot, written only when
          the volume has checksums enabled -- so verifying needs both.
      dos_attributes:
        value: val & 0x000f
        doc: bit0 read-only, bit1 hidden, bit2 system, bit3 archive.

  extended_flags:
    seq:
      - id: val
        type: u4
    instances:
      is_compressed:
        value: (val & 0x00000001) != 0
        doc: |
          Inert: both of the driver's compression paths are -EOPNOTSUPP stubs,
          so no mountable volume holds compressed data.
      no_compress:
        value: (val & 0x00000002) != 0
      has_crc_prefix:
        value: (val & 0x00000008) != 0
        doc: |
          Set on symlinks, and only when the volume has checksums enabled: the
          stored target then carries a 4-byte crc32c prefix that `size` counts.
          Not an "is a symlink" flag -- that comes from the mode.
      in_encrypted_dir:
        value: (val & 0x80000000) != 0

enums:
  posix_file_type:
    0x1000: fifo
    0x2000: chardev
    0x4000: dir
    0x6000: blockdev
    0x8000: regular
    0xa000: symlink
    0xc000: socket

  checksum_algorithm:
    0: no_checksum
    1: crc32c

  encryption_mode:
    1: aes_256_xts
    4: aes_256_cts
    5: aes_128_cbc
    6: aes_128_cts
