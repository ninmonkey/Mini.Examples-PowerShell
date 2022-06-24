#requires -module Az.Compute
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
using namespace System.Collections
using namespace System.Collections.Generic

Register-ArgumentCompleter -CommandName 'Get-AzVMImage' -ParameterName 'PublisherName' -ScriptBlock {
    param(
        [string] $CommandName,
        [string] $ParameterName,
        [string] $WordToComplete,
        [CommandAst] $CommandAst,
        [IDictionary] $SuppliedParameters #We only use this
    )
    trap {
        Write-Host ''
        Write-Host -fore Red "$CommandName -$ParameterName Autocomplete Error: $PSItem"
        return ' '
    }
    $ErrorActionPreference = 'Stop'
    $Location = $SuppliedParameters.Location
    if (-not $Location) {
        throw 'You must first specify the -Location parameter before tab completing the -PublisherName parameter.'
    }
    (Get-AzVMImagePublisher -Location $Location).PublisherName | Where-Object { $_ -like "*$WordToComplete*" }
}

Register-ArgumentCompleter -CommandName 'Get-AzVMImage' -ParameterName 'Offer' -ScriptBlock {
    param(
        [string] $CommandName,
        [string] $ParameterName,
        [string] $WordToComplete,
        [CommandAst] $CommandAst,
        [IDictionary] $SuppliedParameters #We only use this
    )
    trap {
        Write-Host ''
        Write-Host -fore Red "$CommandName -$ParameterName Autocomplete Error: $PSItem"
        return ' '
    }
    $ErrorActionPreference = 'Stop'
    $Location = $SuppliedParameters.Location
    $PublisherName = $SuppliedParameters.PublisherName
    if (-not $Location) {
        throw 'You must first specify the -Location parameter before tab completing the -Offer parameter.'
    }
    if (-not $PublisherName) {
        throw 'You must first specify the -PublisherName parameter before tab completing the -Offer parameter.'
    }
    (Get-AzVMImageOffer -Location $Location -PublisherName $PublisherName).Offer | Where-Object { $_ -like "*$WordToComplete*" }
}

Register-ArgumentCompleter -CommandName 'Get-AzVMImage' -ParameterName 'Skus' -ScriptBlock {
    param(
        [string] $CommandName,
        [string] $ParameterName,
        [string] $WordToComplete,
        [CommandAst] $CommandAst,
        [IDictionary] $SuppliedParameters #We only use this
    )
    trap {
        Write-Host ''
        Write-Host -fore Red "$CommandName -$ParameterName Autocomplete Error: $PSItem"
        return ' '
    }
    $ErrorActionPreference = 'Stop'
    $Location = $SuppliedParameters.Location
    $PublisherName = $SuppliedParameters.PublisherName
    $Offer = $SuppliedParameters.Offer
    if (-not $Location) {
        throw 'You must first specify the -Location parameter before tab completing the -Skus parameter.'
    }
    if (-not $PublisherName) {
        throw 'You must first specify the -PublisherName parameter before tab completing the -Skus parameter.'
    }
    if (-not $Offer) {
        throw 'You must first specify the -Offer parameter before tab completing the -Skus parameter.'
    }
    (Get-AzVMImageSku -Location $Location -PublisherName $PublisherName -Offer $offer).Skus | Where-Object { $_ -like "*$WordToComplete*" }
}

Register-ArgumentCompleter -CommandName 'Get-AzVMImage' -ParameterName 'Version' -ScriptBlock {
    param(
        [string] $CommandName,
        [string] $ParameterName,
        [string] $WordToComplete,
        [CommandAst] $CommandAst,
        [IDictionary] $SuppliedParameters #We only use this
    )
    trap {
        Write-Host ''
        Write-Host -fore Red "$CommandName -$ParameterName Autocomplete Error: $PSItem"
        return ' '
    }
    $ErrorActionPreference = 'Stop'
    $Location = $SuppliedParameters.Location
    $PublisherName = $SuppliedParameters.PublisherName
    $Offer = $SuppliedParameters.Offer
    $Skus = $SuppliedParameters.Skus
    if (-not $Location) {
        throw 'You must first specify the -Location parameter before tab completing the -Version parameter.'
    }
    if (-not $PublisherName) {
        throw 'You must first specify the -PublisherName parameter before tab completing the -Version parameter.'
    }
    if (-not $Offer) {
        throw 'You must first specify the -Offer parameter before tab completing the -Version parameter.'
    }
    if (-not $Skus) {
        throw 'You must first specify the -Offer parameter before tab completing the -Version parameter.'
    }
    (Get-AzVMImage -Location $Location -PublisherName $PublisherName -Offer $offer -Sku $skus).Version | Where-Object { $_ -like "*$WordToComplete*" }
}
