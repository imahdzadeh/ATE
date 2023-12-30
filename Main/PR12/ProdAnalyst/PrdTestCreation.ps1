# Created by Isar Mahdzadeh
# Decmeber 12 2023
#

Try
{
    . "$(Split-Path $PSScriptRoot -Parent)\config\$(($PSCommandPath.Split('\') | select -last 1) -replace ('.ps1$','var.ps1'))"
#    throw [System.IO.FileNotFoundException] "$file not found."
    $strDupFileName = $null
    $ProjNames = Get-ChildItem -Path $ProdRoot -Directory | ForEach-Object{$_.Name}
    $DGVCellValueChanging = $flase
    $DGVCBInfo = New-Object system.Data.DataTable
    $DGVCBInfoVer = gci "$confRoot\$ConFolPRF" -file | Foreach{
      $_ -replace '^PRF', ''
      } | Select-Object *, @{ n = "IntVal"; e = {[int]($_)}} | Sort-Object IntVal | Select-Object -Last 1

    $DGVCBInfoCol = @()
    (Get-Content "$confRoot\$ConFolPRF\$ConFolPRF$($DGVCBInfoVer.IntVal)" | select -First 1) -split "," | foreach {
    $DGVCBInfoCol += $_
    $col2 = New-Object System.Data.DataColumn
    $col2.DataType = [string]
    $col2.ColumnName = $_
    $DGVCBInfo.Columns.Add($col2)
    }

    $folderselection = New-Object System.Windows.Forms.OpenFileDialog -Property @{  
        InitialDirectory = [Environment]::GetFolderPath('Desktop')  
        CheckFileExists = 0  
        ValidateNames = 0  
        FileName = "Choose Folder"  
    }  
        

    $DGVCBColumn = New-Object system.Data.DataTable
    [void]$DGVCBColumn.Columns.Add($strCBPeopName)

    Import-Csv "$confRoot\$ConFolPRF\$ConFolPRF$($DGVCBInfoVer.IntVal)" |  foreach {
        $row2 = $DGVCBInfo.NewRow() 
        foreach($column in $DGVCBInfoCol){
            $row2.$column=$_.$column
        }
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
            $strFileName = "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests\$($NewFileNameLbl.Text)$($CSVFileExt)"
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
                                            "$( ($_.Cells | % {$_.Value}) -join ','),$strCreated,$((Get-Date).ToString('MM/dd/yyyy hh:mm tt')),$([Environment]::UserName)".Trim() | 
                                            Out-file $strFileName -Append   
                                        }
                                
                                    }
                                    End{}                           
                                }
                                If($ImageBx.tag -ne $null)
                                {
                                    $ImageBx.Image.Save("$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($NewFileNameLbl.Text)$($ImageExt)")
#                                    $strTemp = "$($NewFileNameLbl.Text)$($ImageExt)"
                                } 
                                "$((Get-Date).ToString('MM/dd/yyyy hh:mm:ss tt'))`t $($PSCommandPath.Split('\') | 
                                select -last 1)-SaveBtn`t $($NewRB.Text) `t $($NewFileNameLbl.Text) `t $Global:StrImageLast `t $([Environment]::UserName)" | 
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
                                        "$( ($_.Cells | % {$_.Value}) -join ','),$strChanged,$((Get-Date).ToString('MM/dd/yyyy hh:mm tt')),$([Environment]::UserName)".Trim() | 
                                        Out-file $strFileName -Append
                                    }                                  
                                }
                                $imageFolTemp = "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\"
                                If($ImageBx.tag -eq $ImgFileAddbtn.Text)
                                {                                 
                                    If(Test-Path "$imageFolTemp$($NewFileNameLbl.Text)$($ImageExt)")
                                    {
                                        Move-Item  "$imageFolTemp$($NewFileNameLbl.Text)$($ImageExt)" "$imageFolTemp$ArchFolder\$($NewFileNameLbl.Text)$($ImageExt)"
                                        Rename-Item "$imageFolTemp$ArchFolder\$($NewFileNameLbl.Text)$($ImageExt)" `
                                        "$imageFolTemp$ArchFolder\$($NewFileNameLbl.Text)_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss tt'))$($ImageExt)"
#                                        $strTemp = "$($NewFileNameLbl.Text)_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss tt'))$($ImageExt)"
                                    }
                                    $ImageBx.Image.Save("$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($NewFileNameLbl.Text)$($ImageExt)")
                                }
                                Else
                                {
                                     If((Test-Path "$imageFolTemp$($NewFileNameLbl.Text)$($ImageExt)") -and ($ImageBx.tag -eq $ImgFileRembtn.Text))
                                     {
                                        Move-Item  "$imageFolTemp$($NewFileNameLbl.Text)$($ImageExt)" "$imageFolTemp$ArchFolder\$($NewFileNameLbl.Text)$($ImageExt)"
                                        Rename-Item "$imageFolTemp$ArchFolder\$($NewFileNameLbl.Text)$($ImageExt)" `
                                        "$imageFolTemp$ArchFolder\$($NewFileNameLbl.Text)_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss tt'))$($ImageExt)"                                       
                                     }
                                } 
                                "$((Get-Date).ToString('MM/dd/yyyy hh:mm:ss tt'))`t $($PSCommandPath.Split('\') | 
                                select -last 1)-SaveBtn`t $($OldRB.Text)`t $($NewFileNameLbl.Text) `t $Global:StrImageLast `t $([Environment]::UserName)" | 
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
                            select -last 1)-SaveBtn`t لطفا مقادیر مواد اولیه را وارد کنید ، ذخیره انجام نشد `t$($NewFileNameLbl.Text) `t$([Environment]::UserName)" | 
                            Out-File $UserLogPath -Append                                
                        }
                    }
                    Else
                    {
                        [System.Windows.MessageBox]::Show("وجود دارد، ذخیره انجام نشد $($Global:strDupFileName) فرمول مشابه در شماره")
                        "$((Get-Date).ToString('MM/dd/yyyy hh:mm:ss tt'))`t $($PSCommandPath.Split('\') | 
                        select -last 1)-SaveBtn`t وجود دارد، ذخیره انجام نشد $($strDupFileName) فرمول مشابه در شماره `t$($NewFileNameLbl.Text) `t$([Environment]::UserName)" | 
                        Out-File $UserLogPath -Append                            
                    }
                }
                Else
                {
                    [System.Windows.MessageBox]::Show("سطر خالی وجود دارد، ذخیره انجام نشد $($strCBPeopName) در ستون")
                    "$((Get-Date).ToString('MM/dd/yyyy hh:mm:ss tt'))`t $($PSCommandPath.Split('\') | 
                    select -last 1)-SaveBtn`t سطر خالی وجود دارد، ذخیره انجام نشد $($strCBPeopName) در ستون `t$($NewFileNameLbl.Text) `t$([Environment]::UserName)" | 
                    Out-File $UserLogPath -Append  
                }
            }
            Else
            {
                [System.Windows.MessageBox]::Show("تکرار وجود دارد، ذخیره انجام نشد $($strCBPeopName) در ستون")
                "$((Get-Date).ToString('MM/dd/yyyy hh:mm:ss tt'))`t $($PSCommandPath.Split('\') | 
                select -last 1)-SaveBtn`t کرار وجود دارد، ذخیره انجام نشد $($strCBPeopName) در ستون `t$($NewFileNameLbl.Text) `t$([Environment]::UserName)" | 
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
                    If (($bolCHK -eq $false) -and ($_.Name -ne "$($NewFileNameLbl.Text)$($CSVFileExt)")){
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
        $NewFileNameLbl.Text = "" 
        $NewNameLbl.Visible = $false
        $NameLbl.Visible = $false 
    } 

    Function funOldRBClick{
        Try
        {
            $ProdLB.Enabled = $true
            $DesktopBtn.Enabled = $false
            $EmailGV.Enabled = $false 
            $NewFileNameLbl.Text = ""
            $NewNameLbl.Visible = $false 
            $PRFFiles = Get-ChildItem -Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests" -File | 
            ForEach-Object{$_.Name.TrimEnd($CSVFileExt)}
            If ($PRFFiles -ne $null)
            {
                $ProdLB.Items.AddRange($PRFFiles)
            }
        }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-funOldRBClick`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append  
        } 
    } 

    Function funDisAllCB{
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
        $NewNameLbl.Visible = $false 
        $NewFileNameLbl.Text = ""
        $Cancelbtn.Enabled = $flase
        $saveBtn.Enabled = $false
        $ProdCatLB.Text = $null
        $NameLbl.Visible = $false
        $PrjNameLB.Enabled = $true
        $ImageBx.Image = $null
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
            $intSum = 0
            $intCal = 0
            If ($NewRB.Checked){
                $ConfFileVer = $null
                $TotMlIB.Text = 0
                $TotPercentIB.Text = 0
                $ConfFileVer = gci "$confRoot\$ConFolPRF" -file | Foreach{
                    $_ -match $RegExVerVar
                    } | Select-Object *, @{ n = "IntVal"; e = {[int]($Matches[2])}} | Sort-Object IntVal | Select-Object -Last 1

                $ConfFileNo = $null
                $ConfFileNo = gci "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)" -file -Recurse| Foreach{
                    $_ -match $RegExNoVar
                    } | Select-Object *, @{ n = "IntVal"; e = {[int]($Matches[4])}} | Sort-Object IntVal | Select-Object -Last 1
                $NewFileNameLbl.Text = "$($ConFolPRF)$($ConfFileVer.IntVal)$($DepCode)$($ConfFileNo.IntVal+1)" 
                $NewNameLbl.Visible = $true
            }
            Else
            {
                Get-Content "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$FolderNameTests\$($ProdLB.SelectedItem)$CSVFileExt" | 
                Where-Object { !$_.StartsWith("#") } | ConvertFrom-Csv | Foreach {
                    $row = $DGVDataTab.NewRow() 
                    foreach($column in $DGVDataTab.Columns)
                    {            
                        $row.($column.columnname)=$_.($column.columnname)
                    }
                    $DGVDataTab.Rows.Add($row)
                }
                $NewFileNameLbl.Text = $ProdLB.SelectedItem
                $NameLbl.Visible = $true
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
                $TotPercentIB.Text = $intSum
                $TotMlIB.Text = [math]::round($intCal,2)
                If(Test-Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($NewFileNameLbl.Text)$($ImageExt)")
                    {
 #                       $imgFile = (Get-Item $dialog.FileName)
                        $Global:img = [System.Drawing.Image]::Fromfile("$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($NewFileNameLbl.Text)$($ImageExt)");
                        $ImageBx.Image = $Global:img
                        $ImageBx.Tag = $imgFile.Name
#                        $ImageBx.Image.Save("$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($NewFileNameLbl.Text)$($ImageExt)")
#                        $Global:img.Dispose()
                    } 
            }
            If($ImageBx.Image -ne $null){$ImgFileRembtn.Enabled = $true}
        }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-funShowInfo`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append 
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
            gci "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$($MatCodeFol)" -file | Foreach{
                If( $_.Name -match $RegExMAC)
                {
                    $objDTV += Import-Csv $_.FullName
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
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-funShowMAC`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append 
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
                If($objShowFrmArr -ne 'عکس')
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
                        $intIterate = $intIterate + 1
                        If($intIterate -eq 1)
                        {
                            $ShowPRFDGV.rows.Add((, $DGVImage +(,$FileName +($_ -split ',')[3..5])))                           
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
<#
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
#>
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
    $EmailGV.Location = New-Object System.Drawing.size(80,115)
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
    $EmailGV.Size=New-Object System.Drawing.Size($HeaderWidth,350)
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
        Try
        {
            $intSum = 0
            $intCal = 0
            If (!$DGVCellValueChanging){
                $DGVCellValueChanging = $true  
                If ($_.columnindex -eq $intColToSum)
                {
                        foreach ($TGVRow in $EmailGV.Rows)
                        {
                        $TGVRow.HeaderCell.Value = ($TGVRow.Index +1).ToString()
                            If ($TGVRow.cells[$intColToSum].Value -match '^\d*\.?\d+$') 
                            {
                                $intSum  = $intSum + [int]($TGVRow.cells[$intColToSum].Value) 
                            }
                            If ($TotMlIB.Text -match '^\d*\.?\d+$' )
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
                        $TotPercentIB.text = $intSum
                }
                Else
                {
                    If ($_.columnindex -eq $intColToCal)
                    {
                        foreach ($TGVRow in $EmailGV.Rows)
                        {
                            If ($TGVRow.cells[$intColToCal].Value -match '^\d*\.?\d+$') 
                            {
                                If($TGVRow.cells[$intColToCal].Value -ne [System.DBNull]::Value)
                                {
                                    $intCal  = $intCal + [int]($TGVRow.cells[$intColToCal].Value) 
                                }
                            }
                        }
                         $TotMlIB.text = $intCal
                        foreach ($TGVRow in $EmailGV.Rows)
                        {
                            If ($TGVRow.cells[$intColToCal].Value -match '^\d*\.?\d+$' -or $TGVRow.cells[$intColToCal].Value -eq [System.DBNull]::Value) 
                            {
                                If($TGVRow.cells[$intColToCal].Value -ne [System.DBNull]::Value -and $TGVRow.cells[$intColToCal].Value -ne 0)
                                {
                                    $TGVRow.cells[$intColToSum].Value = [math]::round(( ([int]($TGVRow.cells[$intColToCal].Value)/([int]($TotMlIB.Text)))*100).ToString(),2)
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
                        $TotPercentIB.text = $intSum
                        $DGVCellValueChanging = $false                            
                    }
                }

            }
        }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-EmailGV.Add_CellValueChanged`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append  
        }    
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
        Try
        {
            $NewRB.Enabled = $true
            $OldRB.Enabled = $true
            $RBGroup.Enabled = $true
            $ShowMACbtn.Enabled = $true
            $ShowPRFbtn.Enabled = $true
            $DGVCBColumn.Rows.Clear()
            gci "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$($MatCodeFol)" -file | Foreach{
                       If( $_.Name -match $RegExMAC)
                       {
                            Get-Content $_.FullName | ConvertFrom-Csv  |Select -ExpandProperty $strCBPeopName | foreach {
                                [void]$DGVCBColumn.Rows.Add($_)
                            }
                       }
            }
        }
        Catch
        {
            "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
            select -last 1)-ProdCatLB.Add_SelectedIndexChanged`t $_ `t$([Environment]::UserName)" | 
            Out-File $ErrLogPath -Append  
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

    $NewNameLbl = New-Object System.Windows.Forms.label
    $NewNameLbl.Location = New-Object System.Drawing.size(200,85)
    $NewNameLbl.Size = New-Object System.Drawing.Size(80,20) 
    $NewNameLbl.Text = ":شماره آزمایش جدید" 
    $NewNameLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomleft
    $NewNameLbl.Visible = $false
    $NewNameLbl.BackColor = ''

    $NameLbl = New-Object System.Windows.Forms.label
    $NameLbl.Location = New-Object System.Drawing.size(195,85)
    $NameLbl.Size = New-Object System.Drawing.Size(70,20) 
    $NameLbl.Text = ":شماره آزمایش" 
    $NameLbl.TextAlign=[System.Drawing.ContentAlignment]::bottomleft
    $NameLbl.Visible = $False
    $NameLbl.BackColor = ''

    $NewFileNameLbl = New-Object System.Windows.Forms.label
    $NewFileNameLbl.Location = New-Object System.Drawing.size(90,85)
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
        If ($TotPercentIB.text -eq 100)
        {
           $TotPercentIB.BackColor = 'lightgreen' 
        }
        Else
        {
             $TotPercentIB.BackColor = ''
        }
    
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
    If ($TotMlIB.Text -match '\D'){
            $TotMlIB.BackColor = 'red' 
        }
        Else
        {
            $TotMlIB.BackColor = '' 
        }

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
    $OldRB.Location = New-Object System.Drawing.size(140,12)
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
    $NewRB.Location = New-Object System.Drawing.size(255,12)
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
    $ProdLB.Size = New-Object System.Drawing.Size(120,30)
    $ProdLB.AutoCompleteSource = 'ListItems'
    $ProdLB.AutoCompleteMode = 'Append'
    #$ProdLB.Text = 200
    $ProdLB.Enabled = $false
    $ProdLB.DrawMode = [System.Windows.Forms.DrawMode]::OwnerDrawFixed
    $ProdLB.add_DrawItem({
    
        param([System.Object]$s, [System.Windows.Forms.DrawItemEventArgs]$e)
        if ($s.Items.Count -eq 0) {return}

        If(Test-Path "$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($s.Items[$e.Index])$($ImageExt)")
            {
#                       $imgFile = (Get-Item $dialog.FileName)
                $Global:img = [System.Drawing.Image]::Fromfile("$ProdRoot\$($PrjNameLB.SelectedItem)\$($ProdCatLB.SelectedItem)\$imgFolder\$($s.Items[$e.Index])$($ImageExt)");
                $e.Graphics.DrawImage($Global:img,0,$e.Bounds.Y+2.5,10,10)
                $Global:img.Dispose()
            } 
             
        #Suppose item de type String
#        $Graphics = $e.Graphics
#        $Rectangle = $e.Bounds
 #       $e.DrawBackground()
#       if ($e.Index -ge 0) {
#            $Name = ([System.Windows.Forms.ComboBox]$s).Items[$e.Index].ToString()
#            $Font = [System.Drawing.Font]::new("Arial", 10, [System.Drawing.FontStyle]::Regular)
#            $Color = [System.Drawing.Color]::FromName($Name)
#            $Brush = [System.Drawing.SolidBrush]::new($Color)
            # Can uncomment this if you do not want the background highlighted when hovering over item.
            # $Graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
#            $Graphics.DrawString($Name, $Font, [System.Drawing.Brushes]::Black, $Rectangle.X, $Rectangle.Top)
#            $Graphics.FillRectangle($Brush, $Rectangle.X + 110, $Rectangle.Y + 5, $Rectangle.Width -10, $Rectangle.Height -10)
        
            # Dispose of disposable objects
 #           $Brush.Dispose()
  #      }
        $e.Graphics.DrawString($s.Items[$e.Index], $e.Font, [System.Drawing.SystemBrushes]::ControlText, $e.Bounds.Left+10, $e.Bounds.Top, [System.Drawing.StringFormat]::GenericDefault)
        
    })
    $ProdLB.Add_SelectedIndexChanged({
      
        $DesktopBtn.Enabled = $True  
    })

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
    $CancelBtn.Add_Click({
        $PrjNameLB.ResetText()
        funDisAllCB
    })

    $SaveBtn = New-Object system.Windows.Forms.Button
    $SaveBtn.Location = New-Object System.Drawing.Size(100,505) 
    $SaveBtn.BackColor = "#d2d4d6"
    $SaveBtn.text = "ذخیره"
    $SaveBtn.width = 120
    $SaveBtn.height = 35
    $SaveBtn.Font = 'Microsoft Sans Serif,10'
    $SaveBtn.ForeColor = "#000"
    $SaveBtn.Enabled = $false
    $SaveBtn.Add_Click({funSaveBtn})

    $NewBtn = New-Object system.Windows.Forms.Button
    $NewBtn.Location = New-Object System.Drawing.Size(470,505) 
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
    $ImgFileAddbtn.Location = New-Object System.Drawing.Size(180,55) 
    $ImgFileAddbtn.BackColor = "#d2d4d6"
    $ImgFileAddbtn.text = "اضافه کردن عکس"
    $ImgFileAddbtn.width = 100
    $ImgFileAddbtn.height = 25
    $ImgFileAddbtn.Font = 'Microsoft Sans Serif,10'
    $ImgFileAddbtn.Enabled = $False
    $ImgFileAddbtn.ForeColor = "#000"
    $ImgFileAddbtn.Add_Click({funImgAddFile})

    $ImgFileRembtn = New-Object system.Windows.Forms.Button
    $ImgFileRembtn.Location = New-Object System.Drawing.Size(180,25) 
    $ImgFileRembtn.BackColor = "#d2d4d6"
    $ImgFileRembtn.text = "حذف عکس"
    $ImgFileRembtn.width = 100
    $ImgFileRembtn.height = 25
    $ImgFileRembtn.Font = 'Microsoft Sans Serif,10'
    $ImgFileRembtn.Enabled = $False
    $ImgFileRembtn.ForeColor = "#000"
    $ImgFileRembtn.Add_Click({funImgRemFile})

    $ImageBx = new-object Windows.Forms.PictureBox
    $ImageBx.Location = New-Object System.Drawing.Size(95,25)
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
    #    & D:\ATE\IT\Root\Main\Main.ps1
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
    
    $SecoForm.Controls.Add($ReturnBtn)
    $SecoForm.Controls.Add($SaveBtn)
    $SecoForm.Controls.Add($DesktopGB)

    #$SecoForm.Add_Shown({funDisAllCB})
    [void]$SecoForm.ShowDialog()
    <#
    $SecoForm.Add_KeyDown({
        $_.SuppressKeyPress = $True
     #   if     ($_.KeyCode -eq "Enter"){& $button_click}
        if     ($_.KeyCode -eq "Enter"){}
        elseif (($_.Control) -and ($_.KeyCode -eq 'A')){$objTextbox.SelectAll()}
        elseif ($_.KeyCode -eq "Escape"){$Form1.Close()}
        else {$_.SuppressKeyPress = $False}
        })
    #>
}
Catch
{ 
    "$((Get-Date).ToString('MM/dd/yyyy hh:mm tt'))`t $($PSCommandPath.Split('\') | 
    select -last 1)-Main`t $_ `t$([Environment]::UserName)" | 
    Out-File $ErrLogPath -Append 
}
