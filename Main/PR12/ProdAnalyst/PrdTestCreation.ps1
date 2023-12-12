
. "$(Split-Path $PSScriptRoot -Parent)\config\$(($PSCommandPath.Split('\') | select -last 1) -replace ('.ps1$','var.ps1'))"

$DGVCBInfo = New-Object system.Data.DataTable
$DGVCBInfoVer = gci "$confRoot\$ConFol" -file | Foreach{
  $_ -replace '^PRF', ''
  } | Select-Object *, @{ n = "IntVal"; e = {[int]($_)}} | Sort-Object IntVal | Select-Object -Last 1

$DGVCBInfoCol = @()
(Get-Content "$confRoot\$ConFol\$ConFol$($DGVCBInfoVer.IntVal)" | select -First 1) -split "," | foreach {
$DGVCBInfoCol += $_
$col2 = New-Object System.Data.DataColumn
$col2.DataType = [string]
$col2.ColumnName = $_
$DGVCBInfo.Columns.Add($col2)
}

Import-Csv "$confRoot\$ConFol\$ConFol$($DGVCBInfoVer.IntVal)" |  foreach {
    $row2 = $DGVCBInfo.NewRow() 
    foreach($column in $DGVCBInfoCol){
        $row2.$column=$_.$column
    }
    [void]$DGVCBInfo.Rows.Add($row2)
}


$DGVCBColumn = New-Object system.Data.DataTable
[void]$DGVCBColumn.Columns.Add($strCBPeopName)
Import-Csv "D:\HST\Production\Material Info\SUI1PR121.csv" | Select -ExpandProperty $strCBPeopName | foreach {
[void]$DGVCBColumn.Rows.Add($_)

}


<#
$DGVColType.Keys | foreach{
$col = New-Object System.Data.DataColumn
$col.DataType = [string]
$col.ColumnName = $_
$DGVDataTab.Columns.Add($col)
}
#>
#$DGVDataTab.Columns.Count

  
#    $DGVDataTab.Rows.Add($row)

#$col = $DGVColType['Commnets']

#    $col = New-Object System.Data.DataColumn
#    $col = $DGVColType['Commnets']
 #   $col.DataType = [string]

#    $EmailGV.Rows.Add($_.from,$_.subject,$_.time) | out-null
#    $EmailGV.Rows.Add($_.item[0].value) | out-   

$SecoForm.Add_Closing({param($sender,$e)
<#
    $result = [System.Windows.Forms.MessageBox]::Show(`
        "Are you sure you want to exit?", `
        "Close", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    if ($result -ne [System.Windows.Forms.DialogResult]::Yes)
    {
        $e.Cancel= $true
    }
#>
})

Function funNewRBClick{
    $ProdLB.Enabled = $false
    $DesktopBtn.Enabled = $true
    $ProdLB.Items.Clear()
    $ProdLB.Text = $null
    $EmailGV.Enabled = $false 
    If ($EmailGV.Rows.Count -gt 0){
        $DGVDataTab.Clear()
    }
} 

Function funOldRBClick{
    $ProdLB.Enabled = $true
    $DesktopBtn.Enabled = $false
    $ProdLB.Items.Clear()
    $ProdLB.Text = $null
    $EmailGV.Enabled = $false 
    $PRFFiles = (Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests" -File | ForEach-Object{$_.Name}).TrimEnd($FileExt)
    If ($PRFFiles -ne $null)
    {
        $ProdLB.Items.AddRange($PRFFiles)
    } 
} 

Function funDisAllCB{
    $NewRB.Checked = $false
    $OldRB.Checked = $false
  #  $EmailGV.Rows.Clear()
    $DesktopBtn.Enabled = $false
    $ProdLB.Enabled = $false
    $ProdLB.Items.Clear()
    $ProdLB.Text = $null
    $RBGroup.Enabled = $false
    $TotPercentIB.Text = $null
    $TotMlIB.Text = $null
    $EmailGV.Enabled = $false
    $TotLbl.Visible = $false
    $TotPercentIB.Visible = $false
    $TotMlIB.Visible = $false 
    If ($EmailGV.Rows.Count -gt 0){
        $DGVDataTab.Clear()
    }
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
<#
 #   $EmailGV.rows.Clear()
    $intIncre = 0
    Import-Csv -Path "D:\HST\Production\Projects\Ellie\Gel Nail Polish\$FolderNameTests\PRF1El11 - copy3.csv" | foreach {       
   
    }
     $EmailGV.Rows.Add($_.'Material Code',$_.name,$Date,$keys,$intIncre)
#>
    $EmailGV.Enabled = $true
    $TotLbl.Visible = $true
    $TotPercentIB.Visible = $true
    $TotMlIB.Visible = $true
    If ($NewRB.Checked){
        $ToNatural = {[regex]::Replace($_, '^[A-Za-z]*\d*[A-Za-z]*(\d+).csv', '$1')} 
        $NewFileName  = gci "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests" -file | sort $ToNatural | select -First 1
         $test
    }
    Else
    {
        Import-Csv "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests\$($ProdLB.SelectedItem)$fileExt" | foreach {
            $row = $DGVDataTab.NewRow() 
            foreach($column in $DGVDataTab.Columns)
            {            
                $row.($column.columnname)=$_.($column.columnname)
            }
            $DGVDataTab.Rows.Add($row)
        }
    }
}

Function funDeskBtnClick{

}

<#
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
  
   If($lbItem -contains 'Gholamreza')
   {
        $e.Graphics.DrawImage($Gh,0,$e.Bounds.Y+2.5,25,25)
         $e.Graphics.FillEllipse($brush,18,$e.Bounds.Y+21,8,8)
   }
   Else
   {
        $e.Graphics.DrawImage($avatar,0,$e.Bounds.Y+2.5,25,25)
   } 
   
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
#>


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
$DesktopBtn.Location = New-Object System.Drawing.Size(632,110) 
$DesktopBtn.BackColor = "#d2d4d6"
$DesktopBtn.text = "اجرای انتخابهای بالا"
$DesktopBtn.width = 120
$DesktopBtn.height = 35
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

$DGVDataTab = New-Object system.Data.DataTable
foreach($row3 in $DGVCBInfo){
    $colDT = New-Object System.Data.DataColumn
    $colDT.DataType = [string]
    $colDT.ColumnName = $row3.Name
    $DGVDataTab.Columns.Add($colDT)
    $col = New-Object $row3.Type
    $col.HeaderText = $row3.Name
    $col.DataPropertyName = $row3.Name
    $HeaderWidth = $HeaderWidth + $row3.SizeX
    $col.Width = $row3.SizeX
    $col.DefaultCellStyle.Alignment = $row3.Alignment
    If ($row3.Type -eq 'System.Windows.Forms.DataGridViewComboBoxColumn'){
        $col.DataSource = $DGVCBColumn
        $col.ValueMember = $row3.Name
        $col.DisplayMember = $row3.Name
    }
    [void]$EmailGV.columns.Add($col)
}

<#
$HeaderWidth = 0
$DGVColType.Keys | foreach {
    $col = New-Object $DGVColType[$_]
    $col.HeaderText = $_
    $col.DataPropertyName = $_
    $HeaderWidth = $HeaderWidth + ($_.Length * 15)
    $col.Width = ($_.Length * 15)
    If ($_ -eq $strCBPeopName){
       $col.DataSource = $DGVCBColumn

  #      $col.DataSource = $test
        $col.ValueMember = $_
        $col.DisplayMember = $_
    }
    [void]$EmailGV.columns.Add($col)
}
#>
$HeaderWidth = $HeaderWidth + 3 
$EmailGV.Size=New-Object System.Drawing.Size($HeaderWidth,350)
$EmailGV.AllowUserToAddRows = $true
$EmailGV.ReadOnly = $false
$EmailGV.ColumnHeadersDefaultCellStyle.Alignment = [System.Drawing.ContentAlignment]::MiddleCenter
#$EmailGV.DefaultCellStyle.Alignment = [System.Drawing.ContentAlignment]::bottomLeft
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
$EmailGV.DataSource = $DGVDataTab
$EmailGV.Enabled = $false 
$EmailGV.DefaultCellStyle.BackColor = 'lightgreen'
<#
$str = $null
Import-Csv -Path "D:\HST\Production\Projects\Ellie\Gel Nail Polish\$FolderNameTests\PRF1El11 - copy3.csv" | foreach {  
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
    $RBGroup.Enabled = $true
<#
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
#        $DesktopGB.Controls.Add($thisCB)  
        
    }
#>
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


$TotLbl = New-Object System.Windows.Forms.label
$TotLbl.Location = New-Object System.Drawing.size(99,502)
$TotLbl.Size = New-Object System.Drawing.Size(80,15) 
$TotLbl.Text = "Total" 
$TotLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomright
$TotLbl.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)
$TotLbl.Visible = $false

$TotPercentIB = New-Object System.Windows.Forms.Label
$TotPercentIB.Location = New-Object System.Drawing.size(240,500)
$TotPercentIB.Size = New-Object System.Drawing.Size(50,20)
#$TotPercentIB.Enabled = $false
$TotPercentIB.TextAlign=[System.Drawing.ContentAlignment]::middlecenter
#$TotPercentIB.Text = 100
$TotPercentIB.BackColor = 'lightgreen'
$TotPercentIB.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)
$TotPercentIB.Visible = $false

$TotMlIB = New-Object System.Windows.Forms.TextBox
$TotMlIB.Location = New-Object System.Drawing.size(310,500)
$TotMlIB.Size = New-Object System.Drawing.Size(50,15)
$TotMlIB.Text = 200
$TotMlIB.TextAlign = 'Center'
$TotMlIB.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)
$TotMlIB.Visible = $false


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

$OldRB = New-Object System.Windows.Forms.RadioButton
$OldRB.Location = New-Object System.Drawing.size(140,12)
$OldRB.Size = New-Object System.Drawing.Size(100,20) 
$OldRB.Text = "تغییر آزمایش موجود" 
$OldRB.Add_Click({
funOLDRBClick
})
$OldRB.TextAlign=[System.Drawing.ContentAlignment]::bottomright
#$NeworOldRB.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)

$NewRB = New-Object System.Windows.Forms.RadioButton
$NewRB.Location = New-Object System.Drawing.size(255,12)
$NewRB.Size = New-Object System.Drawing.Size(90,20) 

$NewRB.Text = "ایجاد آزمایش جدید" 
$NewRB.Add_Click({
funNEWRBClick
})
$NewRB.TextAlign=[System.Drawing.ContentAlignment]::bottomright



$ProdLB = New-Object System.Windows.Forms.ComboBox
$ProdLB.Location = New-Object System.Drawing.size(10,10)
$ProdLB.Size = New-Object System.Drawing.Size(120,30)
$ProdLB.AutoCompleteSource = 'ListItems'
$ProdLB.AutoCompleteMode = 'Append'
#$ProdLB.Text = 200
$ProdLB.Enabled = $false
$ProdLB.Add_SelectedIndexChanged({

  $DesktopBtn.Enabled = $True  

})
#$ProdLB.TextAlign = 'Center'
#$ProdLB.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)


$RBGroup = New-Object System.Windows.Forms.GroupBox
$RBGroup.Location = '400,70'
$RBGroup.size = '350,35'
$RBGroup.Enabled = $false
$RBGroup.Padding = 1

$RBGroup.Controls.AddRange(@($OldRB,$NewRB))
$RBGroup.Controls.Add($ProdLB)

$DesktopGB.Controls.Add($RBGroup)
$DesktopGB.Controls.Add($TotPercentIB)
$DesktopGB.Controls.Add($TotMlIB)
$DesktopGB.Controls.Add($TotLbl)
$DesktopGB.Controls.Add($GBLbl)
$DesktopGB.Controls.Add($ProdLbl)
$DesktopGB.Controls.Add($ProjLbl)
#$DesktopGB.Controls.Add($ProdLB)
$DesktopGB.Controls.Add($EmailGV)
$DesktopGB.Controls.Add($ProdCatLB)
$DesktopGB.Controls.Add($PrjNameLB)
$DesktopGB.Controls.Add($DesktopBtn)


$SecoForm.Controls.Add($DesktopGB)

$SecoForm.Add_Shown({funDisAllCB})
[void] $SecoForm.ShowDialog()