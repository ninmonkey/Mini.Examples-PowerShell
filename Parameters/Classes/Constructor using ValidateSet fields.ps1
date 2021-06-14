# class Stuff {
#     # [ValidatePattern('^[\da-f]{64}$')]
#     # [string]$Checksum
#     Stuff() {}
#     Stuff([string]$Business) {
#         $Business
#     }
#     Stuff([string]$Checksum, [string]$Case) {
#         return $Business
#         # if ($Case -eq 'Upper') { $this.Checksum = $Checksum."To$Case"() }
#         # elseif ($Case -eq 'Lower') { $this.Checksum = $Checksum."To$Case"() }
#         # else { throw "Valid cases are 'Upper' and 'Lower'. '$Case' is not a valid case." }
#     }
#     [string] ToString() {
#         return $this.$Business
#     }
# }


# # [Stuff]::new('param')
# class Device {
#     [string]$Brand
#     [string]$Model
#     [string]$VendorSku

#     [string]ToString() {
#         return ('{0}|{1}|{2}' -f $this.Brand, $this.Model, $this.VendorSku)
#     }
# }

# class Rack {
#     [int]$Slots = 8
#     [string]$Brand
#     # [validatescript('Surface Pro 4', 'A3')]
#     [string]$Model

#     [string]$VendorSku
#     [string]$AssetId
#     [Device[]]$Devices = [Device[]]::new($this.Slots)

#     [void] AddDevice(
#         [Device]$dev,
#         [int]$slot, [string]$Model) {
#         ## Add argument validation logic here
#         $this.Devices[$slot] = $dev
#     }

#     [void]RemoveDevice([int]$slot) {
#         ## Add argument validation logic here
#         $this.Devices[$slot] = $null
#     }

#     [int[]] GetAvailableSlots() {
#         [int]$i = 0
#         return @($this.Devices.foreach{ if ($_ -eq $null) { $i }; $i++ })
#     }
# }

# $rack = [Rack]::new()

# $surface = [Device]::new()
# $surface.Brand = 'Microsoft'
# $surface.Model = 'Surface Pro 4'
# $surface.VendorSku = '5072641000'
# $rack.AddDevice($surface, 2)

# $rack
# $rack.GetAvailableSlots()


# $rack = [Rack]::new()

# $surface = [Device]::new()
# $surface.Brand = 'Microsoft'
# $surface.Model = 'Surface Pro '
# $surface.VendorSku = '5072641000'
# $rack.AddDevice($surface, 2)

class Animal {
    [string]$Name = 'J.Doe'
    # [validatescript( ( $_ -is 'int' )]
    # [ValidateScript({$_ -is [int]})]
    [ValidateScript()]
    [uint]$Lives = 1

    [validateset('cat', 'dog', 'unknown')]
    [string]$Species = 'cat'

    Animal(
        [string]$Name,
        [uint]$Lives,
        [string]$Species
    ) {
        $this.Name = $Name
        $this.Lives = $Lives
        $this.Species = $Species
    }
    [string]ToString() {
        return ('{0}|{1}|{2}' -f $this.Name, $this.Lives, $this.Species)
    }
}
# $cat = $null
# $cat2 = $null

[Animal]$cat2 = [Animal]::New('Fred', 1, 'zebra')
if ($cat2) {
    $cat2.ToString()
}

[Animal]$cat = [Animal]::New('Kirk', 9, 'cat')
if ($cat) {
    $cat.ToString()
}

[Animal]$cat3 = [Animal]::New('Kirk', ( ([double]1.4)), 'cat')
if ($cat3) {
    $cat3.ToString()
}

