# Datatable for your CSV content
$DataTable1 = New-Object System.Data.DataTable
[void] $DataTable1.Columns.Add("Fruit")
[void] $DataTable1.Columns.Add("RGB")

# Your CSV content
@"
Fruit,RGB
apple,ff0000
apple,00ff00
kiwi,00ff00
"@ | ConvertFrom-Csv | ForEach-Object {
    [void] $DataTable1.Rows.Add($_.Fruit, $_.RGB)
    }

# Acceptable color values datatable - for your combobox
$DataTable2 = New-Object System.Data.DataTable
[void] $DataTable2.Columns.Add("RGB")
[void] $DataTable2.Columns.Add("Color")
# Manually add rows. You can programmatically add the rows as well 
[void] $DataTable2.Rows.Add("ff0000", "red")
[void] $DataTable2.Rows.Add("00ff00", "green")
[void] $DataTable2.Rows.Add("0000ff", "blue")

# Form
$Form = New-Object System.Windows.Forms.Form
$Form.Size = New-Object System.Drawing.Size(500,500)
$Form.StartPosition = "CenterScreen"

# Form event handlers
$Form.Add_Shown({
    $Form.Activate()
    })

# Datagridview
$DGV = New-Object System.Windows.Forms.DataGridView
$DGV.Anchor = [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Top
$DGV.Location = New-Object System.Drawing.Size(0,0) 
$DGV.Size = New-Object System.Drawing.Size(480,400)
$DGV.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",10,0,3,1)
$DGV.BackgroundColor = "#ffffffff"
$DGV.BorderStyle = "Fixed3D"
$DGV.AlternatingRowsDefaultCellStyle.BackColor = "#ffe6e6e6"
$DGV.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill
$DGV.AutoSizeRowsMode = [System.Windows.Forms.DataGridViewAutoSizeRowsMode]::AllCells
$DGV.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect
$DGV.ClipboardCopyMode = "EnableWithoutHeaderText"
$DGV.AllowUserToOrderColumns = $True
$DGV.DataSource = $DataTable1
$DGV.AutoGenerateColumns = $False
$Form.Controls.Add($DGV)

# Datagridview columns
$Column1 = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$Column1.Name = "Fruit"
$Column1.HeaderText = "Fruit"
$Column1.DataPropertyName = "Fruit"
$Column1.AutoSizeMode = "Fill"

$Column2 = New-Object System.Windows.Forms.DataGridViewComboBoxColumn
$Column2.Name = "Color"
$Column2.HeaderText = "Color"
$Column2.DataSource = $DataTable2
$Column2.ValueMember = "RGB"
$Column2.DisplayMember = "Color"
$Column2.DataPropertyName = "RGB"

$DGV.Columns.AddRange($Column1, $Column2)

# Button to export data
$Button = New-Object System.Windows.Forms.Button
$Button.Anchor = [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Bottom
$Button.Location = New-Object System.Drawing.Size(10,420) 
$Button.Text = "Export"
$Form.Controls.Add($Button)

# Button event handlers
$Button.Add_Click({
    $DataTable1 | Out-GridView # do what you want
    })

# Show form
[void] $Form.ShowDialog()