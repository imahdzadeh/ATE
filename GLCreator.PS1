$ComRoot = "D:\ATE"
$MainPath = "$ComRoot\AccFinance\ACCG\GL"
$ACCLPath = "$ComRoot\AccFinance\ACCG"
$CurYear = (Get-Date).year
$CurMonth = ((Get-Culture).DateTimeFormat.GetMonthName((Get-Date).Month)).Substring(0,3)
$GLYPAth = "$mainPath\$CurYear"
$GLMPAth = "$GLYPAth\$CurMonth"
$ACCLFileName = (Get-ChildItem -Path $ACCLPath -Filter "*ACCL*").FullName
#$sheetName = "SubLedgers"
$ObjCSV = Import-Csv $ACCLFileName
#$excelPidsBefore = @(Get-Process -ErrorAction Ignore Excel | Select-Object -ExpandProperty Id)
#$view=@()
If (!(Test-Path -Path $mainPath))
    {
        "GL folder does not exit, creating..."
        $GLYPAthCre = New-Item -ItemType Directory -Path $GLYPAth
    }
If (!(Test-Path -Path $GLYPAth))
    {
        "Current year folder $GLYPAth does not exit, creating..." 
        $GLYPAthCre = New-Item -ItemType Directory -Path $GLYPAth
    }
If (!(Test-Path -Path $GLMPAth))
    {
        "Current month folder $GLMPAth does not exit, creating..." 
        $GLMPAthCre = New-Item -ItemType Directory -Path $GLMPAth
    }
ForEach($folObj in $ObjCSV){
    $SLPAth = "$GLMPAth\$($folObj.folder)" 
    If (!(Test-Path -Path $SLPAth))
    {
        "SL folder $SLPAth does not exit, creating..."
        $SLPAthCre = New-Item -ItemType Directory -Path $SLPAth
    }
    $SLPAth = "$SLPAth\$($folObj.Abbri)"
    If (!(Test-Path -Path $SLPAth))
    {
        "SL folder $SLPAth does not exit, creating..."
        $SLPAthCre = New-Item -ItemType Directory -Path $SLPAth
    }   

    $SLPAth = $null    
}


$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(1550,500)
$view = Import-Csv $ACCLFileName

$list = New-Object System.collections.ArrayList
$list.AddRange($view)

$dataGridView = New-Object System.Windows.Forms.DataGridView -Property @{
    Size=New-Object System.Drawing.Size(700,400)
    ColumnHeadersVisible = $true
    DataSource = $list
    Location= New-Object System.Drawing.Point(20,20)
}
