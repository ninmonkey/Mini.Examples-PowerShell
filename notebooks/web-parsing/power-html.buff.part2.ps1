Import-Module PowerHtml -ea stop
# steppable or string builder would let me wait till the very end then pipe to native command for colors
# finally, I join with (hr)
# get-history | s -First 20 | Join-String -prop CommandLine -sep $(hr 2)

$Url = @{
    Wiki = 'https://gameshows.fandom.com/wiki/Jeopardy!/Records_%26_Statistics'
}
#  = 'https://gameshows.fandom.com/wiki/Jeopardy!/Records_%26_Statistics'
$Url.Source = $Url.Wiki
$XPaths ??= @{
    computerGeneratedPath = '/html/body/div[4]/div[3]/div[3]/main/div[3]/div[1]/div/table[1]'
    humanPath             = '//[@id="All-Time_Total_Winnings"]'
}
$Q ??= @{}
$Doc = PowerHTML\ConvertFrom-Html -URI $Url.Source
$Doc.SelectSingleNode(  $XPaths.computerGeneratedPath )




$Q.SpanByID = $Doc.SelectNodes('//span[@id="All-Time_Total_Winnings"]')
$Q.AnonByID = $Doc.SelectNodes('//[@id="All-Time_Total_Winnings"]')
$doc.SelectNodes('//[@id="All-Time_Total_Winnings"]')