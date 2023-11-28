$mainPath = 'D:\HST\AccFinance\ACCG\GL'
If (!(Test-Path -Path $mainPath))
{
   "GL folder does not exit" 
 #  New-Item -ItemType Directory -Path $GLYPAth
}
$CurYear = (Get-Date).year
$GLYPAth = $mainPath + "\" + $CurYear
If (!(Test-Path -Path $GLYPAth))
{
   "Current year folder does not exit" 
 #  New-Item -ItemType Directory -Path $GLYPAth
}


get-childitem -path $Path | foreach {
    If ($ForType -f $_.Name)
    {

    }        
}
