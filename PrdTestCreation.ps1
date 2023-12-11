Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ProdRoot = "$env:comroot\Production\Projects\"
$ProjNames = Get-ChildItem -Path $ProdRoot -Directory | ForEach-Object{$_.Name}
$strCBPeopName = "Material Code"
[void] [System.Windows.Forms.Application]::EnableVisualStyles()
$persianCalendar = New-Object System.Globalization.PersianCalendar
$gregorianDate = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Now,"Iran Standard Time")
# Convert the Gregorian date to Shamsi (Jalali) calendar
$shamsiYear = $persianCalendar.GetYear($gregorianDate)
$shamsiMonth = $persianCalendar.GetMonth($gregorianDate)
$shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)

enum columnHeaders{
 MaterialCode = 1
 Ratio = 2
 Weightml = 3
 Commnets = 4
}

$ProdFolders = New-Object 'system.collections.generic.dictionary[string,boolean]'
$ProdFolders['Material Code'] = $true
$ProdFolders['Ratio %'] = $false
$ProdFolders['Weight ml'] = $true
$ProdFolders['Commnets'] = $true

$DGVColType = New-Object 'system.collections.generic.dictionary[string,string]'
$DGVColType['Material Code'] = 'System.Windows.Forms.DataGridViewComboBoxColumn'
$DGVColType['Ratio %'] = 'System.Windows.Forms.DataGridViewTextBoxColumn'
$DGVColType['Weight ml'] = 'System.Windows.Forms.DataGridViewTextBoxColumn'
$DGVColType['Comments'] = 'System.Windows.Forms.DataGridViewTextBoxColumn'

#$test = New-Object $DGVColType['Commnets']

$Secoform = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 800, 600
    Text          =            $shamsiYear.ToString() + "/" + 
                               ($shamsiMonth = $persianCalendar.GetMonth($gregorianDate)) + "/" + 
                               ( $shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)).ToString() + "`t`t`t`t`t`t`t`t`t`t" + "پارس طوبی تکیه" 
    Topmost       = $true
}

$DGVComboBox = New-Object system.Data.DataTable
$DGVColType.Keys | foreach{
$col = New-Object System.Data.DataColumn
$col.DataType = [string]
$col.ColumnName = $_
$DGVComboBox.Columns.Add($col)
}
#$DGVComboBox.Columns.Count
Import-Csv "D:\HST\Production\Projects\Ellie\Gel Nail Polish\Tests\PRF1El11 - copy3.csv" | foreach {
#$CSVColName = $objSource[0].PSobject.Properties.Name
<#
$DGVColType.Keys | select -ExpandProperty $strCBPeopName | Foreach {

}
#>

    $row = $DGVComboBox.NewRow() 
 #   $row.$strCBPeopName=$_
  #  $DGVComboBox.Rows.Add($row)
   foreach($column in $DGVColType.Keys)
    {
        $row.$column=$_.$column
    }
    $DGVComboBox.Rows.Add($row)
}

  
#    $DGVComboBox.Rows.Add($row)

#$col = $DGVColType['Commnets']

#    $col = New-Object System.Data.DataColumn
#    $col = $DGVColType['Commnets']
 #   $col.DataType = [string]

#    $EmailGV.Rows.Add($_.from,$_.subject,$_.time) | out-null
#    $EmailGV.Rows.Add($_.item[0].value) | out-    

Function funDisAllCB{
    $ProdFolders.Keys | % {
        $thisKey = $_
        $thisCB = $DesktopGB.Controls | Where-Object {$_.Name -eq  $thisKey}      
        If ($thisCB -ne $null){ $thisCB.Dispose()}       
    } 
  #  $EmailGV.Rows.Clear()
    $DesktopBtn.Enabled = $false
}

Function funCBChUNch{
    $bolfunCBChUNch = $false   
    Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)" -Directory | foreach {       
        $thisCB = $_.Name
        $thisCB = $DesktopGB.Controls | Where-Object {$_.Name -eq $thisCB}
        If ($thisCB.Checked){$bolfunCBChUNch = $true}    
    }
 #   $EmailGV.Rows.Clear()
    If ($bolfunCBChUNch)
    {$DesktopBtn.Enabled = $true}
    Else
    {$DesktopBtn.Enabled = $false}
}

Function funShowInfo{
 #   $EmailGV.rows.Clear()
    $intIncre = 0
    Import-Csv -Path "D:\HST\Production\Projects\Ellie\Gel Nail Polish\Tests\PRF1El11 - copy3.csv" | foreach {       
   
    }
     $EmailGV.Rows.Add($_.'Material Code',$_.name,$Date,$keys,$intIncre)
}

$ProdLB_DrawItem={
 param(
  [System.Object] $sender, 
  [System.Windows.Forms.DrawItemEventArgs] $e
 )
   #Suppose Sender de type Listbox
 if ($Sender.Items.Count -eq 0) {return}
 
   #Suppose item de type String
 $lbItem=$Sender.Items[$e.Index]
 #[System.Windows.Forms.ControlPaint]::DrawCheckBox($e.Graphics,$e.Bounds.X, $e.Bounds.Top + 1, 15, 15, [System.Windows.Forms.ButtonState]::Checked)
 #[System.Windows.Forms.ControlPaint]::DrawButton($e.Graphics,$e.Bounds.X, $e.Bounds.Top + 1, 15, 15)
 [System.Windows.Forms.ControlPaint]::DrawLabel($e.Graphics,$e.Bounds.X, $e.Bounds.Top + 1, 15, 15,[System.Windows.Forms.ButtonState]::Checked)
 #[System.Windows.Forms.ControlPaint]::DrawCheckBox()
 #if ( $lbItem -match 'locked$')  
 #{ 
 
    If ($e.Index -lt 8)
    {
        $Color=[System.Drawing.Color]::green       
    }
    Else
    {
        $Color=[System.Drawing.Color]::red       
    }
    try
    {

      $brush = new-object System.Drawing.SolidBrush($Color)
      $test = $lbItem.length
  #    $e.Graphics.FillRectangle($brush, $e.Bounds)
  <#
   If($lbItem -contains 'Gholamreza')
   {
        $e.Graphics.DrawImage($Gh,0,$e.Bounds.Y+2.5,25,25)
         $e.Graphics.FillEllipse($brush,18,$e.Bounds.Y+21,8,8)
   }
   Else
   {
        $e.Graphics.DrawImage($avatar,0,$e.Bounds.Y+2.5,25,25)
   } 
   #>
 #     $e.Graphics.DrawImage($GH,0,$e.Bounds.Y+2.5,30,30)
#     $e.Graphics.DrawImage($circlepath,0,$e.Bounds.Y+2.5,30,30)
        
    }
    finally
    {
      $brush.Dispose()
    }
  # }
 #$e.Graphics.DrawString($lbItem, $e.Font, [System.Drawing.SystemBrushes]::ControlText, (new-object System.Drawing.PointF($e.Bounds.X, $e.Bounds.Y)))
 $Yp = ($e.Bounds.Y) + 18 
 $e.Graphics.DrawString($lbItem, $e.Font, [System.Drawing.SystemBrushes]::ControlText, (new-object System.Drawing.PointF(25, $Yp)))
 
}



$ProdLB = New-Object System.Windows.Forms.ListBox
$ProdLB.Location = New-Object System.Drawing.Point(50,100)
$ProdLB.Size = New-Object System.Drawing.Size(700,400)
$ProdLB.Height = 400
$ProdLB.FormattingEnabled = $True

$ProdLB.TabIndex = 4
$ProdLB.DrawMode = [System.Windows.Forms.DrawMode]::OwnerDrawFixed
$ProdLB.DataBindings.DefaultDataSourceUpdateMode = 0
$ProdLB.ItemHeight = 20


        $ListBoxCB = New-Object System.Windows.Forms.CheckBox
        $ListBoxCB.Text = 'sdfsdf'
  #      $ListBoxCB.Size = 20
#        $ProdLB.Controls.Add($ListBoxCB)
                $ListBoxtB = New-Object System.Windows.Forms.TextBox
        $ListBoxtB.Text = 'sdfsdf'
  #      $ListBoxCB.Size = 20
 #       $ProdLB.Controls.Add($ListBoxtB)
#$ProdLB.Add_DrawItem($ProdLB_DrawItem)
#$ProdLB.add_Click($action_si_click_sur_VMKO)
[void] $ProdLB.Items.Add('sdfsdfsdf')
<#
[void] $ProdLB.Items.Add('User1')
[void] $ProdLB.Items.Add('Ali')
[void] $ProdLB.Items.Add('User3')
[void] $ProdLB.Items.Add('tesduser')
[void] $ProdLB.Items.Add('chatuser')
[void] $ProdLB.Items.Add('group')
[void] $ProdLB.Items.Add('user12')
[void] $ProdLB.Items.Add('offile')
[void] $ProdLB.Items.Add('usr5')
[void] $ProdLB.Items.Add('echo')
[void] $ProdLB.Items.Add('noname')
[void] $ProdLB.Items.Add('noname')
[void] $ProdLB.Items.Add('noname')
[void] $ProdLB.Items.Add('noname')
[void] $ProdLB.Items.Add('noname')
#>

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

$DataTable2 = New-Object System.Data.DataTable
[void] $DataTable2.Columns.Add("RGB")
[void] $DataTable2.Columns.Add("Color")
# Manually add rows. You can programmatically add the rows as well 
[void] $DataTable2.Rows.Add("ff0000", "red")
[void] $DataTable2.Rows.Add("00ff00", "green")
[void] $DataTable2.Rows.Add("0000ff", "blue")

$EmailGV = $null
$EmailGV = New-Object System.Windows.Forms.DataGridView
$EmailGV.Location = New-Object System.Drawing.size(100,150)
#$EmailGV.ColumnCount = ([columnHeaders].GetEnumNames()).Length
$EmailGV.RowHeadersVisible = $false
$EmailGV.SelectionMode = 'FullRowSelect'
$EmailGV.AllowUserToResizeColumns = $false
$EmailGV.AllowUserToResizeRows = $false

$HeaderWidth = 0
$DGVColType.Keys | foreach {

$col = New-Object $DGVColType[$_]
$col.HeaderText = $_
$col.DataPropertyName = $_
$HeaderWidth = $HeaderWidth + ($_.Length * 15)
$col.Width = ($_.Length * 15)
If ($_ -eq 'material code')
{
    $col.DataSource = $DGVComboBox
    $col.ValueMember = $_
    $col.DisplayMember = $_
}
$EmailGV.columns.Add($col )

}

<#
$ProdFolders.Keys | foreach {
$test = $($ProdFolders.Keys).IndexOf($_)
    $EmailGV.Columns[$test].HeaderText = $_
    $HeaderWidth = $HeaderWidth + ($_.Length * 15)
    $EmailGV.Columns[$test].Width = $_.Length *15
   
 #  $EmailGV.Columns[$test].CellType = 'DataGridViewComboBoxColumn'
    $EmailGV.Columns[$test].ValueType.Name
    $test = $ProdFolders[$_]
    $EmailGV.Columns[$ProdFolders[$_]].ReadOnly = $ProdFolders[$_] 
}
#>

$HeaderWidth = $HeaderWidth + 3 
$EmailGV.Size=New-Object System.Drawing.Size($HeaderWidth,350)
$EmailGV.AllowUserToAddRows = $false
$EmailGV.ReadOnly = $false
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
$EmailGV.DataSource = $DGVComboBox 
<#
$str = $null
Import-Csv -Path "D:\HST\Production\Projects\Ellie\Gel Nail Polish\Tests\PRF1El11 - copy3.csv" | foreach {  
$test = $_ 
#$DGVColType.Keys -join ','
$DGVColType.Keys | foreach {
    If ($str -eq $null)
    {
        $str = $test.$_
    }
    Else
    {
        $str = "$str,$($test.$_)"
    }
}
    Try
    {
        
  #     [void]$EmailGV.Rows.Add($_.'Material Code',$_.'Ratio %',$_.'Weight ml',$_.'Comments')
   #    [void]$EmailGV.Rows.Add( ($DGVColType.Keys -join ','))
      
 #      [void]$EmailGV.Rows.Add($str)
        
       }
    Catch
    {
        Write-Host $_.ScriptStackTrace
    }
}
 #>  

#$EmailGV.Rows.Add('sdfsd',$ListBoxtB,$Date,$keys,$intIncre,'sdsdf','sdfsdf')
#$EmailGV.columns.Item(1)


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
    Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)" -Directory | foreach {
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
$GBLbl.Text = "ایجاد و تغییر آزمایش برای محصولات جدید" 
$GBLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomright

$DesktopGB = New-Object system.Windows.Forms.Groupbox
$DesktopGB.Size = New-Object System.Drawing.Size(500,550)
#$DesktopGB.Dock = [System.Windows.Forms.DockStyle]::Fill
$DesktopGB.AutoSize = $true
#$DesktopGB.BackColor = 'red'

$DesktopGB.Controls.Add($GBLbl)
$DesktopGB.Controls.Add($ProdLbl)
$DesktopGB.Controls.Add($ProjLbl)
#$DesktopGB.Controls.Add($ProdLB)
$DesktopGB.Controls.Add($EmailGV)
$DesktopGB.Controls.Add($ProdCatLB)
$DesktopGB.Controls.Add($PrjNameLB)
#$DesktopGB.Controls.Add($DesktopBtn)

$SecoForm.Controls.Add($DesktopGB)

$SecoForm.Add_Shown({funDisAllCB})
[void] $SecoForm.ShowDialog()