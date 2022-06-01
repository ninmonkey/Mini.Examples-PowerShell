```ps1

"Hsl","Lch","Rgb","Lab","Xyz" | % { 
   Get-Gradient red cyan -Width 10 -ColorSpace $_ | %{ Write-Host " " -bg $_ -no} 
   Write-Host
}
```

todo screenshot
```ps1
"Hsl","Lch","Rgb","Lab","Xyz" | % { 
       Get-Gradient red cyan -Width 10 -ColorSpace $_ | %{ Write-Host " " -bg $_ -no}
       Write-Host
    }
    ```

```ps1
>> gi fg:Purple | gm To*

   TypeName: PoshCode.Pansies.RgbColor

Name               MemberType Definition
----               ---------- ----------
To                 Method     T To[T](), T IColorSpace.To[T]()
ToCmy              Method     PoshCode.Pansies.ColorSpaces.ICmy ToCmy()
ToCmyk             Method     PoshCode.Pansies.ColorSpaces.ICmyk ToCmyk()
ToHsb              Method     PoshCode.Pansies.ColorSpaces.IHsb ToHsb()
ToHsl              Method     PoshCode.Pansies.ColorSpaces.IHsl ToHsl()
ToHsv              Method     PoshCode.Pansies.ColorSpaces.IHsv ToHsv()
ToHunterLab        Method     PoshCode.Pansies.ColorSpaces.IHunterLab ToHunterLab()
ToLab              Method     PoshCode.Pansies.ColorSpaces.ILab ToLab()
ToLch              Method     PoshCode.Pansies.ColorSpaces.ILch ToLch()
ToLuv              Method     PoshCode.Pansies.ColorSpaces.ILuv ToLuv()
ToRgb              Method     PoshCode.Pansies.ColorSpaces.IRgb ToRgb(), PoshCode.Pa
```