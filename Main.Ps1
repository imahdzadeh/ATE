[void] [System.Windows.Forms.Application]::EnableVisualStyles()
$persianCalendar = New-Object System.Globalization.PersianCalendar
$gregorianDate = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Now,"Iran Standard Time")
# Convert the Gregorian date to Shamsi (Jalali) calendar
$shamsiYear = $persianCalendar.GetYear($gregorianDate)
$shamsiMonth = $persianCalendar.GetMonth($gregorianDate)
$shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)

$dataPanel = New-Object Windows.Forms.TableLayoutPanel
$dataPanel.BorderStyle = "None"
$dataPanel.add_paint({$whitePen = new-object System.Drawing.Pen([system.drawing.color]::white, 3)
$_.graphics.drawrectangle($whitePen,$this.clientrectangle)
})
$calendar = New-Object Windows.Forms.MonthCalendar -Property @{
    ShowTodayCircle   = $false
    MaxSelectionCount = 1
}

#$MainWindow.AutoSize = $true

$form = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 800, 600
    Text          =            $shamsiYear.ToString() + "/" + 
                               ($shamsiMonth = $persianCalendar.GetMonth($gregorianDate)) + "/" + 
                               ( $shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)).ToString() + "`t`t`t`t`t`t`t`t`t`t " + "پارس طوبی تکیه" 
    Topmost       = $true
}
$form.AutoScale = $false
# Define the size, title and background color             = 

$EmailGV = $null
$EmailGV = New-Object System.Windows.Forms.DataGridView
$EmailGV.Size=New-Object System.Drawing.Size(429,350)
$EmailGV.ColumnCount = 3
$EmailGV.Columns[1].width = 208
$EmailGV.RowHeadersVisible = $false
$EmailGV.ColumnHeadersVisible = $false


Import-Csv 'C:\Users\Isar\Desktop\powershell\emails.csv' | foreach {
    $EmailGV.Rows.Add($_.from,$_.subject,$_.time) | out-null
#    $EmailGV.Rows.Add($_.item[0].value) | out-    
}


$img3 = [System.Drawing.Image]::Fromfile('C:\Users\Isar\Desktop\powershell\img3.png')
$circlepath = [System.Drawing.Image]::Fromfile('C:\Users\Isar\Desktop\powershell\circle.png')

$pictureBox2 = new-object Windows.Forms.PictureBox
$pictureBox2.Image = $img3
$pictureBox2.SizeMode = "StretchImage"
$pictureBox2.Location = New-Object System.Drawing.size(7,10)
$pictureBox2.Size = New-Object System.Drawing.Size(25,25)

$circle = new-object Windows.Forms.PictureBox
$circle.Image = $circlepath
$circle.SizeMode = "StretchImage"
$circle.Location = New-Object System.Drawing.size(31,30)
$circle.Size = New-Object System.Drawing.Size(7,7)

$GBChat = New-Object system.Windows.Forms.Groupbox
$GBChat.Size = New-Object System.Drawing.Size(222,239)

$GBemail = New-Object system.Windows.Forms.Groupbox
$GBemail.Size = New-Object System.Drawing.Size(120,400)
#$GBemail.Location = New-Object System.Drawing.point(31,30)
#$GBemail.AutoSize = $true

#$GBChat.text = ""
#$GBChat.Dock = [System.Windows.Forms.DockStyle]::bottom

#$GBChat.BackColor = 'black'

#$GBChat.Location = New-Object System.Drawing.Point(20,20)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(5,40)
$listBox.Size = New-Object System.Drawing.Size(214,400)
$listBox.Height = 200

[void] $listBox.Items.Add('User1')
[void] $listBox.Items.Add('Ali')
[void] $listBox.Items.Add('User3')
[void] $listBox.Items.Add('Matyma')
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
$EmailLB.Location = New-Object System.Drawing.Point(2,36)
$EmailLB.Size = New-Object System.Drawing.Size(116,300)
$EmailLB.Height = 316
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
$Chatlabel.Location = New-Object System.Drawing.size(32,12)
$Chatlabel.Size = New-Object System.Drawing.Size(25,15)
$Chatlabel.Text = $env:USERNAME

$Chatstatus = New-Object System.Windows.Forms.Label
$Chatstatus.Location = New-Object System.Drawing.size(38,28)
$Chatstatus.Size = New-Object System.Drawing.Size(30,25)
$Chatstatus.Text = 'حاضر'

$GBChat.Controls.Add($listBox)
$GBChat.Controls.Add($Chatlabel)
$GBChat.Controls.Add($pictureBox2)
$GBChat.Controls.Add($Chatstatus)
$GBChat.Controls.Add($circle)



$Panel = New-Object System.Windows.Forms.TableLayoutPanel
$panel.Dock = "Fill"
$panel.ColumnCount = 1
$panel.RowCount = 1
$panel.CellBorderStyle = "single"
$panel.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
$panel.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))

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
$objTextBox1.RightToLeft
$groupBox4.Controls.Add($objLabel2)
$groupBox4.Controls.Add($NewsLB)

$AddPrinterBtn                   = New-Object system.Windows.Forms.Button
$AddPrinterBtn.Anchor            = 'right'
$AddPrinterBtn.BackColor         = "#d2d4d6"
$AddPrinterBtn.text              = "امور پرسنلی"
$AddPrinterBtn.width             = 215
$AddPrinterBtn.height            = 50
#$AddPrinterBtn.location          = New-Object System.Drawing.Point(370,250)
$AddPrinterBtn.Font              = 'Microsoft Sans Serif,10'
$AddPrinterBtn.ForeColor         = "#000"

$ComposeBtn                   = New-Object system.Windows.Forms.Button
$ComposeBtn.Location = New-Object System.Drawing.Size(5,10)
#$ComposeBtn.Anchor            = 'right'
$ComposeBtn.BackColor         = "#d2d4d6"
$ComposeBtn.text              = "Compose"
$ComposeBtn.width             = 110
$ComposeBtn.height            = 25
#$ComposeBtn.location          = New-Object System.Drawing.Point(370,250)
$ComposeBtn.Font              = 'Microsoft Sans Serif,10'
$ComposeBtn.ForeColor         = "#000"

$DesktopBtn                      = New-Object system.Windows.Forms.Button
$DesktopBtn.Anchor            = 'right'
$DesktopBtn.BackColor         = "#d2d4d6"
$DesktopBtn.text              = "میز کار"
$DesktopBtn.width             = 215
$DesktopBtn.height            = 50
#$AddPrinterBtn.location          = New-Object System.Drawing.Point(370,250)
$DesktopBtn.Font              = 'Microsoft Sans Serif,10'
$DesktopBtn.ForeColor         = "#000"



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
#$form.Controls.Add($objLabel)
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
#$tableLayoutPanel2.BackColor = 'blue'
$tableLayoutPanel2.Dock = [System.Windows.Forms.DockStyle]::bottom
$tableLayoutPanel2.AutoSize = $true
#$tableLayoutPanel2.Location = New-Object System.Drawing.Size(220,10)

$tableLayoutPanel1 = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel1.RowCount = 2
$tableLayoutPanel1.ColumnCount = 1
#$tableLayoutPanel1.Controls.Add($groupBox1, 1, 0);
$tableLayoutPanel1.Controls.Add($AddPrinterBtn, 0, 0);
$tableLayoutPanel1.Controls.Add($DesktopBtn, 0, 1);
#$tableLayoutPanel1.Controls.Add($groupBox3, 0, 2);
#$tableLayoutPanel1.Controls.Add(, 2, 2);
$tableLayoutPanel1.Dock = [System.Windows.Forms.DockStyle]::bottom
#$tableLayoutPanel1.BackColor = 'gray'
$tableLayoutPanel1.AutoSize= $true

$tableLayoutPanel3 = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel3.RowCount = 1
$tableLayoutPanel3.ColumnCount = 1
$tableLayoutPanel3.Size = New-Object System.Drawing.Size(200,250)
$tableLayoutPanel3.Controls.Add($GBChat, 0, 0);
#$tableLayoutPanel3.BackColor = 'red'
$tableLayoutPanel3.Dock = [System.Windows.Forms.DockStyle]::top
#$tableLayoutPanel3.AutoSize = $true

$tableLayoutPanel4 = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel4.RowCount = 1
$tableLayoutPanel4.ColumnCount = 2
#$tableLayoutPanel4.AutoSize = $true
$tableLayoutPanel4
$tableLayoutPanel4.Size = New-Object System.Drawing.Size(560,200)
$tableLayoutPanel4.Controls.Add($GBemail, 0, 0);
$tableLayoutPanel4.Controls.Add($EmailGV, 1, 0);
#$tableLayoutPanel4.BackColor = 'green'
$tableLayoutPanel4.Dock = [System.Windows.Forms.DockStyle]::right
#$tableLayoutPanel4.AutoSize = $true



$form.controls.Add($tableLayoutPanel1)

$form.controls.Add($tableLayoutPanel3)
$form.controls.Add($tableLayoutPanel4)
$form.controls.Add($tableLayoutPanel2)
#$panel.Dock = [System.Windows.Forms.DockStyle]::fill

#$form.BackColor='yellow'

#$form.controls.add($tableLayoutPanel2)

#$form.controls.add($Panel)

[void]$Form.ShowDialog()