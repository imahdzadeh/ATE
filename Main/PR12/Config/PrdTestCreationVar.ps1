# ---------------->>>>>IMPORTANT<<<<<<<<<<<<----------------
# This line retrieves all the types and high level variables from main config file
# and must be included in all sub config files
. "$($env:comroot)\IT\Root\Config\Config.ps1"

# Define objects and variables customed to this script below
#///////////////////////////////////////////////////////////////////////////////////
$ConFol = "PRF" 
$ProjNames = Get-ChildItem -Path $ProdRoot -Directory | ForEach-Object{$_.Name}
$strCBPeopName = 'Material Code'
$FileExt = ".csv"
$FolderNameTests = "Tests"

$Secoform = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 800, 600
    Text          =            $shamsiYear.ToString() + "/" + 
                               ($shamsiMonth = $persianCalendar.GetMonth($gregorianDate)) + "/" + 
                               ( $shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)).ToString() + "`t`t`t`t`t`t`t`t`t`t" + "پارس طوبی تکیه" 
    Topmost       = $true
}
