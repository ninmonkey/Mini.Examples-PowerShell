Replaces files.

REPLACE [drive1:][path1]filename [drive2:][path2] [/A] [/P] [/R] [/W]
REPLACE [drive1:][path1]filename [drive2:][path2] [/P] [/R] [/S] [/W] [/U]

  [drive1:][path1]filename Specifies the source file or files.
  [drive2:][path2]         Specifies the directory where files are to be
                           replaced.
  /A                       Adds new files to destination directory. Cannot
                           use with /S or /U switches.
  /P                       Prompts for confirmation before replacing a file or
                           adding a source file.
  /R                       Replaces read-only files as well as unprotected
                           files.
  /S                       Replaces files in all subdirectories of the
                           destination directory. Cannot use with the /A
                           switch.
  /W                       Waits for you to insert a disk before beginning.
  /U                       Replaces (updates) only files that are older than
                           source files. Cannot use with the /A switch.
