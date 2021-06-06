function Write-Hello {
    param(
        # autocomplete a color
        [Parameter(Mandatory, Position = 0)]
        [ConsoleColor]$Color
    )

    Write-Host 'Hello' -ForegroundColor $Color
}