using namespace System.IO
using namespace System.Drawing
using namespace System.Drawing.Imaging
using namespace System.Windows.Forms
#using assembly System.Windows.Forms

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationCore,PresentationFramework
$ComRoot= "D:\ATE"                        <#modified by atena jan 14 24 for desktop.ps1#  be commented#>
#$ComRoot="C:\Users\Mahdza1\Documents\ATE" <#modified by atena jan 14 24 for desktop.ps1# be added#>
$ArchFolder = "Archive"
$PSFileExten = ".ps1"
$VarFileCont = "Var"
$CSVFileExt = ".csv"
$LogFileExt = ".log"
$ConfigFolName = "Config"
$LogFolName = "Log"
$UserFolName = "User"
$ErrFolName = "Err"
$CommentCar = "#"
$CSVDelimiter = ','
$strCreated = 'جدید'
$strChanged = 'ویرایش'
$MainRoot= "$($ComRoot)\IT\Root\Main"
$ProdRoot = "$($ComRoot)\Production\Projects"
$confRoot = "$($ComRoot)\IT\Root\Config"
$ITRoot = "$($ComRoot)\IT"
$AllDepCode = "B10|OF11|HR20|LA30|OP40|IT50|AF60|SA70|MKT80|CE90|PR12|PU13"
$persianCalendar = New-Object System.Globalization.PersianCalendar
$gregorianDate = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Now,"Iran Standard Time")
# Convert the Gregorian date to Shamsi (Jalali) calendar
$shamsiYear = $persianCalendar.GetYear($gregorianDate)
$shamsiMonth = $persianCalendar.GetMonth($gregorianDate)
$shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)
$Icon = New-Object system.drawing.icon ("D:\ATE\IT\Root\Main\favicon.ico")