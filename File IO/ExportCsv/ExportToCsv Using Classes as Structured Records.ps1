
class File { 
   [string]$Name
   [string]$FullName
   [int]$Bytes
   [string]$SizeKb
}

function ReportSummary {
    # collect stats on all file in one folder
    param( [string]$Path )

    $files = gci $Path
    foreach($f in $Files) { 
        [File]@{ 
             Name = $f.Name
             SizeKb = '{0:n2}' -f @( $f.Length / 1kb )
             FullName = $f.FullName 
             Bytes = $f.length
        }
    }
}
ReportSummary | ConvertTo-Csv
<#
outputs:

>> ReportSummary ~ | Select -First 15 | ft -AutoSize

    Name                     SizeKb FullName
    ----                     ------ --------
    _lesshst                 0.78   C:\Users\nin\_lesshst
    .bash_history            11.49  C:\Users\nin\.bash_history
    .bash_logout             0.02   C:\Users\nin\.bash_logout
    .bash_profile            0.00   C:\Users\nin\.bash_profile
    .bashrc                  0.00   C:\Users\nin\.bashrc
    
#>

ReportSummary ~ | Export-Csv 'foo.csv'

# Round trip works! 
[File[]]$results =  ReportSummary ~ | ConvertTo-Csv | ConvertFrom-Csv

