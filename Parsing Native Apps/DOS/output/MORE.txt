Displays output one screen at a time.

MORE [/E [/C] [/P] [/S] [/Tn] [+n]] < [drive:][path]filename
command-name | MORE [/E [/C] [/P] [/S] [/Tn] [+n]]
MORE /E [/C] [/P] [/S] [/Tn] [+n] [files]

    [drive:][path]filename  Specifies a file to display one
                            screen at a time.

    command-name            Specifies a command whose output
                            will be displayed.

    /E      Enable extended features
    /C      Clear screen before displaying page
    /P      Expand FormFeed characters
    /S      Squeeze multiple blank lines into a single line
    /Tn     Expand tabs to n spaces (default 8)

            Switches can be present in the MORE environment
            variable.

    +n      Start displaying the first file at line n

    files   List of files to be displayed. Files in the list
            are separated by blanks.

    If extended features are enabled, the following commands
    are accepted at the -- More -- prompt:

    P n     Display next n lines
    S n     Skip next n lines
    F       Display next file
    Q       Quit
    =       Show line number
    ?       Show help line
    <space> Display next page
    <ret>   Display next line
