using namespace System.IO
using namespace System.Drawing
using namespace System.Drawing.Imaging
# Load the GDI+ and WinForms Assemblies
[void][reflection.assembly]::LoadWithPartialName( "System.IO")
[void][reflection.assembly]::LoadWithPartialName( "System.Drawing")
[void][reflection.assembly]::LoadWithPartialName( "System.Drawing.Imaging")


Function funDelShape{
    If ($arrRegions.Count -gt 0 -and $global:objShape -ne $null)
    {
        $arrRegions.Remove($global:objShape)       
    }
    $DesktopPan.Invalidate()     
}

Function imgStreamer($imgPath){

    $inStream = ([FileInfo]$imgPath).Open([FileMode]::Open, [FileAccess]::ReadWrite)
    [Image]::FromStream($inStream)
    $inStream.Dispose()
}

$DesktopPan = New-Object System.Windows.Forms.Panel
#$DesktopPan.BackColor = 'green'
$DesktopPan.Location = New-Object System.Drawing.size(120,50)
$DesktopPan.Size = New-Object System.Drawing.Size(1100,700)
$DesktopPan.Dock = [System.Windows.Forms.DockStyle]::Fill
#$DesktopPan.AutoSize = $true
$DesktopPan.name = "Main"
$DesktopPan.BorderStyle = 1


$DesktopPan.Add_KeyDown({
if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Delete) {     
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
}

function Set-DoubleBuffer {
    param ([Parameter(Mandatory = $true)]
        [System.Windows.Forms.Panel]$grid,
        [boolean]$Enabled)  
    $type = $grid.GetType();
    $propInfo = $type.GetProperty("DoubleBuffered", ('Instance','NonPublic'))
    $propInfo.SetValue($grid, $Enabled)
}

$intIterate = 0
$bolMouseDown = $false
$objShape = $null

$arrRegions = [System.Collections.ArrayList]@()
# Create pen and brush objects 
$myBrush = new-object Drawing.SolidBrush black
$mypen = new-object Drawing.Pen black,2
$mypen2 = new-object Drawing.Pen gray, 4
$mypen3 = new-object Drawing.Pen white, 4
$mypen2.Color = [System.Drawing.Color]::FromArgb(180,180,180)
$bigarrow = New-Object System.Drawing.Drawing2D.AdjustableArrowCap 5,5
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

$fonty = New-Object System.Drawing.Font 'arial',16

# Create a Form
$form = New-Object Windows.Forms.Form
$form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
#$form.BackColor = [System.Drawing.Color]::FromArgb(220,220,220)
$form.Size = New-Object Drawing.Size 1300, 800
$form.AutoScroll = $true
# Get the form's graphics object





$DesktopPan.Add_paint({
    param([System.Object]$s, [System.Windows.Forms.PaintEventArgs]$e)
#    $e.Graphics.InterpolationMode = 2
    $e.Graphics.SmoothingMode = 4
    $mouse = [System.Windows.Forms.Cursor]::Position
    $point = $DesktopPan.PointToClient($mouse)
    If ($StartCircle.Checked -or $Dimond.Checked -or $Square.Checked)
    {
        $Global:intIterate ++
        $point.X = $point.X - 50
        $point.Y = $point.Y - 50
        switch (($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)
        {
            'StartCircle' {          
                $myPath = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myPath2 = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myPath.AddEllipse($point.X,$point.Y,100,100)
                $myPath2.AddEllipse(($point.X)-2,($point.Y)-2,104,104)
                $myregion2 = new-object System.Drawing.Region  $myPath2
                New-Variable -Force -Name "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate" -Value (new-object System.Drawing.Region  $myPath) 
                $myregion = Get-Variable -ValueOnly -Include "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                $strMess = 'test'
                $objPSCircle = [pscustomobject]@{
                    name = "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                    type = 'StartCircle'
                    Location = $location
                    myregion = $myregion
                    myregion2 = $myregion2
                    P = $point
                    myPath = $myPath
                    myPath2 = $myPath2
                    str = $strMess
                }
                [void]$arrRegions.Add($objPSCircle)                
                 If(($Global:bolMouseDown) -and ($global:objShape -ne $null))
                 {
                    $global:objShape = $objPSCircle
                 }
            }
            'dimond' {
                
                $pp1 = New-Object System.Drawing.Point ($point.X) , ($point.Y+50)
                $pp2 = New-Object System.Drawing.Point ($point.X+50 ), ($point.Y)
                $pp3 = New-Object System.Drawing.Point ($point.X+100 ), ($point.Y+50)
                $pp4 = New-Object System.Drawing.Point ($point.X+50 ), ($point.Y+100)
                $points = @($pp1,$pp2,$pp3,$pp4)

                $sp1 = New-Object System.Drawing.Point ($pp1.X-2) , ($pp1.Y)
                $sp2 = New-Object System.Drawing.Point ($pp2.X ), ($pp2.Y-2)
                $sp3 = New-Object System.Drawing.Point ($pp3.X+2) , ($pp3.Y)
                $sp4 = New-Object System.Drawing.Point ($pp4.X ), ($pp4.Y+2)
                $points2 = @($sp1,$sp2,$sp3,$sp4)

                $myPath = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myPath2 = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myPath.AddPolygon($points)
                $myPath2.AddPolygon($points2)
                $myregion2 = new-object System.Drawing.Region  $myPath2
                New-Variable -Force -Name "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate" -Value (new-object System.Drawing.Region  $myPath) 
                $myregion = Get-Variable -ValueOnly -Include "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                $objPSDimond = [pscustomobject]@{
                    name = "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                    type = 'Dimond'
                    Location = $location
                    myregion = $myregion
                    myregion2 = $myregion2
                    P = $point
                    myPath = $myPath
                    myPath2 = $myPath2
                    str = $strMess
                 }
                [void]$arrRegions.Add($objPSDimond)                
                 If(($Global:bolMouseDown) -and ($global:objShape -ne $null))
                 {
                    $global:objShape = $objPSDimond
                 }           
            }
            'Square' {

                $pp1 = New-Object System.Drawing.Point ($point.X-25) , ($point.Y+15)
                $pp2 = New-Object System.Drawing.Point ($point.X+125 ), ($point.Y+15)
                $pp3 = New-Object System.Drawing.Point ($point.X+125) , ($point.Y+85)
                $pp4 = New-Object System.Drawing.Point ($point.X-25 ), ($point.Y+85)
                $points = @($pp1,$pp2,$pp3,$pp4)

                $sp1 = New-Object System.Drawing.Point ($pp1.X-2 ), ($pp1.Y-2)
                $sp2 = New-Object System.Drawing.Point ($pp2.X+2 ), ($pp2.Y-2)
                $sp3 = New-Object System.Drawing.Point ($pp3.X+2) , ($pp3.Y+2)
                $sp4 = New-Object System.Drawing.Point ($pp4.X-2 ), ($pp4.Y+2)
                $points2 = @($sp1,$sp2,$sp3,$sp4)
                
                $myPath = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myPath2 = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myPath.AddPolygon($points)
                $myPath2.AddPolygon($points2)
                $myregion2 = new-object System.Drawing.Region  $myPath2
                New-Variable -Force -Name "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate" -Value (new-object System.Drawing.Region  $myPath) 
                $myregion = Get-Variable -ValueOnly -Include "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                $objPSSquare = [pscustomobject]@{
                    name = "$(($ShapesTbl.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                    type = 'Square'
                    Location = $location
                    myregion = $myregion
                    myregion2 = $myregion2
                    P = $point
                    myPath = $myPath
                    myPath2 = $myPath2
                    str = $strMess
                }
                [void]$arrRegions.Add($objPSSquare              
                    )               
                If(($Global:bolMouseDown) -and ($global:objShape -ne $null))
                {
                $global:objShape = $objPSSquare
                }            
            }
        }

    }
    If ($arrRegions.count -gt 0)
    {
         for($i = 0; $i -lt $arrRegions.Count; $i++)
        {
            $arrItem = $arrRegions[$i]
            If ($arrItem.myregion.isVisible($point))
            {
                $StartCircle.Checked = $false
                $StartCircle.Refresh()
                $Dimond.Checked = $false
                $Dimond.Refresh()
                $Square.checked = $false
                $Square.Refresh()

                $DesktopPan.Focus()

                $e.Graphics.DrawPath($mypen2, $arrItem.myPath2)
                $e.Graphics.DrawPath($mypen, $arrItem.myPath)
                $e.Graphics.DrawString("test", $fonty , $myBrush, $arrItem.p.X+40,$arrItem.p.y+55, [System.Drawing.StringFormat]::GenericDefault)
                $e.Graphics.DrawImage($avatar,$arrItem.p.X+50,$arrItem.p.y+55,10,10)
                $e.Graphics.SetClip($arrItem.myregion,4)

            }
            Else
            {

                $e.Graphics.DrawPath($mypen, $arrItem.myPath)
                $e.Graphics.DrawString("test", $fonty , $myBrush, $arrItem.p.X+40,$arrItem.p.y+55, [System.Drawing.StringFormat]::GenericDefault)
                $e.Graphics.DrawImage($avatar,$arrItem.p.X+50,$arrItem.p.y+55,10,10)
                $e.Graphics.SetClip($arrItem.myregion,4)
            }
        }  
    }       
})

 

$DesktopPan.add_MouseDown({
$Global:bolMouseDown = $true
$Global:objShape = $null
$mouse = [System.Windows.Forms.Cursor]::Position
$point = $DesktopPan.PointToClient($mouse)
    If ($arrRegions.Count -gt 0)
    {
         for($i = 0; $i -lt $arrRegions.Count; $i++)
        {
            $arrItem = $arrRegions[$i]
            If ($arrItem.myregion2.isVisible($point))
            {
                $StartCircle.Checked = $false
                $StartCircle.Refresh()
                $Dimond.Checked = $false
                $Dimond.Refresh()
                $Square.checked = $false
                $Square.Refresh()
                $global:objShape = $arrItem
            }                     
        }  
    }
$DesktopPan.Invalidate() 
})

$DesktopPan.add_MouseUp({
    If($Global:bolMouseDown)
    {
        $Global:bolMouseDown = $false
        If ($Global:objShape -ne $null)
        {
            foreach($cont in $ShapesTbl.Controls)
            {
                $cont.checked = $false
            }
        }
    }
   

})

$DesktopPan.add_MouseMove({
    If(($Global:bolMouseDown) -and ($global:objShape -ne $null))
    {
        $mouse = [System.Windows.Forms.Cursor]::Position
        $point = $DesktopPan.PointToClient($mouse)
        If(($point.X  -gt 50) -and ($point.Y -gt 50))
        {
            If(($point.X + 50  -lt $DesktopPan.Size.Width) -and ($point.Y + 50  -lt $DesktopPan.Size.Height))
            {
                $objShape = Get-Variable -ValueOnly -Include $global:objShape.type               
                $objShape.Checked = $true
                $arrRegions.Remove($global:objShape)         
                $DesktopPan.Invalidate()
            }
        } 
    }

})

$ShapesTbl = New-Object System.Windows.Forms.TableLayoutPanel
$ShapesTbl.BackColor = ''
#$ShapesTbl.Size = New-Object System.Drawing.Size(100,700)
#$ShapesTbl.Location = New-Object System.Drawing.size(2,100)
#$DesktopPan.Dock = [System.Windows.Forms.DockStyle]::Fill
$ShapesTbl.AutoSize = $true
$ShapesTbl.ColumnCount = 2
#$ShapesTbl.CellBorderStyle = 2
$ShapesTbl.TabIndex = 5

$SubIconTbl = New-Object System.Windows.Forms.TableLayoutPanel
$SubIconTbl.BackColor = ''
#$SubIconTbl.Size = New-Object System.Drawing.Size(100,700)
#$SubIconTbl.Location = New-Object System.Drawing.size(2,100)
#$SubIconTbl.Dock = [System.Windows.Forms.DockStyle]::Fill
$SubIconTbl.AutoSize = $true
$SubIconTbl.ColumnCount = 2
#$SubIconTbl.CellBorderStyle = 2
$SubIconTbl.TabIndex = 5

$LinesTbl = New-Object System.Windows.Forms.TableLayoutPanel
$LinesTbl.BackColor = ''
#$SubIconTbl.Size = New-Object System.Drawing.Size(100,700)
#$SubIconTbl.Location = New-Object System.Drawing.size(2,100)
#$SubIconTbl.Dock = [System.Windows.Forms.DockStyle]::Fill
$LinesTbl.AutoSize = $true
$LinesTbl.ColumnCount = 1
#$SubIconTbl.CellBorderStyle = 2
$LinesTbl.TabIndex = 5

$ShowPRFbtn = New-Object system.Windows.Forms.Button
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

          $arrRegions.Clear()
    }
    $DesktopPan.Invalidate()         
})

$DelShape = New-Object system.Windows.Forms.Button
$DelShape.Location = New-Object System.Drawing.Size(2,50) 
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


$SolidLine = New-Object System.Windows.Forms.CheckBox
$SolidLine.Size = New-Object System.Drawing.Size(100,25)
$SolidLine.name = 'LightMess'
$SolidLine.Image = imgStreamer "D:\ATE\IT\Root\images\SolidLine.png"
$SolidLine.Appearance = 1
$SolidLine.FlatStyle = 2
$SolidLine.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $SolidLine
})

$DashedLine = New-Object System.Windows.Forms.CheckBox
$DashedLine.Size = New-Object System.Drawing.Size(100,25)
$DashedLine.name = 'LightMess'
$DashedLine.Image = imgStreamer "D:\ATE\IT\Root\images\DashedLine.png"
$DashedLine.Appearance = 1
$DashedLine.FlatStyle = 2
$DashedLine.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $DashedLine
})

$MessSubIcon = New-Object System.Windows.Forms.CheckBox
$MessSubIcon.Size = New-Object System.Drawing.Size(45,45)
$MessSubIcon.name = 'LightMess'
$MessSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\LightMess.png"
$MessSubIcon.Appearance = 1
$MessSubIcon.FlatStyle = 2
$MessSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $MessSubIcon
})

$DarkMessSubIcon = New-Object System.Windows.Forms.CheckBox
$DarkMessSubIcon.Size = New-Object System.Drawing.Size(45,45)
$DarkMessSubIcon.name = 'DarktMess'
$DarkMessSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\DarkMess.png"
$DarkMessSubIcon.Appearance = 1
$DarkMessSubIcon.FlatStyle = 2
$DarkMessSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $DarkMessSubIcon
})

$GearSubIcon = New-Object System.Windows.Forms.CheckBox
$GearSubIcon.Size = New-Object System.Drawing.Size(45,45)
$GearSubIcon.name = 'Gear'
$GearSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Gear.png"
$GearSubIcon.Appearance = 1
$GearSubIcon.FlatStyle = 2
$GearSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $GearSubIcon
})


$ClockSubIcon = New-Object System.Windows.Forms.CheckBox
$ClockSubIcon.Size = New-Object System.Drawing.Size(45,45)
$ClockSubIcon.name = 'Clock'
$ClockSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Clock.png"
$ClockSubIcon.Appearance = 1
$ClockSubIcon.FlatStyle = 2
$ClockSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ClockSubIcon
})

$CrossSubIcon = New-Object System.Windows.Forms.CheckBox
$CrossSubIcon.Size = New-Object System.Drawing.Size(45,45)
$CrossSubIcon.name = 'Clock'
$CrossSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Cross.png"
$CrossSubIcon.Appearance = 1
$CrossSubIcon.FlatStyle = 2
$CrossSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $CrossSubIcon
})


$SinStartSubIcon = New-Object System.Windows.Forms.CheckBox
$SinStartSubIcon.Size = New-Object System.Drawing.Size(45,45)
$SinStartSubIcon.name = 'Clock'
$SinStartSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\SigStart.png"
$SinStartSubIcon.Appearance = 1
$SinStartSubIcon.FlatStyle = 2
$SinStartSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $SinStartSubIcon
})

$ConSubIcon = New-Object System.Windows.Forms.CheckBox
$ConSubIcon.Size = New-Object System.Drawing.Size(45,45)
$ConSubIcon.name = 'Clock'
$ConSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Condition.png"
$ConSubIcon.Appearance = 1
$ConSubIcon.FlatStyle = 2
$ConSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ConSubIcon
})

$SigEndSubIcon = New-Object System.Windows.Forms.CheckBox
$SigEndSubIcon.Size = New-Object System.Drawing.Size(45,45)
$SigEndSubIcon.name = 'Clock'
$SigEndSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\SigEnd.png"
$SigEndSubIcon.Appearance = 1
$SigEndSubIcon.FlatStyle = 2
$SigEndSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $SigEndSubIcon
})

$ErrEndSubIcon = New-Object System.Windows.Forms.CheckBox
$ErrEndSubIcon.Size = New-Object System.Drawing.Size(45,45)
$ErrEndSubIcon.name = 'Clock'
$ErrEndSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\ErrEnd.png"
$ErrEndSubIcon.Appearance = 1
$ErrEndSubIcon.FlatStyle = 2
$ErrEndSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ErrEndSubIcon
})

$ErrorSubIcon = New-Object System.Windows.Forms.CheckBox
$ErrorSubIcon.Size = New-Object System.Drawing.Size(45,45)
$ErrorSubIcon.name = 'Clock'
$ErrorSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Error.png"
$ErrorSubIcon.Appearance = 1
$ErrorSubIcon.FlatStyle = 2
$ErrorSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ErrorSubIcon
})


$EscaSubIcon = New-Object System.Windows.Forms.CheckBox
$EscaSubIcon.Size = New-Object System.Drawing.Size(45,45)
$EscaSubIcon.name = 'Clock'
$EscaSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Escalation.png"
$EscaSubIcon.Appearance = 1
$EscaSubIcon.FlatStyle = 2
$EscaSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $EscaSubIcon
})

$EscaEndSubIcon = New-Object System.Windows.Forms.CheckBox
$EscaEndSubIcon.Size = New-Object System.Drawing.Size(45,45)
$EscaEndSubIcon.name = 'Clock'
$EscaEndSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\EscalEnd.png"
$EscaEndSubIcon.Appearance = 1
$EscaEndSubIcon.FlatStyle = 2
$EscaEndSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $EscaEndSubIcon
})

$ArrowSubIcon = New-Object System.Windows.Forms.CheckBox
$ArrowSubIcon.Size = New-Object System.Drawing.Size(45,45)
$ArrowSubIcon.name = 'Clock'
$ArrowSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Arrow.png"
$ArrowSubIcon.Appearance = 1
$ArrowSubIcon.FlatStyle = 2
$ArrowSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $ArrowSubIcon
})


$FArrowSubIcon = New-Object System.Windows.Forms.CheckBox
$FArrowSubIcon.Size = New-Object System.Drawing.Size(45,45)
$FArrowSubIcon.name = 'Clock'
$FArrowSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\FArrow.png"
$FArrowSubIcon.Appearance = 1
$FArrowSubIcon.FlatStyle = 2
$FArrowSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $FArrowSubIcon
})

$UserSubIcon = New-Object System.Windows.Forms.CheckBox
$UserSubIcon.Size = New-Object System.Drawing.Size(45,45)
$UserSubIcon.name = 'Clock'
$UserSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\User.png"
$UserSubIcon.Appearance = 1
$UserSubIcon.FlatStyle = 2
$UserSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $UserSubIcon
})

$PlusSubIcon = New-Object System.Windows.Forms.CheckBox
$PlusSubIcon.Size = New-Object System.Drawing.Size(45,45)
$PlusSubIcon.name = 'Clock'
$PlusSubIcon.Image = imgStreamer "D:\ATE\IT\Root\images\Plus.png"
$PlusSubIcon.Appearance = 1
$PlusSubIcon.FlatStyle = 2
$PlusSubIcon.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $PlusSubIcon
})

$StartCircle = New-Object System.Windows.Forms.CheckBox
$StartCircle.Size = New-Object System.Drawing.Size(45,45)
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

$InterCircle = New-Object System.Windows.Forms.CheckBox
$InterCircle.Size = New-Object System.Drawing.Size(45,45)
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



$Dimond = New-Object System.Windows.Forms.CheckBox
$Dimond.Size = New-Object System.Drawing.Size(45,45)
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


$Square = New-Object System.Windows.Forms.CheckBox
$Square.Size = New-Object System.Drawing.Size(45,45)
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

$DataObj = New-Object System.Windows.Forms.CheckBox
$DataObj.Size = New-Object System.Drawing.Size(45,45)
$DataObj.name = 'Square'
$DataObj.Image = imgStreamer "D:\ATE\IT\Root\images\DataObj.png"
$DataObj.ImageAlign = 'MiddleCenter'
$DataObj.Appearance = 1
$DataObj.FlatStyle = 2
$DataObj.Padding = 5
$DataObj.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $DataObj
})

$MainTbl = New-Object System.Windows.Forms.TableLayoutPanel
#$MainTbl.Location = New-Object System.Drawing.Size(2,50) 
$MainTbl.AutoSize = $true
$MainTbl.CellBorderStyle = 0
#$MainTbl.BackColor = "#d2d4d6"
$MainTbl.ColumnCount = 2
$MainTbl.RowCount = 4

$butsTbl =  New-Object System.Windows.Forms.TableLayoutPanel
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


$MainTbl.Controls.Add($DesktopPan,1,0)
$MainTbl.Controls.Add($ShapesTbl,0,0)
$MainTbl.Controls.Add($SubIconTbl,0,1)
$MainTbl.Controls.Add($LinesTbl,0,2)
$MainTbl.Controls.Add($butsTbl,0,3)
$MainTbl.SetRowSpan($DesktopPan,4)

$form.Controls.Add($MainTbl)
$form.Add_Shown({$form.Activate(); $DesktopPan.Focus()})

$form.Add_Closing{
   
}
$form.Add_Load{
    Set-DoubleBuffer -grid $DesktopPan -Enabled $true
    $DelShape.Focus()
    
}

[void]$form.ShowDialog()   # display the dialog