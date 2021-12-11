Compares two files or sets of files and displays the differences between
them


FC [/A] [/C] [/L] [/LBn] [/N] [/OFF[LINE]] [/T] [/U] [/W] [/nnnn]
   [drive1:][path1]filename1 [drive2:][path2]filename2
FC /B [drive1:][path1]filename1 [drive2:][path2]filename2

  /A         Displays only first and last lines for each set of differences.
  /B         Performs a binary comparison.
  /C         Disregards the case of letters.
  /L         Compares files as ASCII text.
  /LBn       Sets the maximum consecutive mismatches to the specified
             number of lines.
  /N         Displays the line numbers on an ASCII comparison.
  /OFF[LINE] Do not skip files with offline attribute set.
  /T         Does not expand tabs to spaces.
  /U         Compare files as UNICODE text files.
  /W         Compresses white space (tabs and spaces) for comparison.
  /nnnn      Specifies the number of consecutive lines that must match
             after a mismatch.
  [drive1:][path1]filename1
             Specifies the first file or set of files to compare.
  [drive2:][path2]filename2
             Specifies the second file or set of files to compare.

