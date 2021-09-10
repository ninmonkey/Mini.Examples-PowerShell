class MyArgumentTransformation : System.Management.Automation.ArgumentTransformationAttribute {
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object]$inputData) {
        # Facets of $inputData can be tested here. For example, if it's a string, pass it on without any changes
        if ($inputData -is [string]) {
            return $inputData
        }

        # Or look for a property with a specific pattern
        if ($property = $inputData.PSObject.Properties.Match('*_id')) {
            return $property.Value
        }

        throw 'Invalid argument'
    }
}

function MyCommand {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [MyArgumentTransformation()]
        [string]$SomeParam
    )

    process {
        Write-Host $SomeParam
    }
}

'string', [PSCustomObject]@{ entity_id = 'object' } | MyCommand
