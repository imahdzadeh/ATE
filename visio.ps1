#Load the GDI+ and WinForms Assemblies
[void][reflection.assembly]::LoadWithPartialName( "System.Windows.Forms")
[void][reflection.assembly]::LoadWithPartialName( "System.Drawing")



$intIterate = 0

$arrRegions = [System.Collections.ArrayList]@()
# Create pen and brush objects 
$myBrush = new-object Drawing.SolidBrush green
$mypen = new-object Drawing.Pen black
$mypen2 = new-object Drawing.Pen black

$bigarrow = New-Object System.Drawing.Drawing2D.AdjustableArrowCap 5,5
$mypen.color = "black" # Set the pen color
$mypen.width = 2     # ste the pen line width

$mypen2.color = "black" # Set the pen color
$mypen2.width = 2     # ste the pen line width
$mypen2.CustomEndCap = $bigarrow

$brushBg = [System.Drawing.Brushes]::gray
$ClearbrushBg = [System.Drawing.Brushes]::white

# Create a Rectangle object for use when drawing rectangle
$rect = new-object Drawing.Rectangle 10, 10, 180, 180

# Create a Form
$form = New-Object Windows.Forms.Form
$form.Size = New-Object Drawing.Size 1200, 800
$form.AutoScroll = $true
# Get the form's graphics object
$DesktopGB = New-Object system.Windows.Forms.Groupbox
$DesktopGB.Size = New-Object System.Drawing.Size(1100,750)
#$DesktopGB.Dock = [System.Windows.Forms.DockStyle]::Fill
$DesktopGB.AutoSize = $true

$DesktopGB.add_MouseDown({
$mouse = [System.Windows.Forms.Cursor]::Position
$point = $DesktopGB.PointToClient($mouse)
    If ($arrRegions -ne $null)
    {
        foreach($arrItem in $arrRegions)
        {
            If ($arrItem.isVisible($point))
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
    <#
                $m = new-object  System.Drawing.Drawing2D.Matrix
                $m.RotateAt(45,$point)
                $g.Transform = $m
    #>
                $ShowPRFbtn.Focus()
                $g.FillRegion($brushBg, $arrItem) 
                $g.ResetTransform()
            #        $arrItem.Intersect((New-Object System.Drawing.Rectangle 50 , 50, 100 , 100))
            #         $g.DrawRectangle($mypen, $point.X , $point.Y, 100 , 100) # draw a line
            }
            Else
            {
    <#  
                $m = new-object  System.Drawing.Drawing2D.Matrix
                $m.RotateAt(45,$point)
                $g.Transform = $m
    #>
                $g.FillRegion($ClearbrushBg, $arrItem) 

                $g.ResetTransform()
            }

        }  
    }
})

$DesktopGB.add_MouseUp({

    If ($show.Checked -or $show2.Checked -or $PolygonRB.Checked)
    {
        $Global:intIterate ++


        $mouse = [System.Windows.Forms.Cursor]::Position
        $point = $DesktopGB.PointToClient($mouse)
        $point.X = $point.X - 50
        $point.Y = $point.Y - 50
        #$test.Clear('window')

        #$region1 = new-object System.Drawing.Region(New-Object System.Drawing.Rectangle 10, 10, 100, 100)
        #$region1 = new-object System.Drawing.Region
        #$region1.Intersect((New-Object System.Drawing.Rectangle $point.X , $point.Y, 100 , 100))
        #write-host ($region1.GetRegionData()).Data
        $Test= ($ShapesGB.Controls | Where-Object -FilterScript {$_.Checked}).name

        switch (($ShapesGB.Controls | Where-Object -FilterScript {$_.Checked}).name)
        {
            'circle' {
            
                New-Variable -Force -Name "circle$Global:intIterate" -Value (new-object System.Drawing.Region)
                $thisButton = Get-Variable -ValueOnly -Include "circle$Global:intIterate"

                $myrect = New-Object System.Drawing.Rectangle $point.X , $point.Y, 100 , 100
                $myGP = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myGP.AddEllipse($myrect)
                $thisButton.Intersect($myGP)
                $thisButton | Add-Member NoteProperty 'Name' "circle$Global:intIterate"
                [void]$arrRegions.Add($thisButton)
#                $thisButton.Anchor = 'right'
#                $thisButton.Name = "circle$Global:intIterate"
 #               $thisButton.Text = "circle$Global:intIterate"
#                $thisButton = $DesktopGB.CreateGraphics()
            
                $g.PageUnit = 'pixel'     
                $g.InterpolationMode = 7   
                $g.FillRegion($brushBg, $thisButton)    
                $g.DrawEllipse($mypen, $point.X , $point.Y, 100 , 100) # draw a line
    #            $thisButton.DrawLine($mypen, $point.X, $point.Y, $point.X  , $point.Y+ 100) # draw a line
    #            $thisButton.DrawLine($mypen, $point.X, $point.Y+ 100, $point.X  + 100, $point.Y+ 100) # draw a line
    #            $thisButton.DrawLine($mypen, $point.X+ 100, $point.Y+ 100, $point.X  + 100, $point.Y) # draw a line       
            }
            'dimond' {
                $p1 = New-Object System.Drawing.Point ($point.X) , ($point.Y+50)
                $p2 = New-Object System.Drawing.Point ($point.X+50 ), ($point.Y)
                $p3 = New-Object System.Drawing.Point ($point.X+50) , ($point.Y)
                $p4 = New-Object System.Drawing.Point ($point.X+100 ), ($point.Y+50)
                $p5 = New-Object System.Drawing.Point ($point.X+100 ), ($point.Y+50)
                $p6 = New-Object System.Drawing.Point ($point.X+50 ), ($point.Y+100)
                $points = @($p1,$p2,$p3,$p4,$p5,$p6)
        #           New-Variable -Force -Name "newshape$intIterate" -Value (New-Object System.Windows.Forms.Button)
                New-Variable -Force -Name "dimond$Global:intIterate" -Value (new-object System.Drawing.Region)
                $thisButton = Get-Variable -ValueOnly -Include "dimond$Global:intIterate"
                $myrect = New-Object System.Drawing.Rectangle $point.X , $point.Y, 100 , 100
                $myGP = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myGP.AddPolygon($points)
                $thisButton.Intersect($myGP)

 #                  $points = @($p1,$p2) 
 #               $thisButton.Intersect((New-Object System.Drawing.Rectangle $point.X , $point.Y, 100 , 100))
 #               $thisButton | Add-Member NoteProperty 'Name' "dimond$Global:intIterate"
                [void]$arrRegions.Add($thisButton)
                
    #            $thisButton.Anchor = 'right'
    #            $thisButton.Name = "newshape$intIterate"
        #           $thisButton.Text = "newshape$intIterate"
            
                $g.PageUnit = 'pixel' 
                $g.InterpolationMode = 4
  #              $g.TranslateTransform(0 ,0)
 <# 
                $m = new-object  System.Drawing.Drawing2D.Matrix
                $m.RotateAt(45,$point)
                $g.Transform = $m
#>
                $g.FillRegion($brushBg, $thisButton)       
                $g.DrawPolygon($mypen,$points) # draw a line
    #            $g.DrawRectangle($mypen, $thisButton.GetBounds($g)) # draw a line

                $g.ResetTransform()  

            
            }
            'Square' {
                $p1 = New-Object System.Drawing.Point ($point.X-25) , ($point.Y+15)
                $p2 = New-Object System.Drawing.Point ($point.X+125 ), ($point.Y+15)
                $p3 = New-Object System.Drawing.Point ($point.X+125) , ($point.Y+85)
                $p4 = New-Object System.Drawing.Point ($point.X-25 ), ($point.Y+85)
                 $points = @($p1,$p2,$p3,$p4)
#                $points = @($p1,$p2,$p3,$p4,$p5,$p6)
        #           New-Variable -Force -Name "newshape$intIterate" -Value (New-Object System.Windows.Forms.Button)
                New-Variable -Force -Name "Square$Global:intIterate" -Value (new-object System.Drawing.Region)
                $thisButton = Get-Variable -ValueOnly -Include "Square$Global:intIterate"
                $myrect = New-Object System.Drawing.Rectangle $point.X , $point.Y, 100 , 100
                $myGP = New-Object System.Drawing.Drawing2D.GraphicsPath
                $myGP.AddPolygon($points)
                $thisButton.Intersect($myGP)
                [void]$arrRegions.Add($thisButton)
            
    #            $thisButton.Anchor = 'right'
    #            $thisButton.Name = "newshape$intIterate"
        #           $thisButton.Text = "newshape$intIterate"
            
                $g.PageUnit = 'pixel' 
                $g.InterpolationMode = 4
  #              $g.TranslateTransform(0 ,0)
 <# 
                $m = new-object  System.Drawing.Drawing2D.Matrix
                $m.RotateAt(45,$point)
                $g.Transform = $m
#>
                $g.FillRegion($brushBg, $thisButton)       
                $g.DrawPolygon($mypen,$points) # draw a line
    #            $g.DrawRectangle($mypen, $thisButton.GetBounds($g)) # draw a line

                $g.ResetTransform()  

            
            }
        }
    }

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

$Show = New-Object System.Windows.Forms.RadioButton
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
#$Show.Font = 'Microsoft Sans Serif,10'
#$Show.ForeColor = "#000"
#$Show.

$Show2 = New-Object System.Windows.Forms.RadioButton
$Show2.name = 'Dimond'
$image = [System.Drawing.Image]::FromFile("D:\ATE\IT\Root\images\VDimond.png")
$Show2.Image= $image
$Show2.ImageAlign = 'MiddleCenter'
$Show2.Location = New-Object System.Drawing.Size(20,200) 
$Show2.Appearance = 1
$Show2.FlatStyle = 2
#$Show.BackColor = "#d2d4d6"
#$Show.text = "sec square"
$Show2.width = 80
$Show2.height =80
$Show2.Padding = 5

$PolygonRB = New-Object System.Windows.Forms.RadioButton
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


$g = $DesktopGB.CreateGraphics()
$ShapesGB.Controls.Add($PolygonRB)
$ShapesGB.Controls.Add($Show)
$ShapesGB.Controls.Add($Show2)
$DesktopGB.Controls.Add($ShapesGB)
$DesktopGB.Controls.Add($ShowPRFbtn)
$form.Controls.Add($DesktopGB)
[void]$form.ShowDialog()   # display the dialog