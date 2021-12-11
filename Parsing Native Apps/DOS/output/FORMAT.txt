Formats a disk for use with Windows.

FORMAT volume [/FS:file-system] [/V:label] [/Q] [/L[:state]] [/A:size] [/C] [/I:state] [/X] [/P:passes] [/S:state]
FORMAT volume [/V:label] [/Q] [/F:size] [/P:passes]
FORMAT volume [/V:label] [/Q] [/T:tracks /N:sectors] [/P:passes]
FORMAT volume [/V:label] [/Q] [/P:passes]
FORMAT volume [/Q]

  volume          Specifies the drive letter (followed by a colon),
                  mount point, or volume name.
  /FS:filesystem  Specifies the type of the file system (FAT, FAT32, exFAT,
                  NTFS, UDF, ReFS).
  /V:label        Specifies the volume label.
  /Q              Performs a quick format. Note that this switch overrides /P.
  /C              NTFS only: Files created on the new volume will be compressed
                  by default.
  /X              Forces the volume to dismount first if necessary.  All opened
                  handles to the volume would no longer be valid.
  /R:revision     UDF only: Forces the format to a specific UDF version
                  (1.02, 1.50, 2.00, 2.01, 2.50).  The default
                  revision is 2.01.
  /D              UDF 2.50 only: Metadata will be duplicated.
  /L[:state]      NTFS Only: Overrides the default size of file record.
                  By default, a non-tiered volume will be formatted with small
                  size file records and a tiered volume will be formatted with
                  large size file records.  /L and /L:enable forces format to
                  use large size file records and /L:disable forces format to
                  use small size file records.
  /A:size         Overrides the default allocation unit size. Default settings
                  are strongly recommended for general use.
                  ReFS supports 4096, 64K.
                  NTFS supports 512, 1024, 2048, 4096, 8192, 16K, 32K, 64K,
                  128K, 256K, 512K, 1M, 2M.
                  FAT supports 512, 1024, 2048, 4096, 8192, 16K, 32K, 64K,
                  (128K, 256K for sector size > 512 bytes).
                  FAT32 supports 512, 1024, 2048, 4096, 8192, 16K, 32K, 64K,
                  (128K, 256K for sector size > 512 bytes).
                  exFAT supports 512, 1024, 2048, 4096, 8192, 16K, 32K, 64K,
                  128K, 256K, 512K, 1M, 2M, 4M, 8M, 16M, 32M.

                  Note that the FAT and FAT32 files systems impose the
                  following restrictions on the number of clusters on a volume:

                  FAT: Number of clusters <= 65526
                  FAT32: 65526 < Number of clusters < 4177918

                  Format will immediately stop processing if it decides that
                  the above requirements cannot be met using the specified
                  cluster size.

                  NTFS compression is not supported for allocation unit sizes
                  above 4096.

  /F:size         Specifies the size of the floppy disk to format (1.44)
  /T:tracks       Specifies the number of tracks per disk side.
  /N:sectors      Specifies the number of sectors per track.
  /P:count        Zero every sector on the volume.  After that, the volume
                  will be overwritten "count" times using a different
                  random number each time.  If "count" is zero, no additional
                  overwrites are made after zeroing every sector.  This switch
                  is ignored when /Q is specified.
  /S:state        Specifies support for short filenames (enable, disable)
                  Short names are disabled by default
  /TXF:state      Specifies txf is enabled/disabled (enabled, disabled)
                  TxF is enabled by default
  /I:state        ReFS only: Specifies whether integrity should be enabled on
                  the new volume. "state" is either "enable" or "disable"
                  Integrity is enabled on storage that supports data redundancy
                  by default.
  /DAX[:state]    NTFS Only: Enable direct access storage (DAX) mode for this
                  volume.  In DAX mode, the volume is accessed via the memory
                  bus, boosting IO performance.  A volume can be formatted
                  with DAX mode only if the hardware is DAX capable.
                  State can specify "enable" or "disable".  /DAX is considered
                  as /DAX:enable.
  /LogSize[:size] NTFS Only: Specifies the size for NTFS log file in kilobytes.
                  The minimum supported size is 2MB, so specifying size smaller
                  than 2MB will result in a 2MB log file.  Zero indicates the
                  default value which generally depend on the volume size.
  /NoRepairLogs   NTFS Only: Disables NTFS repair logs.  If the flag is set
                  spotfix (i.e. chkdsk /spotfix) will not work.
