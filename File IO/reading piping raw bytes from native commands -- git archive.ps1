$proc = [System.Diagnostics.Process]::new()
$proc.StartInfo.FileName = "git"
$proc.StartInfo.Arguments = "archive main build.ps1 --format=zip"
$proc.StartInfo.RedirectStandardOutput = $true
$proc.StartInfo.RedirectStandardError = $true
$proc.Start()
$proc.WaitForExit()

$stderr = $proc.StandardError.ReadToEnd()

if ($proc.ExitCode) {
    throw "git archive failed with $($proc.ExitCode) - $stderr"
}

$zip = [System.IO.Compression.ZipArchive]::new($proc.StandardOutput.BaseStream)
try {
    foreach ($entry in $zip.Entries) {
        Write-Host "Getting $($entry.Fullname)"

        try {
            $entryStream = $entry.Open()
            $sr = [System.IO.StreamReader]::new($entryStream)

            $fileContents = $sr.ReadToEnd()

            Write-Host $fileContents
        }
        finally {
            if ($sr) { $sr.Dispose() }
            if ($entryStream) { $entryStream.Dispose() }
        }
    }
}
finally {
    $zip.Dispose()
}

# Src: JBorean92: <https://discord.com/channels/180528040881815552/447476117629304853/1050259943036559470>

