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

#-----------------------CSV Files
 If (Test-Path $TablesCSV)
    {
    
        $TablesCSV1 = Import-Csv $TablesCSV
        $TablesCSV1 | % {     
            if ($_.TableName -eq $strmaintbl) 
            {
                New-Variable -Force -Name $_.TableName -Value (New-Object $_.obj)
                $thisTable = Get-Variable -ValueOnly -Include $_.TableName
                If($_.tablename -ne [System.DBNull]::Value){$thisControl.name = $_.tablename}
                If($_.AutoSize -ne [System.DBNull]::Value){$thisControl.AutoSize = $_.AutoSize}
                If($_.ColumnCount -ne [System.DBNull]::Value){$thisControl.ColumnCount = $_.ColumnCount}
                If($_.RowCount -ne [System.DBNull]::Value){$thisControl.RowCount = $_.RowCount}
                If($_.CellBorderStyle -ne [System.DBNull]::Value){$thisControl.CellBorderStyle = $_.CellBorderStyle}
                If($_.Height -ne [System.DBNull]::Value){$thisControl.Height = $_.Height}
            }
                     
        }

        $TablesCSV2 = Import-Csv $TablesCSV
        $TablesCSV2 | Select-Object -SkipLast 1 | % {     
            if ($_.TableName -ne $strmaintbl) 
            {
                New-Variable -Force -Name $_.TableName -Value (New-Object $_.obj)
                $thisTablemain = Get-Variable -ValueOnly -Include $_.TableName
                If($_.tablename -ne [System.DBNull]::Value){$thisControl.name = $_.tablename}
                If($_.AutoSize -ne [System.DBNull]::Value){$thisControl.AutoSize = $_.AutoSize}
                If($_.ColumnCount -ne [System.DBNull]::Value){$thisControl.ColumnCount = $_.ColumnCount}
                If($_.RowCount -ne [System.DBNull]::Value){$thisControl.RowCount = $_.RowCount}
                If($_.CellBorderStyle -ne [System.DBNull]::Value){$thisControl.CellBorderStyle = $_.CellBorderStyle}
                If($_.Height -ne [System.DBNull]::Value){$thisControl.Height = $_.Height}
                $basetbl = $null
                $Basetbl = Get-Variable -ValueOnly -Include $strmaintbl
                $Basetbl.controls.add($thisTablemain)
            }
        }        

    }
    If (Test-Path $ControlsCSV )
    {
        $Controls = Import-Csv $ControlsCSV
        $Controls | % {
            If($_.Obj -ne "System.Windows.Forms.TableLayoutPanel"){
                New-Variable -Force -Name $_.objName -Value (New-Object $_.obj)
                $thisControl = Get-Variable -ValueOnly -Include $_.objName
                $thisControl.Name = $_.objName
            }
            Else
            {
                $thisControl = Get-Variable -ValueOnly -Include $_.objName
            }
            $thisControl.Size = New-Object System.Drawing.Size($_.width,$_.Height)
            If($_.ImageName -ne [System.DBNull]::Value){$thisControl.Image = funImgStreamer "$imgFol\$($_.ImageName)$imgFileExt"}     
            If($_.ImageAlign -ne [System.DBNull]::Value){$thisControl.ImageAlign = $_.ImageAlign}
            If($_.Padding -ne [System.DBNull]::Value){$thisControl.Padding = $_.Padding}  
            If($_.Margin -ne [System.DBNull]::Value){$thisControl.Margin = $_.Margin}
            If($_.Tag -ne [System.DBNull]::Value){$thisControl.Tag = $_.Tag}  
            If($_.Appearance -ne [System.DBNull]::Value){$thisControl.Appearance = $_.Appearance}
            If($_.FlatStyle -ne [System.DBNull]::Value){$thisControl.FlatStyle = $_.FlatStyle}
            If($_.BackColor -ne [System.DBNull]::Value){$thisControl.BackColor = $_.BackColor}
            If($_.Text -ne [System.DBNull]::Value){$thisControl.Text = $_.Text}
            If($_.ForeColor -ne [System.DBNull]::Value){$thisControl.ForeColor = $_.ForeColor}
            If($_.TextAlign -ne [System.DBNull]::Value){$thisControl.TextAlign = $_.TextAlign}
            If($_.Anchor -ne [System.DBNull]::Value){$thisControl.Anchor = $_.Anchor}
            If($_.functions -ne [System.DBNull]::Value)
            {
                $funName = $_.functions
                New-Variable -Force -Name "$($_.objName)var" -Value ($_.functions)
                $thisControl.Add_Click({
#                    If(!$This.Checked){$DesktopPan.Focus()}
                    funDisAllShapes  $This
                    $ObjFunVar = Get-Variable -ValueOnly -Include "$($This.Name)$VarFileCont"
                    invoke-expression  $ObjFunVar
                })                                     
            }
            Else
            {
                $thisControl.Add_Click({
#                    If(!$This.Checked){$DesktopPan.Focus()}
                    funDisAllShapes  $This
                })                  
            }
            $Thistbl = Get-Variable -ValueOnly -Include $_.TableName
            $Thistbl.controls.add($thisControl)                
        }                                    
    }



#-------------------------

<#
$DesktopCC = New-Object Panel
$DesktopCC.AutoScroll = $true
#$DesktopCC.Size = New-Object Size(1100,601)
#$DesktopCC.Controls.Add($DesktopPan)
#$DesktopCC.BackColor = 'gray'
#>

$MainTbl = New-Object TableLayoutPanel
#$MainTbl.AutoSize = $true
$MainTbl.CellBorderStyle = 1
$MainTbl.Size = New-Object Size(1100,601)
#$MainTbl.ColumnCount = 4
#$MainTbl.RowCount = 3
#$MainTbl.BackColor = 'green'

<#
$HeaderTbl = New-Object TableLayoutPanel
#$HeaderTbl.AutoScroll = $true
#$HeaderTbl.Controls.Add($DesktopPan)
$HeaderTbl.CellBorderStyle = 1
$HeaderTbl.Size = New-Object Size(1100,100)
$HeaderTbl.ColumnCount = 4
$HeaderTbl.RowCount = 3
#$HeaderTbl.BackColor = 'pink'


$HeaderTblLbl1 = New-Object System.Windows.Forms.label
#$HeaderTblLbl1.Location = New-Object System.Drawing.size(520,-5)
#$HeaderTblLbl1.Size = New-Object System.Drawing.Size(250,20) 
$HeaderTblLbl1.Text = "فرم تعریف کالا" 
$HeaderTblLbl1.Font = 'Arial'
#$HeaderTblLbl1.BackColor = "red"
$HeaderTblLbl1.size = New-Object System.Drawing.Size(760,30)
$HeaderTblLbl1.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#$HeaderTblLbl1.TextAlign=[System.Drawing.ContentAlignment]::MiddleCenter 

$HeaderTblLbl2 = New-Object System.Windows.Forms.label
$HeaderTblLbl2.Text = ":شناسه" 
$HeaderTblLbl2.Font = 'Arial'
$HeaderTblLbl2.TextAlign=[System.Drawing.ContentAlignment]::TopRight

$HeaderTblLbl3 = New-Object System.Windows.Forms.label
#$HeaderTblLbl1.Location = New-Object System.Drawing.size(520,-5)
#$HeaderTblLbl1.Size = New-Object System.Drawing.Size(250,20) 
$HeaderTblLbl3.Text = "WHE-FR-001-00" 
$HeaderTblLbl3.Font = 'Arial'
$HeaderTblLbl3.TextAlign=[System.Drawing.ContentAlignment]::TopLeft

$HeaderTblDateLbl = New-Object System.Windows.Forms.label
$HeaderTblDateLbl.Text = ":تاریخ بازنگری" 
$HeaderTblDateLbl.Font = 'Arial'
$HeaderTblDateLbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight

$HeaderTblDateValueLbl = New-Object System.Windows.Forms.label
$HeaderTblDateValuelbl.Text = "1402-12-04" 
$HeaderTblDateValueLbl.Font = 'Arial'
$HeaderTblDateValueLbl.TextAlign=[System.Drawing.ContentAlignment]::TopLeft

$HeaderTblRefLbl = New-Object System.Windows.Forms.label
$HeaderTblRefLbl.Text = ":مرجع" 
$HeaderTblRefLbl.Font = 'Arial'
$HeaderTblRefLbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight

$HeaderTblRefValueLbl = New-Object System.Windows.Forms.label
$HeaderTblRefValuelbl.Text = "WHE-SOP-001-00" 
$HeaderTblRefvalueLbl.Font = 'Arial'
$HeaderTblRefValueLbl.TextAlign =[System.Drawing.ContentAlignment]::TopLeft

$HeaderTblNameLbl = New-Object System.Windows.Forms.label
$HeaderTblNamelbl.Text = "شرکت مهــــــدپــویـــــــان اطلــــــس" 
$HeaderTblNameLbl.Font ="b titr"
#$HeaderTblNameLbl.TextAlign = 2
$HeaderTblNameLbl.size = New-Object System.Drawing.Size(760,60)
$HeaderTblNameLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#$HeaderTblNameLbl.BackColor = "red"

$ImageBx = new-object Windows.Forms.PictureBox
$ImageBx.Size = New-Object System.Drawing.Size(110,80)
$ImageBx.SizeMode = 1
$imagebx.Image = [System.Drawing.Image]::Fromfile("D:\ATE\Officers\Image_20240225192535.png");

  

$DesktopCC.Controls.Add($HeaderTblNameLbl)


$MainTbl.Controls.Add($HeaderTbl)
$HeaderTbl.Controls.Add($HeaderTblLbl1,2,2)
$HeaderTbl.Controls.Add($HeaderTblLbl2,1,0)
$HeaderTbl.Controls.Add($HeaderTblLbl3,0,0)
$HeaderTbl.Controls.Add($HeaderTblDateLbl,1,1)
$HeaderTbl.Controls.Add($HeaderTblDateValueLbl,0,1)
$HeaderTbl.Controls.Add($HeaderTblRefLbl,1,2)
$HeaderTbl.Controls.Add($HeaderTblRefValueLbl,0,2)
$HeaderTbl.Controls.Add($HeaderTblNameLbl,2,0)
$HeaderTbl.Controls.add($ImageBx,3,0)
$HeaderTbl.SetRowSpan($ImageBx,3)
#$HeaderTbl.Controls.Add($DesktopCC,2,0)
$HeaderTbl.SetRowSpan($HeaderTblNameLbl,2)
#$HeaderTbl.SetRowSpan(2)
#>
#$Secoform.Controls.Add($HeaderTbl)
$Secoform.Controls.Add($MainTbl)  


[void]$Secoform.ShowDialog()   # display the dialog