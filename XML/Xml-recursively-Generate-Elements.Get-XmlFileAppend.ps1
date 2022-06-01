'code from: <https://gist.github.com/IISResetMe/06761683ba313e5c48f548d011f75549>
Get-XmlFileTreeAppend "path"
'

function Get-XmlFileTreeAppend {
    param(
        [Parameter(ParameterSetName = 'Path', Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]
        ${Path},

        [Parameter(ParameterSetName = 'LiteralPath', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('PSPath')]
        [string[]]
        ${LiteralPath}
    )

    function ProcessNode {
        param([System.IO.FileSystemInfo]$item, [System.Xml.XmlNode]$parent)

        $doc = if (!$parent.OwnerDocument) {
            $parent
        } else {
            $parent.OwnerDocument
        }

        if ($item -is [System.IO.DirectoryInfo]) {
            $newNode = $doc.CreateElement('Directory')
            $newNode.SetAttribute('Name', $item.Name)

            $item.EnumerateDirectories() | ForEach-Object {
                ProcessNode $_ $newNode
            }

            $item.EnumerateFiles() | ForEach-Object {
                ProcessNode $_ $newNode
            }
        } else {
            $newNode = $doc.CreateElement('File')
            $newNode.SetAttribute('Name', $item.Name)
            $newNode.SetAttribute('Size', $item.Length)
        }
        [void]$parent.AppendChild($newNode)
    }

    $root = Get-Item @PSBoundParameters
    $xml = [xml]::new()
    ProcessNode $root $xml

    return $xml.OuterXml
}

function Get-XmlFileTreeWriter {
    param(
        [Parameter(ParameterSetName = 'Path', Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]
        ${Path},

        [Parameter(ParameterSetName = 'LiteralPath', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('PSPath')]
        [string[]]
        ${LiteralPath}
    )

    function NewNode {
        param([System.IO.FileSystemInfo]$item, [System.Xml.XmlWriter]$writer)

        $isDir = $item -is [System.IO.DirectoryInfo]

        if ($isDir) {
            $writer.WriteStartElement('Directory')
            $writer.WriteAttributeString('Name', $item.Name)

            $item.EnumerateDirectories() | ForEach-Object {
                NewNode $_ $writer
            }

            $item.EnumerateFiles() | ForEach-Object {
                NewNode $_ $writer
            }
        } else {
            $writer.WriteStartElement('File')
            $writer.WriteAttributeString('Name', $item.Name)
            $writer.WriteAttributeString('Size', $item.Length)
        }
        $writer.WriteEndElement()
    }

    try {
        $settings = [System.Xml.XmlWriterSettings]@{ Indent = $true; Encoding = [System.Text.Encoding]::UTF8 }
        $stringbuilder = [System.Text.StringBuilder]::new()
        $writer = [System.Xml.XmlWriter]::Create($stringbuilder, $settings)

        $writer.WriteStartDocument()
        NewNode (Get-Item @PSBoundParameters) $writer
        $writer.WriteEndDocument()

        $writer.Flush()

        return $stringbuilder.ToString()
    } finally {
        if ($writer -is [IDisposable]) {
            $writer.Dispose()
        }
    }
}