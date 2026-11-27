"""Writes synthetic.bin: an SMBIOS 3.10 structure table with the structure
types and later-version fields that the real samples lack. Field values are
hand-encoded from DSP0134 3.10.0; see _test/samples/firmware/smbios/smbios.yml.

    python3 make_synthetic.py synthetic.bin
"""
import struct
import sys


def structure(type_, handle, body, strings=()):
    head = bytes([type_, 4 + len(body)]) + struct.pack('<H', handle)
    if strings:
        tail = b''.join(s.encode() + b'\0' for s in strings) + b'\0'
    else:
        tail = b'\0\0'
    return head + body + tail


out = b''
# Type 0, 3.1 layout: ROM size 0xff, extended ROM size 48 GiB.
out += structure(0, 0x0000,
    bytes([1, 2]) + struct.pack('<H', 0xe800) + bytes([3, 0xff])
    + struct.pack('<Q', 0x880)                  # PCI, upgradeable
    + bytes([0x01, 0x0c])                       # ACPI; targeted content, UEFI
    + bytes([1, 2, 0xff, 0xff])
    + struct.pack('<H', 0x4030),                # 48, unit GiB
    ['Vendor', '1.0', '01/02/2026'])
# Type 3: rack chassis with lock, 2 contained elements of 3 bytes, SKU, rack type.
out += structure(3, 0x0001,
    bytes([1, 0x80 | 0x17, 0, 0, 0, 3, 3, 3, 3]) + struct.pack('<I', 0)
    + bytes([2, 2, 2, 3])
    + bytes([0x03, 1, 8])                       # board type: server blade
    + bytes([0x80 | 0x27, 1, 2])                # structure type 39
    + bytes([2, 1, 2]),                         # SKU string, rack OU, 2
    ['Maker', 'SKU-1'])
# Type 9, 3.5 layout: x16 PCIe Gen3 slot, one peer group.
out += structure(9, 0x0002,
    bytes([1, 0xb6, 0x0d, 4, 4]) + struct.pack('<H', 7) + bytes([0x04, 0x0b])
    + struct.pack('<H', 0) + bytes([0x3a, (2 << 3) | 1, 0x0d, 1])
    + struct.pack('<H', 1) + bytes([0x3b, 0, 0x0b])        # peer 0001:3b:00.0
    + bytes([3, 0x0d]) + struct.pack('<H', 2032) + bytes([3]),
    ['SLOT1'])
# Type 23: enabled, watchdog, boot option OS, on limit do not reboot.
out += structure(23, 0x0003,
    bytes([0b00111011]) + struct.pack('<HHHH', 2, 5, 10, 0xffff))
# Type 29: motherboard, OK; 5 A, -0.1 A, 1 mA, 50 mA, accuracy unknown, 1.5 A.
out += structure(29, 0x0004,
    bytes([1, (3 << 5) | 7])
    + struct.pack('<hhHhHIh', 5000, -100, 10, 50, 0x8000, 0, 1500),
    ['Current'])
# Type 30: outbound enabled only.
out += structure(30, 0x0005, bytes([1, 0b10]), ['OOB Inc'])
# Type 33: corrected single-bit, device level, read.
out += structure(33, 0x0006,
    bytes([0x0c, 3, 3])
    + struct.pack('<IQQI', 0xdeadbeef, 0x123456789, 1 << 63, 64))
# Type 37: RamBus, 2 devices (load 2 handle 0x20, load 3 handle 0x21).
out += structure(37, 0x0007,
    bytes([3, 8, 2, 2]) + struct.pack('<H', 0x20) + bytes([3]) + struct.pack('<H', 0x21))
# Type 42: network host interface, USB device data, one Redfish over IP record.
out += structure(42, 0x0008,
    bytes([0x40, 7, 2, 0x6b, 0x1d, 0x02, 0x01, 0, 0, 1, 4, 3, 1, 2, 3]))
# Type 44: AArch64 processor-specific block, architecture data revision 1.
arch = struct.pack('<HBBI', 1, 0xa8, 0, 0) + b''.join(
    struct.pack('<Q', 0x1000 + i) for i in range(20))
block = struct.pack('<HBB', 0x0100, 8 + len(arch), 0) + bytes([0x3b, 0x04, 0, 0]) + arch
out += structure(44, 0x0009, struct.pack('<H', 0x10) + bytes([len(block), 5]) + block)
# Type 46: UEFI device path string property of handle 2.
out += structure(46, 0x000a,
    struct.pack('<H', 1) + bytes([1]) + struct.pack('<H', 2),
    ['PciRoot(0x0)/Pci(0x1,0x0)'])
out += structure(127, 0xfeff, b'')

with open(sys.argv[1], 'wb') as f:
    f.write(out)
