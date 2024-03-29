﻿# Created by Isar Mahdzadeh
# Decmeber 30 2023
#
# Below line temporary till we have AD and can sert env variable in login script
# $ComRoot = "D:\ATE"
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
$ConFolPRF = "PRF"
$ConFolMAC = "MAC"
$ImageExt = ".png"
$depCode = "PR12"
$FolderNameTests = 'Tests' 
$strCBPeopName = 'Material Code'
$imgFolder = "img"
$StrImageLast = ""

$MatCodeFol = $strCBPeopName
$intColToCal = 2
$intColToSum = 1
$strCreated = 'Created'
$strChanged = 'Changed'
$RegExVerVar = "($($ConFolPRF))(\d*)"
$RegExNoVar = "($($ConFolPRF))(\d*)($($AllDepCode))(\d*)(.csv)"
$RegExMAC = "($($ConFolMAC))(\d*)($($AllDepCode))(\d*)(.csv)"
$ArrColToCompare = @('Material code','ratio %','Weight ml' )
#$RegExNoneCo= "^[a-zA-Z0-9.,$;]*$"
$RegExNoneCo = "'^.*(?:\r?\n)?'"
$RegExComment= "#$_"

$ShowFrmArr = @('عکس','شماره','توضیحات','وضعیت','تاریخ')

$strComLine = $("#" * 20)
$CommentCar = "#"
$UserLogPath ="$MainRoot\$depCode\$LogFolName\$UserFolName\$((Get-Date).ToString('MMMyy'))$LogFileExt" 
$ErrLogPath ="$MainRoot\$depCode\$LogFolName\$ErrFolName\$((Get-Date).ToString('MMMyy'))$LogFileExt" 
$Secoform = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 800, 600
    Text          =            $shamsiYear.ToString() + "/" + 
                               ($shamsiMonth = $persianCalendar.GetMonth($gregorianDate)) + "/" + 
                               ( $shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)).ToString() + "`t`t`t`t`t`t`t`t`t`t" + "رایا" 
    Topmost       = $true
}
#///////////////////////////////////////////////////////////////////////////////////