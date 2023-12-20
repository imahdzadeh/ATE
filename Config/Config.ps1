Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationCore,PresentationFramework
$ComRoot= "D:\ATE"
$MainRoot= "$($ComRoot)\IT\Root\Main"
$ProdRoot = "$($ComRoot)\Production\Projects"
$confRoot = "$($ComRoot)\IT\Root\Config"
$AllDepCode = "B10|OF11|HR20|LA30|OP40|IT50|AF60|SA70|MKT80|CE90|PR12|PU13"
$persianCalendar = New-Object System.Globalization.PersianCalendar
$gregorianDate = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Now,"Iran Standard Time")
# Convert the Gregorian date to Shamsi (Jalali) calendar
$shamsiYear = $persianCalendar.GetYear($gregorianDate)
$shamsiMonth = $persianCalendar.GetMonth($gregorianDate)
$shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)