Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#$PrjListPath = "$env:comroot\Secretary\Master\Projects.csv"
$ProdRoot = "$env:comroot\Production\Projects\"
$ProjNames = Get-ChildItem -Path $ProdRoot -Directory | ForEach-Object{$_.Name}
#$ProjFields = Get-ChildItem -Path "$ProdRoot\$ProjNames" -Directory | ForEach-Object{$_.Name}
#$ProjCateg = Get-ChildItem -Path "$ProdRoot\$ProjNames" -Directory | ForEach-Object{$_.Name}
[void] [System.Windows.Forms.Application]::EnableVisualStyles()
$persianCalendar = New-Object System.Globalization.PersianCalendar
$gregorianDate = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Now,"Iran Standard Time")
# Convert the Gregorian date to Shamsi (Jalali) calendar
$shamsiYear = $persianCalendar.GetYear($gregorianDate)
$shamsiMonth = $persianCalendar.GetMonth($gregorianDate)
$shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)

$Secoform = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 800, 600
    Text          =            $shamsiYear.ToString() + "/" + 
                               ($shamsiMonth = $persianCalendar.GetMonth($gregorianDate)) + "/" + 
                               ( $shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)).ToString() + "`t`t`t`t`t`t`t`t`t`t" + "پارس طوبی تکیه" 
    Topmost       = $true
}

$DesktopBtn = New-Object system.Windows.Forms.Button
$DesktopBtn.Location = New-Object System.Drawing.Size(630,100) 
$DesktopBtn.BackColor = "#d2d4d6"
$DesktopBtn.text = "نمایش اطلاعات"
$DesktopBtn.width = 120
$DesktopBtn.height = 30
$DesktopBtn.Font = 'Microsoft Sans Serif,10'
$DesktopBtn.ForeColor = "#000"
$DesktopBtn.Add_Click({

    $EmailGV.rows.Clear()
    If ($DiscardCB.Checked)
    {
         Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdTypeLB.SelectedItem)\Discarded" -file  | foreach {
         $EmailGV.Rows.Add('باطل شده',$_.name)
    
    }
    }
    If ($TestCB.Checked)
    {
        Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdTypeLB.SelectedItem)\Tests" -file  | foreach {
         $EmailGV.Rows.Add('در حال تست',$_.name)
    }
    }

})
$PrjNameLB = $null
$PrjNameLB = New-Object System.Windows.Forms.Combobox 
$PrjNameLB.Location = New-Object System.Drawing.Size(650,40) 
$PrjNameLB.Size = New-Object System.Drawing.Size(100,20) 
$PrjNameLB.Height = 70
$PrjNameLB.AutoCompleteSource = 'ListItems'
$PrjNameLB.AutoCompleteMode = 'Append'
#$test = Import-Csv $PrjListPath | Select 'project name'
$PrjNameLB.Items.AddRange($ProjNames)
$PrjNameLB.Add_SelectedIndexChanged({
    $ProdTypeLB.Items.Clear()
    $ProdTypeLB.Text = $null
    $ProdType = Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)" -Directory | ForEach-Object{$_.Name}
    If ($ProdType -ne $null)
    {
        $ProdTypeLB.Items.AddRange($ProdType)
    }    
})

$EmailGV = $null
$EmailGV = New-Object System.Windows.Forms.DataGridView
$EmailGV.Size=New-Object System.Drawing.Size(595,350)
$EmailGV.Location = New-Object System.Drawing.size(150,150)
$EmailGV.ColumnCount = 2
$EmailGV.Columns[1].width = 492
$EmailGV.Columns[0].width =100
$EmailGV.RowHeadersVisible = $false
#$EmailGV.ColumnHeadersVisible = $false
$EmailGV.SelectionMode = 'FullRowSelect'
$EmailGV.AllowUserToResizeColumns = $false
$EmailGV.AllowUserToResizeRows = $false
$EmailGV.Columns[1].HeaderText = 'شناسه'
$EmailGV.Columns[0].HeaderText = 'وضعیت'
$EmailGV.AllowUserToAddRows = $false
$EmailGV.ReadOnly = $true
$EmailGV.ColumnHeadersDefaultCellStyle.Alignment = [System.Drawing.ContentAlignment]::MiddleCenter
$EmailGV.DefaultCellStyle.Alignment = [System.Drawing.ContentAlignment]::bottomright
$EmailGV.AllowUserToOrderColumns = $false
$EmailGV.RowHeadersWidthSizeMode = 1
#$EmailGV.AutoSizeRowsMode = $false
$EmailGV.ColumnHeadersHeightSizeMode = 1
foreach ($datagridviewcolumn in $EmailGV.columns) {
    $datagridviewcolumn.sortmode = 0
}
$EmailGV.rowh



#$EmailGV.header = [System.Drawing.ContentAlignment]::bottomright

$ProdTypeLB = $null
$ProdTypeLB = New-Object System.Windows.Forms.Combobox 
$ProdTypeLB.Location = New-Object System.Drawing.Size(545,40) 
$ProdTypeLB.Size = New-Object System.Drawing.Size(100,20) 
$ProdTypeLB.Height = 70
$ProdTypeLB.AutoCompleteSource = 'ListItems'
$ProdTypeLB.AutoCompleteMode = 'Append'
$ProdTypeLB.Add_SelectedIndexChanged({

})

$ProductsLB = New-Object System.Windows.Forms.Combobox 
$ProductsLB.Location = New-Object System.Drawing.Size(418,30) 
$ProductsLB.Size = New-Object System.Drawing.Size(100,20) 
$ProductsLB.Height = 70
$ProductsLB.AutoCompleteSource = 'ListItems'
$ProductsLB.AutoCompleteMode = 'Append'
#$PrjSubCategLB = Import-Csv $PrjListPath | Select 'project name'
#$PrjSubCategLB.Items.AddRange($PrjField.'Project Name')
$ProductsLB.Add_SelectedIndexChanged({
    
})
#>

$TestCB = New-Object System.Windows.Forms.CheckBox
$TestCB.Location = New-Object System.Drawing.size(710,70)
$TestCB.Size = New-Object System.Drawing.Size(80,20) 
$TestCB.Text = "تستها"

$DiscardCB = New-Object System.Windows.Forms.CheckBox
$DiscardCB.Location = New-Object System.Drawing.size(630,70)
$DiscardCB.Size = New-Object System.Drawing.Size(80,20)
$DiscardCB.Text = "باطل ها"

$ProjLbl = New-Object System.Windows.Forms.label
$ProjLbl.Location = New-Object System.Drawing.size(700,20)
$ProjLbl.Size = New-Object System.Drawing.Size(50,20) 
$ProjLbl.Text = ":نام پروژه" 
$ProjLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomright

$ProdLbl = New-Object System.Windows.Forms.label
$ProdLbl.Location = New-Object System.Drawing.size(565,20)
$ProdLbl.Size = New-Object System.Drawing.Size(80,20) 
$ProdLbl.Text = ":نوع محصول" 
$ProdLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomright

$GBLbl = New-Object System.Windows.Forms.label
$GBLbl.Location = New-Object System.Drawing.size(520,-5)
$GBLbl.Size = New-Object System.Drawing.Size(250,20) 
$GBLbl.Text = "نمایش و دسترسی به محصولات در حال تست و باطل شده ها" 
$GBLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomright

$DesktopGB = New-Object system.Windows.Forms.Groupbox
$DesktopGB.Size = New-Object System.Drawing.Size(500,300)
#$DesktopGB.Dock = [System.Windows.Forms.DockStyle]::Fill
$DesktopGB.AutoSize = $true

$DesktopGB.Controls.Add($GBLbl)
$DesktopGB.Controls.Add($ProdLbl)
$DesktopGB.Controls.Add($ProjLbl)
$DesktopGB.Controls.Add($EmailGV)
$DesktopGB.Controls.Add($TestCB)
$DesktopGB.Controls.Add($DiscardCB)
$DesktopGB.Controls.Add($ProdTypeLB)
$DesktopGB.Controls.Add($PrjNameLB)
$DesktopGB.Controls.Add($DesktopBtn)
#$DesktopGB.Controls.Add($PrjCodeLB)


#$SecoForm.Controls.Add($textBox)

$SecoForm.Controls.Add($DesktopGB)

#$Secoform.AutoScale = $false
    [void] $SecoForm.ShowDialog()