﻿Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Management.Automation
<#
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
#>
$EmailGV = $null
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
#$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $false

#$AddPrinterBtn | ConvertTo-Json | out-file 'D:\HST\IT\Root\sample.jso'

#[System.IO.File]::WriteAllLines('D:\HST\IT\Root\sample.xml', [System.Management.Automation.PSSerializer]::Serialize($AddPrinterBtn), $Utf8NoBomEncoding)

#[System.Management.Automation.PSSerializer]::serialize($test) | out-file 'D:\HST\IT\Root\sample.jso'
$EmailGV | Export-Clixml -Path 'D:\HST\IT\Root\sample.xml' -Encoding UTF8
#$EmailGV | ConvertTo-JSON -Depth 4 | Out-File D:\HST\IT\Root\sample.txt

$EmailGV.ColumnCount

#$SecoForm.Controls.Add($DesktopGB)

#$Secoform.AutoScale = $false
#[void] $SecoForm.ShowDialog()
#[void] $Mainform.ShowDialog()