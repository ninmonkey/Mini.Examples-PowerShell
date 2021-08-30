& {
    [cmdletbinding()]
    param()

    <#
from: jborean93
<https://discord.com/channels/180528040881815552/446156137952182282/833545120891535370>
#>
    $scanDirPath = 'C:\Temp\discord'

    $dirQueue = [Collections.Generic.Queue[IO.DirectoryInfo]]::new()
    $dirQueue.Enqueue((Get-Item -LiteralPath $scanDirPath))
    $size = 0

    while ($dirQueue.Count) {
        $dir = $dirQueue.Dequeue()

        Write-Verbose -Message "Scanning contents of '$($dir.FullName)'"
        $entries = @()
        try {
            $entries = $dir.EnumerateFileSystemInfos('*', [IO.SearchOption]::TopDirectoryOnly)
        }
        catch [System.IO.DirectoryNotFoundException] {
            # Broken ReparsePoint/Symlink, cannot enumerate
        }
        catch [System.UnauthorizedAccessException] {
        }  # No ListDirectory permissions, Get-ChildItem ignored this

        foreach ($entry in $entries) {
            Write-Verbose -Message "Processing '$($entry.FullName)'"
            if ($entry -is [IO.DirectoryInfo]) {
                if ($entry.Name -like 'folder*') {
                    Write-Verbose -Message "Directory '$($entry.Name)' matches filter, adding to queue"
                    $dirQueue.Enqueue($entry)
                }
                else {
                    Write-Verbose -Message "Directory '$($entry.Name)' does not match filter, skipping"
                }
            }
            else {
                Write-Verbose -Message "File '$($entry.Name)' being added to total size"
                $size += $entry.Length
            }
        }
    }

} -verbose
