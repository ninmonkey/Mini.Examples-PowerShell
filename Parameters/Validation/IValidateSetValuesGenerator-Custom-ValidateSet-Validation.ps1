

Class ValidFiletype : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        $listing = Get-FileType -Path (Get-Item .) -Depth 2 -ea ignore
        # You can see the value is recalculate on-use,
        $Listing | Join-String -sep ', ' -op ("recalc: $($listing.count)") | Write-Debug
        return [String[]] $listing
    }
}
 
function FindSomeFiletype {
    # Find filetypes, and validate from initial results
    param(
        # which filetype[s] ?
        [Alias('Extension')]
        [ValidateSet([ValidFiletype])]
        [Parameter(Mandatory, Position = 0)]
        [string[]]$Filetype
    )
}

FindSomeFiletype '.ps1', '.log', '.DoesNotExist' -ea continue
Push-Location -Path 'temp:\'
Get-FileType temp:\
