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

$DesktopBtn                   = New-Object system.Windows.Forms.Button
$DesktopBtn.Anchor            = 'right'
$DesktopBtn.BackColor         = "#d2d4d6"
$DesktopBtn.text              = "میز کار"
$DesktopBtn.width             = 100
$DesktopBtn.height            = 50
#$AddPrinterBtn.location      = New-Object System.Drawing.Point(370,250)
$DesktopBtn.Font              = 'Microsoft Sans Serif,10'
$DesktopBtn.ForeColor         = "#000"
$DesktopBtn.Add_Click({

$textBox = New-Object System.Windows.Forms.Label
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$textBox.Text = 'test'

#$SecoForm.Controls.Add($textBox)

})
$PrjNameLB = $null
$PrjNameLB = New-Object System.Windows.Forms.Combobox 
$PrjNameLB.Location = New-Object System.Drawing.Size(10,50) 
$PrjNameLB.Size = New-Object System.Drawing.Size(100,20) 
$PrjNameLB.Height = 70
$PrjNameLB.AutoCompleteSource = 'ListItems'
$PrjNameLB.AutoCompleteMode = 'Append'
#$test = Import-Csv $PrjListPath | Select 'project name'
$PrjNameLB.Items.AddRange($ProjNames)
$PrjNameLB.Add_SelectedIndexChanged({
    $PrjFieldLB.Items.Clear()
    $PrjFieldLB.Text = $null
    $PrjCategLB.Items.Clear()
    $PrjCategLB.Text =  $null
    $PrjSubCategLB.Items.Clear()
    $PrjSubCategLB.Text =  $null
  #  $ProductsLB.Items.Clear()
 #   $ProductsLB.Text =  $null
    $ProjFields = Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)" -Directory | ForEach-Object{$_.Name}
    If ($ProjFields -ne $null)
    {
        $PrjFieldLB.Items.AddRange($ProjFields)
    }    
})
$PrjFieldLB = $null
$PrjFieldLB = New-Object System.Windows.Forms.Combobox 
$PrjFieldLB.Location = New-Object System.Drawing.Size(112,50) 
$PrjFieldLB.Size = New-Object System.Drawing.Size(100,20) 
$PrjFieldLB.Height = 70
$PrjFieldLB.AutoCompleteSource = 'ListItems'
$PrjFieldLB.AutoCompleteMode = 'Append'
#$PrjField = Import-Csv $PrjListPath | Select 'project name'
#$PrjFieldLB.Items.AddRange($PrjField.'Project Name')
$PrjFieldLB.Add_SelectedIndexChanged({
    $PrjCategLB.Items.Clear()
    $PrjCategLB.Text =  $null
    $PrjSubCategLB.Items.Clear()
    $PrjSubCategLB.Text =  $null
  #  $ProductsLB.Items.Clear()
 #   $ProductsLB.Text =  $null
    $PrjCateg = Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($PrjFieldLB.SelectedItem)" -Directory | ForEach-Object{$_.Name}
    If ($PrjCateg -ne $null)
    {
        $PrjCategLB.Items.AddRange($PrjCateg)
    }
})

$PrjCategLB = $null
$PrjCategLB = New-Object System.Windows.Forms.Combobox 
$PrjCategLB.Location = New-Object System.Drawing.Size(214,50) 
$PrjCategLB.Size = New-Object System.Drawing.Size(100,20) 
$PrjCategLB.Height = 70
$PrjCategLB.AutoCompleteSource = 'ListItems'
$PrjCategLB.AutoCompleteMode = 'Append'
#$PrjField = Import-Csv $PrjListPath | Select 'project name'
#$PrjFieldLB.Items.AddRange($PrjField.'Project Name')
$PrjCategLB.Add_SelectedIndexChanged({
    $PrjSubCategLB.Items.Clear()
    $PrjSubCategLB.Text =  $null
  #  $ProductsLB.Items.Clear()
 #   $ProductsLB.Text =  $null
    $PrjSubCateg = Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($PrjFieldLB.SelectedItem)\$($PrjCategLB.SelectedItem)" -Directory | ForEach-Object{$_.Name}
    If ($PrjSubCateg -ne $null)
    {
        $PrjSubCategLB.Items.AddRange($PrjSubCateg)
    }
})

$PrjSubCategLB = $null
$PrjSubCategLB = New-Object System.Windows.Forms.Combobox 
$PrjSubCategLB.Location = New-Object System.Drawing.Size(316,50) 
$PrjSubCategLB.Size = New-Object System.Drawing.Size(100,20) 
$PrjSubCategLB.Height = 70
$PrjSubCategLB.AutoCompleteSource = 'ListItems'
$PrjSubCategLB.AutoCompleteMode = 'Append'
#$PrjSubCategLB = Import-Csv $PrjListPath | Select 'project name'
#$PrjSubCategLB.Items.AddRange($PrjField.'Project Name')
$PrjSubCategLB.Add_SelectedIndexChanged({
<#
    $ProductsLB.Items.Clear()
    $ProductsLB.Text =  $null
    $Products = Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($PrjFieldLB.SelectedItem)\$($PrjCategLB.SelectedItem)\$($PrjSubCategLB.SelectedItem)" -Directory | ForEach-Object{$_.Name}
    If ($Products -ne $null)
    {
        $ProductsLB.Items.AddRange($Products)
    }
    #>
    
})
<#

$ProductsLB = $null
$ProductsLB = New-Object System.Windows.Forms.Combobox 
$ProductsLB.Location = New-Object System.Drawing.Size(418,50) 
$ProductsLB.Size = New-Object System.Drawing.Size(100,20) 
$ProductsLB.Height = 70
$ProductsLB.AutoCompleteSource = 'ListItems'
$ProductsLB.AutoCompleteMode = 'Append'
#$PrjSubCategLB = Import-Csv $PrjListPath | Select 'project name'
#$PrjSubCategLB.Items.AddRange($PrjField.'Project Name')
$ProductsLB.Add_SelectedIndexChanged({
    
})
#>
$DesktopGB = New-Object system.Windows.Forms.Groupbox
#$DesktopGB.Size = New-Object System.Drawing.Size(100,239)
$DesktopGB.Dock = [System.Windows.Forms.DockStyle]::Fill
$DesktopGB.AutoSize = $true

$DesktopGB.Text = 'test'


$DesktopGB.Controls.Add($ProductsLB)
$DesktopGB.Controls.Add($PrjSubCategLB)
$DesktopGB.Controls.Add($PrjCategLB)
$DesktopGB.Controls.Add($PrjFieldLB)
$DesktopGB.Controls.Add($PrjNameLB)
#$DesktopGB.Controls.Add($DesktopBtn)
$DesktopGB.Controls.Add($PrjCodeLB)


#$SecoForm.Controls.Add($textBox)

$SecoForm.Controls.Add($DesktopGB)

#$Secoform.AutoScale = $false
    [void] $SecoForm.ShowDialog()