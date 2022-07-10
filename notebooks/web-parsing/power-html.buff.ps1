Import-Module PowerHTML
# $q = PowerHTML\ConvertFrom-Html -URI 'https://powerbi.microsoft.com/en-us/blog/'
# find all links on the page
# $q.SelectNodes('//a')
# filter by name
# $q.SelectNodes('//a') | Where-Object InnerText -Match 'jan'
$Url = @{
    TextEncoding                  = 'https://docs.microsoft.com/en-us/dotnet/api/system.text.encoding?view=net-6.0'
    PwshExperimentalFeaturesTable = 'https://docs.microsoft.com/en-us/powershell/scripting/learn/experimental-features?view=powershell-7.3'
}
@'
todo:

    - [ ] update type `[HtmlAgilityPack.HtmlNode]` to have a max lengths
        for `.OuterHtml` and probably `.InnerHtml`, `OuterText, and  `InnerText`
    - [ ] pipe to FZF with XPATH
        that XPATH renders the actual sub-document that

see:
    - [HtmlAgility docs TOC](https://html-agility-pack.net/documentation)
        - [HtmlAttribute](https://html-agility-pack.net/attributes)
    - [XML.XPath.XPathExpression](https://docs.microsoft.com/en-us/dotnet/api/system.xml.xpath.xpathexpression?view=net-6.0)
    - [XML Types to avoid \(and use\)](https://docs.microsoft.com/en-us/dotnet/standard/design-guidelines/system-xml-usage)
    - [MDN: ARIA Roles Listing](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles)
    - docs: [Namespace System.XML](https://docs.microsoft.com/en-us/dotnet/api/system.xml?view=net-6.0)
        - [ARIA Attributes and Properties](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes)
'@
$Url.Source = $Url.PwshExperimentalFeaturesTable

$Q = $Query = @{} # Save query results for comparison
$Doc ??= PowerHTML\ConvertFrom-Html -URI $Url.Source
$rawDoc ??= PowerHTML\ConvertFrom-Html -URI $Url.Source -Raw

H1 '$doc'
$doc | iot2

H1 '$rawDoc'
$rawDoc | iot2
Hr
$rawDoc.GetType().FullName | Label '$RawDoc is a'
$Doc.GetType().FullName | Label '$Doc is a'
H1 '$Doc queries'
$Doc | Fm *select*


H1 'Find every "id" attribute on "div" elements'
$q.Div_IdList = $doc.SelectNodes('//div').attributes | Where-Object Name -EQ 'id'

$q.Div_IdList | Select-Object -First 2 | Format-List
Hr
$q.Div_IdList.value | Sort-Object | UL | Label 'all IDs set on Div elements'
$q.Tables = $doc.SelectNodes('//table')


function _exportNodeAsHtml {
    param( $Source,
        [switch]$AutoOpen
    )
    # $innerHtml = $q.Tables[0].InnerHtml | Select-Object -First 5
    # $rawHtml = $q.Tables[0].InnerHtml
    $Html = $Source

    $RenderedHtml = @'
<html><body>
<div id="main-content">
{0}
</div>
</body></html>
'@ -f @(
        $Html
    )

    $RenderedHtml | Sc -Path 'temp:\export-outer.html'
    $dest = Get-Item 'temp:\export-outer.html'
    Label 'Wrote' $Dest.FullName #| Write-Information

    # Get-Item $dest | GoCode
}


$innerHtml = $q.Tables[0].InnerHtml | Select-Object -First 5
$rawHtml = $q.Tables[0].InnerHtml
$SomeTarget = $q.Tables[0]
_exportNodeAsHtml $SomeTarget.OuterHtml

function _fmtTable_HAP_htmlAttribute {
    # Summarize a [HHtmlAgilityPack.HtmlAttribute]
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]$InputObject
    )
    begin {
        $Items = [list[object]]::new()
    }
    process {
        foreach ($obj in $InputObject) {
            $Items.Add( $obj )
        }
    }
    end {
        if (@($items)[0] -isnot 'HtmlAgilityPack.HtmlAttribute') {
            Write-Debug "UnexpectedTypeWarning: $($InputObject.GetType())"
        }
        $items
        | Sort-Object Value
        | Format-Table Value, DeEntitizeValue, XPath
    }
}
function _fmtTable_HAP_htmlNode {
    # Summarize a [HHtmlAgilityPack.HtmlAttribute]
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]$InputObject
    )
    begin {
        $Items = [list[object]]::new()
    }
    process {
        foreach ($obj in $InputObject) {
            $Items.Add( $obj )
        }
    }
    end {
        if (@($items)[0] -isnot 'HtmlAgilityPack.HtmlNode') {
            Write-Debug "UnexpectedTypeWarning: $($InputObject.GetType())"
        }
        $PropsForAttribute = 'Name', 'Attributes', 'ClosingAttributes', 'EndNode', 'HasAttributes', 'HasChildNodes', 'XPath', 'InnerText', 'InnherHtml'
        $items
        | Sort-Object Name
        | Select-Object $PropsForAttribute
        | Format-Table
    }
}
H1 'different defaults: htmlAttribute'
$q.Div_IdList | _fmtTable_HAP_htmlAttribute
H1 'htmlNode'
$q.Tables[0] | _fmtTable_HAP_htmlNode

# Import-Module PowerHTML
# $q = PowerHTML\ConvertFrom-Html -URI 'https://powerbi.microsoft.com/en-us/blog/'
_exportNodeAsHtml $SomeTarget.OuterHtml
$q.tables | s -ExcludeProperty inner*, outer*

$q.tables[0] | s -ExcludeProperty inner*, outer* | s -First 1

$Target = $q.Tables[0]
$render1 = @'
[{5} ] name: {0}
childrenTypesOf: {6}
HasChild = {1} HasAttrib = {2} HasClosingAttr = {3}
overflow: {4}

{5}

{6}

'@ -f @(
    # 0
    $Target.Name ?? 'missing'

    # 1,2,3
    $target.HasChildNodes ?? 'missing'
    $target.HasAttributes ?? 'missing'
    $target.HasClosingAttributes ?? 'missing'

    # 4
    $Target.NodeType ?? 'missing'
    #5

    $Target.ChildNodes | ForEach-Object pstypenames | ForEach-Object { $_ -as 'type' }
    | shortType | Sort-Object -Unique
    | Join-String -Separator ' ' -op "${fg:green}PSTypenames ${fg:reset}"

    #6
    $Target.ChildNodes
    | Join-String { $_.NodeType, $_.Name -join '=' } -sep ',  ' -op 'childNodes = @(' -os ')'
    | Join-String -op "${fg:orange}ChildNodes = " -os "${fg:clear}"
    | Join-String -op "${fg:green}ChildNodes> " -os "${fg:clear}"
    #old:
    # $Target.ChildNodes | Join-String { $_.NodeType, $_.Name -join '=' } -sep ',  ' -op 'childNodes = @(' -os ')'
    # | Join-String -op "${fg:gray80}ChildNodes = " -os "${fg:clear}"
)

$render1



'open live preview of (_exportNodeAsHtml)''s path' | Label 'Tip' -fg green
| Write-Warning

$noop = $Null
# # find all links on the page
# $q.SelectNodes("//a")

# # filter by name
# $q.SelectNodes("//a") | ? InnerText -match 'jan'

# # https://docs.microsoft.com/en-us/dotnet/api/system.text.encoding?view=net-6.0


