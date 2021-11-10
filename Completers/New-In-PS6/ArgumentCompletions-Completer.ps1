#Requires -Version 6

function Invoke-Manpage {
    # parameters will auto complete, however unlike validateset, you can input anything
    param(
        [ArgumentCompletions('ls', 'git', 'gh')]
        [string]$CommandName
    )
    "invoking: $CommandName --help | less "
}

Invoke-Manpage ls
Invoke-Manpage bat

# invoking: ls --help | less
# invoking: bat --help | less