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

$MainObject = [pscustomobject]@{
                arrRegions = [ArrayList]@()
                arrGroups = [ArrayList]@()
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
    }
    Else
    {
       
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
    If ($MainObject.arrRegions.Count -gt 0 -and $global:objShape -ne $null)
    {
        $MainObject.arrRegions.Remove($global:objShape)
        $Global:objShape = $null       
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

Function funAddGroups($point, $intIterate, $name){

          
   
}

Function funDPanMouseDown{
    $Global:bolMouseDown = $true
    $BolCont = $false
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
        If(!$BolCont)
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
                    If(
                        $arrGroItem.TopPath.isVisible($point) -or
                        $arrGroItem.RightPath.isVisible($point) -or
                        $arrGroItem.BottomPath.isVisible($point) -or
                        $arrGroItem.LeftPath.isVisible($point) -or
                        $arrGroItem.TAreaPath.isVisible($point)
                      )
                    {
                        $Global:objGroup = $arrGroItem
                    }
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
    $e.Graphics.SmoothingMode = 4
    $mouse = [Cursor]::Position
    $point = $DesktopPan.PointToClient($mouse)
    $strSwitch = ""
#    If ($StartCircle.Checked -or $Dimond.Checked -or $Square.Checked -Or $InterCircle.Checked -Or $DataObject.Checked)
    If($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked})
    {
        $strSwitch = ($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name
    }
    If($GroupsTbl.Controls | Where-Object -FilterScript {$_.Checked})
    {
        $strSwitch = ($GroupsTbl.Controls | Where-Object -FilterScript {$_.Checked}).name
    }
    If($Global:SelText -eq $Null -and $Global:SelPath -eq $null)
    {
        If($Global:bolMouseMove -And $Global:bolMouseDown -And $global:objShape -ne $null)
        {
            $strSwitch = $global:objShape.type  
        }
    }
    Else
    {
        If($TextIcon.Checked -and $Global:bolMouseDown -and $Global:SelText -ne $Null)
        {
            $Global:SelText.pTXDiffer = $Global:SelText.pCenter.x - $point.x
            $Global:SelText.pTYDiffer = $Global:SelText.pCenter.Y - $point.Y
        }
            ElseIf($TextIcon.Checked -and $Global:bolMouseDown -and $Global:SelPath -ne $Null)
            {            
                $Global:SelPath.pTXDiffer = $Global:SelPath.pCenter.X - $point.X
                $Global:SelPath.pTYDiffer = $Global:SelPath.pCenter.Y - $point.Y
            }

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
    $TopPath = New-Object Drawing2D.GraphicsPath
    $RightPath = New-Object Drawing2D.GraphicsPath
    $BottomPath = New-Object Drawing2D.GraphicsPath
    $LeftPath = New-Object Drawing2D.GraphicsPath
    $TAreaPAth = New-Object Drawing2D.GraphicsPath
    switch ($strSwitch)
    {
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
            $point.X = $point.X - ($PoolSize / $intDevideBy2)
            $point.Y = $point.Y - ($PoolSize / $intDevideBy2)
            $sizeDevidedBy2 = $PoolTAreaSize / $intDevideBy2  
            $PoolTAreaSizeDevidedBy2 = $PoolTAreaSize / $intDevideBy2            
            $pTop1 = New-Object Point $point.X , $point.Y
            $pTop2 = New-Object Point ($point.X + $PoolTAreaSize) , $point.Y
            $pTop3 = New-Object Point ($point.X + $PoolSize) , $point.Y
            $pBottom1 = New-Object Point $point.X , ($point.Y +$PoolSize)
            $pBottom2 = New-Object Point ($point.X + $PoolTAreaSize), ($point.Y + $PoolSize)
            $pBottom3 = New-Object Point ($point.X + $PoolSize), ($point.Y + $PoolSize)
            $pText = New-Object Point ($point.X + $PoolTAreaSizeDevidedBy2) , ($point.Y + $sizeDevidedBy2)                          
            $TopPath.AddLine($pTop1,$pTop3)   
            $RightPath.AddLine($pTop3,$pBottom3)               
            $BottomPath.AddLine($pBottom1,$pBottom3) 
            $LeftPath.AddLine($pBottom1,$pTop1)     
            $TAreaPAth.AddLine($pBottom2,$pTop2) 
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
            Else
            {
                 $objGroup = [pscustomobject]@{
     
       
                    Name = "$name$Global:intIterate"
                    Point = $point
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
                    Text = ""
                    PointPen = $RegPen
                    MainPen = $GroupPen
                }
                $MainObject.arrGroups.Add($objGroup)
                funDisAllShapes $null
                $global:objGroup = $objGroup   
            }
        }
        Else
        {
            If($strSwitch -eq ($ShapesTbl.Controls | Where-Object -FilterScript {$_.Name -match $strSwitch}).Name)
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
            Else
            {
                
            }
        }
    }
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
                        $e.Graphics.DrawImage($SubProcess.Image,$arrItem.pLeft.x + ($SubProcess.Width/$intDevideBy2), $arrItem.pCenter.y - $SubProcess.Height + $arcSize)
                    }
                    If($arrItem.Icon -ne "")
                    {
                        $TempObj = Get-Variable -ValueOnly -Include $arrItem.Icon
                        $e.Graphics.DrawImage($TempObj.Image,($arrItem.pCenter.x - $SquareSize) + $TempObj.Width, ($arrItem.pCenter.y - $squareSizeY) + $arcSize)
                    }
                }
                Else
                {
                    If($arrItem.Type -eq $Dimond.Name)
                    {
                        $TempObj = Get-Variable -ValueOnly -Include $arrItem.Icon
                        $e.Graphics.DrawImage($TempObj.Image,$arrItem.pTop.x - $DimondSize , $arrItem.pLeft.y - $DimondSize)
                    }
                        ElseIf($arrItem.Type -eq $StartCircle.Name -Or $arrItem.Type -eq $InterCircle.Name)
                        {
                            $TempObj = Get-Variable -ValueOnly -Include $arrItem.Icon
                            $e.Graphics.DrawImage($TempObj.Image,($arrItem.pTop.x - $StartCircleSize) - $arcSize,( $arrItem.pCenter.y - $StartCircleSize)-$arcSize)
                        }
                    Else
                    {
                        $TempObj = Get-Variable -ValueOnly -Include $arrItem.Icon
                        $e.Graphics.DrawImage($TempObj.Image,($arrItem.pTop.x - $DataObjSize) ,( $arrItem.pCenter.y - $DataObjSizeX))    
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
            If($arrGroItem.TopPath.isVisible($DesktopPan.PointToClient([Cursor]::Position)))
            {
                
            }
            Else
            {
                $e.Graphics.DrawPath($arrGroItem.MainPen, $arrGroItem.TopPath)
                $e.Graphics.DrawPath($arrGroItem.MainPen, $arrGroItem.RightPath)
                $e.Graphics.DrawPath($arrGroItem.MainPen, $arrGroItem.BottomPath)
                $e.Graphics.DrawPath($arrGroItem.MainPen, $arrGroItem.LeftPath)
                $e.Graphics.DrawPath($TextPen, $arrGroItem.TAreaPath)
#                $PathGraBrush = New-Object Drawing2D.LinearGradientBrush ($arrGroItem.BottomPointGB,$arrGroItem.TopPointGB,$arrItem.fillColor,[color]::White)
#                $e.Graphics.FillPath($PathGraBrush,$arrGroItem.MainPath)
            }

        }
    }                
}

Function funDPanMouseUp{
    $Global:bolMouseMove = $false
    $Global:bolMouseDown = $false
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
}

Function funDPanMouseMove{
    If(
        ($Global:bolMouseDown) -and 
        ($global:objShape -ne $null -or $Global:SelPath -ne $Null) -and 
        !$SolidLine.Checked -and !$DashedLine.Checked -and !$dottedline.Checked
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
        $MainObject | Export-Clixml "$($dialog.FileName).ate" -Depth 1
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
            $MainObject | Export-Clixml "$($dialog.FileName).ate" -Depth 1
            $namelbl.Text = (Get-Item "$($dialog.FileName).ate").Name
        }
    }
    Else
    {
        $MainObject | Export-Clixml $Global:strFileName -Depth 1
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
} 

#-----------------------------EndOfFunction
$LinesTbl = New-Object TableLayoutPanel
$LinesTbl.BackColor = ''
$LinesTbl.Name = "LinesTbl"
#$SubIconTbl.Size = New-Object System.Drawing.Size(100,700)
#$SubIconTbl.Location = New-Object System.Drawing.size(2,100)
#$SubIconTbl.Dock = [System.Windows.Forms.DockStyle]::Fill
$LinesTbl.AutoSize = $true
$LinesTbl.ColumnCount = 1
#$SubIconTbl.CellBorderStyle = 2
Write-Host $ChkBoxes
    If (Test-Path $ChkBoxes )
    {
        #$depcode = $_.Name
        $ScriptCSV = Import-Csv $ChkBoxes
        # $DepCodeFol = $_.Name
        $ScriptCSV | % {  
            #$ScriptName = $_.Name                     
            New-Variable -Force -Name $_.chkBoxName -Value (New-Object $_.obj)
            $thisCheckBox = Get-Variable -ValueOnly -Include $_.chkBoxName
            #$thisButton.Anchor = 'right'
            $thisCheckBox.Name = $_.chkBoxName
            # $thisButton.Location = New-Object System.Drawing.Size(175,(35+26*$test))
            $thisCheckBox.Size = New-Object System.Drawing.Size($_.sizeX,$_.sizeY)
#           $thisCheckBox.Padding = $_.Padding
#           $thisCheckBox.Margin = $_.Margin
            $thisCheckBox.Tag = $_.Tag
            $thisCheckBox.Image = funImgStreamer "$imgFol\$($_.ImageName)$imgFileExt"
            $thisCheckBox.ImageAlign = $_.ImageAlign
            $thisCheckBox.Appearance = $_.Appearance
            $thisCheckBox.FlatStyle = $_.FlatStyle
            $thisCheckBox.Add_Click({
                If(!$This.Checked){$DesktopPan.Focus()}
                funDisAllShapes  $thisCheckBox 
            })  
            $Thistbl = Get-Variable -ValueOnly -Include $_.TableName
            $Thistbl.controls.add($thisCheckBox)               
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

$ShowPRFbtn = New-Object Button
#$ShowPRFbtn.Location = New-Object System.Drawing.Size(1000,38) 
$ShowPRFbtn.BackColor = "#d2d4d6"
$ShowPRFbtn.text = "پاک کردن همه شکلها"
$ShowPRFbtn.width = 110
$ShowPRFbtn.height = 30
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
$DelShape.height = 30
$DelShape.Font = 'Microsoft Sans Serif,10'
$DelShape.ForeColor = "#000"
$DelShape.TabIndex = 1

$DelShape.Add_Click({
    funDisAllShapes $ShapesTbl
    funDelShape       
})

<#
$SolidLine = New-Object System.Windows.Forms.CheckBox
$SolidLine.Size = New-Object Size(100,25)
$SolidLine.name = 'SolidLine'
$SolidLine.Tag = 0
$SolidLine.Image = funImgStreamer "D:\ATE\IT\Root\images\SolidLine.png"
$SolidLine.Appearance = 1
$SolidLine.FlatStyle = 2
$SolidLine.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $SolidLine
})
#>
<#
$DashedLine = New-Object CheckBox
$DashedLine.Size = New-Object Size(100,25)
$DashedLine.Tag = 1
$DashedLine.name = 'DashedLine'
$DashedLine.Image = funImgStreamer "D:\ATE\IT\Root\images\DashedLine.png"
$DashedLine.Appearance = 1
$DashedLine.FlatStyle = 2
$DashedLine.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $DashedLine
})
#>

<#$DottedLine = New-Object CheckBox
$DottedLine.Size = New-Object Size(100,25)
$DottedLine.Tag = 2
$DottedLine.name = 'DottedLine'
$DottedLine.Image = funImgStreamer "D:\ATE\IT\Root\images\DottedLine.png"
$DottedLine.Appearance = 1
$DottedLine.FlatStyle = 2
$DottedLine.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $DottedLine
})
#>
$MessSubIcon = New-Object CheckBox
$MessSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$MessSubIcon.name = 'MessSubIcon'
$MessSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\LightMess.png"
$MessSubIcon.Appearance = 1
$MessSubIcon.FlatStyle = 2
$MessSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $MessSubIcon
})

$DarkMessSubIcon = New-Object CheckBox
$DarkMessSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$DarkMessSubIcon.name = 'DarkMessSubIcon'
$DarkMessSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\DarkMess.png"
$DarkMessSubIcon.Appearance = 1
$DarkMessSubIcon.FlatStyle = 2
$DarkMessSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $DarkMessSubIcon
})

$GearSubIcon = New-Object CheckBox
$GearSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$GearSubIcon.name = 'GearSubIcon'
$GearSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\Gear.png"
$GearSubIcon.Appearance = 1
$GearSubIcon.FlatStyle = 2
$GearSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $GearSubIcon
})


$ClockSubIcon = New-Object CheckBox
$ClockSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$ClockSubIcon.name = 'ClockSubIcon'
$ClockSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\Clock.png"
$ClockSubIcon.Appearance = 1
$ClockSubIcon.FlatStyle = 2
$ClockSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ClockSubIcon
})

$InnerCircle = New-Object CheckBox
$InnerCircle.Size = New-Object Size($subIconButSize,$subIconButSize)
$InnerCircle.name = 'InnerCircle'
$InnerCircle.Image = funImgStreamer "D:\ATE\IT\Root\images\InnerCircle.png"
$InnerCircle.Appearance = 1
$InnerCircle.FlatStyle = 2
$InnerCircle.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $InnerCircle
})

$CrossSubIcon = New-Object CheckBox
$CrossSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$CrossSubIcon.name = 'CrossSubIcon'
$CrossSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\Cross.png"
$CrossSubIcon.Appearance = 1
$CrossSubIcon.FlatStyle = 2
$CrossSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $CrossSubIcon
})


$SinStartSubIcon = New-Object CheckBox
$SinStartSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$SinStartSubIcon.name = 'SinStartSubIcon'
$SinStartSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\SigStart.png"
$SinStartSubIcon.Appearance = 1
$SinStartSubIcon.FlatStyle = 2
$SinStartSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $SinStartSubIcon
})

$ConSubIcon = New-Object CheckBox
$ConSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$ConSubIcon.name = 'ConSubIcon'
$ConSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\Condition.png"
$ConSubIcon.Appearance = 1
$ConSubIcon.FlatStyle = 2
$ConSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ConSubIcon
})

$SigEndSubIcon = New-Object CheckBox
$SigEndSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$SigEndSubIcon.name = 'SigEndSubIcon'
$SigEndSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\SigEnd.png"
$SigEndSubIcon.Appearance = 1
$SigEndSubIcon.FlatStyle = 2
$SigEndSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $SigEndSubIcon
})

$ErrEndSubIcon = New-Object CheckBox
$ErrEndSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$ErrEndSubIcon.name = 'ErrEndSubIcon'
$ErrEndSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\ErrEnd.png"
$ErrEndSubIcon.Appearance = 1
$ErrEndSubIcon.FlatStyle = 2
$ErrEndSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ErrEndSubIcon
})

$ErrorSubIcon = New-Object CheckBox
$ErrorSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$ErrorSubIcon.name = 'ErrorSubIcon'
$ErrorSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\Error.png"
$ErrorSubIcon.Appearance = 1
$ErrorSubIcon.FlatStyle = 2
$ErrorSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ErrorSubIcon
})


$EscaSubIcon = New-Object CheckBox
$EscaSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$EscaSubIcon.name = 'EscaSubIcon'
$EscaSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\Escalation.png"
$EscaSubIcon.Appearance = 1
$EscaSubIcon.FlatStyle = 2
$EscaSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $EscaSubIcon
})

$EscaEndSubIcon = New-Object CheckBox
$EscaEndSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$EscaEndSubIcon.name = 'EscaEndSubIcon'
$EscaEndSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\EscalEnd.png"
$EscaEndSubIcon.Appearance = 1
$EscaEndSubIcon.FlatStyle = 2
$EscaEndSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $EscaEndSubIcon
})

$TextIcon = New-Object CheckBox
$TextIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$TextIcon.name = 'TextIcon'
$TextIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\T.png"
$TextIcon.Appearance = 1
$TextIcon.FlatStyle = 2
$TextIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $TextIcon
    funTextIconClick
})

$ArrowSubIcon = New-Object CheckBox
$ArrowSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$ArrowSubIcon.name = 'ArrowSubIcon'
$ArrowSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\Arrow.png"
$ArrowSubIcon.Appearance = 1
$ArrowSubIcon.FlatStyle = 2
$ArrowSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ArrowSubIcon
})


$FArrowSubIcon = New-Object CheckBox
$FArrowSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$FArrowSubIcon.name = 'FArrowSubIcon'
$FArrowSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\FArrow.png"
$FArrowSubIcon.Appearance = 1
$FArrowSubIcon.FlatStyle = 2
$FArrowSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $FArrowSubIcon
})

$UserSubIcon = New-Object CheckBox
$UserSubIcon.Size = New-Object Size($subIconButSize,$subIconButSize)
$UserSubIcon.name = 'UserSubIcon'
$UserSubIcon.Image = funImgStreamer "D:\ATE\IT\Root\images\User.png"
$UserSubIcon.Appearance = 1
$UserSubIcon.FlatStyle = 2
$UserSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $UserSubIcon
})

$SubProcess = New-Object CheckBox
$SubProcess.Size = New-Object Size($subIconButSize,$subIconButSize)
$SubProcess.name = 'SubProcess'
$SubProcess.Image = funImgStreamer "D:\ATE\IT\Root\images\Plus.png"
$SubProcess.Appearance = 1
$SubProcess.FlatStyle = 2
$SubProcess.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $SubProcess
})

$Play = New-Object CheckBox
$Play.Size = New-Object Size($subIconButSize,$subIconButSize)
$Play.name = 'Play'
$Play.Image = funImgStreamer "D:\ATE\IT\Root\images\Play.png"
$Play.Appearance = 1
$Play.FlatStyle = 2
$Play.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Play
})

$Record = New-Object CheckBox
$Record.Size = New-Object Size($subIconButSize,$subIconButSize)
$Record.name = 'Record'
$Record.Image = funImgStreamer "D:\ATE\IT\Root\images\Record.png"
$Record.Appearance = 1
$Record.FlatStyle = 2
$Record.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Record
})

$Stop = New-Object CheckBox
$Stop.Size = New-Object Size($subIconButSize,$subIconButSize)
$Stop.name = 'Stop'
$Stop.Image = funImgStreamer "D:\ATE\IT\Root\images\Stop.png"
$Stop.Appearance = 1
$Stop.FlatStyle = 2
$Stop.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Stop
})

$ZoomOut = New-Object CheckBox
$ZoomOut.Size = New-Object Size($subIconButSize,$subIconButSize)
$ZoomOut.name = 'ZoomOut'
$ZoomOut.Image = funImgStreamer "D:\ATE\IT\Root\images\ZoomOut.png"
$ZoomOut.Appearance = 1
$ZoomOut.FlatStyle = 2
$ZoomOut.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ZoomOut
    $this.Checked = $false
})

$Magnifier = New-Object CheckBox
$Magnifier.Size = New-Object Size($subIconButSize,$subIconButSize)
$Magnifier.name = 'Magnifier'
$Magnifier.Image = funImgStreamer "D:\ATE\IT\Root\images\Magnifier.png"
$Magnifier.Appearance = 1
$Magnifier.FlatStyle = 2
$Magnifier.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Magnifier
    $this.Checked = $false
})

$ZoomIn = New-Object CheckBox
$ZoomIn.Size = New-Object Size($subIconButSize,$subIconButSize)
$ZoomIn.name = 'ZoomIn'
$ZoomIn.Image = funImgStreamer "D:\ATE\IT\Root\images\ZoomIn.png"
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
$StartCircle.Image = funImgStreamer "D:\ATE\IT\Root\images\StartCircle.png"
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
$InterCircle.Image= funImgStreamer "D:\ATE\IT\Root\images\InterCircle.png"
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
$Dimond.Image = funImgStreamer "D:\ATE\IT\Root\images\VDimond.png"
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
$Square.Image = funImgStreamer "D:\ATE\IT\Root\images\VSquare.png"
$Square.ImageAlign = 'MiddleCenter'
$Square.Appearance = 1
$Square.FlatStyle = 2
$Square.Padding = 5
$Square.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Square
})

$DataObject = New-Object CheckBox
$DataObject.Size = New-Object Size($ShapesSize,$ShapesSize)
$DataObject.name = 'DataObject'
$DataObject.Image = funImgStreamer "D:\ATE\IT\Root\images\DataObj.png"
$DataObject.ImageAlign = 'MiddleCenter'
$DataObject.Appearance = 1
$DataObject.FlatStyle = 2
$DataObject.Padding = 5
$DataObject.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $DataObject
})

$Pool = New-Object CheckBox
$Pool.Size = New-Object Size($GroupSizeX,$GroupSizeY)
$Pool.name = 'Pool'
$Pool.Image = funImgStreamer "D:\ATE\IT\Root\images\Pool.png"
$Pool.ImageAlign = 'MiddleCenter'
$Pool.Appearance = 1
$Pool.FlatStyle = 2
$Pool.Padding = 5
$Pool.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Pool
})

$Lane = New-Object CheckBox
$Lane.Size = New-Object Size($GroupSizeX,$GroupSizeY)
$Lane.name = 'Lane'
$Lane.Image = funImgStreamer "D:\ATE\IT\Root\images\Lane.png"
$Lane.ImageAlign = 'MiddleCenter'
$Lane.Appearance = 1
$Lane.FlatStyle = 2
$Lane.Padding = 5
$Lane.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Lane
})

$Group = New-Object CheckBox
$Group.Size = New-Object Size($GroupSizeX,$GroupSizeY)
$Group.name = 'Group'
$Group.Image = funImgStreamer "D:\ATE\IT\Root\images\Group.png"
$Group.ImageAlign = 'MiddleCenter'
$Group.Appearance = 1
$Group.FlatStyle = 2
$Group.Padding = 5
$Group.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Group
})

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
#$MainTbl.Location = New-Object System.Drawing.Size(2,50) 
$MainTbl.AutoSize = $true
$MainTbl.CellBorderStyle = 1
#$MainTbl.BackColor = "#d2d4d6"
$MainTbl.ColumnCount = 2
$MainTbl.RowCount = 5

$butsTbl =  New-Object TableLayoutPanel
$butsTbl.BackColor = ''
#$butsTbl.Controls.Add($ShowPRFbtn)
#$butsTbl.Controls.Add($DelShape)
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

$NewBtn = New-Object Button
$NewBtn.Location = New-Object Size(2,50) 
$NewBtn.name = "New"
$NewBtn.BackColor = "#d2d4d6"
$NewBtn.text = "جدید"
$NewBtn.width = 80
$NewBtn.height = 30
$NewBtn.Font = 'Microsoft Sans Serif,10'
$NewBtn.ForeColor = "#000"
$NewBtn.TabIndex = 1
$NewBtn.Add_Click({
    funLoadBtn
 })

$UndoBtn = New-Object Button
$UndoBtn.Location = New-Object Size(2,50) 
$UndoBtn.name = "Undo"
$UndoBtn.BackColor = "#d2d4d6"
$UndoBtn.text = ""
$UndoBtn.width = 30
$UndoBtn.image = funImgStreamer "D:\ATE\IT\Root\images\Undo.png"
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
$RedoBtn.image = funImgStreamer "D:\ATE\IT\Root\images\redo.png"
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

$GroupsTbl = New-Object TableLayoutPanel
$GroupsTbl.BackColor = ''
#$MagnifierTbl.Size = New-Object System.Drawing.Size(100,700)
#$MagnifierTbl.Location = New-Object System.Drawing.size(2,100)
#$MagnifierTbl.Dock = [System.Windows.Forms.DockStyle]::Fill
$GroupsTbl.AutoSize = $true
$GroupsTbl.ColumnCount = 1
#$LaunchTbl.CellBorderStyle = 2



$TopMenuTbl =  New-Object TableLayoutPanel
$TopMenuTbl.BackColor = ''
#$TopMenuTbl.Controls.Add($ReturnBtn)
$TopMenuTbl.RowCount = 1
$TopMenuTbl.ColumnCount = 12
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


$ShapesTbl.Controls.Add($StartCircle)
$ShapesTbl.Controls.Add($InterCircle)
$ShapesTbl.Controls.Add($Dimond)
$ShapesTbl.Controls.Add($Square)
$ShapesTbl.Controls.Add($DataObject)


#$DesktopPan.Controls.Add()

$SubIconTbl.Controls.Add($MessSubIcon)
$SubIconTbl.Controls.Add($DarkMessSubIcon)
$SubIconTbl.Controls.Add($GearSubIcon)
$SubIconTbl.Controls.Add($ClockSubIcon)
$SubIconTbl.Controls.Add($CrossSubIcon)
$SubIconTbl.Controls.Add($TextIcon)
$SubIconTbl.Controls.Add($InnerCircle)

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
$SubIconTbl.Controls.Add($SubProcess)
<#
$LinesTbl.Controls.Add($SolidLine)
$LinesTbl.Controls.Add($DashedLine)
$LinesTbl.Controls.Add($DottedLine)
#>
$LaunchTbl.Controls.Add($Play)
$LaunchTbl.Controls.Add($Record)
$LaunchTbl.Controls.Add($Stop)

$MagnifierTbl.Controls.Add($ZoomOut)
$MagnifierTbl.Controls.Add($Magnifier)
$MagnifierTbl.Controls.Add($ZoomIn)

$GroupsTbl.Controls.Add($pool)
$GroupsTbl.Controls.Add($Lane)
$GroupsTbl.Controls.Add($Group)

$TopMenuTbl.Controls.Add($namelbl)
$TopMenuTbl.Controls.Add($Filenamelbl)
$TopMenuTbl.Controls.Add($NewBtn)
$TopMenuTbl.Controls.Add($SaveBtn)
$TopMenuTbl.Controls.Add($SaveAsBtn)
$TopMenuTbl.Controls.Add($LoadBtn)
$TopMenuTbl.Controls.Add($UndoBtn)
$TopMenuTbl.Controls.Add($RedoBtn)
$TopMenuTbl.Controls.Add($LaunchTbl)
$TopMenuTbl.Controls.Add($MagnifierTbl)
$TopMenuTbl.Controls.Add($ShowPRFbtn)
$TopMenuTbl.Controls.Add($DelShape)


$MainTbl.Controls.Add($ReturnBtn,0,0)
$MainTbl.Controls.Add($ReturnBtn,0,0)
$MainTbl.Controls.Add($TopMenuTbl,1,0)
$MainTbl.Controls.Add($DesktopPan,1,1)
$MainTbl.Controls.Add($ShapesTbl,0,1)
$MainTbl.Controls.Add($SubIconTbl,0,2)
$MainTbl.Controls.Add($LinesTbl,0,3)
$MainTbl.Controls.Add($butsTbl,0,4)
$MainTbl.Controls.Add($GroupsTbl,0,5)
$MainTbl.Controls.Add($Annotation,0,6)
$MainTbl.SetRowSpan($DesktopPan,6)


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