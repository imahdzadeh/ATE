
. "$(Split-Path $PSScriptRoot -Parent)\config\$(($PSCommandPath.Split('\') | select -last 1) -replace ('.ps1$','var.ps1'))"

$ProjNames = Get-ChildItem -Path $ProdRoot -Directory | ForEach-Object{$_.Name}

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


#$DGVCBColumn.Rows.Clear()
#$DGVCBColumn.Columns.Clear()
$DGVCBColumn = New-Object system.Data.DataTable
[void]$DGVCBColumn.Columns.Add($strCBPeopName)
#Import-Csv "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\Material Info\MAC1PR121.csv" | Select -ExpandProperty $strCBPeopName | foreach {
    Import-Csv "D:\ATE\Production\Projects\Ellie\Gel Nail Polish\Material Info\MAC1PR121.csv" | Select -ExpandProperty $strCBPeopName | foreach {
    [void]$DGVCBColumn.Rows.Add($_)
} 
 


#[void]$DGVCBColumn.Columns.Add($strCBPeopName)

 #  Import-Csv "D:\ATE\Production\Projects\Ellie\Gel Nail Polish\Material Info\MAC1PR121.csv" | Select -ExpandProperty $strCBPeopName | foreach {
#Import-Csv "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\Material Info\MAC1PR121.csv" | Select -ExpandProperty $strCBPeopName | foreach {
 #   [void]$DGVCBColumn.Rows.Add($_)
#}

Import-Csv "$confRoot\$ConFol\$ConFol$($DGVCBInfoVer.IntVal)" |  foreach {
    $row2 = $DGVCBInfo.NewRow() 
    foreach($column in $DGVCBInfoCol){
        $row2.$column=$_.$column
    }
    [void]$DGVCBInfo.Rows.Add($row2)
}

$SecoForm.Add_Closing({param($sender,$e)
    
})

Function funPrjNameLB {
    $ProdCatLB.Items.Clear()
    $ProdCatLB.Text = $null
    $ProdType = Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)" -Directory | ForEach-Object{$_.Name}
    If ($ProdType -ne $null)
    {       
        $ProdCatLB.Items.AddRange($ProdType)
        $ProdCatLB.Enabled = $true
    }  
}

Function funSaveBtn {
    $strFileName = "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests\$($NewFileNameLbl.Text)$($FileExt)"
    If ($NewRB.Checked){
 #       $FileWriter = new-object System.IO.StreamWriter($strFileName,[System.Text.Encoding]::UTF8)
 #       $FileWriter.Encoding.
 #       $FileWriter.WriteLine( "$( ($EmailGV.Columns | % {$_.headertext}) -join ','),$(($ExtrInfoArr) -join ",")" )
        "$(($EmailGV.Columns | % {$_.headertext}) -join ','),$(($ExtrInfoArr) -join ",")".Trim() | Out-file $strFileName
        $EmailGV.Rows | Select-Object -SkipLast 1  | % {          
            "$( ($_.Cells | % {$_.Value}) -join ','),$strCreated,$((Get-Date).ToString('MM/dd/yyyy hh:mm tt')),$([Environment]::UserName)".Trim() | Out-file $strFileName -Append
        }      
    } 
    Else
    {
        (Get-Content $strFileName) | foreach {$_ -replace '^.*(?:\r?\n)?' , '#$_' } |  Out-File $strFileName
 #       $strComLine | Out-File $strFileName -Append
  #      $FileWriter = new-object System.IO.StreamWriter($strFileName)
 #       $FileWriter.WriteLine( "$( ($EmailGV.Columns | % {$_.headertext}) -join ','),$(($ExtrInfoArr) -join ",")" )
        "$(($EmailGV.Columns | % {$_.headertext}) -join ','),$(($ExtrInfoArr) -join ",")".Trim() | Out-file $strFileName -Append
  #      $EmailGV.Rows | Select-Object -SkipLast 1  | % {          
  #          $FileWriter.WriteLine( "$( ($_.Cells | % {$_.Value}) -join ','),$strChanged,$((Get-Date).ToString('MM/dd/yyyy hh:mm tt')),$([Environment]::UserName)" )
#        }
        $EmailGV.Rows | Select-Object -SkipLast 1  | % {          
            "$( ($_.Cells | % {$_.Value}) -join ','),$strChanged,$((Get-Date).ToString('MM/dd/yyyy hh:mm tt')),$([Environment]::UserName)".Trim() | Out-file $strFileName -Append
        }     
    }
    $SaveBtn.Enabled = $false
  #  $EmailGV.DefaultCellStyle.BackColor = 'lightgreen' 
    $cancelBtn.Enabled = $false
    
 #   $FileWriter.Close()
}

Function funNewRBClick{
    $ProdLB.Enabled = $false
    $DesktopBtn.Enabled = $true
    $ProdLB.Items.Clear()
    $ProdLB.Text = $null
    $EmailGV.Enabled = $false
    $NewFileNameLbl.Text = "" 
    $NewNameLbl.Visible = $false
    $NameLbl.Visible = $false 
    If ($EmailGV.Rows.Count -gt 0){
  #      $DGVDataTab.Clear()
    }
} 

Function funOldRBClick{
    $ProdLB.Enabled = $true
 #   $DesktopBtn.Enabled = $false
#    $ProdLB.Items.Clear()
#    $ProdLB.Text = $null
    $EmailGV.Enabled = $false 
 #   $NewFileNameLbl.Text = ""
    $NewNameLbl.Visible = $false 
    $PRFFiles = (Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests" -File | ForEach-Object{$_.Name}).TrimEnd($FileExt)
    If ($PRFFiles -ne $null)
    {
        $ProdLB.Items.AddRange($PRFFiles)
    } 
} 

Function funDisAllCB{
 #   $NewRB.Enabled = $faslse
 #   $OldRB.Enabled = $false
  #  $EmailGV.Rows.Clear()
 #   $DesktopBtn.Enabled = $false
#    $ProdLB.Enabled = $false
#    $ProdLB.Items.Clear()
#    $ProdLB.Text = $null
 #   $RBGroup.Enabled = $false
    $TotPercentIB.Text = $null
    $TotMlIB.Text = $null
    $EmailGV.Enabled = $false
    $TotLbl.Visible = $false
    $TotPercentIB.Visible = $false
    $TotMlIB.Visible = $false
    $NewNameLbl.Visible = $false 
    $NewFileNameLbl.Text = ""
    $Cancelbtn.Enabled = $flase
    $saveBtn.Enabled = $false
#    $ProdCatLB.Text = $null
    $NameLbl.Visible = $false
    If ($EmailGV.Rows.Count -gt 0){
 #       $DGVDataTab.Clear()
    }
}

<#
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
#>

Function funShowInfo{
 #   $DesktopBtn.Enabled = $false
    $EmailGV.Enabled = $true
    $TotLbl.Visible = $true
    $TotPercentIB.Visible = $true
    $TotMlIB.Visible = $true
    $Cancelbtn.Enabled = $true
    $saveBtn.Enabled = $true
<#
    $DGVCBColumn.Rows.Clear()
    $DGVCBColumn.Columns.Clear()
    [void]$DGVCBColumn.Columns.Add($strCBPeopName)
 #   Import-Csv "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\Material Info\MAC1PR121.csv" | Select -ExpandProperty $strCBPeopName | foreach {
    Import-Csv "D:\ATE\Production\Projects\Ellie\Gel Nail Polish\Material Info\MAC1PR121.csv" | Select -ExpandProperty $strCBPeopName | foreach {
        [void]$DGVCBColumn.Rows.Add($_)

    } 
#>
    If ($NewRB.Checked){
        $ConfFileVer = $null
        $ConfFileVer = gci "$confRoot\$ConFol" -file | Foreach{
            $_ -match $RegExVerVar
            } | Select-Object *, @{ n = "IntVal"; e = {[int]($Matches[2])}} | Sort-Object IntVal | Select-Object -Last 1

        $ConfFileNo = $null
        $ConfFileNo = gci "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)" -file -Recurse| Foreach{
            $_ -match $RegExNoVar
            } | Select-Object *, @{ n = "IntVal"; e = {[int]($Matches[4])}} | Sort-Object IntVal | Select-Object -Last 1
        $NewFileNameLbl.Text = "$($ConFol)$($ConfFileVer.IntVal)$($DepCode)$($ConfFileNo.IntVal+1)" 
        $NewNameLbl.Visible = $true
    }
    Else
    {
  #      Import-Csv "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests\$($ProdLB.SelectedItem)$fileExt" | foreach {

  #          If ( ($_[0].PSObject.Properties.value[0]).Substring(0,1) -ne '#')
#            {
        Get-Content "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests\$($ProdLB.SelectedItem)$fileExt" | Where-Object { !$_.StartsWith("#") } | ConvertFrom-Csv | Foreach {
            $row = $DGVDataTab.NewRow() 
            foreach($column in $DGVDataTab.Columns)
            {            
                $row.($column.columnname)=$_.($column.columnname)
            }
            $DGVDataTab.Rows.Add($row)
  #          }
        }
        $NewFileNameLbl.Text = $ProdLB.SelectedItem
        $NameLbl.Visible = $true
    }
}

$ProdLB = New-Object System.Windows.Forms.ListBox
$ProdLB.Location = New-Object System.Drawing.Point(50,100)
$ProdLB.Size = New-Object System.Drawing.Size(700,400)
$ProdLB.Height = 400
$ProdLB.FormattingEnabled = $True
$ProdLB.BackColor = 'red'

$ProdLB.TabIndex = 4
$ProdLB.DrawMode = [System.Windows.Forms.DrawMode]::OwnerDrawFixed
$ProdLB.DataBindings.DefaultDataSourceUpdateMode = 0
$ProdLB.ItemHeight = 20

$ListBoxCB = New-Object System.Windows.Forms.CheckBox
$ListBoxCB.Text = 'sdfsdf'
$ListBoxtB = New-Object System.Windows.Forms.TextBox
$ListBoxtB.Text = 'sdfsdf'

$DesktopBtn = New-Object system.Windows.Forms.Button
$DesktopBtn.Location = New-Object System.Drawing.Size(600,505) 
$DesktopBtn.BackColor = "#d2d4d6"
$DesktopBtn.text = "اجرای انتخابهای بالا"
$DesktopBtn.width = 120
$DesktopBtn.height = 35
$DesktopBtn.Font = 'Microsoft Sans Serif,10'
$DesktopBtn.ForeColor = "#000"
#$DesktopBtn.Enabled = $false
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
    funPrjNameLB
 #   funDisAllCB 
})

$EmailGV = $null
$EmailGV = New-Object System.Windows.Forms.DataGridView
$EmailGV.Location = New-Object System.Drawing.size(120,115)
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
$EmailGV.Add_CellValueChanged{
    foreach ($TGVRow in $EmailGV.Rows)
    {
   # write-host [int]($TotPercentIB.text) + 1
   If ($TGVRow.cells[$intColToSum].Value -ne $null -and $TGVRow.cells[$intColToSum].Value -gt 0) 
   {
      $intSum  = $intSum + [int]($TGVRow.cells[$intColToSum].Value) 
    }
      If ($TotMlIB.Text -gt 0 )
        {
         $TGVRow.cells[$intColToCal].Value = ( ([int]($TotMlIB.Text)*[int]($TGVRow.cells[$intColToSum].Value))/100).ToString()
        }
    }
    $TotPercentIB.text = $intSum
}
foreach ($datagridviewcolumn in $EmailGV.columns) {
    $datagridviewcolumn.sortmode = 0
}
$EmailGV.DataSource = $DGVDataTab
$EmailGV.Enabled = $false

#$EmailGV.Columns[0].DefaultCellStyle.BackColor ='lightgreen'
$ProdCatLB = $null
$ProdCatLB = New-Object System.Windows.Forms.Combobox 
$ProdCatLB.Location = New-Object System.Drawing.Size(545,40) 
$ProdCatLB.Size = New-Object System.Drawing.Size(100,20) 
$ProdCatLB.Height = 70
$ProdCatLB.AutoCompleteSource = 'ListItems'
$ProdCatLB.AutoCompleteMode = 'Append'
#$ProdCatLB.Enabled = $false
$ProdCatLB.Add_SelectedIndexChanged({
 #   $NewRB.Enabled = $true
 #   $OldRB.Enabled = $true
 #   $RBGroup.Enabled = $true
 <#
    $DGVCBColumn.Rows.Clear()
    $DGVCBColumn.Columns.Clear()
    [void]$DGVCBColumn.Columns.Add($strCBPeopName)
    Import-Csv "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\Material Info\MAC1PR121.csv" | Select -ExpandProperty $strCBPeopName | foreach {
        [void]$DGVCBColumn.Rows.Add($_)
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

$NewNameLbl = New-Object System.Windows.Forms.label
$NewNameLbl.Location = New-Object System.Drawing.size(235,85)
$NewNameLbl.Size = New-Object System.Drawing.Size(80,20) 
$NewNameLbl.Text = ":شماره آزمایش جدید" 
$NewNameLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomleft
$NewNameLbl.Visible = $false
$NewNameLbl.BackColor = ''

$NameLbl = New-Object System.Windows.Forms.label
$NameLbl.Location = New-Object System.Drawing.size(235,85)
$NameLbl.Size = New-Object System.Drawing.Size(70,20) 
$NameLbl.Text = ":شماره آزمایش" 
$NameLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomleft
$NameLbl.Visible = $False
$NameLbl.BackColor = ''

$NewFileNameLbl = New-Object System.Windows.Forms.label
$NewFileNameLbl.Location = New-Object System.Drawing.size(130,85)
#$NewFileNameLbl.Size = New-Object System.Drawing.Size(80,20)
$NewFileNameLbl.AutoSize = $ture 
$NewFileNameLbl.Text = ""
$NewFileNameLbl.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)
$NewFileNameLbl.TextAlign=[System.Drawing.ContentAlignment]::MiddleRight
$NewFileNameLbl.BackColor = ''

#[System.Windows.MessageBox]::Show('test')

$TotLbl = New-Object System.Windows.Forms.label
$TotLbl.Location = New-Object System.Drawing.size(120,470)
$TotLbl.Size = New-Object System.Drawing.Size(80,15) 
$TotLbl.Text = "Total" 
$TotLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomright
$TotLbl.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)
$TotLbl.Visible = $true

$TotPercentIB = New-Object System.Windows.Forms.Label
$TotPercentIB.Location = New-Object System.Drawing.size(270,470)
$TotPercentIB.Size = New-Object System.Drawing.Size(50,20)
#$TotPercentIB.Enabled = $false
$TotPercentIB.TextAlign=[System.Drawing.ContentAlignment]::middlecenter
#$TotPercentIB.Text = 100
$TotPercentIB.BackColor = 'lightgreen'
$TotPercentIB.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)
$TotPercentIB.Visible = $true

$TotMlIB = New-Object System.Windows.Forms.TextBox
$TotMlIB.Location = New-Object System.Drawing.size(335,469)
$TotMlIB.Size = New-Object System.Drawing.Size(50,12)
#$TotMlIB.Text = 200
$TotMlIB.TextAlign = 'Center'
$TotMlIB.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)
$TotMlIB.Visible = $true
$TotMlIB.TextAlign= 'Center'

$GBLbl = New-Object System.Windows.Forms.label
$GBLbl.Location = New-Object System.Drawing.size(520,-5)
$GBLbl.Size = New-Object System.Drawing.Size(250,20) 
$GBLbl.Text = "ایجاد یا تغییر آزمایش برای محصولات جدید" 
$GBLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomright

$DesktopGB = New-Object system.Windows.Forms.Groupbox
$DesktopGB.Size = New-Object System.Drawing.Size(500,550)
#$DesktopGB.Dock = [System.Windows.Forms.DockStyle]::Fill
$DesktopGB.AutoSize = $true
#$DesktopGB.BackColor = 'red'

$OldRB = New-Object System.Windows.Forms.RadioButton
$OldRB.Location = New-Object System.Drawing.size(140,12)
$OldRB.Size = New-Object System.Drawing.Size(100,20)
$oldRB.Checked = $false 
$OldRB.Text = "تغییر آزمایش موجود" 
$OldRB.Add_Click({
funOLDRBClick
})
$OldRB.TextAlign=[System.Drawing.ContentAlignment]::bottomright
#$NeworOldRB.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)

$NewRB = New-Object System.Windows.Forms.RadioButton
$NewRB.Location = New-Object System.Drawing.size(255,12)
$NewRB.Size = New-Object System.Drawing.Size(90,20) 
$NewRB.Checked = $true
$NewRB.Text = "ایجاد آزمایش جدید" 
$NewRB.Add_Click({
#funNEWRBClick
})
$NewRB.TextAlign=[System.Drawing.ContentAlignment]::bottomright



$ProdLB = New-Object System.Windows.Forms.ComboBox
$ProdLB.Location = New-Object System.Drawing.size(10,10)
$ProdLB.Size = New-Object System.Drawing.Size(120,30)
$ProdLB.AutoCompleteSource = 'ListItems'
$ProdLB.AutoCompleteMode = 'Append'
#$ProdLB.Text = 200
#$ProdLB.Enabled = $false
$ProdLB.Add_SelectedIndexChanged({

  $DesktopBtn.Enabled = $True  

})
#$ProdLB.TextAlign = 'Center'
#$ProdLB.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)


$RBGroup = New-Object System.Windows.Forms.GroupBox
$RBGroup.Location = '400,70'
$RBGroup.size = '350,35'
#$RBGroup.Enabled = $false
$RBGroup.Padding = 1

$RBGroup.Controls.AddRange(@($OldRB,$NewRB))
$RBGroup.Controls.Add($ProdLB)

$CancelBtn = New-Object system.Windows.Forms.Button
$CancelBtn.Location = New-Object System.Drawing.Size(225,505) 
$CancelBtn.BackColor = "#d2d4d6"
$CancelBtn.text = "انصراف"
$CancelBtn.width = 120
$CancelBtn.height = 35
$CancelBtn.Font = 'Microsoft Sans Serif,10'
$CancelBtn.ForeColor = "#000"
$CancelBtn.Enabled = $false
$CancelBtn.Add_Click({funDisAllCB})

$SaveBtn = New-Object system.Windows.Forms.Button
$SaveBtn.Location = New-Object System.Drawing.Size(100,505) 
$SaveBtn.BackColor = "#d2d4d6"
$SaveBtn.text = "ذخیره"
$SaveBtn.width = 120
$SaveBtn.height = 35
$SaveBtn.Font = 'Microsoft Sans Serif,10'
$SaveBtn.ForeColor = "#000"
#$SaveBtn.Enabled = $true
$SaveBtn.Add_Click({funSaveBtn})

$NewBtn = New-Object system.Windows.Forms.Button
$NewBtn.Location = New-Object System.Drawing.Size(470,505) 
$NewBtn.BackColor = "#d2d4d6"
$NewBtn.text = "جدید"
$NewBtn.width = 120
$NewBtn.height = 35
$NewBtn.Font = 'Microsoft Sans Serif,10'
$NewBtn.ForeColor = "#000"
#$SaveBtn.Enabled = $true
$NewBtn.Add_Click({funNewBtn})

$DesktopGB.Controls.Add($NewBtn)
$DesktopGB.Controls.Add($NameLbl)
$DesktopGB.Controls.Add($CancelBtn)
$DesktopGB.Controls.Add($SaveBtn)
$DesktopGB.Controls.Add($NewNameLbl)
$DesktopGB.Controls.Add($NewFileNameLbl)
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

$SecoForm.Controls.Add($SaveBtn)
$SecoForm.Controls.Add($DesktopGB)

#$SecoForm.Add_Shown({funDisAllCB})
[void] $SecoForm.ShowDialog()