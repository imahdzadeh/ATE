# Created by Isar Mahdzadeh
# Decmeber 12 2023
#
#
# ---------------->>>>>IMPORTANT<<<<<<<<<<<<----------------
# This line retrieves all the types and high level variables from main config file
# and must be included in all sub config files
<#/\/\/\/\/\/\/\/\#>. "$($env:comroot)\IT\Root\Config\Config.ps1" <#/\/\/\/\/\/\/\#>
#
#
# Define objects and variables customed to this script between the lines
#///////////////////////////////////////////////////////////////////////////////////
$ConFol = "PRF"
$FileExt = ".csv"
$depCode = "PR12"
$FolderNameTests = 'Tests' 
$MatInfoPath = "Material Info"
$strCBPeopName = 'Material Code'
$intColToCal = 2
$intColToSum = 1
$strCreated = 'Created'
$strChanged = 'Changed'
$RegExVerVar = "($($conFol))(\d*)"
$RegExNoVar = "($($conFol))(\d*)($($AllDepCode))(\d*)(.csv)"
#$RegExNoneCo= "^[a-zA-Z0-9.,$;]*$"
$RegExNoneCo= "'^.*(?:\r?\n)?'"
$RegExComment= "#$_"
$ExtrInfoArr = @('Latest Change','Date','Analyst')
$strComLine = $("#" * 20)
$Secoform = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 800, 600
    Text          =            $shamsiYear.ToString() + "/" + 
                               ($shamsiMonth = $persianCalendar.GetMonth($gregorianDate)) + "/" + 
                               ( $shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)).ToString() + "`t`t`t`t`t`t`t`t`t`t" + "پارس طوبی تکیه" 
    Topmost       = $true
}
#///////////////////////////////////////////////////////////////////////////////////