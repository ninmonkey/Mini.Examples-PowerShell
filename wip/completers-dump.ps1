
```ps1
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

<#
.description
    add autocompletion to the command `dotnet`
.notes
see:
    - [Docs: Register-AutoCompleter](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/register-argumentcompleter?view=powershell-7)
    - [docs: Automation.CompletionResult ](https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.completionresult?view=powershellsdk-7.0.0)

#>
# function Add-NativeAutoCompleterDotnet {

# $temp_old_Debug = $DebugPreference
function New-CompletionResult {
    <#
    .synopsis
        Create a [System.Management.Automation.CompletionResult]
    .notes
    todo:
        - refactor inline constants'
    .example
        PS> New-CompletionResult '--info' 'info' ParameterName 'List installed .net runtimes'

        CompletionText : --info
        ListItemText   : info
        ResultType     : ParameterName
        ToolTip        : List installed .net runtime
    #>
    param(
        # Completion Result returned
        [Parameter(Mandatory, Position = 0)]
        [string]$CompletionText,

        # Text displayed in the popup, usually equal to -CompletionText without a "--" prefix.
        [Parameter(Mandatory, Position = 1)]
        [string]$ListItemText,

        # enum: [System.Management.Automation.CompletionResultType]
        [Parameter(Mandatory, Position = 2)]
        [CompletionResultType]$ResultType,

        # Verbose description shown when a single command is selected
        [Parameter(Mandatory, Position = 3)]
        [string]$Tooltip
    )

    "New [CompletionResult]: $CompletionText, $ListItemText, $ResultType, $Tooltip" | Write-Debug

    [CompletionResult]::new( $CompletionText, $ListItemText, $ResultType, $Tooltip)
    return
}

# $_privateExeName = 'dotnet'
Register-ArgumentCompleter -Native -CommandName 'dotnet' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'dotnet'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-')) {
                break
            }
            $element.Value
        }) -join ';'

    $completions = @(switch ($command) {
            'dotnet' {
                # todo: refactor to import from user JSON, or [Hashtable]
                New-CompletionResult '--info' 'info' ParameterName 'Display Runtime Environment, Host, SDKs installed and runtimes installed'
                New-CompletionResult '--list-sdks' 'list-sdks' ParameterName 'List installed SDKs'
                New-CompletionResult '--list-runtimes' 'list-runtimes' ParameterName 'List installed runtimes'
                New-CompletionResult '--diagnostics' 'diagnostics' ParameterName 'Enable diagnostic output.'



                # [CompletionResult]::new('--list-sdks', 'zebra', [CompletionResultType]::ParameterName, 'Prints help information. Use --help for more details.')
                # [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information. Use --help for more details.')
                # [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                # [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
        })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
    Write-Debug 'loaded completer: dotnet.exe'
}
```


```ps1

using namespace System.Management.Automation
using namespace System.Management.Automation.Language

<#
.description
    add autocompletion to the command `dotnet`
.notes
see:
    - [Docs: Register-AutoCompleter](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/register-argumentcompleter?view=powershell-7)
    - [docs: Automation.CompletionResult ](https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.completionresult?view=powershellsdk-7.0.0)

#>
# function Add-NativeAutoCompleterDotnet {
'todo: refactor inline constants'
# $_privateExeName = 'dotnet'
Register-ArgumentCompleter -Native -CommandName 'dotnet' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'dotnet'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-')) {
                break
            }
            $element.Value
        }) -join ';'

    $completions = @(switch ($command) {
            'dotnet' {
                [CompletionResult]::new('-A', 'A', [CompletionResultType]::ParameterName, 'Show NUM lines after each match.')
                [CompletionResult]::new('--after-context', 'after-context', [CompletionResultType]::ParameterName, 'Show NUM lines after each match.')
                [CompletionResult]::new('-B', 'B', [CompletionResultType]::ParameterName, 'Show NUM lines before each match.')
                [CompletionResult]::new('--before-context', 'before-context', [CompletionResultType]::ParameterName, 'Show NUM lines before each match.')
                [CompletionResult]::new('--color', 'color', [CompletionResultType]::ParameterName, 'Controls when to use color.')
                [CompletionResult]::new('--colors', 'colors', [CompletionResultType]::ParameterName, 'Configure color settings and styles.')
                [CompletionResult]::new('-C', 'C', [CompletionResultType]::ParameterName, 'Show NUM lines before and after each match.')
                [CompletionResult]::new('--context', 'context', [CompletionResultType]::ParameterName, 'Show NUM lines before and after each match.')
                [CompletionResult]::new('--context-separator', 'context-separator', [CompletionResultType]::ParameterName, 'Set the context separator string.')
                [CompletionResult]::new('--dfa-size-limit', 'dfa-size-limit', [CompletionResultType]::ParameterName, 'The upper size limit of the regex DFA.')
                [CompletionResult]::new('-E', 'E', [CompletionResultType]::ParameterName, 'Specify the text encoding of files to search.')
                [CompletionResult]::new('--encoding', 'encoding', [CompletionResultType]::ParameterName, 'Specify the text encoding of files to search.')
                [CompletionResult]::new('-f', 'f', [CompletionResultType]::ParameterName, 'Search for patterns from the given file.')
                [CompletionResult]::new('--file', 'file', [CompletionResultType]::ParameterName, 'Search for patterns from the given file.')
                [CompletionResult]::new('-g', 'g', [CompletionResultType]::ParameterName, 'Include or exclude files.')
                [CompletionResult]::new('--glob', 'glob', [CompletionResultType]::ParameterName, 'Include or exclude files.')
                [CompletionResult]::new('--iglob', 'iglob', [CompletionResultType]::ParameterName, 'Include or exclude files case insensitively.')
                [CompletionResult]::new('--ignore-file', 'ignore-file', [CompletionResultType]::ParameterName, 'Specify additional ignore files.')
                [CompletionResult]::new('-M', 'M', [CompletionResultType]::ParameterName, 'Don''t print lines longer than this limit.')
                [CompletionResult]::new('--max-columns', 'max-columns', [CompletionResultType]::ParameterName, 'Don''t print lines longer than this limit.')
                [CompletionResult]::new('-m', 'm', [CompletionResultType]::ParameterName, 'Limit the number of matches.')
                [CompletionResult]::new('--max-count', 'max-count', [CompletionResultType]::ParameterName, 'Limit the number of matches.')
                [CompletionResult]::new('--max-depth', 'max-depth', [CompletionResultType]::ParameterName, 'Descend at most NUM directories.')
                [CompletionResult]::new('--max-filesize', 'max-filesize', [CompletionResultType]::ParameterName, 'Ignore files larger than NUM in size.')
                [CompletionResult]::new('--path-separator', 'path-separator', [CompletionResultType]::ParameterName, 'Set the path separator.')
                [CompletionResult]::new('--pre', 'pre', [CompletionResultType]::ParameterName, 'search outputs of COMMAND FILE for each FILE')
                [CompletionResult]::new('--pre-glob', 'pre-glob', [CompletionResultType]::ParameterName, 'Include or exclude files from a preprocessing command.')
                [CompletionResult]::new('--regex-size-limit', 'regex-size-limit', [CompletionResultType]::ParameterName, 'The upper size limit of the compiled regex.')
                [CompletionResult]::new('-e', 'e', [CompletionResultType]::ParameterName, 'A pattern to search for.')
                [CompletionResult]::new('--regexp', 'regexp', [CompletionResultType]::ParameterName, 'A pattern to search for.')
                [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Replace matches with the given text.')
                [CompletionResult]::new('--replace', 'replace', [CompletionResultType]::ParameterName, 'Replace matches with the given text.')
                [CompletionResult]::new('--sort', 'sort', [CompletionResultType]::ParameterName, 'Sort results in ascending order. Implies --threads=1.')
                [CompletionResult]::new('--sortr', 'sortr', [CompletionResultType]::ParameterName, 'Sort results in descending order. Implies --threads=1.')
                [CompletionResult]::new('-j', 'j', [CompletionResultType]::ParameterName, 'The approximate number of threads to use.')
                [CompletionResult]::new('--threads', 'threads', [CompletionResultType]::ParameterName, 'The approximate number of threads to use.')
                [CompletionResult]::new('-t', 't', [CompletionResultType]::ParameterName, 'Only search files matching TYPE.')
                [CompletionResult]::new('--type', 'type', [CompletionResultType]::ParameterName, 'Only search files matching TYPE.')
                [CompletionResult]::new('--type-add', 'type-add', [CompletionResultType]::ParameterName, 'Add a new glob for a file type.')
                [CompletionResult]::new('--type-clear', 'type-clear', [CompletionResultType]::ParameterName, 'Clear globs for a file type.')
                [CompletionResult]::new('-T', 'T', [CompletionResultType]::ParameterName, 'Do not search files matching TYPE.')
                [CompletionResult]::new('--type-not', 'type-not', [CompletionResultType]::ParameterName, 'Do not search files matching TYPE.')
                [CompletionResult]::new('--auto-hybrid-regex', 'auto-hybrid-regex', [CompletionResultType]::ParameterName, 'Dynamically use PCRE2 if necessary.')
                [CompletionResult]::new('--no-auto-hybrid-regex', 'no-auto-hybrid-regex', [CompletionResultType]::ParameterName, 'no-auto-hybrid-regex')
                [CompletionResult]::new('--binary', 'binary', [CompletionResultType]::ParameterName, 'Search binary files.')
                [CompletionResult]::new('--no-binary', 'no-binary', [CompletionResultType]::ParameterName, 'no-binary')
                [CompletionResult]::new('--block-buffered', 'block-buffered', [CompletionResultType]::ParameterName, 'Force block buffering.')
                [CompletionResult]::new('--no-block-buffered', 'no-block-buffered', [CompletionResultType]::ParameterName, 'no-block-buffered')
                [CompletionResult]::new('-b', 'b', [CompletionResultType]::ParameterName, 'Print the 0-based byte offset for each matching line.')
                [CompletionResult]::new('--byte-offset', 'byte-offset', [CompletionResultType]::ParameterName, 'Print the 0-based byte offset for each matching line.')
                [CompletionResult]::new('-s', 's', [CompletionResultType]::ParameterName, 'Search case sensitively (default).')
                [CompletionResult]::new('--case-sensitive', 'case-sensitive', [CompletionResultType]::ParameterName, 'Search case sensitively (default).')
                [CompletionResult]::new('--column', 'column', [CompletionResultType]::ParameterName, 'Show column numbers.')
                [CompletionResult]::new('--no-column', 'no-column', [CompletionResultType]::ParameterName, 'no-column')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Only show the count of matching lines for each file.')
                [CompletionResult]::new('--count', 'count', [CompletionResultType]::ParameterName, 'Only show the count of matching lines for each file.')
                [CompletionResult]::new('--count-matches', 'count-matches', [CompletionResultType]::ParameterName, 'Only show the count of individual matches for each file.')
                [CompletionResult]::new('--crlf', 'crlf', [CompletionResultType]::ParameterName, 'Support CRLF line terminators (useful on Windows).')
                [CompletionResult]::new('--no-crlf', 'no-crlf', [CompletionResultType]::ParameterName, 'no-crlf')
                [CompletionResult]::new('--debug', 'debug', [CompletionResultType]::ParameterName, 'Show debug messages.')
                [CompletionResult]::new('--trace', 'trace', [CompletionResultType]::ParameterName, 'trace')
                [CompletionResult]::new('--no-encoding', 'no-encoding', [CompletionResultType]::ParameterName, 'no-encoding')
                [CompletionResult]::new('--files', 'files', [CompletionResultType]::ParameterName, 'Print each file that would be searched.')
                [CompletionResult]::new('-l', 'l', [CompletionResultType]::ParameterName, 'Only print the paths with at least one match.')
                [CompletionResult]::new('--files-with-matches', 'files-with-matches', [CompletionResultType]::ParameterName, 'Only print the paths with at least one match.')
                [CompletionResult]::new('--files-without-match', 'files-without-match', [CompletionResultType]::ParameterName, 'Only print the paths that contain zero matches.')
                [CompletionResult]::new('-F', 'F', [CompletionResultType]::ParameterName, 'Treat the pattern as a literal string.')
                [CompletionResult]::new('--fixed-strings', 'fixed-strings', [CompletionResultType]::ParameterName, 'Treat the pattern as a literal string.')
                [CompletionResult]::new('--no-fixed-strings', 'no-fixed-strings', [CompletionResultType]::ParameterName, 'no-fixed-strings')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Follow symbolic links.')
                [CompletionResult]::new('--follow', 'follow', [CompletionResultType]::ParameterName, 'Follow symbolic links.')
                [CompletionResult]::new('--no-follow', 'no-follow', [CompletionResultType]::ParameterName, 'no-follow')
                [CompletionResult]::new('--glob-case-insensitive', 'glob-case-insensitive', [CompletionResultType]::ParameterName, 'Process all glob patterns case insensitively.')
                [CompletionResult]::new('--no-glob-case-insensitive', 'no-glob-case-insensitive', [CompletionResultType]::ParameterName, 'no-glob-case-insensitive')
                [CompletionResult]::new('--heading', 'heading', [CompletionResultType]::ParameterName, 'Print matches grouped by each file.')
                [CompletionResult]::new('--no-heading', 'no-heading', [CompletionResultType]::ParameterName, 'Don''t group matches by each file.')
                [CompletionResult]::new('--hidden', 'hidden', [CompletionResultType]::ParameterName, 'Search hidden files and directories.')
                [CompletionResult]::new('--no-hidden', 'no-hidden', [CompletionResultType]::ParameterName, 'no-hidden')
                [CompletionResult]::new('-i', 'i', [CompletionResultType]::ParameterName, 'Case insensitive search.')
                [CompletionResult]::new('--ignore-case', 'ignore-case', [CompletionResultType]::ParameterName, 'Case insensitive search.')
                [CompletionResult]::new('--ignore-file-case-insensitive', 'ignore-file-case-insensitive', [CompletionResultType]::ParameterName, 'Process ignore files case insensitively.')
                [CompletionResult]::new('--no-ignore-file-case-insensitive', 'no-ignore-file-case-insensitive', [CompletionResultType]::ParameterName, 'no-ignore-file-case-insensitive')
                [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterName, 'Invert matching.')
                [CompletionResult]::new('--invert-match', 'invert-match', [CompletionResultType]::ParameterName, 'Invert matching.')
                [CompletionResult]::new('--json', 'json', [CompletionResultType]::ParameterName, 'Show search results in a JSON Lines format.')
                [CompletionResult]::new('--no-json', 'no-json', [CompletionResultType]::ParameterName, 'no-json')
                [CompletionResult]::new('--line-buffered', 'line-buffered', [CompletionResultType]::ParameterName, 'Force line buffering.')
                [CompletionResult]::new('--no-line-buffered', 'no-line-buffered', [CompletionResultType]::ParameterName, 'no-line-buffered')
                [CompletionResult]::new('-n', 'n', [CompletionResultType]::ParameterName, 'Show line numbers.')
                [CompletionResult]::new('--line-number', 'line-number', [CompletionResultType]::ParameterName, 'Show line numbers.')
                [CompletionResult]::new('-N', 'N', [CompletionResultType]::ParameterName, 'Suppress line numbers.')
                [CompletionResult]::new('--no-line-number', 'no-line-number', [CompletionResultType]::ParameterName, 'Suppress line numbers.')
                [CompletionResult]::new('-x', 'x', [CompletionResultType]::ParameterName, 'Only show matches surrounded by line boundaries.')
                [CompletionResult]::new('--line-regexp', 'line-regexp', [CompletionResultType]::ParameterName, 'Only show matches surrounded by line boundaries.')
                [CompletionResult]::new('--max-columns-preview', 'max-columns-preview', [CompletionResultType]::ParameterName, 'Print a preview for lines exceeding the limit.')
                [CompletionResult]::new('--no-max-columns-preview', 'no-max-columns-preview', [CompletionResultType]::ParameterName, 'no-max-columns-preview')
                [CompletionResult]::new('--mmap', 'mmap', [CompletionResultType]::ParameterName, 'Search using memory maps when possible.')
                [CompletionResult]::new('--no-mmap', 'no-mmap', [CompletionResultType]::ParameterName, 'Never use memory maps.')
                [CompletionResult]::new('-U', 'U', [CompletionResultType]::ParameterName, 'Enable matching across multiple lines.')
                [CompletionResult]::new('--multiline', 'multiline', [CompletionResultType]::ParameterName, 'Enable matching across multiple lines.')
                [CompletionResult]::new('--no-multiline', 'no-multiline', [CompletionResultType]::ParameterName, 'no-multiline')
                [CompletionResult]::new('--multiline-dotall', 'multiline-dotall', [CompletionResultType]::ParameterName, 'Make ''.'' match new lines when multiline is enabled.')
                [CompletionResult]::new('--no-multiline-dotall', 'no-multiline-dotall', [CompletionResultType]::ParameterName, 'no-multiline-dotall')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Never read configuration files.')
                [CompletionResult]::new('--no-ignore', 'no-ignore', [CompletionResultType]::ParameterName, 'Don''t respect ignore files.')
                [CompletionResult]::new('--ignore', 'ignore', [CompletionResultType]::ParameterName, 'ignore')
                [CompletionResult]::new('--no-ignore-dot', 'no-ignore-dot', [CompletionResultType]::ParameterName, 'Don''t respect .ignore files.')
                [CompletionResult]::new('--ignore-dot', 'ignore-dot', [CompletionResultType]::ParameterName, 'ignore-dot')
                [CompletionResult]::new('--no-ignore-global', 'no-ignore-global', [CompletionResultType]::ParameterName, 'Don''t respect global ignore files.')
                [CompletionResult]::new('--ignore-global', 'ignore-global', [CompletionResultType]::ParameterName, 'ignore-global')
                [CompletionResult]::new('--no-ignore-messages', 'no-ignore-messages', [CompletionResultType]::ParameterName, 'Suppress gitignore parse error messages.')
                [CompletionResult]::new('--ignore-messages', 'ignore-messages', [CompletionResultType]::ParameterName, 'ignore-messages')
                [CompletionResult]::new('--no-ignore-parent', 'no-ignore-parent', [CompletionResultType]::ParameterName, 'Don''t respect ignore files in parent directories.')
                [CompletionResult]::new('--ignore-parent', 'ignore-parent', [CompletionResultType]::ParameterName, 'ignore-parent')
                [CompletionResult]::new('--no-ignore-vcs', 'no-ignore-vcs', [CompletionResultType]::ParameterName, 'Don''t respect VCS ignore files.')
                [CompletionResult]::new('--ignore-vcs', 'ignore-vcs', [CompletionResultType]::ParameterName, 'ignore-vcs')
                [CompletionResult]::new('--no-messages', 'no-messages', [CompletionResultType]::ParameterName, 'Suppress some error messages.')
                [CompletionResult]::new('--messages', 'messages', [CompletionResultType]::ParameterName, 'messages')
                [CompletionResult]::new('--no-pcre2-unicode', 'no-pcre2-unicode', [CompletionResultType]::ParameterName, 'Disable Unicode mode for PCRE2 matching.')
                [CompletionResult]::new('--pcre2-unicode', 'pcre2-unicode', [CompletionResultType]::ParameterName, 'pcre2-unicode')
                [CompletionResult]::new('-0', '0', [CompletionResultType]::ParameterName, 'Print a NUL byte after file paths.')
                [CompletionResult]::new('--null', 'null', [CompletionResultType]::ParameterName, 'Print a NUL byte after file paths.')
                [CompletionResult]::new('--null-data', 'null-data', [CompletionResultType]::ParameterName, 'Use NUL as a line terminator instead of \n.')
                [CompletionResult]::new('--one-file-system', 'one-file-system', [CompletionResultType]::ParameterName, 'Do not descend into directories on other file systems.')
                [CompletionResult]::new('--no-one-file-system', 'no-one-file-system', [CompletionResultType]::ParameterName, 'no-one-file-system')
                [CompletionResult]::new('-o', 'o', [CompletionResultType]::ParameterName, 'Print only matches parts of a line.')
                [CompletionResult]::new('--only-matching', 'only-matching', [CompletionResultType]::ParameterName, 'Print only matches parts of a line.')
                [CompletionResult]::new('--passthru', 'passthru', [CompletionResultType]::ParameterName, 'Print both matching and non-matching lines.')
                [CompletionResult]::new('-P', 'P', [CompletionResultType]::ParameterName, 'Enable PCRE2 matching.')
                [CompletionResult]::new('--pcre2', 'pcre2', [CompletionResultType]::ParameterName, 'Enable PCRE2 matching.')
                [CompletionResult]::new('--no-pcre2', 'no-pcre2', [CompletionResultType]::ParameterName, 'no-pcre2')
                [CompletionResult]::new('--pcre2-version', 'pcre2-version', [CompletionResultType]::ParameterName, 'Print the version of PCRE2 that ripgrep uses.')
                [CompletionResult]::new('--no-pre', 'no-pre', [CompletionResultType]::ParameterName, 'no-pre')
                [CompletionResult]::new('-p', 'p', [CompletionResultType]::ParameterName, 'Alias for --color always --heading --line-number.')
                [CompletionResult]::new('--pretty', 'pretty', [CompletionResultType]::ParameterName, 'Alias for --color always --heading --line-number.')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Do not print anything to stdout.')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Do not print anything to stdout.')
                [CompletionResult]::new('-z', 'z', [CompletionResultType]::ParameterName, 'Search in compressed files.')
                [CompletionResult]::new('--search-zip', 'search-zip', [CompletionResultType]::ParameterName, 'Search in compressed files.')
                [CompletionResult]::new('--no-search-zip', 'no-search-zip', [CompletionResultType]::ParameterName, 'no-search-zip')
                [CompletionResult]::new('-S', 'S', [CompletionResultType]::ParameterName, 'Smart case search.')
                [CompletionResult]::new('--smart-case', 'smart-case', [CompletionResultType]::ParameterName, 'Smart case search.')
                [CompletionResult]::new('--sort-files', 'sort-files', [CompletionResultType]::ParameterName, 'DEPRECATED')
                [CompletionResult]::new('--no-sort-files', 'no-sort-files', [CompletionResultType]::ParameterName, 'no-sort-files')
                [CompletionResult]::new('--stats', 'stats', [CompletionResultType]::ParameterName, 'Print statistics about this ripgrep search.')
                [CompletionResult]::new('--no-stats', 'no-stats', [CompletionResultType]::ParameterName, 'no-stats')
                [CompletionResult]::new('-a', 'a', [CompletionResultType]::ParameterName, 'Search binary files as if they were text.')
                [CompletionResult]::new('--text', 'text', [CompletionResultType]::ParameterName, 'Search binary files as if they were text.')
                [CompletionResult]::new('--no-text', 'no-text', [CompletionResultType]::ParameterName, 'no-text')
                [CompletionResult]::new('--trim', 'trim', [CompletionResultType]::ParameterName, 'Trim prefixed whitespace from matches.')
                [CompletionResult]::new('--no-trim', 'no-trim', [CompletionResultType]::ParameterName, 'no-trim')
                [CompletionResult]::new('--type-list', 'type-list', [CompletionResultType]::ParameterName, 'Show all supported file types.')
                [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterName, 'Reduce the level of "smart" searching.')
                [CompletionResult]::new('--unrestricted', 'unrestricted', [CompletionResultType]::ParameterName, 'Reduce the level of "smart" searching.')
                [CompletionResult]::new('--vimgrep', 'vimgrep', [CompletionResultType]::ParameterName, 'Show results in vim compatible format.')
                [CompletionResult]::new('-H', 'H', [CompletionResultType]::ParameterName, 'Print the file path with the matched lines.')
                [CompletionResult]::new('--with-filename', 'with-filename', [CompletionResultType]::ParameterName, 'Print the file path with the matched lines.')
                [CompletionResult]::new('-I', 'I', [CompletionResultType]::ParameterName, 'Never print the file path with the matched lines.')
                [CompletionResult]::new('--no-filename', 'no-filename', [CompletionResultType]::ParameterName, 'Never print the file path with the matched lines.')
                [CompletionResult]::new('-w', 'w', [CompletionResultType]::ParameterName, 'Only show matches surrounded by word boundaries.')
                [CompletionResult]::new('--word-regexp', 'word-regexp', [CompletionResultType]::ParameterName, 'Only show matches surrounded by word boundaries.')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information. Use --help for more details.')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information. Use --help for more details.')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
                break
            }
        })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
```


$docs_md = @'
see:

    [Docs example: Native completer](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/register-argumentcompleter?view=powershell-7#example-1--register-a-custom-argument-completer)'

# Constructor:

```ps1
[CompletionResult]::new(String, String, CompletionResultType, String)
    Name,
    ResultValue
    CompleteType: [enum]
    Tooltip
```

Enum [CompletionResultType]:
    https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.completionresulttype?view=powershellsdk-7.0.0

[completion type](https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.completionresulttype?view=powershellsdk-7.0.0)

```ps1
'@
# $docs_md | Show-Markdown

$scriptblock = {
    $VerbosePreference = $true
    param($wordToComplete, $commandAst, $cursorPosition)
    dotnet complete --position $cursorPosition $commandAst.ToString() | ForEach-Object {
        <#

        #>
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        # "Created: $($_) as 'ParameterValue'" | Write-Debug

    }
}
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock $scriptblock
```