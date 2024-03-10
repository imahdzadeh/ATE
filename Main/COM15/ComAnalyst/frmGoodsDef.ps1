#==================================#
#|   Created by Isar & @ten@ Mahdzadeh    |#
#==================================#
#|   March 04 2024             |#
#==================================#
#|   imahdzadeh@gmail.com      |#

#==================================#
#|   Atenshin Elsci               |#
#==================================#

$DepCodeTemp = (Split-Path $PSScriptRoot -Parent).Split('\') | select -Last 1
$ConFol =  (Get-Item $PSScriptRoot).parent.Parent.Parent.FullName
$pathTemp = "$ConFol\Config\$DepCodeTemp\$((Get-Item $PSCommandPath).Name)" -replace (".ps1$","")
. "$pathTemp\$(((Get-Item $PSCommandPath).Name) -replace (".ps1$","var.ps1"))"


if($varDebugTrace -ne 0){Set-PSDebug -Trace $varDebugTrace}Else{Set-PSDebug -Trace $varDebugTrace}


$MainTbl = New-Object TableLayoutPanel
#$MainTbl.AutoSize = $true
$MainTbl.CellBorderStyle = 1
$MainTbl.Size = New-Object Size(1100,601)
#$MainTbl.ColumnCount = 4
#$MainTbl.RowCount = 3
#$MainTbl.BackColor = 'green'

$HeaderTbl = New-Object TableLayoutPanel
#$HeaderTbl.AutoScroll = $true
#$HeaderTbl.Controls.Add($DesktopPan)
$HeaderTbl.CellBorderStyle = 2
$HeaderTbl.Size = New-Object Size(1100,100)
$HeaderTbl.ColumnCount = 3
$HeaderTbl.RowCount = 3
$HeaderTbl.BackColor = 'pink'

$HeaderTblLbl1 = New-Object System.Windows.Forms.label
#$HeaderTblLbl1.Location = New-Object System.Drawing.size(520,-5)
#$HeaderTblLbl1.Size = New-Object System.Drawing.Size(250,20) 
$HeaderTblLbl1.Text = "فرم تعریف کالا" 
$HeaderTblLbl1.Font = 'Arial'
$HeaderTblLbl1.TextAlign=[System.Drawing.ContentAlignment]::TopRight  

$HeaderTblLbl2 = New-Object System.Windows.Forms.label
$HeaderTblLbl2.Text = ":شناسه" 
$HeaderTblLbl2.Font = 'Arial'
$HeaderTblLbl2.TextAlign=[System.Drawing.ContentAlignment]::TopLeft

$HeaderTblLbl3 = New-Object System.Windows.Forms.label
#$HeaderTblLbl1.Location = New-Object System.Drawing.size(520,-5)
#$HeaderTblLbl1.Size = New-Object System.Drawing.Size(250,20) 
$HeaderTblLbl3.Text = "WHE-FR-001-00" 
$HeaderTblLbl3.Font = 'Arial'
$HeaderTblLbl3.TextAlign=[System.Drawing.ContentAlignment]::TopRight

$HeaderTblDateLbl = New-Object System.Windows.Forms.label
$HeaderTblDateLbl.Text = ":تاریخ بازنگری" 
$HeaderTblDateLbl.Font = 'Arial'
$HeaderTblDateLbl.TextAlign=[System.Drawing.ContentAlignment]::TopLeft

$HeaderTblDateValueLbl = New-Object System.Windows.Forms.label
$HeaderTblDateValuelbl.Text = "1402-12-04" 
$HeaderTblDateValueLbl.Font = 'Arial'
$HeaderTblDateValueLbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight

$HeaderTblRefLbl = New-Object System.Windows.Forms.label
$HeaderTblRefLbl.Text = ":مرجع" 
$HeaderTblRefLbl.Font = 'Arial'
$HeaderTblRefLbl.TextAlign=[System.Drawing.ContentAlignment]::TopLeft

$HeaderTblRefValueLbl = New-Object System.Windows.Forms.label
$HeaderTblRefValuelbl.Text = "WHE-SOP-001-00" 
$HeaderTblRefvalueLbl.Font = 'Arial'
$HeaderTblRefValueLbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight

$HeaderTblNameLbl = New-Object System.Windows.Forms.label
$HeaderTblNamelbl.Text = "شرکت مهــــــدپــویـــــــان اطلــــــس" 
$HeaderTblNameLbl.Font = 'Arial'
#$HeaderTblNameLbl.TextAlign=[System.Drawing.ContentAlignment]::MiddleCenter

$Secoform.Controls.Add($MainTbl)
$MainTbl.Controls.Add($HeaderTbl)
#$HeaderTbl.Controls.Add($HeaderTblLbl1,2,2)
$HeaderTbl.Controls.Add($HeaderTblLbl2,1,0)
$HeaderTbl.Controls.Add($HeaderTblLbl3,0,0)
$HeaderTbl.Controls.Add($HeaderTblDateLbl,1,1)
$HeaderTbl.Controls.Add($HeaderTblDateValueLbl,0,1)
$HeaderTbl.Controls.Add($HeaderTblRefLbl,1,2)
$HeaderTbl.Controls.Add($HeaderTblRefValueLbl,0,2)
$HeaderTbl.Controls.Add($HeaderTblNameLbl,2,0)
$HeaderTbl.SetRowSpan($HeaderTblNameLbl,2)
#$HeaderTbl.SetRowSpan(2)

#$Secoform.Controls.Add($HeaderTbl)
    


[void]$Secoform.ShowDialog()   # display the dialog