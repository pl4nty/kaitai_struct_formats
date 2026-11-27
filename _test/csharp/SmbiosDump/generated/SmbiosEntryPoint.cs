// This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild



namespace Kaitai
{

    /// <summary>
    /// The SMBIOS entry point tells software where the SMBIOS structure table
    /// (see `smbios`) is in physical memory, how long it is and which version of
    /// DSP0134 it follows. There are three kinds, told apart by their anchor
    /// string:
    /// 
    /// * `_SM_`, the 32-bit entry point of SMBIOS 2.1 and later, which embeds a
    ///   legacy `_DMI_` entry point at offset 0x10;
    /// * `_SM3_`, the 64-bit entry point of SMBIOS 3.0 and later;
    /// * `_DMI_` on its own, the entry point of the legacy DMI 2.0 table.
    /// 
    /// Firmware places the entry point on a 16-byte boundary in 0xf0000-0xfffff,
    /// or publishes its address in the EFI configuration table. Linux exposes it
    /// as `/sys/firmware/dmi/tables/smbios_entry_point`; there the table address
    /// is a physical one and the table is in the `DMI` file next to it.
    /// 
    /// `dmidecode --dump-bin` writes the entry point with the table address
    /// changed to 0x20, followed by the table at that offset, so for such a file
    /// `table` parses the whole structure table. `table` is null if the address
    /// is beyond the end of the input.
    /// 
    /// The checksums are not verified: all bytes of the entry point (and, for the
    /// 32-bit one, the 15 bytes from `_DMI_`) add up to 0 modulo 256.
    /// </summary>
    /// <remarks>
    /// Reference: <a href="https://www.dmtf.org/sites/default/files/standards/documents/DSP0134_3.10.0.pdf">Source</a>
    /// </remarks>
    public partial class SmbiosEntryPoint : KaitaiStruct
    {
        public static SmbiosEntryPoint FromFile(string fileName)
        {
            return new SmbiosEntryPoint(new KaitaiStream(fileName));
        }

        public SmbiosEntryPoint(KaitaiStream p__io, KaitaiStruct p__parent = null, SmbiosEntryPoint p__root = null) : base(p__io)
        {
            m_parent = p__parent;
            m_root = p__root ?? this;
            _read();
        }
        private void _read()
        {
            _anchor = System.Text.Encoding.GetEncoding("ASCII").GetString(m_io.ReadBytes(4));
            switch (Anchor) {
            case "_DMI": {
                _body = new LegacyEntryPoint(m_io, this, m_root);
                break;
            }
            case "_SM3": {
                _body = new EntryPoint64(m_io, this, m_root);
                break;
            }
            case "_SM_": {
                _body = new EntryPoint32(m_io, this, m_root);
                break;
            }
            }
        }

        /// <summary>
        /// SMBIOS 2.1 (32-bit) entry point, after the `_SM_` anchor.
        /// </summary>
        public partial class EntryPoint32 : KaitaiStruct
        {
            public static EntryPoint32 FromFile(string fileName)
            {
                return new EntryPoint32(new KaitaiStream(fileName));
            }

            public EntryPoint32(KaitaiStream p__io, SmbiosEntryPoint p__parent = null, SmbiosEntryPoint p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                f_table = false;
                _read();
            }
            private void _read()
            {
                _checksum = m_io.ReadU1();
                _lenEntryPoint = m_io.ReadU1();
                _majorVersion = m_io.ReadU1();
                _minorVersion = m_io.ReadU1();
                _lenMaxStructure = m_io.ReadU2le();
                _entryPointRevision = m_io.ReadU1();
                _formattedArea = m_io.ReadBytes(5);
                _intermediateAnchor = m_io.ReadBytes(4);
                if (!((KaitaiStream.ByteArrayCompare(_intermediateAnchor, new byte[] { 95, 68, 77, 73 }) == 0)))
                {
                    throw new ValidationNotEqualError(new byte[] { 95, 68, 77, 73 }, _intermediateAnchor, m_io, "/types/entry_point_32/seq/7");
                }
                _legacy = new LegacyEntryPoint(m_io, this, m_root);
            }
            private bool f_table;
            private Smbios _table;

            /// <summary>
            /// Same as `legacy.table`.
            /// </summary>
            public Smbios Table
            {
                get
                {
                    if (f_table)
                        return _table;
                    f_table = true;
                    _table = (Smbios) (Legacy.Table);
                    return _table;
                }
            }
            private byte _checksum;
            private byte _lenEntryPoint;
            private byte _majorVersion;
            private byte _minorVersion;
            private ushort _lenMaxStructure;
            private byte _entryPointRevision;
            private byte[] _formattedArea;
            private byte[] _intermediateAnchor;
            private LegacyEntryPoint _legacy;
            private SmbiosEntryPoint m_root;
            private SmbiosEntryPoint m_parent;
            public byte Checksum { get { return _checksum; } }

            /// <summary>
            /// 0x1f; some version 2.1 implementations use 0x1e, as that version of
            /// the specification stated by mistake.
            /// </summary>
            public byte LenEntryPoint { get { return _lenEntryPoint; } }
            public byte MajorVersion { get { return _majorVersion; } }
            public byte MinorVersion { get { return _minorVersion; } }

            /// <summary>
            /// Size of the largest structure, strings included.
            /// </summary>
            public ushort LenMaxStructure { get { return _lenMaxStructure; } }

            /// <summary>
            /// 0 for the SMBIOS 2.1 definition.
            /// </summary>
            public byte EntryPointRevision { get { return _entryPointRevision; } }

            /// <summary>
            /// Zero for `entry_point_revision` 0.
            /// </summary>
            public byte[] FormattedArea { get { return _formattedArea; } }
            public byte[] IntermediateAnchor { get { return _intermediateAnchor; } }

            /// <summary>
            /// Intermediate entry point, for legacy DMI browsers.
            /// </summary>
            public LegacyEntryPoint Legacy { get { return _legacy; } }
            public SmbiosEntryPoint M_Root { get { return m_root; } }
            public SmbiosEntryPoint M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// SMBIOS 3.0 (64-bit) entry point, after the `_SM3` part of the anchor.
        /// </summary>
        public partial class EntryPoint64 : KaitaiStruct
        {
            public static EntryPoint64 FromFile(string fileName)
            {
                return new EntryPoint64(new KaitaiStream(fileName));
            }

            public EntryPoint64(KaitaiStream p__io, SmbiosEntryPoint p__parent = null, SmbiosEntryPoint p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                f_table = false;
                _read();
            }
            private void _read()
            {
                _magic = m_io.ReadBytes(1);
                if (!((KaitaiStream.ByteArrayCompare(_magic, new byte[] { 95 }) == 0)))
                {
                    throw new ValidationNotEqualError(new byte[] { 95 }, _magic, m_io, "/types/entry_point_64/seq/0");
                }
                _checksum = m_io.ReadU1();
                _lenEntryPoint = m_io.ReadU1();
                _majorVersion = m_io.ReadU1();
                _minorVersion = m_io.ReadU1();
                _docrev = m_io.ReadU1();
                _entryPointRevision = m_io.ReadU1();
                _reserved = m_io.ReadU1();
                _maxLenStructureTable = m_io.ReadU4le();
                _ofsStructureTable = m_io.ReadU8le();
            }
            private bool f_table;
            private Smbios _table;
            public Smbios Table
            {
                get
                {
                    if (f_table)
                        return _table;
                    f_table = true;
                    if (((long) (OfsStructureTable)) < M_Io.Size) {
                        KaitaiStream io = M_Io;
                        long _pos = io.Pos;
                        io.Seek(((long) (OfsStructureTable)));
                        __raw_table = io.ReadBytes((((long) (OfsStructureTable)) + MaxLenStructureTable <= M_Io.Size ? MaxLenStructureTable : M_Io.Size - ((long) (OfsStructureTable))));
                        var io___raw_table = new KaitaiStream(__raw_table);
                        _table = new Smbios(io___raw_table);
                        io.Seek(_pos);
                    }
                    return _table;
                }
            }
            private byte[] _magic;
            private byte _checksum;
            private byte _lenEntryPoint;
            private byte _majorVersion;
            private byte _minorVersion;
            private byte _docrev;
            private byte _entryPointRevision;
            private byte _reserved;
            private uint _maxLenStructureTable;
            private ulong _ofsStructureTable;
            private SmbiosEntryPoint m_root;
            private SmbiosEntryPoint m_parent;
            private byte[] __raw_table;

            /// <summary>
            /// Last byte of the `_SM3_` anchor.
            /// </summary>
            public byte[] Magic { get { return _magic; } }
            public byte Checksum { get { return _checksum; } }

            /// <summary>
            /// 0x18.
            /// </summary>
            public byte LenEntryPoint { get { return _lenEntryPoint; } }
            public byte MajorVersion { get { return _majorVersion; } }
            public byte MinorVersion { get { return _minorVersion; } }

            /// <summary>
            /// Third part of the version, e.g. 1 for 2.7.1.
            /// </summary>
            public byte Docrev { get { return _docrev; } }

            /// <summary>
            /// 1 for the SMBIOS 3.0 definition.
            /// </summary>
            public byte EntryPointRevision { get { return _entryPointRevision; } }
            public byte Reserved { get { return _reserved; } }

            /// <summary>
            /// The table is at most this long and ends with an end-of-table structure.
            /// </summary>
            public uint MaxLenStructureTable { get { return _maxLenStructureTable; } }

            /// <summary>
            /// Physical address of the structure table.
            /// </summary>
            public ulong OfsStructureTable { get { return _ofsStructureTable; } }
            public SmbiosEntryPoint M_Root { get { return m_root; } }
            public SmbiosEntryPoint M_Parent { get { return m_parent; } }
            public byte[] M_RawTable { get { return __raw_table; } }
        }

        /// <summary>
        /// DMI 2.0 entry point, or the intermediate entry point that a 32-bit
        /// SMBIOS entry point embeds.
        /// </summary>
        public partial class LegacyEntryPoint : KaitaiStruct
        {
            public static LegacyEntryPoint FromFile(string fileName)
            {
                return new LegacyEntryPoint(new KaitaiStream(fileName));
            }

            public LegacyEntryPoint(KaitaiStream p__io, KaitaiStruct p__parent = null, SmbiosEntryPoint p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                f_table = false;
                _read();
            }
            private void _read()
            {
                _magic = m_io.ReadBytes(1);
                if (!((KaitaiStream.ByteArrayCompare(_magic, new byte[] { 95 }) == 0)))
                {
                    throw new ValidationNotEqualError(new byte[] { 95 }, _magic, m_io, "/types/legacy_entry_point/seq/0");
                }
                _checksum = m_io.ReadU1();
                _lenStructureTable = m_io.ReadU2le();
                _ofsStructureTable = m_io.ReadU4le();
                _numStructures = m_io.ReadU2le();
                _bcdRevision = m_io.ReadU1();
            }
            private bool f_table;
            private Smbios _table;
            public Smbios Table
            {
                get
                {
                    if (f_table)
                        return _table;
                    f_table = true;
                    if (OfsStructureTable + LenStructureTable <= M_Io.Size) {
                        KaitaiStream io = M_Io;
                        long _pos = io.Pos;
                        io.Seek(((long) (OfsStructureTable)));
                        __raw_table = io.ReadBytes(LenStructureTable);
                        var io___raw_table = new KaitaiStream(__raw_table);
                        _table = new Smbios(io___raw_table);
                        io.Seek(_pos);
                    }
                    return _table;
                }
            }
            private byte[] _magic;
            private byte _checksum;
            private ushort _lenStructureTable;
            private uint _ofsStructureTable;
            private ushort _numStructures;
            private byte _bcdRevision;
            private SmbiosEntryPoint m_root;
            private KaitaiStruct m_parent;
            private byte[] __raw_table;

            /// <summary>
            /// Last byte of the `_DMI_` anchor.
            /// </summary>
            public byte[] Magic { get { return _magic; } }
            public byte Checksum { get { return _checksum; } }
            public ushort LenStructureTable { get { return _lenStructureTable; } }

            /// <summary>
            /// Physical address of the structure table.
            /// </summary>
            public uint OfsStructureTable { get { return _ofsStructureTable; } }
            public ushort NumStructures { get { return _numStructures; } }

            /// <summary>
            /// Version in BCD, e.g. 0x21 for 2.1; 0 if only `major_version` and
            /// `minor_version` of the 32-bit entry point give it.
            /// </summary>
            public byte BcdRevision { get { return _bcdRevision; } }
            public SmbiosEntryPoint M_Root { get { return m_root; } }
            public KaitaiStruct M_Parent { get { return m_parent; } }
            public byte[] M_RawTable { get { return __raw_table; } }
        }
        private string _anchor;
        private KaitaiStruct _body;
        private SmbiosEntryPoint m_root;
        private KaitaiStruct m_parent;
        public string Anchor { get { return _anchor; } }
        public KaitaiStruct Body { get { return _body; } }
        public SmbiosEntryPoint M_Root { get { return m_root; } }
        public KaitaiStruct M_Parent { get { return m_parent; } }
    }
}
