import-module  ShowUI

ListView -ItemSource {
    gci $Env:Public\Pictures -recurse -File
    StackPanel -Orientation Horizontal {
        Image -Width 40 -source { Binding -Path FullName}
        Label -content {Binding -Path Name}
    }
} -show