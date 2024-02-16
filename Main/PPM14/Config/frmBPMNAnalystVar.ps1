# Created by Isar Mahdzadeh
# Decmeber 12 2023
#
# Below line temporary till we have AD and can insert env variable in login script
# below 2 Lines find the mainpth of curren authenticated user
$ComRoot = Import-Csv "$((Get-Item $PSScriptRoot).Parent.Parent.parent.FullName)\Config\Users\UsersProfile.csv" | `
Where-Object {$_.UserID -match $([Environment]::UserName)} | % {$_.mainpath}
#$ComRoot = "D:\ATE"
#
# ---------------->>>>>IMPORTANT<<<<<<<<<<<<----------------
# This line retrieves all the types and high level variables from main config file
# and must be included in all sub config files
<#-----------------#>. "$($ComRoot)\IT\Root\Config\Config.ps1" <#-----------------#>
#
#
# Define objects and variables customed to this script between the lines
#///////////////////////////////////////////////////////////////////////////////////
$Creation = "Creation"
$DesktopWidth = 1100
$desktopHeight = 600
$intMaxWidth = 10000
$intMaxHeight = 5000
#$depCode = "PPM14"
$frmName = (Get-Item $PSCommandPath).Name
#Write-Host $VarFileCont
$frmConfFol = ($frmName.Replace($PSFileExten,$EmptyStr)) -replace $VarFileCont,$EmptyStr
$depCode = "$((Get-Item $PSScriptRoot).Parent.Name)"
$frmConfigPath = "$confRoot\$depCode\$frmConfFol"
$imgFol = "$ImageFolder\$depCode\$frmConfFol"
$ControlsCSV ="$frmConfigPath\Controls.csv"
$TablesCSV ="$frmConfigPath\Tables.csv"
$RegionsClass = "Region"
$GroupsClass = "Groups"
$Global:strFileName = $null
$Global:SelText = $Null
$LaneLineSize = 1
$PoolLineSize = 2
$TextSize = 12
$BoldFont = 1
$Global:ScaleUnit = 1
$RegularFont = 0
$varDebugTrace = 0
$Logging = $True
$ImageExt = ".png"
$PoolSize = 200
$LaneSize = 100
$GroupSize = 400
$PoolTAreaSize = 35
$intIterate = 0
$intRegPenSize = 2
$intSelPenSize = 2
$intMedPenSize = 3
$intGroPenSize = 4
$intBigPenSize = 7
$bolMouseDown = $false
$objShape = $null
$arcSize = 10
$ShadowSize = 2
$squareSize = 80
$squareSizeY = 60
$DimondSize = 40
$StartCircleSize = 34
$InterCircleSize = 30
$DataObjSize = 40
$DataObjSizeX = $DataObjSize - ($DataObjSize /3)
$adjustPixel = 10
$ConnPSize = 10
$intDevideBy2 = 2
$intMultiplyBy2 = 2 
$intArrowSize = 4
$intFirstLineSize = 20
$MainObject = $Null
$myBrush = new-object Drawing.SolidBrush black
$SelTextBrush = new-object Drawing.SolidBrush Gray
$WhiteTextBrush = new-object Drawing.SolidBrush white
$TextBrush = new-object Drawing.SolidBrush Black
$BigPen = new-object Drawing.Pen black,$intBigPenSize
$BigWhitePen = new-object Drawing.Pen red,$intGroPenSize
$TinyPen = new-object Drawing.Pen black,1
$RegPen = new-object Drawing.Pen gray,$intRegPenSize
$MedPen = new-object Drawing.Pen gray,$intMedPenSize
$SelPen = new-object Drawing.Pen Black,$intSelPenSize
$GroupPen = new-object Drawing.Pen Black,$intGroPenSize
$TextPen = new-object Drawing.Pen Black,$intRegPenSize
$mypen2 = new-object Drawing.Pen gray, 4
$mypen3 = new-object Drawing.Pen black, 4
$mypen2.Color = [System.Drawing.Color]::FromArgb(180,180,180)
$bigarrow = New-Object Drawing2D.AdjustableArrowCap $intArrowSize, $intArrowSize
$mypenCap = new-object Drawing.Pen black,1.4
$mypenCap.CustomEndCap = $bigarrow
$BigpenCap = new-object Drawing.Pen gray,3
$BigpenCap.CustomEndCap = $bigarrow
$brushBg = [System.Drawing.Brushes]::gray
$brushBg.Color = [System.Drawing.Color]::FromArgb(200,200,200)
$ClearbrushBg = [System.Drawing.Brushes]::white
$rect = new-object Drawing.Rectangle 10, 10, 180, 180
$avatar = [System.Drawing.Image]::Fromfile('D:\ate\IT\Root\images\circle.png')
$fonty = New-Object Font 'arial',9
$UserLogPath ="$MainRoot\$depCode\$LogFolName\$UserFolName\$((Get-Date).ToString('MMMyy'))$LogFileExt" 
$ErrLogPath ="$MainRoot\$depCode\$LogFolName\$ErrFolName\$((Get-Date).ToString('MMMyy'))$LogFileExt" 
$subIconButSize = 30
$ShapesSize = 50
$GroupSizeX = 100
$GroupSizey = 60
$code = @"
[System.Runtime.InteropServices.DllImport("gdi32.dll")]
public static extern IntPtr CreateRoundRectRgn(int nLeftRect, int nTopRect,
    int nRightRect, int nBottomRect, int nWidthEllipse, int nHeightEllipse);
"@
$Win32Helpers = Add-Type -MemberDefinition $code -Name "Win32Helpers" -PassThru
$Secoform = New-Object Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 1250,700
    Text          =            $shamsiYear.ToString() + "/" + 
                               ($shamsiMonth = $persianCalendar.GetMonth($gregorianDate)) + "/" + 
                               ( $shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)).ToString() + "`t`t`t`t`t`t`t`t`t`t`t`t`t`t`t`t`t`t`t" + "رایا" 
    Topmost       = $False
    FormBorderStyle = 'FixedDialog'
    MaximizeBox = $false
}
#///////////////////////////////////////////////////////////////////////////////////