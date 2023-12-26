# Created by Isar Mahdzadeh
# Decmeber 12 2023
#
. "$(Split-Path $PSScriptRoot -Parent)\config\$(($PSCommandPath.Split('\') | select -last 1) -replace ('.ps1$','Conf.ps1'))"

Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
function Show-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 4)
}
function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0)
}
 

[void] [System.Windows.Forms.Application]::EnableVisualStyles()
$persianCalendar = New-Object System.Globalization.PersianCalendar
$gregorianDate = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Now,"Iran Standard Time")
# Convert the Gregorian date to Shamsi (Jalali) calendar
$shamsiYear = $persianCalendar.GetYear($gregorianDate)
$shamsiMonth = $persianCalendar.GetMonth($gregorianDate)
$shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)
<#
$dataPanel = New-Object Windows.Forms.TableLayoutPanel
$dataPanel.BorderStyle = "None"
$dataPanel.add_paint({$whitePen = new-object System.Drawing.Pen([system.drawing.color]::white, 3)
$_.graphics.drawrectangle($whitePen,$this.clientrectangle)
})
#>
$calendar = New-Object Windows.Forms.MonthCalendar -Property @{
    ShowTodayCircle   = $false
    MaxSelectionCount = 1
}

#$MainWindow.AutoSize = $true
<#
$Mainform = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 800, 600
    Text          =            $shamsiYear.ToString() + "/" + 
                               ($shamsiMonth = $persianCalendar.GetMonth($gregorianDate)) + "/" + 
                               ( $shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)).ToString() + "`t`t`t`t`t`t`t`t`t`t" + "مهد پویان اطلس" 
    Topmost       = $true
}
$Secoform = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 800, 600
    Text          =            $shamsiYear.ToString() + "/" + 
                               ($shamsiMonth = $persianCalendar.GetMonth($gregorianDate)) + "/" + 
                               ( $shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)).ToString() + "`t`t`t`t`t`t`t`t`t`t" + "مهد پویان اطلس" 
    Topmost       = $true
}
#>
$Secoform.AutoScale = $false
$Mainform.AutoScale = $false
# Define the size, title and background color             = 

$EmailGV = $null
$EmailGV = New-Object System.Windows.Forms.DataGridView
$EmailGV.Size=New-Object System.Drawing.Size(595,350)
$EmailGV.Location = New-Object System.Drawing.size(25,50)
$EmailGV.ColumnCount = 3
$EmailGV.Columns[0].width = 180
$EmailGV.Columns[1].width = 325
$EmailGV.Columns[2].width = 70
$EmailGV.RowHeadersVisible = $false
$EmailGV.ColumnHeadersVisible = $false
$EmailGV.SelectionMode = 'FullRowSelect'
$EmailGV.AllowUserToResizeColumns = $false
$EmailGV.AllowUserToResizeRows = $false

Try{
    Import-Csv 'C:\Users\Isar\Desktop\powershell\emails.csv' | foreach {
        $EmailGV.Rows.Add($_.from,$_.subject,$_.time) | out-null
    #    $EmailGV.Rows.Add($_.item[0].value) | out-    
    }
}
Catch
{

}


$img3 = [System.Drawing.Image]::Fromfile('C:\Users\Isar\Desktop\powershell\img3.png')
$avatar = [System.Drawing.Image]::Fromfile('D:\ate\IT\Root\images\avatar.png')
$GH = [System.Drawing.Image]::Fromfile('D:\ate\IT\Root\images\pop.png')


$pictureBox2 = new-object Windows.Forms.PictureBox
$pictureBox2.Image = $img3
$pictureBox2.SizeMode = "StretchImage"
$pictureBox2.Location = New-Object System.Drawing.size(7,10)
$pictureBox2.Size = New-Object System.Drawing.Size(25,25)
$pictureBox2.BackColor = 'green'

$circle = new-object Windows.Forms.PictureBox
$circle.Image = $circlepath
$circle.SizeMode = "StretchImage"
$circle.Location = New-Object System.Drawing.size(31,30)
$circle.Size = New-Object System.Drawing.Size(7,7)

$circle2 = new-object Windows.Forms.PictureBox
$circle2.Image = $circlepath
$circle2.SizeMode = "StretchImage"
$circle2.Location = New-Object System.Drawing.size(31,30)
$circle2.Size = New-Object System.Drawing.Size(7,7)

$GBChat = New-Object system.Windows.Forms.Groupbox
$GBChat.Size = New-Object System.Drawing.Size(100,239)

$GBemail = New-Object system.Windows.Forms.Groupbox
$GBemail.Size = New-Object System.Drawing.Size(80,400)
$GBemail.Location = New-Object System.Drawing.point(31,0)
#$GBemail.BackColor = 'red'
#$GBemail.AutoSize = $true

#$GBChat.text = ""
#$GBChat.Dock = [System.Windows.Forms.DockStyle]::bottom

#$GBChat.BackColor = 'black'

#$GBChat.Location = New-Object System.Drawing.Point(20,20)

$listBox_DrawItem={
 param(
  [System.Object] $sender, 
  [System.Windows.Forms.DrawItemEventArgs] $e
 )
   #Suppose Sender de type Listbox
 if ($Sender.Items.Count -eq 0) {return}
 
   #Suppose item de type String
 $lbItem=$Sender.Items[$e.Index]
 
 
 #if ( $lbItem -match 'locked$')  
 #{ 
 
 
    If ($e.Index -lt 8)
    {
        $Color=[System.Drawing.Color]::green       
    }
    Else
    {
        $Color=[System.Drawing.Color]::red       
    }
    try
    {
      $brush = new-object System.Drawing.SolidBrush($Color)
      $test = $lbItem.length
  #    $e.Graphics.FillRectangle($brush, $e.Bounds)

   If($lbItem -contains 'Gholamreza')
   {
        $e.Graphics.DrawImage($Gh,0,$e.Bounds.Y+2.5,25,25)
         $e.Graphics.FillEllipse($brush,18,$e.Bounds.Y+21,8,8)
   }
   Else
   {
        $e.Graphics.DrawImage($avatar,0,$e.Bounds.Y+2.5,25,25)
   } 

 #     $e.Graphics.DrawImage($GH,0,$e.Bounds.Y+2.5,30,30)
#     $e.Graphics.DrawImage($circlepath,0,$e.Bounds.Y+2.5,30,30)
    
     
     
    }
    finally
    {
      $brush.Dispose()
    }
  # }
 #$e.Graphics.DrawString($lbItem, $e.Font, [System.Drawing.SystemBrushes]::ControlText, (new-object System.Drawing.PointF($e.Bounds.X, $e.Bounds.Y)))
 $Yp = ($e.Bounds.Y) + 18 
 $e.Graphics.DrawString($lbItem, $e.Font, [System.Drawing.SystemBrushes]::ControlText, (new-object System.Drawing.PointF(25, $Yp)))
}
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(5,40)
$listBox.Size = New-Object System.Drawing.Size(214,400)
$listBox.Height = 200
$listbox.FormattingEnabled = $True

$listbox.TabIndex = 4
$listBox.DrawMode = [System.Windows.Forms.DrawMode]::OwnerDrawFixed
$listbox.DataBindings.DefaultDataSourceUpdateMode = 0
$listBox.ItemHeight = 32
$listBox.Add_DrawItem($listBox_DrawItem)
#$listbox.add_Click($action_si_click_sur_VMKO)

[void] $listBox.Items.Add('Gholamreza')
[void] $listBox.Items.Add('User1')
[void] $listBox.Items.Add('Ali')
[void] $listBox.Items.Add('User3')
[void] $listBox.Items.Add('tesduser')
[void] $listBox.Items.Add('chatuser')
[void] $listBox.Items.Add('group')
[void] $listBox.Items.Add('user12')
[void] $listBox.Items.Add('offile')
[void] $listBox.Items.Add('usr5')
[void] $listBox.Items.Add('echo')
[void] $listBox.Items.Add('noname')
[void] $listBox.Items.Add('noname')
[void] $listBox.Items.Add('noname')
[void] $listBox.Items.Add('noname')
[void] $listBox.Items.Add('noname')
#$listBox.Controls.Add($circle)
#$listBox.Items[2].



$NewsLB = New-Object System.Windows.Forms.ListBox
$NewsLB.Location = New-Object System.Drawing.Point(5,30)
$NewsLB.Size = New-Object System.Drawing.Size(510,50)
$NewsLB.Height = 172

[void] $NewsLB.Items.Add('Google News is a news aggregator service developed by Google')
[void] $NewsLB.Items.Add('')
[void] $NewsLB.Items.Add('It presents a continuous flow of links to articles organized from thousands of publishers and magazines')
[void] $NewsLB.Items.Add('')
[void] $NewsLB.Items.Add('PowerShell is a task automation and configuration management program from Microsoft')

$EmailLB = New-Object System.Windows.Forms.ListBox
$EmailLB.Location = New-Object System.Drawing.Point(2,25)
$EmailLB.Size = New-Object System.Drawing.Size(80,300)
$EmailLB.Height = 329
[void] $EmailLB.Items.Add('Inbox')
[void] $EmailLB.Items.Add('')
[void] $EmailLB.Items.Add('Drafts')
[void] $EmailLB.Items.Add('')
[void] $EmailLB.Items.Add('Sent')
[void] $EmailLB.Items.Add('')
[void] $EmailLB.Items.Add('Archive')
[void] $EmailLB.Items.Add('')
[void] $EmailLB.Items.Add('Spam')
[void] $EmailLB.Items.Add('')
[void] $EmailLB.Items.Add('Trash')

$Chatlabel = New-Object System.Windows.Forms.Label
$Chatlabel.Location = New-Object System.Drawing.size(33,25)
$Chatlabel.Size = New-Object System.Drawing.Size(25,15)
$Chatlabel.Text = $env:USERNAME

$Chatstatus = New-Object System.Windows.Forms.Label
$Chatstatus.Location = New-Object System.Drawing.size(70,26)
$Chatstatus.Size = New-Object System.Drawing.Size(30,25)
$Chatstatus.Text = 'حاضر'

$GBChat.Controls.Add($listBox)
$GBChat.Controls.Add($Chatlabel)
$GBChat.Controls.Add($pictureBox2)
$GBChat.Controls.Add($Chatstatus)
#$GBChat.Controls.Add($circle)

$calendar.Location = New-Object System.Drawing.Size(10,20)

$Groupbox3 = New-Object system.Windows.Forms.Groupbox
$Groupbox3.text = "Group Box3"

$Groupbox4 = New-Object system.Windows.Forms.Groupbox
#$Groupbox4.text = "Group Box4"
$Groupbox4.Dock = [System.Windows.Forms.DockStyle]::fill
$objLabel2 = New-Object System.Windows.Forms.label
$objLabel2.Location = New-Object System.Drawing.Size(220,10)
$objLabel2.Size = New-Object System.Drawing.Size(130,10)
$objLabel2.BackColor = "Transparent"
#$objLabel2.ForeColor = "black"
$objLabel2.Text = "نمایه ها"
$objTextBox1 = New-Object System.Windows.Forms.TextBox
$objTextBox1.Location = New-Object System.Drawing.Size(30,30)
$objTextBox1.Multiline = $True
$objTextBox1.Scrollbars = "vertical"
$objTextBox1.AutoSize = $true
$objTextBox1.Text = 'Google News is a news aggregator service developed by Google. `n sdfsdfsdfsfd'
$objTextBox1.Dock = [System.Windows.Forms.DockStyle]::fill
$groupBox4.Controls.Add($objLabel2)
$groupBox4.Controls.Add($NewsLB)

$AddPrinterBtn                   = New-Object system.Windows.Forms.Button
$AddPrinterBtn.Anchor            = 'right'
$AddPrinterBtn.BackColor         = "#d2d4d6"
$AddPrinterBtn.text              = "امور پرسنلی"
$AddPrinterBtn.width             = 100
$AddPrinterBtn.height            = 35
#$AddPrinterBtn.location          = New-Object System.Drawing.Point(370,250)
$AddPrinterBtn.Font              = 'Microsoft Sans Serif,10'
$AddPrinterBtn.ForeColor         = "#000"

$Settings                   = New-Object system.Windows.Forms.Button
$Settings.Anchor            = 'right'
$Settings.BackColor         = "#d2d4d6"
$Settings.text              = "تنظیمات"
$Settings.width             = 100
$Settings.height            = 35
#$Settings.location          = New-Object System.Drawing.Point(370,250)
$Settings.Font              = 'Microsoft Sans Serif,10'
$Settings.ForeColor         = "#000"

$ComposeBtn                   = New-Object system.Windows.Forms.Button
$ComposeBtn.Location = New-Object System.Drawing.Size(1,0)
#$ComposeBtn.Anchor            = 'right'
#$ComposeBtn.BackColor         = "#d2d4d6"
$ComposeBtn.text              = "Compose"
$ComposeBtn.width             = 80
$ComposeBtn.height            = 25
#$ComposeBtn.location          = New-Object System.Drawing.Point(370,250)
$ComposeBtn.Font              = 'Microsoft Sans Serif,10'
$ComposeBtn.ForeColor         = "#000"

$DesktopBtn                      = New-Object system.Windows.Forms.Button
$DesktopBtn.Anchor            = 'right'
$DesktopBtn.BackColor         = "#d2d4d6"
$DesktopBtn.text              = "میز کار"
$DesktopBtn.width             = 100
$DesktopBtn.height            = 35
#$AddPrinterBtn.location          = New-Object System.Drawing.Point(370,250)
$DesktopBtn.Font              = 'Microsoft Sans Serif,10'
$DesktopBtn.ForeColor         = "#000"
$DesktopBtn.Add_Click({

    # Call Sub menu 1
    $Mainform.Close()
    $Mainform.Dispose()
 #   $Secoform.Topmost = $True
 #   $Secoform.Add_Shown({$ADBox.Activate()})
 #   [void] $Secoform.ShowDialog()
    # Call Sub menu 1
 #   $MenuBox.Close()
 #   $MenuBox.Dispose()
 #   $ADBox.Topmost = $True
    #$SecoForm.Add_Shown({$SecoForm.Activate()})
<#
$Secoform = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 800, 600
    Text          =            $shamsiYear.ToString() + "/" + 
                               ($shamsiMonth = $persianCalendar.GetMonth($gregorianDate)) + "/" + 
                               ( $shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)).ToString() + "`t`t`t`t`t`t`t`t`t`t" + "پارس طوبی تکیه" 
    Topmost       = $true
}
$Secoform.AutoScale = $false
    [void] $SecoForm.Show()
#>


& D:\ATE\IT\Root\Main\Desktop.ps1
})

$MainPanel = New-Object System.Windows.Forms.TableLayoutPanel
$MainPanel.Dock = "Fill"
$MainPanel.ColumnCount = 1
$MainPanel.BackColor='yellow'
$MainPanel.RowCount = 1
$MainPanel.CellBorderStyle = "single"
$MainPanel.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
$MainPanel.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))

$groupBox1 = New-Object System.Windows.Forms.GroupBox
$groupBox1.Size = New-Object Drawing.Size 250, 200
#$groupBox1.text = "تقویم"
#$groupBox1.backcolor = "#cfd0d1"
$objLabel = New-Object System.Windows.Forms.label
$objLabel.Location = New-Object System.Drawing.Size(220,10)
$objLabel.Size = New-Object System.Drawing.Size(130,15)
$objLabel.BackColor = "Transparent"
$objLabel.ForeColor = "black"
$objLabel.Text = "تقویم"
#$objLabel.Anchor = 'left,top'
$groupBox1.Controls.Add($objLabel)
$groupBox1.Controls.Add($calendar)
#$Mainform.Controls.Add($objLabel)
#$panel.controls.AddRange(@($Groupbox3))
$groupBox2 = New-Object System.Windows.Forms.GroupBox
$groupBox2.Controls.Add($AddPrinterBtn)

$GBemail.Controls.Add($ComposeBtn)
$GBemail.Controls.Add($EmailLB)

$tableLayoutPanel2 = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel2.RowCount = 1
$tableLayoutPanel2.ColumnCount = 2
$tableLayoutPanel2.Controls.Add($groupBox1, 0, 0);
$tableLayoutPanel2.Controls.Add($groupBox4, 1, 0);
$tableLayoutPanel2.BackColor = 'blue'
$tableLayoutPanel2.Dock = [System.Windows.Forms.DockStyle]::bottom
$tableLayoutPanel2.AutoSize = $true
#$tableLayoutPanel2.Location = New-Object System.Drawing.Size(220,10)

$tableLayoutPanel1 = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel1.RowCount = 3
$tableLayoutPanel1.ColumnCount = 1
#$tableLayoutPanel1.Controls.Add($groupBox1, 1, 0);
$tableLayoutPanel1.Controls.Add($AddPrinterBtn, 0, 0);
$tableLayoutPanel1.Controls.Add($DesktopBtn, 0, 1);
$tableLayoutPanel1.Controls.Add($Settings, 0, 2);
#$tableLayoutPanel1.Controls.Add($groupBox3, 0, 2);
#$tableLayoutPanel1.Controls.Add(, 2, 2);
$tableLayoutPanel1.Dock = [System.Windows.Forms.DockStyle]::bottom
$tableLayoutPanel1.BackColor = 'orange'
$tableLayoutPanel1.AutoSize= $true

$tableLayoutPanel3 = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel3.RowCount = 1
$tableLayoutPanel3.ColumnCount = 1
$tableLayoutPanel3.Size = New-Object System.Drawing.Size(150,250)
$tableLayoutPanel3.Controls.Add($GBChat, 0, 0);
$tableLayoutPanel3.BackColor = 'red'
$tableLayoutPanel3.Dock = [System.Windows.Forms.DockStyle]::top
$tableLayoutPanel3.AutoSize = $true

$tableLayoutPanel4 = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel4.RowCount = 1
$tableLayoutPanel4.ColumnCount = 2
$tableLayoutPanel4.AutoSize = $true

$tableLayoutPanel4.Size = New-Object System.Drawing.Size(690,200)
$tableLayoutPanel4.Controls.Add($GBemail, 0, 0);
$tableLayoutPanel4.Controls.Add($EmailGV, 1, 0);
$tableLayoutPanel4.BackColor = 'green'
$tableLayoutPanel4.Dock = [System.Windows.Forms.DockStyle]::right
$tableLayoutPanel4.AutoSize = $true

#$MainPanel.Controls.Add($tableLayoutPanel1,0,0)
#$MainPanel.Controls.Add($tableLayoutPanel2,0,0)
#$MainPanel.Controls.Add($tableLayoutPanel3,0,0)
#$MainPanel.Controls.Add($tableLayoutPanel4,0,0)

$Mainform.controls.Add($tableLayoutPanel1)
$Mainform.controls.Add($tableLayoutPanel3)
$Mainform.controls.Add($tableLayoutPanel4)
$Mainform.controls.Add($tableLayoutPanel2)
#$panel.Dock = [System.Windows.Forms.DockStyle]::fill

#$Mainform.controls.Add($MainPanel)

#$Mainform.BackColor='yellow'

#$Mainform.controls.add($tableLayoutPanel2)
$Mainform.FormBorderStyle = 'FixedDialog'
$Mainform.MaximizeBox = $false
$Secoform.FormBorderStyle = 'FixedDialog'
$Secoform.MaximizeBox = $false
#$Mainform.controls.add($Panel)
Hide-Console
[void]$Mainform.ShowDialog()

#$Mainform.Dispose()