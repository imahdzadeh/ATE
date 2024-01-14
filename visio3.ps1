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

$subIconButSize = 30
$ShapesSize = 50
$code = @"
[System.Runtime.InteropServices.DllImport("gdi32.dll")]
public static extern IntPtr CreateRoundRectRgn(int nLeftRect, int nTopRect,
    int nRightRect, int nBottomRect, int nWidthEllipse, int nHeightEllipse);
"@
$Win32Helpers = Add-Type -MemberDefinition $code -Name "Win32Helpers" -PassThru

Function funDelShape{
    If ($arrRegions.Count -gt 0 -and $global:objShape -ne $null)
    {
        $arrRegions.Remove($global:objShape)
        $Global:objShape = $null       
    }
    $DesktopPan.Invalidate()     
}

Function imgStreamer($imgPath){

    $inStream = ([FileInfo]$imgPath).Open([FileMode]::Open, [FileAccess]::ReadWrite)
    [Image]::FromStream($inStream)
    $inStream.Dispose()
}

$DesktopPan = New-Object Panel
#$DesktopPan.BackColor = 'green'
$DesktopPan.Location = New-Object Size(120,50)
$DesktopPan.Size = New-Object Size(1100,700)
$DesktopPan.Dock = [DockStyle]::Fill
#$DesktopPan.AutoSize = $true
$DesktopPan.name = "Main"
$DesktopPan.BorderStyle = 1


$DesktopPan.Add_KeyDown({
if ($_.KeyCode -eq [Keys]::Delete) {     
            funDelShape
        }
})

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
}

function Set-DoubleBuffer {
    param ([Parameter(Mandatory = $true)]
        [Panel]$grid,
        [boolean]$Enabled)  
    $type = $grid.GetType();
    $propInfo = $type.GetProperty("DoubleBuffered", ('Instance','NonPublic'))
    $propInfo.SetValue($grid, $Enabled)
}

$intIterate = 0
$bolMouseDown = $false
$objShape = $null

$arrRegions = [ArrayList]@()
# Create pen and brush objects 
$myBrush = new-object Drawing.SolidBrush black
$mypen = new-object Drawing.Pen black,2
$mypen2 = new-object Drawing.Pen gray, 4
$mypen3 = new-object Drawing.Pen black, 10
$mypen2.Color = [System.Drawing.Color]::FromArgb(180,180,180)
$bigarrow = New-Object Drawing2D.AdjustableArrowCap 5,5
#$mypen.color = "black" # Set the pen color
#$mypen.width = 4     # ste the pen line width

#$mypen2.color = "black" # Set the pen color
#$mypen2.width = 2     # ste the pen line width
#$mypen2.CustomEndCap = $bigarrow

$brushBg = [System.Drawing.Brushes]::gray
$brushBg.Color = [System.Drawing.Color]::FromArgb(200,200,200)

$ClearbrushBg = [System.Drawing.Brushes]::white

# Create a Rectangle object for use when drawing rectangle
$rect = new-object Drawing.Rectangle 10, 10, 180, 180

$avatar = [System.Drawing.Image]::Fromfile('D:\ate\IT\Root\images\circle.png')

$fonty = New-Object Font 'arial',16

# Create a Form
$form = New-Object Windows.Forms.Form

$form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
#$form.BackColor = [System.Drawing.Color]::FromArgb(220,220,220)
$form.Size = New-Object Drawing.Size 1300, 800
$form.AutoScroll = $true
# Get the form's graphics object


$arcSize = 10
$ShadowSize = 2
$squareSize = 150
$squareSizeY = 100
$DimondSize = 50
$StartCircleSize = 50
$InterCircleSize = 50
$DataObjSizeY = 50
$DataObjSizeX = 35

$DesktopPan.Add_paint({
    param([System.Object]$s, [PaintEventArgs]$e)
#    $e.Graphics.InterpolationMode = 2
    $e.Graphics.SmoothingMode = 4
    $mouse = [Cursor]::Position
    $point = $DesktopPan.PointToClient($mouse)
    $strSwitch = ""
 #   If($global:objShape -eq $null)
 #   {
    If ($StartCircle.Checked -or $Dimond.Checked -or $Square.Checked -Or $InterCircle.Checked -Or $DataObj.Checked)
    {
        $strSwitch = ($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name
    }
    If($Global:bolMouseMove -And $Global:bolMouseDown -And $global:objShape -ne $null)
    {
        $strSwitch = $global:objShape.type  
    }
    
    $Global:intIterate ++
    $point.X = $point.X - 50
    $point.Y = $point.Y - 50
    switch ($strSwitch)
    {
        'StartCircle' { 
            $point.X = $point.X + 25
            $point.Y = $point.Y + 25       
            $myPath = New-Object Drawing2D.GraphicsPath
            $myPath2 = New-Object Drawing2D.GraphicsPath
            $myPath.AddEllipse($point.X,$point.Y,$StartCircleSize,$StartCircleSize)
            $myPath2.AddEllipse(($point.X)-$ShadowSize,($point.Y)-$ShadowSize,$StartCircleSize+($ShadowSize*2),$StartCircleSize+($ShadowSize*2))
            $myregion2 = new-object Region  $myPath2
            
            If(($Global:bolMouseMove -eq $false) -or ($Global:bolMouseDown -eq $faslse) -or ($global:objShape -eq $null))
            {
                New-Variable -Force -Name "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate" -Value (new-object Region  $myPath) 
                $myregion = Get-Variable -ValueOnly -Include "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                $strMess = 'test'
                $objPSCircle = [pscustomobject]@{
                    name = "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                    type = 'StartCircle'
                    Location = $location
                    myregion = $myregion
                    myregion2 = $myregion2
                    P1 = New-Object Point ($point.X) , ($point.Y -10)
                    P2 = New-Object Point ($point.X) , (($point.Y + $StartCircleSize)+10)
                    myPath = $myPath
                    myPath2 = $myPath2
                    myPen1 = $mypen
                    fillColor = [color]::lightgreen
                    ConnObj = [ArrayList]@()
                    str = $strMess
                    ConnArr = [ArrayList]@()
                }
                [void]$arrRegions.Add($objPSCircle)
                funDisAllShapes $null
            }
            Else
            {
               $global:objShape.myPath = $myPath
               $global:objShape.myPath2 = $myPath2
               $global:objShape.myregion = new-object Region  $myPath
               $global:objShape.myregion2 = $myregion2
               $global:objShape.p1 = New-Object Point ($point.X) , ($point.Y -10)
               $global:objShape.p2 = New-Object Point ($point.X) , (($point.Y + $StartCircleSize)+10)              
            }
        }
        'InterCircle' {
            $point.X = $point.X + 25
            $point.Y = $point.Y + 25            
            $myPath = New-Object Drawing2D.GraphicsPath
            $myPath2 = New-Object Drawing2D.GraphicsPath
            $myPath.AddEllipse($point.X,$point.Y,$InterCircleSize-4,$InterCircleSize-4)                
            $myPath2.AddEllipse(($point.X)-($ShadowSize*2),($point.Y)-($ShadowSize*2),$InterCircleSize+($ShadowSize*2),$InterCircleSize+($ShadowSize*2))
            $myregion2 = new-object Region  $myPath2
            If(($Global:bolMouseMove -eq $false) -or ($Global:bolMouseDown -eq $faslse) -or ($global:objShape -eq $null))
            {
                New-Variable -Force -Name "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate" -Value (new-object Region  $myPath) 
                $myregion = Get-Variable -ValueOnly -Include "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                $strMess = 'test'
                $objPSInterCircle = [pscustomobject]@{
                    name = "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                    type = 'InterCircle'
                    Location = $location
                    myregion = $myregion
                    myregion2 = $myregion2
                    P1 = New-Object Point ($point.X) , ($point.Y -10)
                    P2 = New-Object Point ($point.X) , (($point.Y + $InterCircleSize)+10)
                    myPath = $myPath
                    myPath2 = $myPath2
                    myPen1 = $mypen3
                    fillColor = [color]::BurlyWood
                    str = $strMess
                    ConnArr = [ArrayList]@()
                }
                [void]$arrRegions.Add($objPSInterCircle) 
                funDisAllShapes $null
            }
            Else
            {
               $global:objShape.myPath = $myPath
               $global:objShape.myPath2 = $myPath2
               $global:objShape.myregion = new-object Region  $myPath
               $global:objShape.myregion2 = $myregion2
               $global:objShape.p1 = New-Object Point ($point.X) , ($point.Y -10)
               $global:objShape.p2 = New-Object Point ($point.X) , (($point.Y + $InterCircleSize)+10)                  
            }
<#                             
                If(($Global:bolMouseDown) -and ($global:objShape -ne $null))
                {
                $global:objShape = $objPSInterCircle
                }

#>
        }
        'dimond' {
            $point.X = $point.X + 25
            $point.Y = $point.Y + 25
            $pp1 = New-Object Point ($point.X) , ($point.Y+25)
            $pp2 = New-Object Point ($point.X+25 ), ($point.Y)
            $pp3 = New-Object Point ($point.X+$DimondSize ), ($point.Y+25)
            $pp4 = New-Object Point ($point.X+25 ), ($point.Y+$DimondSize)
            $points = @($pp1,$pp2,$pp3,$pp4)

            $sp1 = New-Object Point ($pp1.X-$ShadowSize) , ($pp1.Y)
            $sp2 = New-Object Point ($pp2.X ), ($pp2.Y-$ShadowSize)
            $sp3 = New-Object Point ($pp3.X+$ShadowSize) , ($pp3.Y)
            $sp4 = New-Object Point ($pp4.X ), ($pp4.Y+$ShadowSize)
            $points2 = @($sp1,$sp2,$sp3,$sp4)

                
               

            $myPath = New-Object Drawing2D.GraphicsPath
            $myPath2 = New-Object Drawing2D.GraphicsPath

            $myPath.AddArc($pp2.x,$pp2.Y,$arcSize,$arcSize,225,90)
            $myPath.AddArc($pp3.x,$pp3.Y,$arcSize,$arcSize,-45,90)
            $myPath.AddArc($pp4.x,$pp4.Y,$arcSize,$arcSize,45,90)
            $myPath.AddArc($pp1.x,$pp1.Y,$arcSize,$arcSize,135,90)
            $myPath.CloseAllFigures()
#                $myPath.AddPolygon($points)
#                $myPath2.AddPolygon($points2)
            $myPath2.AddArc($sp2.x,$sp2.Y,$arcSize,$arcSize,225,90)
            $myPath2.AddArc($sp3.x,$sp3.Y,$arcSize,$arcSize,-45,90)
            $myPath2.AddArc($sp4.x,$sp4.Y,$arcSize,$arcSize,45,90)
            $myPath2.AddArc($sp1.x,$sp1.Y,$arcSize,$arcSize,135,90)
            $myPath2.CloseAllFigures()

            $myregion2 = new-object Region $myPath2
            If(($Global:bolMouseMove -eq $false) -or ($Global:bolMouseDown -eq $faslse) -or ($global:objShape -eq $null))
            {
                New-Variable -Force -Name "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate" -Value (new-object Region  $myPath) 
                $myregion = Get-Variable -ValueOnly -Include "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                $objPSDimond = [pscustomobject]@{
                    name = "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                    type = 'Dimond'
                    Location = $location
                    myregion = $myregion
                    myregion2 = $myregion2
                    P1 = New-Object Point ($point.X) , ($point.Y -10)
                    P2 = New-Object Point ($point.X) , (($point.Y + $DimondSize)+10)
                    myPath = $myPath
                    myPath2 = $myPath2
                    myPen1 = $mypen
                    fillColor = [color]::FromArgb(216, 191, 216)
                    str = $strMess
                    ConnArr = [ArrayList]@()
                    }
                [void]$arrRegions.Add($objPSDimond)
                funDisAllShapes $null
<#                                  
                    If(($Global:bolMouseDown) -and ($global:objShape -ne $null))
                    {
                    $global:objShape = $objPSDimond
                    }
#>
                
            }
            Else
            {
                $global:objShape.myPath = $myPath
                $global:objShape.myPath2 = $myPath2
                $global:objShape.myregion = new-object Region  $myPath
                $global:objShape.myregion2 = $myregion2
                $global:objShape.p1 = New-Object Point ($point.X) , ($point.Y -10)
                $global:objShape.p2 = New-Object Point ($point.X) , (($point.Y + $DimondSize)+10)
            }              
        }
        'Square' {

            $pp1 = New-Object Point ($point.X) , ($point.Y)
            $pp2 = New-Object Point ($point.X+ $squareSize ), ($point.Y)
            $pp3 = New-Object Point ($point.X+ $squareSize) , ($point.Y+100)
            $pp4 = New-Object Point ($point.X ), ($point.Y+100)
#               $points = @($pp1,$pp2,$pp3,$pp4)
#               $pp2.x = 400
#                $pp2.Y  = 400
            $sp1 = New-Object Point ($pp1.X-$ShadowSize ), ($pp1.Y-$ShadowSize)
            $sp2 = New-Object Point ($pp2.X+$ShadowSize ), ($pp2.Y-$ShadowSize)
            $sp3 = New-Object Point ($pp3.X+$ShadowSize) , ($pp3.Y+$ShadowSize)
            $sp4 = New-Object Point ($pp4.X-$ShadowSize ), ($pp4.Y+$ShadowSize)
#               $points2 = @($sp1,$sp2,$sp3,$sp4)
#               $hrgn = $Win32Helpers::CreateRoundRectRgn($point.X-25,$point.Y+15,$point.X+125, $point.Y+85, 10,10)
            $myPath = New-Object Drawing2D.GraphicsPath
            $myPath2 = New-Object Drawing2D.GraphicsPath

            $arcSize = 10
            $myPath.AddArc($pp2.x,$pp2.Y,$arcSize,$arcSize,270,90)
            $myPath.AddArc($pp3.x,$pp3.y,$arcSize,$arcSize,0,90)
            $myPath.AddArc($pp4.x,$pp4.y,$arcSize,$arcSize,90,90)
            $myPath.AddArc($pp1.x,$pp1.Y,$arcSize,$arcSize,180,90)
            $myPath.CloseAllFigures()
                
            $myPath2.AddArc($sp2.x,$sp2.Y,$arcSize,$arcSize,270,90)
            $myPath2.AddArc($sp3.x,$sp3.y,$arcSize,$arcSize,0,90)
            $myPath2.AddArc($sp4.x,$sp4.y,$arcSize,$arcSize,90,90)
            $myPath2.AddArc($sp1.x,$sp1.Y,$arcSize,$arcSize,180,90)
            $myPath2.CloseAllFigures()

            $myregion2 = new-object Region $myPath2
            If(($Global:bolMouseMove -eq $false) -or ($Global:bolMouseDown -eq $faslse) -or ($global:objShape -eq $null))
            {
                New-Variable -Force -Name "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate" -Value (new-object Region  $myPath) 
    #                New-Variable -Force -Name "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate" -Value ([region]::FromHrgn($hrgn)) 
                $myregion = Get-Variable -ValueOnly -Include "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                $objPSSquare = [pscustomobject]@{
                    name = "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                    type = 'Square'
                    Location = $location
                    myregion = $myregion
                    myregion2 = $myregion2
                    P1 = New-Object Point ($point.X) , ($point.Y -$arcSize)
                    P2 = New-Object Point ($point.X) , (($point.Y + $squareSizeY)+$arcSize)
                    myPath = $myPath
                    myPath2 = $myPath2
                    myPen1 = $mypen
                    fillColor = [color]::lightblue
                    str = $strMess
                    ConnArr = [ArrayList]@()
                }
                [void]$arrRegions.Add($objPSSquare)
                funDisAllShapes $null  
            }
            Else
            {
                $global:objShape.myPath = $myPath
                $global:objShape.myPath2 = $myPath2
                $global:objShape.myregion = new-object Region  $myPath
                $global:objShape.myregion2 = $myregion2
                $global:objShape.p1 = New-Object Point ($point.X) , ($point.Y -$arcSize)
                $global:objShape.p2 = New-Object Point ($point.X) , (($point.Y + $squareSizeY)+$arcSize)           
            }
<#                           
            If(($Global:bolMouseDown) -and ($global:objShape -ne $null))
            {
                $global:objShape = $objPSSquare
            }
#>                        
        }
        'DataObject' {
            $point.X = $point.X + 25
            $point.Y = $point.Y + 25
            $pp1 = New-Object Point ($point.X) , ($point.Y)
            $pp2 = New-Object Point ($point.X +$DataObjSizeX), ($point.Y)
            $pp3 = New-Object Point (($point.X +$DataObjSizeX)+10) , ($point.Y+$DataObjSizeY)
            $pp4 = New-Object Point ($point.X ), ($point.Y + $DataObjSizeY)
            $pp5 = New-Object Point ($point.X +$DataObjSizeX), ($point.Y  +10)
            $pp6 = New-Object Point (($point.X +$DataObjSizeX) + 10), (($point.Y) + 10)

            $sp1 = New-Object Point ($point.X - $ShadowSize) , (($point.Y)-$ShadowSize)
            $sp2 = New-Object Point (($point.X +$DataObjSizeX)), ($point.Y -$ShadowSize)
            $sp3 = New-Object Point ((($point.X +$DataObjSizeX)+10)+$ShadowSize) , (($point.Y+$DataObjSizeY)+$ShadowSize)
            $sp4 = New-Object Point (($point.X)-$ShadowSize), (($point.Y + $DataObjSizeY)+$ShadowSize)
            $sp5 = New-Object Point (($point.X +$DataObjSizeX)-$ShadowSize), ($point.Y  +10)
            $sp6 = New-Object Point ((($point.X +$DataObjSizeX) + 10) + $ShadowSize), (($point.Y) + 10)

            $myPath = New-Object Drawing2D.GraphicsPath
            $myPath2 = New-Object Drawing2D.GraphicsPath       
                               
            $myPath.AddLine($pp2,$pp5)
            $myPath.AddLine($pp5,$pp6)
            $myPath.AddArc($pp3.x-10,$pp3.y-10,$arcSize,$arcSize,0,90)
            $myPath.AddArc($pp4.x+10,$pp4.y-10,$arcSize,$arcSize,90,90)
            $myPath.AddArc($pp1.x+10,$pp1.Y,$arcSize,$arcSize,180,90)
            $myPath.AddLine($pp2,$pp6)
                
            $myPath2.AddArc($sp3.x-10,$sp3.y-10,$arcSize,$arcSize,0,90)
            $myPath2.AddArc($sp4.x+10,$sp4.y-10,$arcSize,$arcSize,90,90)
            $myPath2.AddArc($sp1.x+10,$sp1.Y,$arcSize,$arcSize,180,90)
            $myPath2.AddLine($sp2,$sp6)
            $myPath2.CloseFigure()

            $myregion2 = new-object Region $myPath2
            If(($Global:bolMouseMove -eq $false) -or ($Global:bolMouseDown -eq $faslse) -or ($global:objShape -eq $null))
            {
                New-Variable -Force -Name "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate" -Value (new-object Region  $myPath) 
        #                New-Variable -Force -Name "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate" -Value ([region]::FromHrgn($hrgn)) 
                $myregion = Get-Variable -ValueOnly -Include "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                $objPSSquare = [pscustomobject]@{
                    name = "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                    type = 'DataObject'
                    Location = $location
                    myregion = $myregion
                    myregion2 = $myregion2
                    P1 = New-Object Point ($point.X) , ($point.Y - $DataObjSizeY)
                    P2 = New-Object Point ($point.X) , ($point.Y + $DataObjSizeY)
                    myPath = $myPath
                    myPath2 = $myPath2
                    myPen1 = $mypen
                    fillColor = [color]::FromArgb(211,211,211)
                    str = $strMess
                    ConnArr = [ArrayList]@()
                }
                [void]$arrRegions.Add($objPSSquare)
                funDisAllShapes $null
            }
            Else
            {
                $global:objShape.myPath = $myPath
                $global:objShape.myPath2 = $myPath2
                $global:objShape.myregion = new-object Region  $myPath
                $global:objShape.myregion2 = $myregion2
                $global:objShape.p1 = New-Object Point ($point.X) , ($point.Y - $DataObjSizeY)
                $global:objShape.p2 = New-Object Point ($point.X) , ($point.Y + $DataObjSizeY)                   
            }
<#                             
            If(($Global:bolMouseDown) -and ($global:objShape -ne $null))
            {
                $global:objShape = $objPSSquare
            }
#>
        }
    }
    If ($arrRegions.count -gt 0)
    {
        
         for($i = 0; $i -lt $arrRegions.Count; $i++)
        {
            $arrItem = $arrRegions[$i]           
            If ($arrItem.myregion.isVisible($DesktopPan.PointToClient([Cursor]::Position)))
            {       
                $e.Graphics.DrawPath($mypen2, $arrItem.myPath2)
                $e.Graphics.DrawPath($arrItem.mypen1, $arrItem.myPath)
                $PathGraBrush = New-Object Drawing2D.PathGradientBrush($arrItem.myPath)
                $PathGraBrush.SurroundColors = $arrItem.fillColor
                $e.Graphics.FillPath($PathGraBrush,$arrItem.myPath)                
 #               $e.Graphics.DrawString("test", $fonty , $myBrush, $arrItem.p.X+40,$arrItem.p.y+55, [StringFormat]::GenericDefault)
#                $e.Graphics.DrawImage($avatar,$arrItem.p.X+50,$arrItem.p.y+55,10,10)
                $e.Graphics.SetClip($arrItem.myregion,4)

            }
            Else
            {
                $e.Graphics.DrawPath($arrItem.mypen1, $arrItem.myPath)
                $PathGraBrush = New-Object Drawing2D.LinearGradientBrush ($arrItem.P2,$arrItem.P1,$arrItem.fillColor,[color]::White)
#                $PathGraBrush.SurroundColors = $arrItem.fillColor
                $e.Graphics.FillPath($PathGraBrush,$arrItem.myPath)                
#                $e.Graphics.DrawString("test", $fonty , $myBrush, $arrItem.p.X+40,$arrItem.p.y+55, [StringFormat]::GenericDefault)
 #               $e.Graphics.DrawImage($avatar,$arrItem.P1.x,$arrItem.P1.y)
#                $e.Graphics.DrawImage($avatar,$arrItem.P2.x,$arrItem.P2.y)
                $e.Graphics.SetClip($arrItem.myregion,4)
            }
        }  
    }       
})

$DesktopPan.add_MouseDown({
    $Global:bolMouseDown = $true
    $BolCont = $false
    $mouse = [Cursor]::Position
    $point = $DesktopPan.PointToClient($mouse)
 #   If ($Global:objShape -eq $null )
 #   {
 #       $Global:objShape = $null

            If ($arrRegions.Count -gt 0)
            {
                 for($i = 0; $i -lt $arrRegions.Count; $i++)
                {
                    $arrItem = $arrRegions[$i]
                    If ($arrItem.myregion2.isVisible($point))
                    {
                        $BolCont = $True
                        If (($Global:objShape -ne $null) -and ($Global:objShape -ne $arrItem))
                        {
                           
#                            $Global:objShape | Add-Member -MemberType NoteProperty -Name "test" -Value "Quincy"
                            If(!$Global:objShape.ConnArr.Contains($arrItem) -and (!$arrItem.ConnArr.Contains($Global:objShape)))
                            {
                                $Global:objShape.ConnArr.Add($arrItem)
                                write-host "$($Global:objShape.ConnArr.Count) - $($Global:objShape.type)"
                            }
                        }
                        
                        $Global:objShape = $null
                        $StartCircle.Checked = $false
                        $StartCircle.Refresh()
                        $InterCircle.Checked = $false
                        $InterCircle.Refresh()
                        $Dimond.Checked = $false
                        $Dimond.Refresh()
                        $Square.checked = $false
                        $Square.Refresh()
                        $DataObj.checked = $false
                        $DataObj.Refresh()
                        funDisAllShapes $null                         
                        $global:objShape = $arrItem
                        
                    }                     
                }
               
            }
 #           If(!$BolCont){$Global:objShape = $null}
 #   }
 #   Else
 #   {

#    }
    $DesktopPan.Invalidate() 
})

$DesktopPan.add_MouseUp({
 #   If($Global:bolMouseDown)
 #   {
        $Global:bolMouseMove = $false
        $Global:bolMouseDown = $false
        If ($Global:objShape -ne $null)
        {
            foreach($cont in $ShapesTbl.Controls)
            {
                $cont.checked = $false
            }
        }
 #   }
   

})

$DesktopPan.add_MouseMove({
    If(($Global:bolMouseDown) -and ($global:objShape -ne $null))
    {
        $Global:bolMouseMove = $true
        $mouse = [Cursor]::Position
        $point = $DesktopPan.PointToClient($mouse)
        If(($point.X  -gt 50) -and ($point.Y -gt 50))
        {
            If(($point.X + 50  -lt $DesktopPan.Size.Width) -and ($point.Y + 50  -lt $DesktopPan.Size.Height))
            {
                <#
                $objShape = Get-Variable -ValueOnly -Include $global:objShape.type               
                $objShape.Checked = $true
                $arrRegions.Remove($global:objShape)         
                write-host "$($global:objShape.name) removed"
                #>
                $DesktopPan.Invalidate()
            }
        } 
        
    }
    
})

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
    If($arrRegions.Count -gt 0)
    {  
        Write-host ($arrRegions.Count)
        $arrRegions.Clear()
    }
    Else
    {
         Write-host "0"
    }
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
$SolidLine.Image = imgStreamer "D:\ATE\IT\Root\images\SolidLine.png"
$SolidLine.Appearance = 1
$SolidLine.FlatStyle = 2
$SolidLine.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $SolidLine
})

$DashedLine = New-Object CheckBox
$DashedLine.Size = New-Object Size(100,25)
$DashedLine.name = 'LightMess'
$DashedLine.Image = imgStreamer "D:\ATE\IT\Root\images\DashedLine.png"
$DashedLine.Appearance = 1
$DashedLine.FlatStyle = 2
$DashedLine.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $DashedLine
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
$MainTbl.CellBorderStyle = 0
#$MainTbl.BackColor = "#d2d4d6"
$MainTbl.ColumnCount = 2
$MainTbl.RowCount = 5

$butsTbl =  New-Object TableLayoutPanel
$butsTbl.BackColor = ''
$butsTbl.Controls.Add($ShowPRFbtn)
$butsTbl.Controls.Add($DelShape)
$butsTbl.AutoSize = $true

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
$ShapesTbl.Controls.Add($DataObj)


#$DesktopPan.Controls.Add()

$SubIconTbl.Controls.Add($MessSubIcon)
$SubIconTbl.Controls.Add($DarkMessSubIcon)
$SubIconTbl.Controls.Add($GearSubIcon)
$SubIconTbl.Controls.Add($ClockSubIcon)
$SubIconTbl.Controls.Add($CrossSubIcon)
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

$LaunchTbl.Controls.Add($Play)
$LaunchTbl.Controls.Add($Record)
$LaunchTbl.Controls.Add($Stop)

$MagnifierTbl.Controls.Add($ZoomOut)
$MagnifierTbl.Controls.Add($Magnifier)
$MagnifierTbl.Controls.Add($ZoomIn)

$MainTbl.Controls.Add($DesktopPan,1,0)
$MainTbl.Controls.Add($ShapesTbl,0,0)
$MainTbl.Controls.Add($SubIconTbl,0,1)
$MainTbl.Controls.Add($LinesTbl,0,2)
$MainTbl.Controls.Add($butsTbl,0,3)
$MainTbl.Controls.Add($LaunchTbl,0,4)
$MainTbl.Controls.Add($MagnifierTbl,0,5)
$MainTbl.SetRowSpan($DesktopPan,6)


$form.Controls.Add($MainTbl)
$form.Add_Shown({$form.Activate(); $DesktopPan.Focus()})

$form.Add_Closing{
   
}
$form.Add_Load{
    Set-DoubleBuffer -grid $DesktopPan -Enabled $true
    $DelShape.Focus()
    
}

[void]$form.ShowDialog()   # display the dialog