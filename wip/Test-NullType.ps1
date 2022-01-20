function testNullType {
    param(

        # test any object
        [AllowEmptyCollection()]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [Parameter(ValueFromPipeline, Position = 0)]
        [object]$Value
    )
}

# process {
#     if ($null -eq $Value) {
#         'True $Null'; return
#     }


# if ([string]::IsNullOrWhiteSpace($Value)) {
#     'Whitespace $Null'; return
# }

# }
