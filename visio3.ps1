#Load the GDI+ and WinForms Assemblies
[void][reflection.assembly]::LoadWithPartialName( "System.Windows.Forms")
[void][reflection.assembly]::LoadWithPartialName( "System.Drawing")

Function funDisAllShapes($O) {

    foreach($obj in $shapesGB.Controls)
    {
        If($obj -ne $O)
        {
            $obj.checked = $false   
        }    
    }
    
}

$intIterate = 0

$arrRegions = [System.Collections.ArrayList]@()
# Create pen and brush objects 
$myBrush = new-object Drawing.SolidBrush black
$mypen = new-object Drawing.Pen black,2
$mypen2 = new-object Drawing.Pen gray, 4
$mypen3 = new-object Drawing.Pen white, 4
$mypen2.Color = [System.Drawing.Color]::FromArgb(200,200,200)
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
$form.Size = New-Object Drawing.Size 1200, 800
$form.AutoScroll = $true
# Get the form's graphics object
$DesktopGB = New-Object system.Windows.Forms.Groupbox
$DesktopGB.Size = New-Object System.Drawing.Size(1100,750)
#$DesktopGB.Dock = [System.Windows.Forms.DockStyle]::Fill
$DesktopGB.AutoSize = $true
$DesktopGB.Add_paint({
    param([System.Object]$s, [System.Windows.Forms.PaintEventArgs]$e)
    
    $mouse = [System.Windows.Forms.Cursor]::Position
    $point = $DesktopGB.PointToClient($mouse)
    If ($show.Checked -or $show2.Checked -or $PolygonRB.Checked)
    {
        $Global:intIterate ++

        $point.X = $point.X - 50
        $point.Y = $point.Y - 50

        $Test= ($ShapesGB.Controls | Where-Object -FilterScript {$_.Checked}).name

        switch (($ShapesGB.Controls | Where-Object -FilterScript {$_.Checked}).name)
        {
            'circle' {

                $myPath = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myPath2 = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myPath.AddEllipse($point.X,$point.Y,100,100)
                $myPath2.AddEllipse(($point.X)-2,($point.Y)-2,105,105)

                $myregion2 = new-object System.Drawing.Region  $myPath2
                New-Variable -Force -Name "$(($ShapesGB.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate" -Value (new-object System.Drawing.Region  $myPath) 
                $myregion = Get-Variable -ValueOnly -Include "$(($ShapesGB.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"

                $strMess = 'test'

                [void]$arrRegions.Add(              
                    [pscustomobject]@{
                        name = "$(($ShapesGB.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                        Location = $location
                        myregion = $myregion
                        myregion2 = $myregion2
                        P = $point
                        myPath = $myPath
                        myPath2 = $myPath2
                        str = $strMess
                    }                    
                )     
            }
            'dimond' {
                
                $p1 = New-Object System.Drawing.Point ($point.X) , ($point.Y+50)
                $p2 = New-Object System.Drawing.Point ($point.X+50 ), ($point.Y)
                $p3 = New-Object System.Drawing.Point ($point.X+50) , ($point.Y)
                $p4 = New-Object System.Drawing.Point ($point.X+100 ), ($point.Y+50)
                $p5 = New-Object System.Drawing.Point ($point.X+100 ), ($point.Y+50)
                $p6 = New-Object System.Drawing.Point ($point.X+50 ), ($point.Y+100)
                $points = @($p1,$p2,$p3,$p4,$p5,$p6)

                $myPath = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myPath2 = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myPath.AddPolygon($points)
                $myPath2.AddPolygon($points)
                $myregion2 = new-object System.Drawing.Region  $myPath2
                New-Variable -Force -Name "$(($ShapesGB.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate" -Value (new-object System.Drawing.Region  $myPath) 
                $myregion = Get-Variable -ValueOnly -Include "$(($ShapesGB.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                [void]$arrRegions.Add($myregion) 

                [void]$arrRegions.Add(              
                    [pscustomobject]@{
                        name = "$(($ShapesGB.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                        Location = $location
                        myregion = $myregion
                        myregion2 = $myregion2
                        P = $point
                        myPath = $myPath
                        myPath2 = $myPath2
                        str = $strMess
                })
            
            }
            'Square' {

                $p1 = New-Object System.Drawing.Point ($point.X-25) , ($point.Y+15)
                $p2 = New-Object System.Drawing.Point ($point.X+125 ), ($point.Y+15)
                $p3 = New-Object System.Drawing.Point ($point.X+125) , ($point.Y+85)
                $p4 = New-Object System.Drawing.Point ($point.X-25 ), ($point.Y+85)
                $points = @($p1,$p2,$p3,$p4)
                
                $myPath = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myPath2 = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myPath.AddPolygon($points)
                $myPath2.AddPolygon($points)
                $myregion2 = new-object System.Drawing.Region  $myPath2
                New-Variable -Force -Name "$(($ShapesGB.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate" -Value (new-object System.Drawing.Region  $myPath) 
                $myregion = Get-Variable -ValueOnly -Include "$(($ShapesGB.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
             
                [void]$arrRegions.Add(              
                    [pscustomobject]@{
                        name = "$(($ShapesGB.Controls | Where-Object -FilterScript {$_.Checked}).name)$Global:intIterate"
                        Location = $location
                        myregion = $myregion
                        myregion2 = $myregion2
                        P = $point
                        myPath = $myPath
                        myPath2 = $myPath2
                        str = $strMess
                })           
            }
        }

    }
    If ($arrRegions.count -gt 0)
    {
#        foreach($arrItem in $arrRegions)
         for($i = 0; $i -lt $arrRegions.Count; $i++)
        {
 #           If ($arrItem.isVisible($point))
            $arrItem = $arrRegions[$i]
 #           If ($arrItem.isVisible($point))
            If ($arrItem.myregion.isVisible($point))
            {
                If($Show2.Checked -eq $false)
                {
                    $test   
                }
                $Show.Checked = $false
                $Show.Refresh()
                $Show2.Checked = $false
                $Show2.Refresh()
                $PolygonRB.checked = $false
                $PolygonRB.Refresh()

                $DesktopGB.Focus()
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

 

$DesktopGB.add_MouseDown({

$mouse = [System.Windows.Forms.Cursor]::Position
$point = $DesktopGB.PointToClient($mouse)
    If ($arrRegions.Count -gt 0)
    {
#        foreach($arrItem in $arrRegions)
         for($i = 0; $i -lt $arrRegions.Count; $i++)
        {
 #           If ($arrItem.isVisible($point))
            $arrItem = $arrRegions[$i]
            If ($arrItem.myregion2.isVisible($point))
            {
                If($Show2.Checked -eq $false)
                {
                    $test   
                }
                write-host "inside"
                $Show.Checked = $false
                $Show.Refresh()
                $Show2.Checked = $false
                $Show2.Refresh()
                $PolygonRB.checked = $false
                $PolygonRB.Refresh()
                $desktopGB.Invalidate($arrItem.myregion2)
                 
            }
            Else
            {
                $desktopGB.Invalidate()           
            }
        }  
    }
    Else
    {
         $desktopGB.Invalidate() 
    }

})



$DesktopGB.add_MouseUp({

  

})



$ShapesGB = New-Object system.Windows.Forms.Groupbox
$ShapesGB.Size = New-Object System.Drawing.Size(100,700)
#$DesktopGB.Dock = [System.Windows.Forms.DockStyle]::Fill
$ShapesGB.AutoSize = $true

#$formGraphics = $form.createGraphics()
$x = 10
$y= 10


#$test.DrawString("test", [System.Drawing.Font]::GenericDefault, [System.Drawing.SystemBrushes]::ControlText, 50, 50, [System.Drawing.StringFormat]::GenericDefault)   


# Define the paint handler
<#
$DesktopGB.add_paint(
{

#$formGraphics.FillEllipse($myBrush, $rect) # draw an ellipse using rectangle object




#$formGraphics.DrawLine($mypen, 300, 10, 300, 190) # draw a line



}
)
#>

$ShowPRFbtn = New-Object system.Windows.Forms.Button
$ShowPRFbtn.Location = New-Object System.Drawing.Size(1000,38) 
$ShowPRFbtn.BackColor = "#d2d4d6"
$ShowPRFbtn.text = "Clear"
$ShowPRFbtn.width = 120
$ShowPRFbtn.height = 25
$ShowPRFbtn.Font = 'Microsoft Sans Serif,10'
$ShowPRFbtn.ForeColor = "#000"
$ShowPRFbtn.Add_Click({
#$g.Clear('window')
#$g.Flush()
<#
foreach($arrItem in $arrRegions)
  {
    $arrRegions.Clear()
  }
#>
  $arrRegions.Clear()
  $g.Clear([System.Drawing.Color]::White)
#$test.DrawLine($mypen, 10, 100, 100, 150) # draw a line
#$test.Clear('red')
#$form.Refresh()

})

$ShowPRFbtn = New-Object system.Windows.Forms.Button
$ShowPRFbtn.Location = New-Object System.Drawing.Size(1000,38) 
$ShowPRFbtn.BackColor = "#d2d4d6"
$ShowPRFbtn.text = "Clear"
$ShowPRFbtn.width = 120
$ShowPRFbtn.height = 25
$ShowPRFbtn.Font = 'Microsoft Sans Serif,10'
$ShowPRFbtn.ForeColor = "#000"
$ShowPRFbtn.Add_Click({
    
  If($arrRegions.Count -gt 0)
  {  

  <#          
            $DesktopGB.Invalidate($arrItem.region)
            $DesktopGB.Invalidate($arrItem.region2)
            $DesktopGB.Invalidate($arrItem.Path)
            $DesktopGB.Invalidate($arrItem.Path2)
     
             $arrItem.region.dispose()
            $arrItem.region2.dispose()
            $arrItem.Path.dispose()
            $arrItem.Path2.dispose()
#>
        $arrRegions.Clear()
    }
 #           $DesktopGB.Invalidate($arrItem.region2)
 #           $g.Clear([System.Drawing.Color]::White)
    $DesktopGB.Invalidate()         
})

$Show = New-Object System.Windows.Forms.CheckBox
$Show.name = 'circle'
$image = [System.Drawing.Image]::FromFile("D:\ATE\IT\Root\images\VCircle.png")

$Show.Image= $image
$Show.Location = New-Object System.Drawing.Size(20,100) 
$Show.Appearance = 1
$Show.FlatStyle = 2
#$Show.BackColor = "#d2d4d6"
#$Show.text = "sec square"
$Show.width = 80
$Show.height = 80
$Show.Padding = 5
$Show.Add_click({
    If(!$This.Checked){$DesktopGB.Focus()}
    funDisAllShapes $Show
})
#$Show.Font = 'Microsoft Sans Serif,10'
#$Show.ForeColor = "#000"
#$Show.

$Show2 = New-Object System.Windows.Forms.CheckBox
$Show2.name = 'Dimond'
$image = [System.Drawing.Image]::FromFile("D:\ATE\IT\Root\images\VDimond.png")
$Show2.Image= $image
$Show2.ImageAlign = 'MiddleCenter'
$Show2.Location = New-Object System.Drawing.Size(20,200) 
$Show2.Appearance = 1
$Show2.FlatStyle = 2
$Show2.Add_click({
    If(!$This.Checked){$DesktopGB.Focus()}
    funDisAllShapes $Show2
})
#$Show.BackColor = "#d2d4d6"
#$Show.text = "sec square"
$Show2.width = 80
$Show2.height =80
$Show2.Padding = 5


$PolygonRB = New-Object System.Windows.Forms.CheckBox
$PolygonRB.name = 'Square'
$image = [System.Drawing.Image]::FromFile("D:\ATE\IT\Root\images\VSquare.png")
$PolygonRB.Image= $image
$PolygonRB.ImageAlign = 'MiddleCenter'
$PolygonRB.Location = New-Object System.Drawing.Size(20,300) 
$PolygonRB.Appearance = 1
$PolygonRB.FlatStyle = 2
#$Show.BackColor = "#d2d4d6"
#$Show.text = "sec square"
$PolygonRB.width = 80
$PolygonRB.height =80
$PolygonRB.Padding = 5
$PolygonRB.Add_click({
    If(!$This.Checked){$DesktopGB.Focus()}
    funDisAllShapes $PolygonRB
})

$g = $DesktopGB.CreateGraphics()
$g.SmoothingMode = 2

$ShapesGB.Controls.Add($PolygonRB)
$ShapesGB.Controls.Add($Show)
$ShapesGB.Controls.Add($Show2)
$DesktopGB.Controls.Add($ShapesGB)
$DesktopGB.Controls.Add($ShowPRFbtn)
$form.Controls.Add($DesktopGB)
[void]$form.ShowDialog()   # display the dialog