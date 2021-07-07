$list = @(
    40
    'a'
    'aa'
    $null
    , $null
    ''
    '  '
)
$ErrorActionPreference = 'break'
[object[]]$Results = $list | ForEach-Object {
    $itemInfo = [ordered]@{}
    $x = $_

    $itemInfo['Input'] = $x
    $value = switch ($x) {

        40 { '40' ; break; }

        $null { 'null' ; break; }

        # testing for null first, prevents  null-access errors
        { $_.StartsWith('a') } {
            'start'; break;
        }

        'a' { 'a' ; break; }
        {
            [string]::IsNullOrWhiteSpace($_)
        } {
            'NullOrWhiteSpace'
            break
        }

        default { 'other' ; break; }
    }

    $x ??= '[Null]'
    $itemInfo['Value'] = $value
    $itemInfo['True null?'] = $null -eq $x
    [pscustomobject]$itemInfo
    # $Results
}

$Results
