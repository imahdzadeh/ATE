# Created by Isar Mahdzadeh
# Decmeber 12 2023
# imahdzadeh@gmail.com
# Atenshin Elsci

. "$(Split-Path $PSScriptRoot -Parent)\Config\$(($PSCommandPath.Split('\') | select -last 1) -replace (".ps1$","var.ps1"))"



If($varDebugTrace -ne 0){Set-PSDebug -Trace $varDebugTrace}Else{Set-PSDebug -Trace $varDebugTrace}
Function funScale ($Magobj){
    
    If($Magobj.Name -eq $ZoomIn.Name)
    {
        $Global:ScaleUnit = 1.05
        Write-Host $ZoomIn.Name
        $desktoppan.Invalidate()
    }
        ElseIf($Magobj.Name -eq $ZoomOut.Name)
        {
            Write-Host $ZoomOut.Name
            $Global:ScaleUnit = 0.95
            $desktoppan.Invalidate()
        }
            ElseIf($Magobj.Name -eq $Magnifier.Name)
            {
                Write-Host $Magnifier.Name
                $Global:ScaleUnit = 1
                $desktoppan.Invalidate()
            }
    $Magobj.Checked = $false
}  

Function funTextIconClick{
    If($TextIcon.Checked)
    {   
        If($global:objShape -ne $null)
        { 
            $Global:typing = $global:objShape
            $Global:SelText = $global:objShape
        }
            ElseIf($Global:SelPath -ne $Null)
            {
                $Global:typing = $Global:SelPath

            }
#                ElseIf($global:objGroup -ne $Null)
                ElseIf($global:objGroup -ne $Null )
                {
                    $Global:typing = $global:objGroup
                    $Global:SelText = $global:objGroup
                }
     }  
}               

Function funFormKeyDown{
    If($Global:typing -eq $null)
    {
        if ($_.KeyCode -eq [Keys]::Delete) 
        {     
            funDelShape
        }
    }
    Else
    {
        If($_.Keycode -eq [Keys]::Return)
        {
            $Global:typing.Text = "$($Global:typing.Text)`n"
        }
            ElseIf($_.Keydata -match "Shift" -and $_.Keycode -ne "ShiftKey")
            {
                If($_.Keycode -match "^([^0-9]*)$")
                {
                    $Global:typing.Text = "$($Global:typing.Text)$($_.Keycode)"
                }                
#               [Console]::beep(500, 600)
            }
                ElseIf($_.Keycode -eq [Keys]::Back)
                {
                    If($Global:typing.Text.Length -gt 0)
                    {
                        $Global:typing.Text = $Global:typing.Text.Substring(0,($Global:typing.Text.Length-1))
                    }   
                }
                    ElseIf($_.Keycode -eq [Keys]::Space)
                    {
                        $Global:typing.Text = "$($Global:typing.Text) "
                    }
        Else
        {
            If([char]$_.Keyvalue -match "\w")
            {
                $char = "$([char]$_.Keyvalue)".ToLower()
                $Global:typing.Text = "$($Global:typing.Text)$char"
            }
        }
        $desktopPan.Invalidate()
    }
}

Function funDelShape{
    If ($MainObject.arrRegions.Count -gt 0 -and $global:objShape -ne $null)
    {
        $MainObject.arrRegions.Remove($global:objShape)        
        $Global:objShape = $Null              
    }
        ElseIf($MainObject.arrGroups.Count -gt 0 -and $Global:objGroup)
        {
            $MainObject.arrGroups.Remove($Global:objGroup)
            $Global:objGroup = $Null
            $Global:objGroup.AxisPath = $Null
        }
    Else
    {
        If($Global:SelPath -ne $Null)
        {
            for($i = 0; $i -lt $MainObject.arrRegions.Count; $i++)
            {
                for($q = 0; $q -lt $MainObject.arrRegions[$i].ConnArr.Count; $q++)
                {
                    If($MainObject.arrRegions[$i].ConnArr[$q] -eq $Global:SelPath)
                    {
                        $MainObject.arrRegions[$i].ConnArr.Remove($Global:SelPath)
                        $Global:SelPath = $Null
                        Break
                    }
                }
            }
        }
    }
    $DesktopPan.Invalidate()     
}

Function funImgStreamer($imgPath){

    $inStream = ([FileInfo]$imgPath).Open([FileMode]::Open, [FileAccess]::ReadWrite)
    [Image]::FromStream($inStream)
    $inStream.Dispose()
}

Function funDPanMouseDown{
    $Global:bolMouseDown = $true
    $BolContRegions = $false
    $BolContGroup = $false
    $mouse = [Cursor]::Position
    $point = $DesktopPan.PointToClient($mouse)
    If(!$TextIcon.Checked)
    {
        $Global:SelPath = $Null
        for($i = 0; $i -lt $MainObject.arrRegions.Count; $i++)
        {
            $arrItem = $MainObject.arrRegions[$i]
            $Global:typing = $null
            If ($arrItem.ShadowRegion.isVisible($point))
            {
                $SubProcess.Checked
                $BolContRegions = $True
                If(
                    $arrItem.pTopRegion.isVisible($point) -or 
                    $arrItem.pRightRegion.isVisible($point) -or 
                    $arrItem.pBottomRegion.isVisible($point) -or 
                    $arrItem.pLeftRegion.isVisible($point)
                    )
                {
                    If (($Global:objShape -ne $null) -and ($Global:objShape -ne $arrItem))
                    { 
                        If(!$Global:objShape.ConnArr.Contains($arrItem) -and (!$arrItem.ConnArr.Contains($Global:objShape)))
                        {
                            If($arrItem.pTopRegion.isVisible($point)){$TempPoint = "pTop"}
                            If($arrItem.pRightRegion.isVisible($point)){$TempPoint = "pRight"}
                            If($arrItem.pBottomRegion.isVisible($point)){$TempPoint = "pBottom"}
                            If($arrItem.pLeftRegion.isVisible($point)){$TempPoint = "pLeft"}
                            for($j = 0; $j -lt $Global:objShape.ConnArr.Count; $j++)
                            {
                                If($Global:objShape.ConnArr[$j].StartPoint -eq $Global:objShapePoint)
                                {
                                    $Global:objShape.ConnArr[$j].ConnPoint = $TempPoint
                                    $Global:objShape.ConnArr[$j].ConnObj = $arrItem                                            
                                    funDisAllShapes $null
                                }
                            }                                                                       
                            $Global:objShape.ConnArr
                            $Global:objShapePoint = $null
                            $Global:objShape = $null
                        }                        
                    }
                        ElseIf(($Global:objShape -ne $null) -and ($Global:objShape -eq $arrItem) -and ($SolidLine.Checked -Or $DashedLine.Checked -Or $DottedLine.Checked))
                        {
                            If($arrItem.pTopRegion.isVisible($point)){$Global:objShapePoint = "pTop"}
                            If($arrItem.pRightRegion.isVisible($point)){$Global:objShapePoint = "pRight"}
                            If($arrItem.pBottomRegion.isVisible($point)){$Global:objShapePoint = "pBottom"}
                            If($arrItem.pLeftRegion.isVisible($point)){$Global:objShapePoint = "pLeft"}
                            $objConn = [pscustomobject]@{
                                Points = [ArrayList]@()
                                ConnObj = $Null
                                Name = $arrItem.Name
                                ConnType = "Out"
                                StartPoint = $Global:objShapePoint
                                ConnPoint = $null 
                                Path = $null
                                Text = ""
                                pCenter = $point
                                TextPath = $Null
                                pTXDiffer = 0
                                pTYDiffer = 0
                                LineStyle = ($LinesTbl.Controls | Where-Object -FilterScript {$_.Checked}).Tag
                            }
                            $Global:objShape.ConnArr.Add($objConn)                                                                                
                        }
                    Else
                    {
                        $Global:objShapePoint = $null
                    }
                }
                If(
                    ($SubIconTbl.Controls | Where-Object -FilterScript {$_.Checked}) -and 
                    !($LinesTbl.Controls | Where-Object -FilterScript {$_.Checked})
                  )                    
                {
                    If($SubProcess.Checked -and $arrItem.Type -eq $Square.Name)
                    {
                        If($arrItem.SubProcess)
                        {
                            $arrItem.SubProcess = $false
                        }
                        Else
                        {
                            $arrItem.SubProcess = $true
                        }                                
                    }
                    Else
                    {
                        If($arrItem.Icon -eq "" -Or $arrItem.Icon -ne ($SubIconTbl.Controls | Where-Object -FilterScript {$_.Checked}).Name)
                        {
                            $arrItem.Icon = ($SubIconTbl.Controls | Where-Object -FilterScript {$_.Checked}).Name
                        }
                        Else
                        {
                            $arrItem.Icon = ""
                        }
                    }
                }                              
                Else
                {
                    If(!($LinesTbl.Controls | Where-Object -FilterScript {$_.Checked}))
                    {
                        funDisAllShapes $null
                        $Global:objShape = $null
                    }
                }                                             
                $global:objShape = $arrItem                           
            }
            Else
            {
                for($q = 0; $q -lt $arrItem.ConnArr.Count; $q++)
                {
                    If($arrItem.ConnArr[$q].Path.isVisible($point))
                    {
                        $Global:SelPath = $arrItem.ConnArr[$q]  
                    } 
                }
            }             
        }
        If(!$BolContRegions)
        {
            If(
                ($LinesTbl.Controls | Where-Object -FilterScript {$_.Checked}) -and 
                ($Global:objShapePoint -ne $null) -and ($Global:objShape -ne $null)
              )
            {
                for($g = 0; $g -lt $Global:objShape.ConnArr.Count; $g++)
                {
                    $connArrItem = $Global:objShape.ConnArr[$g]
                    If($connArrItem.StartPoint -eq $Global:objShapePoint)
                    {
                        $connArrItem.Points.add($point) 
                    }
                }                      
            }
            Else
            {
                for($i = 0; $i -lt $MainObject.arrGroups.Count; $i++)
                {
                    $arrGroItem = $MainObject.arrGroups[$i]
                    $Global:typing = $null
                    If($arrGroItem.TopPath.isVisible($point))
                        {   
                            $BolContGroups = $True
                            $arrGroItem.AxisPath = "TopPath"
                            $Global:objGroup = $arrGroItem
                            $arrGroItem.TPoint = $point
                        }
                            ElseIf($arrGroItem.RightPath.isVisible($point))
                            {
                                $BolContGroups = $True
                                $arrGroItem.AxisPath = "RightPath"
                                $Global:objGroup = $arrGroItem 
                                $arrGroItem.TPoint = $point                     
                            }
                                ElseIf($arrGroItem.BottomPath.isVisible($point))
                                {
                                    $BolContGroups = $True
                                    $arrGroItem.AxisPath = "BottomPath"
                                    $Global:objGroup = $arrGroItem  
                                    $arrGroItem.TPoint = $point                           
                                }
                                    ElseIf($arrGroItem.LeftPath.isVisible($point))
                                    {
                                        $BolContGroups = $True
                                        $arrGroItem.AxisPath = "LeftPath"
                                        $Global:objGroup = $arrGroItem 
                                        $arrGroItem.TPoint = $point                                  
                                    }
                                        ElseIf($arrGroItem.TAreaPath.isVisible($point))
                                        {
                                            $BolContGroups = $True
                                            $arrGroItem.AxisPath = "TAreaPath"
                                            $Global:objGroup = $arrGroItem
                                            $arrGroItem.TPoint = $point                               
                                        }
                    Else
                    {
                        for($h = 1; $h -lt $arrGroItem.Lanes.Count; $h++)
                        {
                            If($arrGroItem.Lanes[$h].LanePath.isVisible($point))
                            {
                                $BolContGroups = $True
                                $Global:SelLane = $arrGroItem.Lanes[$h]
                            }
                                ElseIf($arrGroItem.Lanes[$h].TAreaPath.isVisible($point))
                                {
                                    $BolContGroups = $True
                                    $Global:SelPath = $arrGroItem.Lanes[$h]
                                } 
                        }                                                                      
                    }                                                        
                }
                If(!$BolContGroups -and $Global:objGroup -ne $Null)
                {
                    $Global:objGroup.AxisPath = ""
                    $Global:objGroup = $Null
                        
                }
                $Global:objShape = $null
                $Global:objShapePoint = $null                   
            }
        }               
    }   
    $DesktopPan.Invalidate() 
}

Function funDPanAddpaint($s,$e){
#    $e.Graphics.InterpolationMode = 2
    $frmPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $e.Graphics.SmoothingMode = 4
    $mouse = [Cursor]::Position
    $point = $DesktopPan.PointToClient($mouse)
    $strSwitch = ""
#    If ($StartCircle.Checked -or $Dimond.Checked -or $Square.Checked -Or $InterCircle.Checked -Or $DataObject.Checked)
    If($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked})
    {
        $strSwitch = ($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name
        $Global:intIterate ++
        $name = "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
    }
    If($Pool.Checked)
    {
        $strSwitch = $Pool.name
        $Global:intIterate ++
        $name = "$strSwitch$Global:intIterate"  
    }
    If($Lane.Checked -and $Global:objGroup -ne $Null)
    {
        $strSwitch = $Lane.name
        $Global:intIterate ++
        $name = "$strSwitch$Global:intIterate"
    }
    If($Global:SelText -eq $Null -and $Global:SelPath -eq $null -and $Global:SelLane -eq $Null)
    {
        If($Global:bolMouseMove -And $Global:bolMouseDown -And $global:objShape -ne $null)
        {
            $strSwitch = $global:objShape.type  
        }
            ElseIf($Global:bolMouseMove -And $Global:bolMouseDown -And $Global:objGroup -ne $null)
            {
                $strSwitch = $Global:objGroup.type
            }
    }
        ElseIf($TextIcon.Checked -and $Global:bolMouseDown -and $Global:SelText -ne $Null)
        {
            $Global:SelText.pTXDiffer = $Global:SelText.pCenter.x - $point.x
            $Global:SelText.pTYDiffer = $Global:SelText.pCenter.Y - $point.Y
        }
            ElseIf($TextIcon.Checked -and $Global:bolMouseDown -and $Global:SelPath -ne $Null)
            {            
                $Global:SelPath.pTXDiffer = $Global:SelPath.pCenter.X - $point.X
                $Global:SelPath.pTYDiffer = $Global:SelPath.pCenter.Y - $point.Y
            }
    Else
    {
        If($Global:SelLane -ne $Null)
        {
            $Global:SelLane.LaneHeight = $Global:SelLane.LaneHeight + ($point.Y - $Global:SelLane.pBottom1.Y)
            
        }
    }    
    If($Global:Loading)
    {
        $point = $Global:SerializedP
        $strSwitch = $global:serializedObj
        $name = "$strSwitch$($Global:intIterate)"
    }
    $MainPath = New-Object Drawing2D.GraphicsPath
    $ShadowPath = New-Object Drawing2D.GraphicsPath
    $pTopPath = New-Object Drawing2D.GraphicsPath
    $pRightPath = New-Object Drawing2D.GraphicsPath
    $pBottomPath = New-Object Drawing2D.GraphicsPath
    $pLeftPath = New-Object Drawing2D.GraphicsPath
    $TopPath = New-Object Drawing2D.GraphicsPath
    $RightPath = New-Object Drawing2D.GraphicsPath
    $BottomPath = New-Object Drawing2D.GraphicsPath
    $LeftPath = New-Object Drawing2D.GraphicsPath
    $TLinePath = New-Object Drawing2D.GraphicsPath
    $TAreaPath = New-Object Drawing2D.GraphicsPath
    $TextPath = New-Object Drawing2D.GraphicsPath
    
    switch ($strSwitch)
    {
        $DoubleCircle.Name { 
            $point.X = $point.X - ($StartCircleSize / $intDevideBy2)
            $point.Y = $point.Y - ($StartCircleSize / $intDevideBy2)
            $sizeDevidedBy2 = $StartCircleSize / $intDevideBy2            
            $TopPointGB = New-Object Point ($point.X) , ($point.Y - $adjustPixel)
            $BottomPointGB = New-Object Point ($point.X) , (($point.Y + $StartCircleSize) + $adjustPixel)
            $pCenter = New-Object Point ($point.X + ($sizeDevidedBy2)) , ($point.Y + $sizeDevidedBy2)
            $pTop = New-Object Point ($point.X + $sizeDevidedBy2), $point.Y
            $pRight = New-Object Point (($point.X + $sizeDevidedBy2) + ($sizeDevidedBy2)) , ($point.Y + $sizeDevidedBy2)
            $pBottom = New-Object Point ($point.X + $sizeDevidedBy2) , (($point.Y + $sizeDevidedBy2) + ($sizeDevidedBy2))
            $pLeft = New-Object Point (($point.X + $sizeDevidedBy2) - $sizeDevidedBy2) , ($point.Y + $sizeDevidedBy2)                               
            $MainPath.AddEllipse($point.X,$point.Y,$StartCircleSize,$StartCircleSize)
            $MainPath.AddEllipse($point.X+$intDevideBy2,$point.Y+$intDevideBy2,$StartCircleSize-$intArrowSize,$StartCircleSize-$intArrowSize)
            $pTopPath.AddEllipse($pTop.X-($ConnPSize / $intDevideBy2),$pTop.Y,$ConnPSize,$ConnPSize)
            $pRightPath.AddEllipse($pRight.X - ($ConnPSize), $pRight.Y - ($ConnPSize / $intDevideBy2),$ConnPSize,$ConnPSize)
            $pLeftPath.AddEllipse($pLeft.X,($pLeft.Y - ($ConnPSize / $intDevideBy2)),$ConnPSize,$ConnPSize)
            $pBottomPath.AddEllipse($pBottom.X - ($ConnPSize / $intDevideBy2),($pBottom.Y - ($ConnPSize)),$ConnPSize,$ConnPSize)
            $ShadowPath.AddEllipse(($point.X)-$ShadowSize,($point.Y)-$ShadowSize,$StartCircleSize+($ShadowSize*$intMultiplyBy2),$StartCircleSize+($ShadowSize*$intMultiplyBy2))
            $fillColor = [color]::White                  
            $maxConn = 1
            $bolInput = $false
            $MainPen = $GroupPen
        }
        $StartCircle.Name { 
            $point.X = $point.X - ($StartCircleSize / $intDevideBy2)
            $point.Y = $point.Y - ($StartCircleSize / $intDevideBy2)
            $sizeDevidedBy2 = $StartCircleSize / $intDevideBy2            
            $TopPointGB = New-Object Point ($point.X) , ($point.Y - $adjustPixel)
            $BottomPointGB = New-Object Point ($point.X) , (($point.Y + $StartCircleSize) + $adjustPixel)
            $pCenter = New-Object Point ($point.X + ($sizeDevidedBy2)) , ($point.Y + $sizeDevidedBy2)
            $pTop = New-Object Point ($point.X + $sizeDevidedBy2), $point.Y
            $pRight = New-Object Point (($point.X + $sizeDevidedBy2) + ($sizeDevidedBy2)) , ($point.Y + $sizeDevidedBy2)
            $pBottom = New-Object Point ($point.X + $sizeDevidedBy2) , (($point.Y + $sizeDevidedBy2) + ($sizeDevidedBy2))
            $pLeft = New-Object Point (($point.X + $sizeDevidedBy2) - $sizeDevidedBy2) , ($point.Y + $sizeDevidedBy2)                               
            $MainPath.AddEllipse($point.X,$point.Y,$StartCircleSize,$StartCircleSize)
            $pTopPath.AddEllipse($pTop.X-($ConnPSize / $intDevideBy2),$pTop.Y,$ConnPSize,$ConnPSize)
            $pRightPath.AddEllipse($pRight.X - ($ConnPSize), $pRight.Y - ($ConnPSize / $intDevideBy2),$ConnPSize,$ConnPSize)
            $pLeftPath.AddEllipse($pLeft.X,($pLeft.Y - ($ConnPSize / $intDevideBy2)),$ConnPSize,$ConnPSize)
            $pBottomPath.AddEllipse($pBottom.X - ($ConnPSize / $intDevideBy2),($pBottom.Y - ($ConnPSize)),$ConnPSize,$ConnPSize)
            $ShadowPath.AddEllipse(($point.X)-$ShadowSize,($point.Y)-$ShadowSize,$StartCircleSize+($ShadowSize*$intMultiplyBy2),$StartCircleSize+($ShadowSize*$intMultiplyBy2))
            $fillColor = [color]::lightgreen                  
            $maxConn = 1
            $bolInput = $false
            $MainPen = $RegPen
        }
        $InterCircle.Name {
            $point.X = $point.X - ($InterCircleSize / $intDevideBy2)
            $point.Y = $point.Y - ($InterCircleSize / $intDevideBy2)
            $sizeDevidedBy2 = $InterCircleSize / $intDevideBy2            
            $TopPointGB = New-Object Point ($point.X) , ($point.Y - $adjustPixel)
            $BottomPointGB = New-Object Point ($point.X) , (($point.Y + $InterCircleSize) + $adjustPixel)
            $pCenter = New-Object Point ($point.X + ($sizeDevidedBy2)) , ($point.Y + $sizeDevidedBy2)
            $pTop = New-Object Point ($point.X + $sizeDevidedBy2), $point.Y
            $pRight = New-Object Point (($point.X + $sizeDevidedBy2) + ($sizeDevidedBy2)) , ($point.Y + $sizeDevidedBy2)
            $pBottom = New-Object Point ($point.X + $sizeDevidedBy2) , (($point.Y + $sizeDevidedBy2) + ($sizeDevidedBy2))
            $pLeft = New-Object Point (($point.X + $sizeDevidedBy2) - $sizeDevidedBy2) , ($point.Y + $sizeDevidedBy2)                               
            $MainPath.AddEllipse($point.X,$point.Y,$InterCircleSize,$InterCircleSize)
            $pTopPath.AddEllipse($pTop.X-($ConnPSize / $intDevideBy2),$pTop.Y,$ConnPSize,$ConnPSize)
            $pRightPath.AddEllipse($pRight.X - ($ConnPSize), $pRight.Y - ($ConnPSize / $intDevideBy2),$ConnPSize,$ConnPSize)
            $pLeftPath.AddEllipse($pLeft.X,($pLeft.Y - ($ConnPSize / $intDevideBy2)),$ConnPSize,$ConnPSize)
            $pBottomPath.AddEllipse($pBottom.X - ($ConnPSize / $intDevideBy2),($pBottom.Y - ($ConnPSize)),$ConnPSize,$ConnPSize)
            $ShadowPath.AddEllipse(($point.X)-$ShadowSize,($point.Y)-$ShadowSize,$InterCircleSize+($ShadowSize*$intMultiplyBy2),$InterCircleSize+($ShadowSize*$intMultiplyBy2))
            $fillColor = [color]::BurlyWood
            $maxConn = 12
            $bolInput = $false
            $MainPen = $BigPen
        }
        $dimond.Name {           
            $point.X = $point.X - ($DimondSize / $intDevideBy2)
            $point.Y = $point.Y - ($DimondSize / $intDevideBy2)
            $sizeDevidedBy2 = $DimondSize / $intDevideBy2
            $TopPointGB = New-Object Point ($point.X) , ($point.Y - $adjustPixel)
            $BottomPointGB = New-Object Point ($point.X) , (($point.Y + $DimondSize) + $adjustPixel)
            $pCenter = New-Object Point ($point.X + ($sizeDevidedBy2)) , ($point.Y + $sizeDevidedBy2)
            $pTop = New-Object Point (($point.X + $sizeDevidedBy2)+($ConnPSize / $intDevideBy2)), $point.Y
            $pRight = New-Object Point (($point.X + $DimondSize)+ $ConnPSize), (($point.Y + $sizeDevidedBy2)+ ($ConnPSize / $intDevideBy2))
            $pBottom = New-Object Point (($point.X + $sizeDevidedBy2)+($ConnPSize / $intDevideBy2)) , (($point.Y + $DimondSize)+$ConnPSize)
            $pLeft = New-Object Point $point.X , (($point.Y + $sizeDevidedBy2)+($ConnPSize / $intDevideBy2))
            $MainPath.AddArc(($pTop.x - ($ConnPSize / $intDevideBy2)),$pTop.Y,$arcSize,$arcSize,225,90)
            $MainPath.AddArc(($pRight.x - ($ConnPSize)),($pRight.Y-($ConnPSize / $intDevideBy2)),$arcSize,$arcSize,-45,90)
            $MainPath.AddArc(($pBottom.x - ($ConnPSize / $intDevideBy2)),($pBottom.Y -$ConnPSize),$arcSize,$arcSize,45,90)
            $MainPath.AddArc($pLeft.x,($pLeft.Y- ($ConnPSize / $intDevideBy2)),$arcSize,$arcSize,135,90)
            $MainPath.CloseAllFigures() 
            $ShadowPath.AddArc(($pTop.x-($ConnPSize / $intDevideBy2)), ($pTop.Y-$ShadowSize),$arcSize,$arcSize,225,90)
            $ShadowPath.AddArc((($pRight.x+$ShadowSize)- ($ConnPSize)),($pRight.Y-($ConnPSize / $intDevideBy2)),$arcSize,$arcSize,-45,90)
            $ShadowPath.AddArc(($pBottom.x - ($ConnPSize / $intDevideBy2)),(($pBottom.Y+$ShadowSize)-$ConnPSize),$arcSize,$arcSize,45,90)
            $ShadowPath.AddArc(($pLeft.x-$ShadowSize),($pLeft.Y -($ConnPSize / $intDevideBy2)),$arcSize,$arcSize,135,90)
            $ShadowPath.CloseAllFigures()                                         
            $pTopPath.AddEllipse(($pTop.X - ($ConnPSize / $intDevideBy2)),$pTop.Y,$ConnPSize,$ConnPSize)
            $pRightPath.AddEllipse((($pRight.X)- ($ConnPSize)), ($pRight.Y-($ConnPSize / $intDevideBy2)),$ConnPSize,$ConnPSize)
            $pBottomPath.AddEllipse($pBottom.X - ($ConnPSize / $intDevideBy2),($pBottom.Y - ($ConnPSize)),$ConnPSize,$ConnPSize)
            $pLeftPath.AddEllipse($pLeft.X,($pLeft.Y - ($ConnPSize / $intDevideBy2)),$ConnPSize,$ConnPSize)
            $fillColor = [color]::FromArgb(216, 191, 216)
            $maxConn = 12
            $bolInput = $false 
            $MainPen = $RegPen                      
        }
        $Square.Name {
            $point.X = $point.X - ($squareSize / $intDevideBy2)
            $point.Y = $point.Y - ($squareSizeY / $intDevideBy2)
            $TopPointGB = New-Object Point ($point.X) , ($point.Y - $adjustPixel)
            $BottomPointGB = New-Object Point ($point.X) , (($point.Y + $squareSizeY) + $adjustPixel)
            $pCenter = New-Object Point ($point.X + ($squareSize /$intDevideBy2)) , ($point.Y + ($squareSizeY / $intDevideBy2))
            $pTop = New-Object Point (($point.X +($squareSize /$intDevideBy2))), $point.Y
            $pRight = New-Object Point (($point.X + $squareSize)+ $arcSize) , (($point.Y +($squareSizeY / $intDevideBy2)))
            $pBottom = New-Object Point (($point.X + ($squareSize /$intDevideBy2) )) , (($point.Y + ($squareSizeY))+ $arcSize)
            $pLeft = New-Object Point ($point.X ), (($point.Y + ($squareSizeY / $intDevideBy2)))
            $MainPath.AddArc(($pTop.x -($squareSize /$intDevideBy2)),$pTop.Y,$arcSize,$arcSize,180,90)
            $MainPath.AddArc(($pRight.x - $arcSize),($pRight.Y-($squareSizeY / $intDevideBy2)),$arcSize,$arcSize,270,90)
            $MainPath.AddArc(($pBottom.x +($squareSize /$intDevideBy2)),($pBottom.Y - $arcSize),$arcSize,$arcSize,0,90)
            $MainPath.AddArc($pLeft.x,($pLeft.Y+($squareSizeY / $intDevideBy2)),$arcSize,$arcSize,90,90)
            $MainPath.CloseAllFigures() 
            $ShadowPath.AddArc(($pTop.x-$ShadowSize)-($squareSize /$intDevideBy2), ($pTop.Y-$ShadowSize),$arcSize,$arcSize,180,90)
            $ShadowPath.AddArc((($pRight.x+$ShadowSize)- $arcSize),($pRight.Y-$ShadowSize)-($squareSizeY / $intDevideBy2),$arcSize,$arcSize,270,90)
            $ShadowPath.AddArc(($pBottom.x +$ShadowSize)+($squareSize /$intDevideBy2),(($pBottom.Y+$ShadowSize)- $arcSize),$arcSize,$arcSize,0,90)
            $ShadowPath.AddArc(($pLeft.x-$ShadowSize),($pLeft.Y+$ShadowSize )+($squareSizeY / $intDevideBy2),$arcSize,$arcSize,90,90)
            $ShadowPath.CloseAllFigures()                                         
            $pTopPath.AddEllipse(($pTop.X - ($ConnPSize / $intDevideBy2)),$pTop.Y,$ConnPSize,$ConnPSize)
            $pRightPath.AddEllipse((($pRight.X)- $arcSize), ($pRight.Y-($ConnPSize / $intDevideBy2)),$ConnPSize,$ConnPSize)
            $pBottomPath.AddEllipse($pBottom.X - ($ConnPSize / $intDevideBy2),($pBottom.Y - $arcSize),$ConnPSize,$ConnPSize)
            $pLeftPath.AddEllipse($pLeft.X,($pLeft.Y - ($ConnPSize / $intDevideBy2)),$ConnPSize,$ConnPSize)     
            $fillColor = [color]::lightblue                 
            $maxConn = 1
            $bolInput = $false  
            $MainPen = $RegPen                             
        }
        $DataObject.Name {
            $point.X = $point.X - ($DataObjSize / $intDevideBy2)
            $point.Y = $point.Y - ($DataObjSize / $intDevideBy2)
            $pp1 = New-Object Point ($point.X) , ($point.Y)
            $pp2 = New-Object Point ($point.X + $DataObjSizeX), ($point.Y)
            $pp3 = New-Object Point (($point.X + $DataObjSizeX) + $adjustPixel) , ($point.Y + $DataObjSize)
            $pp4 = New-Object Point ($point.X ), ($point.Y + $DataObjSize)
            $pp5 = New-Object Point ($point.X + $DataObjSizeX), ($point.Y  + $adjustPixel)
            $pp6 = New-Object Point (($point.X + $DataObjSizeX) + $adjustPixel), (($point.Y) + $adjustPixel)
            $sp1 = New-Object Point ($point.X - $ShadowSize) , ($point.Y-$ShadowSize)
            $sp2 = New-Object Point (($point.X + $DataObjSizeX)), ($point.Y -$ShadowSize)
            $sp3 = New-Object Point ((($point.X + $DataObjSizeX) + $adjustPixel) + $ShadowSize) , (($point.Y + $DataObjSize) + $ShadowSize)
            $sp4 = New-Object Point (($point.X) - $ShadowSize), (($point.Y + $DataObjSize) + $ShadowSize)
            $sp5 = New-Object Point (($point.X + $DataObjSizeX) - $ShadowSize), ($point.Y  + $adjustPixel)
            $sp6 = New-Object Point ((($point.X + $DataObjSizeX) + $adjustPixel) + $ShadowSize), (($point.Y) + $adjustPixel)
            $TopPointGB = New-Object Point ($point.X) , ($point.Y - $DataObjSize)
            $BottomPointGB = New-Object Point ($point.X) , ($point.Y + $DataObjSize)
            $pCenter = New-Object Point ($point.X + ($DataObjSize / $intDevideBy2)) , ($point.Y + ($DataObjSize / $intDevideBy2))
            $pTop = New-Object Point ($point.X + ($DataObjSize / $intDevideBy2)), $point.Y
            $pRight = New-Object Point (($point.X + ($DataObjSizex / $intDevideBy2)) + ($DataObjSize / $intDevideBy2)) , ($point.Y + ($DataObjSize / $intDevideBy2))
            $pBottom = New-Object Point (($point.X + ($DataObjSize / $intDevideBy2)) ) , (($point.Y + ($DataObjSize / $intDevideBy2)) + ($DataObjSize / $intDevideBy2))
            $pLeft = New-Object Point (($point.X + ($DataObjSize / $intDevideBy2)) - ($DataObjSizex / $intDevideBy2)) , ($point.Y + ($DataObjSize / $intDevideBy2))                  
            $MainPath.AddLine($pp2, $pp5)
            $MainPath.AddLine($pp5, $pp6)
            $MainPath.AddArc($pp3.x - $adjustPixel, $pp3.y-$adjustPixel, $arcSize, $arcSize, 0, 90)
            $MainPath.AddArc($pp4.x + $adjustPixel, $pp4.y-$adjustPixel, $arcSize, $arcSize, 90, 90)
            $MainPath.AddArc($pp1.x + $adjustPixel, $pp1.Y, $arcSize, $arcSize, 180, 90)
            $MainPath.AddLine($pp2,$pp6)
            $pTopPath.AddEllipse($pTop.X-($ConnPSize / $intDevideBy2), $pTop.Y, $ConnPSize, $ConnPSize)
            $pRightPath.AddEllipse($pRight.X - ($ConnPSize), $pRight.Y - ($ConnPSize / $intDevideBy2), $ConnPSize, $ConnPSize)
            $pLeftPath.AddEllipse($pLeft.X, $pLeft.Y - ($ConnPSize / $intDevideBy2), $ConnPSize, $ConnPSize)
            $pBottomPath.AddEllipse($pBottom.X - ($ConnPSize / $intDevideBy2), $pBottom.Y - ($ConnPSize), $ConnPSize, $ConnPSize)                           
            $ShadowPath.AddArc($sp3.x - $adjustPixel, $sp3.y - $adjustPixel, $arcSize, $arcSize, 0, 90)
            $ShadowPath.AddArc($sp4.x + $adjustPixel, $sp4.y - $adjustPixel, $arcSize, $arcSize, 90, 90)
            $ShadowPath.AddArc($sp1.x + $adjustPixel, $sp1.Y , $arcSize, $arcSize, 180, 90)
            $ShadowPath.AddLine($sp2, $sp6)
            $ShadowPath.CloseFigure()
            $fillColor = [color]::FromArgb(211,211,211)                    
            $maxConn = 12
            $bolInput = $True
            $MainPen = $RegPen
        }
        $Pool.Name {
            If($Global:objGroup -ne $null -and $Global:objGroup.AxisPath -ne "")
            {
                If($Global:objGroup.AxisPath -eq "TopPath")
                {
                    $point.Y = $Global:objGroup.Point.Y - ($Global:objGroup.Point.Y - $Point.Y)
                    $point.X = $Global:objGroup.Point.X
                    $PoolWidth = $Global:objGroup.pTop3.x - $point.X
                    $PoolHeight = $Global:objGroup.pBottom1.Y - $point.Y 
                }
                    ElseIf($Global:objGroup.AxisPath -eq "RightPath")
                    {
                        $PoolWidth = $point.X - $Global:objGroup.pTop1.x
                        $point.X = $Global:objGroup.Point.X
                        $point.Y = $Global:objGroup.Point.Y                       
                        $PoolHeight = $Global:objGroup.pBottom1.Y - $point.Y 
                    }
                        ElseIf($Global:objGroup.AxisPath -eq "BottomPath")
                        {
                            $PoolHeight = $point.Y - $Global:objGroup.pTop1.Y 
                            $point.X = $Global:objGroup.Point.X
                            $point.Y = $Global:objGroup.Point.Y                                                
                            $PoolWidth = $Global:objGroup.pTop3.x - $point.X                       
                        }
                            ElseIf($Global:objGroup.AxisPath -eq "LeftPath")
                            {
                                $PoolWidth = $Global:objGroup.pTop3.x - $point.X
                                $point.X = $Global:objGroup.Point.X - ($Global:objGroup.Point.X - $Point.X)                               
                                $point.Y = $Global:objGroup.Point.Y                                               
                                $PoolHeight = $Global:objGroup.pBottom1.Y - $point.Y                            
                            }
                                ElseIf($Global:objGroup.AxisPath -eq "TAreaPath")
                                {
                                    $Px = $point
                                    $PoolWidth = $Global:objGroup.pTop3.x - $Global:objGroup.pTop1.x 
                                    $PoolHeight = $Global:objGroup.pBottom1.Y  - $Global:objGroup.pTop1.Y 
                                    $point.X = $Global:objGroup.point.X - ($Global:objGroup.TPoint.X - $point.X)
                                    $point.Y = $Global:objGroup.point.Y - ($Global:objGroup.TPoint.Y - $point.Y)
                                    $Global:objGroup.TPoint = $Px
                                }
            }
            Else
            {
                If($Global:Loading)
                {
                    $PoolWidth = $global:PoolWidth
                    $PoolHeight = $global:PoolHeight
                }
                Else
                {
                    $PoolWidth = $PoolSize
                    $PoolHeight = $PoolSize
                }
                $point.X
                $point.Y     
            }
            $pCenter = New-Object Point ($point.X + ($PoolTAreaSize / $intDevideby2)), ($point.Y + ($PoolHeight / $intDevideBy2))         
            $pTop1 = New-Object Point $point.X , $point.Y
            $pTop2 = New-Object Point ($point.X + $PoolTAreaSize) , $point.Y
            $pTop3 = New-Object Point ($point.X + $PoolWidth) , $point.Y
            $pBottom1 = New-Object Point $point.X , ($point.Y + $PoolHeight)
            $pBottom2 = New-Object Point ($point.X + $PoolTAreaSize), ($point.Y + $PoolHeight)
            $pBottom3 = New-Object Point ($point.X + $PoolWidth), ($point.Y + $PoolHeight)
                       
            $MAreaRect = $TAreaRect = New-Object Rectangle ($pTop1.x + $PoolLineSize) , ($pTop1.Y + $PoolLineSize),`
                                                            (($pTop3.x - $pTop1.x) - $PoolLineSize) , (($pBottom3.Y -$pTop1.Y) - $PoolLineSize)
            $MainPath.AddRectangle($MAreaRect)

            $TopPath.AddLine($pTop1,(New-Object Point ($pTop3.x + $PoolLineSize), $pTop1.Y)) 
            $TopPath.AddLine((New-Object Point ($pTop3.x), ($pTop3.Y + $PoolLineSize)), `
                            (New-Object Point ($pTop1.x + $PoolLineSize), ($pTop1.Y+$PoolLineSize)))                             
            $TopPath.CloseAllFigures()
            $RightPath.AddLine((New-Object Point ($pTop3.x), ($pTop3.Y + $PoolLineSize)),$pBottom3) 
            $RightPath.AddLine((New-Object Point ($pBottom3.x + $PoolLineSize) , ($pBottom3.Y + $PoolLineSize)),`
                                (New-Object Point ($pTop3.x + $PoolLineSize), ($pTop3.Y)))  
            $RightPath.CloseAllFigures()          
            $BottomPath.AddLine((New-Object Point $pBottom3.x, $pBottom3.Y),`
                                (New-Object Point ($pBottom1.x + $PoolLineSize), ($pBottom1.Y))) 
            $BottomPath.AddLine((New-Object Point ($pBottom1.x), ($pBottom1.Y + $PoolLineSize)), `
                                (New-Object Point ($pBottom3.x + $PoolLineSize), ($pBottom3.Y + $PoolLineSize)))  
            $BottomPath.CloseAllFigures()                                                 
            $LeftPath.AddLine($pTop1,(New-Object Point ($pBottom1.x) , ($pBottom1.Y + $PoolLineSize))) 
            $LeftPath.AddLine((New-Object Point ($pBottom1.x + $PoolLineSize) , ($pBottom1.Y)), `
                                (New-Object Point ($pTop1.x+$PoolLineSize) , ($pTop1.Y + $PoolLineSize)))  
            $LeftPath.CloseAllFigures()
            $TLinePath.AddLine((New-Object Point $pTop2.x, ($pTop2.Y + $PoolLineSize)), $pBottom2)
            $TAreaRect = New-Object Rectangle ($pTop1.x + $PoolLineSize) , ($pTop1.Y + $PoolLineSize),`
                                             (($pTop2.X - $pTop1.X) - $PoolLineSize), (($pBottom2.Y - $pTop2.Y) - $PoolLineSize)                                                            
            $TAreaPath.AddRectangle($TAreaRect)
            $MainPen = $RegPen
        }
        $Lane.Name {
 <#
            If($Global:Loading)
            {
                $LaneHeight = $global:LaneHeight
            }
            Else
            {
                If($Global:objGroup.Lanes.Count -eq 1)
                {
                    $LaneHeight = $LaneSize
                }
                Else
                {
                    $LaneHeight = $Global:objGroup.pBottom2.Y - $Global:objGroup.Lanes[$Global:objGroup.Lanes.Count].pBottom
                }
            }
#>
<#
            $pCenter = New-Object Point ($point.X + ($PoolTAreaSize / $intDevideby2)), ($point.Y + ($LaneSize / $intDevideBy2))    
                    
            $pTop = $Global:objGroup.Lanes[$Global:objGroup.Lanes.Count-1].pBottom1
            $pBottom1 = New-Object Point ($pTop.X, ($pTop.Y + $LaneSize))
            $pBottom2 = New-Object Point (($pTop.X +($Global:objGroup.PoolWidth-$PoolTAreaSize)), ($pTop.Y + $LaneSize))           
            $TAreaRect = New-Object Rectangle $pTop.X , $pTop.Y, ($Global:objGroup.Width-$PoolTAreaSize) , $LaneSize
            $TAreaPath.AddRectangle($TAreaRect)

            $BottomPath.AddLine($pBottom1,$pBottom2) 
            $BottomPath.AddLine((New-Object Point ($pBottom2.X), ($pBottom2.Y + $LaneLineSize)), `
                            (New-Object Point ($pBottom1.x ), ($pBottom1.Y+$LaneLineSize)))
            $BottomPath.CloseAllFigures()                       
#>            
                                    
        }               
    }
    If($strSwitch -ne "")
    {
        $ptopRegion = new-object Region $pTopPath
        $pRightRegion = new-object Region $pRightPath
        $pBottomRegion = new-object Region $pBottomPath
        $pLeftRegion = new-object Region $pLeftPath
        $ShadowRegion = new-object Region $ShadowPath
        $MainRegion = new-object Region  $MainPath
        If(
            (!$Global:bolMouseMove -or !$Global:bolMouseDown -or (($global:objShape -eq $null) -and ($Global:objGroup -eq $Null))) -or 
            ($Global:Loading)
          )
        {
            If($strSwitch -eq ($ShapesTbl.Controls | Where-Object -FilterScript {$_.Name -match $strSwitch}).Name)
            {
                $objPSNewShape = [pscustomobject]@{
                    arrClass = $RegionsClass
                    name = $name
                    type = $strSwitch
                    Point = $point
                    Location = $location
                    intIterate = $Global:intIterate
                    Mainregion = $MainRegion
                    Shadowregion = $ShadowRegion
                    pTopRegion = $ptopRegion
                    pRightRegion = $pRightRegion
                    pBottomRegion = $pBottomRegion 
                    pLeftRegion = $pLeftRegion
                    TopPointGB = $TopPointGB
                    BottomPointGB = $BottomPointGB
                    pCenter = $pCenter
                    pTop = $pTop
                    pRight = $pRight
                    pBottom = $pBottom 
                    pLeft = $pLeft
                    MainPath = $MainPath
                    ShadowPath = $ShadowPath
                    pTopPath = $pTopPath
                    pRightPath = $pRightPath
                    pBottomPath = $pBottomPath
                    pLeftPath = $pLeftPath
                    PointPen = $RegPen
                    MainPen = $MainPen
                    ConnArr = [ArrayList]@()
                    Text = ""
                    Icon = ""
                    SubProcess = $false
                    Condition = ""
                    TextPath = $Null
                    pTXDiffer = 0
                    pTYDiffer = 0
                    fillColor = $fillColor                 
                    maxConn = $maxConn
                    bolInput = $bolInput
                }
                $MainObject.arrRegions.Add($objPSNewShape)
                funDisAllShapes $null
                $global:objShape = $objPSNewShape
            }
            If($strSwitch -Contains $Pool.Name)
            {
                 $objGroup = [pscustomobject]@{     
                    Name = $name
                    Type= $strSwitch
                    intIterate = $Global:intIterate
                    Lanes = [ArrayList]@()
                    Point = $point
                    TPoint = $Null
                    pTop1 = $pTop1
                    pTop2 = $pTop2
                    pTop3 = $pTop3
                    pBottom1 = $pBottom1
                    pBottom2 = $pBottom2
                    pBottom3 = $pBottom3
                    TopPath = $TopPath
                    RightPath = $RightPath
                    BottomPath = $BottomPath
                    LeftPath = $LeftPath 
                    TAreaPath = $TAreaPath
                    TLinePath = $TLinePath
                    MainPath = $MainPath
                    Text = "$strSwitch$($MainObject.arrGroups.Count+1)"
                    TextPath = $TextPath
                    pCenter = $pCenter
                    AxisPath = ""
                    TextPen = $TinyPen
                    MainPen = $GroupPen
                    pTXDiffer = 0
                    pTYDiffer = 0
                    PoolWidth = $PoolWidth
                    PoolHeight = $PoolHeight
                }
                $objGroup.Lanes.Add(
                    [pscustomobject]@{     
                        Name = "dummy"
                        pBottom1 = $pTop2
                })

                $MainObject.arrGroups.Add($objGroup)
                funDisAllShapes $null
                $global:objGroup = $objGroup   
            }
            If($strSwitch -Contains $Lane.Name)
            {
               $objLane = [pscustomobject]@{     
                    Name = $name
                    Type= $strSwitch
                    intIterate = $Global:intIterate
                    Pool = $Null
                    Point = $point
                    TPoint = $Null
                    pTop = $pTop
                    pBottom1 = $pBottom1
                    pBottom2 = $pBottom2
                    LanePAth = $BottomPath
                    TAreaPath = $TAreaPath
                    Text = "$strSwitch$($global:objGroup.Lanes.Count)"
                    TextPath = $TextPath
                    pCenter = $pCenter
                    TextPen = $TinyPen
                    MainPen = $GroupPen
                    pTXDiffer = 0
                    pTYDiffer = 0
                    LaneHeight = $LaneSize
                }
                $global:objGroup.Lanes.Add($objLane)
                funDisAllShapes $null
                $global:objLane = $objLane
            }
        }
        Else
        {
            If($strSwitch -eq ($ShapesTbl.Controls | Where-Object -FilterScript {$_.Name -match $strSwitch}).Name)
            {
                $global:objShape.Point = $point
                $global:objShape.MainPath = $MainPath
                $global:objShape.ShadowPath = $ShadowPath
                $global:objShape.pTopPath = $pTopPath
                $global:objShape.pRightPath = $pRightPath
                $global:objShape.pBottomPath = $pBottomPath
                $global:objShape.pLeftPath = $pLeftPath
                $global:objShape.Mainregion = $MainRegion
                $global:objShape.Shadowregion = $ShadowRegion
                $global:objShape.pTopRegion = $ptopRegion
                $global:objShape.pRightRegion = $pRightRegion
                $global:objShape.pBottomRegion = $pBottomRegion 
                $global:objShape.pLeftRegion = $pLeftRegion
                $global:objShape.TopPointGB = $TopPointGB
                $global:objShape.BottomPointGB = $BottomPointGB
                $global:objShape.PCenter = $pCenter
                $global:objShape.pTop = $pTop
                $global:objShape.pRight = $pRight
                $global:objShape.pBottom = $pBottom
                $global:objShape.pLeft = $pLeft
            }
            If($strSwitch -Contains $Pool.Name)
            {
                $Global:objGroup.Point = $point
                $Global:objGroup.pTop1 = $pTop1
                $Global:objGroup.pTop2 = $pTop2
                $Global:objGroup.pTop3 = $pTop3
                $Global:objGroup.pBottom1 = $pBottom1
                $Global:objGroup.pBottom2 = $pBottom2
                $Global:objGroup.pBottom3 = $pBottom3
                $Global:objGroup.MainPath = $MainPath
                $Global:objGroup.TopPath = $TopPath
                $Global:objGroup.RightPath = $RightPath
                $Global:objGroup.BottomPath = $BottomPath
                $Global:objGroup.LeftPath = $LeftPath 
                $Global:objGroup.TAreaPath = $TAreaPath
                $Global:objGroup.TLinePath = $TLinePath
                $Global:objGroup.pCenter = $pCenter
                $Global:objGroup.PoolWidth = $PoolWidth
                $Global:objGroup.PoolHeight = $PoolHeight
                $Global:objGroup.Lanes[0].pBottom1 = $pTop2
            }
            If($strSwitch -Contains $Lane.Name)
            {
                $global:objLane.Name = $name
                $global:objLane.Type= $strSwitch
                $global:objLane.intIterate = $Global:intIterate
                $global:objLane.Pool = $Null
                $global:objLane.Point = $point
                $global:objLane.TPoint = $Null
                $global:objLane.pTop = $pTop
                $global:objLane.pBottom1 = $pBottom1
                $global:objLane.pBottom2 = $pBottom2
                $global:objLane.BottomPath = $BottomPath
                $global:objLane.TAreaPath = $TAreaPath
                $global:objLane.TextPath = $TextPath
                $global:objLane.pCenter = $pCenter
                $global:objLane.TextPen = $TinyPen
                $global:objLane.MainPen = $GroupPen
#                $global:objLane.pTXDiffer = 0
#                $global:objLane.pTYDiffer = 0
                $global:objLane.LaneHeight = $LaneHeight
                                
            }
        }
    }

    $MatrixScale = New-Object System.Drawing.Drawing2D.Matrix
    $MatrixScale.Scale($Global:ScaleUnit,$Global:ScaleUnit)
#    $e.Graphics.transform($MatrixScale)

    If ($MainObject.arrRegions.count -gt 0)
    {        
        for($i = 0; $i -lt $MainObject.arrRegions.Count; $i++)
        {
            $arrItem = $MainObject.arrRegions[$i]           
            If (
                $arrItem.Mainregion.isVisible($DesktopPan.PointToClient([Cursor]::Position)) `
                -or ($arrItem -eq $Global:objShape)                                                                                                       
               )
            { 
            
#                $frmPath.AddPath($arrItem.ShadowPath,$true)
 #               $frmPath.AddPath( $arrItem.MainPath,$true)
                      
                $e.Graphics.DrawPath($mypen2, $arrItem.ShadowPath)
                $e.Graphics.DrawPath($arrItem.MainPen, $arrItem.MainPath)

#                $e.Graphics.DrawPath($arrItem.MainPen, $frmPath)
                
                $PathGraBrush = New-Object Drawing2D.PathGradientBrush($arrItem.MainPath)
                $PathGraBrush.SurroundColors = $arrItem.fillColor
                $e.Graphics.FillPath($PathGraBrush,$arrItem.MainPath) 
                $e.Graphics.DrawPath($arrItem.PointPen, $arrItem.pTopPath)
                $e.Graphics.DrawPath($arrItem.PointPen, $arrItem.pRightPath)
                $e.Graphics.DrawPath($arrItem.PointPen, $arrItem.pBottomPath)
                $e.Graphics.DrawPath($arrItem.PointPen, $arrItem.pLeftPath)
                If($Global:objShapePoint -ne $null -and $arrItem -eq $Global:objShape)
                {
                   $e.Graphics.DrawPath($SelPen, $arrItem."$($Global:objShapePoint)Path") 
                }
<#
                $e.Graphics.DrawEllipse($arrItem.PointPen,$arrItem.pright.x,$arrItem.pright.Y,$ConnPSize,$ConnPSize)    
                $e.Graphics.DrawEllipse($arrItem.PointPen,$arrItem.pTop.x,$arrItem.pTop.Y,$ConnPSize,$ConnPSize)   
                $e.Graphics.DrawEllipse($arrItem.PointPen,$arrItem.pBottom.x,$arrItem.pBottom.Y,$ConnPSize,$ConnPSize)         
                $e.Graphics.DrawEllipse($arrItem.PointPen,$arrItem.pLeft.x,$arrItem.pLeft.Y,$ConnPSize,$ConnPSize) 
#>                        
#                $e.Graphics.DrawImage($avatar,$arrItem.p.X+50,$arrItem.p.y+55,10,10)
#                $e.Graphics.SetClip($arrItem.Mainregion,4)
            }
            Else
            {
#                $frmPath.AddPath($arrItem.ShadowPath,$true)
#                $frmPath.AddPath( $arrItem.MainPath,$true)
                $e.Graphics.DrawPath($arrItem.MainPen, $arrItem.MainPath)
#                $e.Graphics.DrawPath($arrItem.MainPen, $frmPath)
                
                $PathGraBrush = New-Object Drawing2D.LinearGradientBrush ($arrItem.BottomPointGB,$arrItem.TopPointGB,$arrItem.fillColor,[color]::White)
#                $PathGraBrush.SurroundColors = $arrItem.fillColor

                $e.Graphics.FillPath($PathGraBrush,$arrItem.MainPath)

#                $e.Graphics.FillPath($PathGraBrush, $frmPath)
                               
#                $e.Graphics.DrawString("test", $fonty , $myBrush, $arrItem.p.X+40,$arrItem.p.y+55, [StringFormat]::GenericDefault)
 #               $e.Graphics.DrawImage($avatar,$arrItem.P1.x,$arrItem.P1.y)
#                $e.Graphics.DrawImage($avatar,$arrItem.P2.x,$arrItem.P2.y)
#                $e.Graphics.SetClip($arrItem.Mainregion,4)
            }
#            New-Variable -Force -Name "$($arrItem.Name)$iMPScale" -Value (New-Object System.Drawing.Drawing2D.Matrix) 
#            $MatrixScale = Get-Variable -ValueOnly -Include "$($arrItem.Name)$iMPScale"
            



#            $e.Graphics.Transform = $MatrixScale
#            $e.Graphics.FillPath($PathGraBrush, $frmPath)
 #           $Global:ScaleUnit = 1

            If($arrItem.Text -ne "")
            {
                New-Variable -Force -Name "$($arrItem.Name)$iTPath" -Value (New-Object Drawing2D.GraphicsPath) 
                $TextPath = Get-Variable -ValueOnly -Include "$($arrItem.Name)$iTPath"
                $pTemp = New-Object Point ($arrItem.Pcenter.X - $arrItem.pTXDiffer) , ($arrItem.Pcenter.Y - $arrItem.pTYDiffer)
                If($Global:SelText -eq $arrItem)
                {
                    $TextPath.AddString($arrItem.Text, $fonty.FontFamily , $BoldFont, $TextSize ,$pTemp, [StringFormat]::GenericDefault) 
                    $e.Graphics.FillPath($SelTextBrush,$TextPath)            
                }
                Else
                {
                    $TextPath.AddString($arrItem.Text, $fonty.FontFamily , $RegularFont, $TextSize ,$pTemp, [StringFormat]::GenericDefault) 
                    $e.Graphics.FillPath($TextBrush,$TextPath)
                } 
                $arrItem.TextPath = $TextPath               
#                $e.Graphics.DrawString($arrItem.Text, $fonty , $myBrush, $arrItem.Pcenter.X,$arrItem.pCenter.y, [StringFormat]::GenericDefault)  
            }

            for($c = 0; $c -lt $arrItem.ConnArr.Count; $c++)
            {
                $arrConnItem = $arrItem.ConnArr[$c]
                New-Variable -Force -Name "$($arrItem.Name)$c" -Value (New-Object Drawing2D.GraphicsPath) 
                $MainPath = Get-Variable -ValueOnly -Include "$($arrItem.Name)$c"
#                $MainPath = New-Object Drawing2D.GraphicsPath
                If($arrConnItem.Points.Count -gt 0)
                {
                    for($p = 0; $p -lt $arrConnItem.Points.Count; $p++)
                    {
                        If($p -eq 0)
                        {
                            $Point1 = $arrItem."$($arrConnItem.StartPoint)"
                        }
                        Else
                        {
                            $Point1 = $arrConnItem.Points[$p-1]
                        }
                        
                        $Point2 = $arrConnItem.Points[$p]
                        If($arrConnItem.StartPoint -eq "pTop" -or $arrConnItem.StartPoint -eq "pBottom")
                        {
                            $Ptemp  = new-object Point ($Point1.X , $Point2.Y)
                            $MainPath.AddLine($Point1,$Ptemp)
                            $MainPath.AddLine($Ptemp,$Point2)
                        }
                        Else
                        {
                            $Ptemp  = new-object Point ($Point2.X , $Point1.Y)
                            $MainPath.AddLine($Point1,$Ptemp)
                            $MainPath.AddLine($Ptemp,$Point2)
                        }
                    }
                }
                Else
                {
                    $Point2 = $arrItem."$($arrConnItem.StartPoint)"
                }
                If($arrConnItem.ConnPoint -ne $null)
                {
                    If($arrConnItem.StartPoint -eq "pTop" -or $arrConnItem.StartPoint -eq "pBottom")
                    {
                        $Ptemp  = new-object Point ($Point2.X, $arrConnItem.ConnObj."$($arrConnItem.ConnPoint)".Y)
                        $MainPath.AddLine($Point2,$Ptemp)
                        $MainPath.AddLine($Ptemp,$arrConnItem.ConnObj."$($arrConnItem.ConnPoint)")
                    }
                    Else
                    {
                        $Ptemp  = new-object Point ($arrConnItem.ConnObj."$($arrConnItem.ConnPoint)".X, $Point2.Y)
                        $MainPath.AddLine($Point2,$Ptemp)
                        $MainPath.AddLine($Ptemp,$arrConnItem.ConnObj."$($arrConnItem.ConnPoint)")  
                    }
                } 
                $mypenCap.DashStyle = $arrConnItem.LineStyle
#                $arrItem.Mainregion.intersect($MainPath)   
                $arrConnItem.Path = $MainPath
                If($Global:SelPath.Name -eq $arrItem.ConnArr[$c].Name -and $Global:SelPath.Startpoint -eq $arrConnItem.StartPoint)
                {
                    $e.Graphics.DrawPath($BigpenCap, $MainPath)
                }
                Else
                {               
                    $e.Graphics.DrawPath($mypenCap, $MainPath)
                }
                If($arrConnItem.Text -ne "")
                {
                    New-Variable -Force -Name "$($arrConnItem.Name)$cTPathObj" -Value (New-Object Drawing2D.GraphicsPath) 
                    $TextPath = Get-Variable -ValueOnly -Include "$($arrConnItem.Name)$cTPathObj"
                    $pTemp = New-Object Point ($arrConnItem.Pcenter.X - $arrConnItem.pTXDiffer) , ($arrConnItem.Pcenter.Y - $arrConnItem.pTYDiffer)
                    If($Global:SelPath -eq $arrConnItem)
                    {
                        $TextPath.AddString($arrConnItem.Text, $fonty.FontFamily , $BoldFont, $TextSize ,$pTemp, [StringFormat]::GenericDefault) 
                        $e.Graphics.FillPath($SelTextBrush,$TextPath)            
                    }
                    Else
                    {
                        $TextPath.AddString($arrConnItem.Text, $fonty.FontFamily , $RegularFont, $TextSize ,$pTemp, [StringFormat]::GenericDefault) 
                        $e.Graphics.FillPath($TextBrush,$TextPath)
                    } 
                    $arrConnItem.TextPath = $TextPath               
    #                $e.Graphics.DrawString($arrItem.Text, $fonty , $myBrush, $arrItem.Pcenter.X,$arrItem.pCenter.y, [StringFormat]::GenericDefault)  
                }
            }
            If($arrItem.SubProcess -Or $arrItem.Icon -ne "")
            {
                If($arrItem.Type -eq $Square.Name)
                {
                    If($arrItem.SubProcess){
                        $e.Graphics.DrawImage($SubProcess.Image,($arrItem.pLeft.x), $arrItem.pCenter.y - $SubProcess.Height + $arcSize)
                    }
                    If($arrItem.Icon -ne "")
                    {
                        $TempObj = Get-Variable -ValueOnly -Include $arrItem.Icon
                        $e.Graphics.DrawImage($TempObj.Image,($arrItem.pCenter.x - $SquareSize) + $arcSize, ($arrItem.pCenter.y - $squareSizeY) - $intArrowSize)
                    }
                }
                Else
                {
                    If($arrItem.Type -eq $Dimond.Name)
                    {
                        $TempObj = Get-Variable -ValueOnly -Include $arrItem.Icon
 #                       $e.Graphics.DrawImage($TempObj.Image,$arrItem.pTop.x - $DimondSize , $arrItem.pLeft.y - $DimondSize)

                        $e.Graphics.DrawImage($TempObj.Image,($arrItem.point.x - ($DimondSize / $intDevideBy2)-$intArrowSize)`
                                                            , ($arrItem.point.y - ($DimondSize / $intDevideBy2)-$intArrowSize))

#                        $e.Graphics.DrawImage($avatar,$arrItem.point.x  , $arrItem.point.y)
#                        $e.Graphics.DrawImage($avatar,$arrItem.point.x  , $arrItem.point.y)

#                        $e.Graphics.DrawImage($avatar,$arrItem.pcenter.x  , $arrItem.pcenter.y)
                    }
                        ElseIf($arrItem.Type -eq $StartCircle.Name -Or $arrItem.Type -eq $InterCircle.Name -Or $arrItem.Type -eq $DoubleCircle.Name)
                        {
                            $TempObj = Get-Variable -ValueOnly -Include $arrItem.Icon
                            $e.Graphics.DrawImage($TempObj.Image,($arrItem.pTop.x - $StartCircleSize) - $arcSize,( $arrItem.pCenter.y - $StartCircleSize)-$arcSize)
                        }
                    Else
                    {
                        $TempObj = Get-Variable -ValueOnly -Include $arrItem.Icon
                        $e.Graphics.DrawImage($TempObj.Image,($arrItem.pTop.x - $DataObjSize)- $intArrowSize ,( $arrItem.pTop.y - $DataObjSizeX))    
                    }
                }
            }            
        }
    }
    If ($MainObject.arrGroups.count -gt 0)
    {        
        for($r = 0; $r -lt $MainObject.arrGroups.Count; $r++)
        {           
            $arrGroItem = $MainObject.arrGroups[$r]
            $e.Graphics.FillPath($TextBrush, $arrGroItem.TopPath)
            $e.Graphics.FillPath($TextBrush, $arrGroItem.RightPath)
            $e.Graphics.FillPath($TextBrush, $arrGroItem.BottomPath)
            $e.Graphics.FillPath($TextBrush, $arrGroItem.LeftPath)
            $e.Graphics.DrawPath($arrGroItem.TextPen, $arrGroItem.TLinePath)
            If($arrGroItem.Text -ne "")
            {
                New-Variable -Force -Name "$($arrGroItem.Name)$rTPath" -Value (New-Object Drawing2D.GraphicsPath) 
                $TextPath = Get-Variable -ValueOnly -Include "$($arrGroItem.Name)$rTPath"
#                $pTemp = $arrGroItem.TextPoint
                $pTemp = New-Object Point ($arrGroItem.Pcenter.X - $arrGroItem.pTXDiffer) , ($arrGroItem.Pcenter.Y - $arrGroItem.pTYDiffer)
                If($Global:SelText -eq $arrGroItem)
                {
                    $TextPath.AddString($arrGroItem.Text, $fonty.FontFamily , $BoldFont, $TextSize ,$pTemp, [StringFormat]::GenericDefault) 
#                    $e.Graphics.FillPath($SelTextBrush,$TextPath)            
                }
                Else
                {
                    $TextPath.AddString($arrGroItem.Text, $fonty.FontFamily , $RegularFont, $TextSize ,$pTemp, [StringFormat]::GenericDefault) 
#                    $e.Graphics.FillPath($TextBrush,$TextPath)
                } 
                $arrGroItem.TextPath = $TextPath
                $matrix = New-Object System.Drawing.Drawing2D.Matrix
                $matrix.RotateAt(-90,$pTemp)
                $TextPath.Transform($matrix)
                $e.Graphics.FillPath($TextBrush,$TextPath)           
#                $e.Graphics.DrawString($arrItem.Text, $fonty , $myBrush, $arrItem.Pcenter.X,$arrItem.pCenter.y, [StringFormat]::GenericDefault)  
            }
#            $e.Graphics.FillPath($SelTextBrush, $arrGroItem.TAreaPath)           
            If($arrGroItem.TopPath.isVisible($DesktopPan.PointToClient([Cursor]::Position)))
            {$e.Graphics.Fillpath($SelTextBrush, $arrGroItem.TopPath)}
                ElseIf($arrGroItem.RightPath.isVisible($DesktopPan.PointToClient([Cursor]::Position)))
                {$e.Graphics.FillPath($SelTextBrush, $arrGroItem.RightPath)}
                    ElseIf($arrGroItem.BottomPath.isVisible($DesktopPan.PointToClient([Cursor]::Position)))
                    {$e.Graphics.FillPath($SelTextBrush, $arrGroItem.BottomPath)}
                        ElseIf($arrGroItem.LeftPath.isVisible($DesktopPan.PointToClient([Cursor]::Position)))
                        {$e.Graphics.FillPath($SelTextBrush, $arrGroItem.LeftPath)}
                            ElseIf($arrGroItem.TAreaPath.isVisible($DesktopPan.PointToClient([Cursor]::Position)))
                            {                               
                                $e.Graphics.Fillpath($SelTextBrush, $arrGroItem.TopPath)
                                $e.Graphics.FillPath($SelTextBrush, $arrGroItem.RightPath)
                                $e.Graphics.FillPath($SelTextBrush, $arrGroItem.BottomPath)
                                $e.Graphics.FillPath($SelTextBrush, $arrGroItem.LeftPath)
                            }
#            $e.Graphics.FillPath($SelTextBrush, $arrGroItem.TAreaPath)
            for($n = 0; $n -lt $arrGroItem.Lanes.Count; $n++)
            {
                If($n -gt 0)
                {
    #                $arrConnItem = $arrGroItem.Lanes[$n]
                    New-Variable -Force -Name "$($arrGroItem.Lanes[$n].Name)$nMPath" -Value (New-Object Drawing2D.GraphicsPath) 
                    $MainPath = Get-Variable -ValueOnly -Include "$($arrGroItem.Lanes[$n].Name)$nMPath"
    #                $MainPath = New-Object Drawing2D.GraphicsPath
                    New-Variable -Force -Name "$($arrGroItem.Lanes[$n].Name)$nTPath" -Value (New-Object Drawing2D.GraphicsPath) 
                    $TextPath = Get-Variable -ValueOnly -Include "$($arrGroItem.Lanes[$n].Name)$nTPath"

                    New-Variable -Force -Name "$($arrGroItem.Lanes[$n].Name)$nLPath" -Value (New-Object Drawing2D.GraphicsPath) 
                    $LinePath = Get-Variable -ValueOnly -Include "$($arrGroItem.Lanes[$n].Name)$nLPath"
                                        
                    $pTop = $arrGroItem.Lanes[$n-1].pBottom1
                    $pCenter = New-Object Point ($pTop.X + ($PoolTAreaSize / $intDevideby2)), ($pTop.Y + ($LaneSize / $intDevideBy2))
                    $arrGroItem.Lanes[$n].pCenter = $pCenter
                    $pTemp = New-Object Point ($pCenter.X - $arrGroItem.Lanes[$n].pTXDiffer) , ($pCenter.Y - $arrGroItem.Lanes[$n].pTYDiffer)
                    $arrGroItem.Lanes[$n].pBottom1 = New-Object Point ($pTop.X, ($pTop.Y + ($arrGroItem.Lanes[$n].LaneHeight)))
                    $pBottom1 = New-Object Point ($pTop.X, ($pTop.Y + $arrGroItem.Lanes[$n].LaneHeight))
                    $pBottom2 = New-Object Point (($pTop.X +(($arrGroItem.PoolWidth-$PoolTAreaSize) )), ($pTop.Y + $arrGroItem.Lanes[$n].LaneHeight))           
                    $LaneTAreaRect = New-Object Rectangle $pTop.X , $pTop.Y, ($PoolTAreaSize) , $arrGroItem.Lanes[$n].LaneHeight
                    $MainPath.AddRectangle($LaneTAreaRect)
                    $arrGroItem.Lanes[$n].TextPAth = $MainPath
                    $LaneLineReac = New-Object Rectangle $pBottom1.X , ($pBottom1.Y - $PoolLineSize), ($arrGroItem.PoolWidth-$PoolTAreaSize) , $intGroPenSize
                    $LinePath.AddRectangle($LaneLineReac)

#                    $BottomPath.AddLine($pBottom1,$pBottom2)
<#                     
                    $BottomPath.AddLine((New-Object Point ($pBottom2.X), ($pBottom2.Y + $LaneLineSize)), `
                                    (New-Object Point ($pBottom1.x ), ($pBottom1.Y+$LaneLineSize)))

                    $BottomPath.CloseAllFigures()
#>
#                    $arrGroItem.Lanes[$n].BottomPath = $BottomPath  
#                    $e.Graphics.FillPath($TextBrush, $LinePath)
                    
                    $e.Graphics.FillPath($WhiteTextBrush, $LinePath)
                    $e.Graphics.DrawLine($arrGroItem.TextPen,$pBottom1,$pBottom2)

#                    $pTemp = New-Object Point ($arrGroItem.Lanes[$n].pTop.X - $arrGroItem.Lanes[$n].pTXDiffer) , ($arrGroItem.Lanes[$n].pTop.Y - $arrGroItem.Lanes[$n].pTYDiffer)
                    If($Global:SelText -eq $arrGroItem.Lanes[$n].TextPath)
                    {
                        $TextPath.AddString($arrGroItem.Lanes[$n].Text, $fonty.FontFamily , $BoldFont, $TextSize ,$pTemp, [StringFormat]::GenericDefault)            
                    }
                    Else
                    {
                        $TextPath.AddString($arrGroItem.Lanes[$n].Text, $fonty.FontFamily , $RegularFont, $TextSize ,$pTemp, [StringFormat]::GenericDefault) 
                    } 
                    $arrGroItem.Lanes[$n].TextPath = $TextPath
                    $arrGroItem.Lanes[$n].TAreaPath = $MainPath
                    $arrGroItem.Lanes[$n].LanePath = $LinePath
                    $matrix = New-Object System.Drawing.Drawing2D.Matrix
                    $matrix.RotateAt(-90,$pTemp)
                    $TextPath.Transform($matrix)
                    $e.Graphics.FillPath($TextBrush,$TextPath)
                               

                }
                Else
                {
                    $arrGroItem.Lanes[$n].pBottom1 = $arrGroItem.pTop2
                }
            }
        }
    }                
}

Function funDPanMouseUp{
    $Global:bolMouseMove = $false
    $Global:bolMouseDown = $false
    $Global:SelLane = $Null
    $SubIconTbl.Controls | Where-Object -FilterScript {$_.Checked} | % {   
        $_.checked = $false
        $Global:typing = $Null
        $Global:SelText = $Null
        $Global:SelPath = $Null
        $DesktopPan.Invalidate()
    }

    If ($Global:objShape -ne $null)
    {
        foreach($cont in $ShapesTbl.Controls)
        {
            $cont.checked = $false
        }
    }

    If ($Global:objGroup -ne $null)
    {
        foreach($cont in $GroupsTbl.Controls)
        {
            $cont.checked = $false
        }
    }       
}

Function funDPanMouseMove{
    If(
        ($Global:bolMouseDown) -and 
        ($global:objShape -ne $null -or $Global:SelPath -ne $Null -or $Global:objGroup -ne $Null) -and 
#        !$SolidLine.Checked -and !$DashedLine.Checked -and !$dottedline.Checked
        !($LinesTbl.Controls | Where-Object -FilterScript {$_.Checked})
      )
    {
        $Global:bolMouseMove = $true
        $mouse = [Cursor]::Position
        $point = $DesktopPan.PointToClient($mouse)
        If(($point.X  -gt 50) -and ($point.Y -gt 50))
        {
            If(($point.X + 50  -lt $DesktopPan.Size.Width) -and ($point.Y + 50  -lt $DesktopPan.Size.Height))
            {
                $DesktopPan.Invalidate()                
            }
        }         
    }
    Else
    {
        If( $Global:objShapePoint -ne $null) 
        {
           $DesktopPan.Invalidate()
        } 
    }    
}

Function funNewBtn{

}

Function funLoadBtn{
    $dialog = [System.Windows.Forms.OpenFileDialog]::new()
    $dialog.RestoreDirectory = $true
    $result = $dialog.ShowDialog()
    if($result -eq [System.Windows.Forms.DialogResult]::OK){
        funClearAll
        $Global:Loading = $true
        $global:serializedObj = $null
        $global:SerializedP = New-Object Point
        $objPSNewShape = Import-Clixml $dialog.FileName
        $FileNameLbl.Text = ((Get-Item $dialog.FileName).Name).Replace(".ate",'')
        $objPSNewShape.arrGroups
        foreach($objLoad in $objPSNewShape.arrRegions)
        {
            $global:Class = $objLoad.Class
            $global:serializedObj = $objLoad.Type
            $Global:intIterate = $objLoad.intIterate
            $global:SerializedP.X = $objLoad.pCenter.X
            $global:SerializedP.Y = $objLoad.pCenter.Y
            $DesktopPan.Invalidate() 
            $DesktopPan.Update()        
        }
        for($i = 0; $i -lt $MainObject.arrRegions.Count; $i++)
        {
            $arrItem = $MainObject.arrRegions[$i]
            foreach($objLoad in $objPSNewShape.arrRegions)
            {
                If($objLoad.Name -eq $MainObject.arrRegions[$i].Name)
                {
                    $MainObject.arrRegions[$i].Text = $objLoad.Text
                    $MainObject.arrRegions[$i].pTXDiffer = $objLoad.pTXDiffer
                    $MainObject.arrRegions[$i].pTYDiffer = $objLoad.pTYDiffer
                    $MainObject.arrRegions[$i].Icon = $objLoad.Icon
                    $MainObject.arrRegions[$i].SubProcess = $objLoad.SubProcess
                    $MainObject.arrRegions[$i].Condition = $objLoad.Condition               
                    for($c = 0; $c -lt $objLoad.ConnArr.Count; $c++)
                    {
                        $points = [ArrayList]@()
                        for($k = 0; $k -lt $objLoad.ConnArr[$c].Points.Count; $k++)
                        {
                            $p = New-Object Point $objLoad.ConnArr[$c].Points[$k].X,$objLoad.ConnArr[$c].Points[$k].Y
                            $points.Add($p)
                        }
                        $connObj = [pscustomobject]@{
                            Points = $points
                            ConnObj = $MainObject.arrRegions | where name -eq $objLoad.ConnArr[$c].ConnObj.Name
                            Name = $objLoad.ConnArr[$c].Name
                            ConnType = $objLoad.ConnArr[$c].ConnType
                            StartPoint = $objLoad.ConnArr[$c].StartPoint
                            ConnPoint = $objLoad.ConnArr[$c].ConnPoint
                            Path = $objLoad.ConnArr[$c].Path
                            Text = $objLoad.ConnArr[$c].Text
                            pCenter = $objLoad.ConnArr[$c].pCenter
                            TextPath = $objLoad.ConnArr[$c].TextPath
                            pTXDiffer = $objLoad.ConnArr[$c].pTXDiffer
                            pTYDiffer = $objLoad.ConnArr[$c].pTYDiffer
                            LineStyle = $objLoad.ConnArr[$c].LineStyle
                        } 
                        $MainObject.arrRegions[$i].ConnArr.Add($connObj)
                    }
                }
            }
        }
        foreach($objLoad in $objPSNewShape.arrGroups)
        {
            $global:serializedObj = $objLoad.Type
            $Global:intIterate = $objLoad.intIterate
            $global:SerializedP.X = $objLoad.Point.X
            $global:SerializedP.Y = $objLoad.Point.Y
            $global:PoolWidth = $objLoad.PoolWidth
            $global:PoolHeight = $objLoad.PoolHeight
            $DesktopPan.Invalidate() 
            $DesktopPan.Update()        
        }
        $Global:Loading = $false
        for($i = 0; $i -lt $MainObject.arrGroups.Count; $i++)
        {
            foreach($objLoad in $objPSNewShape.arrGroups)
            {
                If($objLoad.Name -eq $MainObject.arrGroups[$i].Name)
                {
                    $MainObject.arrGroups[$i].Text = $objLoad.Text
                    $MainObject.arrGroups[$i].pTXDiffer = $objLoad.pTXDiffer
                    $MainObject.arrGroups[$i].pTYDiffer = $objLoad.pTYDiffer                
                    for($u = 1; $u -lt $objLoad.Lanes.Count; $u++)
                    {
                        $global:serializedObj = ""
                        $Global:intIterate ++
                        
                        $objLane = [pscustomobject]@{     
                                Name = $objLoad.Lanes[$u].name
                                Type= $objLoad.Lanes[$u].Type
                                pCenter = $Null
                                TextPath = $Null
                                LanePath = $Null
                                TAreaPath = $Null
                                intIterate = $objLoad.Lanes[$u].intIterate
                                Pool = $objLoad.Lanes[$u].Pool
                                Point = $objLoad.Lanes[$u].point
                                TPoint = $objLoad.Lanes[$u].TPoint
                                pTop = $objLoad.Lanes[$u].pTop
                                pBottom1 = $objLoad.Lanes[$u].pBottom1
                                pBottom2 = $objLoad.Lanes[$u].pBottom2
                                Text = $objLoad.Lanes[$u].Text
                                TextPen = $TinyPen
                                MainPen = $GroupPen
                                pTXDiffer = $objLoad.Lanes[$u].pTXDiffer
                                pTYDiffer = $objLoad.Lanes[$u]. pTYDiffer
                                LaneHeight =$objLoad.Lanes[$u].LaneHeight
                            } 
                        $MainObject.arrGroups[$i].Lanes.Add($objLane)
                        $DesktopPan.Invalidate() 
                        $DesktopPan.Update()
    <#                                         
                        $MainObject.arrGroups[$i].Lanes[$u].Point = $objLoad.Lanes[$u].point
                        $MainObject.arrGroups[$i].Lanes[$u].TPoint = $objLoad.Lanes[$u].Null
                        $MainObject.arrGroups[$i].Lanes[$u].pTop = $objLoad.Lanes[$u].pTop
    
                        $MainObject.arrGroups[$i].Lanes[$u].pBottom1 = $objLoad.Lanes[$u].pBottom1
    
                        $MainObject.arrGroups[$i].Lanes[$u].pBottom2 = $objLoad.Lanes[$u].pBottom2
                        $MainObject.arrGroups[$i].Lanes[$u].LanePAth = $objLoad.Lanes[$u].BottomPath
                        $MainObject.arrGroups[$i].Lanes[$u].TAreaPath = $objLoad.Lanes[$u].TAreaPath
                        $MainObject.arrGroups[$i].Lanes[$u].TextPath = $objLoad.Lanes[$u].TextPath
                        $MainObject.arrGroups[$i].Lanes[$u].pCenter = $objLoad.Lanes[$u].pCenter
                        $MainObject.arrGroups[$i].Lanes[$u].TextPen = $objLoad.Lanes[$u].TinyPen
                        $MainObject.arrGroups[$i].Lanes[$u].MainPen = $objLoad.Lanes[$u].GroupPen
                    
                        $MainObject.arrGroups[$i].Lanes[$u].Pool = $objLoad.Lanes[$u].Pool
    
                        $MainObject.arrGroups[$i].Lanes[$u].LaneHeight = $objLoad.Lanes[$u].LaneHeight
                        
                        $MainObject.arrGroups[$i].Lanes[$u].intIterate = $objLoad.Lanes[$u].intIterate
                        $MainObject.arrGroups[$i].Lanes[$u].Type = $objLoad.Lanes[$u].Type
                        $MainObject.arrGroups[$i].Lanes[$u].Text = $objLoad.Lanes[$u].Text
                        $MainObject.arrGroups[$i].Lanes[$u].pTXDiffer = $objLoad.Lanes[$u].pTXDiffer
                        $MainObject.arrGroups[$i].Lanes[$u].pTYDiffer = $objLoad.Lanes[$u].pTYDiffer 
    
    [pscustomobject]@{     
                        Name = $name
                        Type= $strSwitch
                        intIterate = $Global:intIterate
                        Pool = $Null
                        Point = $point
                        TPoint = $Null
                        pTop = $pTop
                        pBottom1 = $pBottom1
                        pBottom2 = $pBottom2
                        LanePAth = $BottomPath
                        TAreaPath = $TAreaPath
                        Text = $name
                        TextPath = $TextPath
                        pCenter = $pCenter
                        TextPen = $TinyPen
                        MainPen = $GroupPen
                        pTXDiffer = 0
                        pTYDiffer = 0
                        LaneHeight = $LaneSize
                    }
    #>                    
                                 
                    }                
                
                
                }

            }
        }
        $DesktopPan.Invalidate() 
        $Global:strFileName = Get-Item $dialog.FileName
        
    }
}

Function funSaveAsBtn{
    $dialog = [System.Windows.Forms.SaveFileDialog]::new()
    $dialog.RestoreDirectory = $true
    $result = $dialog.ShowDialog()
    if($result -eq [System.Windows.Forms.DialogResult]::OK){
        $Global:strFileName = "$($dialog.FileName).ate"
        $MainObject | Export-Clixml "$($dialog.FileName).ate" -Depth 1
        $FileNameLbl.Text = ((Get-Item "$($dialog.FileName).ate").Name).Replace(".ate",'')
    }   
}

Function funSaveBtn{

    If($Global:strFileName -eq $Null)
    {
        $dialog = [System.Windows.Forms.SaveFileDialog]::new()
        $dialog.RestoreDirectory = $true
        $result = $dialog.ShowDialog()
        $MainObject.arrGroups
        if($result -eq [System.Windows.Forms.DialogResult]::OK){
            $Global:strFileName = "$($dialog.FileName).ate"
            $MainObject | Export-Clixml "$($dialog.FileName).ate" -Depth 1
            $FileNameLbl.Text = (Get-Item "$($dialog.FileName).ate").Name
        }
    }
    Else
    {
        $MainObject | Export-Clixml $Global:strFileName -Depth 1
    } 
    $MainObject.arrGroups  
}

Function funDisAllShapes($O) {  
    foreach($obj in $ShapesTbl.Controls)
    {
        If($obj -ne $O)
        {
            $obj.checked = $false   
        }    
    }
    foreach($obj in $SubIconTbl.Controls)
    {
        If($obj -ne $O -and $obj.checked)
        {
            $obj.checked = $false   
        }  
    }   
        foreach($obj in $LinesTbl.Controls)
    {
        If($obj -ne $O)
        {
            $obj.checked = $false   
        }  
    }  
    foreach($obj in  $LaunchTbl.Controls)
    {
        If($obj -ne $O)
        {
            $obj.checked = $false   
        }  
    } 
    foreach($obj in  $GroupsTbl.Controls)
    {
        If($obj -ne $O)
        {
            $obj.checked = $false   
        }  
    }
    If($O -ne $Annotation)
    {
        $Annotation.Checked = $false
    } 
    If(
        !($LinesTbl.Controls | Where-Object -FilterScript {$_.Checked}) -and 
        !($GroupsTbl.Controls | Where-Object -FilterScript {$_.Checked}) -and 
        !($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked})
      )
    {
        $Global:objShapePoint = $Null
        $desktopPan.Invalidate()
    }  
}

function Set-DoubleBuffer {
    param ([Parameter(Mandatory = $true)]
        [Panel]$grid,
        [boolean]$Enabled)  
    $type = $grid.GetType();
    $propInfo = $type.GetProperty("DoubleBuffered", ('Instance','NonPublic'))
    $propInfo.SetValue($grid, $Enabled)
}

function funClearAll{
    If($MainObject.arrRegions.Count -gt 0)
    {  
        $MainObject.arrRegions.Clear()
    }
    If($MainObject.arrGroups.Count -gt 0)
    {  
        $MainObject.arrGroups.Clear()
    }    
} 

#-----------------------------EndOfFunctions

    $MainObject = [pscustomobject]@{
                    arrRegions = [ArrayList]@()
                    arrGroups = [ArrayList]@()
                  }
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
            If($_.functions -ne [System.DBNull]::Value)
            {
                $funName = $_.functions
                New-Variable -Force -Name "$($_.objName)var" -Value ($_.functions)
                $thisControl.Add_Click({
                    If(!$This.Checked){$DesktopPan.Focus()}
                    funDisAllShapes  $This
                    $ObjFunVar = Get-Variable -ValueOnly -Include "$($This.Name)$VarFileCont"
                    invoke-expression  $ObjFunVar
                })                                     
            }
            Else
            {
                $thisControl.Add_Click({
                    If(!$This.Checked){$DesktopPan.Focus()}
                    funDisAllShapes  $This
                })                  
            }
            $Thistbl = Get-Variable -ValueOnly -Include $_.TableName
            $Thistbl.controls.add($thisControl)                
        }                                    
    }

#----------------------------Controls

$DesktopPan = New-Object Panel
#$DesktopPan.BackColor = 'green'
$DesktopPan.Location = New-Object Size(120,50)
$DesktopPan.Size = New-Object Size(1100,700)
$DesktopPan.Dock = [DockStyle]::Fill
#$DesktopPan.AutoSize = $true
$DesktopPan.name = "Main"
$DesktopPan.BorderStyle = 1
$DesktopPan.Add_paint({
    param([System.Object]$s, [PaintEventArgs]$e)
    funDPanAddpaint $s $e       
})
$DesktopPan.add_MouseDown({funDPanMouseDown})
$DesktopPan.add_MouseUp({funDPanMouseUp})
$DesktopPan.add_MouseMove({funDPanMouseMove})

$Annotation = New-Object CheckBox
$Annotation.Size = New-Object Size($GroupSizeX,$subIconButSize)
$Annotation.name = 'Annotation'
$Annotation.Image = funImgStreamer "D:\ATE\IT\Root\images\Annotation.png"
$Annotation.ImageAlign = 'MiddleCenter'
$Annotation.Appearance = 1
$Annotation.FlatStyle = 2
$Annotation.Padding = 5
$Annotation.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Annotation
})

$MainTbl = New-Object TableLayoutPanel
$MainTbl.AutoSize = $true
$MainTbl.CellBorderStyle = 1
$MainTbl.ColumnCount = 2
$MainTbl.RowCount = 5

$ReturnBtn = New-Object Button
$ReturnBtn.Location = New-Object Size(2,50) 
$ReturnBtn.name = "Desktop"
$ReturnBtn.BackColor = "#d2d4d6"
$ReturnBtn.text = "<<<< بازگشت به صفحه قبل"
$ReturnBtn.width = 115
$ReturnBtn.height = 40
$ReturnBtn.Font = 'Microsoft Sans Serif,10'
$ReturnBtn.ForeColor = "#000"
$ReturnBtn.TabIndex = 1
$ReturnBtn.Add_Click({
    $SecoForm.Close()
    $SecoForm.Dispose()
    & "$MainRoot\$($this.Name).ps1"
}.GetNewClosure())

$MainTbl.Controls.Add($ReturnBtn,0,0)
$MainTbl.Controls.Add($ReturnBtn,0,0)
$MainTbl.Controls.Add($TopMenuTbl,1,0)
$MainTbl.Controls.Add($DesktopPan,1,1)
$MainTbl.Controls.Add($ShapesTbl,0,1)
$MainTbl.Controls.Add($SubIconTbl,0,2)
$MainTbl.Controls.Add($LinesTbl,0,3)
#$MainTbl.Controls.Add($butsTbl,0,4)
$MainTbl.Controls.Add($GroupsTbl,0,4)
$MainTbl.Controls.Add($Annotation,0,5)
$MainTbl.SetRowSpan($DesktopPan,6)

$Secoform.Controls.Add($MainTbl)
$Secoform.Add_Shown({$Secoform.Activate(); $DesktopPan.Focus()})
$Secoform.KeyPreview = $true
$Secoform.Add_KeyDown({funFormKeyDown})

$Secoform.Add_Closing{
   $Global:objShapePoint = $null
   $Global:objShape = $null
   $Global:objGroup = $Null
   $Global:SelPath = $Null
   $Global:SelLane = $Null
   $Global:intIterate = 0
   $Global:ObjLane = $Null
#   $Global:objGroup?.AxisPath = $Null
   $MainObject.arrRegions.Clear()
   $MainObject.arrGroups.Clear()
}
$Secoform.Add_Load{
    Set-DoubleBuffer -grid $DesktopPan -Enabled $true
    $DelShape.Focus()
    
}

[void]$Secoform.ShowDialog()   # display the dialog