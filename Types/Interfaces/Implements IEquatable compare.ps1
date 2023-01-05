class TestComparer : System.IEquatable[TestComparer] {
    [string] $Prop1
    [string] $Prop2

    hidden static [bool] Equals ([TestComparer] $X, [TestComparer] $Y) {
        return $X.Prop1.Equals($Y.Prop1) -and $X.Prop2.Equals($Y.Prop2)
    }

    [bool] Equals ([TestComparer] $Object) {
        return [TestComparer]::Equals($this, $Object)
    }

    [int] GetHashCode () {
        return [System.Tuple]::Create($this.Prop1, $this.Prop2).GetHashCode()
    }
}

$c1 = [TestComparer]::new()
$c2 = [TestComparer]::new()


$c1 -eq $c2