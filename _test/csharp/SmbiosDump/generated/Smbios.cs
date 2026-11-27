// This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

using System.Collections.Generic;

namespace Kaitai
{

    /// <summary>
    /// SMBIOS (System Management BIOS) is the standard way for the firmware of a
    /// computer to tell the operating system what hardware it runs on: vendor,
    /// model and serial numbers, processors, caches, memory modules, slots, ports,
    /// sensors, power supplies and so on. The data that `dmidecode` prints comes
    /// from this table.
    /// 
    /// This spec describes the structure table itself, as DSP0134 3.10.0 defines
    /// it: a packed sequence of structures that normally ends with one of type
    /// 127 (end of table). Linux exposes it as `/sys/firmware/dmi/tables/DMI`.
    /// The entry point (`_SM_`, `_SM3_` or `_DMI_` anchor) that tells where the
    /// table is in memory is described by `smbios_entry_point`; a file written by
    /// `dmidecode --dump-bin` starts with a copy of the entry point and has the
    /// table at offset 0x20.
    /// 
    /// Every structure consists of a 4-byte header, a formatted area whose length
    /// depends on the version of the standard the firmware follows, and a set of
    /// strings that fields of the formatted area refer to by number. Fields that
    /// later versions of the standard added at the end of a formatted area are
    /// only present if the formatted area is long enough, and are null otherwise;
    /// bytes that a newer version adds after the last field known here are left
    /// unparsed. Structure types 128 to 255 are OEM-specific and are not parsed.
    /// 
    /// Bit numbers in the docs are counted from the least significant bit.
    /// </summary>
    /// <remarks>
    /// Reference: <a href="https://www.dmtf.org/standards/smbios">Source</a>
    /// </remarks>
    /// <remarks>
    /// Reference: <a href="https://www.dmtf.org/sites/default/files/standards/documents/DSP0134_3.10.0.pdf">Source</a>
    /// </remarks>
    public partial class Smbios : KaitaiStruct
    {
        public static Smbios FromFile(string fileName)
        {
            return new Smbios(new KaitaiStream(fileName));
        }


        public enum Aarch64DataSubType
        {
            Architecture = 0,
            VendorSpecific = 1,
        }

        public enum BatteryChemistry
        {
            Other = 1,
            Unknown = 2,
            LeadAcid = 3,
            NickelCadmium = 4,
            NickelMetalHydride = 5,
            LithiumIon = 6,
            ZincAir = 7,
            LithiumPolymer = 8,
        }

        public enum BoardType
        {
            Unknown = 1,
            Other = 2,
            ServerBlade = 3,
            ConnectivitySwitch = 4,
            SystemManagementModule = 5,
            ProcessorModule = 6,
            IoModule = 7,
            MemoryModule = 8,
            DaughterBoard = 9,
            Motherboard = 10,
            ProcessorMemoryModule = 11,
            ProcessorIoModule = 12,
            InterconnectBoard = 13,
        }

        public enum BootStatus
        {
            NoErrors = 0,
            NoBootableMedia = 1,
            OperatingSystemFailedToLoad = 2,
            FirmwareDetectedHardwareFailure = 3,
            OperatingSystemDetectedHardwareFailure = 4,
            UserRequestedBoot = 5,
            SystemSecurityViolation = 6,
            PreviouslyRequestedImage = 7,
            WatchdogTimerExpired = 8,
        }

        public enum CacheAssociativity
        {
            Other = 1,
            Unknown = 2,
            DirectMapped = 3,
            SetAssociative2Way = 4,
            SetAssociative4Way = 5,
            FullyAssociative = 6,
            SetAssociative8Way = 7,
            SetAssociative16Way = 8,
            SetAssociative12Way = 9,
            SetAssociative24Way = 10,
            SetAssociative32Way = 11,
            SetAssociative48Way = 12,
            SetAssociative64Way = 13,
            SetAssociative20Way = 14,
        }

        public enum CacheErrorCorrectionType
        {
            Other = 1,
            Unknown = 2,
            None = 3,
            Parity = 4,
            SingleBitEcc = 5,
            MultiBitEcc = 6,
        }

        public enum CacheLocation
        {
            Internal = 0,
            External = 1,
            Reserved = 2,
            Unknown = 3,
        }

        public enum CacheOperationalMode
        {
            WriteThrough = 0,
            WriteBack = 1,
            VariesWithMemoryAddress = 2,
            Unknown = 3,
        }

        public enum ChassisSecurityStatus
        {
            Other = 1,
            Unknown = 2,
            None = 3,
            ExternalInterfaceLockedOut = 4,
            ExternalInterfaceEnabled = 5,
        }

        public enum ChassisState
        {
            Other = 1,
            Unknown = 2,
            Safe = 3,
            Warning = 4,
            Critical = 5,
            NonRecoverable = 6,
        }

        public enum ChassisType
        {
            Other = 1,
            Unknown = 2,
            Desktop = 3,
            LowProfileDesktop = 4,
            PizzaBox = 5,
            MiniTower = 6,
            Tower = 7,
            Portable = 8,
            Laptop = 9,
            Notebook = 10,
            HandHeld = 11,
            DockingStation = 12,
            AllInOne = 13,
            SubNotebook = 14,
            SpaceSaving = 15,
            LunchBox = 16,
            MainServerChassis = 17,
            ExpansionChassis = 18,
            SubChassis = 19,
            BusExpansionChassis = 20,
            PeripheralChassis = 21,
            RaidChassis = 22,
            RackMountChassis = 23,
            SealedCasePc = 24,
            MultiSystemChassis = 25,
            CompactPci = 26,
            AdvancedTca = 27,
            Blade = 28,
            BladeEnclosure = 29,
            Tablet = 30,
            Convertible = 31,
            Detachable = 32,
            IotGateway = 33,
            EmbeddedPc = 34,
            MiniPc = 35,
            StickPc = 36,
        }

        public enum ConnectorType
        {
            None = 0,
            Centronics = 1,
            MiniCentronics = 2,
            Proprietary = 3,
            Db25PinMale = 4,
            Db25PinFemale = 5,
            Db15PinMale = 6,
            Db15PinFemale = 7,
            Db9PinMale = 8,
            Db9PinFemale = 9,
            Rj11 = 10,
            Rj45 = 11,
            MiniScsi50Pin = 12,
            MiniDin = 13,
            MicroDin = 14,
            Ps2 = 15,
            Infrared = 16,
            HpHil = 17,
            AccessBusUsb = 18,
            SsaScsi = 19,
            CircularDin8Male = 20,
            CircularDin8Female = 21,
            OnBoardIde = 22,
            OnBoardFloppy = 23,
            DualInline9Pin = 24,
            DualInline25Pin = 25,
            DualInline50Pin = 26,
            DualInline68Pin = 27,
            OnBoardSoundInputFromCdRom = 28,
            MiniCentronicsType14 = 29,
            MiniCentronicsType26 = 30,
            MiniJackHeadphones = 31,
            Bnc = 32,
            Ieee1394 = 33,
            SasSataPlugReceptacle = 34,
            UsbTypeCReceptacle = 35,
            Pc98 = 160,
            Pc98Hireso = 161,
            PcH98 = 162,
            Pc98Note = 163,
            Pc98Full = 164,
            Other = 255,
        }

        public enum CoolingDeviceType
        {
            Other = 1,
            Unknown = 2,
            Fan = 3,
            CentrifugalBlower = 4,
            ChipFan = 5,
            CabinetFan = 6,
            PowerSupplyFan = 7,
            HeatPipe = 8,
            IntegratedRefrigeration = 9,
            ActiveCooling = 16,
            PassiveCooling = 17,
        }

        public enum CpuStatus
        {
            Unknown = 0,
            Enabled = 1,
            DisabledByUser = 2,
            DisabledByFirmware = 3,
            Idle = 4,
            Other = 7,
        }

        public enum ErrorDetectingMethod
        {
            Other = 1,
            Unknown = 2,
            None = 3,
            Parity8Bit = 4,
            Ecc32Bit = 5,
            Ecc64Bit = 6,
            Ecc128Bit = 7,
            Crc = 8,
        }

        public enum EventLogAccessMethod
        {
            IndexedIo18BitIndex18BitData = 0,
            IndexedIo28BitIndex18BitData = 1,
            IndexedIo116BitIndex18BitData = 2,
            MemoryMapped32 = 3,
            Gpnv = 4,
        }

        public enum EventLogHeaderFormat
        {
            NoHeader = 0,
            Type1 = 1,
        }

        public enum EventLogType
        {
            SingleBitEccMemoryError = 1,
            MultiBitEccMemoryError = 2,
            ParityMemoryError = 3,
            BusTimeout = 4,
            IoChannelCheck = 5,
            SoftwareNmi = 6,
            PostMemoryResize = 7,
            PostError = 8,
            PciParityError = 9,
            PciSystemError = 10,
            CpuFailure = 11,
            EisaFailsafeTimerTimeout = 12,
            CorrectableMemoryLogDisabled = 13,
            LoggingDisabledForEventType = 14,
            SystemLimitExceeded = 16,
            AsynchronousHardwareTimerExpired = 17,
            SystemConfigurationInformation = 18,
            HardDiskInformation = 19,
            SystemReconfigured = 20,
            UncorrectableCpuComplexError = 21,
            LogAreaReset = 22,
            SystemBoot = 23,
            EndOfLog = 255,
        }

        public enum EventLogVariableDataFormat
        {
            None = 0,
            Handle = 1,
            MultipleEvent = 2,
            MultipleEventHandle = 3,
            PostResultsBitmap = 4,
            SystemManagementType = 5,
            MultipleEventSystemManagementType = 6,
        }

        public enum ExtendedRomSizeUnit
        {
            Mib = 0,
            Gib = 1,
        }

        public enum FirmwareIdFormat
        {
            FreeForm = 0,
            UefiGuid = 1,
        }

        public enum FirmwareState
        {
            Other = 1,
            Unknown = 2,
            Disabled = 3,
            Enabled = 4,
            Absent = 5,
            StandbyOffline = 6,
            StandbySpare = 7,
            UnavailableOffline = 8,
        }

        public enum FirmwareVersionFormat
        {
            FreeForm = 0,
            MajorMinor = 1,
            Hex32Bit = 2,
            Hex64Bit = 3,
        }

        public enum HardwareSecurityStatus
        {
            Disabled = 0,
            Enabled = 1,
            NotImplemented = 2,
            Unknown = 3,
        }

        public enum HostInterfaceProtocolType
        {
            Ipmi = 2,
            Mctp = 3,
            RedfishOverIp = 4,
            Oem = 240,
        }

        public enum HostInterfaceType
        {
            Network = 64,
            Oem = 240,
        }

        public enum InterleaveSupport
        {
            Other = 1,
            Unknown = 2,
            OneWay = 3,
            TwoWay = 4,
            FourWay = 5,
            EightWay = 6,
            SixteenWay = 7,
        }

        public enum IpmiInterfaceType
        {
            Unknown = 0,
            Kcs = 1,
            Smic = 2,
            Bt = 3,
            Ssif = 4,
        }

        public enum IpmiRegisterSpacing
        {
            SuccessiveBytes = 0,
            Boundary32Bit = 1,
            Boundary16Byte = 2,
            Reserved = 3,
        }

        public enum ManagementDeviceAddressType
        {
            Other = 1,
            Unknown = 2,
            IoPort = 3,
            Memory = 4,
            SmBus = 5,
        }

        public enum ManagementDeviceType
        {
            Other = 1,
            Unknown = 2,
            Lm75 = 3,
            Lm78 = 4,
            Lm79 = 5,
            Lm80 = 6,
            Lm81 = 7,
            Adm9240 = 8,
            Ds1780 = 9,
            Maxim1617 = 10,
            Gl518sm = 11,
            W83781d = 12,
            Ht82h791 = 13,
        }

        public enum MemoryArrayErrorCorrection
        {
            Other = 1,
            Unknown = 2,
            None = 3,
            Parity = 4,
            SingleBitEcc = 5,
            MultiBitEcc = 6,
            Crc = 7,
        }

        public enum MemoryArrayLocation
        {
            Other = 1,
            Unknown = 2,
            SystemBoard = 3,
            IsaAddOnCard = 4,
            EisaAddOnCard = 5,
            PciAddOnCard = 6,
            McaAddOnCard = 7,
            PcmciaAddOnCard = 8,
            ProprietaryAddOnCard = 9,
            Nubus = 10,
            Pc98C20AddOnCard = 160,
            Pc98C24AddOnCard = 161,
            Pc98EAddOnCard = 162,
            Pc98LocalBusAddOnCard = 163,
            CxlAddOnCard = 164,
        }

        public enum MemoryArrayUse
        {
            Other = 1,
            Unknown = 2,
            SystemMemory = 3,
            VideoMemory = 4,
            FlashMemory = 5,
            NonVolatileRam = 6,
            CacheMemory = 7,
        }

        public enum MemoryChannelType
        {
            Other = 1,
            Unknown = 2,
            Rambus = 3,
            Synclink = 4,
        }

        public enum MemoryDeviceType
        {
            Other = 1,
            Unknown = 2,
            Dram = 3,
            Edram = 4,
            Vram = 5,
            Sram = 6,
            Ram = 7,
            Rom = 8,
            Flash = 9,
            Eeprom = 10,
            Feprom = 11,
            Eprom = 12,
            Cdram = 13,
            Ram3d = 14,
            Sdram = 15,
            Sgram = 16,
            Rdram = 17,
            Ddr = 18,
            Ddr2 = 19,
            Ddr2FbDimm = 20,
            Ddr3 = 24,
            Fbd2 = 25,
            Ddr4 = 26,
            Lpddr = 27,
            Lpddr2 = 28,
            Lpddr3 = 29,
            Lpddr4 = 30,
            LogicalNonVolatileDevice = 31,
            Hbm = 32,
            Hbm2 = 33,
            Ddr5 = 34,
            Lpddr5 = 35,
            Hbm3 = 36,
            Mrdimm = 37,
            Lpddr6 = 38,
        }

        public enum MemoryErrorGranularity
        {
            Other = 1,
            Unknown = 2,
            DeviceLevel = 3,
            MemoryPartitionLevel = 4,
        }

        public enum MemoryErrorOperation
        {
            Other = 1,
            Unknown = 2,
            Read = 3,
            Write = 4,
            PartialWrite = 5,
        }

        public enum MemoryErrorType
        {
            Other = 1,
            Unknown = 2,
            Ok = 3,
            BadRead = 4,
            ParityError = 5,
            SingleBitError = 6,
            DoubleBitError = 7,
            MultiBitError = 8,
            NibbleError = 9,
            ChecksumError = 10,
            CrcError = 11,
            CorrectedSingleBitError = 12,
            CorrectedError = 13,
            UncorrectableError = 14,
        }

        public enum MemoryFormFactor
        {
            Other = 1,
            Unknown = 2,
            Simm = 3,
            Sip = 4,
            Chip = 5,
            Dip = 6,
            Zip = 7,
            ProprietaryCard = 8,
            Dimm = 9,
            Tsop = 10,
            RowOfChips = 11,
            Rimm = 12,
            Sodimm = 13,
            Srimm = 14,
            FbDimm = 15,
            Die = 16,
            Camm = 17,
            Cudimm = 18,
            Csodimm = 19,
        }

        public enum MemoryTechnology
        {
            Other = 1,
            Unknown = 2,
            Dram = 3,
            NvdimmN = 4,
            NvdimmF = 5,
            NvdimmP = 6,
            IntelOptanePersistentMemory = 7,
            Mrdimm = 8,
        }

        public enum OnboardDeviceType
        {
            Other = 1,
            Unknown = 2,
            Video = 3,
            ScsiController = 4,
            Ethernet = 5,
            TokenRing = 6,
            Sound = 7,
            PataController = 8,
            SataController = 9,
            SasController = 10,
            WirelessLan = 11,
            Bluetooth = 12,
            Wwan = 13,
            Emmc = 14,
            NvmeController = 15,
            UfsController = 16,
            InfinibandController = 17,
            GpuController = 18,
        }

        public enum PointingDeviceInterface
        {
            Other = 1,
            Unknown = 2,
            Serial = 3,
            Ps2 = 4,
            Infrared = 5,
            HpHil = 6,
            BusMouse = 7,
            Adb = 8,
            BusMouseDb9 = 160,
            BusMouseMicroDin = 161,
            Usb = 162,
            I2c = 163,
            Spi = 164,
        }

        public enum PointingDeviceType
        {
            Other = 1,
            Unknown = 2,
            Mouse = 3,
            TrackBall = 4,
            TrackPoint = 5,
            GlidePoint = 6,
            TouchPad = 7,
            TouchScreen = 8,
            OpticalSensor = 9,
        }

        public enum PortType
        {
            None = 0,
            ParallelPortXtAtCompatible = 1,
            ParallelPortPs2 = 2,
            ParallelPortEcp = 3,
            ParallelPortEpp = 4,
            ParallelPortEcpEpp = 5,
            SerialPortXtAtCompatible = 6,
            SerialPort16450Compatible = 7,
            SerialPort16550Compatible = 8,
            SerialPort16550aCompatible = 9,
            ScsiPort = 10,
            MidiPort = 11,
            JoyStickPort = 12,
            KeyboardPort = 13,
            MousePort = 14,
            SsaScsi = 15,
            Usb = 16,
            Firewire = 17,
            PcmciaTypeI = 18,
            PcmciaTypeIi = 19,
            PcmciaTypeIii = 20,
            Cardbus = 21,
            AccessBusPort = 22,
            ScsiIi = 23,
            ScsiWide = 24,
            Pc98 = 25,
            Pc98Hireso = 26,
            PcH98 = 27,
            VideoPort = 28,
            AudioPort = 29,
            ModemPort = 30,
            NetworkPort = 31,
            Sata = 32,
            Sas = 33,
            Mfdp = 34,
            Thunderbolt = 35,
            Compatible8251 = 160,
            FifoCompatible8251 = 161,
            Other = 255,
        }

        public enum PowerSupplyRangeSwitching
        {
            Other = 1,
            Unknown = 2,
            Manual = 3,
            AutoSwitch = 4,
            WideRange = 5,
            NotApplicable = 6,
        }

        public enum PowerSupplyType
        {
            Other = 1,
            Unknown = 2,
            Linear = 3,
            Switching = 4,
            Battery = 5,
            Ups = 6,
            Converter = 7,
            Regulator = 8,
        }

        public enum ProbeLocation
        {
            Other = 1,
            Unknown = 2,
            Processor = 3,
            Disk = 4,
            PeripheralBay = 5,
            SystemManagementModule = 6,
            Motherboard = 7,
            MemoryModule = 8,
            ProcessorModule = 9,
            PowerUnit = 10,
            AddInCard = 11,
            FrontPanelBoard = 12,
            BackPanelBoard = 13,
            PowerSystemBoard = 14,
            DriveBackPlane = 15,
        }

        public enum ProbeStatus
        {
            Other = 1,
            Unknown = 2,
            Ok = 3,
            NonCritical = 4,
            Critical = 5,
            NonRecoverable = 6,
        }

        public enum ProcessorArchitectureType
        {
            Ia32 = 1,
            X64 = 2,
            Itanium = 3,
            Aarch32 = 4,
            Aarch64 = 5,
            RiscvRv32 = 6,
            RiscvRv64 = 7,
            RiscvRv128 = 8,
            Loongarch32 = 9,
            Loongarch64 = 10,
        }

        public enum ProcessorFamily
        {
            Other = 1,
            Unknown = 2,
            I8086 = 3,
            I80286 = 4,
            Intel386 = 5,
            Intel486 = 6,
            I8087 = 7,
            I80287 = 8,
            I80387 = 9,
            I80487 = 10,
            IntelPentium = 11,
            PentiumPro = 12,
            PentiumIi = 13,
            PentiumMmx = 14,
            IntelCeleron = 15,
            PentiumIiXeon = 16,
            PentiumIii = 17,
            M1 = 18,
            M2 = 19,
            IntelCeleronM = 20,
            IntelPentium4Ht = 21,
            IntelProcessor = 22,
            AmdDuron = 24,
            K5 = 25,
            K6 = 26,
            K62 = 27,
            K63 = 28,
            AmdAthlon = 29,
            Amd29000 = 30,
            K62Plus = 31,
            PowerPc = 32,
            PowerPc601 = 33,
            PowerPc603 = 34,
            PowerPc603Plus = 35,
            PowerPc604 = 36,
            PowerPc620 = 37,
            PowerPcX704 = 38,
            PowerPc750 = 39,
            IntelCoreDuo = 40,
            IntelCoreDuoMobile = 41,
            IntelCoreSoloMobile = 42,
            IntelAtom = 43,
            IntelCoreM = 44,
            IntelCoreM3 = 45,
            IntelCoreM5 = 46,
            IntelCoreM7 = 47,
            Alpha = 48,
            Alpha21064 = 49,
            Alpha21066 = 50,
            Alpha21164 = 51,
            Alpha21164pc = 52,
            Alpha21164a = 53,
            Alpha21264 = 54,
            Alpha21364 = 55,
            AmdTurionIiUltraDualCoreMobileM = 56,
            AmdTurionIiDualCoreMobileM = 57,
            AmdAthlonIiDualCoreM = 58,
            AmdOpteron6100 = 59,
            AmdOpteron4100 = 60,
            AmdOpteron6200 = 61,
            AmdOpteron4200 = 62,
            AmdFx = 63,
            Mips = 64,
            MipsR4000 = 65,
            MipsR4200 = 66,
            MipsR4400 = 67,
            MipsR4600 = 68,
            MipsR10000 = 69,
            AmdCSeries = 70,
            AmdESeries = 71,
            AmdASeries = 72,
            AmdGSeries = 73,
            AmdZSeries = 74,
            AmdRSeries = 75,
            AmdOpteron4300 = 76,
            AmdOpteron6300 = 77,
            AmdOpteron3300 = 78,
            AmdFirepro = 79,
            Sparc = 80,
            Supersparc = 81,
            MicrosparcIi = 82,
            MicrosparcIiep = 83,
            Ultrasparc = 84,
            UltrasparcIi = 85,
            UltrasparcIiI = 86,
            UltrasparcIii = 87,
            UltrasparcIiiI = 88,
            M68040 = 96,
            M68xxx = 97,
            M68000 = 98,
            M68010 = 99,
            M68020 = 100,
            M68030 = 101,
            AmdAthlonX4QuadCore = 102,
            AmdOpteronX1000 = 103,
            AmdOpteronX2000Apu = 104,
            AmdOpteronASeries = 105,
            AmdOpteronX3000Apu = 106,
            AmdZen = 107,
            Hobbit = 112,
            CrusoeTm5000 = 120,
            CrusoeTm3000 = 121,
            EfficeonTm8000 = 122,
            Weitek = 128,
            Itanium = 130,
            AmdAthlon64 = 131,
            AmdOpteron = 132,
            AmdSempron = 133,
            AmdTurion64Mobile = 134,
            DualCoreAmdOpteron = 135,
            AmdAthlon64X2DualCore = 136,
            AmdTurion64X2Mobile = 137,
            QuadCoreAmdOpteron = 138,
            ThirdGenerationAmdOpteron = 139,
            AmdPhenomFxQuadCore = 140,
            AmdPhenomX4QuadCore = 141,
            AmdPhenomX2DualCore = 142,
            AmdAthlonX2DualCore = 143,
            PaRisc = 144,
            PaRisc8500 = 145,
            PaRisc8000 = 146,
            PaRisc7300lc = 147,
            PaRisc7200 = 148,
            PaRisc7100lc = 149,
            PaRisc7100 = 150,
            V30 = 160,
            QuadCoreIntelXeon3200 = 161,
            DualCoreIntelXeon3000 = 162,
            QuadCoreIntelXeon5300 = 163,
            DualCoreIntelXeon5100 = 164,
            DualCoreIntelXeon5000 = 165,
            DualCoreIntelXeonLv = 166,
            DualCoreIntelXeonUlv = 167,
            DualCoreIntelXeon7100 = 168,
            QuadCoreIntelXeon5400 = 169,
            QuadCoreIntelXeon = 170,
            DualCoreIntelXeon5200 = 171,
            DualCoreIntelXeon7200 = 172,
            QuadCoreIntelXeon7300 = 173,
            QuadCoreIntelXeon7400 = 174,
            MultiCoreIntelXeon7400 = 175,
            PentiumIiiXeon = 176,
            PentiumIiiSpeedstep = 177,
            Pentium4 = 178,
            IntelXeon = 179,
            As400 = 180,
            IntelXeonMp = 181,
            AmdAthlonXp = 182,
            AmdAthlonMp = 183,
            IntelItanium2 = 184,
            IntelPentiumM = 185,
            IntelCeleronD = 186,
            IntelPentiumD = 187,
            IntelPentiumExtremeEdition = 188,
            IntelCoreSolo = 189,
            ReservedCore2OrK7 = 190,
            IntelCore2Duo = 191,
            IntelCore2Solo = 192,
            IntelCore2Extreme = 193,
            IntelCore2Quad = 194,
            IntelCore2ExtremeMobile = 195,
            IntelCore2DuoMobile = 196,
            IntelCore2SoloMobile = 197,
            IntelCoreI7 = 198,
            DualCoreIntelCeleron = 199,
            Ibm390 = 200,
            G4 = 201,
            G5 = 202,
            Esa390G6 = 203,
            ZArchitectureBase = 204,
            IntelCoreI5 = 205,
            IntelCoreI3 = 206,
            IntelCoreI9 = 207,
            IntelXeonD = 208,
            ViaC7M = 210,
            ViaC7D = 211,
            ViaC7 = 212,
            ViaEden = 213,
            MultiCoreIntelXeon = 214,
            DualCoreIntelXeon3xxx = 215,
            QuadCoreIntelXeon3xxx = 216,
            ViaNano = 217,
            DualCoreIntelXeon5xxx = 218,
            QuadCoreIntelXeon5xxx = 219,
            DualCoreIntelXeon7xxx = 221,
            QuadCoreIntelXeon7xxx = 222,
            MultiCoreIntelXeon7xxx = 223,
            MultiCoreIntelXeon3400 = 224,
            AmdOpteron3000 = 228,
            AmdSempronIi = 229,
            EmbeddedAmdOpteronQuadCore = 230,
            AmdPhenomTripleCore = 231,
            AmdTurionUltraDualCoreMobile = 232,
            AmdTurionDualCoreMobile = 233,
            AmdAthlonDualCore = 234,
            AmdSempronSi = 235,
            AmdPhenomIi = 236,
            AmdAthlonIi = 237,
            SixCoreAmdOpteron = 238,
            AmdSempronM = 239,
            I860 = 250,
            I960 = 251,
            IndicatorFamily2 = 254,
            Armv7 = 256,
            Armv8 = 257,
            Armv9 = 258,
            Sh3 = 260,
            Sh4 = 261,
            Arm = 280,
            Strongarm = 281,
            Cyrix6x86 = 300,
            Mediagx = 301,
            Mii = 302,
            Winchip = 320,
            Dsp = 350,
            VideoProcessor = 500,
            RiscvRv32 = 512,
            RiscvRv64 = 513,
            RiscvRv128 = 514,
            Loongarch = 600,
            Loongson1 = 601,
            Loongson2 = 602,
            Loongson3 = 603,
            Loongson2k = 604,
            Loongson3a = 605,
            Loongson3b = 606,
            Loongson3c = 607,
            Loongson3d = 608,
            Loongson3e = 609,
            DualCoreLoongson2k2xxx = 610,
            QuadCoreLoongson3a5xxx = 620,
            MultiCoreLoongson3a5xxx = 621,
            QuadCoreLoongson3b5xxx = 622,
            MultiCoreLoongson3b5xxx = 623,
            MultiCoreLoongson3c5xxx = 624,
            MultiCoreLoongson3d5xxx = 625,
            IntelCore3 = 768,
            IntelCore5 = 769,
            IntelCore7 = 770,
            IntelCore9 = 771,
            IntelCoreUltra3 = 772,
            IntelCoreUltra5 = 773,
            IntelCoreUltra7 = 774,
            IntelCoreUltra9 = 775,
        }

        public enum ProcessorType
        {
            Other = 1,
            Unknown = 2,
            CentralProcessor = 3,
            MathProcessor = 4,
            DspProcessor = 5,
            VideoProcessor = 6,
        }

        public enum ProcessorUpgrade
        {
            Other = 1,
            Unknown = 2,
            DaughterBoard = 3,
            ZifSocket = 4,
            ReplaceablePiggyBack = 5,
            None = 6,
            LifSocket = 7,
            Slot1 = 8,
            Slot2 = 9,
            Socket370Pin = 10,
            SlotA = 11,
            SlotM = 12,
            Socket423 = 13,
            SocketA = 14,
            Socket478 = 15,
            Socket754 = 16,
            Socket940 = 17,
            Socket939 = 18,
            SocketMpga604 = 19,
            SocketLga771 = 20,
            SocketLga775 = 21,
            SocketS1 = 22,
            SocketAm2 = 23,
            SocketF = 24,
            SocketLga1366 = 25,
            SocketG34 = 26,
            SocketAm3 = 27,
            SocketC32 = 28,
            SocketLga1156 = 29,
            SocketLga1567 = 30,
            SocketPga988a = 31,
            SocketBga1288 = 32,
            SocketRpga988b = 33,
            SocketBga1023 = 34,
            SocketBga1224 = 35,
            SocketLga1155 = 36,
            SocketLga1356 = 37,
            SocketLga2011 = 38,
            SocketFs1 = 39,
            SocketFs2 = 40,
            SocketFm1 = 41,
            SocketFm2 = 42,
            SocketLga20113 = 43,
            SocketLga13563 = 44,
            SocketLga1150 = 45,
            SocketBga1168 = 46,
            SocketBga1234 = 47,
            SocketBga1364 = 48,
            SocketAm4 = 49,
            SocketLga1151 = 50,
            SocketBga1356 = 51,
            SocketBga1440 = 52,
            SocketBga1515 = 53,
            SocketLga36471 = 54,
            SocketSp3 = 55,
            SocketSp3r2 = 56,
            SocketLga2066 = 57,
            SocketBga1392 = 58,
            SocketBga1510 = 59,
            SocketBga1528 = 60,
            SocketLga4189 = 61,
            SocketLga1200 = 62,
            SocketLga4677 = 63,
            SocketLga1700 = 64,
            SocketBga1744 = 65,
            SocketBga1781 = 66,
            SocketBga1211 = 67,
            SocketBga2422 = 68,
            SocketLga1211 = 69,
            SocketLga2422 = 70,
            SocketLga5773 = 71,
            SocketBga5773 = 72,
            SocketAm5 = 73,
            SocketSp5 = 74,
            SocketSp6 = 75,
            SocketBga883 = 76,
            SocketBga1190 = 77,
            SocketBga4129 = 78,
            SocketLga4710 = 79,
            SocketLga7529 = 80,
            SocketBga1964 = 81,
            SocketBga1792 = 82,
            SocketBga2049 = 83,
            SocketBga2551 = 84,
            SocketLga1851 = 85,
            SocketBga2114 = 86,
            SocketBga2833 = 87,
            OtherSocket = 255,
        }

        public enum RackType
        {
            Unspecified = 0,
            Ou = 1,
        }

        public enum SlotCurrentUsage
        {
            Other = 1,
            Unknown = 2,
            Available = 3,
            InUse = 4,
            Unavailable = 5,
        }

        public enum SlotHeight
        {
            NotApplicable = 0,
            Other = 1,
            Unknown = 2,
            FullHeight = 3,
            LowProfile = 4,
        }

        public enum SlotLength
        {
            Other = 1,
            Unknown = 2,
            ShortLength = 3,
            LongLength = 4,
            DriveFormFactor25Inch = 5,
            DriveFormFactor35Inch = 6,
        }

        public enum SlotType
        {
            Other = 1,
            Unknown = 2,
            Isa = 3,
            Mca = 4,
            Eisa = 5,
            Pci = 6,
            PcCard = 7,
            VlVesa = 8,
            Proprietary = 9,
            ProcessorCardSlot = 10,
            ProprietaryMemoryCardSlot = 11,
            IoRiserCardSlot = 12,
            Nubus = 13,
            Pci66mhzCapable = 14,
            Agp = 15,
            Agp2x = 16,
            Agp4x = 17,
            PciX = 18,
            Agp8x = 19,
            M2Socket1DpKeyA = 20,
            M2Socket1SdKeyE = 21,
            M2Socket2KeyB = 22,
            M2Socket3KeyM = 23,
            MxmTypeI = 24,
            MxmTypeIi = 25,
            MxmTypeIiiStandardConnector = 26,
            MxmTypeIiiHeConnector = 27,
            MxmTypeIv = 28,
            Mxm30TypeA = 29,
            Mxm30TypeB = 30,
            PciExpressGen2Sff8639 = 31,
            PciExpressGen3Sff8639 = 32,
            PciExpressMini52PinWithBottomSideKeepOuts = 33,
            PciExpressMini52PinWithoutBottomSideKeepOuts = 34,
            PciExpressMini76Pin = 35,
            PciExpressGen4Sff8639 = 36,
            PciExpressGen5Sff8639 = 37,
            OcpNic30Sff = 38,
            OcpNic30Lff = 39,
            OcpNicPriorTo30 = 40,
            CxlFlexbus10 = 48,
            Pc98C20 = 160,
            Pc98C24 = 161,
            Pc98E = 162,
            Pc98LocalBus = 163,
            Pc98Card = 164,
            PciExpress = 165,
            PciExpressX1 = 166,
            PciExpressX2 = 167,
            PciExpressX4 = 168,
            PciExpressX8 = 169,
            PciExpressX16 = 170,
            PciExpressGen2 = 171,
            PciExpressGen2X1 = 172,
            PciExpressGen2X2 = 173,
            PciExpressGen2X4 = 174,
            PciExpressGen2X8 = 175,
            PciExpressGen2X16 = 176,
            PciExpressGen3 = 177,
            PciExpressGen3X1 = 178,
            PciExpressGen3X2 = 179,
            PciExpressGen3X4 = 180,
            PciExpressGen3X8 = 181,
            PciExpressGen3X16 = 182,
            PciExpressGen4 = 184,
            PciExpressGen4X1 = 185,
            PciExpressGen4X2 = 186,
            PciExpressGen4X4 = 187,
            PciExpressGen4X8 = 188,
            PciExpressGen4X16 = 189,
            PciExpressGen5 = 190,
            PciExpressGen5X1 = 191,
            PciExpressGen5X2 = 192,
            PciExpressGen5X4 = 193,
            PciExpressGen5X8 = 194,
            PciExpressGen5X16 = 195,
            PciExpressGen6AndBeyond = 196,
            EdsffE1 = 197,
            EdsffE3 = 198,
        }

        public enum SlotWidth
        {
            Other = 1,
            Unknown = 2,
            Bit8 = 3,
            Bit16 = 4,
            Bit32 = 5,
            Bit64 = 6,
            Bit128 = 7,
            X1 = 8,
            X2 = 9,
            X4 = 10,
            X8 = 11,
            X12 = 12,
            X16 = 13,
            X32 = 14,
        }

        public enum StringPropertyId
        {
            UefiDevicePath = 1,
        }

        public enum StructureType
        {
            PlatformFirmwareInformation = 0,
            SystemInformation = 1,
            BaseboardInformation = 2,
            SystemEnclosure = 3,
            ProcessorInformation = 4,
            MemoryControllerInformation = 5,
            MemoryModuleInformation = 6,
            CacheInformation = 7,
            PortConnectorInformation = 8,
            SystemSlots = 9,
            OnBoardDevicesInformation = 10,
            OemStrings = 11,
            SystemConfigurationOptions = 12,
            FirmwareLanguageInformation = 13,
            GroupAssociations = 14,
            SystemEventLog = 15,
            PhysicalMemoryArray = 16,
            MemoryDevice = 17,
            MemoryErrorInformation32 = 18,
            MemoryArrayMappedAddress = 19,
            MemoryDeviceMappedAddress = 20,
            BuiltInPointingDevice = 21,
            PortableBattery = 22,
            SystemReset = 23,
            HardwareSecurity = 24,
            SystemPowerControls = 25,
            VoltageProbe = 26,
            CoolingDevice = 27,
            TemperatureProbe = 28,
            ElectricalCurrentProbe = 29,
            OutOfBandRemoteAccess = 30,
            BootIntegrityServices = 31,
            SystemBootInformation = 32,
            MemoryErrorInformation64 = 33,
            ManagementDevice = 34,
            ManagementDeviceComponent = 35,
            ManagementDeviceThresholdData = 36,
            MemoryChannel = 37,
            IpmiDeviceInformation = 38,
            SystemPowerSupply = 39,
            AdditionalInformation = 40,
            OnboardDevicesExtendedInformation = 41,
            ManagementControllerHostInterface = 42,
            TpmDevice = 43,
            ProcessorAdditionalInformation = 44,
            FirmwareInventoryInformation = 45,
            StringProperty = 46,
            Inactive = 126,
            EndOfTable = 127,
        }

        public enum SystemCacheType
        {
            Other = 1,
            Unknown = 2,
            Instruction = 3,
            Data = 4,
            Unified = 5,
        }

        public enum SystemResetBootOption
        {
            OperatingSystem = 1,
            SystemUtilities = 2,
            DoNotReboot = 3,
        }

        public enum WakeUpType
        {
            Reserved = 0,
            Other = 1,
            Unknown = 2,
            ApmTimer = 3,
            ModemRing = 4,
            LanRemote = 5,
            PowerSwitch = 6,
            PciPme = 7,
            AcPowerRestored = 8,
        }
        public Smbios(KaitaiStream p__io, KaitaiStruct p__parent = null, Smbios p__root = null) : base(p__io)
        {
            m_parent = p__parent;
            m_root = p__root ?? this;
            _read();
        }
        private void _read()
        {
            _structures = new List<Structure>();
            {
                var i = 0;
                Structure M_;
                do {
                    M_ = new Structure(m_io, this, m_root);
                    _structures.Add(M_);
                    i++;
                } while (!( ((M_.Type == StructureType.EndOfTable) || (M_.LenFormattedArea < 4) || (M_Io.IsEof)) ));
            }
        }

        /// <summary>
        /// Values of the AArch64 ID registers, see the Arm A-profile architecture
        /// reference for their fields.
        /// </summary>
        public partial class Aarch64ArchitectureData : KaitaiStruct
        {
            public static Aarch64ArchitectureData FromFile(string fileName)
            {
                return new Aarch64ArchitectureData(new KaitaiStream(fileName));
            }

            public Aarch64ArchitectureData(KaitaiStream p__io, Smbios.Aarch64ProcessorSpecificData p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _version = m_io.ReadU2le();
                _lenData = m_io.ReadU1();
                _reserved1 = m_io.ReadU1();
                _reserved2 = m_io.ReadU4le();
                _idAa64afr0El1 = m_io.ReadU8le();
                _idAa64afr1El1 = m_io.ReadU8le();
                _idAa64dfr0El1 = m_io.ReadU8le();
                _idAa64dfr1El1 = m_io.ReadU8le();
                _idAa64dfr2El1 = m_io.ReadU8le();
                _idAa64fpfr0El1 = m_io.ReadU8le();
                _idAa64isar0El1 = m_io.ReadU8le();
                _idAa64isar1El1 = m_io.ReadU8le();
                _idAa64isar2El1 = m_io.ReadU8le();
                _idAa64isar3El1 = m_io.ReadU8le();
                _idAa64mmfr0El1 = m_io.ReadU8le();
                _idAa64mmfr1El1 = m_io.ReadU8le();
                _idAa64mmfr2El1 = m_io.ReadU8le();
                _idAa64mmfr3El1 = m_io.ReadU8le();
                _idAa64mmfr4El1 = m_io.ReadU8le();
                _idAa64pfr0El1 = m_io.ReadU8le();
                _idAa64pfr1El1 = m_io.ReadU8le();
                _idAa64pfr2El1 = m_io.ReadU8le();
                _idAa64smfr0El1 = m_io.ReadU8le();
                _idAa64zfr0El1 = m_io.ReadU8le();
            }
            private ushort _version;
            private byte _lenData;
            private byte _reserved1;
            private uint _reserved2;
            private ulong _idAa64afr0El1;
            private ulong _idAa64afr1El1;
            private ulong _idAa64dfr0El1;
            private ulong _idAa64dfr1El1;
            private ulong _idAa64dfr2El1;
            private ulong _idAa64fpfr0El1;
            private ulong _idAa64isar0El1;
            private ulong _idAa64isar1El1;
            private ulong _idAa64isar2El1;
            private ulong _idAa64isar3El1;
            private ulong _idAa64mmfr0El1;
            private ulong _idAa64mmfr1El1;
            private ulong _idAa64mmfr2El1;
            private ulong _idAa64mmfr3El1;
            private ulong _idAa64mmfr4El1;
            private ulong _idAa64pfr0El1;
            private ulong _idAa64pfr1El1;
            private ulong _idAa64pfr2El1;
            private ulong _idAa64smfr0El1;
            private ulong _idAa64zfr0El1;
            private Smbios m_root;
            private Smbios.Aarch64ProcessorSpecificData m_parent;
            public ushort Version { get { return _version; } }
            public byte LenData { get { return _lenData; } }
            public byte Reserved1 { get { return _reserved1; } }
            public uint Reserved2 { get { return _reserved2; } }
            public ulong IdAa64afr0El1 { get { return _idAa64afr0El1; } }
            public ulong IdAa64afr1El1 { get { return _idAa64afr1El1; } }
            public ulong IdAa64dfr0El1 { get { return _idAa64dfr0El1; } }
            public ulong IdAa64dfr1El1 { get { return _idAa64dfr1El1; } }
            public ulong IdAa64dfr2El1 { get { return _idAa64dfr2El1; } }
            public ulong IdAa64fpfr0El1 { get { return _idAa64fpfr0El1; } }
            public ulong IdAa64isar0El1 { get { return _idAa64isar0El1; } }
            public ulong IdAa64isar1El1 { get { return _idAa64isar1El1; } }
            public ulong IdAa64isar2El1 { get { return _idAa64isar2El1; } }
            public ulong IdAa64isar3El1 { get { return _idAa64isar3El1; } }

            /// <summary>
            /// The smallest PARange of all CPUs of the system.
            /// </summary>
            public ulong IdAa64mmfr0El1 { get { return _idAa64mmfr0El1; } }
            public ulong IdAa64mmfr1El1 { get { return _idAa64mmfr1El1; } }
            public ulong IdAa64mmfr2El1 { get { return _idAa64mmfr2El1; } }
            public ulong IdAa64mmfr3El1 { get { return _idAa64mmfr3El1; } }
            public ulong IdAa64mmfr4El1 { get { return _idAa64mmfr4El1; } }
            public ulong IdAa64pfr0El1 { get { return _idAa64pfr0El1; } }
            public ulong IdAa64pfr1El1 { get { return _idAa64pfr1El1; } }
            public ulong IdAa64pfr2El1 { get { return _idAa64pfr2El1; } }
            public ulong IdAa64smfr0El1 { get { return _idAa64smfr0El1; } }
            public ulong IdAa64zfr0El1 { get { return _idAa64zfr0El1; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Aarch64ProcessorSpecificData M_Parent { get { return m_parent; } }
        }
        public partial class Aarch64ProcessorSpecificData : KaitaiStruct
        {
            public static Aarch64ProcessorSpecificData FromFile(string fileName)
            {
                return new Aarch64ProcessorSpecificData(new KaitaiStream(fileName));
            }

            public Aarch64ProcessorSpecificData(KaitaiStream p__io, Smbios.ProcessorAdditionalInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _revisionMinor = m_io.ReadU1();
                _revisionMajor = m_io.ReadU1();
                _lenData = m_io.ReadU1();
                _reserved1 = m_io.ReadU1();
                _vendorJep106Code = m_io.ReadU1();
                _vendorJep106Bank = m_io.ReadBitsIntLe(7);
                _reserved2 = m_io.ReadBitsIntLe(1) != 0;
                m_io.AlignToByte();
                _subType = ((Smbios.Aarch64DataSubType) m_io.ReadU1());
                _reserved3 = m_io.ReadU1();
                switch (SubType) {
                case Smbios.Aarch64DataSubType.Architecture: {
                    __raw_subTypeData = m_io.ReadBytesFull();
                    var io___raw_subTypeData = new KaitaiStream(__raw_subTypeData);
                    _subTypeData = new Aarch64ArchitectureData(io___raw_subTypeData, this, m_root);
                    break;
                }
                default: {
                    _subTypeData = m_io.ReadBytesFull();
                    break;
                }
                }
            }
            private byte _revisionMinor;
            private byte _revisionMajor;
            private byte _lenData;
            private byte _reserved1;
            private byte _vendorJep106Code;
            private ulong _vendorJep106Bank;
            private bool _reserved2;
            private Aarch64DataSubType _subType;
            private byte _reserved3;
            private object _subTypeData;
            private Smbios m_root;
            private Smbios.ProcessorAdditionalInformation m_parent;
            private byte[] __raw_subTypeData;
            public byte RevisionMinor { get { return _revisionMinor; } }
            public byte RevisionMajor { get { return _revisionMajor; } }
            public byte LenData { get { return _lenData; } }
            public byte Reserved1 { get { return _reserved1; } }

            /// <summary>
            /// JEP-106 identification code of the silicon provider, with parity bit.
            /// </summary>
            public byte VendorJep106Code { get { return _vendorJep106Code; } }

            /// <summary>
            /// JEP-106 bank index (continuation count) of the silicon provider.
            /// </summary>
            public ulong VendorJep106Bank { get { return _vendorJep106Bank; } }
            public bool Reserved2 { get { return _reserved2; } }
            public Aarch64DataSubType SubType { get { return _subType; } }
            public byte Reserved3 { get { return _reserved3; } }

            /// <summary>
            /// Vendor-specific data is defined by the silicon provider.
            /// </summary>
            public object SubTypeData { get { return _subTypeData; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.ProcessorAdditionalInformation M_Parent { get { return m_parent; } }
            public byte[] M_RawSubTypeData { get { return __raw_subTypeData; } }
        }

        /// <summary>
        /// Type 40, values that the specification does not define yet for fields
        /// of other structures.
        /// </summary>
        public partial class AdditionalInformation : KaitaiStruct
        {
            public static AdditionalInformation FromFile(string fileName)
            {
                return new AdditionalInformation(new KaitaiStream(fileName));
            }

            public AdditionalInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _numEntries = m_io.ReadU1();
                _entries = new List<AdditionalInformationEntry>();
                for (var i = 0; i < NumEntries; i++)
                {
                    _entries.Add(new AdditionalInformationEntry(m_io, this, m_root));
                }
            }
            private byte _numEntries;
            private List<AdditionalInformationEntry> _entries;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public byte NumEntries { get { return _numEntries; } }
            public List<AdditionalInformationEntry> Entries { get { return _entries; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }
        public partial class AdditionalInformationEntry : KaitaiStruct
        {
            public static AdditionalInformationEntry FromFile(string fileName)
            {
                return new AdditionalInformationEntry(new KaitaiStream(fileName));
            }

            public AdditionalInformationEntry(KaitaiStream p__io, Smbios.AdditionalInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _lenEntry = m_io.ReadU1();
                _referencedHandle = m_io.ReadU2le();
                _referencedOffset = m_io.ReadU1();
                _string = new StringRef(M_Parent.M_Parent, m_io, this, m_root);
                _value = m_io.ReadBytes(LenEntry - 5);
            }
            private byte _lenEntry;
            private ushort _referencedHandle;
            private byte _referencedOffset;
            private StringRef _string;
            private byte[] _value;
            private Smbios m_root;
            private Smbios.AdditionalInformation m_parent;
            public byte LenEntry { get { return _lenEntry; } }
            public ushort ReferencedHandle { get { return _referencedHandle; } }

            /// <summary>
            /// Offset of the field in the referenced structure, counted from the
            /// start of its header, i.e. 4 more than its position in `formatted_area`.
            /// </summary>
            public byte ReferencedOffset { get { return _referencedOffset; } }
            public StringRef String { get { return _string; } }

            /// <summary>
            /// Value of the same type and size as the referenced field.
            /// </summary>
            public byte[] Value { get { return _value; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.AdditionalInformation M_Parent { get { return m_parent; } }
        }
        public partial class BaseboardFeatureFlags : KaitaiStruct
        {
            public static BaseboardFeatureFlags FromFile(string fileName)
            {
                return new BaseboardFeatureFlags(new KaitaiStream(fileName));
            }

            public BaseboardFeatureFlags(KaitaiStream p__io, Smbios.BaseboardInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _hostingBoard = m_io.ReadBitsIntLe(1) != 0;
                _requiresDaughterBoard = m_io.ReadBitsIntLe(1) != 0;
                _removable = m_io.ReadBitsIntLe(1) != 0;
                _replaceable = m_io.ReadBitsIntLe(1) != 0;
                _hotSwappable = m_io.ReadBitsIntLe(1) != 0;
                _reserved = m_io.ReadBitsIntLe(3);
            }
            private bool _hostingBoard;
            private bool _requiresDaughterBoard;
            private bool _removable;
            private bool _replaceable;
            private bool _hotSwappable;
            private ulong _reserved;
            private Smbios m_root;
            private Smbios.BaseboardInformation m_parent;

            /// <summary>
            /// Set if the board is a hosting board, e.g. a motherboard.
            /// </summary>
            public bool HostingBoard { get { return _hostingBoard; } }
            public bool RequiresDaughterBoard { get { return _requiresDaughterBoard; } }
            public bool Removable { get { return _removable; } }
            public bool Replaceable { get { return _replaceable; } }
            public bool HotSwappable { get { return _hotSwappable; } }
            public ulong Reserved { get { return _reserved; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.BaseboardInformation M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 2.
        /// </summary>
        public partial class BaseboardInformation : KaitaiStruct
        {
            public static BaseboardInformation FromFile(string fileName)
            {
                return new BaseboardInformation(new KaitaiStream(fileName));
            }

            public BaseboardInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _manufacturer = new StringRef(M_Parent, m_io, this, m_root);
                _product = new StringRef(M_Parent, m_io, this, m_root);
                _version = new StringRef(M_Parent, m_io, this, m_root);
                _serialNumber = new StringRef(M_Parent, m_io, this, m_root);
                if (!(M_Io.IsEof)) {
                    _assetTag = new StringRef(M_Parent, m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _featureFlags = new BaseboardFeatureFlags(m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _locationInChassis = new StringRef(M_Parent, m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _chassisHandle = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _boardType = ((Smbios.BoardType) m_io.ReadU1());
                }
                if (!(M_Io.IsEof)) {
                    _numContainedObjectHandles = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _containedObjectHandles = new List<ushort>();
                    for (var i = 0; i < NumContainedObjectHandles; i++)
                    {
                        _containedObjectHandles.Add(m_io.ReadU2le());
                    }
                }
            }
            private StringRef _manufacturer;
            private StringRef _product;
            private StringRef _version;
            private StringRef _serialNumber;
            private StringRef _assetTag;
            private BaseboardFeatureFlags _featureFlags;
            private StringRef _locationInChassis;
            private ushort? _chassisHandle;
            private BoardType _boardType;
            private byte? _numContainedObjectHandles;
            private List<ushort> _containedObjectHandles;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef Manufacturer { get { return _manufacturer; } }
            public StringRef Product { get { return _product; } }
            public StringRef Version { get { return _version; } }
            public StringRef SerialNumber { get { return _serialNumber; } }
            public StringRef AssetTag { get { return _assetTag; } }
            public BaseboardFeatureFlags FeatureFlags { get { return _featureFlags; } }
            public StringRef LocationInChassis { get { return _locationInChassis; } }
            public ushort? ChassisHandle { get { return _chassisHandle; } }
            public BoardType BoardType { get { return _boardType; } }
            public byte? NumContainedObjectHandles { get { return _numContainedObjectHandles; } }

            /// <summary>
            /// Handles of structures (processors, slots, memory devices and so
            /// on) on this board.
            /// </summary>
            public List<ushort> ContainedObjectHandles { get { return _containedObjectHandles; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 21.
        /// </summary>
        public partial class BuiltInPointingDevice : KaitaiStruct
        {
            public static BuiltInPointingDevice FromFile(string fileName)
            {
                return new BuiltInPointingDevice(new KaitaiStream(fileName));
            }

            public BuiltInPointingDevice(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _pointingDeviceType = ((Smbios.PointingDeviceType) m_io.ReadU1());
                _interface = ((Smbios.PointingDeviceInterface) m_io.ReadU1());
                _numButtons = m_io.ReadU1();
            }
            private PointingDeviceType _pointingDeviceType;
            private PointingDeviceInterface _interface;
            private byte _numButtons;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public PointingDeviceType PointingDeviceType { get { return _pointingDeviceType; } }
            public PointingDeviceInterface Interface { get { return _interface; } }
            public byte NumButtons { get { return _numButtons; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 7.
        /// </summary>
        public partial class CacheInformation : KaitaiStruct
        {
            public static CacheInformation FromFile(string fileName)
            {
                return new CacheInformation(new KaitaiStream(fileName));
            }

            public CacheInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _socketDesignation = new StringRef(M_Parent, m_io, this, m_root);
                _level = m_io.ReadBitsIntLe(3);
                _socketed = m_io.ReadBitsIntLe(1) != 0;
                _reserved1 = m_io.ReadBitsIntLe(1) != 0;
                _location = ((Smbios.CacheLocation) m_io.ReadBitsIntLe(2));
                _enabled = m_io.ReadBitsIntLe(1) != 0;
                _operationalMode = ((Smbios.CacheOperationalMode) m_io.ReadBitsIntLe(2));
                _reserved2 = m_io.ReadBitsIntLe(6);
                m_io.AlignToByte();
                _maximumCacheSize = new CacheSize(m_io, this, m_root);
                _installedSize = new CacheSize(m_io, this, m_root);
                _supportedSramType = new SramTypes(m_io, this, m_root);
                _currentSramType = new SramTypes(m_io, this, m_root);
                if (!(M_Io.IsEof)) {
                    _cacheSpeed = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _errorCorrectionType = ((Smbios.CacheErrorCorrectionType) m_io.ReadU1());
                }
                if (!(M_Io.IsEof)) {
                    _systemCacheType = ((Smbios.SystemCacheType) m_io.ReadU1());
                }
                if (!(M_Io.IsEof)) {
                    _associativity = ((Smbios.CacheAssociativity) m_io.ReadU1());
                }
                if (!(M_Io.IsEof)) {
                    _maximumCacheSize2 = new CacheSize2(m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _installedCacheSize2 = new CacheSize2(m_io, this, m_root);
                }
            }
            private StringRef _socketDesignation;
            private ulong _level;
            private bool _socketed;
            private bool _reserved1;
            private CacheLocation _location;
            private bool _enabled;
            private CacheOperationalMode _operationalMode;
            private ulong _reserved2;
            private CacheSize _maximumCacheSize;
            private CacheSize _installedSize;
            private SramTypes _supportedSramType;
            private SramTypes _currentSramType;
            private byte? _cacheSpeed;
            private CacheErrorCorrectionType _errorCorrectionType;
            private SystemCacheType _systemCacheType;
            private CacheAssociativity _associativity;
            private CacheSize2 _maximumCacheSize2;
            private CacheSize2 _installedCacheSize2;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef SocketDesignation { get { return _socketDesignation; } }

            /// <summary>
            /// Cache level minus 1, i.e. 0 for an L1 cache.
            /// </summary>
            public ulong Level { get { return _level; } }
            public bool Socketed { get { return _socketed; } }
            public bool Reserved1 { get { return _reserved1; } }
            public CacheLocation Location { get { return _location; } }
            public bool Enabled { get { return _enabled; } }
            public CacheOperationalMode OperationalMode { get { return _operationalMode; } }
            public ulong Reserved2 { get { return _reserved2; } }

            /// <summary>
            /// 0xffff if the size is in `maximum_cache_size_2`.
            /// </summary>
            public CacheSize MaximumCacheSize { get { return _maximumCacheSize; } }

            /// <summary>
            /// 0 if no cache is installed.
            /// </summary>
            public CacheSize InstalledSize { get { return _installedSize; } }
            public SramTypes SupportedSramType { get { return _supportedSramType; } }
            public SramTypes CurrentSramType { get { return _currentSramType; } }

            /// <summary>
            /// In ns, 0 if unknown.
            /// </summary>
            public byte? CacheSpeed { get { return _cacheSpeed; } }
            public CacheErrorCorrectionType ErrorCorrectionType { get { return _errorCorrectionType; } }
            public SystemCacheType SystemCacheType { get { return _systemCacheType; } }
            public CacheAssociativity Associativity { get { return _associativity; } }
            public CacheSize2 MaximumCacheSize2 { get { return _maximumCacheSize2; } }
            public CacheSize2 InstalledCacheSize2 { get { return _installedCacheSize2; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }
        public partial class CacheSize : KaitaiStruct
        {
            public static CacheSize FromFile(string fileName)
            {
                return new CacheSize(new KaitaiStream(fileName));
            }

            public CacheSize(KaitaiStream p__io, Smbios.CacheInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                f_sizeKib = false;
                _read();
            }
            private void _read()
            {
                _size = m_io.ReadBitsIntLe(15);
                _granularity64k = m_io.ReadBitsIntLe(1) != 0;
            }
            private bool f_sizeKib;
            private int _sizeKib;
            public int SizeKib
            {
                get
                {
                    if (f_sizeKib)
                        return _sizeKib;
                    f_sizeKib = true;
                    _sizeKib = (int) ((Granularity64k ? Size * 64 : Size));
                    return _sizeKib;
                }
            }
            private ulong _size;
            private bool _granularity64k;
            private Smbios m_root;
            private Smbios.CacheInformation m_parent;
            public ulong Size { get { return _size; } }

            /// <summary>
            /// Set if `size` is in 64 KiB units, clear if in KiB.
            /// </summary>
            public bool Granularity64k { get { return _granularity64k; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.CacheInformation M_Parent { get { return m_parent; } }
        }
        public partial class CacheSize2 : KaitaiStruct
        {
            public static CacheSize2 FromFile(string fileName)
            {
                return new CacheSize2(new KaitaiStream(fileName));
            }

            public CacheSize2(KaitaiStream p__io, Smbios.CacheInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                f_sizeKib = false;
                _read();
            }
            private void _read()
            {
                _size = m_io.ReadBitsIntLe(31);
                _granularity64k = m_io.ReadBitsIntLe(1) != 0;
            }
            private bool f_sizeKib;
            private int _sizeKib;
            public int SizeKib
            {
                get
                {
                    if (f_sizeKib)
                        return _sizeKib;
                    f_sizeKib = true;
                    _sizeKib = (int) ((Granularity64k ? Size * 64 : Size));
                    return _sizeKib;
                }
            }
            private ulong _size;
            private bool _granularity64k;
            private Smbios m_root;
            private Smbios.CacheInformation m_parent;
            public ulong Size { get { return _size; } }

            /// <summary>
            /// Set if `size` is in 64 KiB units, clear if in KiB.
            /// </summary>
            public bool Granularity64k { get { return _granularity64k; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.CacheInformation M_Parent { get { return m_parent; } }
        }
        public partial class ContainedElement : KaitaiStruct
        {
            public static ContainedElement FromFile(string fileName)
            {
                return new ContainedElement(new KaitaiStream(fileName));
            }

            public ContainedElement(KaitaiStream p__io, Smbios.SystemEnclosure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                f_boardType = false;
                f_structureType = false;
                _read();
            }
            private void _read()
            {
                _elementType = m_io.ReadBitsIntLe(7);
                _isStructureType = m_io.ReadBitsIntLe(1) != 0;
                m_io.AlignToByte();
                _minimum = m_io.ReadU1();
                _maximum = m_io.ReadU1();
            }
            private bool f_boardType;
            private BoardType _boardType;
            public BoardType BoardType
            {
                get
                {
                    if (f_boardType)
                        return _boardType;
                    f_boardType = true;
                    if (!(IsStructureType)) {
                        _boardType = (BoardType) (((Smbios.BoardType) ElementType));
                    }
                    return _boardType;
                }
            }
            private bool f_structureType;
            private StructureType _structureType;
            public StructureType StructureType
            {
                get
                {
                    if (f_structureType)
                        return _structureType;
                    f_structureType = true;
                    if (IsStructureType) {
                        _structureType = (StructureType) (((Smbios.StructureType) ElementType));
                    }
                    return _structureType;
                }
            }
            private ulong _elementType;
            private bool _isStructureType;
            private byte _minimum;
            private byte _maximum;
            private Smbios m_root;
            private Smbios.SystemEnclosure m_parent;

            /// <summary>
            /// A `board_type` if `is_structure_type` is clear, a
            /// `structure_type` if it is set.
            /// </summary>
            public ulong ElementType { get { return _elementType; } }
            public bool IsStructureType { get { return _isStructureType; } }

            /// <summary>
            /// Number of such elements the chassis needs to operate.
            /// </summary>
            public byte Minimum { get { return _minimum; } }

            /// <summary>
            /// Number of such elements the chassis can hold.
            /// </summary>
            public byte Maximum { get { return _maximum; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.SystemEnclosure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 27.
        /// </summary>
        public partial class CoolingDevice : KaitaiStruct
        {
            public static CoolingDevice FromFile(string fileName)
            {
                return new CoolingDevice(new KaitaiStream(fileName));
            }

            public CoolingDevice(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _temperatureProbeHandle = m_io.ReadU2le();
                _deviceType = ((Smbios.CoolingDeviceType) m_io.ReadBitsIntLe(5));
                _status = ((Smbios.ProbeStatus) m_io.ReadBitsIntLe(3));
                m_io.AlignToByte();
                _coolingUnitGroup = m_io.ReadU1();
                _oemDefined = m_io.ReadU4le();
                if (!(M_Io.IsEof)) {
                    _nominalSpeed = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _description = new StringRef(M_Parent, m_io, this, m_root);
                }
            }
            private ushort _temperatureProbeHandle;
            private CoolingDeviceType _deviceType;
            private ProbeStatus _status;
            private byte _coolingUnitGroup;
            private uint _oemDefined;
            private ushort? _nominalSpeed;
            private StringRef _description;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public ushort TemperatureProbeHandle { get { return _temperatureProbeHandle; } }
            public CoolingDeviceType DeviceType { get { return _deviceType; } }
            public ProbeStatus Status { get { return _status; } }

            /// <summary>
            /// Devices with the same non-zero group are redundant; 0 if not part
            /// of a redundant unit.
            /// </summary>
            public byte CoolingUnitGroup { get { return _coolingUnitGroup; } }
            public uint OemDefined { get { return _oemDefined; } }

            /// <summary>
            /// In rpm; 0x8000 if unknown or not rotating.
            /// </summary>
            public ushort? NominalSpeed { get { return _nominalSpeed; } }
            public StringRef Description { get { return _description; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 29. A value of 0x8000 means unknown.
        /// </summary>
        public partial class ElectricalCurrentProbe : KaitaiStruct
        {
            public static ElectricalCurrentProbe FromFile(string fileName)
            {
                return new ElectricalCurrentProbe(new KaitaiStream(fileName));
            }

            public ElectricalCurrentProbe(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _description = new StringRef(M_Parent, m_io, this, m_root);
                _location = ((Smbios.ProbeLocation) m_io.ReadBitsIntLe(5));
                _status = ((Smbios.ProbeStatus) m_io.ReadBitsIntLe(3));
                m_io.AlignToByte();
                _maximumValue = m_io.ReadS2le();
                _minimumValue = m_io.ReadS2le();
                _resolution = m_io.ReadU2le();
                _tolerance = m_io.ReadS2le();
                _accuracy = m_io.ReadU2le();
                _oemDefined = m_io.ReadU4le();
                if (!(M_Io.IsEof)) {
                    _nominalValue = m_io.ReadS2le();
                }
            }
            private StringRef _description;
            private ProbeLocation _location;
            private ProbeStatus _status;
            private short _maximumValue;
            private short _minimumValue;
            private ushort _resolution;
            private short _tolerance;
            private ushort _accuracy;
            private uint _oemDefined;
            private short? _nominalValue;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef Description { get { return _description; } }
            public ProbeLocation Location { get { return _location; } }
            public ProbeStatus Status { get { return _status; } }

            /// <summary>
            /// In mA.
            /// </summary>
            public short MaximumValue { get { return _maximumValue; } }

            /// <summary>
            /// In mA.
            /// </summary>
            public short MinimumValue { get { return _minimumValue; } }

            /// <summary>
            /// In 1/10 mA.
            /// </summary>
            public ushort Resolution { get { return _resolution; } }

            /// <summary>
            /// Plus or minus, in mA.
            /// </summary>
            public short Tolerance { get { return _tolerance; } }

            /// <summary>
            /// Plus or minus, in 1/100 %.
            /// </summary>
            public ushort Accuracy { get { return _accuracy; } }
            public uint OemDefined { get { return _oemDefined; } }

            /// <summary>
            /// In mA.
            /// </summary>
            public short? NominalValue { get { return _nominalValue; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }
        public partial class ErrorCorrectingCapability : KaitaiStruct
        {
            public static ErrorCorrectingCapability FromFile(string fileName)
            {
                return new ErrorCorrectingCapability(new KaitaiStream(fileName));
            }

            public ErrorCorrectingCapability(KaitaiStream p__io, Smbios.MemoryControllerInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _other = m_io.ReadBitsIntLe(1) != 0;
                _unknown = m_io.ReadBitsIntLe(1) != 0;
                _none = m_io.ReadBitsIntLe(1) != 0;
                _singleBitErrorCorrecting = m_io.ReadBitsIntLe(1) != 0;
                _doubleBitErrorCorrecting = m_io.ReadBitsIntLe(1) != 0;
                _errorScrubbing = m_io.ReadBitsIntLe(1) != 0;
                _reserved = m_io.ReadBitsIntLe(2);
            }
            private bool _other;
            private bool _unknown;
            private bool _none;
            private bool _singleBitErrorCorrecting;
            private bool _doubleBitErrorCorrecting;
            private bool _errorScrubbing;
            private ulong _reserved;
            private Smbios m_root;
            private Smbios.MemoryControllerInformation m_parent;
            public bool Other { get { return _other; } }
            public bool Unknown { get { return _unknown; } }
            public bool None { get { return _none; } }
            public bool SingleBitErrorCorrecting { get { return _singleBitErrorCorrecting; } }
            public bool DoubleBitErrorCorrecting { get { return _doubleBitErrorCorrecting; } }
            public bool ErrorScrubbing { get { return _errorScrubbing; } }
            public ulong Reserved { get { return _reserved; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.MemoryControllerInformation M_Parent { get { return m_parent; } }
        }
        public partial class EventLogTypeDescriptor : KaitaiStruct
        {
            public static EventLogTypeDescriptor FromFile(string fileName)
            {
                return new EventLogTypeDescriptor(new KaitaiStream(fileName));
            }

            public EventLogTypeDescriptor(KaitaiStream p__io, Smbios.SystemEventLog p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _logType = ((Smbios.EventLogType) m_io.ReadU1());
                _variableDataFormatType = ((Smbios.EventLogVariableDataFormat) m_io.ReadU1());
            }
            private EventLogType _logType;
            private EventLogVariableDataFormat _variableDataFormatType;
            private Smbios m_root;
            private Smbios.SystemEventLog m_parent;
            public EventLogType LogType { get { return _logType; } }
            public EventLogVariableDataFormat VariableDataFormatType { get { return _variableDataFormatType; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.SystemEventLog M_Parent { get { return m_parent; } }
        }
        public partial class ExtendedRomSize : KaitaiStruct
        {
            public static ExtendedRomSize FromFile(string fileName)
            {
                return new ExtendedRomSize(new KaitaiStream(fileName));
            }

            public ExtendedRomSize(KaitaiStream p__io, Smbios.PlatformFirmwareInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _size = m_io.ReadBitsIntLe(14);
                _unit = ((Smbios.ExtendedRomSizeUnit) m_io.ReadBitsIntLe(2));
            }
            private ulong _size;
            private ExtendedRomSizeUnit _unit;
            private Smbios m_root;
            private Smbios.PlatformFirmwareInformation m_parent;
            public ulong Size { get { return _size; } }
            public ExtendedRomSizeUnit Unit { get { return _unit; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.PlatformFirmwareInformation M_Parent { get { return m_parent; } }
        }
        public partial class FirmwareCharacteristics : KaitaiStruct
        {
            public static FirmwareCharacteristics FromFile(string fileName)
            {
                return new FirmwareCharacteristics(new KaitaiStream(fileName));
            }

            public FirmwareCharacteristics(KaitaiStream p__io, Smbios.PlatformFirmwareInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _reserved0 = m_io.ReadBitsIntLe(2);
                _unknown = m_io.ReadBitsIntLe(1) != 0;
                _notSupported = m_io.ReadBitsIntLe(1) != 0;
                _isa = m_io.ReadBitsIntLe(1) != 0;
                _mca = m_io.ReadBitsIntLe(1) != 0;
                _eisa = m_io.ReadBitsIntLe(1) != 0;
                _pci = m_io.ReadBitsIntLe(1) != 0;
                _pcmcia = m_io.ReadBitsIntLe(1) != 0;
                _plugAndPlay = m_io.ReadBitsIntLe(1) != 0;
                _apm = m_io.ReadBitsIntLe(1) != 0;
                _upgradeable = m_io.ReadBitsIntLe(1) != 0;
                _shadowingAllowed = m_io.ReadBitsIntLe(1) != 0;
                _vlVesa = m_io.ReadBitsIntLe(1) != 0;
                _escd = m_io.ReadBitsIntLe(1) != 0;
                _bootFromCd = m_io.ReadBitsIntLe(1) != 0;
                _selectableBoot = m_io.ReadBitsIntLe(1) != 0;
                _romSocketed = m_io.ReadBitsIntLe(1) != 0;
                _bootFromPcmcia = m_io.ReadBitsIntLe(1) != 0;
                _edd = m_io.ReadBitsIntLe(1) != 0;
                _int13Nec9800Floppy = m_io.ReadBitsIntLe(1) != 0;
                _int13ToshibaFloppy = m_io.ReadBitsIntLe(1) != 0;
                _int13Floppy525360k = m_io.ReadBitsIntLe(1) != 0;
                _int13Floppy5251200k = m_io.ReadBitsIntLe(1) != 0;
                _int13Floppy35720k = m_io.ReadBitsIntLe(1) != 0;
                _int13Floppy352880k = m_io.ReadBitsIntLe(1) != 0;
                _int5PrintScreen = m_io.ReadBitsIntLe(1) != 0;
                _int98042Keyboard = m_io.ReadBitsIntLe(1) != 0;
                _int14Serial = m_io.ReadBitsIntLe(1) != 0;
                _int17Printer = m_io.ReadBitsIntLe(1) != 0;
                _int10CgaMonoVideo = m_io.ReadBitsIntLe(1) != 0;
                _necPc98 = m_io.ReadBitsIntLe(1) != 0;
                _firmwareVendorReserved = m_io.ReadBitsIntLe(16);
                _systemVendorReserved = m_io.ReadBitsIntLe(16);
            }
            private ulong _reserved0;
            private bool _unknown;
            private bool _notSupported;
            private bool _isa;
            private bool _mca;
            private bool _eisa;
            private bool _pci;
            private bool _pcmcia;
            private bool _plugAndPlay;
            private bool _apm;
            private bool _upgradeable;
            private bool _shadowingAllowed;
            private bool _vlVesa;
            private bool _escd;
            private bool _bootFromCd;
            private bool _selectableBoot;
            private bool _romSocketed;
            private bool _bootFromPcmcia;
            private bool _edd;
            private bool _int13Nec9800Floppy;
            private bool _int13ToshibaFloppy;
            private bool _int13Floppy525360k;
            private bool _int13Floppy5251200k;
            private bool _int13Floppy35720k;
            private bool _int13Floppy352880k;
            private bool _int5PrintScreen;
            private bool _int98042Keyboard;
            private bool _int14Serial;
            private bool _int17Printer;
            private bool _int10CgaMonoVideo;
            private bool _necPc98;
            private ulong _firmwareVendorReserved;
            private ulong _systemVendorReserved;
            private Smbios m_root;
            private Smbios.PlatformFirmwareInformation m_parent;
            public ulong Reserved0 { get { return _reserved0; } }
            public bool Unknown { get { return _unknown; } }
            public bool NotSupported { get { return _notSupported; } }
            public bool Isa { get { return _isa; } }
            public bool Mca { get { return _mca; } }
            public bool Eisa { get { return _eisa; } }
            public bool Pci { get { return _pci; } }
            public bool Pcmcia { get { return _pcmcia; } }
            public bool PlugAndPlay { get { return _plugAndPlay; } }
            public bool Apm { get { return _apm; } }

            /// <summary>
            /// Firmware is in flash and can be upgraded.
            /// </summary>
            public bool Upgradeable { get { return _upgradeable; } }
            public bool ShadowingAllowed { get { return _shadowingAllowed; } }
            public bool VlVesa { get { return _vlVesa; } }
            public bool Escd { get { return _escd; } }
            public bool BootFromCd { get { return _bootFromCd; } }
            public bool SelectableBoot { get { return _selectableBoot; } }
            public bool RomSocketed { get { return _romSocketed; } }
            public bool BootFromPcmcia { get { return _bootFromPcmcia; } }

            /// <summary>
            /// Enhanced Disk Drive specification is supported.
            /// </summary>
            public bool Edd { get { return _edd; } }

            /// <summary>
            /// Japanese floppy for NEC 9800 1.2 MB (3.5&quot;, 1K bytes/sector).
            /// </summary>
            public bool Int13Nec9800Floppy { get { return _int13Nec9800Floppy; } }

            /// <summary>
            /// Japanese floppy for Toshiba 1.2 MB (3.5&quot;, 360 RPM).
            /// </summary>
            public bool Int13ToshibaFloppy { get { return _int13ToshibaFloppy; } }
            public bool Int13Floppy525360k { get { return _int13Floppy525360k; } }
            public bool Int13Floppy5251200k { get { return _int13Floppy5251200k; } }
            public bool Int13Floppy35720k { get { return _int13Floppy35720k; } }
            public bool Int13Floppy352880k { get { return _int13Floppy352880k; } }
            public bool Int5PrintScreen { get { return _int5PrintScreen; } }
            public bool Int98042Keyboard { get { return _int98042Keyboard; } }
            public bool Int14Serial { get { return _int14Serial; } }
            public bool Int17Printer { get { return _int17Printer; } }
            public bool Int10CgaMonoVideo { get { return _int10CgaMonoVideo; } }
            public bool NecPc98 { get { return _necPc98; } }
            public ulong FirmwareVendorReserved { get { return _firmwareVendorReserved; } }
            public ulong SystemVendorReserved { get { return _systemVendorReserved; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.PlatformFirmwareInformation M_Parent { get { return m_parent; } }
        }
        public partial class FirmwareCharacteristicsExt1 : KaitaiStruct
        {
            public static FirmwareCharacteristicsExt1 FromFile(string fileName)
            {
                return new FirmwareCharacteristicsExt1(new KaitaiStream(fileName));
            }

            public FirmwareCharacteristicsExt1(KaitaiStream p__io, Smbios.PlatformFirmwareInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _acpi = m_io.ReadBitsIntLe(1) != 0;
                _usbLegacy = m_io.ReadBitsIntLe(1) != 0;
                _agp = m_io.ReadBitsIntLe(1) != 0;
                _i2oBoot = m_io.ReadBitsIntLe(1) != 0;
                _ls120Boot = m_io.ReadBitsIntLe(1) != 0;
                _atapiZipBoot = m_io.ReadBitsIntLe(1) != 0;
                _ieee1394Boot = m_io.ReadBitsIntLe(1) != 0;
                _smartBattery = m_io.ReadBitsIntLe(1) != 0;
            }
            private bool _acpi;
            private bool _usbLegacy;
            private bool _agp;
            private bool _i2oBoot;
            private bool _ls120Boot;
            private bool _atapiZipBoot;
            private bool _ieee1394Boot;
            private bool _smartBattery;
            private Smbios m_root;
            private Smbios.PlatformFirmwareInformation m_parent;
            public bool Acpi { get { return _acpi; } }
            public bool UsbLegacy { get { return _usbLegacy; } }
            public bool Agp { get { return _agp; } }
            public bool I2oBoot { get { return _i2oBoot; } }
            public bool Ls120Boot { get { return _ls120Boot; } }
            public bool AtapiZipBoot { get { return _atapiZipBoot; } }
            public bool Ieee1394Boot { get { return _ieee1394Boot; } }
            public bool SmartBattery { get { return _smartBattery; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.PlatformFirmwareInformation M_Parent { get { return m_parent; } }
        }
        public partial class FirmwareCharacteristicsExt2 : KaitaiStruct
        {
            public static FirmwareCharacteristicsExt2 FromFile(string fileName)
            {
                return new FirmwareCharacteristicsExt2(new KaitaiStream(fileName));
            }

            public FirmwareCharacteristicsExt2(KaitaiStream p__io, Smbios.PlatformFirmwareInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _biosBootSpecification = m_io.ReadBitsIntLe(1) != 0;
                _functionKeyNetworkBoot = m_io.ReadBitsIntLe(1) != 0;
                _targetedContentDistribution = m_io.ReadBitsIntLe(1) != 0;
                _uefi = m_io.ReadBitsIntLe(1) != 0;
                _virtualMachine = m_io.ReadBitsIntLe(1) != 0;
                _manufacturingModeSupported = m_io.ReadBitsIntLe(1) != 0;
                _manufacturingModeEnabled = m_io.ReadBitsIntLe(1) != 0;
                _reserved = m_io.ReadBitsIntLe(1) != 0;
            }
            private bool _biosBootSpecification;
            private bool _functionKeyNetworkBoot;
            private bool _targetedContentDistribution;
            private bool _uefi;
            private bool _virtualMachine;
            private bool _manufacturingModeSupported;
            private bool _manufacturingModeEnabled;
            private bool _reserved;
            private Smbios m_root;
            private Smbios.PlatformFirmwareInformation m_parent;
            public bool BiosBootSpecification { get { return _biosBootSpecification; } }
            public bool FunctionKeyNetworkBoot { get { return _functionKeyNetworkBoot; } }
            public bool TargetedContentDistribution { get { return _targetedContentDistribution; } }
            public bool Uefi { get { return _uefi; } }

            /// <summary>
            /// The table describes a virtual machine; if clear, nothing can be
            /// inferred.
            /// </summary>
            public bool VirtualMachine { get { return _virtualMachine; } }
            public bool ManufacturingModeSupported { get { return _manufacturingModeSupported; } }
            public bool ManufacturingModeEnabled { get { return _manufacturingModeEnabled; } }
            public bool Reserved { get { return _reserved; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.PlatformFirmwareInformation M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 45, one firmware component of the system.
        /// </summary>
        public partial class FirmwareInventoryInformation : KaitaiStruct
        {
            public static FirmwareInventoryInformation FromFile(string fileName)
            {
                return new FirmwareInventoryInformation(new KaitaiStream(fileName));
            }

            public FirmwareInventoryInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _firmwareComponentName = new StringRef(M_Parent, m_io, this, m_root);
                _firmwareVersion = new StringRef(M_Parent, m_io, this, m_root);
                _versionFormat = ((Smbios.FirmwareVersionFormat) m_io.ReadU1());
                _firmwareId = new StringRef(M_Parent, m_io, this, m_root);
                _firmwareIdFormat = ((Smbios.FirmwareIdFormat) m_io.ReadU1());
                _releaseDate = new StringRef(M_Parent, m_io, this, m_root);
                _manufacturer = new StringRef(M_Parent, m_io, this, m_root);
                _lowestSupportedFirmwareVersion = new StringRef(M_Parent, m_io, this, m_root);
                _imageSize = m_io.ReadU8le();
                _updatable = m_io.ReadBitsIntLe(1) != 0;
                _writeProtected = m_io.ReadBitsIntLe(1) != 0;
                _reserved = m_io.ReadBitsIntLe(14);
                m_io.AlignToByte();
                _state = ((Smbios.FirmwareState) m_io.ReadU1());
                _numAssociatedComponentHandles = m_io.ReadU1();
                _associatedComponentHandles = new List<ushort>();
                for (var i = 0; i < NumAssociatedComponentHandles; i++)
                {
                    _associatedComponentHandles.Add(m_io.ReadU2le());
                }
            }
            private StringRef _firmwareComponentName;
            private StringRef _firmwareVersion;
            private FirmwareVersionFormat _versionFormat;
            private StringRef _firmwareId;
            private FirmwareIdFormat _firmwareIdFormat;
            private StringRef _releaseDate;
            private StringRef _manufacturer;
            private StringRef _lowestSupportedFirmwareVersion;
            private ulong _imageSize;
            private bool _updatable;
            private bool _writeProtected;
            private ulong _reserved;
            private FirmwareState _state;
            private byte _numAssociatedComponentHandles;
            private List<ushort> _associatedComponentHandles;
            private Smbios m_root;
            private Smbios.Structure m_parent;

            /// <summary>
            /// E.g. &quot;BMC Firmware&quot;.
            /// </summary>
            public StringRef FirmwareComponentName { get { return _firmwareComponentName; } }
            public StringRef FirmwareVersion { get { return _firmwareVersion; } }
            public FirmwareVersionFormat VersionFormat { get { return _versionFormat; } }
            public StringRef FirmwareId { get { return _firmwareId; } }
            public FirmwareIdFormat FirmwareIdFormat { get { return _firmwareIdFormat; } }

            /// <summary>
            /// In DSP0266 date-time format, e.g. &quot;2021-05-15T04:14:33+06:00&quot;.
            /// </summary>
            public StringRef ReleaseDate { get { return _releaseDate; } }
            public StringRef Manufacturer { get { return _manufacturer; } }
            public StringRef LowestSupportedFirmwareVersion { get { return _lowestSupportedFirmwareVersion; } }

            /// <summary>
            /// In bytes; all bits set if unknown.
            /// </summary>
            public ulong ImageSize { get { return _imageSize; } }
            public bool Updatable { get { return _updatable; } }
            public bool WriteProtected { get { return _writeProtected; } }
            public ulong Reserved { get { return _reserved; } }
            public FirmwareState State { get { return _state; } }
            public byte NumAssociatedComponentHandles { get { return _numAssociatedComponentHandles; } }
            public List<ushort> AssociatedComponentHandles { get { return _associatedComponentHandles; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 13.
        /// </summary>
        public partial class FirmwareLanguageInformation : KaitaiStruct
        {
            public static FirmwareLanguageInformation FromFile(string fileName)
            {
                return new FirmwareLanguageInformation(new KaitaiStream(fileName));
            }

            public FirmwareLanguageInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _numInstallableLanguages = m_io.ReadU1();
                _abbreviatedFormat = m_io.ReadBitsIntLe(1) != 0;
                _reserved1 = m_io.ReadBitsIntLe(7);
                m_io.AlignToByte();
                _reserved2 = m_io.ReadBytes(15);
                _currentLanguage = new StringRef(M_Parent, m_io, this, m_root);
            }
            private byte _numInstallableLanguages;
            private bool _abbreviatedFormat;
            private ulong _reserved1;
            private byte[] _reserved2;
            private StringRef _currentLanguage;
            private Smbios m_root;
            private Smbios.Structure m_parent;

            /// <summary>
            /// Number of strings, one per language.
            /// </summary>
            public byte NumInstallableLanguages { get { return _numInstallableLanguages; } }

            /// <summary>
            /// Set if the strings look like &quot;enUS&quot;, clear if like
            /// &quot;en|US|iso8859-1&quot;. Absent (zero) before version 2.1.
            /// </summary>
            public bool AbbreviatedFormat { get { return _abbreviatedFormat; } }
            public ulong Reserved1 { get { return _reserved1; } }
            public byte[] Reserved2 { get { return _reserved2; } }
            public StringRef CurrentLanguage { get { return _currentLanguage; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 14.
        /// </summary>
        public partial class GroupAssociations : KaitaiStruct
        {
            public static GroupAssociations FromFile(string fileName)
            {
                return new GroupAssociations(new KaitaiStream(fileName));
            }

            public GroupAssociations(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _groupName = new StringRef(M_Parent, m_io, this, m_root);
                _items = new List<GroupItem>();
                {
                    var i = 0;
                    while (!m_io.IsEof) {
                        _items.Add(new GroupItem(m_io, this, m_root));
                        i++;
                    }
                }
            }
            private StringRef _groupName;
            private List<GroupItem> _items;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef GroupName { get { return _groupName; } }
            public List<GroupItem> Items { get { return _items; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }
        public partial class GroupItem : KaitaiStruct
        {
            public static GroupItem FromFile(string fileName)
            {
                return new GroupItem(new KaitaiStream(fileName));
            }

            public GroupItem(KaitaiStream p__io, Smbios.GroupAssociations p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _itemType = ((Smbios.StructureType) m_io.ReadU1());
                _itemHandle = m_io.ReadU2le();
            }
            private StructureType _itemType;
            private ushort _itemHandle;
            private Smbios m_root;
            private Smbios.GroupAssociations m_parent;
            public StructureType ItemType { get { return _itemType; } }
            public ushort ItemHandle { get { return _itemHandle; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.GroupAssociations M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 24.
        /// </summary>
        public partial class HardwareSecurity : KaitaiStruct
        {
            public static HardwareSecurity FromFile(string fileName)
            {
                return new HardwareSecurity(new KaitaiStream(fileName));
            }

            public HardwareSecurity(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _frontPanelResetStatus = ((Smbios.HardwareSecurityStatus) m_io.ReadBitsIntLe(2));
                _administratorPasswordStatus = ((Smbios.HardwareSecurityStatus) m_io.ReadBitsIntLe(2));
                _keyboardPasswordStatus = ((Smbios.HardwareSecurityStatus) m_io.ReadBitsIntLe(2));
                _powerOnPasswordStatus = ((Smbios.HardwareSecurityStatus) m_io.ReadBitsIntLe(2));
            }
            private HardwareSecurityStatus _frontPanelResetStatus;
            private HardwareSecurityStatus _administratorPasswordStatus;
            private HardwareSecurityStatus _keyboardPasswordStatus;
            private HardwareSecurityStatus _powerOnPasswordStatus;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public HardwareSecurityStatus FrontPanelResetStatus { get { return _frontPanelResetStatus; } }
            public HardwareSecurityStatus AdministratorPasswordStatus { get { return _administratorPasswordStatus; } }
            public HardwareSecurityStatus KeyboardPasswordStatus { get { return _keyboardPasswordStatus; } }
            public HardwareSecurityStatus PowerOnPasswordStatus { get { return _powerOnPasswordStatus; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }
        public partial class HostInterfaceProtocolRecord : KaitaiStruct
        {
            public static HostInterfaceProtocolRecord FromFile(string fileName)
            {
                return new HostInterfaceProtocolRecord(new KaitaiStream(fileName));
            }

            public HostInterfaceProtocolRecord(KaitaiStream p__io, Smbios.ManagementControllerHostInterface p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _protocolType = ((Smbios.HostInterfaceProtocolType) m_io.ReadU1());
                _lenProtocolTypeSpecificData = m_io.ReadU1();
                _protocolTypeSpecificData = m_io.ReadBytes(LenProtocolTypeSpecificData);
            }
            private HostInterfaceProtocolType _protocolType;
            private byte _lenProtocolTypeSpecificData;
            private byte[] _protocolTypeSpecificData;
            private Smbios m_root;
            private Smbios.ManagementControllerHostInterface m_parent;
            public HostInterfaceProtocolType ProtocolType { get { return _protocolType; } }
            public byte LenProtocolTypeSpecificData { get { return _lenProtocolTypeSpecificData; } }

            /// <summary>
            /// The data of Redfish over IP is defined by DSP0270.
            /// </summary>
            public byte[] ProtocolTypeSpecificData { get { return _protocolTypeSpecificData; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.ManagementControllerHostInterface M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 38.
        /// </summary>
        public partial class IpmiDeviceInformation : KaitaiStruct
        {
            public static IpmiDeviceInformation FromFile(string fileName)
            {
                return new IpmiDeviceInformation(new KaitaiStream(fileName));
            }

            public IpmiDeviceInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _interfaceType = ((Smbios.IpmiInterfaceType) m_io.ReadU1());
                _ipmiSpecificationRevisionMinor = m_io.ReadBitsIntLe(4);
                _ipmiSpecificationRevisionMajor = m_io.ReadBitsIntLe(4);
                m_io.AlignToByte();
                _i2cTargetAddress = m_io.ReadU1();
                _nvStorageDeviceAddress = m_io.ReadU1();
                _baseAddress = m_io.ReadU8le();
                if (!(M_Io.IsEof)) {
                    _interruptTriggerLevel = m_io.ReadBitsIntLe(1) != 0;
                }
                if (!(M_Io.IsEof)) {
                    _interruptActiveHigh = m_io.ReadBitsIntLe(1) != 0;
                }
                if (!(M_Io.IsEof)) {
                    _reserved1 = m_io.ReadBitsIntLe(1) != 0;
                }
                if (!(M_Io.IsEof)) {
                    _interruptInfoSpecified = m_io.ReadBitsIntLe(1) != 0;
                }
                if (!(M_Io.IsEof)) {
                    _addressLsb = m_io.ReadBitsIntLe(1) != 0;
                }
                if (!(M_Io.IsEof)) {
                    _reserved2 = m_io.ReadBitsIntLe(1) != 0;
                }
                if (!(M_Io.IsEof)) {
                    _registerSpacing = ((Smbios.IpmiRegisterSpacing) m_io.ReadBitsIntLe(2));
                }
                m_io.AlignToByte();
                if (!(M_Io.IsEof)) {
                    _interruptNumber = m_io.ReadU1();
                }
            }
            private IpmiInterfaceType _interfaceType;
            private ulong _ipmiSpecificationRevisionMinor;
            private ulong _ipmiSpecificationRevisionMajor;
            private byte _i2cTargetAddress;
            private byte _nvStorageDeviceAddress;
            private ulong _baseAddress;
            private bool? _interruptTriggerLevel;
            private bool? _interruptActiveHigh;
            private bool? _reserved1;
            private bool? _interruptInfoSpecified;
            private bool? _addressLsb;
            private bool? _reserved2;
            private IpmiRegisterSpacing _registerSpacing;
            private byte? _interruptNumber;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public IpmiInterfaceType InterfaceType { get { return _interfaceType; } }
            public ulong IpmiSpecificationRevisionMinor { get { return _ipmiSpecificationRevisionMinor; } }
            public ulong IpmiSpecificationRevisionMajor { get { return _ipmiSpecificationRevisionMajor; } }

            /// <summary>
            /// 8-bit form of the address (bit 0 is 0); dmidecode shows the 7-bit
            /// form, e.g. 0x10 for 0x20.
            /// </summary>
            public byte I2cTargetAddress { get { return _i2cTargetAddress; } }

            /// <summary>
            /// 0xff if there is no storage device.
            /// </summary>
            public byte NvStorageDeviceAddress { get { return _nvStorageDeviceAddress; } }

            /// <summary>
            /// Memory-mapped or, if bit 0 is set, I/O address of the BMC. The
            /// real bit 0 is `address_lsb`.
            /// </summary>
            public ulong BaseAddress { get { return _baseAddress; } }

            /// <summary>
            /// Set if level-triggered, clear if edge-triggered.
            /// </summary>
            public bool? InterruptTriggerLevel { get { return _interruptTriggerLevel; } }
            public bool? InterruptActiveHigh { get { return _interruptActiveHigh; } }
            public bool? Reserved1 { get { return _reserved1; } }
            public bool? InterruptInfoSpecified { get { return _interruptInfoSpecified; } }
            public bool? AddressLsb { get { return _addressLsb; } }
            public bool? Reserved2 { get { return _reserved2; } }
            public IpmiRegisterSpacing RegisterSpacing { get { return _registerSpacing; } }

            /// <summary>
            /// 0 if unspecified.
            /// </summary>
            public byte? InterruptNumber { get { return _interruptNumber; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 42.
        /// </summary>
        public partial class ManagementControllerHostInterface : KaitaiStruct
        {
            public static ManagementControllerHostInterface FromFile(string fileName)
            {
                return new ManagementControllerHostInterface(new KaitaiStream(fileName));
            }

            public ManagementControllerHostInterface(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                f_byteAt05h = false;
                f_isLengthPrefixed = false;
                _read();
            }
            private void _read()
            {
                _interfaceType = ((Smbios.HostInterfaceType) m_io.ReadU1());
                if (IsLengthPrefixed) {
                    _lenInterfaceTypeSpecificData = m_io.ReadU1();
                }
                if (IsLengthPrefixed) {
                    _interfaceTypeSpecificData = m_io.ReadBytes(((uint) (LenInterfaceTypeSpecificData)));
                }
                if (IsLengthPrefixed) {
                    _numProtocolRecords = m_io.ReadU1();
                }
                if (IsLengthPrefixed) {
                    _protocolRecords = new List<HostInterfaceProtocolRecord>();
                    for (var i = 0; i < NumProtocolRecords; i++)
                    {
                        _protocolRecords.Add(new HostInterfaceProtocolRecord(m_io, this, m_root));
                    }
                }
                if (!(IsLengthPrefixed)) {
                    _pre32Data = m_io.ReadBytesFull();
                }
            }
            private bool f_byteAt05h;
            private byte? _byteAt05h;
            public byte? ByteAt05h
            {
                get
                {
                    if (f_byteAt05h)
                        return _byteAt05h;
                    f_byteAt05h = true;
                    if (M_Io.Size >= 2) {
                        long _pos = m_io.Pos;
                        m_io.Seek(1);
                        _byteAt05h = m_io.ReadU1();
                        m_io.Seek(_pos);
                    }
                    return _byteAt05h;
                }
            }
            private bool f_isLengthPrefixed;
            private bool _isLengthPrefixed;

            /// <summary>
            /// True if the structure is long enough for the 3.2 layout (a length,
            /// that many bytes and a record count). A pre-3.2 structure can pass
            /// this test by chance.
            /// </summary>
            public bool IsLengthPrefixed
            {
                get
                {
                    if (f_isLengthPrefixed)
                        return _isLengthPrefixed;
                    f_isLengthPrefixed = true;
                    _isLengthPrefixed = (bool) ( ((M_Io.Size >= 3) && (M_Io.Size >= 3 + ByteAt05h)) );
                    return _isLengthPrefixed;
                }
            }
            private HostInterfaceType _interfaceType;
            private byte? _lenInterfaceTypeSpecificData;
            private byte[] _interfaceTypeSpecificData;
            private byte? _numProtocolRecords;
            private List<HostInterfaceProtocolRecord> _protocolRecords;
            private byte[] _pre32Data;
            private Smbios m_root;
            private Smbios.Structure m_parent;

            /// <summary>
            /// 0 to 0x3f are MCTP host interface types defined by DSP0239.
            /// </summary>
            public HostInterfaceType InterfaceType { get { return _interfaceType; } }

            /// <summary>
            /// Absent before version 3.2, when the data of an OEM interface
            /// started with the IANA enterprise number right here.
            /// </summary>
            public byte? LenInterfaceTypeSpecificData { get { return _lenInterfaceTypeSpecificData; } }

            /// <summary>
            /// For an OEM interface, starts with the IANA enterprise number
            /// (big-endian); the network host interface data is defined by
            /// DSP0270.
            /// </summary>
            public byte[] InterfaceTypeSpecificData { get { return _interfaceTypeSpecificData; } }
            public byte? NumProtocolRecords { get { return _numProtocolRecords; } }
            public List<HostInterfaceProtocolRecord> ProtocolRecords { get { return _protocolRecords; } }

            /// <summary>
            /// Everything after `interface_type` in a structure too short for the
            /// 3.2 layout; for an OEM interface, starts with the IANA enterprise
            /// number.
            /// </summary>
            public byte[] Pre32Data { get { return _pre32Data; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 34.
        /// </summary>
        public partial class ManagementDevice : KaitaiStruct
        {
            public static ManagementDevice FromFile(string fileName)
            {
                return new ManagementDevice(new KaitaiStream(fileName));
            }

            public ManagementDevice(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _description = new StringRef(M_Parent, m_io, this, m_root);
                _deviceType = ((Smbios.ManagementDeviceType) m_io.ReadU1());
                _address = m_io.ReadU4le();
                _addressType = ((Smbios.ManagementDeviceAddressType) m_io.ReadU1());
            }
            private StringRef _description;
            private ManagementDeviceType _deviceType;
            private uint _address;
            private ManagementDeviceAddressType _addressType;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef Description { get { return _description; } }
            public ManagementDeviceType DeviceType { get { return _deviceType; } }
            public uint Address { get { return _address; } }
            public ManagementDeviceAddressType AddressType { get { return _addressType; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 35.
        /// </summary>
        public partial class ManagementDeviceComponent : KaitaiStruct
        {
            public static ManagementDeviceComponent FromFile(string fileName)
            {
                return new ManagementDeviceComponent(new KaitaiStream(fileName));
            }

            public ManagementDeviceComponent(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _description = new StringRef(M_Parent, m_io, this, m_root);
                _managementDeviceHandle = m_io.ReadU2le();
                _componentHandle = m_io.ReadU2le();
                if (!(M_Io.IsEof)) {
                    _thresholdHandle = m_io.ReadU2le();
                }
            }
            private StringRef _description;
            private ushort _managementDeviceHandle;
            private ushort _componentHandle;
            private ushort? _thresholdHandle;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef Description { get { return _description; } }
            public ushort ManagementDeviceHandle { get { return _managementDeviceHandle; } }

            /// <summary>
            /// Handle of the probe or cooling device.
            /// </summary>
            public ushort ComponentHandle { get { return _componentHandle; } }

            /// <summary>
            /// Handle of a management device threshold data structure.
            /// </summary>
            public ushort? ThresholdHandle { get { return _thresholdHandle; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 36. The unit is that of the component (mV, mA, 1/10 °C or rpm);
        /// -32768 (0x8000) means unavailable.
        /// </summary>
        public partial class ManagementDeviceThresholdData : KaitaiStruct
        {
            public static ManagementDeviceThresholdData FromFile(string fileName)
            {
                return new ManagementDeviceThresholdData(new KaitaiStream(fileName));
            }

            public ManagementDeviceThresholdData(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _lowerThresholdNonCritical = m_io.ReadS2le();
                _upperThresholdNonCritical = m_io.ReadS2le();
                _lowerThresholdCritical = m_io.ReadS2le();
                _upperThresholdCritical = m_io.ReadS2le();
                _lowerThresholdNonRecoverable = m_io.ReadS2le();
                _upperThresholdNonRecoverable = m_io.ReadS2le();
            }
            private short _lowerThresholdNonCritical;
            private short _upperThresholdNonCritical;
            private short _lowerThresholdCritical;
            private short _upperThresholdCritical;
            private short _lowerThresholdNonRecoverable;
            private short _upperThresholdNonRecoverable;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public short LowerThresholdNonCritical { get { return _lowerThresholdNonCritical; } }
            public short UpperThresholdNonCritical { get { return _upperThresholdNonCritical; } }
            public short LowerThresholdCritical { get { return _lowerThresholdCritical; } }
            public short UpperThresholdCritical { get { return _upperThresholdCritical; } }
            public short LowerThresholdNonRecoverable { get { return _lowerThresholdNonRecoverable; } }
            public short UpperThresholdNonRecoverable { get { return _upperThresholdNonRecoverable; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 19.
        /// </summary>
        public partial class MemoryArrayMappedAddress : KaitaiStruct
        {
            public static MemoryArrayMappedAddress FromFile(string fileName)
            {
                return new MemoryArrayMappedAddress(new KaitaiStream(fileName));
            }

            public MemoryArrayMappedAddress(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _startingAddress = m_io.ReadU4le();
                _endingAddress = m_io.ReadU4le();
                _memoryArrayHandle = m_io.ReadU2le();
                _partitionWidth = m_io.ReadU1();
                if (!(M_Io.IsEof)) {
                    _extendedStartingAddress = m_io.ReadU8le();
                }
                if (!(M_Io.IsEof)) {
                    _extendedEndingAddress = m_io.ReadU8le();
                }
            }
            private uint _startingAddress;
            private uint _endingAddress;
            private ushort _memoryArrayHandle;
            private byte _partitionWidth;
            private ulong? _extendedStartingAddress;
            private ulong? _extendedEndingAddress;
            private Smbios m_root;
            private Smbios.Structure m_parent;

            /// <summary>
            /// In KiB; 0xffffffff if given in `extended_starting_address`.
            /// </summary>
            public uint StartingAddress { get { return _startingAddress; } }

            /// <summary>
            /// Address of the last KiB of the range; 0xffffffff if given in
            /// `extended_ending_address`.
            /// </summary>
            public uint EndingAddress { get { return _endingAddress; } }
            public ushort MemoryArrayHandle { get { return _memoryArrayHandle; } }

            /// <summary>
            /// Number of memory devices that form a row.
            /// </summary>
            public byte PartitionWidth { get { return _partitionWidth; } }

            /// <summary>
            /// In bytes.
            /// </summary>
            public ulong? ExtendedStartingAddress { get { return _extendedStartingAddress; } }

            /// <summary>
            /// Address of the last byte of the range.
            /// </summary>
            public ulong? ExtendedEndingAddress { get { return _extendedEndingAddress; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 37.
        /// </summary>
        public partial class MemoryChannel : KaitaiStruct
        {
            public static MemoryChannel FromFile(string fileName)
            {
                return new MemoryChannel(new KaitaiStream(fileName));
            }

            public MemoryChannel(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _channelType = ((Smbios.MemoryChannelType) m_io.ReadU1());
                _maximumChannelLoad = m_io.ReadU1();
                _numMemoryDevices = m_io.ReadU1();
                _memoryDevices = new List<MemoryChannelDevice>();
                for (var i = 0; i < NumMemoryDevices; i++)
                {
                    _memoryDevices.Add(new MemoryChannelDevice(m_io, this, m_root));
                }
            }
            private MemoryChannelType _channelType;
            private byte _maximumChannelLoad;
            private byte _numMemoryDevices;
            private List<MemoryChannelDevice> _memoryDevices;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public MemoryChannelType ChannelType { get { return _channelType; } }
            public byte MaximumChannelLoad { get { return _maximumChannelLoad; } }
            public byte NumMemoryDevices { get { return _numMemoryDevices; } }
            public List<MemoryChannelDevice> MemoryDevices { get { return _memoryDevices; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }
        public partial class MemoryChannelDevice : KaitaiStruct
        {
            public static MemoryChannelDevice FromFile(string fileName)
            {
                return new MemoryChannelDevice(new KaitaiStream(fileName));
            }

            public MemoryChannelDevice(KaitaiStream p__io, Smbios.MemoryChannel p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _load = m_io.ReadU1();
                _handle = m_io.ReadU2le();
            }
            private byte _load;
            private ushort _handle;
            private Smbios m_root;
            private Smbios.MemoryChannel m_parent;
            public byte Load { get { return _load; } }
            public ushort Handle { get { return _handle; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.MemoryChannel M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 5, obsolete since version 2.1.
        /// </summary>
        public partial class MemoryControllerInformation : KaitaiStruct
        {
            public static MemoryControllerInformation FromFile(string fileName)
            {
                return new MemoryControllerInformation(new KaitaiStream(fileName));
            }

            public MemoryControllerInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _errorDetectingMethod = ((Smbios.ErrorDetectingMethod) m_io.ReadU1());
                _errorCorrectingCapability = new ErrorCorrectingCapability(m_io, this, m_root);
                _supportedInterleave = ((Smbios.InterleaveSupport) m_io.ReadU1());
                _currentInterleave = ((Smbios.InterleaveSupport) m_io.ReadU1());
                _maxMemoryModuleSize = m_io.ReadU1();
                _supportedSpeeds = new MemorySpeeds(m_io, this, m_root);
                _supportedMemoryTypes = new MemoryModuleTypes(m_io, this, m_root);
                _memoryModuleVoltage = new MemoryModuleVoltage(m_io, this, m_root);
                _numMemoryModuleHandles = m_io.ReadU1();
                _memoryModuleHandles = new List<ushort>();
                for (var i = 0; i < NumMemoryModuleHandles; i++)
                {
                    _memoryModuleHandles.Add(m_io.ReadU2le());
                }
                if (!(M_Io.IsEof)) {
                    _enabledErrorCorrectingCapabilities = new ErrorCorrectingCapability(m_io, this, m_root);
                }
            }
            private ErrorDetectingMethod _errorDetectingMethod;
            private ErrorCorrectingCapability _errorCorrectingCapability;
            private InterleaveSupport _supportedInterleave;
            private InterleaveSupport _currentInterleave;
            private byte _maxMemoryModuleSize;
            private MemorySpeeds _supportedSpeeds;
            private MemoryModuleTypes _supportedMemoryTypes;
            private MemoryModuleVoltage _memoryModuleVoltage;
            private byte _numMemoryModuleHandles;
            private List<ushort> _memoryModuleHandles;
            private ErrorCorrectingCapability _enabledErrorCorrectingCapabilities;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public ErrorDetectingMethod ErrorDetectingMethod { get { return _errorDetectingMethod; } }
            public ErrorCorrectingCapability ErrorCorrectingCapability { get { return _errorCorrectingCapability; } }
            public InterleaveSupport SupportedInterleave { get { return _supportedInterleave; } }
            public InterleaveSupport CurrentInterleave { get { return _currentInterleave; } }

            /// <summary>
            /// Largest module supported per slot is `2 ** max_memory_module_size` MiB.
            /// </summary>
            public byte MaxMemoryModuleSize { get { return _maxMemoryModuleSize; } }
            public MemorySpeeds SupportedSpeeds { get { return _supportedSpeeds; } }
            public MemoryModuleTypes SupportedMemoryTypes { get { return _supportedMemoryTypes; } }
            public MemoryModuleVoltage MemoryModuleVoltage { get { return _memoryModuleVoltage; } }
            public byte NumMemoryModuleHandles { get { return _numMemoryModuleHandles; } }
            public List<ushort> MemoryModuleHandles { get { return _memoryModuleHandles; } }
            public ErrorCorrectingCapability EnabledErrorCorrectingCapabilities { get { return _enabledErrorCorrectingCapabilities; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 17.
        /// </summary>
        public partial class MemoryDevice : KaitaiStruct
        {
            public static MemoryDevice FromFile(string fileName)
            {
                return new MemoryDevice(new KaitaiStream(fileName));
            }

            public MemoryDevice(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _physicalMemoryArrayHandle = m_io.ReadU2le();
                _memoryErrorInformationHandle = m_io.ReadU2le();
                _totalWidth = m_io.ReadU2le();
                _dataWidth = m_io.ReadU2le();
                _size = m_io.ReadU2le();
                _formFactor = ((Smbios.MemoryFormFactor) m_io.ReadU1());
                _deviceSet = m_io.ReadU1();
                _deviceLocator = new StringRef(M_Parent, m_io, this, m_root);
                _bankLocator = new StringRef(M_Parent, m_io, this, m_root);
                _memoryType = ((Smbios.MemoryDeviceType) m_io.ReadU1());
                _typeDetail = new MemoryTypeDetail(m_io, this, m_root);
                if (!(M_Io.IsEof)) {
                    _speed = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _manufacturer = new StringRef(M_Parent, m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _serialNumber = new StringRef(M_Parent, m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _assetTag = new StringRef(M_Parent, m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _partNumber = new StringRef(M_Parent, m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _rank = m_io.ReadBitsIntLe(5);
                }
                if (!(M_Io.IsEof)) {
                    _disabledByError = m_io.ReadBitsIntLe(1) != 0;
                }
                if (!(M_Io.IsEof)) {
                    _unmapped = m_io.ReadBitsIntLe(1) != 0;
                }
                if (!(M_Io.IsEof)) {
                    _reserved = m_io.ReadBitsIntLe(1) != 0;
                }
                m_io.AlignToByte();
                if (!(M_Io.IsEof)) {
                    _extendedSize = m_io.ReadU4le();
                }
                if (!(M_Io.IsEof)) {
                    _configuredMemorySpeed = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _minimumVoltage = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _maximumVoltage = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _configuredVoltage = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _memoryTechnology = ((Smbios.MemoryTechnology) m_io.ReadU1());
                }
                if (!(M_Io.IsEof)) {
                    _memoryOperatingModeCapability = new MemoryOperatingModeCapability(m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _firmwareVersion = new StringRef(M_Parent, m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _moduleManufacturerId = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _moduleProductId = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _memorySubsystemControllerManufacturerId = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _memorySubsystemControllerProductId = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _nonVolatileSize = m_io.ReadU8le();
                }
                if (!(M_Io.IsEof)) {
                    _volatileSize = m_io.ReadU8le();
                }
                if (!(M_Io.IsEof)) {
                    _cacheSize = m_io.ReadU8le();
                }
                if (!(M_Io.IsEof)) {
                    _logicalSize = m_io.ReadU8le();
                }
                if (!(M_Io.IsEof)) {
                    _extendedSpeed = m_io.ReadU4le();
                }
                if (!(M_Io.IsEof)) {
                    _extendedConfiguredMemorySpeed = m_io.ReadU4le();
                }
                if (!(M_Io.IsEof)) {
                    _pmic0ManufacturerId = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _pmic0RevisionNumber = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _rcdManufacturerId = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _rcdRevisionNumber = m_io.ReadU2le();
                }
            }
            private ushort _physicalMemoryArrayHandle;
            private ushort _memoryErrorInformationHandle;
            private ushort _totalWidth;
            private ushort _dataWidth;
            private ushort _size;
            private MemoryFormFactor _formFactor;
            private byte _deviceSet;
            private StringRef _deviceLocator;
            private StringRef _bankLocator;
            private MemoryDeviceType _memoryType;
            private MemoryTypeDetail _typeDetail;
            private ushort? _speed;
            private StringRef _manufacturer;
            private StringRef _serialNumber;
            private StringRef _assetTag;
            private StringRef _partNumber;
            private ulong? _rank;
            private bool? _disabledByError;
            private bool? _unmapped;
            private bool? _reserved;
            private uint? _extendedSize;
            private ushort? _configuredMemorySpeed;
            private ushort? _minimumVoltage;
            private ushort? _maximumVoltage;
            private ushort? _configuredVoltage;
            private MemoryTechnology _memoryTechnology;
            private MemoryOperatingModeCapability _memoryOperatingModeCapability;
            private StringRef _firmwareVersion;
            private ushort? _moduleManufacturerId;
            private ushort? _moduleProductId;
            private ushort? _memorySubsystemControllerManufacturerId;
            private ushort? _memorySubsystemControllerProductId;
            private ulong? _nonVolatileSize;
            private ulong? _volatileSize;
            private ulong? _cacheSize;
            private ulong? _logicalSize;
            private uint? _extendedSpeed;
            private uint? _extendedConfiguredMemorySpeed;
            private ushort? _pmic0ManufacturerId;
            private ushort? _pmic0RevisionNumber;
            private ushort? _rcdManufacturerId;
            private ushort? _rcdRevisionNumber;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public ushort PhysicalMemoryArrayHandle { get { return _physicalMemoryArrayHandle; } }

            /// <summary>
            /// Handle of a memory error information structure; 0xfffe if the
            /// system does not provide one, 0xffff if there was no error.
            /// </summary>
            public ushort MemoryErrorInformationHandle { get { return _memoryErrorInformationHandle; } }

            /// <summary>
            /// In bits, including error-correction bits; 0xffff if unknown.
            /// </summary>
            public ushort TotalWidth { get { return _totalWidth; } }

            /// <summary>
            /// In bits; 0xffff if unknown.
            /// </summary>
            public ushort DataWidth { get { return _dataWidth; } }

            /// <summary>
            /// In MiB, or in KiB if bit 15 is set; 0 if no device is installed,
            /// 0xffff if unknown, 0x7fff if given in `extended_size`.
            /// </summary>
            public ushort Size { get { return _size; } }
            public MemoryFormFactor FormFactor { get { return _formFactor; } }

            /// <summary>
            /// 0 if not part of a set, 0xff if unknown.
            /// </summary>
            public byte DeviceSet { get { return _deviceSet; } }

            /// <summary>
            /// E.g. &quot;DIMM 3&quot;.
            /// </summary>
            public StringRef DeviceLocator { get { return _deviceLocator; } }
            public StringRef BankLocator { get { return _bankLocator; } }
            public MemoryDeviceType MemoryType { get { return _memoryType; } }
            public MemoryTypeDetail TypeDetail { get { return _typeDetail; } }

            /// <summary>
            /// Maximum speed in MT/s; 0 if unknown, 0xffff if given in `extended_speed`.
            /// </summary>
            public ushort? Speed { get { return _speed; } }
            public StringRef Manufacturer { get { return _manufacturer; } }
            public StringRef SerialNumber { get { return _serialNumber; } }
            public StringRef AssetTag { get { return _assetTag; } }
            public StringRef PartNumber { get { return _partNumber; } }

            /// <summary>
            /// 0 if unknown.
            /// </summary>
            public ulong? Rank { get { return _rank; } }
            public bool? DisabledByError { get { return _disabledByError; } }
            public bool? Unmapped { get { return _unmapped; } }
            public bool? Reserved { get { return _reserved; } }

            /// <summary>
            /// In MiB, for devices of 32 GiB - 1 MiB or more; bit 31 is reserved.
            /// </summary>
            public uint? ExtendedSize { get { return _extendedSize; } }

            /// <summary>
            /// In MT/s; 0 if unknown, 0xffff if given in
            /// `extended_configured_memory_speed`.
            /// </summary>
            public ushort? ConfiguredMemorySpeed { get { return _configuredMemorySpeed; } }

            /// <summary>
            /// In mV, 0 if unknown.
            /// </summary>
            public ushort? MinimumVoltage { get { return _minimumVoltage; } }

            /// <summary>
            /// In mV, 0 if unknown.
            /// </summary>
            public ushort? MaximumVoltage { get { return _maximumVoltage; } }

            /// <summary>
            /// In mV, 0 if unknown.
            /// </summary>
            public ushort? ConfiguredVoltage { get { return _configuredVoltage; } }
            public MemoryTechnology MemoryTechnology { get { return _memoryTechnology; } }
            public MemoryOperatingModeCapability MemoryOperatingModeCapability { get { return _memoryOperatingModeCapability; } }
            public StringRef FirmwareVersion { get { return _firmwareVersion; } }

            /// <summary>
            /// JEP-106 code from the SPD: the bank (continuation count) in the
            /// low byte, the code in the high byte; 0 if unknown.
            /// </summary>
            public ushort? ModuleManufacturerId { get { return _moduleManufacturerId; } }

            /// <summary>
            /// 0 if unknown.
            /// </summary>
            public ushort? ModuleProductId { get { return _moduleProductId; } }

            /// <summary>
            /// JEP-106 code from the SPD, as `module_manufacturer_id`.
            /// </summary>
            public ushort? MemorySubsystemControllerManufacturerId { get { return _memorySubsystemControllerManufacturerId; } }
            public ushort? MemorySubsystemControllerProductId { get { return _memorySubsystemControllerProductId; } }

            /// <summary>
            /// In bytes; all bits set if unknown.
            /// </summary>
            public ulong? NonVolatileSize { get { return _nonVolatileSize; } }

            /// <summary>
            /// In bytes; all bits set if unknown.
            /// </summary>
            public ulong? VolatileSize { get { return _volatileSize; } }

            /// <summary>
            /// In bytes; all bits set if unknown.
            /// </summary>
            public ulong? CacheSize { get { return _cacheSize; } }

            /// <summary>
            /// In bytes; all bits set if unknown.
            /// </summary>
            public ulong? LogicalSize { get { return _logicalSize; } }

            /// <summary>
            /// In MT/s; bit 31 is reserved.
            /// </summary>
            public uint? ExtendedSpeed { get { return _extendedSpeed; } }

            /// <summary>
            /// In MT/s; bit 31 is reserved.
            /// </summary>
            public uint? ExtendedConfiguredMemorySpeed { get { return _extendedConfiguredMemorySpeed; } }

            /// <summary>
            /// JEP-106 code from the SPD, as `module_manufacturer_id`.
            /// </summary>
            public ushort? Pmic0ManufacturerId { get { return _pmic0ManufacturerId; } }

            /// <summary>
            /// 0xff00 if unknown.
            /// </summary>
            public ushort? Pmic0RevisionNumber { get { return _pmic0RevisionNumber; } }

            /// <summary>
            /// JEP-106 code from the SPD, as `module_manufacturer_id`.
            /// </summary>
            public ushort? RcdManufacturerId { get { return _rcdManufacturerId; } }

            /// <summary>
            /// 0xff00 if unknown.
            /// </summary>
            public ushort? RcdRevisionNumber { get { return _rcdRevisionNumber; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 20.
        /// </summary>
        public partial class MemoryDeviceMappedAddress : KaitaiStruct
        {
            public static MemoryDeviceMappedAddress FromFile(string fileName)
            {
                return new MemoryDeviceMappedAddress(new KaitaiStream(fileName));
            }

            public MemoryDeviceMappedAddress(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _startingAddress = m_io.ReadU4le();
                _endingAddress = m_io.ReadU4le();
                _memoryDeviceHandle = m_io.ReadU2le();
                _memoryArrayMappedAddressHandle = m_io.ReadU2le();
                _partitionRowPosition = m_io.ReadU1();
                _interleavePosition = m_io.ReadU1();
                _interleavedDataDepth = m_io.ReadU1();
                if (!(M_Io.IsEof)) {
                    _extendedStartingAddress = m_io.ReadU8le();
                }
                if (!(M_Io.IsEof)) {
                    _extendedEndingAddress = m_io.ReadU8le();
                }
            }
            private uint _startingAddress;
            private uint _endingAddress;
            private ushort _memoryDeviceHandle;
            private ushort _memoryArrayMappedAddressHandle;
            private byte _partitionRowPosition;
            private byte _interleavePosition;
            private byte _interleavedDataDepth;
            private ulong? _extendedStartingAddress;
            private ulong? _extendedEndingAddress;
            private Smbios m_root;
            private Smbios.Structure m_parent;

            /// <summary>
            /// In KiB; 0xffffffff if given in `extended_starting_address`.
            /// </summary>
            public uint StartingAddress { get { return _startingAddress; } }

            /// <summary>
            /// Address of the last KiB of the range; 0xffffffff if given in
            /// `extended_ending_address`.
            /// </summary>
            public uint EndingAddress { get { return _endingAddress; } }
            public ushort MemoryDeviceHandle { get { return _memoryDeviceHandle; } }
            public ushort MemoryArrayMappedAddressHandle { get { return _memoryArrayMappedAddressHandle; } }

            /// <summary>
            /// Position of the device in a row, starting at 1; 0xff if unknown.
            /// </summary>
            public byte PartitionRowPosition { get { return _partitionRowPosition; } }

            /// <summary>
            /// 0 if not interleaved, 0xff if unknown.
            /// </summary>
            public byte InterleavePosition { get { return _interleavePosition; } }

            /// <summary>
            /// 0 if not interleaved, 0xff if unknown.
            /// </summary>
            public byte InterleavedDataDepth { get { return _interleavedDataDepth; } }

            /// <summary>
            /// In bytes.
            /// </summary>
            public ulong? ExtendedStartingAddress { get { return _extendedStartingAddress; } }

            /// <summary>
            /// Address of the last byte of the range.
            /// </summary>
            public ulong? ExtendedEndingAddress { get { return _extendedEndingAddress; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 18.
        /// </summary>
        public partial class MemoryErrorInformation32 : KaitaiStruct
        {
            public static MemoryErrorInformation32 FromFile(string fileName)
            {
                return new MemoryErrorInformation32(new KaitaiStream(fileName));
            }

            public MemoryErrorInformation32(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _errorType = ((Smbios.MemoryErrorType) m_io.ReadU1());
                _errorGranularity = ((Smbios.MemoryErrorGranularity) m_io.ReadU1());
                _errorOperation = ((Smbios.MemoryErrorOperation) m_io.ReadU1());
                _vendorSyndrome = m_io.ReadU4le();
                _memoryArrayErrorAddress = m_io.ReadU4le();
                _deviceErrorAddress = m_io.ReadU4le();
                _errorResolution = m_io.ReadU4le();
            }
            private MemoryErrorType _errorType;
            private MemoryErrorGranularity _errorGranularity;
            private MemoryErrorOperation _errorOperation;
            private uint _vendorSyndrome;
            private uint _memoryArrayErrorAddress;
            private uint _deviceErrorAddress;
            private uint _errorResolution;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public MemoryErrorType ErrorType { get { return _errorType; } }
            public MemoryErrorGranularity ErrorGranularity { get { return _errorGranularity; } }
            public MemoryErrorOperation ErrorOperation { get { return _errorOperation; } }

            /// <summary>
            /// 0 if unknown.
            /// </summary>
            public uint VendorSyndrome { get { return _vendorSyndrome; } }

            /// <summary>
            /// 0x80000000 if unknown.
            /// </summary>
            public uint MemoryArrayErrorAddress { get { return _memoryArrayErrorAddress; } }

            /// <summary>
            /// 0x80000000 if unknown.
            /// </summary>
            public uint DeviceErrorAddress { get { return _deviceErrorAddress; } }

            /// <summary>
            /// In bytes; 0x80000000 if unknown.
            /// </summary>
            public uint ErrorResolution { get { return _errorResolution; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 33.
        /// </summary>
        public partial class MemoryErrorInformation64 : KaitaiStruct
        {
            public static MemoryErrorInformation64 FromFile(string fileName)
            {
                return new MemoryErrorInformation64(new KaitaiStream(fileName));
            }

            public MemoryErrorInformation64(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _errorType = ((Smbios.MemoryErrorType) m_io.ReadU1());
                _errorGranularity = ((Smbios.MemoryErrorGranularity) m_io.ReadU1());
                _errorOperation = ((Smbios.MemoryErrorOperation) m_io.ReadU1());
                _vendorSyndrome = m_io.ReadU4le();
                _memoryArrayErrorAddress = m_io.ReadU8le();
                _deviceErrorAddress = m_io.ReadU8le();
                _errorResolution = m_io.ReadU4le();
            }
            private MemoryErrorType _errorType;
            private MemoryErrorGranularity _errorGranularity;
            private MemoryErrorOperation _errorOperation;
            private uint _vendorSyndrome;
            private ulong _memoryArrayErrorAddress;
            private ulong _deviceErrorAddress;
            private uint _errorResolution;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public MemoryErrorType ErrorType { get { return _errorType; } }
            public MemoryErrorGranularity ErrorGranularity { get { return _errorGranularity; } }
            public MemoryErrorOperation ErrorOperation { get { return _errorOperation; } }

            /// <summary>
            /// 0 if unknown.
            /// </summary>
            public uint VendorSyndrome { get { return _vendorSyndrome; } }

            /// <summary>
            /// 0x8000000000000000 if unknown.
            /// </summary>
            public ulong MemoryArrayErrorAddress { get { return _memoryArrayErrorAddress; } }

            /// <summary>
            /// 0x8000000000000000 if unknown.
            /// </summary>
            public ulong DeviceErrorAddress { get { return _deviceErrorAddress; } }

            /// <summary>
            /// In bytes; 0x80000000 if unknown.
            /// </summary>
            public uint ErrorResolution { get { return _errorResolution; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 6, obsolete since version 2.1.
        /// </summary>
        public partial class MemoryModuleInformation : KaitaiStruct
        {
            public static MemoryModuleInformation FromFile(string fileName)
            {
                return new MemoryModuleInformation(new KaitaiStream(fileName));
            }

            public MemoryModuleInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _socketDesignation = new StringRef(M_Parent, m_io, this, m_root);
                _bankConnections = m_io.ReadU1();
                _currentSpeed = m_io.ReadU1();
                _currentMemoryType = new MemoryModuleTypes(m_io, this, m_root);
                _installedSize = new MemoryModuleSize(m_io, this, m_root);
                _enabledSize = new MemoryModuleSize(m_io, this, m_root);
                _uncorrectableErrors = m_io.ReadBitsIntLe(1) != 0;
                _correctableErrors = m_io.ReadBitsIntLe(1) != 0;
                _errorStatusInEventLog = m_io.ReadBitsIntLe(1) != 0;
                _reserved = m_io.ReadBitsIntLe(5);
            }
            private StringRef _socketDesignation;
            private byte _bankConnections;
            private byte _currentSpeed;
            private MemoryModuleTypes _currentMemoryType;
            private MemoryModuleSize _installedSize;
            private MemoryModuleSize _enabledSize;
            private bool _uncorrectableErrors;
            private bool _correctableErrors;
            private bool _errorStatusInEventLog;
            private ulong _reserved;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef SocketDesignation { get { return _socketDesignation; } }

            /// <summary>
            /// Each nibble is a bank (RAS#) the socket is connected to, 0xf for
            /// none; e.g. 0x13 for banks 1 and 3.
            /// </summary>
            public byte BankConnections { get { return _bankConnections; } }

            /// <summary>
            /// In ns, 0 if unknown.
            /// </summary>
            public byte CurrentSpeed { get { return _currentSpeed; } }
            public MemoryModuleTypes CurrentMemoryType { get { return _currentMemoryType; } }
            public MemoryModuleSize InstalledSize { get { return _installedSize; } }
            public MemoryModuleSize EnabledSize { get { return _enabledSize; } }
            public bool UncorrectableErrors { get { return _uncorrectableErrors; } }
            public bool CorrectableErrors { get { return _correctableErrors; } }
            public bool ErrorStatusInEventLog { get { return _errorStatusInEventLog; } }
            public ulong Reserved { get { return _reserved; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }
        public partial class MemoryModuleSize : KaitaiStruct
        {
            public static MemoryModuleSize FromFile(string fileName)
            {
                return new MemoryModuleSize(new KaitaiStream(fileName));
            }

            public MemoryModuleSize(KaitaiStream p__io, Smbios.MemoryModuleInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _size = m_io.ReadBitsIntLe(7);
                _doubleBank = m_io.ReadBitsIntLe(1) != 0;
            }
            private ulong _size;
            private bool _doubleBank;
            private Smbios m_root;
            private Smbios.MemoryModuleInformation m_parent;

            /// <summary>
            /// `2 ** size` MiB; 0x7d if not determinable, 0x7e if installed but
            /// not enabled, 0x7f if not installed.
            /// </summary>
            public ulong Size { get { return _size; } }
            public bool DoubleBank { get { return _doubleBank; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.MemoryModuleInformation M_Parent { get { return m_parent; } }
        }
        public partial class MemoryModuleTypes : KaitaiStruct
        {
            public static MemoryModuleTypes FromFile(string fileName)
            {
                return new MemoryModuleTypes(new KaitaiStream(fileName));
            }

            public MemoryModuleTypes(KaitaiStream p__io, KaitaiStruct p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _other = m_io.ReadBitsIntLe(1) != 0;
                _unknown = m_io.ReadBitsIntLe(1) != 0;
                _standard = m_io.ReadBitsIntLe(1) != 0;
                _fastPageMode = m_io.ReadBitsIntLe(1) != 0;
                _edo = m_io.ReadBitsIntLe(1) != 0;
                _parity = m_io.ReadBitsIntLe(1) != 0;
                _ecc = m_io.ReadBitsIntLe(1) != 0;
                _simm = m_io.ReadBitsIntLe(1) != 0;
                _dimm = m_io.ReadBitsIntLe(1) != 0;
                _burstEdo = m_io.ReadBitsIntLe(1) != 0;
                _sdram = m_io.ReadBitsIntLe(1) != 0;
                _reserved = m_io.ReadBitsIntLe(5);
            }
            private bool _other;
            private bool _unknown;
            private bool _standard;
            private bool _fastPageMode;
            private bool _edo;
            private bool _parity;
            private bool _ecc;
            private bool _simm;
            private bool _dimm;
            private bool _burstEdo;
            private bool _sdram;
            private ulong _reserved;
            private Smbios m_root;
            private KaitaiStruct m_parent;
            public bool Other { get { return _other; } }
            public bool Unknown { get { return _unknown; } }
            public bool Standard { get { return _standard; } }
            public bool FastPageMode { get { return _fastPageMode; } }
            public bool Edo { get { return _edo; } }
            public bool Parity { get { return _parity; } }
            public bool Ecc { get { return _ecc; } }
            public bool Simm { get { return _simm; } }
            public bool Dimm { get { return _dimm; } }
            public bool BurstEdo { get { return _burstEdo; } }
            public bool Sdram { get { return _sdram; } }
            public ulong Reserved { get { return _reserved; } }
            public Smbios M_Root { get { return m_root; } }
            public KaitaiStruct M_Parent { get { return m_parent; } }
        }
        public partial class MemoryModuleVoltage : KaitaiStruct
        {
            public static MemoryModuleVoltage FromFile(string fileName)
            {
                return new MemoryModuleVoltage(new KaitaiStream(fileName));
            }

            public MemoryModuleVoltage(KaitaiStream p__io, Smbios.MemoryControllerInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _voltage5v = m_io.ReadBitsIntLe(1) != 0;
                _voltage3v3 = m_io.ReadBitsIntLe(1) != 0;
                _voltage2v9 = m_io.ReadBitsIntLe(1) != 0;
                _reserved = m_io.ReadBitsIntLe(5);
            }
            private bool _voltage5v;
            private bool _voltage3v3;
            private bool _voltage2v9;
            private ulong _reserved;
            private Smbios m_root;
            private Smbios.MemoryControllerInformation m_parent;
            public bool Voltage5v { get { return _voltage5v; } }
            public bool Voltage3v3 { get { return _voltage3v3; } }
            public bool Voltage2v9 { get { return _voltage2v9; } }
            public ulong Reserved { get { return _reserved; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.MemoryControllerInformation M_Parent { get { return m_parent; } }
        }
        public partial class MemoryOperatingModeCapability : KaitaiStruct
        {
            public static MemoryOperatingModeCapability FromFile(string fileName)
            {
                return new MemoryOperatingModeCapability(new KaitaiStream(fileName));
            }

            public MemoryOperatingModeCapability(KaitaiStream p__io, Smbios.MemoryDevice p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _reserved1 = m_io.ReadBitsIntLe(1) != 0;
                _other = m_io.ReadBitsIntLe(1) != 0;
                _unknown = m_io.ReadBitsIntLe(1) != 0;
                _volatileMemory = m_io.ReadBitsIntLe(1) != 0;
                _byteAccessiblePersistentMemory = m_io.ReadBitsIntLe(1) != 0;
                _blockAccessiblePersistentMemory = m_io.ReadBitsIntLe(1) != 0;
                _reserved2 = m_io.ReadBitsIntLe(10);
            }
            private bool _reserved1;
            private bool _other;
            private bool _unknown;
            private bool _volatileMemory;
            private bool _byteAccessiblePersistentMemory;
            private bool _blockAccessiblePersistentMemory;
            private ulong _reserved2;
            private Smbios m_root;
            private Smbios.MemoryDevice m_parent;
            public bool Reserved1 { get { return _reserved1; } }
            public bool Other { get { return _other; } }
            public bool Unknown { get { return _unknown; } }
            public bool VolatileMemory { get { return _volatileMemory; } }
            public bool ByteAccessiblePersistentMemory { get { return _byteAccessiblePersistentMemory; } }
            public bool BlockAccessiblePersistentMemory { get { return _blockAccessiblePersistentMemory; } }
            public ulong Reserved2 { get { return _reserved2; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.MemoryDevice M_Parent { get { return m_parent; } }
        }
        public partial class MemorySpeeds : KaitaiStruct
        {
            public static MemorySpeeds FromFile(string fileName)
            {
                return new MemorySpeeds(new KaitaiStream(fileName));
            }

            public MemorySpeeds(KaitaiStream p__io, Smbios.MemoryControllerInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _other = m_io.ReadBitsIntLe(1) != 0;
                _unknown = m_io.ReadBitsIntLe(1) != 0;
                _speed70ns = m_io.ReadBitsIntLe(1) != 0;
                _speed60ns = m_io.ReadBitsIntLe(1) != 0;
                _speed50ns = m_io.ReadBitsIntLe(1) != 0;
                _reserved = m_io.ReadBitsIntLe(11);
            }
            private bool _other;
            private bool _unknown;
            private bool _speed70ns;
            private bool _speed60ns;
            private bool _speed50ns;
            private ulong _reserved;
            private Smbios m_root;
            private Smbios.MemoryControllerInformation m_parent;
            public bool Other { get { return _other; } }
            public bool Unknown { get { return _unknown; } }
            public bool Speed70ns { get { return _speed70ns; } }
            public bool Speed60ns { get { return _speed60ns; } }
            public bool Speed50ns { get { return _speed50ns; } }
            public ulong Reserved { get { return _reserved; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.MemoryControllerInformation M_Parent { get { return m_parent; } }
        }
        public partial class MemoryTypeDetail : KaitaiStruct
        {
            public static MemoryTypeDetail FromFile(string fileName)
            {
                return new MemoryTypeDetail(new KaitaiStream(fileName));
            }

            public MemoryTypeDetail(KaitaiStream p__io, Smbios.MemoryDevice p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _reserved = m_io.ReadBitsIntLe(1) != 0;
                _other = m_io.ReadBitsIntLe(1) != 0;
                _unknown = m_io.ReadBitsIntLe(1) != 0;
                _fastPaged = m_io.ReadBitsIntLe(1) != 0;
                _staticColumn = m_io.ReadBitsIntLe(1) != 0;
                _pseudoStatic = m_io.ReadBitsIntLe(1) != 0;
                _rambus = m_io.ReadBitsIntLe(1) != 0;
                _synchronous = m_io.ReadBitsIntLe(1) != 0;
                _cmos = m_io.ReadBitsIntLe(1) != 0;
                _edo = m_io.ReadBitsIntLe(1) != 0;
                _windowDram = m_io.ReadBitsIntLe(1) != 0;
                _cacheDram = m_io.ReadBitsIntLe(1) != 0;
                _nonVolatile = m_io.ReadBitsIntLe(1) != 0;
                _registered = m_io.ReadBitsIntLe(1) != 0;
                _unbuffered = m_io.ReadBitsIntLe(1) != 0;
                _lrdimm = m_io.ReadBitsIntLe(1) != 0;
            }
            private bool _reserved;
            private bool _other;
            private bool _unknown;
            private bool _fastPaged;
            private bool _staticColumn;
            private bool _pseudoStatic;
            private bool _rambus;
            private bool _synchronous;
            private bool _cmos;
            private bool _edo;
            private bool _windowDram;
            private bool _cacheDram;
            private bool _nonVolatile;
            private bool _registered;
            private bool _unbuffered;
            private bool _lrdimm;
            private Smbios m_root;
            private Smbios.MemoryDevice m_parent;
            public bool Reserved { get { return _reserved; } }
            public bool Other { get { return _other; } }
            public bool Unknown { get { return _unknown; } }
            public bool FastPaged { get { return _fastPaged; } }
            public bool StaticColumn { get { return _staticColumn; } }
            public bool PseudoStatic { get { return _pseudoStatic; } }
            public bool Rambus { get { return _rambus; } }
            public bool Synchronous { get { return _synchronous; } }
            public bool Cmos { get { return _cmos; } }
            public bool Edo { get { return _edo; } }
            public bool WindowDram { get { return _windowDram; } }
            public bool CacheDram { get { return _cacheDram; } }
            public bool NonVolatile { get { return _nonVolatile; } }
            public bool Registered { get { return _registered; } }
            public bool Unbuffered { get { return _unbuffered; } }
            public bool Lrdimm { get { return _lrdimm; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.MemoryDevice M_Parent { get { return m_parent; } }
        }
        public partial class OnBoardDevice : KaitaiStruct
        {
            public static OnBoardDevice FromFile(string fileName)
            {
                return new OnBoardDevice(new KaitaiStream(fileName));
            }

            public OnBoardDevice(KaitaiStream p__io, Smbios.OnBoardDevicesInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _deviceType = ((Smbios.OnboardDeviceType) m_io.ReadBitsIntLe(7));
                _enabled = m_io.ReadBitsIntLe(1) != 0;
                m_io.AlignToByte();
                _description = new StringRef(M_Parent.M_Parent, m_io, this, m_root);
            }
            private OnboardDeviceType _deviceType;
            private bool _enabled;
            private StringRef _description;
            private Smbios m_root;
            private Smbios.OnBoardDevicesInformation m_parent;
            public OnboardDeviceType DeviceType { get { return _deviceType; } }
            public bool Enabled { get { return _enabled; } }
            public StringRef Description { get { return _description; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.OnBoardDevicesInformation M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 10, obsolete since version 2.6.
        /// </summary>
        public partial class OnBoardDevicesInformation : KaitaiStruct
        {
            public static OnBoardDevicesInformation FromFile(string fileName)
            {
                return new OnBoardDevicesInformation(new KaitaiStream(fileName));
            }

            public OnBoardDevicesInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _devices = new List<OnBoardDevice>();
                {
                    var i = 0;
                    while (!m_io.IsEof) {
                        _devices.Add(new OnBoardDevice(m_io, this, m_root));
                        i++;
                    }
                }
            }
            private List<OnBoardDevice> _devices;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public List<OnBoardDevice> Devices { get { return _devices; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 41.
        /// </summary>
        public partial class OnboardDevicesExtendedInformation : KaitaiStruct
        {
            public static OnboardDevicesExtendedInformation FromFile(string fileName)
            {
                return new OnboardDevicesExtendedInformation(new KaitaiStream(fileName));
            }

            public OnboardDevicesExtendedInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _referenceDesignation = new StringRef(M_Parent, m_io, this, m_root);
                _deviceType = ((Smbios.OnboardDeviceType) m_io.ReadBitsIntLe(7));
                _enabled = m_io.ReadBitsIntLe(1) != 0;
                m_io.AlignToByte();
                _deviceTypeInstance = m_io.ReadU1();
                _address = new PciAddress(m_io, this, m_root);
            }
            private StringRef _referenceDesignation;
            private OnboardDeviceType _deviceType;
            private bool _enabled;
            private byte _deviceTypeInstance;
            private PciAddress _address;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef ReferenceDesignation { get { return _referenceDesignation; } }
            public OnboardDeviceType DeviceType { get { return _deviceType; } }
            public bool Enabled { get { return _enabled; } }

            /// <summary>
            /// Number of the device among those of its type, starting at 1.
            /// </summary>
            public byte DeviceTypeInstance { get { return _deviceTypeInstance; } }
            public PciAddress Address { get { return _address; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 30.
        /// </summary>
        public partial class OutOfBandRemoteAccess : KaitaiStruct
        {
            public static OutOfBandRemoteAccess FromFile(string fileName)
            {
                return new OutOfBandRemoteAccess(new KaitaiStream(fileName));
            }

            public OutOfBandRemoteAccess(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _manufacturerName = new StringRef(M_Parent, m_io, this, m_root);
                _inboundConnectionEnabled = m_io.ReadBitsIntLe(1) != 0;
                _outboundConnectionEnabled = m_io.ReadBitsIntLe(1) != 0;
                _reserved = m_io.ReadBitsIntLe(6);
            }
            private StringRef _manufacturerName;
            private bool _inboundConnectionEnabled;
            private bool _outboundConnectionEnabled;
            private ulong _reserved;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef ManufacturerName { get { return _manufacturerName; } }
            public bool InboundConnectionEnabled { get { return _inboundConnectionEnabled; } }
            public bool OutboundConnectionEnabled { get { return _outboundConnectionEnabled; } }
            public ulong Reserved { get { return _reserved; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// PCI segment group, bus, device and function. Devices that are not on
        /// a PCI-like bus have 0xffff, 0xff and 0xff here.
        /// </summary>
        public partial class PciAddress : KaitaiStruct
        {
            public static PciAddress FromFile(string fileName)
            {
                return new PciAddress(new KaitaiStream(fileName));
            }

            public PciAddress(KaitaiStream p__io, KaitaiStruct p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _segmentGroupNumber = m_io.ReadU2le();
                _busNumber = m_io.ReadU1();
                _functionNumber = m_io.ReadBitsIntLe(3);
                _deviceNumber = m_io.ReadBitsIntLe(5);
            }
            private ushort _segmentGroupNumber;
            private byte _busNumber;
            private ulong _functionNumber;
            private ulong _deviceNumber;
            private Smbios m_root;
            private KaitaiStruct m_parent;
            public ushort SegmentGroupNumber { get { return _segmentGroupNumber; } }
            public byte BusNumber { get { return _busNumber; } }
            public ulong FunctionNumber { get { return _functionNumber; } }
            public ulong DeviceNumber { get { return _deviceNumber; } }
            public Smbios M_Root { get { return m_root; } }
            public KaitaiStruct M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 16.
        /// </summary>
        public partial class PhysicalMemoryArray : KaitaiStruct
        {
            public static PhysicalMemoryArray FromFile(string fileName)
            {
                return new PhysicalMemoryArray(new KaitaiStream(fileName));
            }

            public PhysicalMemoryArray(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _location = ((Smbios.MemoryArrayLocation) m_io.ReadU1());
                _use = ((Smbios.MemoryArrayUse) m_io.ReadU1());
                _memoryErrorCorrection = ((Smbios.MemoryArrayErrorCorrection) m_io.ReadU1());
                _maximumCapacity = m_io.ReadU4le();
                _memoryErrorInformationHandle = m_io.ReadU2le();
                _numMemoryDevices = m_io.ReadU2le();
                if (!(M_Io.IsEof)) {
                    _extendedMaximumCapacity = m_io.ReadU8le();
                }
            }
            private MemoryArrayLocation _location;
            private MemoryArrayUse _use;
            private MemoryArrayErrorCorrection _memoryErrorCorrection;
            private uint _maximumCapacity;
            private ushort _memoryErrorInformationHandle;
            private ushort _numMemoryDevices;
            private ulong? _extendedMaximumCapacity;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public MemoryArrayLocation Location { get { return _location; } }
            public MemoryArrayUse Use { get { return _use; } }
            public MemoryArrayErrorCorrection MemoryErrorCorrection { get { return _memoryErrorCorrection; } }

            /// <summary>
            /// In KiB; 0x80000000 if given in `extended_maximum_capacity`.
            /// </summary>
            public uint MaximumCapacity { get { return _maximumCapacity; } }

            /// <summary>
            /// Handle of a memory error information structure; 0xfffe if the
            /// system does not provide one, 0xffff if there was no error.
            /// </summary>
            public ushort MemoryErrorInformationHandle { get { return _memoryErrorInformationHandle; } }
            public ushort NumMemoryDevices { get { return _numMemoryDevices; } }

            /// <summary>
            /// In bytes.
            /// </summary>
            public ulong? ExtendedMaximumCapacity { get { return _extendedMaximumCapacity; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 0, called BIOS information before version 3.8.
        /// </summary>
        public partial class PlatformFirmwareInformation : KaitaiStruct
        {
            public static PlatformFirmwareInformation FromFile(string fileName)
            {
                return new PlatformFirmwareInformation(new KaitaiStream(fileName));
            }

            public PlatformFirmwareInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _vendor = new StringRef(M_Parent, m_io, this, m_root);
                _firmwareVersion = new StringRef(M_Parent, m_io, this, m_root);
                _startingAddressSegment = m_io.ReadU2le();
                _releaseDate = new StringRef(M_Parent, m_io, this, m_root);
                _romSize = m_io.ReadU1();
                _characteristics = new FirmwareCharacteristics(m_io, this, m_root);
                if (!(M_Io.IsEof)) {
                    _characteristicsExt1 = new FirmwareCharacteristicsExt1(m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _characteristicsExt2 = new FirmwareCharacteristicsExt2(m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _platformFirmwareMajorRelease = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _platformFirmwareMinorRelease = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _embeddedControllerFirmwareMajorRelease = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _embeddedControllerFirmwareMinorRelease = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _extendedRomSize = new ExtendedRomSize(m_io, this, m_root);
                }
            }
            private StringRef _vendor;
            private StringRef _firmwareVersion;
            private ushort _startingAddressSegment;
            private StringRef _releaseDate;
            private byte _romSize;
            private FirmwareCharacteristics _characteristics;
            private FirmwareCharacteristicsExt1 _characteristicsExt1;
            private FirmwareCharacteristicsExt2 _characteristicsExt2;
            private byte? _platformFirmwareMajorRelease;
            private byte? _platformFirmwareMinorRelease;
            private byte? _embeddedControllerFirmwareMajorRelease;
            private byte? _embeddedControllerFirmwareMinorRelease;
            private ExtendedRomSize _extendedRomSize;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef Vendor { get { return _vendor; } }
            public StringRef FirmwareVersion { get { return _firmwareVersion; } }

            /// <summary>
            /// Segment of the BIOS starting address, e.g. 0xe800; the runtime
            /// image takes `(0x10000 - starting_address_segment) * 16` bytes.
            /// 0 if it does not apply, e.g. on UEFI systems.
            /// </summary>
            public ushort StartingAddressSegment { get { return _startingAddressSegment; } }

            /// <summary>
            /// In mm/dd/yyyy format (mm/dd/yy before version 2.3).
            /// </summary>
            public StringRef ReleaseDate { get { return _releaseDate; } }

            /// <summary>
            /// Size of the ROM is `(rom_size + 1) * 64` KiB; 0xff means that it is
            /// 16 MiB or more and given in `extended_rom_size`.
            /// </summary>
            public byte RomSize { get { return _romSize; } }
            public FirmwareCharacteristics Characteristics { get { return _characteristics; } }
            public FirmwareCharacteristicsExt1 CharacteristicsExt1 { get { return _characteristicsExt1; } }
            public FirmwareCharacteristicsExt2 CharacteristicsExt2 { get { return _characteristicsExt2; } }

            /// <summary>
            /// 0xff, as is the minor release, if not supported.
            /// </summary>
            public byte? PlatformFirmwareMajorRelease { get { return _platformFirmwareMajorRelease; } }
            public byte? PlatformFirmwareMinorRelease { get { return _platformFirmwareMinorRelease; } }

            /// <summary>
            /// 0xff if the embedded controller firmware cannot be upgraded.
            /// </summary>
            public byte? EmbeddedControllerFirmwareMajorRelease { get { return _embeddedControllerFirmwareMajorRelease; } }
            public byte? EmbeddedControllerFirmwareMinorRelease { get { return _embeddedControllerFirmwareMinorRelease; } }
            public ExtendedRomSize ExtendedRomSize { get { return _extendedRomSize; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 8.
        /// </summary>
        public partial class PortConnectorInformation : KaitaiStruct
        {
            public static PortConnectorInformation FromFile(string fileName)
            {
                return new PortConnectorInformation(new KaitaiStream(fileName));
            }

            public PortConnectorInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _internalReferenceDesignator = new StringRef(M_Parent, m_io, this, m_root);
                _internalConnectorType = ((Smbios.ConnectorType) m_io.ReadU1());
                _externalReferenceDesignator = new StringRef(M_Parent, m_io, this, m_root);
                _externalConnectorType = ((Smbios.ConnectorType) m_io.ReadU1());
                _portType = ((Smbios.PortType) m_io.ReadU1());
            }
            private StringRef _internalReferenceDesignator;
            private ConnectorType _internalConnectorType;
            private StringRef _externalReferenceDesignator;
            private ConnectorType _externalConnectorType;
            private PortType _portType;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef InternalReferenceDesignator { get { return _internalReferenceDesignator; } }
            public ConnectorType InternalConnectorType { get { return _internalConnectorType; } }
            public StringRef ExternalReferenceDesignator { get { return _externalReferenceDesignator; } }
            public ConnectorType ExternalConnectorType { get { return _externalConnectorType; } }
            public PortType PortType { get { return _portType; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 22.
        /// </summary>
        public partial class PortableBattery : KaitaiStruct
        {
            public static PortableBattery FromFile(string fileName)
            {
                return new PortableBattery(new KaitaiStream(fileName));
            }

            public PortableBattery(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _location = new StringRef(M_Parent, m_io, this, m_root);
                _manufacturer = new StringRef(M_Parent, m_io, this, m_root);
                _manufactureDate = new StringRef(M_Parent, m_io, this, m_root);
                _serialNumber = new StringRef(M_Parent, m_io, this, m_root);
                _deviceName = new StringRef(M_Parent, m_io, this, m_root);
                _deviceChemistry = ((Smbios.BatteryChemistry) m_io.ReadU1());
                _designCapacity = m_io.ReadU2le();
                _designVoltage = m_io.ReadU2le();
                _sbdsVersionNumber = new StringRef(M_Parent, m_io, this, m_root);
                _maximumErrorInBatteryData = m_io.ReadU1();
                if (!(M_Io.IsEof)) {
                    _sbdsSerialNumber = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _sbdsManufactureDate = new SbdsDate(m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _sbdsDeviceChemistry = new StringRef(M_Parent, m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _designCapacityMultiplier = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _oemSpecific = m_io.ReadU4le();
                }
            }
            private StringRef _location;
            private StringRef _manufacturer;
            private StringRef _manufactureDate;
            private StringRef _serialNumber;
            private StringRef _deviceName;
            private BatteryChemistry _deviceChemistry;
            private ushort _designCapacity;
            private ushort _designVoltage;
            private StringRef _sbdsVersionNumber;
            private byte _maximumErrorInBatteryData;
            private ushort? _sbdsSerialNumber;
            private SbdsDate _sbdsManufactureDate;
            private StringRef _sbdsDeviceChemistry;
            private byte? _designCapacityMultiplier;
            private uint? _oemSpecific;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef Location { get { return _location; } }
            public StringRef Manufacturer { get { return _manufacturer; } }

            /// <summary>
            /// None if given in `sbds_manufacture_date`.
            /// </summary>
            public StringRef ManufactureDate { get { return _manufactureDate; } }

            /// <summary>
            /// None if given in `sbds_serial_number`.
            /// </summary>
            public StringRef SerialNumber { get { return _serialNumber; } }
            public StringRef DeviceName { get { return _deviceName; } }

            /// <summary>
            /// `unknown` if given in `sbds_device_chemistry`.
            /// </summary>
            public BatteryChemistry DeviceChemistry { get { return _deviceChemistry; } }

            /// <summary>
            /// In mWh, times `design_capacity_multiplier`; 0 if unknown.
            /// </summary>
            public ushort DesignCapacity { get { return _designCapacity; } }

            /// <summary>
            /// In mV, 0 if unknown.
            /// </summary>
            public ushort DesignVoltage { get { return _designVoltage; } }

            /// <summary>
            /// Smart Battery Data Specification version.
            /// </summary>
            public StringRef SbdsVersionNumber { get { return _sbdsVersionNumber; } }

            /// <summary>
            /// In percent, 0xff if unknown.
            /// </summary>
            public byte MaximumErrorInBatteryData { get { return _maximumErrorInBatteryData; } }
            public ushort? SbdsSerialNumber { get { return _sbdsSerialNumber; } }
            public SbdsDate SbdsManufactureDate { get { return _sbdsManufactureDate; } }

            /// <summary>
            /// E.g. &quot;PbAc&quot;.
            /// </summary>
            public StringRef SbdsDeviceChemistry { get { return _sbdsDeviceChemistry; } }
            public byte? DesignCapacityMultiplier { get { return _designCapacityMultiplier; } }
            public uint? OemSpecific { get { return _oemSpecific; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 44.
        /// </summary>
        public partial class ProcessorAdditionalInformation : KaitaiStruct
        {
            public static ProcessorAdditionalInformation FromFile(string fileName)
            {
                return new ProcessorAdditionalInformation(new KaitaiStream(fileName));
            }

            public ProcessorAdditionalInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _referencedHandle = m_io.ReadU2le();
                _lenProcessorSpecificData = m_io.ReadU1();
                _processorType = ((Smbios.ProcessorArchitectureType) m_io.ReadU1());
                switch (ProcessorType) {
                case Smbios.ProcessorArchitectureType.Aarch64: {
                    __raw_processorSpecificData = m_io.ReadBytes(LenProcessorSpecificData);
                    var io___raw_processorSpecificData = new KaitaiStream(__raw_processorSpecificData);
                    _processorSpecificData = new Aarch64ProcessorSpecificData(io___raw_processorSpecificData, this, m_root);
                    break;
                }
                default: {
                    _processorSpecificData = m_io.ReadBytes(LenProcessorSpecificData);
                    break;
                }
                }
            }
            private ushort _referencedHandle;
            private byte _lenProcessorSpecificData;
            private ProcessorArchitectureType _processorType;
            private object _processorSpecificData;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            private byte[] __raw_processorSpecificData;

            /// <summary>
            /// Handle of the processor information structure this one adds to.
            /// </summary>
            public ushort ReferencedHandle { get { return _referencedHandle; } }
            public byte LenProcessorSpecificData { get { return _lenProcessorSpecificData; } }
            public ProcessorArchitectureType ProcessorType { get { return _processorType; } }

            /// <summary>
            /// Defined in separate documents: the RISC-V BRS, the LoongArch SMBIOS
            /// and the Intel SMBIOS specifications; 64-bit Arm data is part of
            /// DSP0134.
            /// </summary>
            public object ProcessorSpecificData { get { return _processorSpecificData; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
            public byte[] M_RawProcessorSpecificData { get { return __raw_processorSpecificData; } }
        }
        public partial class ProcessorCharacteristics : KaitaiStruct
        {
            public static ProcessorCharacteristics FromFile(string fileName)
            {
                return new ProcessorCharacteristics(new KaitaiStream(fileName));
            }

            public ProcessorCharacteristics(KaitaiStream p__io, Smbios.ProcessorInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _reserved0 = m_io.ReadBitsIntLe(1) != 0;
                _unknown = m_io.ReadBitsIntLe(1) != 0;
                _capable64Bit = m_io.ReadBitsIntLe(1) != 0;
                _multiCore = m_io.ReadBitsIntLe(1) != 0;
                _hardwareThread = m_io.ReadBitsIntLe(1) != 0;
                _executeProtection = m_io.ReadBitsIntLe(1) != 0;
                _enhancedVirtualization = m_io.ReadBitsIntLe(1) != 0;
                _powerPerformanceControl = m_io.ReadBitsIntLe(1) != 0;
                _capable128Bit = m_io.ReadBitsIntLe(1) != 0;
                _arm64SocId = m_io.ReadBitsIntLe(1) != 0;
                _reserved1 = m_io.ReadBitsIntLe(6);
            }
            private bool _reserved0;
            private bool _unknown;
            private bool _capable64Bit;
            private bool _multiCore;
            private bool _hardwareThread;
            private bool _executeProtection;
            private bool _enhancedVirtualization;
            private bool _powerPerformanceControl;
            private bool _capable128Bit;
            private bool _arm64SocId;
            private ulong _reserved1;
            private Smbios m_root;
            private Smbios.ProcessorInformation m_parent;
            public bool Reserved0 { get { return _reserved0; } }
            public bool Unknown { get { return _unknown; } }
            public bool Capable64Bit { get { return _capable64Bit; } }
            public bool MultiCore { get { return _multiCore; } }
            public bool HardwareThread { get { return _hardwareThread; } }
            public bool ExecuteProtection { get { return _executeProtection; } }
            public bool EnhancedVirtualization { get { return _enhancedVirtualization; } }
            public bool PowerPerformanceControl { get { return _powerPerformanceControl; } }
            public bool Capable128Bit { get { return _capable128Bit; } }
            public bool Arm64SocId { get { return _arm64SocId; } }
            public ulong Reserved1 { get { return _reserved1; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.ProcessorInformation M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 4.
        /// </summary>
        public partial class ProcessorInformation : KaitaiStruct
        {
            public static ProcessorInformation FromFile(string fileName)
            {
                return new ProcessorInformation(new KaitaiStream(fileName));
            }

            public ProcessorInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _socketDesignation = new StringRef(M_Parent, m_io, this, m_root);
                _processorType = ((Smbios.ProcessorType) m_io.ReadU1());
                _processorFamily = ((Smbios.ProcessorFamily) m_io.ReadU1());
                _processorManufacturer = new StringRef(M_Parent, m_io, this, m_root);
                _processorId = m_io.ReadBytes(8);
                _processorVersion = new StringRef(M_Parent, m_io, this, m_root);
                _voltage = m_io.ReadU1();
                _externalClock = m_io.ReadU2le();
                _maxSpeed = m_io.ReadU2le();
                _currentSpeed = m_io.ReadU2le();
                _cpuStatus = ((Smbios.CpuStatus) m_io.ReadBitsIntLe(3));
                _reserved1 = m_io.ReadBitsIntLe(3);
                _socketPopulated = m_io.ReadBitsIntLe(1) != 0;
                _reserved2 = m_io.ReadBitsIntLe(1) != 0;
                m_io.AlignToByte();
                _processorUpgrade = ((Smbios.ProcessorUpgrade) m_io.ReadU1());
                if (!(M_Io.IsEof)) {
                    _l1CacheHandle = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _l2CacheHandle = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _l3CacheHandle = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _serialNumber = new StringRef(M_Parent, m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _assetTag = new StringRef(M_Parent, m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _partNumber = new StringRef(M_Parent, m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _coreCount = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _coreEnabled = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _threadCount = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _processorCharacteristics = new ProcessorCharacteristics(m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _processorFamily2 = ((Smbios.ProcessorFamily) m_io.ReadU2le());
                }
                if (!(M_Io.IsEof)) {
                    _coreCount2 = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _coreEnabled2 = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _threadCount2 = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _threadEnabled = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _socketType = new StringRef(M_Parent, m_io, this, m_root);
                }
            }
            private StringRef _socketDesignation;
            private ProcessorType _processorType;
            private ProcessorFamily _processorFamily;
            private StringRef _processorManufacturer;
            private byte[] _processorId;
            private StringRef _processorVersion;
            private byte _voltage;
            private ushort _externalClock;
            private ushort _maxSpeed;
            private ushort _currentSpeed;
            private CpuStatus _cpuStatus;
            private ulong _reserved1;
            private bool _socketPopulated;
            private bool _reserved2;
            private ProcessorUpgrade _processorUpgrade;
            private ushort? _l1CacheHandle;
            private ushort? _l2CacheHandle;
            private ushort? _l3CacheHandle;
            private StringRef _serialNumber;
            private StringRef _assetTag;
            private StringRef _partNumber;
            private byte? _coreCount;
            private byte? _coreEnabled;
            private byte? _threadCount;
            private ProcessorCharacteristics _processorCharacteristics;
            private ProcessorFamily _processorFamily2;
            private ushort? _coreCount2;
            private ushort? _coreEnabled2;
            private ushort? _threadCount2;
            private ushort? _threadEnabled;
            private StringRef _socketType;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef SocketDesignation { get { return _socketDesignation; } }
            public ProcessorType ProcessorType { get { return _processorType; } }

            /// <summary>
            /// `indicator_family_2` means that the family is in
            /// `processor_family_2`.
            /// </summary>
            public ProcessorFamily ProcessorFamily { get { return _processorFamily; } }
            public StringRef ProcessorManufacturer { get { return _processorManufacturer; } }

            /// <summary>
            /// Processor-specific identification data. On x86 the EAX and EDX
            /// values that CPUID returns for leaf 1, on 32-bit Arm the MIDR, on
            /// 64-bit Arm the MIDR_EL1 or (if `arm64_soc_id` is set in the
            /// characteristics) the SoC ID, JEP-106 code and SoC revision, on
            /// RISC-V the mvendorid CSR and on LoongArch the CPUCFG word 0.
            /// </summary>
            public byte[] ProcessorId { get { return _processorId; } }
            public StringRef ProcessorVersion { get { return _processorVersion; } }

            /// <summary>
            /// Deprecated since version 3.8, 0 if unused. If bit 7 is set, the
            /// other bits hold the current voltage in tenths of a volt.
            /// Otherwise bits 0, 1 and 2 are set if the socket accepts 5 V,
            /// 3.3 V and 2.9 V.
            /// </summary>
            public byte Voltage { get { return _voltage; } }

            /// <summary>
            /// In MHz, 0 if unknown.
            /// </summary>
            public ushort ExternalClock { get { return _externalClock; } }

            /// <summary>
            /// In MHz, 0 if unknown. Capability of the socket, not the processor.
            /// </summary>
            public ushort MaxSpeed { get { return _maxSpeed; } }

            /// <summary>
            /// In MHz, 0 if unknown.
            /// </summary>
            public ushort CurrentSpeed { get { return _currentSpeed; } }
            public CpuStatus CpuStatus { get { return _cpuStatus; } }
            public ulong Reserved1 { get { return _reserved1; } }
            public bool SocketPopulated { get { return _socketPopulated; } }
            public bool Reserved2 { get { return _reserved2; } }
            public ProcessorUpgrade ProcessorUpgrade { get { return _processorUpgrade; } }

            /// <summary>
            /// Handle of a cache information structure, 0xffff if there is none.
            /// </summary>
            public ushort? L1CacheHandle { get { return _l1CacheHandle; } }

            /// <summary>
            /// Handle of a cache information structure, 0xffff if there is none.
            /// </summary>
            public ushort? L2CacheHandle { get { return _l2CacheHandle; } }

            /// <summary>
            /// Handle of a cache information structure, 0xffff if there is none.
            /// </summary>
            public ushort? L3CacheHandle { get { return _l3CacheHandle; } }
            public StringRef SerialNumber { get { return _serialNumber; } }
            public StringRef AssetTag { get { return _assetTag; } }
            public StringRef PartNumber { get { return _partNumber; } }

            /// <summary>
            /// 0 if unknown, 0xff if the number is in `core_count_2`.
            /// </summary>
            public byte? CoreCount { get { return _coreCount; } }

            /// <summary>
            /// 0 if unknown, 0xff if the number is in `core_enabled_2`.
            /// </summary>
            public byte? CoreEnabled { get { return _coreEnabled; } }

            /// <summary>
            /// 0 if unknown, 0xff if the number is in `thread_count_2`.
            /// </summary>
            public byte? ThreadCount { get { return _threadCount; } }
            public ProcessorCharacteristics ProcessorCharacteristics { get { return _processorCharacteristics; } }
            public ProcessorFamily ProcessorFamily2 { get { return _processorFamily2; } }

            /// <summary>
            /// 0 if unknown.
            /// </summary>
            public ushort? CoreCount2 { get { return _coreCount2; } }

            /// <summary>
            /// 0 if unknown.
            /// </summary>
            public ushort? CoreEnabled2 { get { return _coreEnabled2; } }

            /// <summary>
            /// 0 if unknown.
            /// </summary>
            public ushort? ThreadCount2 { get { return _threadCount2; } }

            /// <summary>
            /// 0 if unknown.
            /// </summary>
            public ushort? ThreadEnabled { get { return _threadEnabled; } }

            /// <summary>
            /// E.g. &quot;Socket LGA4710&quot;; set if `processor_upgrade` is `other_socket`.
            /// </summary>
            public StringRef SocketType { get { return _socketType; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }
        public partial class SbdsDate : KaitaiStruct
        {
            public static SbdsDate FromFile(string fileName)
            {
                return new SbdsDate(new KaitaiStream(fileName));
            }

            public SbdsDate(KaitaiStream p__io, Smbios.PortableBattery p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _day = m_io.ReadBitsIntLe(5);
                _month = m_io.ReadBitsIntLe(4);
                _yearSince1980 = m_io.ReadBitsIntLe(7);
            }
            private ulong _day;
            private ulong _month;
            private ulong _yearSince1980;
            private Smbios m_root;
            private Smbios.PortableBattery m_parent;
            public ulong Day { get { return _day; } }
            public ulong Month { get { return _month; } }
            public ulong YearSince1980 { get { return _yearSince1980; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.PortableBattery M_Parent { get { return m_parent; } }
        }
        public partial class SlotCharacteristics1 : KaitaiStruct
        {
            public static SlotCharacteristics1 FromFile(string fileName)
            {
                return new SlotCharacteristics1(new KaitaiStream(fileName));
            }

            public SlotCharacteristics1(KaitaiStream p__io, Smbios.SystemSlots p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _unknown = m_io.ReadBitsIntLe(1) != 0;
                _provides5v = m_io.ReadBitsIntLe(1) != 0;
                _provides3v3 = m_io.ReadBitsIntLe(1) != 0;
                _sharedOpening = m_io.ReadBitsIntLe(1) != 0;
                _pcCard16 = m_io.ReadBitsIntLe(1) != 0;
                _cardbus = m_io.ReadBitsIntLe(1) != 0;
                _zoomVideo = m_io.ReadBitsIntLe(1) != 0;
                _modemRingResume = m_io.ReadBitsIntLe(1) != 0;
            }
            private bool _unknown;
            private bool _provides5v;
            private bool _provides3v3;
            private bool _sharedOpening;
            private bool _pcCard16;
            private bool _cardbus;
            private bool _zoomVideo;
            private bool _modemRingResume;
            private Smbios m_root;
            private Smbios.SystemSlots m_parent;
            public bool Unknown { get { return _unknown; } }
            public bool Provides5v { get { return _provides5v; } }
            public bool Provides3v3 { get { return _provides3v3; } }
            public bool SharedOpening { get { return _sharedOpening; } }
            public bool PcCard16 { get { return _pcCard16; } }
            public bool Cardbus { get { return _cardbus; } }
            public bool ZoomVideo { get { return _zoomVideo; } }
            public bool ModemRingResume { get { return _modemRingResume; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.SystemSlots M_Parent { get { return m_parent; } }
        }
        public partial class SlotCharacteristics2 : KaitaiStruct
        {
            public static SlotCharacteristics2 FromFile(string fileName)
            {
                return new SlotCharacteristics2(new KaitaiStream(fileName));
            }

            public SlotCharacteristics2(KaitaiStream p__io, Smbios.SystemSlots p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _pme = m_io.ReadBitsIntLe(1) != 0;
                _hotPlug = m_io.ReadBitsIntLe(1) != 0;
                _smbus = m_io.ReadBitsIntLe(1) != 0;
                _bifurcation = m_io.ReadBitsIntLe(1) != 0;
                _asyncSurpriseRemoval = m_io.ReadBitsIntLe(1) != 0;
                _cxl10 = m_io.ReadBitsIntLe(1) != 0;
                _cxl20 = m_io.ReadBitsIntLe(1) != 0;
                _cxl30 = m_io.ReadBitsIntLe(1) != 0;
            }
            private bool _pme;
            private bool _hotPlug;
            private bool _smbus;
            private bool _bifurcation;
            private bool _asyncSurpriseRemoval;
            private bool _cxl10;
            private bool _cxl20;
            private bool _cxl30;
            private Smbios m_root;
            private Smbios.SystemSlots m_parent;
            public bool Pme { get { return _pme; } }
            public bool HotPlug { get { return _hotPlug; } }
            public bool Smbus { get { return _smbus; } }
            public bool Bifurcation { get { return _bifurcation; } }
            public bool AsyncSurpriseRemoval { get { return _asyncSurpriseRemoval; } }
            public bool Cxl10 { get { return _cxl10; } }
            public bool Cxl20 { get { return _cxl20; } }
            public bool Cxl30 { get { return _cxl30; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.SystemSlots M_Parent { get { return m_parent; } }
        }
        public partial class SlotPeerGroup : KaitaiStruct
        {
            public static SlotPeerGroup FromFile(string fileName)
            {
                return new SlotPeerGroup(new KaitaiStream(fileName));
            }

            public SlotPeerGroup(KaitaiStream p__io, Smbios.SystemSlots p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _address = new PciAddress(m_io, this, m_root);
                _dataBusWidth = m_io.ReadU1();
            }
            private PciAddress _address;
            private byte _dataBusWidth;
            private Smbios m_root;
            private Smbios.SystemSlots m_parent;
            public PciAddress Address { get { return _address; } }
            public byte DataBusWidth { get { return _dataBusWidth; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.SystemSlots M_Parent { get { return m_parent; } }
        }
        public partial class SramTypes : KaitaiStruct
        {
            public static SramTypes FromFile(string fileName)
            {
                return new SramTypes(new KaitaiStream(fileName));
            }

            public SramTypes(KaitaiStream p__io, Smbios.CacheInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _other = m_io.ReadBitsIntLe(1) != 0;
                _unknown = m_io.ReadBitsIntLe(1) != 0;
                _nonBurst = m_io.ReadBitsIntLe(1) != 0;
                _burst = m_io.ReadBitsIntLe(1) != 0;
                _pipelineBurst = m_io.ReadBitsIntLe(1) != 0;
                _synchronous = m_io.ReadBitsIntLe(1) != 0;
                _asynchronous = m_io.ReadBitsIntLe(1) != 0;
                _reserved = m_io.ReadBitsIntLe(9);
            }
            private bool _other;
            private bool _unknown;
            private bool _nonBurst;
            private bool _burst;
            private bool _pipelineBurst;
            private bool _synchronous;
            private bool _asynchronous;
            private ulong _reserved;
            private Smbios m_root;
            private Smbios.CacheInformation m_parent;
            public bool Other { get { return _other; } }
            public bool Unknown { get { return _unknown; } }
            public bool NonBurst { get { return _nonBurst; } }
            public bool Burst { get { return _burst; } }
            public bool PipelineBurst { get { return _pipelineBurst; } }
            public bool Synchronous { get { return _synchronous; } }
            public bool Asynchronous { get { return _asynchronous; } }
            public ulong Reserved { get { return _reserved; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.CacheInformation M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Types 11 (OEM strings) and 12 (system configuration options): the
        /// strings of the structure are its content.
        /// </summary>
        public partial class StringCount : KaitaiStruct
        {
            public static StringCount FromFile(string fileName)
            {
                return new StringCount(new KaitaiStream(fileName));
            }

            public StringCount(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _numStrings = m_io.ReadU1();
            }
            private byte _numStrings;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public byte NumStrings { get { return _numStrings; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 46, a string property of another structure.
        /// </summary>
        public partial class StringProperty : KaitaiStruct
        {
            public static StringProperty FromFile(string fileName)
            {
                return new StringProperty(new KaitaiStream(fileName));
            }

            public StringProperty(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _stringPropertyId = ((Smbios.StringPropertyId) m_io.ReadU2le());
                _stringPropertyValue = new StringRef(M_Parent, m_io, this, m_root);
                _parentHandle = m_io.ReadU2le();
            }
            private StringPropertyId _stringPropertyId;
            private StringRef _stringPropertyValue;
            private ushort _parentHandle;
            private Smbios m_root;
            private Smbios.Structure m_parent;

            /// <summary>
            /// 0x8000 to 0xbfff are firmware vendor IDs, 0xc000 and above OEM IDs.
            /// </summary>
            public StringPropertyId StringPropertyId { get { return _stringPropertyId; } }
            public StringRef StringPropertyValue { get { return _stringPropertyValue; } }
            public ushort ParentHandle { get { return _parentHandle; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Number of a string of the structure, 0 if the field has none.
        /// </summary>
        public partial class StringRef : KaitaiStruct
        {
            public StringRef(Structure p_owner, KaitaiStream p__io, KaitaiStruct p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _owner = p_owner;
                f_value = false;
                _read();
            }
            private void _read()
            {
                _index = m_io.ReadU1();
            }
            private bool f_value;
            private string _value;
            public string Value
            {
                get
                {
                    if (f_value)
                        return _value;
                    f_value = true;
                    if ( ((Index != 0) && (Index < Owner.Strings.Count)) ) {
                        _value = (string) (Owner.Strings[Index - 1]);
                    }
                    return _value;
                }
            }
            private byte _index;
            private Structure _owner;
            private Smbios m_root;
            private KaitaiStruct m_parent;
            public byte Index { get { return _index; } }

            /// <summary>
            /// The structure whose strings the number refers to.
            /// </summary>
            public Structure Owner { get { return _owner; } }
            public Smbios M_Root { get { return m_root; } }
            public KaitaiStruct M_Parent { get { return m_parent; } }
        }
        public partial class Structure : KaitaiStruct
        {
            public static Structure FromFile(string fileName)
            {
                return new Structure(new KaitaiStream(fileName));
            }

            public Structure(KaitaiStream p__io, Smbios p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _type = ((Smbios.StructureType) m_io.ReadU1());
                _lenFormattedArea = m_io.ReadU1();
                _handle = m_io.ReadU2le();
                if (LenFormattedArea >= 4) {
                    switch (Type) {
                    case Smbios.StructureType.AdditionalInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new AdditionalInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.BaseboardInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new BaseboardInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.BuiltInPointingDevice: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new BuiltInPointingDevice(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.CacheInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new CacheInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.CoolingDevice: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new CoolingDevice(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.ElectricalCurrentProbe: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new ElectricalCurrentProbe(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.FirmwareInventoryInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new FirmwareInventoryInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.FirmwareLanguageInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new FirmwareLanguageInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.GroupAssociations: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new GroupAssociations(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.HardwareSecurity: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new HardwareSecurity(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.IpmiDeviceInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new IpmiDeviceInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.ManagementControllerHostInterface: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new ManagementControllerHostInterface(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.ManagementDevice: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new ManagementDevice(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.ManagementDeviceComponent: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new ManagementDeviceComponent(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.ManagementDeviceThresholdData: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new ManagementDeviceThresholdData(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.MemoryArrayMappedAddress: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new MemoryArrayMappedAddress(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.MemoryChannel: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new MemoryChannel(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.MemoryControllerInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new MemoryControllerInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.MemoryDevice: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new MemoryDevice(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.MemoryDeviceMappedAddress: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new MemoryDeviceMappedAddress(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.MemoryErrorInformation32: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new MemoryErrorInformation32(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.MemoryErrorInformation64: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new MemoryErrorInformation64(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.MemoryModuleInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new MemoryModuleInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.OemStrings: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new StringCount(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.OnBoardDevicesInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new OnBoardDevicesInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.OnboardDevicesExtendedInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new OnboardDevicesExtendedInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.OutOfBandRemoteAccess: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new OutOfBandRemoteAccess(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.PhysicalMemoryArray: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new PhysicalMemoryArray(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.PlatformFirmwareInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new PlatformFirmwareInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.PortConnectorInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new PortConnectorInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.PortableBattery: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new PortableBattery(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.ProcessorAdditionalInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new ProcessorAdditionalInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.ProcessorInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new ProcessorInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.StringProperty: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new StringProperty(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.SystemBootInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new SystemBootInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.SystemConfigurationOptions: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new StringCount(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.SystemEnclosure: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new SystemEnclosure(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.SystemEventLog: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new SystemEventLog(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.SystemInformation: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new SystemInformation(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.SystemPowerControls: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new SystemPowerControls(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.SystemPowerSupply: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new SystemPowerSupply(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.SystemReset: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new SystemReset(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.SystemSlots: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new SystemSlots(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.TemperatureProbe: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new TemperatureProbe(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.TpmDevice: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new TpmDevice(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    case Smbios.StructureType.VoltageProbe: {
                        __raw_formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        var io___raw_formattedArea = new KaitaiStream(__raw_formattedArea);
                        _formattedArea = new VoltageProbe(io___raw_formattedArea, this, m_root);
                        break;
                    }
                    default: {
                        _formattedArea = m_io.ReadBytes(LenFormattedArea - 4);
                        break;
                    }
                    }
                }
                if (LenFormattedArea >= 4) {
                    _strings = new List<string>();
                    {
                        var i = 0;
                        string M_;
                        do {
                            M_ = System.Text.Encoding.GetEncoding("UTF-8").GetString(m_io.ReadBytesTerm(0, false, true, true));
                            _strings.Add(M_);
                            i++;
                        } while (!(M_ == ""));
                    }
                }
                if ( ((LenFormattedArea >= 4) && (Strings.Count == 1)) ) {
                    _terminator = m_io.ReadBytes(1);
                    if (!((KaitaiStream.ByteArrayCompare(_terminator, new byte[] { 0 }) == 0)))
                    {
                        throw new ValidationNotEqualError(new byte[] { 0 }, _terminator, m_io, "/types/structure/seq/5");
                    }
                }
            }
            private StructureType _type;
            private byte _lenFormattedArea;
            private ushort _handle;
            private object _formattedArea;
            private List<string> _strings;
            private byte[] _terminator;
            private Smbios m_root;
            private Smbios m_parent;
            private byte[] __raw_formattedArea;
            public StructureType Type { get { return _type; } }

            /// <summary>
            /// Length of the formatted area in bytes, counted from the start of
            /// the structure, i.e. including `type`, this field and `handle`.
            /// </summary>
            public byte LenFormattedArea { get { return _lenFormattedArea; } }

            /// <summary>
            /// Number that other structures use to refer to this one. 0xffff in
            /// a handle field elsewhere means &quot;no structure&quot;.
            /// </summary>
            public ushort Handle { get { return _handle; } }
            public object FormattedArea { get { return _formattedArea; } }

            /// <summary>
            /// Strings of the structure, followed by an empty one that ends the
            /// list. A string field of the formatted area holds the number of
            /// its string, starting at 1, or 0 if it has none.
            /// </summary>
            public List<string> Strings { get { return _strings; } }

            /// <summary>
            /// A structure without strings still ends in two zero bytes; this is
            /// the second one.
            /// </summary>
            public byte[] Terminator { get { return _terminator; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios M_Parent { get { return m_parent; } }
            public byte[] M_RawFormattedArea { get { return __raw_formattedArea; } }
        }

        /// <summary>
        /// Type 32.
        /// </summary>
        public partial class SystemBootInformation : KaitaiStruct
        {
            public static SystemBootInformation FromFile(string fileName)
            {
                return new SystemBootInformation(new KaitaiStream(fileName));
            }

            public SystemBootInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _reserved = m_io.ReadBytes(6);
                if (!(M_Io.IsEof)) {
                    _bootStatus = ((Smbios.BootStatus) m_io.ReadU1());
                }
                _bootStatusData = m_io.ReadBytesFull();
            }
            private byte[] _reserved;
            private BootStatus _bootStatus;
            private byte[] _bootStatusData;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public byte[] Reserved { get { return _reserved; } }

            /// <summary>
            /// 128 to 191 are vendor-specific (the vendor is the system
            /// manufacturer), 192 to 255 product-specific.
            /// </summary>
            public BootStatus BootStatus { get { return _bootStatus; } }

            /// <summary>
            /// Additional data, e.g. for `previously_requested_image`.
            /// </summary>
            public byte[] BootStatusData { get { return _bootStatusData; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 3, system enclosure or chassis.
        /// </summary>
        public partial class SystemEnclosure : KaitaiStruct
        {
            public static SystemEnclosure FromFile(string fileName)
            {
                return new SystemEnclosure(new KaitaiStream(fileName));
            }

            public SystemEnclosure(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _manufacturer = new StringRef(M_Parent, m_io, this, m_root);
                _enclosureType = ((Smbios.ChassisType) m_io.ReadBitsIntLe(7));
                _lockPresent = m_io.ReadBitsIntLe(1) != 0;
                m_io.AlignToByte();
                _version = new StringRef(M_Parent, m_io, this, m_root);
                _serialNumber = new StringRef(M_Parent, m_io, this, m_root);
                _assetTagNumber = new StringRef(M_Parent, m_io, this, m_root);
                if (!(M_Io.IsEof)) {
                    _bootUpState = ((Smbios.ChassisState) m_io.ReadU1());
                }
                if (!(M_Io.IsEof)) {
                    _powerSupplyState = ((Smbios.ChassisState) m_io.ReadU1());
                }
                if (!(M_Io.IsEof)) {
                    _thermalState = ((Smbios.ChassisState) m_io.ReadU1());
                }
                if (!(M_Io.IsEof)) {
                    _securityStatus = ((Smbios.ChassisSecurityStatus) m_io.ReadU1());
                }
                if (!(M_Io.IsEof)) {
                    _oemDefined = m_io.ReadU4le();
                }
                if (!(M_Io.IsEof)) {
                    _height = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _numPowerCords = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _numContainedElements = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _lenContainedElement = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    __raw_containedElements = new List<byte[]>();
                    _containedElements = new List<ContainedElement>();
                    for (var i = 0; i < NumContainedElements; i++)
                    {
                        __raw_containedElements.Add(m_io.ReadBytes(((uint) (LenContainedElement))));
                        var io___raw_containedElements = new KaitaiStream(__raw_containedElements[__raw_containedElements.Count - 1]);
                        _containedElements.Add(new ContainedElement(io___raw_containedElements, this, m_root));
                    }
                }
                if (!(M_Io.IsEof)) {
                    _skuNumber = new StringRef(M_Parent, m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _rackType = ((Smbios.RackType) m_io.ReadU1());
                }
                if (!(M_Io.IsEof)) {
                    _rackHeight = m_io.ReadU1();
                }
            }
            private StringRef _manufacturer;
            private ChassisType _enclosureType;
            private bool _lockPresent;
            private StringRef _version;
            private StringRef _serialNumber;
            private StringRef _assetTagNumber;
            private ChassisState _bootUpState;
            private ChassisState _powerSupplyState;
            private ChassisState _thermalState;
            private ChassisSecurityStatus _securityStatus;
            private uint? _oemDefined;
            private byte? _height;
            private byte? _numPowerCords;
            private byte? _numContainedElements;
            private byte? _lenContainedElement;
            private List<ContainedElement> _containedElements;
            private StringRef _skuNumber;
            private RackType _rackType;
            private byte? _rackHeight;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            private List<byte[]> __raw_containedElements;
            public StringRef Manufacturer { get { return _manufacturer; } }
            public ChassisType EnclosureType { get { return _enclosureType; } }
            public bool LockPresent { get { return _lockPresent; } }
            public StringRef Version { get { return _version; } }
            public StringRef SerialNumber { get { return _serialNumber; } }
            public StringRef AssetTagNumber { get { return _assetTagNumber; } }
            public ChassisState BootUpState { get { return _bootUpState; } }
            public ChassisState PowerSupplyState { get { return _powerSupplyState; } }
            public ChassisState ThermalState { get { return _thermalState; } }
            public ChassisSecurityStatus SecurityStatus { get { return _securityStatus; } }
            public uint? OemDefined { get { return _oemDefined; } }

            /// <summary>
            /// Height in rack units (1.75 in); 0 if unspecified, 0xff if given in
            /// `rack_height`.
            /// </summary>
            public byte? Height { get { return _height; } }

            /// <summary>
            /// 0 if unspecified.
            /// </summary>
            public byte? NumPowerCords { get { return _numPowerCords; } }
            public byte? NumContainedElements { get { return _numContainedElements; } }
            public byte? LenContainedElement { get { return _lenContainedElement; } }
            public List<ContainedElement> ContainedElements { get { return _containedElements; } }
            public StringRef SkuNumber { get { return _skuNumber; } }
            public RackType RackType { get { return _rackType; } }

            /// <summary>
            /// Height of the enclosure in the units of `rack_type`.
            /// </summary>
            public byte? RackHeight { get { return _rackHeight; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
            public List<byte[]> M_RawContainedElements { get { return __raw_containedElements; } }
        }

        /// <summary>
        /// Type 15.
        /// </summary>
        public partial class SystemEventLog : KaitaiStruct
        {
            public static SystemEventLog FromFile(string fileName)
            {
                return new SystemEventLog(new KaitaiStream(fileName));
            }

            public SystemEventLog(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _lenLogArea = m_io.ReadU2le();
                _ofsLogHeader = m_io.ReadU2le();
                _ofsLogData = m_io.ReadU2le();
                _accessMethod = ((Smbios.EventLogAccessMethod) m_io.ReadU1());
                _logAreaValid = m_io.ReadBitsIntLe(1) != 0;
                _logAreaFull = m_io.ReadBitsIntLe(1) != 0;
                _reserved = m_io.ReadBitsIntLe(6);
                m_io.AlignToByte();
                _logChangeToken = m_io.ReadU4le();
                _accessMethodAddress = m_io.ReadU4le();
                if (!(M_Io.IsEof)) {
                    _logHeaderFormat = ((Smbios.EventLogHeaderFormat) m_io.ReadU1());
                }
                if (!(M_Io.IsEof)) {
                    _numSupportedLogTypeDescriptors = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _lenLogTypeDescriptor = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    __raw_supportedLogTypeDescriptors = new List<byte[]>();
                    _supportedLogTypeDescriptors = new List<EventLogTypeDescriptor>();
                    for (var i = 0; i < NumSupportedLogTypeDescriptors; i++)
                    {
                        __raw_supportedLogTypeDescriptors.Add(m_io.ReadBytes(((uint) (LenLogTypeDescriptor))));
                        var io___raw_supportedLogTypeDescriptors = new KaitaiStream(__raw_supportedLogTypeDescriptors[__raw_supportedLogTypeDescriptors.Count - 1]);
                        _supportedLogTypeDescriptors.Add(new EventLogTypeDescriptor(io___raw_supportedLogTypeDescriptors, this, m_root));
                    }
                }
            }
            private ushort _lenLogArea;
            private ushort _ofsLogHeader;
            private ushort _ofsLogData;
            private EventLogAccessMethod _accessMethod;
            private bool _logAreaValid;
            private bool _logAreaFull;
            private ulong _reserved;
            private uint _logChangeToken;
            private uint _accessMethodAddress;
            private EventLogHeaderFormat _logHeaderFormat;
            private byte? _numSupportedLogTypeDescriptors;
            private byte? _lenLogTypeDescriptor;
            private List<EventLogTypeDescriptor> _supportedLogTypeDescriptors;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            private List<byte[]> __raw_supportedLogTypeDescriptors;
            public ushort LenLogArea { get { return _lenLogArea; } }
            public ushort OfsLogHeader { get { return _ofsLogHeader; } }
            public ushort OfsLogData { get { return _ofsLogData; } }
            public EventLogAccessMethod AccessMethod { get { return _accessMethod; } }
            public bool LogAreaValid { get { return _logAreaValid; } }
            public bool LogAreaFull { get { return _logAreaFull; } }
            public ulong Reserved { get { return _reserved; } }

            /// <summary>
            /// Changes whenever the log does; 0 if not implemented.
            /// </summary>
            public uint LogChangeToken { get { return _logChangeToken; } }

            /// <summary>
            /// For the indexed I/O methods, the index port in the low word and
            /// the data port in the high word; for `memory_mapped_32` the
            /// physical address; for `gpnv` the GPNV handle in the low word.
            /// </summary>
            public uint AccessMethodAddress { get { return _accessMethodAddress; } }
            public EventLogHeaderFormat LogHeaderFormat { get { return _logHeaderFormat; } }
            public byte? NumSupportedLogTypeDescriptors { get { return _numSupportedLogTypeDescriptors; } }
            public byte? LenLogTypeDescriptor { get { return _lenLogTypeDescriptor; } }
            public List<EventLogTypeDescriptor> SupportedLogTypeDescriptors { get { return _supportedLogTypeDescriptors; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
            public List<byte[]> M_RawSupportedLogTypeDescriptors { get { return __raw_supportedLogTypeDescriptors; } }
        }

        /// <summary>
        /// Type 1.
        /// </summary>
        public partial class SystemInformation : KaitaiStruct
        {
            public static SystemInformation FromFile(string fileName)
            {
                return new SystemInformation(new KaitaiStream(fileName));
            }

            public SystemInformation(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _manufacturer = new StringRef(M_Parent, m_io, this, m_root);
                _productName = new StringRef(M_Parent, m_io, this, m_root);
                _version = new StringRef(M_Parent, m_io, this, m_root);
                _serialNumber = new StringRef(M_Parent, m_io, this, m_root);
                if (!(M_Io.IsEof)) {
                    _uuid = new SystemUuid(m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _wakeUpType = ((Smbios.WakeUpType) m_io.ReadU1());
                }
                if (!(M_Io.IsEof)) {
                    _skuNumber = new StringRef(M_Parent, m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _family = new StringRef(M_Parent, m_io, this, m_root);
                }
            }
            private StringRef _manufacturer;
            private StringRef _productName;
            private StringRef _version;
            private StringRef _serialNumber;
            private SystemUuid _uuid;
            private WakeUpType _wakeUpType;
            private StringRef _skuNumber;
            private StringRef _family;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef Manufacturer { get { return _manufacturer; } }
            public StringRef ProductName { get { return _productName; } }
            public StringRef Version { get { return _version; } }
            public StringRef SerialNumber { get { return _serialNumber; } }
            public SystemUuid Uuid { get { return _uuid; } }
            public WakeUpType WakeUpType { get { return _wakeUpType; } }
            public StringRef SkuNumber { get { return _skuNumber; } }
            public StringRef Family { get { return _family; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 25, time of the next scheduled power-on. All fields are BCD; a
        /// field outside its range (e.g. 0xff) is ignored.
        /// </summary>
        public partial class SystemPowerControls : KaitaiStruct
        {
            public static SystemPowerControls FromFile(string fileName)
            {
                return new SystemPowerControls(new KaitaiStream(fileName));
            }

            public SystemPowerControls(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _nextScheduledPowerOnMonth = m_io.ReadU1();
                _nextScheduledPowerOnDayOfMonth = m_io.ReadU1();
                _nextScheduledPowerOnHour = m_io.ReadU1();
                _nextScheduledPowerOnMinute = m_io.ReadU1();
                _nextScheduledPowerOnSecond = m_io.ReadU1();
            }
            private byte _nextScheduledPowerOnMonth;
            private byte _nextScheduledPowerOnDayOfMonth;
            private byte _nextScheduledPowerOnHour;
            private byte _nextScheduledPowerOnMinute;
            private byte _nextScheduledPowerOnSecond;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public byte NextScheduledPowerOnMonth { get { return _nextScheduledPowerOnMonth; } }
            public byte NextScheduledPowerOnDayOfMonth { get { return _nextScheduledPowerOnDayOfMonth; } }
            public byte NextScheduledPowerOnHour { get { return _nextScheduledPowerOnHour; } }
            public byte NextScheduledPowerOnMinute { get { return _nextScheduledPowerOnMinute; } }
            public byte NextScheduledPowerOnSecond { get { return _nextScheduledPowerOnSecond; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 39.
        /// </summary>
        public partial class SystemPowerSupply : KaitaiStruct
        {
            public static SystemPowerSupply FromFile(string fileName)
            {
                return new SystemPowerSupply(new KaitaiStream(fileName));
            }

            public SystemPowerSupply(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _powerUnitGroup = m_io.ReadU1();
                _location = new StringRef(M_Parent, m_io, this, m_root);
                _deviceName = new StringRef(M_Parent, m_io, this, m_root);
                _manufacturer = new StringRef(M_Parent, m_io, this, m_root);
                _serialNumber = new StringRef(M_Parent, m_io, this, m_root);
                _assetTagNumber = new StringRef(M_Parent, m_io, this, m_root);
                _modelPartNumber = new StringRef(M_Parent, m_io, this, m_root);
                _revisionLevel = new StringRef(M_Parent, m_io, this, m_root);
                _maxPowerCapacity = m_io.ReadU2le();
                _hotReplaceable = m_io.ReadBitsIntLe(1) != 0;
                _present = m_io.ReadBitsIntLe(1) != 0;
                _unplugged = m_io.ReadBitsIntLe(1) != 0;
                _inputVoltageRangeSwitching = ((Smbios.PowerSupplyRangeSwitching) m_io.ReadBitsIntLe(4));
                _status = ((Smbios.ProbeStatus) m_io.ReadBitsIntLe(3));
                _powerSupplyType = ((Smbios.PowerSupplyType) m_io.ReadBitsIntLe(4));
                _reserved = m_io.ReadBitsIntLe(2);
                m_io.AlignToByte();
                if (!(M_Io.IsEof)) {
                    _inputVoltageProbeHandle = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _coolingDeviceHandle = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _inputCurrentProbeHandle = m_io.ReadU2le();
                }
            }
            private byte _powerUnitGroup;
            private StringRef _location;
            private StringRef _deviceName;
            private StringRef _manufacturer;
            private StringRef _serialNumber;
            private StringRef _assetTagNumber;
            private StringRef _modelPartNumber;
            private StringRef _revisionLevel;
            private ushort _maxPowerCapacity;
            private bool _hotReplaceable;
            private bool _present;
            private bool _unplugged;
            private PowerSupplyRangeSwitching _inputVoltageRangeSwitching;
            private ProbeStatus _status;
            private PowerSupplyType _powerSupplyType;
            private ulong _reserved;
            private ushort? _inputVoltageProbeHandle;
            private ushort? _coolingDeviceHandle;
            private ushort? _inputCurrentProbeHandle;
            private Smbios m_root;
            private Smbios.Structure m_parent;

            /// <summary>
            /// Supplies with the same non-zero group are redundant; 0 if not part
            /// of a redundant unit.
            /// </summary>
            public byte PowerUnitGroup { get { return _powerUnitGroup; } }
            public StringRef Location { get { return _location; } }
            public StringRef DeviceName { get { return _deviceName; } }
            public StringRef Manufacturer { get { return _manufacturer; } }
            public StringRef SerialNumber { get { return _serialNumber; } }
            public StringRef AssetTagNumber { get { return _assetTagNumber; } }
            public StringRef ModelPartNumber { get { return _modelPartNumber; } }
            public StringRef RevisionLevel { get { return _revisionLevel; } }

            /// <summary>
            /// In W, 0x8000 if unknown.
            /// </summary>
            public ushort MaxPowerCapacity { get { return _maxPowerCapacity; } }
            public bool HotReplaceable { get { return _hotReplaceable; } }
            public bool Present { get { return _present; } }
            public bool Unplugged { get { return _unplugged; } }
            public PowerSupplyRangeSwitching InputVoltageRangeSwitching { get { return _inputVoltageRangeSwitching; } }
            public ProbeStatus Status { get { return _status; } }
            public PowerSupplyType PowerSupplyType { get { return _powerSupplyType; } }
            public ulong Reserved { get { return _reserved; } }
            public ushort? InputVoltageProbeHandle { get { return _inputVoltageProbeHandle; } }
            public ushort? CoolingDeviceHandle { get { return _coolingDeviceHandle; } }
            public ushort? InputCurrentProbeHandle { get { return _inputCurrentProbeHandle; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 23, automatic system reset by a watchdog timer.
        /// </summary>
        public partial class SystemReset : KaitaiStruct
        {
            public static SystemReset FromFile(string fileName)
            {
                return new SystemReset(new KaitaiStream(fileName));
            }

            public SystemReset(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _enabled = m_io.ReadBitsIntLe(1) != 0;
                _bootOption = ((Smbios.SystemResetBootOption) m_io.ReadBitsIntLe(2));
                _bootOptionOnLimit = ((Smbios.SystemResetBootOption) m_io.ReadBitsIntLe(2));
                _hasWatchdogTimer = m_io.ReadBitsIntLe(1) != 0;
                _reserved = m_io.ReadBitsIntLe(2);
                m_io.AlignToByte();
                _resetCount = m_io.ReadU2le();
                _resetLimit = m_io.ReadU2le();
                _timerInterval = m_io.ReadU2le();
                _timeout = m_io.ReadU2le();
            }
            private bool _enabled;
            private SystemResetBootOption _bootOption;
            private SystemResetBootOption _bootOptionOnLimit;
            private bool _hasWatchdogTimer;
            private ulong _reserved;
            private ushort _resetCount;
            private ushort _resetLimit;
            private ushort _timerInterval;
            private ushort _timeout;
            private Smbios m_root;
            private Smbios.Structure m_parent;

            /// <summary>
            /// Set if the user enabled the system reset.
            /// </summary>
            public bool Enabled { get { return _enabled; } }

            /// <summary>
            /// What to do after a watchdog reset.
            /// </summary>
            public SystemResetBootOption BootOption { get { return _bootOption; } }

            /// <summary>
            /// What to do when `reset_limit` is reached.
            /// </summary>
            public SystemResetBootOption BootOptionOnLimit { get { return _bootOptionOnLimit; } }
            public bool HasWatchdogTimer { get { return _hasWatchdogTimer; } }
            public ulong Reserved { get { return _reserved; } }

            /// <summary>
            /// Automatic resets since the last intentional one; 0xffff if unknown.
            /// </summary>
            public ushort ResetCount { get { return _resetCount; } }

            /// <summary>
            /// 0xffff if unknown.
            /// </summary>
            public ushort ResetLimit { get { return _resetLimit; } }

            /// <summary>
            /// Watchdog timer interval in minutes; 0xffff if unknown.
            /// </summary>
            public ushort TimerInterval { get { return _timerInterval; } }

            /// <summary>
            /// Minutes before the reboot is initiated; 0xffff if unknown.
            /// </summary>
            public ushort Timeout { get { return _timeout; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 9.
        /// </summary>
        public partial class SystemSlots : KaitaiStruct
        {
            public static SystemSlots FromFile(string fileName)
            {
                return new SystemSlots(new KaitaiStream(fileName));
            }

            public SystemSlots(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _slotDesignation = new StringRef(M_Parent, m_io, this, m_root);
                _slotType = ((Smbios.SlotType) m_io.ReadU1());
                _slotDataBusWidth = ((Smbios.SlotWidth) m_io.ReadU1());
                _currentUsage = ((Smbios.SlotCurrentUsage) m_io.ReadU1());
                _slotLength = ((Smbios.SlotLength) m_io.ReadU1());
                _slotId = m_io.ReadU2le();
                _slotCharacteristics1 = new SlotCharacteristics1(m_io, this, m_root);
                if (!(M_Io.IsEof)) {
                    _slotCharacteristics2 = new SlotCharacteristics2(m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _baseAddress = new PciAddress(m_io, this, m_root);
                }
                if (!(M_Io.IsEof)) {
                    _baseDataBusWidth = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _numPeerGroups = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _peerGroups = new List<SlotPeerGroup>();
                    for (var i = 0; i < NumPeerGroups; i++)
                    {
                        _peerGroups.Add(new SlotPeerGroup(m_io, this, m_root));
                    }
                }
                if (!(M_Io.IsEof)) {
                    _slotInformation = m_io.ReadU1();
                }
                if (!(M_Io.IsEof)) {
                    _slotPhysicalWidth = ((Smbios.SlotWidth) m_io.ReadU1());
                }
                if (!(M_Io.IsEof)) {
                    _slotPitch = m_io.ReadU2le();
                }
                if (!(M_Io.IsEof)) {
                    _slotHeight = ((Smbios.SlotHeight) m_io.ReadU1());
                }
            }
            private StringRef _slotDesignation;
            private SlotType _slotType;
            private SlotWidth _slotDataBusWidth;
            private SlotCurrentUsage _currentUsage;
            private SlotLength _slotLength;
            private ushort _slotId;
            private SlotCharacteristics1 _slotCharacteristics1;
            private SlotCharacteristics2 _slotCharacteristics2;
            private PciAddress _baseAddress;
            private byte? _baseDataBusWidth;
            private byte? _numPeerGroups;
            private List<SlotPeerGroup> _peerGroups;
            private byte? _slotInformation;
            private SlotWidth _slotPhysicalWidth;
            private ushort? _slotPitch;
            private SlotHeight _slotHeight;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef SlotDesignation { get { return _slotDesignation; } }
            public SlotType SlotType { get { return _slotType; } }

            /// <summary>
            /// Electrical width; the physical width is in `slot_type` or `slot_physical_width`.
            /// </summary>
            public SlotWidth SlotDataBusWidth { get { return _slotDataBusWidth; } }
            public SlotCurrentUsage CurrentUsage { get { return _currentUsage; } }
            public SlotLength SlotLength { get { return _slotLength; } }

            /// <summary>
            /// Meaning depends on `slot_type`: the logical slot number for MCA
            /// and EISA, the ACPI _SUN value or $PIRQ slot number for PCI-like
            /// slots, and the adapter (low byte) and socket (high byte) numbers
            /// for PCMCIA.
            /// </summary>
            public ushort SlotId { get { return _slotId; } }
            public SlotCharacteristics1 SlotCharacteristics1 { get { return _slotCharacteristics1; } }
            public SlotCharacteristics2 SlotCharacteristics2 { get { return _slotCharacteristics2; } }

            /// <summary>
            /// Lowest PCI address of the device in the slot.
            /// </summary>
            public PciAddress BaseAddress { get { return _baseAddress; } }
            public byte? BaseDataBusWidth { get { return _baseDataBusWidth; } }
            public byte? NumPeerGroups { get { return _numPeerGroups; } }
            public List<SlotPeerGroup> PeerGroups { get { return _peerGroups; } }

            /// <summary>
            /// The PCI Express generation (e.g. 6) for `pci_express_gen6_and_beyond`
            /// slots, may be set for other PCI Express slots, otherwise 0.
            /// </summary>
            public byte? SlotInformation { get { return _slotInformation; } }
            public SlotWidth SlotPhysicalWidth { get { return _slotPhysicalWidth; } }

            /// <summary>
            /// In 1/100 mm, 0 if unknown.
            /// </summary>
            public ushort? SlotPitch { get { return _slotPitch; } }
            public SlotHeight SlotHeight { get { return _slotHeight; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// UUID of the system. The first three fields are little-endian, unlike
        /// RFC 4122, so {00112233-4455-6677-8899-AABBCCDDEEFF} is stored as
        /// 33 22 11 00 55 44 77 66 88 99 AA BB CC DD EE FF. All 0xff bytes mean
        /// that the UUID is not set but can be; all zero bytes mean that there is
        /// none.
        /// </summary>
        public partial class SystemUuid : KaitaiStruct
        {
            public static SystemUuid FromFile(string fileName)
            {
                return new SystemUuid(new KaitaiStream(fileName));
            }

            public SystemUuid(KaitaiStream p__io, Smbios.SystemInformation p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _timeLow = m_io.ReadU4le();
                _timeMid = m_io.ReadU2le();
                _timeHiAndVersion = m_io.ReadU2le();
                _clockSeqHiAndReserved = m_io.ReadU1();
                _clockSeqLow = m_io.ReadU1();
                _node = m_io.ReadBytes(6);
            }
            private uint _timeLow;
            private ushort _timeMid;
            private ushort _timeHiAndVersion;
            private byte _clockSeqHiAndReserved;
            private byte _clockSeqLow;
            private byte[] _node;
            private Smbios m_root;
            private Smbios.SystemInformation m_parent;
            public uint TimeLow { get { return _timeLow; } }
            public ushort TimeMid { get { return _timeMid; } }
            public ushort TimeHiAndVersion { get { return _timeHiAndVersion; } }
            public byte ClockSeqHiAndReserved { get { return _clockSeqHiAndReserved; } }
            public byte ClockSeqLow { get { return _clockSeqLow; } }
            public byte[] Node { get { return _node; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.SystemInformation M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 28. A value of 0x8000 means unknown.
        /// </summary>
        public partial class TemperatureProbe : KaitaiStruct
        {
            public static TemperatureProbe FromFile(string fileName)
            {
                return new TemperatureProbe(new KaitaiStream(fileName));
            }

            public TemperatureProbe(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _description = new StringRef(M_Parent, m_io, this, m_root);
                _location = ((Smbios.ProbeLocation) m_io.ReadBitsIntLe(5));
                _status = ((Smbios.ProbeStatus) m_io.ReadBitsIntLe(3));
                m_io.AlignToByte();
                _maximumValue = m_io.ReadS2le();
                _minimumValue = m_io.ReadS2le();
                _resolution = m_io.ReadU2le();
                _tolerance = m_io.ReadS2le();
                _accuracy = m_io.ReadU2le();
                _oemDefined = m_io.ReadU4le();
                if (!(M_Io.IsEof)) {
                    _nominalValue = m_io.ReadS2le();
                }
            }
            private StringRef _description;
            private ProbeLocation _location;
            private ProbeStatus _status;
            private short _maximumValue;
            private short _minimumValue;
            private ushort _resolution;
            private short _tolerance;
            private ushort _accuracy;
            private uint _oemDefined;
            private short? _nominalValue;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef Description { get { return _description; } }
            public ProbeLocation Location { get { return _location; } }
            public ProbeStatus Status { get { return _status; } }

            /// <summary>
            /// In 1/10 °C.
            /// </summary>
            public short MaximumValue { get { return _maximumValue; } }

            /// <summary>
            /// In 1/10 °C.
            /// </summary>
            public short MinimumValue { get { return _minimumValue; } }

            /// <summary>
            /// In 1/1000 °C.
            /// </summary>
            public ushort Resolution { get { return _resolution; } }

            /// <summary>
            /// Plus or minus, in 1/10 °C.
            /// </summary>
            public short Tolerance { get { return _tolerance; } }

            /// <summary>
            /// Plus or minus, in 1/100 %.
            /// </summary>
            public ushort Accuracy { get { return _accuracy; } }
            public uint OemDefined { get { return _oemDefined; } }

            /// <summary>
            /// In 1/10 °C.
            /// </summary>
            public short? NominalValue { get { return _nominalValue; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }
        public partial class TpmCharacteristics : KaitaiStruct
        {
            public static TpmCharacteristics FromFile(string fileName)
            {
                return new TpmCharacteristics(new KaitaiStream(fileName));
            }

            public TpmCharacteristics(KaitaiStream p__io, Smbios.TpmDevice p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _reserved1 = m_io.ReadBitsIntLe(2);
                _notSupported = m_io.ReadBitsIntLe(1) != 0;
                _familyConfigurableViaFirmwareUpdate = m_io.ReadBitsIntLe(1) != 0;
                _familyConfigurableViaPlatformSoftware = m_io.ReadBitsIntLe(1) != 0;
                _familyConfigurableViaOemMechanism = m_io.ReadBitsIntLe(1) != 0;
                _reserved2 = m_io.ReadBitsIntLe(58);
            }
            private ulong _reserved1;
            private bool _notSupported;
            private bool _familyConfigurableViaFirmwareUpdate;
            private bool _familyConfigurableViaPlatformSoftware;
            private bool _familyConfigurableViaOemMechanism;
            private ulong _reserved2;
            private Smbios m_root;
            private Smbios.TpmDevice m_parent;
            public ulong Reserved1 { get { return _reserved1; } }
            public bool NotSupported { get { return _notSupported; } }
            public bool FamilyConfigurableViaFirmwareUpdate { get { return _familyConfigurableViaFirmwareUpdate; } }
            public bool FamilyConfigurableViaPlatformSoftware { get { return _familyConfigurableViaPlatformSoftware; } }
            public bool FamilyConfigurableViaOemMechanism { get { return _familyConfigurableViaOemMechanism; } }
            public ulong Reserved2 { get { return _reserved2; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.TpmDevice M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 43.
        /// </summary>
        public partial class TpmDevice : KaitaiStruct
        {
            public static TpmDevice FromFile(string fileName)
            {
                return new TpmDevice(new KaitaiStream(fileName));
            }

            public TpmDevice(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _vendorId = System.Text.Encoding.GetEncoding("ASCII").GetString(KaitaiStream.BytesTerminate(m_io.ReadBytes(4), 0, false));
                _majorSpecVersion = m_io.ReadU1();
                _minorSpecVersion = m_io.ReadU1();
                _firmwareVersion1 = m_io.ReadU4le();
                _firmwareVersion2 = m_io.ReadU4le();
                _description = new StringRef(M_Parent, m_io, this, m_root);
                _characteristics = new TpmCharacteristics(m_io, this, m_root);
                if (!(M_Io.IsEof)) {
                    _oemDefined = m_io.ReadU4le();
                }
            }
            private string _vendorId;
            private byte _majorSpecVersion;
            private byte _minorSpecVersion;
            private uint _firmwareVersion1;
            private uint _firmwareVersion2;
            private StringRef _description;
            private TpmCharacteristics _characteristics;
            private uint? _oemDefined;
            private Smbios m_root;
            private Smbios.Structure m_parent;

            /// <summary>
            /// TCG vendor ID, e.g. &quot;IFX&quot;.
            /// </summary>
            public string VendorId { get { return _vendorId; } }

            /// <summary>
            /// 1 for TPM 1.2, 2 for TPM 2.0.
            /// </summary>
            public byte MajorSpecVersion { get { return _majorSpecVersion; } }
            public byte MinorSpecVersion { get { return _minorSpecVersion; } }

            /// <summary>
            /// For TPM 1.2 the TPM_VERSION structure, for TPM 2.0 the
            /// TPM_PT_FIRMWARE_VERSION_1 property.
            /// </summary>
            public uint FirmwareVersion1 { get { return _firmwareVersion1; } }

            /// <summary>
            /// For TPM 2.0 the TPM_PT_FIRMWARE_VERSION_2 property, else 0.
            /// </summary>
            public uint FirmwareVersion2 { get { return _firmwareVersion2; } }
            public StringRef Description { get { return _description; } }
            public TpmCharacteristics Characteristics { get { return _characteristics; } }
            public uint? OemDefined { get { return _oemDefined; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }

        /// <summary>
        /// Type 26. A value of 0x8000 means unknown.
        /// </summary>
        public partial class VoltageProbe : KaitaiStruct
        {
            public static VoltageProbe FromFile(string fileName)
            {
                return new VoltageProbe(new KaitaiStream(fileName));
            }

            public VoltageProbe(KaitaiStream p__io, Smbios.Structure p__parent = null, Smbios p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _description = new StringRef(M_Parent, m_io, this, m_root);
                _location = ((Smbios.ProbeLocation) m_io.ReadBitsIntLe(5));
                _status = ((Smbios.ProbeStatus) m_io.ReadBitsIntLe(3));
                m_io.AlignToByte();
                _maximumValue = m_io.ReadS2le();
                _minimumValue = m_io.ReadS2le();
                _resolution = m_io.ReadU2le();
                _tolerance = m_io.ReadS2le();
                _accuracy = m_io.ReadU2le();
                _oemDefined = m_io.ReadU4le();
                if (!(M_Io.IsEof)) {
                    _nominalValue = m_io.ReadS2le();
                }
            }
            private StringRef _description;
            private ProbeLocation _location;
            private ProbeStatus _status;
            private short _maximumValue;
            private short _minimumValue;
            private ushort _resolution;
            private short _tolerance;
            private ushort _accuracy;
            private uint _oemDefined;
            private short? _nominalValue;
            private Smbios m_root;
            private Smbios.Structure m_parent;
            public StringRef Description { get { return _description; } }
            public ProbeLocation Location { get { return _location; } }
            public ProbeStatus Status { get { return _status; } }

            /// <summary>
            /// In mV.
            /// </summary>
            public short MaximumValue { get { return _maximumValue; } }

            /// <summary>
            /// In mV.
            /// </summary>
            public short MinimumValue { get { return _minimumValue; } }

            /// <summary>
            /// In 1/10 mV.
            /// </summary>
            public ushort Resolution { get { return _resolution; } }

            /// <summary>
            /// Plus or minus, in mV.
            /// </summary>
            public short Tolerance { get { return _tolerance; } }

            /// <summary>
            /// Plus or minus, in 1/100 %.
            /// </summary>
            public ushort Accuracy { get { return _accuracy; } }
            public uint OemDefined { get { return _oemDefined; } }

            /// <summary>
            /// In mV.
            /// </summary>
            public short? NominalValue { get { return _nominalValue; } }
            public Smbios M_Root { get { return m_root; } }
            public Smbios.Structure M_Parent { get { return m_parent; } }
        }
        private List<Structure> _structures;
        private Smbios m_root;
        private KaitaiStruct m_parent;

        /// <summary>
        /// Ends at the end-of-table structure, at the end of the input, or at a
        /// structure shorter than its header (e.g. zero padding after the table).
        /// </summary>
        public List<Structure> Structures { get { return _structures; } }
        public Smbios M_Root { get { return m_root; } }
        public KaitaiStruct M_Parent { get { return m_parent; } }
    }
}
