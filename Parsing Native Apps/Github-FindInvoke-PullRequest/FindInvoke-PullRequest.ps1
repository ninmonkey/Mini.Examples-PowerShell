<#
see post:
    https://github.blog/2021-03-11-scripting-with-github-cli/#combine-gh-with-other-tools


His bash command was:
    $ gh alias set co --shell 'id="$(gh pr list -L100 | fzf | cut -f1)"; [ -n "$id" ] && gh pr checkout "$id"'
    $ gh co
ie:
    > id="$(gh pr list -L100 | fzf | cut -f1)"
    > [ -n "$id" ] && gh pr checkout "$id"

#>

function FindInvoke-PullRequest {
    <#
    .synopsis
        Lists PR, filters using Fzf, then 'gh pr checkout' that PR
    .description
        - I was not sure which verb to use, since it finds *and* invokes
        - for a version without depenencies, see below: "FindInvoke-PullRequest-NoDependency"
    .notes
        future:
            - use 'gh' json output, instead of parsing text, like:
                PS> gh pr list --json 'id,number,labels,author,title,url,updatedAt,closed'

            - use 'Fzf's dynamic preview mode, as you move up/down it will
                call 'gh pr view 15171' in the background
                showing descriptions **before** you hit enter inside "fzf"
    .example
        PS> FindInvoke-PullRequest

        # you select PR 15171 here

        Confirm
        Are you sure you want to perform this action?
        Performing the operation "gh pr checkout" on target "15171 Remove alias D of -Directory switch kvprasoon:remove-ls-alias OPEN".
        [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        # limit
        [Parameter(position = 0)]
        [Alias('L')]
        [uint]$Limit = 100
    )

    $pr_id = Invoke-NativeCommand 'gh' -ArgumentList @(
        'pr'
        'list'
        "-L$Limit"
    ) | Out-Fzf -MultiSelect:$false
    | ForEach-Object { $_ -split '\D+' | Select-Object -First 1 }

    $string_pr_description = $fzf
    $string_command_description = "gh pr checkout <id:$pr_id>"

    if ($PSCmdlet.ShouldProcess($string_pr_description, $string_command_description)) {
        Invoke-NativeCommand 'gh' -ArgumentList @(
            'pr'
            'checkout'
            $pr_id
        )
    }
}

function FindInvoke-PullRequest-NoDependency {
    <#
    .synopsis
        Like 'FindInvoke-PullRequest' without requiring module 'Ninmonkey.Console'
        ie: Less error handling
    .example
        PS> FindInvoke-PullRequest-NoDependency
        # you select PR 15171 here

        Confirm
        Are you sure you want to perform this action?
        Performing the operation "gh pr checkout" on target "15171 Remove alias D of -Directory switch kvprasoon:remove-ls-alias OPEN".
        [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param()

    $fzf = gh pr list -L10 | fzf
    $pr_id = $fzf -split '\D+' | Select-Object -First 1

    if ($PSCmdlet.ShouldProcess("`nPR: $fzf", "gh pr checkout <$pr_id>")) {
        $ghArgs = @('pr', 'checkout', $pr_id)
        $ghBin = Get-Command -CommandType Application 'gh' -ea Stop | Select-Object -First 1
        & $ghBin @ghArgs
    }
}
