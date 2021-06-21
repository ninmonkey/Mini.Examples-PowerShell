class Animal {
    [string]$Name = ''
    [uint]$Lives = 1

    [validateset('Cat', 'Dog', 'Unspecified')]
    [string]$Species = 'Unspecified'

    Animal( [string]$Name, [string]$Species, [uint]$Lives) {
        if ($Lives -gt 9) {
            Write-Error "Invalid lives: $Lives"
        }
        $this.Name = $Name
        $this.Lives = $Lives
        $this.Species = $Species
    }
    [string]ToString() {
        return ('{0}|{1}|{2}' -f $this.Name, $this.Lives, $this.Species)
    }
}

class Rack {
    [int]$Slots = 8
    [string]$Brand
    [string]$Model
    [string]$VendorSku
    [string]$AssetId
    [Device[]]$Devices = [Device[]]::new($this.Slots)

    [void] AddDevice([Device]$dev, [int]$slot) {
        ## Add argument validation logic here
        $this.Devices[$slot] = $dev
    }

    [void]RemoveDevice([int]$slot) {
        ## Add argument validation logic here
        $this.Devices[$slot] = $null
    }

    [int[]] GetAvailableSlots() {
        [int]$i = 0
        return @($this.Devices.foreach{ if ($_ -eq $null) { $i }; $i++ })
    }
}

<#

#>