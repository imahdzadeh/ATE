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

$NewsLB = New-Object System.Windows.Forms.ListBox
$NewsLB.Location = New-Object System.Drawing.Point(5,30)
$NewsLB.Size = New-Object System.Drawing.Size(510,50)
$NewsLB.Height = 172

$Chatlabel = New-Object System.Windows.Forms.Label
$Chatlabel.Location = New-Object System.Drawing.size(33,25)
$Chatlabel.Size = New-Object System.Drawing.Size(25,15)
$Chatlabel.Text = $env:USERNAME
#& 'D:\HST\IT\Root\DeskPool1213.ps1'
#$SecoForm.Controls.Add($textBox)

#$EmailGV = New-Object System.Windows.Forms.DataGridView

#$MyRawString = Get-Content -Raw 'D:\HST\IT\Root\sample.xml'
#$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $false
#[System.IO.File]::WriteAllLines('D:\HST\IT\Root\sample.xml', $MyRawString, $Utf8NoBomEncoding)
$EmailGV = Import-Clixml -Path 'D:\HST\IT\Root\sample.xml'
#$EmailGV = [System.Management.Automation.PSSerializer]::Deserialize($test)
$EmailGV.Columns[1].HeaderText
$EmailGVNew = New-Object $EmailGV

#$EmailGV = New-Object System.Windows.Forms.DataGridView

##$EmailGVNew.Size=$EmailGV.Size
#$EmailGVNew.Location = $EmailGV.Location
$EmailGVNew.ColumnCount = $EmailGV.ColumnCount
$EmailGVNew.Columns[1].width = $EmailGV.Columns[1].width
$EmailGVNew.Columns[0].width =$EmailGV.Columns[0].width
$EmailGVNew.RowHeadersVisible = $EmailGV.RowHeadersVisible
#$EmailGVNew.ColumnHeadersVisible = $false
$EmailGVNew.SelectionMode = $EmailGV.SelectionMode
$EmailGVNew.AllowUserToResizeColumns = $EmailGV.AllowUserToResizeColumns
$EmailGVNew.AllowUserToResizeRows = $EmailGV.AllowUserToResizeRows
$EmailGVNew.Columns[1].HeaderText = $EmailGV.Columns[1].HeaderText
$EmailGVNew.Columns[0].HeaderText = $EmailGV.Columns[0].HeaderText

#$EmailGV.Columns[0].HeaderText
#[void]$EmailGV.Rows.Add('باطل شده','شناسه')
#[void]$EmailGV.Rows.Add('باطل شده2','2شناسه')

#$EmailGV | Get-Member

#$EmailGV = [System.Management.Automation.PSSerializer]::Deserialize($test)
#$EmailGV = Get-Content D:\HST\IT\Root\sample.txt | ConvertFrom-Json
#$type = $EmailGV | gm | Select -Property TypeName -First 1
#$EmailGV | Get-Member 
#$EmailGV | Get-Member
#$SecoForm.Controls.Add($DesktopGB)
#$NewsLB | Get-Member
#$Secoform.AutoScale = $false
#[void] $SecoForm.ShowDialog()

$Mainform.Controls.Add($Chatlabel)
$Mainform.Controls.Add($EmailGVNew)
[void] $Mainform.ShowDialog()