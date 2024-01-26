# Created by Atena Mahdzadeh
# Jan 12 2024
#
# Below line temporary till we have AD and can insert env variable in login script
#$ComRoot = "C:/Users/Mahdza1/Documents/ATE"
#$ComRoot = "D:\ATE"
$ComRoot = Import-Csv "$((Get-Item $PSScriptRoot).Parent.Parent.parent.FullName)\Config\Users\UsersProfile.csv" | `
Where-Object {$_.UserID -match $([Environment]::UserName)} | % {$_.mainpath}
#
# ---------------->>>>>IMPORTANT<<<<<<<<<<<<----------------
# This line retrieves all the types and high level variables from main config file
# and must be included in all sub config files
<#-----------------#>. "$($ComRoot)\IT\Root\Config\Config.ps1" <#-----------------#>
#
#
# Define objects and variables customed to this script between the lines
#///////////////////////////////////////////////////////////////////////////////////
$varDebugTrace = 0
#اسم دکمه برگشت به صفحه اصلی
$retunBtnName = "Main"
$PreSupplierName = 'SUI1PR'
$FirstSupplierCode = '121'
# فرم جاری
$Mainform = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 800, 600
    Text          =            $shamsiYear.ToString() + "/" + 
                               ($shamsiMonth = $persianCalendar.GetMonth($gregorianDate)) + "/" + 
                               ( $shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)).ToString() + "`t`t`t`t`t`t`t`t`t`t" + "مهد پویان اطلس" 
    Topmost       = $false
}