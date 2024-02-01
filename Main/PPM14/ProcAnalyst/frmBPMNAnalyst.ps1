<#
using namespace System.IO
using namespace System.Collections
using namespace System.Drawing
using namespace System.Drawing.Imaging
using namespace System.Windows.Forms
using assembly System.Windows.Forms
# Load the GDI+ and WinForms Assemblies
[void][reflection.assembly]::LoadWithPartialName( "System.IO")
[void][reflection.assembly]::LoadWithPartialName( "System.Drawing")
[void][reflection.assembly]::LoadWithPartialName( "System.Drawing.Imaging")
#>

. "$(Split-Path $PSScriptRoot -Parent)\Config\$(($PSCommandPath.Split('\') | select -last 1) -replace (".ps1$","var.ps1"))"

if($varDebugTrace -ne 0)
{
    Set-PSDebug -Trace $varDebugTrace    
}
Else
{
    Set-PSDebug -Trace $varDebugTrace  
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
                $Global:typing.Text = "$($Global:typing.Text)$($_.Keycode)"
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
    If ($arrRegions.Count -gt 0 -and $global:objShape -ne $null)
    {
        $arrRegions.Remove($global:objShape)
        $Global:objShape = $null       
    }
    Else
    {
        If($Global:SelPath -ne $Null)
        {
            for($i = 0; $i -lt $arrRegions.Count; $i++)
            {
                for($q = 0; $q -lt $arrRegions[$i].ConnArr.Count; $q++)
                {
                    If($arrRegions[$i].ConnArr[$q] -eq $Global:SelPath)
                    {
                        $arrRegions[$i].ConnArr.Remove($Global:SelPath)
                        $Global:SelPath = $Null
                        Break
                    }
                }
            }
        }
    }
    $DesktopPan.Invalidate()     
}

Function imgStreamer($imgPath){

    $inStream = ([FileInfo]$imgPath).Open([FileMode]::Open, [FileAccess]::ReadWrite)
    [Image]::FromStream($inStream)
    $inStream.Dispose()
}

Function funDPanMouseDown{
    $Global:bolMouseDown = $true
    $BolCont = $false
    $mouse = [Cursor]::Position
    $point = $DesktopPan.PointToClient($mouse)
    $Global:SelPath = $Null
    $Global:SelText = $Null
#    If(!$TextIcon.Checked)
#    {
    for($i = 0; $i -lt $arrRegions.Count; $i++)
    {
        $arrItem = $arrRegions[$i]
        $Global:typing = $null
        If ($arrItem.ShadowRegion.isVisible($point))
        {
            $BolCont = $True
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
                            pTextX = 0
                            pTextY = 0
                            LineStyle = ($LinesTbl.Controls | Where-Object -FilterScript {$_.Checked}).Tag
                        }
                        $Global:objShape.ConnArr.Add($objConn)                                                                                
                    }
                Else
                {
                    $Global:objShapePoint = $null
                }
            }
            Else
            {
                If(($SubIconTbl.Controls | Where-Object -FilterScript {$_.Checked}))
                {
                    If($TextIcon.Checked)
                    {
                        $Global:typing = $arrItem
                    }
                }
                Else
                {
                    If($arrItem.TextPath -ne $Null)
                    {
                        If($arrItem.TextPath.isvisible($point))
                        {
                            $Global:SelText = $arrItem
                        }
                    }
                }
            }
            If($SolidLine.Checked) 
            {
                funDisAllShapes $SolidLine  
            }
                ElseIf($DashedLine.Checked)
                {
                    funDisAllShapes $DashedLine
                }
                    ElseIf($DottedLine.Checked)
                    {
                        funDisAllShapes $DottedLine
                    }
            Else
            {
                    funDisAllShapes $null
                    $Global:objShape = $null
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
    If(!$BolCont)
    {
        If(($SolidLine.Checked -or $DashedLine.Checked -or $dottedLine.Checked) -and ($Global:objShapePoint -ne $null) -and ($Global:objShape -ne $null))
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
            $Global:objShape = $null
            $Global:objShapePoint = $null                   
        }
    }               
<#
    }
    Else
    {
        $Global:typing = $true
        $textObj = [pscustomobject]@{
                    Name = "Text$($arrTexts.Count)"
                    Point = $point
                    Bounded = $false
                    BoundedObj = $Null
                    Text = "test"
                }
        $arrTexts.Add($textObj)
    }
 #>       
    $DesktopPan.Invalidate() 
}

Function funDPanAddpaint($s,$e){
#    $e.Graphics.InterpolationMode = 2
    $e.Graphics.SmoothingMode = 4
    $mouse = [Cursor]::Position
    $point = $DesktopPan.PointToClient($mouse)
    $strSwitch = ""
    If ($StartCircle.Checked -or $Dimond.Checked -or $Square.Checked -Or $InterCircle.Checked -Or $DataObj.Checked)
    {
        $strSwitch = ($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name
    }
    If($Global:SelText -eq $Null)
    {
        If($Global:bolMouseMove -And $Global:bolMouseDown -And $global:objShape -ne $null)
        {
            $strSwitch = $global:objShape.type  
        }
    }
    Else
    {
        $Global:SelText.pTXDiffer = $Global:SelText.pCenter.x - $point.x
        $Global:SelText.pTYDiffer = $Global:SelText.pCenter.Y - $point.Y
    }
    If($Global:Loading)
    {
        $point = $Global:SerializedP
        $strSwitch = $global:serializedObj
    }
    $MainPath = New-Object Drawing2D.GraphicsPath
    $ShadowPath = New-Object Drawing2D.GraphicsPath
    $pTopPath = New-Object Drawing2D.GraphicsPath
    $pRightPath = New-Object Drawing2D.GraphicsPath
    $pBottomPath = New-Object Drawing2D.GraphicsPath
    $pLeftPath = New-Object Drawing2D.GraphicsPath
    switch ($strSwitch)
    {
        'StartCircle' { 
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
        'InterCircle' {
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
        'dimond' {           
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
        'Square' {
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
        'DataObject' {
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
    }
    If($strSwitch -ne "")
    {
        $ptopRegion = new-object Region $pTopPath
        $pRightRegion = new-object Region $pRightPath
        $pBottomRegion = new-object Region $pBottomPath
        $pLeftRegion = new-object Region $pLeftPath
        $ShadowRegion = new-object Region $ShadowPath
        $MainRegion = new-object Region  $MainPath
        If((($Global:bolMouseMove -eq $false) -or ($Global:bolMouseDown -eq $faslse) -or ($global:objShape -eq $null)) -or ($Global:Loading))
        {
            If($Global:Loading)
            {
                $name = "$strSwitch$($Global:intIterate)"
            }
            Else
            {
                $Global:intIterate ++
                $name = "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"                
            }
            $objPSNewShape = [pscustomobject]@{
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
                TextPath = $Null
                pTXDiffer = 0
                pTYDiffer = 0
                fillColor = $fillColor                 
                maxConn = $maxConn
                bolInput = $bolInput
            }
            [void]$arrRegions.Add($objPSNewShape)
            funDisAllShapes $null
            $global:objShape = $objPSNewShape
        }
        Else
        {
            $global:objShape.Point = $Orgpoint
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
    }
    If ($arrRegions.count -gt 0)
    {        
        for($i = 0; $i -lt $arrRegions.Count; $i++)
        {
            $arrItem = $arrRegions[$i]           
            If (
                $arrItem.Mainregion.isVisible($DesktopPan.PointToClient([Cursor]::Position)) `
                -or ($arrItem -eq $Global:objShape)                                                                                                       
               )
            {       
                $e.Graphics.DrawPath($mypen2, $arrItem.ShadowPath)
                $e.Graphics.DrawPath($arrItem.MainPen, $arrItem.MainPath)
                
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
                $e.Graphics.DrawPath($arrItem.MainPen, $arrItem.MainPath)
                $PathGraBrush = New-Object Drawing2D.LinearGradientBrush ($arrItem.BottomPointGB,$arrItem.TopPointGB,$arrItem.fillColor,[color]::White)
#                $PathGraBrush.SurroundColors = $arrItem.fillColor

                $e.Graphics.FillPath($PathGraBrush,$arrItem.MainPath)
                               
#                $e.Graphics.DrawString("test", $fonty , $myBrush, $arrItem.p.X+40,$arrItem.p.y+55, [StringFormat]::GenericDefault)
 #               $e.Graphics.DrawImage($avatar,$arrItem.P1.x,$arrItem.P1.y)
#                $e.Graphics.DrawImage($avatar,$arrItem.P2.x,$arrItem.P2.y)
#                $e.Graphics.SetClip($arrItem.Mainregion,4)
            }
            If($arrItem.Text -ne "")
            {
                New-Variable -Force -Name "$($arrItem.Name)$cTPath" -Value (New-Object Drawing2D.GraphicsPath) 
                $TextPath = Get-Variable -ValueOnly -Include "$($arrItem.Name)$cTPath"
                $pTemp = $pp1 = New-Object Point ($arrItem.Pcenter.X - $arrItem.pTXDiffer) , ($arrItem.Pcenter.Y - $arrItem.pTYDiffer)
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
                $arrConnItem.connobj.PCenter.y
                $arrConnItem.ConnPoint
                $arrConnItem.ConnType
                $intFirstLineSize
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
            }            
        }
    }           
}

Function funDPanMouseUp{
    $Global:bolMouseMove = $false
    $Global:bolMouseDown = $false
    If ($Global:objShape -ne $null)
    {
        foreach($cont in $ShapesTbl.Controls)
        {
            $cont.checked = $false
        }
    }   
}

Function funDPanMouseMove{
    If(($Global:bolMouseDown) -and ($global:objShape -ne $null) -and !$SolidLine.Checked -and !$DashedLine.Checked -and !$dottedline.Checked)
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
        $namelbl.Text = ((Get-Item $dialog.FileName).Name).Replace(".ate",'')
        foreach($objLoad in $objPSNewShape)
        {
            $global:serializedObj = $objLoad.Type
            $Global:intIterate = $objLoad.intIterate
            $global:SerializedP.X = $objLoad.pCenter.X
            $global:SerializedP.Y = $objLoad.pCenter.Y
            $DesktopPan.Invalidate() 
            $DesktopPan.Update()        
        }
        for($i = 0; $i -lt $arrRegions.Count; $i++)
        {
            $arrItem = $arrRegions[$i]
            foreach($objLoad in $objPSNewShape)
            {
                If($objLoad.Name -eq $arrRegions[$i].Name)
                {
                    $arrRegions[$i].Text = $objLoad.Text
                    $arrRegions[$i].pTXDiffer = $objLoad.pTXDiffer
                    $arrRegions[$i].pTYDiffer = $objLoad.pTYDiffer                
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
                            ConnObj = $arrRegions | where name -eq $objLoad.ConnArr[$c].ConnObj.Name
                            Name = $objLoad.ConnArr[$c].Name
                            ConnType = $objLoad.ConnArr[$c].ConnType
                            StartPoint = $objLoad.ConnArr[$c].StartPoint
                            ConnPoint = $objLoad.ConnArr[$c].ConnPoint
                            Path = $objLoad.ConnArr[$c].Path
                            Text = $objLoad.ConnArr[$c].Text
                            pTextX = $objLoad.ConnArr[$c].TextX
                            pTextY = $objLoad.ConnArr[$c].TextY
                            LineStyle = $objLoad.ConnArr[$c].LineStyle
                        } 
                        $arrRegions[$i].ConnArr.Add($connObj)
                    }
                }
            }
        }
        $DesktopPan.Invalidate() 
        $Global:strFileName = Get-Item $dialog.FileName
        $Global:Loading = $false
    }
}

Function funSaveAsBtn{
    $dialog = [System.Windows.Forms.SaveFileDialog]::new()
    $dialog.RestoreDirectory = $true
    $result = $dialog.ShowDialog()
    if($result -eq [System.Windows.Forms.DialogResult]::OK){
        $Global:strFileName = "$($dialog.FileName).ate"
        $arrRegions | Export-Clixml "$($dialog.FileName).ate" -Depth 1
        $namelbl.Text = ((Get-Item "$($dialog.FileName).ate").Name).Replace(".ate",'')
    }   
}

Function funSaveBtn{

    If($Global:strFileName -eq $Null)
    {
        $dialog = [System.Windows.Forms.SaveFileDialog]::new()
        $dialog.RestoreDirectory = $true
        $result = $dialog.ShowDialog()
        if($result -eq [System.Windows.Forms.DialogResult]::OK){
            $Global:strFileName = "$($dialog.FileName).ate"
            $arrRegions | Export-Clixml "$($dialog.FileName).ate" -Depth 1
            $namelbl.Text = (Get-Item "$($dialog.FileName).ate").Name
        }
    }
    Else
    {
        $arrRegions | Export-Clixml $Global:strFileName -Depth 1
    }   
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
        If($obj -ne $O)
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
    If(
        !($LinesTbl.Controls | Where-Object -FilterScript {$_.Checked}) -and 
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
    If($arrRegions.Count -gt 0)
    {  
        $arrRegions.Clear()
    }   
} 

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

$ShowPRFbtn = New-Object Button
#$ShowPRFbtn.Location = New-Object System.Drawing.Size(1000,38) 
$ShowPRFbtn.BackColor = "#d2d4d6"
$ShowPRFbtn.text = "پاک کردن همه شکلها"
$ShowPRFbtn.width = 110
$ShowPRFbtn.height = 25
$ShowPRFbtn.Font = 'Microsoft Sans Serif,10'
$ShowPRFbtn.ForeColor = "#000"
$ShowPRFbtn.Add_Click({
    funDisAllShapes $ShapesTbl
    funClearAll  
    $DesktopPan.Invalidate()         
})

$DelShape = New-Object Button
$DelShape.Location = New-Object Size(2,50) 
$DelShape.BackColor = "#d2d4d6"
$DelShape.text = "حذف شکل"
$DelShape.width = 110
$DelShape.height = 25
$DelShape.Font = 'Microsoft Sans Serif,10'
$DelShape.ForeColor = "#000"
$DelShape.TabIndex = 1
$DelShape.Add_Click({
    funDisAllShapes $ShapesTbl
    funDelShape       
})


$SolidLine = New-Object CheckBox
$SolidLine.Size = New-Object Size(100,25)
$SolidLine.name = 'LightMess'
$SolidLine.Tag = 0
$SolidLine.Image = imgStreamer "D:\ATE\IT\Root\images\SolidLine.png"
$SolidLine.Appearance = 1
$SolidLine.FlatStyle = 2
$SolidLine.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $SolidLine
})

$DashedLine = New-Object CheckBox
$DashedLine.Size = New-Object Size(100,25)
$DashedLine.Tag = 1
$DashedLine.name = 'LightMess'
$DashedLine.Image = imgStreamer "D:\ATE\IT\Root\images\DashedLine.png"
$DashedLine.Appearance = 1
$DashedLine.FlatStyle = 2
$DashedLine.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $DashedLine
})

$DottedLine = New-Object CheckBox
$DottedLine.Size = New-Object Size(100,25)
$DottedLine.Tag = 2
$DottedLine.name = 'LightMess'
$DottedLine.Image = imgStreamer "D:\ATE\IT\Root\images\DottedLine.png"
$DottedLine.Appearance = 1
$DottedLine.FlatStyle = 2
$DottedLine.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $DottedLine
})

$MessSubIcon = New-Object CheckBox
$MessSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$MessSubIcon.name = 'LightMess'
$MessSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\LightMess.png"
$MessSubIcon.Appearance = 1
$MessSubIcon.FlatStyle = 2
$MessSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $MessSubIcon
})

$DarkMessSubIcon = New-Object CheckBox
$DarkMessSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$DarkMessSubIcon.name = 'DarktMess'
$DarkMessSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\DarkMess.png"
$DarkMessSubIcon.Appearance = 1
$DarkMessSubIcon.FlatStyle = 2
$DarkMessSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $DarkMessSubIcon
})

$GearSubIcon = New-Object CheckBox
$GearSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$GearSubIcon.name = 'Gear'
$GearSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Gear.png"
$GearSubIcon.Appearance = 1
$GearSubIcon.FlatStyle = 2
$GearSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $GearSubIcon
})


$ClockSubIcon = New-Object CheckBox
$ClockSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$ClockSubIcon.name = 'Clock'
$ClockSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Clock.png"
$ClockSubIcon.Appearance = 1
$ClockSubIcon.FlatStyle = 2
$ClockSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ClockSubIcon
})

$CrossSubIcon = New-Object CheckBox
$CrossSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$CrossSubIcon.name = 'Clock'
$CrossSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Cross.png"
$CrossSubIcon.Appearance = 1
$CrossSubIcon.FlatStyle = 2
$CrossSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $CrossSubIcon
})


$SinStartSubIcon = New-Object CheckBox
$SinStartSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$SinStartSubIcon.name = 'Clock'
$SinStartSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\SigStart.png"
$SinStartSubIcon.Appearance = 1
$SinStartSubIcon.FlatStyle = 2
$SinStartSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $SinStartSubIcon
})

$ConSubIcon = New-Object CheckBox
$ConSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$ConSubIcon.name = 'Clock'
$ConSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Condition.png"
$ConSubIcon.Appearance = 1
$ConSubIcon.FlatStyle = 2
$ConSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ConSubIcon
})

$SigEndSubIcon = New-Object CheckBox
$SigEndSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$SigEndSubIcon.name = 'Clock'
$SigEndSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\SigEnd.png"
$SigEndSubIcon.Appearance = 1
$SigEndSubIcon.FlatStyle = 2
$SigEndSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $SigEndSubIcon
})

$ErrEndSubIcon = New-Object CheckBox
$ErrEndSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$ErrEndSubIcon.name = 'Clock'
$ErrEndSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\ErrEnd.png"
$ErrEndSubIcon.Appearance = 1
$ErrEndSubIcon.FlatStyle = 2
$ErrEndSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ErrEndSubIcon
})

$ErrorSubIcon = New-Object CheckBox
$ErrorSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$ErrorSubIcon.name = 'Clock'
$ErrorSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Error.png"
$ErrorSubIcon.Appearance = 1
$ErrorSubIcon.FlatStyle = 2
$ErrorSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ErrorSubIcon
})


$EscaSubIcon = New-Object CheckBox
$EscaSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$EscaSubIcon.name = 'Clock'
$EscaSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Escalation.png"
$EscaSubIcon.Appearance = 1
$EscaSubIcon.FlatStyle = 2
$EscaSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $EscaSubIcon
})

$EscaEndSubIcon = New-Object CheckBox
$EscaEndSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$EscaEndSubIcon.name = 'Clock'
$EscaEndSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\EscalEnd.png"
$EscaEndSubIcon.Appearance = 1
$EscaEndSubIcon.FlatStyle = 2
$EscaEndSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $EscaEndSubIcon
})

$TextIcon = New-Object CheckBox
$TextIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$TextIcon.name = 'Clock'
$TextIcon.Image = imgStreamer "D:\ATE\IT\Root\images\T.png"
$TextIcon.Appearance = 1
$TextIcon.FlatStyle = 2
$TextIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $TextIcon
})

$ArrowSubIcon = New-Object CheckBox
$ArrowSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$ArrowSubIcon.name = 'Clock'
$ArrowSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Arrow.png"
$ArrowSubIcon.Appearance = 1
$ArrowSubIcon.FlatStyle = 2
$ArrowSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ArrowSubIcon
})


$FArrowSubIcon = New-Object CheckBox
$FArrowSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$FArrowSubIcon.name = 'Clock'
$FArrowSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\FArrow.png"
$FArrowSubIcon.Appearance = 1
$FArrowSubIcon.FlatStyle = 2
$FArrowSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $FArrowSubIcon
})

$UserSubIcon = New-Object CheckBox
$UserSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$UserSubIcon.name = 'Clock'
$UserSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\User.png"
$UserSubIcon.Appearance = 1
$UserSubIcon.FlatStyle = 2
$UserSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $UserSubIcon
})

$PlusSubIcon = New-Object CheckBox
$PlusSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$PlusSubIcon.name = 'Clock'
$PlusSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Plus.png"
$PlusSubIcon.Appearance = 1
$PlusSubIcon.FlatStyle = 2
$PlusSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $PlusSubIcon
})

$Play = New-Object CheckBox
$Play.Size = New-Object Size($subIconButSize,$subIconButSize)
$Play.name = 'Clock'
$Play.Image = imgStreamer "D:\ATE\IT\Root\images\Play.png"
$Play.Appearance = 1
$Play.FlatStyle = 2
$Play.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Play
})

$Record = New-Object CheckBox
$Record.Size = New-Object Size($subIconButSize,$subIconButSize)
$Record.name = 'Record'
$Record.Image = imgStreamer "D:\ATE\IT\Root\images\Record.png"
$Record.Appearance = 1
$Record.FlatStyle = 2
$Record.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Record
})

$Stop = New-Object CheckBox
$Stop.Size = New-Object Size($subIconButSize,$subIconButSize)
$Stop.name = 'Record'
$Stop.Image = imgStreamer "D:\ATE\IT\Root\images\Stop.png"
$Stop.Appearance = 1
$Stop.FlatStyle = 2
$Stop.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Stop
})

$ZoomOut = New-Object CheckBox
$ZoomOut.Size = New-Object Size($subIconButSize,$subIconButSize)
$ZoomOut.name = 'Record'
$ZoomOut.Image = imgStreamer "D:\ATE\IT\Root\images\ZoomOut.png"
$ZoomOut.Appearance = 1
$ZoomOut.FlatStyle = 2
$ZoomOut.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ZoomOut
    $this.Checked = $false
})

$Magnifier = New-Object CheckBox
$Magnifier.Size = New-Object Size($subIconButSize,$subIconButSize)
$Magnifier.name = 'Record'
$Magnifier.Image = imgStreamer "D:\ATE\IT\Root\images\Magnifier.png"
$Magnifier.Appearance = 1
$Magnifier.FlatStyle = 2
$Magnifier.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Magnifier
    $this.Checked = $false
})

$ZoomIn = New-Object CheckBox
$ZoomIn.Size = New-Object Size($subIconButSize,$subIconButSize)
$ZoomIn.name = 'Record'
$ZoomIn.Image = imgStreamer "D:\ATE\IT\Root\images\ZoomIn.png"
$ZoomIn.Appearance = 1
$ZoomIn.FlatStyle = 2
$ZoomIn.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ZoomIn
    $this.Checked = $false
})


$StartCircle = New-Object CheckBox
$StartCircle.Size = New-Object Size($ShapesSize,$ShapesSize)
$StartCircle.Name = 'StartCircle'
$StartCircle.Image = imgStreamer "D:\ATE\IT\Root\images\StartCircle.png"
#$StartCircle.Location = New-Object System.Drawing.Size(20,100) 
$StartCircle.Appearance = 1
$StartCircle.FlatStyle = 2
#$StartCircle.width = 80
#$StartCircle.height = 80
#$StartCircle.AutoSize = $true
#$StartCircle.Padding = 5
$StartCircle.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $StartCircle
})

$InterCircle = New-Object CheckBox
$InterCircle.Size = New-Object Size($ShapesSize,$ShapesSize)
$InterCircle.name = 'InterCircle'
$InterCircle.Image= imgStreamer "D:\ATE\IT\Root\images\InterCircle.png"
#$StartCircle.Location = New-Object System.Drawing.Size(20,100) 
$InterCircle.Appearance = 1
$InterCircle.FlatStyle = 2
#$StartCircle.width = 80
#$StartCircle.height = 80
#$StartCircle.AutoSize = $true
#$StartCircle.Padding = 5
$InterCircle.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $InterCircle
})



$Dimond = New-Object CheckBox
$Dimond.Size = New-Object Size($ShapesSize,$ShapesSize)
$Dimond.name = 'Dimond'
$Dimond.Image = imgStreamer "D:\ATE\IT\Root\images\VDimond.png"
$Dimond.ImageAlign = 'MiddleCenter'
#$Dimond.Location = New-Object System.Drawing.Size(20,200) 
$Dimond.Appearance = 1
$Dimond.FlatStyle = 2
$Dimond.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Dimond
})
$Dimond.Padding = 5


$Square = New-Object CheckBox
$Square.Size = New-Object Size($ShapesSize,$ShapesSize)
$Square.name = 'Square'
$Square.Image = imgStreamer "D:\ATE\IT\Root\images\VSquare.png"
$Square.ImageAlign = 'MiddleCenter'
$Square.Appearance = 1
$Square.FlatStyle = 2
$Square.Padding = 5
$Square.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Square
})

$DataObj = New-Object CheckBox
$DataObj.Size = New-Object Size($ShapesSize,$ShapesSize)
$DataObj.name = 'DataObject'
$DataObj.Image = imgStreamer "D:\ATE\IT\Root\images\DataObj.png"
$DataObj.ImageAlign = 'MiddleCenter'
$DataObj.Appearance = 1
$DataObj.FlatStyle = 2
$DataObj.Padding = 5
$DataObj.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $DataObj
})

$MainTbl = New-Object TableLayoutPanel
#$MainTbl.Location = New-Object System.Drawing.Size(2,50) 
$MainTbl.AutoSize = $true
$MainTbl.CellBorderStyle = 1
#$MainTbl.BackColor = "#d2d4d6"
$MainTbl.ColumnCount = 2
$MainTbl.RowCount = 5

$butsTbl =  New-Object TableLayoutPanel
$butsTbl.BackColor = ''
$butsTbl.Controls.Add($ShowPRFbtn)
$butsTbl.Controls.Add($DelShape)
$butsTbl.AutoSize = $true


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

$SaveBtn = New-Object Button
$SaveBtn.Location = New-Object Size(2,50) 
$SaveBtn.name = "Save"
$SaveBtn.BackColor = "#d2d4d6"
$SaveBtn.text = "ذخیره"
$SaveBtn.width = 80
$SaveBtn.height = 30
$SaveBtn.Font = 'Microsoft Sans Serif,10'
$SaveBtn.ForeColor = "#000"
$SaveBtn.TabIndex = 1
$SaveBtn.Add_Click({
    funSaveBtn
})

$SaveAsBtn = New-Object Button
$SaveAsBtn.Location = New-Object Size(2,50) 
$SaveAsBtn.name = "Saveas"
$SaveAsBtn.BackColor = "#d2d4d6"
$SaveAsBtn.text = "ذخیره با نام"
$SaveAsBtn.width = 80
$SaveAsBtn.height = 30
$SaveAsBtn.Font = 'Microsoft Sans Serif,10'
$SaveAsBtn.ForeColor = "#000"
$SaveAsBtn.TabIndex = 1
$SaveAsBtn.Add_Click({
    funSaveAsBtn
})

$LoadBtn = New-Object Button

$LoadBtn.Location = New-Object Size(2,50) 
$LoadBtn.name = "Load"
$LoadBtn.BackColor = "#d2d4d6"
$LoadBtn.text = "بارگذاری"
$LoadBtn.width = 80
$LoadBtn.height = 30
$LoadBtn.Font = 'Microsoft Sans Serif,10'
$LoadBtn.ForeColor = "#000"
$LoadBtn.TabIndex = 1
$LoadBtn.Add_Click({
    funLoadBtn
 })

$UndoBtn = New-Object Button
$UndoBtn.Location = New-Object Size(2,50) 
$UndoBtn.name = "Undo"
$UndoBtn.BackColor = "#d2d4d6"
$UndoBtn.text = ""
$UndoBtn.width = 30
$UndoBtn.image = imgStreamer "D:\ATE\IT\Root\images\Undo.png"
$UndoBtn.height = 30
$UndoBtn.Font = 'Microsoft Sans Serif,10'
$UndoBtn.ForeColor = "#000"
$UndoBtn.TabIndex = 1
$UndoBtn.Add_Click({
 })


$RedoBtn = New-Object Button
$RedoBtn.Location = New-Object Size(2,50) 
$RedoBtn.name = "redo"
$RedoBtn.BackColor = "#d2d4d6"
$RedoBtn.text = ""
$RedoBtn.width = 30
$RedoBtn.image = imgStreamer "D:\ATE\IT\Root\images\redo.png"
$RedoBtn.height = 30
$RedoBtn.Font = 'Microsoft Sans Serif,10'
$RedoBtn.ForeColor = "#000"
$RedoBtn.TabIndex = 1
$RedoBtn.Add_Click({
 })



$namelbl = New-Object Label
$namelbl.Text = ""
$namelbl.height = 30
$namelbl.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 12)
$namelbl.TextAlign = 256

$Filenamelbl = New-Object Label
$Filenamelbl.Text = ":نام فایل"
$Filenamelbl.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 12)
$Filenamelbl.height = 30
$Filenamelbl.width = 50
$Filenamelbl.TextAlign = 512

$ShapesTbl = New-Object TableLayoutPanel
$ShapesTbl.BackColor = ''
#$ShapesTbl.Size = New-Object System.Drawing.Size(100,700)
#$ShapesTbl.Location = New-Object System.Drawing.size(2,100)
#$DesktopPan.Dock = [System.Windows.Forms.DockStyle]::Fill
$ShapesTbl.AutoSize = $true
$ShapesTbl.ColumnCount = 2
#$ShapesTbl.CellBorderStyle = 2


$SubIconTbl = New-Object TableLayoutPanel
$SubIconTbl.BackColor = ''
#$SubIconTbl.Size = New-Object System.Drawing.Size(100,700)
#$SubIconTbl.Location = New-Object System.Drawing.size(2,100)
#$SubIconTbl.Dock = [System.Windows.Forms.DockStyle]::Fill
$SubIconTbl.AutoSize = $true
$SubIconTbl.ColumnCount = 3
#$SubIconTbl.CellBorderStyle = 2


$LaunchTbl = New-Object TableLayoutPanel
$LaunchTbl.BackColor = ''
#$LaunchTbl.Size = New-Object System.Drawing.Size(100,700)
#$LaunchTbl.Location = New-Object System.Drawing.size(2,100)
#$LaunchTbl.Dock = [System.Windows.Forms.DockStyle]::Fill
$LaunchTbl.AutoSize = $true
$LaunchTbl.ColumnCount = 3
#$LaunchTbl.CellBorderStyle = 2

$MagnifierTbl = New-Object TableLayoutPanel
$MagnifierTbl.BackColor = ''
#$MagnifierTbl.Size = New-Object System.Drawing.Size(100,700)
#$MagnifierTbl.Location = New-Object System.Drawing.size(2,100)
#$MagnifierTbl.Dock = [System.Windows.Forms.DockStyle]::Fill
$MagnifierTbl.AutoSize = $true
$MagnifierTbl.ColumnCount = 3
#$LaunchTbl.CellBorderStyle = 2


$LinesTbl = New-Object TableLayoutPanel
$LinesTbl.BackColor = ''
#$SubIconTbl.Size = New-Object System.Drawing.Size(100,700)
#$SubIconTbl.Location = New-Object System.Drawing.size(2,100)
#$SubIconTbl.Dock = [System.Windows.Forms.DockStyle]::Fill
$LinesTbl.AutoSize = $true
$LinesTbl.ColumnCount = 1
#$SubIconTbl.CellBorderStyle = 2

$TopMenuTbl =  New-Object TableLayoutPanel
$TopMenuTbl.BackColor = ''
#$TopMenuTbl.Controls.Add($ReturnBtn)
$TopMenuTbl.RowCount = 1
$TopMenuTbl.ColumnCount = 7
$TopMenuTbl.AutoSize = $true
$TopMenuTbl.CellBorderStyle = 1
#$TopMenuTbl.Height = 30

#$ShapesTbl.Controls.Add($butsPanel)
<#
$ShapesTbl.Controls.Add($StartCircle,0,0)
$ShapesTbl.Controls.Add($InterCircle,0,0)
$ShapesTbl.Controls.Add($Dimond,0,1)
$ShapesTbl.Controls.Add($Square,1,0)
$ShapesTbl.Controls.Add($DataObj,1,0)
#>


$TopMenuTbl.Controls.Add($namelbl)
$TopMenuTbl.Controls.Add($Filenamelbl)
$TopMenuTbl.Controls.Add($SaveBtn)
$TopMenuTbl.Controls.Add($SaveAsBtn)
$TopMenuTbl.Controls.Add($LoadBtn)
$TopMenuTbl.Controls.Add($UndoBtn)
$TopMenuTbl.Controls.Add($RedoBtn)

$ShapesTbl.Controls.Add($StartCircle)
$ShapesTbl.Controls.Add($InterCircle)
$ShapesTbl.Controls.Add($Dimond)
$ShapesTbl.Controls.Add($Square)
$ShapesTbl.Controls.Add($DataObj)


#$DesktopPan.Controls.Add()

$SubIconTbl.Controls.Add($MessSubIcon)
$SubIconTbl.Controls.Add($DarkMessSubIcon)
$SubIconTbl.Controls.Add($GearSubIcon)
$SubIconTbl.Controls.Add($ClockSubIcon)
$SubIconTbl.Controls.Add($CrossSubIcon)
$SubIconTbl.Controls.Add($TextIcon)
#$SubIconTbl.Controls.Add($SinStartSubIcon)
#$SubIconTbl.Controls.Add($ConSubIcon)
#$SubIconTbl.Controls.Add($SigEndSubIcon)
#$SubIconTbl.Controls.Add($ErrEndSubIcon)
#$SubIconTbl.Controls.Add($ErrorSubIcon)
#$SubIconTbl.Controls.Add($EscaSubIcon)
#$SubIconTbl.Controls.Add($EscaEndSubIcon)
#$SubIconTbl.Controls.Add($ArrowSubIcon)
#$SubIconTbl.Controls.Add($FArrowSubIcon)
$SubIconTbl.Controls.Add($UserSubIcon)
$SubIconTbl.Controls.Add($PlusSubIcon)

$LinesTbl.Controls.Add($SolidLine)
$LinesTbl.Controls.Add($DashedLine)
$LinesTbl.Controls.Add($DottedLine)

$LaunchTbl.Controls.Add($Play)
$LaunchTbl.Controls.Add($Record)
$LaunchTbl.Controls.Add($Stop)

$MagnifierTbl.Controls.Add($ZoomOut)
$MagnifierTbl.Controls.Add($Magnifier)
$MagnifierTbl.Controls.Add($ZoomIn)

$MainTbl.Controls.Add($ReturnBtn,0,0)
$MainTbl.Controls.Add($ReturnBtn,0,0)
$MainTbl.Controls.Add($TopMenuTbl,1,0)
$MainTbl.Controls.Add($DesktopPan,1,1)
$MainTbl.Controls.Add($ShapesTbl,0,1)
$MainTbl.Controls.Add($SubIconTbl,0,2)
$MainTbl.Controls.Add($LinesTbl,0,3)
$MainTbl.Controls.Add($butsTbl,0,4)
$MainTbl.Controls.Add($LaunchTbl,0,5)
$MainTbl.Controls.Add($MagnifierTbl,0,6)
$MainTbl.SetRowSpan($DesktopPan,7)


$Secoform.Controls.Add($MainTbl)
$Secoform.Add_Shown({$Secoform.Activate(); $DesktopPan.Focus()})

$Secoform.KeyPreview = $true
$Secoform.Add_KeyDown({funFormKeyDown})


$Secoform.Add_Closing{
   $Global:objShapePoint = $null
   $Global:objShape = $null
}
$Secoform.Add_Load{
    Set-DoubleBuffer -grid $DesktopPan -Enabled $true
    $DelShape.Focus()
    
}

[void]$Secoform.ShowDialog()   # display the dialog