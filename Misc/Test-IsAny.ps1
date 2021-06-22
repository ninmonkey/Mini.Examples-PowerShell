function Test-IsAny {

}

$tests = @(
    Test-IsDirectory = $_
    $_.Length -eq 1
    $_.Extension = 'json'
)
