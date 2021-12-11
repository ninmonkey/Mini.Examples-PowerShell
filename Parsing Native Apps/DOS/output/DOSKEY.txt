Edits command lines, recalls Windows commands, and creates macros.

DOSKEY [/REINSTALL] [/LISTSIZE=size] [/MACROS[:ALL | :exename]]
  [/HISTORY] [/INSERT | /OVERSTRIKE] [/EXENAME=exename] [/MACROFILE=filename]
  [macroname=[text]]

  /REINSTALL          Installs a new copy of Doskey.
  /LISTSIZE=size      Sets size of command history buffer.
  /MACROS             Displays all Doskey macros.
  /MACROS:ALL         Displays all Doskey macros for all executables which have
                      Doskey macros.
  /MACROS:exename     Displays all Doskey macros for the given executable.
  /HISTORY            Displays all commands stored in memory.
  /INSERT             Specifies that new text you type is inserted in old text.
  /OVERSTRIKE         Specifies that new text overwrites old text.
  /EXENAME=exename    Specifies the executable.
  /MACROFILE=filename Specifies a file of macros to install.
  macroname           Specifies a name for a macro you create.
  text                Specifies commands you want to record.

UP and DOWN ARROWS recall commands; ESC clears command line; F7 displays
command history; ALT+F7 clears command history; F8 searches command
history; F9 selects a command by number; ALT+F10 clears macro definitions.

The following are some special codes in Doskey macro definitions:
$T     Command separator.  Allows multiple commands in a macro.
$1-$9  Batch parameters.  Equivalent to %1-%9 in batch programs.
$*     Symbol replaced by everything following macro name on command line.
