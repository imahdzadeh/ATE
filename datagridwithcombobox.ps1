Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework

#### Begin of DataTable as Source here

$source = @'
Employee,Status,Code
user.example1,Active,1
user.example2,Withdraw,0
user.example3,Withdraw,0
user.example4,Active,1
user.example5,Withdraw,0
user.example6,Active,1
'@ | ConvertFrom-Csv

$columns = $source[0].PSobject.Properties.Name

$table = New-Object system.Data.DataTable

$col = New-Object System.Data.DataColumn
$col.DataType = [string]
$col.ColumnName = 'Employee'
$table.Columns.Add($col)

$col = New-Object System.Data.DataColumn
$col.DataType = [string]
$col.ColumnName = 'Status'
$table.Columns.Add($col)

$col = New-Object System.Data.DataColumn
$col.DataType = [string]
$col.ColumnName = 'Code'
$table.Columns.Add($col)

foreach($line in $source)
{
    $row = $table.NewRow()
    foreach($column in $columns)
    {
        $row.$column = $line.$column
    }
    $table.Rows.Add($row)
}

##########

$mainForm = New-Object System.Windows.Forms.Form
$mainForm.StartPosition = 'CenterScreen'
$mainForm.FormBorderStyle = 'Fixed3D'
$mainForm.Text = 'Test'
$mainForm.WindowState = 'Maximized'

$bounds = ($mainForm.CreateGraphics()).VisibleClipBounds.Size

$dataGrid = New-Object System.Windows.Forms.DataGridView
$dataGrid.Size = New-Object System.Drawing.Size(($bounds.Width-20),($bounds.Height-140))
$dataGrid.Location = New-Object System.Drawing.Size(10,60)
$dataGrid.AllowUserToAddRows = $false
$dataGrid.SelectionMode = 4
$dataGrid.MultiSelect = $true
$dataGrid.ReadOnly = $false
$dataGrid.RowHeadersVisible = $false
$dataGrid.ColumnHeadersBorderStyle = 2
$dataGrid.EnableHeadersVisualStyles = $true

# Pairing DataPropertyName with DataTable's column Names
$col0 = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$col0.HeaderText = 'Employee'
$col0.DataPropertyName = 'Employee'
$col0.SortMode = 'NotSortable'
$dataGrid.Columns.Add($col0)

$col1=New-Object System.Windows.Forms.DataGridViewComboBoxColumn
$col1.HeaderText = 'Status'
$col1.DataPropertyName = 'Status'
# Using DataTable 'Status' column unique values as DataSource
$col1.DataSource = $table.Status | Select-Object -Unique
$col1.SortMode = 'NotSortable'
$dataGrid.Columns.Add($col1)

$col2 = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$col2.HeaderText = 'Code'
$col2.DataPropertyName = 'Code'
$col2.ReadOnly = $True
$col2.SortMode = 'NotSortable'
$dataGrid.Columns.Add($col2)

$dataGrid.Add_EditingControlShowing({
    
    # Not entirely sure how this works but it works lol
    # Basically the only column that can behave as WinForms ComboBox is
    # DataGridViewComboBoxColumn. When this is True we can enable DropDown and SuggestAppend
    # to the EditingControl. This code is emulated from C# and not sure if it's the right approach
    # but still it works.

    if($_.Control -as [System.Windows.Forms.ComboBox])
    {
        $this.EditingControl.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDown
        $this.EditingControl.AutoCompleteMode = [System.Windows.Forms.AutoCompleteMode]::SuggestAppend
    }
})

$dataGrid.Add_CellEndEdit({

    $row = $this.CurrentRow.DataBoundItem

    # I tried this to work in both ways, meaning, the value of 'Status' would
    # dynamically update the value of 'Code' and vice versa but the DGV gets super buggy
    # Seems like you need 'INotifyPropertyChanged' on the bound DataTable but couldn't
    # figure out how to make it work in PowerShell yet.
    # Source: https://stackoverflow.com/questions/1516252/how-to-programmatically-set-cell-value-in-datagridview

    if($row.Status -eq 'Active')
    {
        $this.CurrentRow.DataBoundItem['Code'] = '1'
    }
    else
    {
        $this.CurrentRow.DataBoundItem['Code'] = '0'
    }
})

$dataGrid.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnMode]::Fill

$dataGrid.Add_DataError({

    # Error handling here
    # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.datagridview.dataerror?view=net-5.0
    $_.Cancel = $true
})

$mainForm.Controls.Add($dataGrid)

$dataGrid.DataSource = $table

$bulkUpdateBtn = New-Object System.Windows.Forms.Button
$bulkUpdateBtn.Size = New-Object System.Drawing.Size(85,30)
$bulkUpdateBtn.Location = New-Object System.Drawing.Size(($dataGrid.Width-74),($dataGrid.Height+70))
$bulkUpdateBtn.Text = "Bulk Update"
$bulkUpdateBtn.Add_Click({
    
    # TO DO

})
$mainForm.Controls.Add($bulkUpdateBtn)

$mainForm.Add_Shown({ $mainForm.Activate() })
$mainForm.ShowDialog()