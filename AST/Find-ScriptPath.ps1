function Find-FunctionSourceCode {
    <#
    .synopsis
        Find the location and line number of a function, then open it
    .example
        Find-FunctionSourceCode PromptNin -PassThru
    .example
        Find-FunctionSourceCode PromptNin -AlwaysOpen

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param (
        # function name
        [Parameter(Mandatory, Position = 0)]
        [string]$FunctionName,

        # Return results, do nothing else.
        [Parameter()]
        [switch]$PassThru,

        # Auto-Open in code?
        [Parameter()]
        [switch]$AlwaysOpen
    )

    begin {
        try {
            $src = Get-Item -ea stop function:\$FunctionName
        }
        catch [System.Management.Automation.CommandNotFoundException] {
            Write-Error "'$FunctionName' not found. Is it a function?"
        }
        # $LineNum =
        # $LineNumEnd =
        # $FileName =
        $meta = [pscustomobject]@{
            'LineNumber'        = $src.ScriptBlock.Ast.Extent.StartLineNumber
            'LineNumberEnd'     = $src.ScriptBlock.Ast.Extent.EndLineNumber
            'CharNumber'        = $src.ScriptBlock.Ast.Extent.StartColumnNumber
            'CharNumberEnd'     = $src.ScriptBlock.Ast.Extent.EndColumnNumber
            'StartOffset'       = $src.ScriptBlock.Ast.Extent.StartOffset
            'EndOffset'         = $src.ScriptBlock.Ast.Extent.EndOffset
            'Path'              = $src.ScriptBlock.Ast.Extent.File | Get-Item -ea continue
            'AstObject'         = $src.ScriptBlock.Ast
            'ScriptBlockObject' = $src.ScriptBlock
        }

        if ($PassThru) {
            $meta
            return
        }
        if ($AlwaysOpen) {
            # template_goal: 'goto <file:line[:character]>'
            # $template_with_line = '{0}:{1}'
            $template_with_char = '{0}:{1}:{2}'

            $goto_location_string = $template_with_char -f @(
                $meta.Path.FullName # actually, do not qoute arg. | Join-String -SingleQuote
                $meta.LineNumber
                $meta.CharNumber
            )

            $final_arg_array = @(
                '--goto'
                $goto_location_string
            )

            & code @final_arg_array
            # & code '--goto {0}' -f $goto_arg

        }





    }

    process {

    }

    end {

    }
}
