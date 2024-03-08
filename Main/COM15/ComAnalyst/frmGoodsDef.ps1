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
$MainTbl.AutoSize = $true
$MainTbl.CellBorderStyle = 1
$MainTbl.ColumnCount = 1
$MainTbl.RowCount = 6
#-------Add other tables to form
If (Test-Path $TablesCSV)
    {
        $TablesCSV = Import-Csv $TablesCSV
        $TablesCSV | % {                     
            New-Variable -Force -Name $_.TableName -Value (New-Object $_.obj)
            $thisTable = Get-Variable -ValueOnly -Include $_.TableName
            $thisTable.Name = $_.TableName
            $thisTable.AutoSize = $_.AutoSize
            $thisTable.ColumnCount = $_.ColumnCount
            $thisTable.RowCount = $_.RowCount
            $thisTable.CellBorderStyle = $_.CellBorderStyle
            $thisTable.Height = $_.Height
            $MainTbl.Controls.Add($thisTable)
        }
    }
#---------Add controls to table
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
                   # funDisAllShapes  $This
                   # $ObjFunVar = Get-Variable -ValueOnly -Include "$($This.Name)$VarFileCont"
                    #invoke-expression  $ObjFunVar
                })                                     
            }
            Else
            {
                $thisControl.Add_Click({
#                    If(!$This.Checked){$DesktopPan.Focus()}
#                   funDisAllShapes  $This
                })                  
            }
            $Thistbl = Get-Variable -ValueOnly -Include $_.TableName
            $Thistbl.controls.add($thisControl)                
        }                                    
    }




$Secoform.Controls.Add($MainTbl)


    


[void]$Secoform.ShowDialog()   # display the dialog