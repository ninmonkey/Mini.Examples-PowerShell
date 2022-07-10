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









# Import-Module PowerHTML
# $q = PowerHTML\ConvertFrom-Html -URI 'https://powerbi.microsoft.com/en-us/blog/'

# # find all links on the page
# $q.SelectNodes("//a")

# # filter by name
# $q.SelectNodes("//a") | ? InnerText -match 'jan'

# # https://docs.microsoft.com/en-us/dotnet/api/system.text.encoding?view=net-6.0


