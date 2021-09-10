function urlFromTemplate {
    # Helper function to generate urls from templates
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$owner,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$repo
    )
    'repos/{0}/{1}/releases' -f @(
        $owner
        $repo
    )
}

$url = urlFromTemplate 'powershell' 'vscode-powershell'
$ghArgList = @(
    'api'
    $url
)

& gh @ghArgList
$ghArgList | Join-String -sep ' ' -op 'invoke: gh ' | New-Text -fg yellow | ForEach-Object tostring
