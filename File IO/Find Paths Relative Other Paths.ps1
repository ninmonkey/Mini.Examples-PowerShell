

function ConvertTo-RelativePath {
    <#
    .synopsis
        Converts a path relative to another
    .notes
        warning: the docs for [IO.Path]::GetRelativePath say that      
            > Paths are resolved by calling the GetFullPath method before calculating the difference
        which calculates abs() paths, using the dotnet CWD not Pwsh CWD.
        
        currently, assumes both params can evaluate to valid path names
        future: use [IO.<File|Directory>Info] types
            or regular stringss, using split on paths as strings                      
    .EXAMPLE
        Pwsh>
        @(
            ls .. | select -first 3
            ls . | select -first 3
            ls  -Depth 3 | Get-random -count 4
        ) | ConvertTo-RelativePath -BaseDir (gi .) | fl
    #>
    param(
        [Parameter(Mandatory, ValueFromPipeline)]$InputObject,
        [Parameter()]$BaseDir #$PSScriptRoot # Get-Item .
    )
    process {
        $Item = $InputObject | Get-Item -ea ignore
        # $BaseDir.GetType()
        if ( [string]::IsNullOrWhiteSpace( $Item ) ) {
            write-error "blank Basedir param"; return
        }

        $baseDir = Get-Item $BaseDir -ea 'ignore' #@-ea 'ignore'
        if( [string]::IsNullOrWhiteSpace( $BaseDir )) {
            $BaseDir = Get-Item .
            write-warning "Assuming BaseDir from Cwd: '$BaseDir'"
        }
        class RelativePathRecord {
            hidden [object]$InputObject
            [string]$RelPath
            [object]$Item
            [object]$BaseDir
        }
        [RelativePathRecord]@{
            InputObject = $Item
            RelPath = [System.IO.Path]::GetRelativePath(
                $baseDir.FullName, $Item.FullName )
            Item = $Item.FullName
            BaseDir = $BaseDir.FullName
        }
    }
}

Get-ChildItem Depth 3
| select -First 100
| Fpreach-Object {
    [IO.Path]::GetRelativePath( (gi ~), $_.FullName) 
}



@(
    ls .. | select -first 3
    ls .  | select -first 3
    ls  -Depth 3 | Get-random -count 4
) | ConvertTo-RelativePath -BaseDir (gi .) -ov 'query' | fl

if($false) {
    {        # related from jaykul
        param($SourceRoot, $DestinationRoot)

        foreach($path in Get-ChildItem $SourceRoot -Recurse -Name) {
            $EventType, $Location, $EventSource, $Remainder = $path.Split([IO.Path]::DirectorySeparatorChar)
            # This depends on the PS7 version of Join-Path:
            Move-Item $path -Destination (Join-Path $DestinationRoot $Location "Historical Data" $EventSource $EventType @Remainder)
        }
    }
}
