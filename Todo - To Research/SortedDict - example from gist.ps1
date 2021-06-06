using namespace System.Collections.Generic

'code from: <https://gist.github.com/IISResetMe/50c3e55a5ef4bb936b2ca79621452105>'
# First we define our comparer
class SortPropertyFirstComparer : IComparer[string] {
    [int]Compare([string]$a, [string]$b) {
        if ($a -ceq 'Property') {
            return -1
        }
        return [System.StringComparer]::CurrentCultureIgnoreCase.Compare($a, $b)
    }
}

# Next, we pass an instance of the new comparer type as an argument to our collection constructor (here a SortedDictionary)
$Dictionary = [SortedDictionary[string, psobject]]::new([SortPropertyFirstComparer]::new())

# Insert your stuff in any order
-split 'a b c d e f' |Sort-Object { Get-Random } | ForEach-Object {
    $Dictionary.Add($_, $null)
}

# The dictionary will automatically re-sort the keys for you
($Dictionary.Keys |Select-Object -First 1) -eq 'a'
($Dictionary.Keys |Select-Object -Last 1) -eq 'f'

# But the exact key 'Property' will always come first :)
$Dictionary.Add('Property', 'PropertyNameGoesHere')
($Dictionary.Keys |Select-Object -First 1) -eq 'Property'
