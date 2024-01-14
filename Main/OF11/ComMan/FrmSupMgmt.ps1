# Created by Atena Mahdzadeh - FrmSupMgmt.ps1
# Jan 12 2024
#
#Try
#{
 . "$(Split-Path $PSScriptRoot -Parent)\Config\$(($PSCommandPath.Split('\') | select -last 1) -replace (".ps1$","var.ps1"))"

    if($varDebugTrace -ne 0)
    {
        Set-PSDebug -Trace $varDebugTrace    
    }
    Else
    {
        Set-PSDebug -Trace $varDebugTrace  
    }

#    throw [System.IO.FileNotFoundException] "$file not found."

<#FormControls 
   +++++++++++++++++++++++++++++++++
#>
#MainTableکنترل 
$MainTable = New-Object System.Windows.Forms.TableLayoutPanel
$MainTable.Dock = "fill"
$MainTable.BackColor= ' '
$MainTable.CellBorderStyle = "Single"
$MainTable.AutoSize = $true

#SupplyInfoTable Control
$SupplyInfoTable = New-Object System.Windows.Forms.TableLayoutPanel
$SupplyInfoTable.Dock = "fill"
$SupplyInfoTable.BackColor= ' '
$SupplyInfoTable.CellBorderStyle = "Single"
#$SupplyInfoTable.AutoSize = $true
$SupplyInfoTable.ColumnCount = 2
$SupplyInfoTable.RowCount = 2
$SupplyInfoTable.BackColor = 'green'


#کنترل دکمه بازگشت به صفحه اصلی
$ReturnBtn = New-Object system.Windows.Forms.Button
$ReturnBtn.Name = $retunBtnName
$ReturnBtn.BackColor = "#d2d4d6"
$ReturnBtn.text = "بازگشت به صفحه اصلی"
$ReturnBtn.width = 100
$ReturnBtn.height = 35
$ReturnBtn.Font = 'Microsoft Sans Serif,10'
$ReturnBtn.ForeColor = "#000"

# MainGroupboxControl                       -Created by atena jan 14 24 
$DesktopGB = New-Object system.Windows.Forms.Groupbox
$DesktopGB.Size = New-Object System.Drawing.Size(500,550)
#$DesktopGB.Dock = [System.Windows.Forms.DockStyle]::Fill
$DesktopGB.AutoSize = $true
$DesktopGB.BackColor = ''

#GroupBoxControl -                          -Created by atena jan 14 24 
$MainGBLbl = New-Object System.Windows.Forms.label
$MainGBLbl.Location = New-Object System.Drawing.size(520,-5)
$MainGBLbl.Size = New-Object System.Drawing.Size(250,20) 
$MainGBLbl.Text = "ایجــاد یا ویــرایــش اطـــلاعات تامـــیــن کنـنده" 
$MainGBLbl.Font = 'Arial'
$MainGBLbl.TextAlign=[System.Drawing.ContentAlignment]::BottomRight    
                                         
#SupportNameLbl -                           -Created by atena jan 14 24 
$NameLbl = New-Object System.Windows.Forms.label
#$NameLbl.Location = New-Object System.Drawing.size(195,85)
#$NameLbl.Size = New-Object System.Drawing.Size(70,20) 
$NameLbl.Text = "نام سازمان تامین کننده" 
$NameLbl.TextAlign=[System.Drawing.ContentAlignment]::TopLeft
#$NameLbl.Visible = $False
$NameLbl.BackColor = 'red'

# رویداد کلیک دکمه بازگشت به صفحه اصلی
    $ReturnBtn.Add_Click({
    $Mainform.Close()
    $Mainform.Dispose()
& "$MainRoot\$($this.Name).ps1"
}.GetNewClosure())

#اضافه کردن کنترلها به فرم و جدول اصلی
$MainTable.Controls.Add($ReturnBtn)
$Mainform.Controls.add($DesktopGB)
$DesktopGB.Controls.Add($MainTable)
$DesktopGB.Controls.Add($MainGBLbl)
$MainTable.Controls.Add($SupplyInfoTable)
$SupplyInfoTable.Controls.Add($NameLbl)

[void]$Mainform.ShowDialog()
