# Created by Isar Mahdzadeh
# Decmeber 20 2023
#
# Below line temporary till we have AD and can sert env variable in login script
#$ComRoot = "D:\ATE"                                                       <#1 modified by atena jan 14 24 for desktop.ps1#  be commented#>       
# $ComRoot = "d:\ATE" 
                               <#2 modified by atena jan 14 24 for desktop.ps1# be added#>                              

$ComRoot = Import-Csv "$((Get-Item $PSScriptRoot).Parent.FullName)\Config\Users\UsersProfile.csv" | `
Where-Object {$_.UserID -match $([Environment]::UserName)} | % {$_.mainpath}
# ---------------->>>>>IMPORTANT<<<<<<<<<<<<----------------
# This line retrieves all the types and high level variables from main config file
# and must be included in all sub config files
 <#-----------------#>. "$($ComRoot)\IT\Root\Config\Config.ps1" <#-----------------#>

#
#
# Define objects and variables customed to this script between the lines
#///////////////////////////////////////////////////////////////////////////////////

# $depCode = "PR12"                                                      <#3 modified by atena jan 14 24 for desktop.ps1#  be commented for line 112#>
$scriptpath = "$MainRoot\$depCode\ProdAnalyst\PrdTestCreation.ps1"
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
                               ( $shamsiDay = $persianCalendar.GetDayOfMonth($gregorianDate)).ToString() + "`t`t`t`t`t`t`t`t`t`t" + "مهد پویان اطلس" 
    Topmost       = $false
}

$MainTbl = New-Object System.Windows.Forms.TableLayoutPanel
#$MainTbl.Anchor = 8
#$MainTbl.Dock = "Fill"
#$MainTbl.Anchor = 'right'
$MainTbl.ColumnCount = 2
#$MainTbl.BackColor=''
#$MainTbl.RowCount = 1
#$MainTbl.CellBorderStyle = "single"
$MainTbl.AutoSize = $true
#$MainTbl.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
#$MainTbl.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 50)))
#$MainTbl.Margin.Top = 50
#$MainTbl.Margin.Right = 10
#$MainTbl.Padding = 10

$ButtonsTbl = New-Object System.Windows.Forms.TableLayoutPanel
#$ButtonsTbl.Anchor = 8
#$ButtonsTbl.Dock = "Fill"
#$ButtonsTbl.Anchor = 'right'
#$ButtonsTbl.ColumnCount = 1
#$ButtonsTbl.BackColor=''
#$ButtonsTbl.RowCount = 1
$ButtonsTbl.CellBorderStyle = "single"
$ButtonsTbl.AutoSize = $true

$CarTablbl = New-Object System.Windows.Forms.TableLayoutPanel
#$CarTablbl.Anchor = 8
#$CarTablbl.Dock = "Fill"
#$CarTablbl.Anchor = 'right'
#$CarTablbl.ColumnCount = 1
#$CarTablbl.BackColor=''
#$CarTablbl.RowCount = 1
$CarTablbl.CellBorderStyle = "single"
$CarTablbl.AutoSize = $true


$ReturnBtn                   = New-Object system.Windows.Forms.Button
$ReturnBtn.Name = "Main"
#$ReturnBtn.Anchor            = 'center'
$ReturnBtn.BackColor         = "#d2d4d6"
$ReturnBtn.text              = "بازگشت به صفحه اصلی"
$ReturnBtn.width             = 100
$ReturnBtn.height            = 35
#$ReturnBtn.location          = New-Object System.Drawing.Point(370,250)
$ReturnBtn.Font              = 'Microsoft Sans Serif,10'
$ReturnBtn.ForeColor         = "#000"
$ReturnBtn.Add_Click({
    $Mainform.Close()
    $Mainform.Dispose()
#    & D:\ATE\IT\Root\Main\Main.ps1
& "$MainRoot\$($this.Name).ps1"
}.GetNewClosure())



$Array = New-Object System.Collections.ArrayList
[void]$Array.add('AAA')
[void]$Array.add('BBB')
[void]$Array.add('CCC')
[void]$Array.add('DDD')
 $Test= 0

 <#
foreach ($item in $Array) {
    $test = $test + 1
  New-Variable -Force -Name "button$test" -Value (New-Object System.Windows.Forms.Button)
  $thisButton = Get-Variable -ValueOnly -Include "button$test"
  $thisButton.Anchor = 'right'
  $thisButton.Location = New-Object System.Drawing.Size(175,(35+26*$test))
  $thisButton.Size = New-Object System.Drawing.Size(250,23)
  $thisButton.Text = $item
  $thisButton.Add_Click({Write-Host $thisButton.Text}.GetNewClosure())
  #$thisButton.Add_Click({param($Sender,$EventArgs) Write-Host $Sender.Text})

  $MainTbl.Controls.Add($thisButton)
}
#>
    
    Get-ChildItem $MainRoot -Directory | foreach{
        If (Test-Path "$($_.FullName)\$ConfigFolName\$($_.Name)$CSVFileExt" )
        {
            $depcode = $_.Name
            $ScriptCSV = Import-Csv "$($_.FullName)\$ConfigFolName\$($_.Name)$CSVFileExt"
            Get-ChildItem $_.FullName -Directory | foreach{
                $DepCodeFol = $_.Name
                If ($_.Name -ne $ConfigFolName -and $_.name -ne $LogFolName)
                {
                    Get-ChildItem $_.FullName -File | foreach {
                        $ScriptName = $_.Name
                        $ScriptCSV | Where-Object {$_.ScriptName -match $ScriptName} | Foreach{
                            New-Variable -Force -Name $ScriptName -Value (New-Object System.Windows.Forms.Button)
                            $thisButton = Get-Variable -ValueOnly -Include $ScriptName
                            $thisButton.Anchor = 'right'
                            $thisButton.Name = $ScriptName
                            $thisButton.Location = New-Object System.Drawing.Size(175,(35+26*$test))
                            $thisButton.Size = New-Object System.Drawing.Size(250,30)
                            $thisButton.Text = $_.PersianAlias
                            $thisButton.Add_Click({
                                $Mainform.Close()
                                $Mainform.Dispose()          
                                & "$MainRoot\$depCode\$DepCodeFol\$ScriptName"   
                            }.GetNewClosure())
                            $ButtonsTbl.Controls.Add($thisButton)    
                        }
                    }
                }     
            }
        }
    }


#$Mainform.Controls.Add($Chatlabel)
#$Mainform.Controls.Add($MainGB)
#$MainTbl.Controls.Add($MainGB)
#$MainGB.Controls.Add($MainTbl)
<#
$test = [System.Management.Automation.PSSerializer]::serialize($test)
$AddPrinterBtn = [System.Management.Automation.PSSerializer]::deserialize($test)
$AddPrinterBtn = New-Object $AddPrinterBtn
#>
#$MainTbl.Controls.Add($EmailGV)
#$AddPrinterBtn.BackColor = 'red'
#$MainTbl.Controls.Add($AddPrinterBtn)
#$MainTbl.Controls.Add($Settings)

$CarTablbl = New-Object Panel
#$CarTablbl.BackColor = 'green'
#$CarTablbl.Location = New-Object Size(120,50)
$CarTablbl.Size = New-Object Size(500,400)
$CarTablbl.Dock = [DockStyle]::Fill
#$CarTablbl.AutoSize = $true
$CarTablbl.name = "Main"
$CarTablbl.BorderStyle = 0

$MainTbl.Controls.Add($ReturnBtn,0,0)
$MainTbl.Controls.Add($ButtonsTbl,1,1)
$MainTbl.SetRowSpan($ButtonsTbl,2)
$MainTbl.Controls.Add($CarTablbl,0,1)
#$MainTbl.SetRowSpan($CarTablbl,2)
$Mainform.Controls.Add($MainTbl)

#$Mainform.Controls.Add($EmailGVNew)
[void]$Mainform.ShowDialog()