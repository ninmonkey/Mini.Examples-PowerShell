#requires -Modules @{ ModuleName = 'PipeScript'; ModuleVersion = '0.2.0' }

Import-Module PIpeScript -PassThru
write-warning 'future: 
    - [ ] Implicitly cache blocks, if modifed is -gt last execute
    - [ ] save/link line number in header (for file urls)
'

h1 'line <file:///./YAML.Template.psx.ps1>'

[ValidateNotNull()][hashtable]$cache ??= @{}

# for speed, I have sequences cached
($cache.t01 ??= {
    $numbers = 1..30
    all $numbers where { $_ % 2  }
} | .> | Join-String -sep  ', ' )

# ($cache.t02 ??= 
{
    $numbers = 1..30
    all $numbers where { $_ % 2  }
} | .> 
# | Join-String -sep  ', ' )


h1 'Section: Runes'

label 't' '03'
($cache.t03 ??=  . {
    $runes = 'ba🦇'.EnumerateRunes()
    all $runes where { $_.IsAscii } are basicAscii
    all $runes where { $_.Value -gt 0xff } are big
 }.Transpile() | ft
 | Join-String -sep  ', ' )

 hr
 label 't' '04'
 ($cache.t04 ??=  . { $runes } 
 | Join-String -sep  ', ' )

 hr
label 't' '05'
 ($cache.t05 ??=  . {
    all -not big $runes }.Transpile() | ft
    | Join-String -sep  ', ' )

 hr

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )

# ($cache.t02 ??= 
# {
# } | .>
# | Join-String -sep  ', ' )