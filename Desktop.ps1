Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$persianCalendar = New-Object System.Globalization.PersianCalendar
$gregorianDate = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Now,"Iran Standard Time")
# Convert the Gregorian date to Shamsi (Jalali) calendar
$shamsiYear = $persianCalendar.GetYear($gregorianDate)
$shamsiMonth = $persianCalendar.GetMonth($gregorianDate)
$shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)

$Mainform = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 800, 600
    Text          =            $shamsiYear.ToString() + "/" + 
                               ($shamsiMonth = $persianCalendar.GetMonth($gregorianDate)) + "/" + 
                               ( $shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)).ToString() + "`t`t`t`t`t`t`t`t`t`t" + "پارس طوبی تکیه" 
    Topmost       = $false
}

$Panel = New-Object System.Windows.Forms.TableLayoutPanel
$panel.Dock = "Fill"
#$panel.Anchor = 'right'
#$panel.ColumnCount = 1
$panel.BackColor='green'
#$panel.RowCount = 1
$panel.CellBorderStyle = "single"
$panel.AutoSize = $true
#$panel.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
#$panel.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 50)))
#$panel.Margin.Top = 50
#$panel.Margin.Right = 10
#$panel.Padding = 10

<#
$AddPrinterBtn                   = New-Object system.Windows.Forms.Button
$AddPrinterBtn.Anchor            = 'right'
$AddPrinterBtn.BackColor         = "#d2d4d6"
$AddPrinterBtn.text              = "امور پرسنلی"
$AddPrinterBtn.width             = 100
$AddPrinterBtn.height            = 35
#$AddPrinterBtn.location          = New-Object System.Drawing.Point(370,250)
$AddPrinterBtn.Font              = 'Microsoft Sans Serif,10'
$AddPrinterBtn.ForeColor         = "#000"

#>
$Settings                   = New-Object system.Windows.Forms.Button
$Settings.Anchor            = 'right'
$Settings.BackColor         = "#d2d4d6"
$Settings.text              = "تنظیمات"
$Settings.width             = 100
$Settings.height            = 35
#$Settings.location          = New-Object System.Drawing.Point(370,250)
$Settings.Font              = 'Microsoft Sans Serif,10'
$Settings.ForeColor         = "#000"
$Settings.Anchor = 'top,right'

$ComposeBtn                   = New-Object system.Windows.Forms.Button
$ComposeBtn.Location = New-Object System.Drawing.Size(1,0)
$ComposeBtn.Anchor            = 'right'
#$ComposeBtn.BackColor         = "#d2d4d6"
$ComposeBtn.text              = "Compose"
$ComposeBtn.width             = 80
$ComposeBtn.height            = 25
#$ComposeBtn.location          = New-Object System.Drawing.Point(370,250)
$ComposeBtn.Font              = 'Microsoft Sans Serif,10'
$ComposeBtn.ForeColor         = "#000"

$MainGB = New-Object system.Windows.Forms.Groupbox
$MainGB.AutoSize = $true
$MainGB.Dock = [System.Windows.Forms.DockStyle]::fill
$MainGB.text = "میز کار"
#$MainGB.BackColor = 'red'
$MainGB.Margin.Top = 100
$MainGB.Padding = 10
#$xml.OuterXml
#$xml = Import-Clixml -Path 'D:\HST\IT\Root\sample.xml'

#$AddPrinterBtn = [System.Management.Automation.PSSerializer]::Deserialize('D:\HST\IT\Root\sample.xml')
#$AddPrinterBtn | Get-Member
#$MyRawString = Get-Content -Raw 'D:\HST\IT\Root\sample.xml'
#$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $false
#[System.IO.File]::WriteAllLines('D:\HST\IT\Root\sample.xml', $MyRawString, $Utf8NoBomEncoding)
$test = Import-Clixml -Path 'D:\HST\IT\Root\sample.xml'
#$test = Get-Content -Path 'D:\HST\IT\Root\sample.xml'
#$AddPrinterBtn = [System.Management.Automation.PSSerializer]::Deserialize('D:\HST\IT\Root\sample.xml')
#$test | Get-Member
#$MainGB.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
#$MainGB.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))

$NewsLB = New-Object System.Windows.Forms.ListBox
$NewsLB.Location = New-Object System.Drawing.Point(5,30)
$NewsLB.Size = New-Object System.Drawing.Size(510,50)
$NewsLB.Height = 172

$test1 = 1

$Chatlabel = New-Object System.Windows.Forms.Label
$Chatlabel.Location = New-Object System.Drawing.size(33,25)
$Chatlabel.Size = New-Object System.Drawing.Size(25,15)
$Chatlabel.Text = $env:USERNAME
#& 'D:\HST\IT\Root\DeskPool1213.ps1'
#$SecoForm.Controls.Add($textBox)
#$EmailGV = New-Object System.Windows.Forms.DataGridView
$tableLayoutPanel1 = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel1.RowCount = 3
$tableLayoutPanel1.ColumnCount = 1
#$tableLayoutPanel1.Controls.Add($groupBox1, 1, 0);
$tableLayoutPanel1.Controls.Add($NewsLB, 0, 0);
$tableLayoutPanel1.Controls.Add($Chatlabel, 0, 1);
#$tableLayoutPanel1.BackColor='gray'

#$tableLayoutPanel1.Controls.Add($groupBox3, 0, 2);
#$tableLayoutPanel1.Controls.Add(, 2, 2);
$tableLayoutPanel1.Dock = [System.Windows.Forms.DockStyle]::top
#$tableLayoutPanel1.BackColor = 'gray'
$tableLayoutPanel1.AutoSize= $true



$EmailGV = New-Object System.Windows.Forms.DataGridView
$EmailGV.Size=New-Object System.Drawing.Size(595,350)
$EmailGV.Location = New-Object System.Drawing.size(150,150)
$EmailGV.ColumnCount = 2
$EmailGV.Columns[1].width = 492
$EmailGV.Columns[0].width =100
$EmailGV.RowHeadersVisible = $false
#$EmailGV.ColumnHeadersVisible = $false
$EmailGV.SelectionMode = 'FullRowSelect'
$EmailGV.AllowUserToResizeColumns = $false
$EmailGV.AllowUserToResizeRows = $false
$EmailGV.Columns[1].HeaderText = 'شناسه'
$EmailGV.Columns[0].HeaderText = 'وضعیت'
$EmailGV.AllowUserToAddRows = $false
$EmailGV.ReadOnly = $true
$EmailGV.ColumnHeadersDefaultCellStyle.Alignment = [System.Drawing.ContentAlignment]::MiddleCenter
$EmailGV.DefaultCellStyle.Alignment = [System.Drawing.ContentAlignment]::bottomright
$EmailGV.AllowUserToOrderColumns = $false
$EmailGV.RowHeadersWidthSizeMode = 1
#$EmailGV.AutoSizeRowsMode = $false
$EmailGV.ColumnHeadersHeightSizeMode = 1
$EmailGV.EnableHeadersVisualStyles = $false
#$EmailGV.DefaultCellStyle.SelectionBackColor= $EmailGV.DefaultCellStyle.BackColor
#$EmailGV.DefaultCellStyle.SelectionForeColor= $EmailGV.DefaultCellStyle.ForeColor
$EmailGV.ColumnHeadersDefaultCellStyle.SelectionBackColor='window'
#$EmailGV.DefaultCellStyle.BackColor
#$EmailGV.DefaultCellStyle.ForeColor
foreach ($datagridviewcolumn in $EmailGV.columns) {
    $datagridviewcolumn.sortmode = 0
}


$Array = New-Object System.Collections.ArrayList
$Array.add('AAA')
$Array.add('BBB')
$Array.add('CCC')
$Array.add('DDD')
 $Test= 0
foreach ($item in $Array) {
    $test = $test + 1
  New-Variable -Force -Name "button$test" -Value (New-Object System.Windows.Forms.Button)
  $thisButton = Get-Variable -ValueOnly -Include "button$test"
  $thisButton.Location = New-Object System.Drawing.Size(175,(35+26*$test))
  $thisButton.Size = New-Object System.Drawing.Size(250,23)
  $thisButton.Text = $item
  $thisButton.Add_Click({Write-Host $thisButton.Text}.GetNewClosure())
  #$thisButton.Add_Click({param($Sender,$EventArgs) Write-Host $Sender.Text})

  $panel.Controls.Add($thisButton)
}

#$Mainform.Controls.Add($Chatlabel)
#$Mainform.Controls.Add($MainGB)
#$panel.Controls.Add($MainGB)
#$MainGB.Controls.Add($panel)
<#
$test = [System.Management.Automation.PSSerializer]::serialize($test)
$AddPrinterBtn = [System.Management.Automation.PSSerializer]::deserialize($test)
$AddPrinterBtn = New-Object $AddPrinterBtn
#>
#$panel.Controls.Add($EmailGV)
#$AddPrinterBtn.BackColor = 'red'
$panel.Controls.Add($AddPrinterBtn)
$panel.Controls.Add($Settings)
$Mainform.Controls.Add($panel)
$Mainform.BackColor = 'green'

#$Mainform.Controls.Add($EmailGVNew)
[void] $Mainform.ShowDialog()