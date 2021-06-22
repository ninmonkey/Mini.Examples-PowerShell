function PromptAdmin {
    @(
        New-Text 'admin'  -bg 'red'
        "`n`u{1f412}> " # 🐒
    ) -join ''
}

function PromptNin {
    <#
    .notes
        see old prompt: './old - promptNin.ps1'
    #>

    <#
        Config: Spartan
        output:
            🐒>
    #>

    if (Test-UserIsAdmin) {
        PromptAdmin;
        return;
    }
    $user_name = "`n`u{1f412}> " # 🐒
    $user_name
}
