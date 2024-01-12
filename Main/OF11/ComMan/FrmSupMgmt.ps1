# Created by Atena Mahdzadeh
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

#کنترل دکمه بازگشت به صفحه اصلی
$ReturnBtn = New-Object system.Windows.Forms.Button
$ReturnBtn.Name = $retunBtnName
$ReturnBtn.BackColor = "#d2d4d6"
$ReturnBtn.text = "بازگشت به صفحه اصلی"
$ReturnBtn.width = 100
$ReturnBtn.height = 35
$ReturnBtn.Font = 'Microsoft Sans Serif,10'
$ReturnBtn.ForeColor = "#000"
#+++++++++++++++++++++++++++++++++++++++++++++++

# رویداد کلیک دکمه بازگشت به صفحه اصلی
    $ReturnBtn.Add_Click({
    $Mainform.Close()
    $Mainform.Dispose()
& "$MainRoot\$($this.Name).ps1"
}.GetNewClosure())

#اضافه کردن کنترلها به فرم و جدول اصلی
$MainTable.Controls.Add($ReturnBtn)
$Mainform.Controls.Add($MainTable)

[void]$Mainform.ShowDialog()
