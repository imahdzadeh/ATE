Add-Type -AssemblyName System.Windows.Forms

$CSVDelimiter = ","
$Global:FileName = $Null

function SelectCsvFile () {
    Add-Type -AssemblyName System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.RestoreDirectory = $true
    $SelectedFile=$OpenFileDialog.ShowDialog()
    If ($SelectedFile -eq "Cancel") {
        $result = $null
    } 
    Else 
    { 
        $SaveBtn.Enabled = $True
        $DGVDataTab = New-Object system.Data.DataTable
        $Global:FileName = $OpenFileDialog.FileName
        (Get-Content $OpenFileDialog.FileName | select -First 1) -split $CSVDelimiter | foreach {
            $col = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
            $col.HeaderText = $_
            $col.Name = $_
            $col.DataPropertyName = $_
            $colDT = New-Object System.Data.DataColumn
            $colDT.DataType = [string]
            $colDT.ColumnName = $_
            $DGVDataTab.Columns.Add($colDT)        
            [void]$DataGrid.columns.Add($col)
        }
        $DataGrid.DataSource = $DGVDataTab
        Import-Csv $OpenFileDialog.FileName |  foreach {
            $row2 = $DGVDataTab.NewRow() 
            foreach($column in $DataGrid.Columns){
                $row2.($column.HeaderText)=$_.($column.HeaderText)
            }
            [void]$DGVDataTab.Rows.Add($row2)
        }
    }
    $OpenFileDialog.Dispose()   
}

Function SaveBtn_Click
{
    ($DataGrid.Columns | % { $_.HeaderText } ) -join ',' | Out-File $Global:FileName
    $DataGrid.Rows | Select-Object -SkipLast 1 | % { ($_.Cells | % { $_.Value }) -join ',' | Out-File $Global:FileName -Append }
}

# Init PowerShell Gui

[System.Windows.Forms.Application]::EnableVisualStyles()
# Create a new form
$ManageTeamsForm = New-Object system.Windows.Forms.Form
# Define the size, title and background color
$ManageTeamsForm.ClientSize = New-Object System.Drawing.Point(820,600)
$ManageTeamsForm.AutoScroll = $true

#DataGrid
$DataGrid = new-object System.windows.forms.DataGridView
$DataGrid.width             = 770
$DataGrid.height            = 550
$DataGrid.location          = New-Object System.Drawing.Point(37,30)
$DataGrid.AllowUserToAddRows = $true
$DataGrid.AllowUserToDeleteRows = $true
$DataGrid.ReadOnly = $false
$DataGrid.AutoSizeColumnsMode = 6
$DataGrid.ColumnHeadersDefaultCellStyle.Alignment = [System.Drawing.ContentAlignment]::MiddleCenter
$DataGrid.SelectionMode = 'FullRowSelect'

#Select File Button
$SelectCsvFileButton = New-Object System.Windows.Forms.Button
$SelectCsvFileButton.Location = New-Object System.Drawing.Size(50,05)
$SelectCsvFileButton.Size = New-Object System.Drawing.Size(120,23)
$SelectCsvFileButton.Text = "Open CSV"
$SelectCsvFileButton.Add_Click({
    SelectCsvFile
})

$SaveBtn = New-Object System.Windows.Forms.Button
$SaveBtn.Location = New-Object System.Drawing.Size(200,05)
$SaveBtn.Size = New-Object System.Drawing.Size(120,23)
$SaveBtn.Text = "Save"
$SaveBtn.Enabled = $false
$SaveBtn.Add_Click({
    SaveBtn_Click
})

$ManageTeamsForm.controls.AddRange(@($SelectCsvFileButton,$DataGrid,$SaveBtn))
[void]$ManageTeamsForm.ShowDialog()