# Load the GDI+ and WinForms Assemblies
[void][reflection.assembly]::LoadWithPartialName( "System.Windows.Forms")
[void][reflection.assembly]::LoadWithPartialName( "System.Drawing")

Function funDelShape{
    If ($arrRegions.Count -gt 0 -and $global:objShape -ne $null)
    {
        $arrRegions.Remove($global:objShape)       
    }
    $DesktopPan.Invalidate()     
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
$ShapesTbl.Size = New-Object System.Drawing.Size(100,700)
$ShapesTbl.Location = New-Object System.Drawing.size(2,100)
#$DesktopPan.Dock = [System.Windows.Forms.DockStyle]::Fill
$ShapesTbl.AutoSize = $true
$ShapesTbl.ColumnCount = 2
#$ShapesTbl.CellBorderStyle = 2
$ShapesTbl.TabIndex = 5
#$formGraphics = $form.createGraphics()
$x = 10
$y= 10


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

$StartCircle = New-Object System.Windows.Forms.CheckBox
$StartCircle.Size = New-Object System.Drawing.Size(45,45)

$StartCircle.name = 'StartCircle'
$image = [System.Drawing.Image]::FromFile("D:\ATE\IT\Root\images\StartCircle.png")
$StartCircle.Image= $image
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
$image = [System.Drawing.Image]::FromFile("D:\ATE\IT\Root\images\InterCircle.png")
$InterCircle.Image= $image
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
$image = [System.Drawing.Image]::FromFile("D:\ATE\IT\Root\images\VDimond.png")
$Dimond.Image= $image
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
$image = [System.Drawing.Image]::FromFile("D:\ATE\IT\Root\images\VSquare.png")
$Square.Image= $image
$Square.ImageAlign = 'MiddleCenter'
$Square.Appearance = 1
$Square.FlatStyle = 2
$Square.Padding = 5
$Square.Add_click({
    If(!$This.Checked){$DesktopPan.Focus()}
    funDisAllShapes $Square
})

$MainTbl = New-Object System.Windows.Forms.TableLayoutPanel
#$MainTbl.Location = New-Object System.Drawing.Size(2,50) 
$MainTbl.AutoSize = $true
$MainTbl.CellBorderStyle = 0
#$MainTbl.BackColor = "#d2d4d6"
$MainTbl.ColumnCount = 3
$MainTbl.RowCount = 3

$butsTbl =  New-Object System.Windows.Forms.TableLayoutPanel
$butsTbl.BackColor = ''
$butsTbl.Controls.Add($ShowPRFbtn)
$butsTbl.Controls.Add($DelShape)
$butsTbl.AutoSize = $true

#$ShapesTbl.Controls.Add($butsPanel)
$ShapesTbl.Controls.Add($StartCircle,0,0)
$ShapesTbl.Controls.Add($InterCircle,0,0)
$ShapesTbl.Controls.Add($Dimond,0,1)
$ShapesTbl.Controls.Add($Square,1,0)
#$DesktopPan.Controls.Add()

$MainTbl.Controls.Add($DesktopPan,1,0)
$MainTbl.Controls.Add($ShapesTbl,0,0)
$MainTbl.Controls.Add($butsTbl,0,1)
$MainTbl.SetRowSpan($DesktopPan,3)

$form.Controls.Add($MainTbl)
$form.Add_Shown({$form.Activate(); $DesktopPan.Focus()})
$form.Add_Load{
    Set-DoubleBuffer -grid $DesktopPan -Enabled $true
    $DelShape.Focus()
    
}

[void]$form.ShowDialog()   # display the dialog