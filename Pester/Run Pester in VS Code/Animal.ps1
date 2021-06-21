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
