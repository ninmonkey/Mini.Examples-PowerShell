Add-Type -AssemblyName 'System.Windows.Forms'
Add-Type -AssemblyName 'System.Drawing'
@'
About:
    select from a select box window

source: https://docs.microsoft.com/en-us/powershell/scripting/samples/selecting-items-from-a-list-box?view=powershell-7.3#create-a-list-box-control-and-select-items-from-it

- https://docs.microsoft.com/en-us/powershell/scripting/samples/creating-a-custom-input-box?view=powershell-7.3
- https://docs.microsoft.com/en-us/powershell/scripting/samples/multiple-selection-list-boxes?view=powershell-7.3

Controls:
    https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms?view=windowsdesktop-6.0

notes:
    Should anything be Disposed()?
'@

& {

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Select a Computer'
    $form.Size = New-Object System.Drawing.Size(300, 200)
    $form.StartPosition = 'CenterScreen'

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75, 120)
    $okButton.Size = New-Object System.Drawing.Size(75, 23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150, 120)
    $cancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.Size = New-Object System.Drawing.Size(280, 20)
    $label.Text = 'Please select a computer:'
    $form.Controls.Add($label)

    $listBox = New-Object System.Windows.Forms.ListBox
    $listBox.Location = New-Object System.Drawing.Point(10, 40)
    $listBox.Size = New-Object System.Drawing.Size(260, 20)
    $listBox.Height = 80

    # [void] $listBox.Items.Add('atl-dc-001')
    # [void] $listBox.Items.Add('atl-dc-002')
    # [void] $listBox.Items.Add('atl-dc-003')
    # [void] $listBox.Items.Add('atl-dc-004')
    # [void] $listBox.Items.Add('atl-dc-005')
    # [void] $listBox.Items.Add('atl-dc-006')
    # [void] $listBox.Items.Add('atl-dc-007')
    Get-Process | Sort-Object CPU -Descending -Top 10 | ForEach-Object { $_.CPU, $_.Name -join ' => ' }
    | ForEach-Object {
        [Void] $listBox.Items.Add( $_ )
    }

    $form.Controls.Add($listBox)

    $form.Topmost = $true

    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $x = $listBox.SelectedItem
        $x
    }


}
