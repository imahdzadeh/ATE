﻿# Created by Isar Mahdzadeh
# Decmeber 12 2023
#
Try
{
    $DepCodeTemp = (Split-Path $PSScriptRoot -Parent).Split('\') | select -Last 1
    $ConFol =  (Get-Item $PSScriptRoot).parent.Parent.Parent.FullName
    $pathTemp = "$ConFol\Config\$DepCodeTemp\$((Get-Item $PSCommandPath).Name)" -replace (".ps1$","")
  . "$pathTemp\$(((Get-Item $PSCommandPath).Name) -replace (".ps1$","var.ps1"))"

 #. "$(Split-Path $PSScriptRoot -Parent)\Config\$(($PSCommandPath.Split('\') | select -last 1) -replace (".ps1$","var.ps1"))"

    if($varDebugTrace -ne 0){Set-PSDebug -Trace $varDebugTrace}Else{Set-PSDebug -Trace $varDebugTrace}

#    throw [System.IO.FileNotFoundException] "$file not found."
    $strDupFileName = $null
    $ProjNames = Get-ChildItem -Path $ProdRoot -Directory | ForEach-Object {$_.Name}
    $DGVCellValueChanging = $flase
    $DGVCBInfo = New-Object system.Data.DataTable
    $DGVCBInfoVer = gci "$ConfFol\$(((Get-Item $PSCommandPath).Name) -replace (".ps1$",''))" -file | Foreach {
      $_ -replace '^PRF', ''
      } | Select-Object *, @{ n = "IntVal"; e = {[int]($_)}} | Sort-Object IntVal | Select-Object -Last 1

    $DGVCBInfoCol = @()
    (Get-Content "$ConfFol\$(((Get-Item $PSCommandPath).Name) -replace (".ps1$",''))\$ConFolPRF$($DGVCBInfoVer.IntVal)" | select -First 1) -split $CSVDelimiter | foreach {
        $DGVCBInfoCol += $_
        $col2 = New-Object System.Data.DataColumn
        $col2.DataType = [string]
        $col2.ColumnName = $_
        $DGVCBInfo.Columns.Add($col2)
    }
   
    $DGVCBColumn = New-Object system.Data.DataTable
    [void]$DGVCBColumn.Columns.Add($strCBPeopName)

    Import-Csv "$ConfFol\$(((Get-Item $PSCommandPath).Name) -replace (".ps1$",''))\$ConFolPRF$($DGVCBInfoVer.IntVal)" |  foreach {
        $row2 = $DGVCBInfo.NewRow() 
        foreach($column in $DGVCBInfoCol){
            $row2.$column=$_.$column
        }
        #تعریف ستونهای دیتا گرید ویو با خصوصیات ستونهای آن
        [void]$DGVCBInfo.Rows.Add($row2)
    }

    $SecoForm.Add_Closing({param($sender,$e)
        $ImageBx.Dispose()   
    })

    Function funPrjNameLB {
        Try
        {
            $ProdCatLB.Items.Clear()
            $ProdCatLB.Text = $null
            $ProdType = Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)" -Directory | ForEach-Object{$_.Name}
            If ($ProdType -ne $null)
            {       
                $ProdCatLB.Items.AddRange($ProdType)
                $ProdCatLB.Enabled = $true
            }
        }
        Catch
        {
            "$((Get-Date).ToString('MMMyy'))`t $($PSCommandPath.Split('\') | select -last 1)-funPrjNameLB`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append 
        }  
    }

    Function funSaveBtn {
        Try
        {
 #           $strFileName = "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests\$($NewFileNameTxb.Tag)$($CSVFileExt)"
            $strFileName = "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests\$($NewFileNameTxb.Tag)"
            If(funSaveDupRowChk)
            {
                If(funSaveEmpRowChk)
                {
                    If(funSaveDupFileChk)
                    {
                        If(funSaveEmpEntries)
                        {
                            If ($NewRB.Checked)
                            {
                               
                            #       $FileWriter = new-object System.IO.StreamWriter($strFileName,[System.Text.Encoding]::UTF8)
                            #       $FileWriter.Encoding.
                            #       $FileWriter.WriteLine( "$( ($EmailGV.Columns | % {$_.headertext}) -join ','),$(($ExtrInfoArr) -join ",")" )
                                $intIterate = 0
                                $EmailGV.Rows | Select-Object -SkipLast 1  | & {
                                    Begin{"$(($EmailGV.Columns | % {$_.headertext}) -join ','),$(($ExtrInfoArr) -join ",")".Trim() | Out-file $strFileName} 
                                    Process{
                                        $intIterate = $intIterate + 1
                                        If ($intIterate -gt 1)
                                        {
                                            "$( ($_.Cells | % {$_.Value}) -join ',')".Trim() | Out-file $strFileName -Append   
                                        }
                                        Else
                                        {
                                            "$( ($_.Cells | % {$_.Value}) -join ','),$strCreated,$((Get-Date).ToString('MM/dd/yyyy hh:mm tt')),$([Environment]::UserName),NA,NA,$($NewFileNameTxb.Text),$true,$($VerTxt.Text)".Trim() | 
                                            Out-file $strFileName -Append   
                                        }                                
                                    }
                                    End{}                           
                                }
                                If($ImageBx.tag -ne $null)
                                {
                                    $ImageBx.Image.Save("$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($NewFileNameTxb.Tag)$($ImageExt)")
#                                    $strTemp = "$($NewFileNameTxb.Tag)$($ImageExt)"
                                } 
                                "$((Get-Date).ToString('MM/dd/yyyy hh:mm:ss tt'))`t$($PSCommandPath.Split('\') | 
                                select -last 1)-SaveBtn`t$($NewRB.Text)`t$($NewFileNameTxb.Tag)`t$($NewFileNameTxb.Text)`t$Global:StrImageLast`t$([Environment]::UserName)" | 
                                Out-File $UserLogPath -Append     
                            } 
                            Else
                            {
                                $intIterate = 0
                                (Get-Content $strFileName) | % {
                                    $intIterate = $intIterate + 1
                                    If(($intIterate -eq 1) -or ($_.StartsWith("#")))
                                    {
                                        $_                              
                                    }
                                    Else
                                    {
                                        '#' + $_        
                                    }                            
                                } |  Out-File $strFileName
                            #       $strComLine | Out-File $strFileName -Append
                            #      $FileWriter = new-object System.IO.StreamWriter($strFileName)
                            #       $FileWriter.WriteLine( "$( ($EmailGV.Columns | % {$_.headertext}) -join ','),$(($ExtrInfoArr) -join ",")" )
                        
                                $intIterate = 0
                                $EmailGV.Rows | Select-Object -SkipLast 1  | % {
                                    $intIterate = $intIterate + 1
                                    If($intIterate -gt 1)
                                    {
                                        "$( ($_.Cells | % {$_.Value}) -join ',')".Trim() | Out-file $strFileName -Append    
                                    }
                                    Else
                                    {
                                        "$( ($_.Cells | % {$_.Value}) -join ','),$strChanged,$((Get-Date).ToString('MM/dd/yyyy hh:mm tt')),$([Environment]::UserName),NA,NA,$($NewFileNameTxb.Text),$true,$([int]$VerTxt.Text+1)".Trim() | 
                                        Out-file $strFileName -Append
                                    }                                  
                                }
                                $imageFolTemp = "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\"
                                If($ImageBx.tag -eq $ImgFileAddbtn.Text)
                                {                                 
                                    If(Test-Path "$imageFolTemp$($NewFileNameTxb.Tag)$($ImageExt)")
                                    {
                                        Move-Item  "$imageFolTemp$($NewFileNameTxb.Tag)$($ImageExt)" "$imageFolTemp$ArchFolder\$($NewFileNameTxb.Tag)$($ImageExt)"
                                        Rename-Item "$imageFolTemp$ArchFolder\$($NewFileNameTxb.Tag)$($ImageExt)" `
                                        "$imageFolTemp$ArchFolder\$($NewFileNameTxb.Tag)_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss tt'))$($ImageExt)"
#                                        $strTemp = "$($NewFileNameTxb.Tag)_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss tt'))$($ImageExt)"
                                    }
                                    $ImageBx.Image.Save("$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($NewFileNameTxb.Tag)$($ImageExt)")
                                }
                                Else
                                {
                                     If((Test-Path "$imageFolTemp$($NewFileNameTxb.Tag)$($ImageExt)") -and ($ImageBx.tag -eq $ImgFileRembtn.Text))
                                     {
                                        Move-Item  "$imageFolTemp$($NewFileNameTxb.Tag)$($ImageExt)" "$imageFolTemp$ArchFolder\$($NewFileNameTxb.Tag)$($ImageExt)"
                                        Rename-Item "$imageFolTemp$ArchFolder\$($NewFileNameTxb.Tag)$($ImageExt)" `
                                        "$imageFolTemp$ArchFolder\$($NewFileNameTxb.Tag)_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss tt'))$($ImageExt)"                                       
                                     }
                                } 
                                "$((Get-Date).ToString('MM/dd/yyyy hh:mm:ss tt'))`t $($PSCommandPath.Split('\') | 
                                select -last 1)-SaveBtn`t $($OldRB.Text)`t $($NewFileNameTxb.Tag) Name:$($NewFileNameTxb.Text)`t $Global:StrImageLast `t $([Environment]::UserName)" | 
                                Out-File $UserLogPath -Append -Force     
                            }
                            $SaveBtn.Enabled = $false
                            $EmailGV.DefaultCellStyle.BackColor = 'lightgreen'
                            $EmailGV.ClearSelection()
                            $EmailGV.Enabled = $false 
                            $cancelBtn.Enabled = $false
                            $NewBtn.Enabled = $true
                            $TotMlIB.Enabled = $false
                            $ImgFileAddbtn.Enabled = $false
                            $ShowMACbtn.Enabled = $false
                            $ShowPRFbtn.Enabled = $false
                            $ImgFileRembtn.Enabled = $false
                            #   $FileWriter.Close()
                        }
                        Else
                        {
                            [System.Windows.MessageBox]::Show("لطفا مقادیر مواد اولیه را وارد کنید ، ذخیره انجام نشد")
                            "$((Get-Date).ToString('MM/dd/yyyy hh:mm:ss tt'))`t $($PSCommandPath.Split('\') | 
                            select -last 1)-SaveBtn`t لطفا مقادیر مواد اولیه را وارد کنید ، ذخیره انجام نشد `t$($NewFileNameTxb.Tag) `t$([Environment]::UserName)" | 
                            Out-File $UserLogPath -Append                                
                        }
                    }
                    Else
                    {
                        [System.Windows.MessageBox]::Show("وجود دارد، ذخیره انجام نشد $($Global:strDupFileName) فرمول مشابه در شماره")
                        "$((Get-Date).ToString('MM/dd/yyyy hh:mm:ss tt'))`t $($PSCommandPath.Split('\') | 
                        select -last 1)-SaveBtn`t وجود دارد، ذخیره انجام نشد $($strDupFileName) فرمول مشابه در شماره `t$($NewFileNameTxb.Tag) `t$([Environment]::UserName)" | 
                        Out-File $UserLogPath -Append                            
                    }
                }
                Else
                {
                    [System.Windows.MessageBox]::Show("سطر خالی وجود دارد، ذخیره انجام نشد $($strCBPeopName) در ستون")
                    "$((Get-Date).ToString('MM/dd/yyyy hh:mm:ss tt'))`t $($PSCommandPath.Split('\') | 
                    select -last 1)-SaveBtn`t سطر خالی وجود دارد، ذخیره انجام نشد $($strCBPeopName) در ستون `t$($NewFileNameTxb.Tag) `t$([Environment]::UserName)" | 
                    Out-File $UserLogPath -Append  
                }
            }
            Else
            {
                [System.Windows.MessageBox]::Show("تکرار وجود دارد، ذخیره انجام نشد $($strCBPeopName) در ستون")
                "$((Get-Date).ToString('MM/dd/yyyy hh:mm:ss tt'))`t $($PSCommandPath.Split('\') | 
                select -last 1)-SaveBtn`t کرار وجود دارد، ذخیره انجام نشد $($strCBPeopName) در ستون `t$($NewFileNameTxb.Tag) `t$([Environment]::UserName)" | 
                Out-File $UserLogPath -Append 
            }
        }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-funSaveBtn`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append 
        }
    }

    Function funSaveEmpEntries{
        Try
        {
            $bolReturn = $true
            $EmailGV.Rows | Select-Object -SkipLast 1 | % {
                If(($_.Cells[$intColToCal].value -eq [System.DBNull]::Value) -and ($_.Cells[$intColToSum].value -eq [System.DBNull]::Value))
                {
                    $bolReturn = $false
                }      
            }    
            $bolReturn
         }
         Catch
         {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-funSaveEmpEntries`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append 
         } 
    }

    Function funSaveEmpRowChk{
        Try
        {
            $bolReturn = $true
            $EmailGV.Rows | Select-Object -SkipLast 1 | % {
                If($_.Cells[$EmailGV.Columns.Item($strCBPeopName).index].value -eq [System.DBNull]::Value)
                {
                    $bolReturn = $false
                }      
            }
            $bolReturn
        }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-funSaveEmpRowChk`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append  
        } 
    }

    Function funSaveDupFileChk{
        Try
        {
            $bolReturn = $true
            $strDupFileName = $null
            $strRanFileName = "$env:temp\$(get-random 100000)"
            $intIterate = 0
            $EmailGV.Rows | Select-Object -SkipLast 1  | & {
                Begin{"$(($EmailGV.Columns | % {$_.headertext}) -join ','),$(($ExtrInfoArr) -join ",")".Trim() | Out-File $strRanFileName} 
                Process{
                    $intIterate = $intIterate + 1
                    If ($intIterate -gt 1)
                    {
                        "$( ($_.Cells | % {$_.Value}) -join ',')".Trim() | Out-file $strRanFileName -Append   
                    }
                    Else
                    {
                        "$( ($_.Cells | % {$_.Value}) -join ','),$strCreated,$((Get-Date).ToString('MM/dd/yyyy hh:mm tt')),$([Environment]::UserName)".Trim() | 
                        Out-File $strRanFileName -Append
                    }
                                
                }
                End{}                           
            }
            $object1 = Get-Content $strRanFileName | ConvertFrom-Csv 
            gci "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)" -file -Recurse| Foreach{
                If($_ -match $RegExNoVar) 
                {
                    $bolCHK = $false
                    $object2 = (Get-Content $_.FullName  | Where-Object { !$_.StartsWith("#") }) | ConvertFrom-Csv
                    Compare-Object $object1 $object2 -Property $ArrColToCompare | % {$bolCHK = $True} 
                    If (($bolCHK -eq $false) -and ($_.Name -ne "$($NewFileNameTxb.Tag)")){
                        $Global:strDupFileName = ($_.Name).TrimEnd($CSVFileExt)
                        $bolReturn = $false
                    }      
                }
            
            }
            $bolReturn
            Remove-Item $strRanFileName -Force | Out-Null
        }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-funSaveDupFileChk`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append 
        }
    }

    Function funSaveDupRowChk{
        Try
        {
            $bolReturn = $true
            $seen = @()
            $EmailGV.Rows | Select-Object -SkipLast 1 | % {
            If($seen -contains $_.Cells[$EmailGV.Columns.Item($strCBPeopName).index].value)
                {
                    $bolReturn = $false
                }
                Else
                {
                    $seen += $_.Cells[$EmailGV.Columns.Item($strCBPeopName).index].value    
                }        
            }
            $bolReturn
        }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-funSaveDupRowChk`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append 
        }    
    }

    Function funNewRBClick{
        $ProdLB.Enabled = $false
        $DesktopBtn.Enabled = $true
        $ProdLB.Items.Clear()
        $ProdLB.Text = $null
        $EmailGV.Enabled = $false
        $NewFileNameTxb.Tag = "" 
#        $NewNameLbl.Visible = $false
#        $NameLbl.Visible = $false 
    } 

    Function funOldRBClick{
        Try
        {
            $ProdLB.Enabled = $true
            $DesktopBtn.Enabled = $false
            $EmailGV.Enabled = $false 
            $NewFileNameTxb.Tag = ""
#            $NewNameLbl.Visible = $false 
            ProdCatLBSelectedIndexChanged
<#
            $PRFFiles = Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests" -File | 
            ForEach-Object{$_.Name.TrimEnd($CSVFileExt)}
            If ($PRFFiles -ne $null)
            {
                $ProdLB.Items.AddRange($PRFFiles)
            }
#>
        }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-funOldRBClick`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append  
        } 
    } 

    Function funDisAllCB{
        $VerTxt.Text = ""
        $TestIDTxt.Text = ""
        $NewRB.Enabled = $faslse
        $OldRB.Enabled = $false
        $NewRB.Checked = $false
        $OldRB.Checked = $false
        $ImgFileAddbtn.Enabled = $false
        $ImgFileRembtn.Enabled = $false
        $ShowMACbtn.Enabled = $false
        $ShowPRFbtn.Enabled = $false
        $DesktopBtn.Enabled = $false
        $ProdLB.Enabled = $false
        $ProdLB.Items.Clear()
        $ProdLB.Text = $null
        $RBGroup.Enabled = $false
        $TotPercentIB.Text = $null
        $TotMlIB.Text = $null
        $TotMlIB.Enabled = $false
        $EmailGV.Enabled = $false
        $TotLbl.Visible = $false
        $TotPercentIB.Visible = $false
        $TotMlIB.Visible = $false
#        $NewNameLbl.Visible = $false 
        $NewFileNameTxb.Text = ""
        $NewFileNameTxb.Enabled = $false
        $Cancelbtn.Enabled = $flase
        $saveBtn.Enabled = $false
        $ProdCatLB.Text = $null
#        $NameLbl.Visible = $false
        $PrjNameLB.Enabled = $true
        $ImageBx.Image = $null
        $arrProducts.Clear()
        If ($EmailGV.Rows.Count -gt 0){
            $DGVDataTab.Clear()
        }
    }

    Function funShowInfo{
        Try
        {
            $DesktopBtn.Enabled = $false
            $NewRB.Enabled = $faslse
            $ProdCatLB.Enabled = $false
            $PrjNameLB.Enabled = $false
            $OldRB.Enabled = $false
            $ProdLB.Enabled = $false
            $EmailGV.Enabled = $true
            $TotLbl.Visible = $true
            $TotPercentIB.Visible = $true
            $TotMlIB.Visible = $true
            $TotMlIB.Enabled = $true
            $Cancelbtn.Enabled = $true
            $saveBtn.Enabled = $true
            $NewBtn.Enabled = $false
            $ImgFileAddbtn.Enabled = $true
            $NewFileNameTxb.Enabled = $true
            $intSum = 0
            $intCal = 0
            If ($NewRB.Checked){
                $ConfFileVer = $null
                $TotMlIB.Text = 0
                $TotPercentIB.Text = 0
                $VerTxt.Text = 1
                "$ConfFol\$(((Get-Item $PSCommandPath).Name) -replace (".ps1$",''))\$ConFolPRF$($DGVCBInfoVer.IntVal)"

#                $ConfFileVer = gci "$confRoot\$ConFolPRF" -file | Foreach{
                $ConfFileVer = gci "$ConfFol\$(((Get-Item $PSCommandPath).Name) -replace (".ps1$",''))" -file | Foreach{
                    $_ -match $RegExVerVar
                    } | Select-Object *, @{ n = "IntVal"; e = {[int]($Matches[2])}} | Sort-Object IntVal | Select-Object -Last 1

                $ConfFileNo = $null
#                $ConfFileNo = gci "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)" -file -Recurse| Foreach{
                $ConfFileNo = gci "$ProdRoot\$($PrjNameLB.SelectedItem)" -file -Recurse| Foreach{
                    $_ -match $RegExNoVar
                    } | Select-Object *, @{ n = "IntVal"; e = {[int]($Matches[4])}} | Sort-Object IntVal | Select-Object -Last 1
                $NewFileNameTxb.Tag = "$($ConFolPRF)$($ConfFileVer.IntVal)$($DepCode)$($ConfFileNo.IntVal+1)$CSVFileExt" 
                $TestIDTxt.Text = "$($ConFolPRF)$($ConfFileVer.IntVal)$($DepCode)$($ConfFileNo.IntVal+1)"
                $NewFileNameTxb.Text = ""
#                $NewNameLbl.Visible = $true
            }
            Else
            {
                $VerTxt.Text = 1
                $TestID = ($arrProducts.GetEnumerator() | Where-Object {$_.Value -eq $ProdLB.SelectedItem}).Name 
                $FileID, $rest = $TestID
                If($rest.count -gt 0)
                {
                   [System.Windows.MessageBox]::Show("نام مشابه در $($rest.count) فرمول دیگر وجود دارد") 
                }
#                Get-Content "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests\$($ProdLB.SelectedItem)$CSVFileExt" | 
                Get-Content "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests\$FileID" | 
                Where-Object { !$_.StartsWith("#") } | ConvertFrom-Csv | Foreach {
                    If($_.Header)
                    {
                        If([int]$_.Ver -gt 0)
                        {
                            $VerTxt.Text = [int]$_.Ver
                        }
                    }    
                    $row = $DGVDataTab.NewRow() 
                    foreach($column in $DGVDataTab.Columns)
                    {            
                        $row.($column.columnname)=$_.($column.columnname)
                    }
                    $DGVDataTab.Rows.Add($row)
                }
                $NewFileNameTxb.Tag = $FileID
                $TestIDTxt.Text = $FileID -replace $CSVFileExt,""
                $NewFileNameTxb.Text = $arrProducts.Item($TestID)
#                $NameLbl.Visible = $true
                foreach ($TGVRow in $EmailGV.Rows)
                {
                    $TGVRow.HeaderCell.Value = ($TGVRow.Index +1).ToString()
                    If ($TGVRow.cells[$intColToSum].Value -ne $null -and $TGVRow.cells[$intColToSum].Value -gt 0) 
                    {
                        $intSum  = $intSum + [single]($TGVRow.cells[$intColToSum].Value) 
                    }
                    If ($TGVRow.cells[$intColToCal].Value -ne $null -and $TGVRow.cells[$intColToCal].Value -gt 0) 
                    {
                        $intCal  = $intCal + [single]($TGVRow.cells[$intColToCal].Value) 
                    }
                }
                $TotPercentIB.Text = [int]$intSum
                $TotMlIB.Text = [math]::round($intCal,2)

#                $test = "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($NewFileNameTxb.Tag)$($ImageExt)"
                $test = "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($TestIDTxt.Text)$($ImageExt)"
                If(Test-Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($TestIDTxt.Text)$($ImageExt)")
                    {
 #                       $imgFile = (Get-Item $dialog.FileName)
                        $Global:img = [System.Drawing.Image]::Fromfile("$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($TestIDTxt.Text)$($ImageExt)");
                        $ImageBx.Image = $Global:img
                        $ImageBx.Tag = $imgFile.Name
#                        $ImageBx.Image.Save("$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($NewFileNameTxb.Tag)$($ImageExt)")
#                        $Global:img.Dispose()
                    } 
            }
            If($ImageBx.Image -ne $null){$ImgFileRembtn.Enabled = $true}
           

        }
        Catch
        {
            If ($Logging)
            {
                "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
                select -last 1)-funShowInfo`t $_ `t$([Environment]::UserName)" | 
                Out-File $ErrLogPath -Append
            }
            Else
            {
                throw $_
            } 
        }

    }

    Function funShowMAC{
        Try
        {
            $ShowMACfrm = New-Object System.Windows.Forms.Form
            $ShowMACfrm.Size = New-Object System.Drawing.Size(400,600)
            $ShowMACfrm.Text = "لیست مواد اولیه"
            $ShowMACfrm.AutoSize = $true

            $ShowMACDGV = $null
            $ShowMACDGV = New-Object System.Windows.Forms.DataGridView
            $ShowMACDGV.Size=New-Object System.Drawing.Size(400,600)
            $ShowMACDGV.Dock = 'fill'
            $ShowMACDGV.RowHeadersVisible = $false
            $ShowMACDGV.SelectionMode = 'FullRowSelect'
            $ShowMACDGV.AutoSizeColumnsMode = 10
    #        $ShowMACDGV.AllowUserToResizeColumns = $false
            $ShowMACDGV.AllowUserToResizeRows = $false
            $ShowMACDGV.Size=New-Object System.Drawing.Size($HeaderWidth,350)
            $ShowMACDGV.AllowUserToDeleteRows = $false
            $ShowMACDGV.AllowUserToAddRows = $true
            $ShowMACDGV.ReadOnly = $true
            $ShowMACDGV.ColumnHeadersDefaultCellStyle.Alignment = [System.Drawing.ContentAlignment]::MiddleCenter
            #$ShowMACDGV.DefaultCellStyle.Alignment = [System.Drawing.ContentAlignment]::bottomLeft
            $ShowMACDGV.AllowUserToOrderColumns = $false
            $ShowMACDGV.RowHeadersWidthSizeMode = 1
            #$ShowMACDGV.AutoSizeRowsMode = $false
            $ShowMACDGV.ColumnHeadersHeightSizeMode = 1
            $ShowMACDGV.EnableHeadersVisualStyles = $false
            #$ShowMACDGV.DefaultCellStyle.SelectionBackColor= $ShowMACDGV.DefaultCellStyle.BackColor
            #$ShowMACDGV.DefaultCellStyle.SelectionForeColor= $ShowMACDGV.DefaultCellStyle.ForeColor
            $ShowMACDGV.ColumnHeadersDefaultCellStyle.SelectionBackColor='window'
            #$ShowMACDGV.AutoSizeRowsMode = $false
            $ShowMACDGV.ColumnHeadersHeightSizeMode = 1
            $objDTV = $null
#            gci "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$($MatCodeFol)" -file | Foreach{
            gci "$ProdRoot\$($PrjNameLB.SelectedItem)" -file -Recurse | Foreach{
                If( $_.Name -match $RegExMAC)
                {
                    
 #                   $objDTV += Import-Csv $_.FullName | Select-Object -ExcludeProperty ($_ -split ',')[$ShowPRFfrmStartCol..$ShowPRFfrmEndCol]
 #                    $objDTV += Import-Csv $_.FullName | Select -ExpandProperty "name"
                     $objDTV += Import-Csv $_.FullName | Select * -ExcludeProperty ($ExtrInfoArr -split $CSVDelimiter)
                    
                }
            }
            $result= new-object System.Collections.ArrayList 
            If ($objDTV -ne $null)
            {
                $result.AddRange($objDTV)     
               $ShowMACDGV.DataSource = $result
            }

            $ShowMACfrm.Controls.Add($ShowMACDGV)
            $ShowMACfrm.Show()

        }

        Catch
        {
            If($Logging)
            {
                "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
                select -last 1)-funShowMAC`t $_ `t$([Environment]::UserName)" | 
                Out-File $ErrLogPath -Append
            }
            Else
            {
                throw $_
            } 
        }

    }

    Function funShowPRF{
        Try
        {
            $ShowPRFfrm = New-Object System.Windows.Forms.Form
            $ShowPRFfrm.Size = New-Object System.Drawing.Size(300,600)
            $ShowPRFfrm.Text = "لیست فرمولها"
 #           $ShowPRFfrm.AutoSize = $true
#            $ShowPRFfrm.AutoSizeMode = 1
            

            $ShowPRFDGV = $null
            $ShowPRFDGV = New-Object System.Windows.Forms.DataGridView
            $ShowPRFDGV.Size=New-Object System.Drawing.Size(400,600)
            $ShowPRFDGV.Dock = 'fill'
            $ShowPRFDGV.RowHeadersVisible = $false
            $ShowPRFDGV.SelectionMode = 'FullRowSelect'
            $ShowPRFDGV.AutoSizeColumnsMode = 10
            $ShowPRFDGV.RowTemplate.Height = 20
            
            $ShowPRFDGV.AllowUserToResizeColumns = $true
            $ShowPRFDGV.AllowUserToResizeRows = $false
            $ShowPRFDGV.Size=New-Object System.Drawing.Size($HeaderWidth,350)
            $ShowPRFDGV.AllowUserToDeleteRows = $false
            $ShowPRFDGV.AllowUserToAddRows = $true
            $ShowPRFDGV.ReadOnly = $false
            $ShowPRFDGV.ColumnHeadersDefaultCellStyle.Alignment = [System.Drawing.ContentAlignment]::MiddleCenter
            #$ShowPRFDGV.DefaultCellStyle.Alignment = [System.Drawing.ContentAlignment]::bottomLeft
            $ShowPRFDGV.AllowUserToOrderColumns = $true
            $ShowPRFDGV.RowHeadersWidthSizeMode = 1
            #$ShowPRFDGV.AutoSizeRowsMode = $false
            $ShowPRFDGV.ColumnHeadersHeightSizeMode = 1
            $ShowPRFDGV.EnableHeadersVisualStyles = $false
            #$ShowPRFDGV.DefaultCellStyle.SelectionBackColor= $ShowPRFDGV.DefaultCellStyle.BackColor
            #$ShowPRFDGV.DefaultCellStyle.SelectionForeColor= $ShowPRFDGV.DefaultCellStyle.ForeColor
            $ShowPRFDGV.ColumnHeadersDefaultCellStyle.SelectionBackColor='window'
            #$ShowPRFDGV.AutoSizeRowsMode = $false
            $ShowPRFDGV.ColumnHeadersHeightSizeMode = 1
            $intiterate
            foreach($objShowFrmArr in $ShowFrmArr)
            {
                If($objShowFrmArr -ne $ImgColName)
                {
                    $Column = New-Object System.Windows.Forms.DataGridViewTextBoxColumn 
                                     
                    $ShowPRFDGV.Columns.insert($ShowPRFDGV.Columns.Count,$Column)  
                    $ShowPRFDGV.Columns[$ShowPRFDGV.Columns.Count - 1].HeaderText = $objShowFrmArr 
                }
                Else
                {
                    $ImageColumn = New-Object System.Windows.Forms.DataGridViewImageColumn
                    $ImageColumn.Width = 100
                    $ImageColumn.AutoSizeMode = 1
                    $ShowPRFDGV.Columns.Insert($ShowPRFDGV.Columns.Count,$ImageColumn)
                    $ShowPRFDGV.Columns[$ShowPRFDGV.Columns.Count - 1].HeaderText = $objShowFrmArr 
                        
                }                              
            }
            $intIterateRow = -1
            $objPRFDTV = $null
            gci "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests" -file | Foreach{
                If( $_.Name -match $RegExNoVar)
                {
                    $Strtest = "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$(($_.Name).TrimEnd($CSVFileExt))$($ImageExt)"
                    If (Test-Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$(($_.Name).TrimEnd($CSVFileExt))$($ImageExt)")
                    {
                        $DGVImage = [System.Drawing.Image]::FromFile(`
                        "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$(($_.Name).TrimEnd($CSVFileExt))$($ImageExt)")
                    }
                    Else
                    {
                        $DGVImage = $null
                    }
                    $intIterate = 0
                    $intIterateRow = $intIterateRow + 1
                    $FileName = $_.Name
                    Get-Content $_.FullName | select -Skip 1 | % {
                        If(!$_.StartsWith("#"))
                        {
                            $intIterate = $intIterate + 1
                            If($intIterate -eq 1)
                            {
                                $ShowPRFDGV.rows.Add((, $DGVImage +(,$FileName +($_ -split $CSVDelimiter)[$ShowPRFfrmStartCol..$ShowPRFfrmEndCol])))                           
                            }
                        }
                    }
                }
            }
            $ShowPRFfrm.Controls.Add($ShowPRFDGV)
            $ShowPRFfrm.Show()
        }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-funShowPRF`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append 
        }
    }

    Function funNewBtn{
        Try
        {
            $NewBtn.Enabled = $false
            $PrjNameLB.ResetText()
            funDisAllCB
            $EmailGV.DefaultCellStyle.BackColor = 'window'
        }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-funNewBtn`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append 
        }
    }

    Function funImgAddFile{
        Try
        {
            $dialog = [System.Windows.Forms.OpenFileDialog]::new()
            $dialog.RestoreDirectory = $true
            $result = $dialog.ShowDialog()
            if($result -eq [System.Windows.Forms.DialogResult]::OK){
                If ($Global:img -ne $null)
                {
                    $ImageBx.Image = $null
                    $Global:img.Dispose()           
                }
            $Global:img = [System.Drawing.Image]::Fromfile($dialog.FileName);
            $ImageBx.Image = $Global:img
            $ImageBx.Tag = $ImgFileAddbtn.Text
            $ImgFileRembtn.Enabled = $false
            $ImgFileAddbtn.Enabled = $false
            $Global:StrImageLast = $ImgFileAddbtn.Text       
            }
        }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-funImgAddFile`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append 
        }
    }

    Function funImgRemFile{
        Try
        {
            If($ImageBx.Image -ne $null)
            {
                $ImgFileRembtn.Enabled = $false
                $ImgFileAddbtn.Enabled = $false
                $ImageBx.Image = $null
                $ImageBx.Tag = $ImgFileRembtn.Text
                $Global:img.Dispose()
                $Global:StrImageLast = $ImgFileRembtn.Text   
            }
            Else
            {
                $ImgFileRembtn.Enabled = $false
                [System.Windows.MessageBox]::Show("عکسی به این آزمایش اضافه نشده است")
            }
        }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-funImgRemFile`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append 
        }        
    }

    Function ProdCatLBSelectedIndexChanged{   
        Try
        {
            $NewRB.Enabled = $true
            $OldRB.Enabled = $true
            $RBGroup.Enabled = $true
            $ShowMACbtn.Enabled = $true
            $ShowPRFbtn.Enabled = $true
            $DGVCBColumn.Rows.Clear()
            $arrProducts.Clear()
 #           gci "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$($MatCodeFol)" -file | Foreach{
            gci "$ProdRoot\$($PrjNameLB.SelectedItem)" -file -Recurse| Foreach{
                       If( $_.Name -match $RegExMAC)
                       {
                            Get-Content $_.FullName | ConvertFrom-Csv  |Select -ExpandProperty $strCBPeopName | foreach {
                                [void]$DGVCBColumn.Rows.Add($_)
                            }
                       }
            }
#Where-Object { !$_.StartsWith("#") } | ConvertFrom-Csv | Foreach {
            $ProdLB.Items.Clear()
            $intIterateTemp = 1
#            $PRFFiles = Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests" -File | 
            Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests" -File | `
#            ForEach-Object{$_.PersianAlias}
            ForEach-Object{
                $FileNameTemp = $_.Name 
                Get-Content $_.FullName | Where-Object { !$_.StartsWith("#") }  | ConvertFrom-Csv | select -first 1 |`
                foreach{
#                    If($_.PersianAlias -eq [System.DBNull]::Value)
                    If($_.PersianAlias -eq $Null)
                    {
                        $arrProducts.add($FileNameTemp,"noname$intIterateTemp")
                        $intIterateTemp++
                    }
                    Else
                    {
                        $arrProducts.add($FileNameTemp,$_.PersianAlias)
                    }                    
                }
#            $_.Name.TrimEnd($CSVFileExt)
            }
            
            foreach($arrProdItem in $arrProducts.keys)
            {
                $ProdLB.Items.Add($arrProducts.Item($arrProdItem))
            }
<#
            If ($PRFFiles -ne $null)
            {
                $ProdLB.Items.AddRange($PRFFiles)
            }
#>

        }
        Catch
        {
            If ($Logging)
            {
                "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
                select -last 1)-ProdCatLB.Add_SelectedIndexChanged`t $_ `t$([Environment]::UserName)" | 
                Out-File $ErrLogPath -Append
            }
            Else
            {
                throw $_
            }      
        }                   
    }

    Function EmailGVCellValueChanged{
        Try
        {
            $intSum = 0
            [Float]$intCal = 0
            If(!$DGVCellValueChanging)
            {
                $DGVCellValueChanging = $true
                If ($_.columnindex -eq $intColToSum)
                {
                        foreach ($TGVRow in $EmailGV.Rows)
                        {
                        $TGVRow.HeaderCell.Value = ($TGVRow.Index +1).ToString()
                            If ($TGVRow.cells[$intColToSum].Value -match '^\d*\.?\d+$') 
                            {
                                $intSum  = $intSum + [Float]($TGVRow.cells[$intColToSum].Value) 
                            }
                            If ($TotMlIB.Text -match $DecimalRegEx )
                            {
                                If  (
                                        (   
                                            ($TGVRow.cells[$intColToCal].Value -eq [System.DBNull]::Value -or 
                                            $TGVRow.cells[$intColToCal].Value -eq 0) -And 
                                            $TGVRow.cells[$intColToSum].Value -ne [System.DBNull]::Value  -and
                                            $TGVRow.cells[$intColToSum].Value -ne $null          
                                        )                                                                            -or
                                        (
                                            ($TGVRow.cells[$intColToSum].Value -ne [System.DBNull]::Value) -and
                                            ($TGVRow.cells[$intColToCal].Value -ne [System.DBNull]::Value) -and
                                            ($TGVRow.cells[$intColToCal].Value -ne 0)                      -and
                                            ($TGVRow.cells[$intColToSum].Value -ne $null)                  -and                                    
                                            ($TGVRow.cells[$intColToCal].Value -ne [math]::round(( ([int]($TotMlIB.Text)*[int]($TGVRow.cells[$intColToSum].Value))/100).ToString(),2))
                                        )                                   
                                    )
                                {
                                    $TGVRow.cells[$intColToCal].Value = [math]::round(( ([int]($TotMlIB.Text)*[int]($TGVRow.cells[$intColToSum].Value))/100).ToString(),2)
                                }
                            }
                        }
                        $TotPercentIB.text = [int]$intSum
                }
                Else
                {
                    If ($_.columnindex -eq $intColToCal)
                    {
                        foreach ($TGVRow in $EmailGV.Rows)
                        {
                            If ($TGVRow.cells[$intColToCal].Value -match $DecimalRegEx) 
                            {
                                If($TGVRow.cells[$intColToCal].Value -ne [System.DBNull]::Value)
                                {
                                    $intCal  = $intCal + [Float]($TGVRow.cells[$intColToCal].Value) 
                                }
                            }
                        }
                            $TotMlIB.text = $intCal
                        foreach ($TGVRow in $EmailGV.Rows)
                        {
                            If ($TGVRow.cells[$intColToCal].Value -match $DecimalRegEx -or $TGVRow.cells[$intColToCal].Value -eq [System.DBNull]::Value) 
                            {
                                If($TGVRow.cells[$intColToCal].Value -ne [System.DBNull]::Value -and $TGVRow.cells[$intColToCal].Value -ne 0)
                                {
                                    $TGVRow.cells[$intColToSum].Value = [math]::round(( ([Float]($TGVRow.cells[$intColToCal].Value)/([Float]($TotMlIB.Text)))*100).ToString(),2)
                                }
                                Else
                                {
                                    $TGVRow.cells[$intColToSum].Value = [System.DBNull]::Value
                                }
                            }
                        }
                        $intSum = 0
                        foreach ($TGVRow in $EmailGV.Rows)
                        {
                            $TGVRow.HeaderCell.Value = ($TGVRow.Index +1).ToString()                            
                            If ($TGVRow.cells[$intColToSum].Value -match '^\d*\.?\d+$') 
                            {
                                $intSum  = $intSum + [int]($TGVRow.cells[$intColToSum].Value) 
                            }
                        }
                        $TotPercentIB.text = [int]$intSum
                                          
                    }
                }
                $DGVCellValueChanging = $false       
            }
        }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-EmailGV.Add_CellValueChanged`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append  
        }          
    }

    Function funUpdateEmailGV{
        Try
        {
            foreach ($TGVRow in $EmailGV.Rows)
            {
            $DGVCellValueChanging = $true
            $TGVRow.HeaderCell.Value = ($TGVRow.Index +1).ToString()
                If ($TGVRow.cells[$intColToSum].Value -match $DecimalRegEx) 
                {
                    $intSum  = $intSum + [int]($TGVRow.cells[$intColToSum].Value) 
                }
                If ($TotMlIB.Text -match $DecimalRegEx )
                {
                    If  (
                            (   
                                ($TGVRow.cells[$intColToCal].Value -eq [System.DBNull]::Value -or 
                                $TGVRow.cells[$intColToCal].Value -eq 0) -And 
                                $TGVRow.cells[$intColToSum].Value -ne [System.DBNull]::Value  -and
                                $TGVRow.cells[$intColToSum].Value -ne $null          
                            )                                                                            -or
                            (
                                ($TGVRow.cells[$intColToSum].Value -ne [System.DBNull]::Value) -and
                                ($TGVRow.cells[$intColToCal].Value -ne [System.DBNull]::Value) -and
                                ($TGVRow.cells[$intColToCal].Value -ne 0)                      -and
                                ($TGVRow.cells[$intColToSum].Value -ne $null)                  -and                                    
#                                ($TGVRow.cells[$intColToCal].Value -ne [math]::round(( ([int]($TotMlIB.Text)*[int]($TGVRow.cells[$intColToSum].Value))/100).ToString(),2))
                                ($TGVRow.cells[$intColToCal].Value -ne [math]::round(( ([Float]($TotMlIB.Text)*[Float]($TGVRow.cells[$intColToSum].Value))/100).ToString(),2))
                            )                                   
                        )
                    {
#                        $TGVRow.cells[$intColToCal].Value = [math]::round(( ([int]($TotMlIB.Text)*[int]($TGVRow.cells[$intColToSum].Value))/100).ToString(),2)
                        $TGVRow.cells[$intColToCal].Value = [math]::round(( ([Float]($TotMlIB.Text)*[Float]($TGVRow.cells[$intColToSum].Value))/100).ToString(),2)
                    }
                }
            }
            $TotPercentIB.text = [int]$intSum
            $DGVCellValueChanging = $false
            }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-funUpdateEmailGV`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append  
        } 
    }

    Function ProdLBDrawItem($s,$e){       
        If ($s.Items.Count -eq 0) {return}
        
        $TestID = ($arrProducts.GetEnumerator() | Where-Object {$_.Value -eq ($s.Items[$e.Index]).trim()}).Name 
        $FileID, $rest = $TestID
        $FileID = $FileID -replace $CSVFileExt,""
        $test = "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$FileID$($ImageExt)" 
#        If(Test-Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($s.Items[$e.Index])$($ImageExt)")
        If(Test-Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$FileID$($ImageExt)")
            {
                $Global:img = [System.Drawing.Image]::Fromfile("$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$FileID$($ImageExt)");
                $e.Graphics.DrawImage($Global:img,0,$e.Bounds.Y+2.5,10,10)
                $Global:img.Dispose()
            }             
        $e.Graphics.DrawString($s.Items[$e.Index], $e.Font, [System.Drawing.SystemBrushes]::ControlText, $e.Bounds.Left+10, $e.Bounds.Top, [System.Drawing.StringFormat]::GenericDefault)          
    }

    $ListBoxCB = New-Object System.Windows.Forms.CheckBox
    $ListBoxCB.Text = 'sdfsdf'
    $ListBoxtB = New-Object System.Windows.Forms.TextBox
    $ListBoxtB.Text = 'sdfsdf'

    $DesktopBtn = New-Object system.Windows.Forms.Button
    $DesktopBtn.Location = New-Object System.Drawing.Size(620,505) 
    $DesktopBtn.BackColor = "#d2d4d6"
    $DesktopBtn.text = "اجرای انتخابهای بالا"
    $DesktopBtn.width = 120
    $DesktopBtn.height = 35
    $DesktopBtn.Font = 'Microsoft Sans Serif,10'
    $DesktopBtn.ForeColor = "#000"
    $DesktopBtn.Enabled = $false
    $DesktopBtn.Add_Click({
        $DesktopBtn.Enabled = $false
        funShowInfo
    })

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
        funDisAllCB 
    })

    $EmailGV = $null
    $EmailGV = New-Object System.Windows.Forms.DataGridView
    $EmailGV.Location = New-Object System.Drawing.size(80,145)
    $EmailGV.RowHeadersVisible = $True
#    $EmailGV.rowh
#    $EmailGV.DefaultCellStyle.flatstyle = 0
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
        $col.Name = $row3.Name
        $col.DataPropertyName = $row3.Name
        $HeaderWidth = $HeaderWidth + $row3.SizeX
        $col.Width = $row3.SizeX
        $col.DefaultCellStyle.Alignment = $row3.Alignment      
        If ($row3.Type -eq 'System.Windows.Forms.DataGridViewComboBoxColumn'){
            $col.DataSource = $DGVCBColumn
            $col.ValueMember = $row3.Name
            $col.DisplayMember = $row3.Name
            $col.flatstyle = 0        
        }   
        [void]$EmailGV.columns.Add($col)
    }
    $HeaderWidth = $HeaderWidth + 52
    $EmailGV.Size=New-Object System.Drawing.Size($HeaderWidth,320)
    $EmailGV.AllowUserToDeleteRows = $false
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
    $EmailGV.RowHeadersDefaultCellStyle.Alignment = [System.Drawing.ContentAlignment]::MiddleLeft
    $EmailGV.RowHeadersWidth = 50
    $EmailGV.Add_CellValueChanged{
        param([System.Object]$s, [System.Windows.Forms.DataGridViewCellEventArgs]$e)
        EmailGVCellValueChanged
    }
    
    $EmailGV.Add_CellBeginEdit{
        param([System.Object]$s, [System.Windows.Forms.DataGridViewCellCancelEventArgs]$e)
<#
        If($EmailGV.Rows[$e.RowIndex].Cells[$e.ColumnIndex].Value -ne [System.DBNull]::Value)
        {
           $global:floCellOldValue = [Float]$EmailGV.Rows[$e.RowIndex].Cells[$e.ColumnIndex].Value 
        } 
 #>             
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
    $ProdCatLB.Enabled = $false
    $ProdCatLB.Add_SelectedIndexChanged({
        ProdCatLBSelectedIndexChanged
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
<#
    $NewNameLbl = New-Object System.Windows.Forms.label
    $NewNameLbl.Location = New-Object System.Drawing.size(200,120)
    $NewNameLbl.Size = New-Object System.Drawing.Size(80,20) 
    $NewNameLbl.Text = ":نام آزمایش جدید" 
    $NewNameLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomleft
    $NewNameLbl.Visible = $ture 
    $NewNameLbl.BackColor = 'green'
#>
    $NameLbl = New-Object System.Windows.Forms.label
    $NameLbl.Location = New-Object System.Drawing.size(650,120)
    $NameLbl.Size = New-Object System.Drawing.Size(50,20) 
    $NameLbl.Text = ":نام آزمایش" 
    $NameLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomleft
#    $NameLbl.Visible = $ture 
    $NameLbl.BackColor = ''

    $NewFileNameTxb = New-Object System.Windows.Forms.TextBox
    $NewFileNameTxb.Location = New-Object System.Drawing.size(500,120)
    $NewFileNameTxb.Size = New-Object System.Drawing.Size(150,20)
    $NewFileNameTxb.AutoSize = $ture 
    $NewFileNameTxb.Text = ""
    $NewFileNameTxb.Tag = ""
    $NewFileNameTxb.TextAlign = 2
    $NewFileNameTxb.Font = [System.Drawing.Font]::new("arial", 10, [System.Drawing.FontStyle]::Bold)
 #   $NewFileNameTxb.TextAlign=[System.Drawing.ContentAlignment]::MiddleRight
    $NewFileNameTxb.BackColor = ''
    $NewFileNameTxb.Enabled = $false
    $NewFileNameTxb.Visible = $True

    $VerLbl = New-Object System.Windows.Forms.label
    $VerLbl.Location = New-Object System.Drawing.size(400,120)
    $VerLbl.Size = New-Object System.Drawing.Size(70,20) 
    $VerLbl.Text = ":نسخه" 
    $VerLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomleft
    $VerLbl.Visible = $True
    $VerLbl.BackColor = ''

    $VerTxt = New-Object System.Windows.Forms.label
    $VerTxt.Location = New-Object System.Drawing.size(380,120)
    $VerTxt.Size = New-Object System.Drawing.Size(20,20) 
    $VerTxt.Text = "" 
    $VerTxt.TextAlign=[System.Drawing.ContentAlignment]::bottomleft
    $VerTxt.Visible = $True
    $VerTxt.BackColor = ''

    $TestIDLbl = New-Object System.Windows.Forms.label
    $TestIDLbl.Location = New-Object System.Drawing.size(190,120)
    $TestIDLbl.Size = New-Object System.Drawing.Size(35,20) 
    $TestIDLbl.Text = ":شناسه" 
    $TestIDLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomleft
    $TestIDLbl.Visible = $True
    $TestIDLbl.BackColor = ''

    $TestIDTxt = New-Object System.Windows.Forms.label
    $TestIDTxt.Location = New-Object System.Drawing.size(85,120)
    $TestIDTxt.Size = New-Object System.Drawing.Size(100,20) 
    $TestIDTxt.Text = "" 
    $TestIDTxt.TextAlign=[System.Drawing.ContentAlignment]::bottomleft
    $TestIDTxt.Visible = $True
    $TestIDTxt.BackColor = ''

    #[System.Windows.MessageBox]::Show('test')

    $TotLbl = New-Object System.Windows.Forms.label
    $TotLbl.Location = New-Object System.Drawing.size(120,470)
    $TotLbl.Size = New-Object System.Drawing.Size(80,15) 
    $TotLbl.Text = "Total" 
    $TotLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomright
    $TotLbl.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)
    $TotLbl.Visible = $false

    $TotPercentIB = New-Object System.Windows.Forms.Label
    $TotPercentIB.Location = New-Object System.Drawing.size(270,470)
    $TotPercentIB.Size = New-Object System.Drawing.Size(50,20)
    #$TotPercentIB.Enabled = $false
    $TotPercentIB.TextAlign=[System.Drawing.ContentAlignment]::middlecenter
    #$TotPercentIB.Text = 100
    #$TotPercentIB.BackColor = 'lightgreen'
    $TotPercentIB.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)
    $TotPercentIB.Visible = $flase
    $TotPercentIB.add_TextChanged({
        If ($TotPercentIB.text -eq 100){$TotPercentIB.BackColor = 'lightgreen'}Else{$TotPercentIB.BackColor = ''}
    })

    $tooltip = New-Object System.Windows.Forms.ToolTip
    $tooltip.InitialDelay = 100 
    $tooltip.ReshowDelay = 100 

    $TotMlIB = New-Object System.Windows.Forms.TextBox
    $TotMlIB.Location = New-Object System.Drawing.size(345,469)
    $TotMlIB.Size = New-Object System.Drawing.Size(50,12)
    #$TotMlIB.Text = 200
    $TotMlIB.TextAlign = 'Center'
    $TotMlIB.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)
    $TotMlIB.Visible = $true
    $TotMlIB.TextAlign= 'Center'
    $TotMlIB.Enabled = $false
    $TotMlIB.Add_KeyDown({      
        if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Enter) {     
            $_.SuppressKeyPress = $True
            funUpdateEmailGV  
        }
        Else
        {
            # Check if Text contains any non-Digits
            if($TotMlIB.Text -notmatch '\D'){
                $TotMlIB.BackColor = '' 
            }      
        }
    })
    $TotMlIB.Add_lostfocus({
        If ($TotMlIB.Text -match $DecimalRegEx)
        {
            $TotMlIB.BackColor = ''
            funUpdateEmailGV
        }
        Else
        {
            $TotMlIB.BackColor = 'red'
        }
        
    })

    $TotMlIB.Add_gotfocus({
        $Global:TotMlIBOldValue = $TotMlIB.Text
    })

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
    $OldRB.Location = New-Object System.Drawing.size(190,12)
    $OldRB.Size = New-Object System.Drawing.Size(100,20)
    $oldRB.Checked = $false 
    $OldRB.Text = "تغییر آزمایش موجود"
    $OldRB.Enabled = $false 
    $OldRB.Add_Click({
        funOLDRBClick
    })
    $OldRB.TextAlign=[System.Drawing.ContentAlignment]::bottomright
    #$NeworOldRB.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)

    $NewRB = New-Object System.Windows.Forms.RadioButton
    $NewRB.Location = New-Object System.Drawing.size(305,12)
    $NewRB.Size = New-Object System.Drawing.Size(90,20) 
    $NewRB.Checked = $false
    $NewRB.Enabled = $false
    $NewRB.Text = "ایجاد آزمایش جدید" 
    $NewRB.Add_Click({
        funNEWRBClick
    })
    $NewRB.TextAlign=[System.Drawing.ContentAlignment]::bottomright

    $ProdLB = New-Object System.Windows.Forms.ComboBox
    $ProdLB.Location = New-Object System.Drawing.size(10,10)
    $ProdLB.Size = New-Object System.Drawing.Size(170,30)
    $ProdLB.AutoCompleteSource = 'ListItems'
    $ProdLB.AutoCompleteMode = 'Append'
    #$ProdLB.Text = 200
    $ProdLB.Enabled = $false
    $ProdLB.DrawMode = [System.Windows.Forms.DrawMode]::OwnerDrawFixed
    $ProdLB.add_DrawItem({ 
        param([System.Object]$s, [System.Windows.Forms.DrawItemEventArgs]$e)
        ProdLBDrawItem $s $e
    })

    $ProdLB.Add_SelectedIndexChanged({     
        $DesktopBtn.Enabled = $True  
    })

    $RBGroup = New-Object System.Windows.Forms.GroupBox
    $RBGroup.Location = '350,70'
    $RBGroup.size = '400,35'
    #$RBGroup.Enabled = $false
    $RBGroup.Padding = 1

    $RBGroup.Controls.AddRange(@($OldRB,$NewRB))
    $RBGroup.Controls.Add($ProdLB)

    $CancelBtn = New-Object system.Windows.Forms.Button
    $CancelBtn.Location = New-Object System.Drawing.Size(175,505) 
    $CancelBtn.BackColor = "#d2d4d6"
    $CancelBtn.text = "انصراف"
    $CancelBtn.width = 120
    $CancelBtn.height = 35
    $CancelBtn.Font = 'Microsoft Sans Serif,10'
    $CancelBtn.ForeColor = "#000"
    $CancelBtn.Enabled = $false
    $CancelBtn.Add_Click({
        $PrjNameLB.ResetText()
        funDisAllCB
    })

    $SaveBtn = New-Object system.Windows.Forms.Button
    $SaveBtn.Location = New-Object System.Drawing.Size(50,505) 
    $SaveBtn.BackColor = "#d2d4d6"
    $SaveBtn.text = "ذخیره"
    $SaveBtn.width = 120
    $SaveBtn.height = 35
    $SaveBtn.Font = 'Microsoft Sans Serif,10'
    $SaveBtn.ForeColor = "#000"
    $SaveBtn.Enabled = $false
    $SaveBtn.Add_Click({funSaveBtn})

    $NewBtn = New-Object system.Windows.Forms.Button
    $NewBtn.Location = New-Object System.Drawing.Size(495,505) 
    $NewBtn.BackColor = "#d2d4d6"
    $NewBtn.text = "جدید"
    $NewBtn.width = 120
    $NewBtn.height = 35
    $NewBtn.Font = 'Microsoft Sans Serif,10'
    $NewBtn.Enabled = $false
    $NewBtn.ForeColor = "#000"
    #$SaveBtn.Enabled = $true
    $NewBtn.Add_Click({funNewBtn})

    $ShowMACbtn = New-Object system.Windows.Forms.Button
    $ShowMACbtn.Location = New-Object System.Drawing.Size(300,38) 
    $ShowMACbtn.BackColor = "#d2d4d6"
    $ShowMACbtn.text = "لیست مواد اولیه"
    $ShowMACbtn.width = 120
    $ShowMACbtn.height = 25
    $ShowMACbtn.Font = 'Microsoft Sans Serif,10'
    $ShowMACbtn.Enabled = $false
    $ShowMACbtn.ForeColor = "#000"
    $ShowMACbtn.Add_Click({funShowMAC})

    $ShowPRFbtn = New-Object system.Windows.Forms.Button
    $ShowPRFbtn.Location = New-Object System.Drawing.Size(420,38) 
    $ShowPRFbtn.BackColor = "#d2d4d6"
    $ShowPRFbtn.text = "لیست فرمولهای آزمایش"
    $ShowPRFbtn.width = 120
    $ShowPRFbtn.height = 25
    $ShowPRFbtn.Font = 'Microsoft Sans Serif,10'
    $ShowPRFbtn.Enabled = $false
    $ShowPRFbtn.ForeColor = "#000"
    $ShowPRFbtn.Add_Click({funShowPRF})

    $ImgFileAddbtn = New-Object system.Windows.Forms.Button
    $ImgFileAddbtn.Location = New-Object System.Drawing.Size(180,65) 
    $ImgFileAddbtn.BackColor = "#d2d4d6"
    $ImgFileAddbtn.text = "بارگذاری عکس"
    $ImgFileAddbtn.width = 100
    $ImgFileAddbtn.height = 25
    $ImgFileAddbtn.Font = 'Microsoft Sans Serif,10'
    $ImgFileAddbtn.Enabled = $False
    $ImgFileAddbtn.ForeColor = "#000"
    $ImgFileAddbtn.Add_Click({funImgAddFile})

    $ImgFileRembtn = New-Object system.Windows.Forms.Button
    $ImgFileRembtn.Location = New-Object System.Drawing.Size(180,35) 
    $ImgFileRembtn.BackColor = "#d2d4d6"
    $ImgFileRembtn.text = "حذف عکس"
    $ImgFileRembtn.width = 100
    $ImgFileRembtn.height = 25
    $ImgFileRembtn.Font = 'Microsoft Sans Serif,10'
    $ImgFileRembtn.Enabled = $False
    $ImgFileRembtn.ForeColor = "#000"
    $ImgFileRembtn.Add_Click({funImgRemFile})

    $ImageBx = new-object Windows.Forms.PictureBox
    $ImageBx.Location = New-Object System.Drawing.Size(95,35)
    $ImageBx.Size = New-Object System.Drawing.Size(80,60)
    $ImageBx.SizeMode = 1
    $ImageBx.add_paint({
        $whitePen = new-object System.Drawing.Pen([system.drawing.color]::gray, 3)
        $_.graphics.drawrectangle($whitePen,$this.clientrectangle)
    })

    $ReturnBtn                   = New-Object system.Windows.Forms.Button
    $ReturnBtn.Location = New-Object System.Drawing.Size(5,10)
    $ReturnBtn.Name = "Desktop"
    #$ReturnBtn.Anchor            = 'center'
    $ReturnBtn.BackColor         = "#d2d4d6"
    $ReturnBtn.text              = "بازگشت به   > صفحه قبل"
    $ReturnBtn.width             = 49
    $ReturnBtn.height            = 70
    $ReturnBtn.Font              = 'Microsoft Sans Serif,10'
    $ReturnBtn.ForeColor         = "#000"
    $ReturnBtn.Add_Click({
        $SecoForm.Close()
        $SecoForm.Dispose()
    & "$MainRoot\$($this.Name).ps1"
    }.GetNewClosure())

    $DesktopGB.Controls.Add($ImgFileRembtn)
    $DesktopGB.Controls.Add($ImageBx)
    $DesktopGB.Controls.Add($ImgFileAddbtn)
    $DesktopGB.Controls.Add($ShowPRFbtn)
    $DesktopGB.Controls.Add($ShowMACbtn)
    $DesktopGB.Controls.Add($NewBtn)
    $DesktopGB.Controls.Add($NameLbl)
    $DesktopGB.Controls.Add($CancelBtn)
    $DesktopGB.Controls.Add($SaveBtn)
    $DesktopGB.Controls.Add($NewNameLbl)
    $DesktopGB.Controls.Add($NewFileNameTxb)
    $DesktopGB.Controls.Add($RBGroup)
    $DesktopGB.Controls.Add($TotPercentIB)
    $DesktopGB.Controls.Add($TotMlIB)
    $DesktopGB.Controls.Add($TotLbl)
    $DesktopGB.Controls.Add($GBLbl)

    $DesktopGB.Controls.Add($VerLbl)
    $DesktopGB.Controls.Add($VerTxt)
    $DesktopGB.Controls.Add($TestIDLbl)
    $DesktopGB.Controls.Add($TestIDTxt)
    
    
    $DesktopGB.Controls.Add($ProdLbl)
    $DesktopGB.Controls.Add($ProjLbl)
    #$DesktopGB.Controls.Add($ProdLB)
    $DesktopGB.Controls.Add($EmailGV)
    $DesktopGB.Controls.Add($ProdCatLB)
    $DesktopGB.Controls.Add($PrjNameLB)
    $DesktopGB.Controls.Add($DesktopBtn)
    
    $SecoForm.Controls.Add($ReturnBtn)
    $SecoForm.Controls.Add($SaveBtn)
    $SecoForm.Controls.Add($DesktopGB)

    [void]$SecoForm.ShowDialog()

}
Catch
{ 
    "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
    select -last 1)-Main`t $_ `t$([Environment]::UserName)" | 
    Out-File $ErrLogPath -Append 
}

