@'
About:  Write PrettyPrinted/Indented XML doc to a string

Docs/references

- using [Files and Streaming I/O](https://docs.microsoft.com/en-us/dotnet/standard/io/)
- [Handling Filel I/O Errors](https://docs.microsoft.com/en-us/dotnet/standard/io/handling-io-errors)

- Interface [IFormatProvider](https://docs.microsoft.com/en-us/dotnet/api/system.iformatprovider?view=net-6.0)
- [Define Custom Format Providers](https://docs.microsoft.com/en-us/dotnet/standard/base-types/how-to-define-and-use-custom-numeric-format-providers)

> Starting with the .NET Framework 2.0, we recommend that you create [XmlWriter] instances by using the XmlWriter.Create method and the XmlWriterSettings class to take advantage of new functionality.

'@ | Show-Markdown

function runUpdatedExample {
    '... code here ... '
}

function runOriginalExample {
    <#
    .notes
        $strWriter.Encoding defaults to utf16-le
        This version is almost verbatim from somewhere in the docs
    #>
    [cmdletbinding()]
    [OutputType([IO.StringWriter])]
    param(
        # an XML Doc instance
        [Parameter()]
        [Xml.XmlDocument]$XmlDoc
    )
    # [xml]$xmlDoc = $randomXml
    @(
        $strWriter ??= [IO.StringWriter]::new()
        $xmlWriter ??= [XML.XmlTextWriter]::new( $strWriter )

        # [Xml.XmlTextWriter] | fm -MemberType Constructor

        # $strWriter; hr; $xmlWriter ; hr;
        $xmlWriter.Formatting = [Xml.Formatting]::Indented

        $xmlDoc.WriteTo( $xmlWriter )
        $xmlWriter.Flush()
        $strWriter.Flush()
    ) | Write-Information # or debug/verbose
    @(
        # h1 'results'
        # $strWriter.ToString()
    ) | Write-Information

    $finalText = $strWriter.ToString()
    $xmlWriter.close()
    $xmlWriter.dispose()

    # redundant, but used for the demo
    # [IO.StringWriter] implements IDisposable, but has no reseources to dispose
    # it is redundant h
    $strWriter.close()
    if ( !($null -eq $strWriter)) {
        $stWriter.dispose()
    }
    return $finalText

}
# [xml]$randomXml = Get-Content (Get-Item -ea stop $PSScriptRoot 'data/bookstore.xml')

# [xml]$xmlDoc = [xml]$randomXml

$content = Get-Content (Get-Item -ea stop (Join-Path $PSScriptRoot 'data/bookstore.xml'))
[xml]$xmldoc = [xml]$content


$splatExample = @{
    Infa    = 'Continue'
    verbose = $True
    Debug   = $false
    XmlDoc  = $XmlDoc
}
# $resultUodated = runUpdatedExample @splatInfo
$resultOriginal = runOriginalExample @splatInfo

# hr -fg magenta
# $result.gettype()
