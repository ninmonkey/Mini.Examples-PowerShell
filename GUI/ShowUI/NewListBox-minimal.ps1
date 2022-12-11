New-ListBox -SelectionMode Multiple {
   # Just using files as an example here ...
   Get-ChildItem -File -Name | Sort-Object -Descending
} -Show