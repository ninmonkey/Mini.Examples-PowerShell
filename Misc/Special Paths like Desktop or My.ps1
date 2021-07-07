
function Get-VBSpecialDirectory {
    <#
    .synopsis
        output a list of special directories defined by [Microsoft.VisualBasic.FileIO.SpecialDirectories]
    .example
        Get-VBSpecialDirectory

        Name                       Value
        ----                       -----
        MyDocuments                C:\Users\cppmo_000\Documents
        MyMusic                    C:\Users\cppmo_000\Music
        MyPictures                 C:\Users\cppmo_000\Pictures
        Desktop                    C:\Users\cppmo_000\Desktop
        Programs                   C:\Users\cppmo_000\AppData\Roaming\Microsoft\Windows\Start Menu\Programs
        ProgramFiles               C:\Program Files
        Temp                       C:\Users\cppmo_000\AppData\Local\Temp
        CurrentUserApplicationData
        AllUsersApplicationData
    #>
    $typeinfo = [Microsoft.VisualBasic.FileIO.SpecialDirectories]
    $memberName = $typeinfo | Find-Member -Static -IncludeSpecialName -IncludeNonPublic -MemberType Property
    $memberName.Name | ForEach-Object {
        $name = $_
        $value = $typeinfo::$_
        [pscustomobject]@{ Name = $name; Value = $value }
    }

}
