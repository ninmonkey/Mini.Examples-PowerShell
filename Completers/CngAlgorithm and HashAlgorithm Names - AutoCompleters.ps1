# works on 7, untested on 5
function EnumerateKinds {
    <#
    .SYNOPSIS
        sugar for enumerating names from Crypto-Enums-Almost-but-not-quite
    #>
    [OutputType('System.String')]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('CngAlgorithm', 'HashAlgorithm', 'Text')]
        [string]$NameKind
    )
    switch ($NameKind) {
        'CngAlgorithm' {
            return [Security.Cryptography.CngAlgorithm]
            | Get-Member -Static -MemberType Properties
            | ForEach-Object Name | Sort-Object -Unique
        }
        'HashAlgorithm' {
            return [Security.Cryptography.HashAlgorithmName]
            | Get-Member -Static -MemberType Properties
            | ForEach-Object Name | Sort-Object -Unique
        }
        'Text' {
            # Get-StringHash -inputText 'sdfds' -HashAlgorithm
            return [Text.Encoding]
            | Get-Member -Static -MemberType Properties
            | ForEach-Object Name | Sort-Object -Unique
        }
        'TextAll' {
            return [Text.Encoding]::GetEncodings().Name | Sort-Object -Unique
        }
        default { throw "UnhandledKind: $NameKind" }
    }
    # or the same with FM
    # [Security.Cryptography.CngAlgorithm] | ClassExplorer\Find-Member -ReturnType [System.Security.Cryptography.CngAlgorithm] -MemberType Property | ForEach-Object Name | Sort-Object
}

function Get-StringHash {
    <#
    .SYNOPSIS
        some function to demonstrate completion of sort-of-enum but not [enum] [CngAlgorithm]
    #>
    [Cmdletbinding()]
    param(
        # Input text to encode
        [Alias('Text')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$InputText,

        # Which hash algorithm
        [Parameter(Mandatory)]
        [ArgumentCompleter({
                param( $commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters )
                EnumerateKinds -NameKind HashAlgorithm
            })]
        [System.Security.Cryptography.HashAlgorithmName]
        $HashAlgorithm,

        # Text encoding, if not utf8
        [Parameter()]
        [ArgumentCompletions('utf-8', 'Unicode', 'utf-16le', 'ascii')]
        [string]$Encoding = 'utf-8'

    )

    process {
        $encoder = [Text.Encoding]::GetEncoding( $Encoding )
        $bytes = $encoder.GetBytes( $InputText )

        $hasher = [System.Security.Cryptography.HashAlgorithm]::Create( $HashAlgorithm )
        $hashed = $hasher.ComputeHash( $bytes )

        return [convert]::ToHexString($hashed)

        # there's a few ways to display bytes as hex
        # Older Powershell versions might only have the last version
        $hexStr = [convert]::ToHexString($hashed) # output ex: 6D6F6E6B
        $hexStr = $hashed | Join-String -FormatString '{0:X}' # output ex: 6D6F6E6B
        $hexStr = $hashed | Join-String -FormatString '{0:x}' -sep ' '  # or breathe a bit
        # older versions can use this instead:
        $hexStr = [System.BitConverter]::ToString($hashed) -replace '-' # output ex: 6D6F6E6B
        return $hexStr

    }
}

Get-StringHash -InputText 'adsfsd' -HashAlgorithm SHA256 -Encoding utf-8



