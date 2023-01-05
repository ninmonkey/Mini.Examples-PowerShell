
function _method1 {
    'press X to do something'
    if($host.UI.RawUI.ReadKey([System.Management.Automation.Host.ReadKeyOptions]'NoEcho, IncludeKeyDown').Character -eq 'X') {
        'doing something'
    }
}

function _method2 {
    [System.Console]::ReadKey($true).Key
}