Import-Module ShowUI
# These are the things that will be returned
$Items = Get-ChildItem $Env:Public\Pictures -Recurse -File

# Grid just to add the buttons at the bottom
Grid -Margin 5 -ControlName Root -Rows *, Auto {
  # Use a ScrollViewer so it can scroll if there are a lot
  ScrollViewer -Row 0 {
    # Put the items in a ListView ...
    ListView -ControlName TheList -ItemsSource $Items -ItemTemplate {
      # But for each of them, we get one of these ...
      StackPanel -Orientation Horizontal {
        CheckBox -IsChecked { Binding -RelativeSource {
            RelativeSource -AncestorType ([System.Windows.Controls.ListViewItem])
        } -Path IsSelected }
        # Since the things I'm listing are image files, I can just bind the source to the fullname
        Image -Width 40 -Source { Binding -Path FullName }
        Label -Content { Binding -Path Name }
      }
    } -SelectionMode Multiple
  }
  # Another Grid because I want the buttons right aligned
  Grid -Row 1 -Margin 5 -HorizontalAlignment Right -Columns 65, 10, 65 {
    Button "OK" -Column 0 -IsDefault -Width 65 -On_Click {
      # Because I buried the data in layers of controls, Set the output explicitly
      Set-UIValue $window -Value $TheList.SelectedItems
      Close-Control $window
    }
    Button "Cancel" -Column 2 -IsCancel -Width 65 -On_Click { Set-UIValue $window -Value $null }
  }
} -Show