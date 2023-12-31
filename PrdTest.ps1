﻿Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ProdRoot = "$env:comroot\Production\Projects\"
$ProjNames = Get-ChildItem -Path $ProdRoot -Directory | ForEach-Object{$_.Name}
[void] [System.Windows.Forms.Application]::EnableVisualStyles()
$persianCalendar = New-Object System.Globalization.PersianCalendar
$gregorianDate = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Now,"Iran Standard Time")
# Convert the Gregorian date to Shamsi (Jalali) calendar
$shamsiYear = $persianCalendar.GetYear($gregorianDate)
$shamsiMonth = $persianCalendar.GetMonth($gregorianDate)
$shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)

enum columnHeaders{
 ردیف = 5
 مرحله = 4
 تاریخ = 3
 شناسه = 2
 وضعیت = 1
}

$ProdFolders = New-Object 'system.collections.generic.dictionary[string,string]'
$ProdFolders['Tests'] = 'آزمایش'
$ProdFolders['RemProd'] = 'محصول حذف شده'
$ProdFolders['Products'] = 'محصول'
$ProdFolders['DisTests'] = 'آزمایش ابطال شده'

$Secoform = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 800, 600
    Text          =            $shamsiYear.ToString() + "/" + 
                               ($shamsiMonth = $persianCalendar.GetMonth($gregorianDate)) + "/" + 
                               ( $shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)).ToString() + "`t`t`t`t`t`t`t`t`t`t" + "پارس طوبی تکیه" 
    Topmost       = $true
}
$ProdFolders.Keys -contains 'tests'

Function funDisAllCB{
    $ProdFolders.Keys | % {
        $thisKey = $_
        $thisCB = $DesktopGB.Controls | Where-Object {$_.Name -eq  $thisKey}      
        If ($thisCB -ne $null){ $thisCB.Dispose()}       
    } 
    $EmailGV.Rows.Clear()
    $DesktopBtn.Enabled = $false
}

Function funCBChUNch{
    $bolfunCBChUNch = $false   
    Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)" -Directory | foreach {       
        $thisCB = $_.Name
        $thisCB = $DesktopGB.Controls | Where-Object {$_.Name -eq $thisCB}
        If ($thisCB.Checked){$bolfunCBChUNch = $true}    
    }
    $EmailGV.Rows.Clear()
    If ($bolfunCBChUNch)
    {$DesktopBtn.Enabled = $true}
    Else
    {$DesktopBtn.Enabled = $false}
}

Function funShowInfo{
    $EmailGV.rows.Clear()
    $intIncre = 0
    Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)" -Directory | foreach {       
        $thisFol = $_.Name
        $thisCB = $DesktopGB.Controls | Where-Object {$_.Name -eq $thisFol}        
        If ($thisCB.Checked)
        {
             Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$($_.Name)" -file  | foreach {
                    $intIncre = $intIncre + 1
                    $latestchange = $null
                    $Date = $null
                    Import-Csv $_.FullName | select -ExpandProperty 'latest change' | foreach {
                        If ($_ -ne $null ){$keys = $_}
                    }
                    Import-Csv $_.FullName | select -ExpandProperty 'date' | foreach {
                        If ($_ -ne $null ){$Date = $_}
                    }                                      
                    $EmailGV.Rows.Add($ProdFolders[$thisFol],$_.name,$Date,$keys,$intIncre)
                }

        }    
    }
}

$DesktopBtn = New-Object system.Windows.Forms.Button
$DesktopBtn.Location = New-Object System.Drawing.Size(630,100) 
$DesktopBtn.BackColor = "#d2d4d6"
$DesktopBtn.text = "نمایش اطلاعات"
$DesktopBtn.width = 120
$DesktopBtn.height = 30
$DesktopBtn.Font = 'Microsoft Sans Serif,10'
$DesktopBtn.ForeColor = "#000"
$DesktopBtn.Enabled = $false
$DesktopBtn.Add_Click({funShowInfo})

$PrjNameLB = $null
$PrjNameLB = New-Object System.Windows.Forms.Combobox 
$PrjNameLB.Location = New-Object System.Drawing.Size(650,40) 
$PrjNameLB.Size = New-Object System.Drawing.Size(100,20) 
$PrjNameLB.Height = 70
$PrjNameLB.AutoCompleteSource = 'ListItems'
$PrjNameLB.AutoCompleteMode = 'Append'

$PrjNameLB.Items.AddRange($ProjNames)
$PrjNameLB.Add_SelectedIndexChanged({
    $ProdCatLB.Items.Clear()
    $ProdCatLB.Text = $null
    $ProdType = Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)" -Directory | ForEach-Object{$_.Name}
    If ($ProdType -ne $null)
    {
        $ProdCatLB.Items.AddRange($ProdType)
    }  
    $ProdCatLB.Enabled = $true 
    funDisAllCB 
})

$EmailGV = $null
$EmailGV = New-Object System.Windows.Forms.DataGridView
$EmailGV.Location = New-Object System.Drawing.size(100,150)
$EmailGV.ColumnCount = ([columnHeaders].GetEnumNames()).Length
$EmailGV.RowHeadersVisible = $false
$EmailGV.SelectionMode = 'FullRowSelect'
$EmailGV.AllowUserToResizeColumns = $false
$EmailGV.AllowUserToResizeRows = $false
$HearderWidth = 0
[columnHeaders].GetEnumNames() | foreach {
$test = ([int]([columnHeaders]::$_)-1)
    $EmailGV.Columns[$test].HeaderText = $_
    $HearderWidth = $HearderWidth + ($_.Length * 25)
    $EmailGV.Columns[$test].Width = $_.Length * 25
}
$HearderWidth = $HearderWidth + 3 
$EmailGV.Size=New-Object System.Drawing.Size($HearderWidth,350)
$EmailGV.AllowUserToAddRows = $false
$EmailGV.ReadOnly = $true
$EmailGV.ReadOnly = $true
$EmailGV.ColumnHeadersDefaultCellStyle.Alignment = [System.Drawing.ContentAlignment]::MiddleCenter
$EmailGV.DefaultCellStyle.Alignment = [System.Drawing.ContentAlignment]::bottomright
$EmailGV.AllowUserToOrderColumns = $false
$EmailGV.RowHeadersWidthSizeMode = 1
#$EmailGV.AutoSizeRowsMode = $false
$EmailGV.ColumnHeadersHeightSizeMode = 1
$EmailGV.EnableHeadersVisualStyles = $false
#$EmailGV.DefaultCellStyle.SelectionBackColor= $EmailGV.DefaultCellStyle.BackColor
#$EmailGV.DefaultCellStyle.SelectionForeColor= $EmailGV.DefaultCellStyle.ForeColor
$EmailGV.ColumnHeadersDefaultCellStyle.SelectionBackColor='window'
#$EmailGV.AutoSizeRowsMode = $false
$EmailGV.ColumnHeadersHeightSizeMode = 1
foreach ($datagridviewcolumn in $EmailGV.columns) {
    $datagridviewcolumn.sortmode = 0
}

$ProdCatLB = $null
$ProdCatLB = New-Object System.Windows.Forms.Combobox 
$ProdCatLB.Location = New-Object System.Drawing.Size(545,40) 
$ProdCatLB.Size = New-Object System.Drawing.Size(100,20) 
$ProdCatLB.Height = 70
$ProdCatLB.AutoCompleteSource = 'ListItems'
$ProdCatLB.AutoCompleteMode = 'Append'
$ProdCatLB.Enabled = $false
$ProdCatLB.Add_SelectedIndexChanged({
    $intIncr = 0
    Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)" -Directory | 
    Where-Object {$ProdFolders.Keys -Contains $_.Name} |  foreach {
        $intIncr = $intIncr + 1
        New-Variable -Force -Name $_.Name -Value (New-Object System.Windows.Forms.CheckBox)
        $thisCB = Get-Variable -ValueOnly -Include $_.Name
        $thisCB.Location = New-Object System.Drawing.Size((270+110*$intIncr),70)
        $thisCB.Size = New-Object System.Drawing.Size(($ProdFolders[$_.Name].Length+90),23)
        $thisCB.Text =  $ProdFolders[$_.Name]
        $thisCB.Name =  $_.Name
        $thisCB.Add_CheckStateChanged({funCBChUNch}.GetNewClosure())
#       Alternative way of adding a function
#       $thisCB.Add_CheckStateChanged({param($Sender,$EventArgs) Write-Host $Sender.Text})
        $DesktopGB.Controls.Add($thisCB)  
        
    }
})

$ProjLbl = New-Object System.Windows.Forms.label
$ProjLbl.Location = New-Object System.Drawing.size(700,20)
$ProjLbl.Size = New-Object System.Drawing.Size(50,20) 
$ProjLbl.Text = ":نام برند" 
$ProjLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomright

$ProdLbl = New-Object System.Windows.Forms.label
$ProdLbl.Location = New-Object System.Drawing.size(565,20)
$ProdLbl.Size = New-Object System.Drawing.Size(80,20) 
$ProdLbl.Text = ":نوع محصول" 
$ProdLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomright

$GBLbl = New-Object System.Windows.Forms.label
$GBLbl.Location = New-Object System.Drawing.size(520,-5)
$GBLbl.Size = New-Object System.Drawing.Size(250,20) 
$GBLbl.Text = "نمایش و دسترسی به محصولات در حال آزمایش و باطل شده ها" 
$GBLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomright

$DesktopGB = New-Object system.Windows.Forms.Groupbox
$DesktopGB.Size = New-Object System.Drawing.Size(500,300)
#$DesktopGB.Dock = [System.Windows.Forms.DockStyle]::Fill
$DesktopGB.AutoSize = $true

$DesktopGB.Controls.Add($GBLbl)
$DesktopGB.Controls.Add($ProdLbl)
$DesktopGB.Controls.Add($ProjLbl)
$DesktopGB.Controls.Add($EmailGV)
$DesktopGB.Controls.Add($ProdCatLB)
$DesktopGB.Controls.Add($PrjNameLB)
$DesktopGB.Controls.Add($DesktopBtn)

$SecoForm.Controls.Add($DesktopGB)

$SecoForm.Add_Shown({funDisAllCB})
[void] $SecoForm.ShowDialog()