# Created by Isar Mahdzadeh
# Decmeber 20 2023
#
# Below line temporary till we have AD and can sert env variable in login script
$ComRoot = "D:\ATE"
#
# ---------------->>>>>IMPORTANT<<<<<<<<<<<<----------------
# This line retrieves all the types and high level variables from main config file
# and must be included in all sub config files
<#-----------------#>. "$($ComRoot)\IT\Root\Config\Config.ps1" <#-----------------#>
#
#
# Define objects and variables customed to this script between the lines
#///////////////////////////////////////////////////////////////////////////////////
$depCode = "PR12"
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

$Panel = New-Object System.Windows.Forms.TableLayoutPanel
$panel.Dock = "Fill"
#$panel.Anchor = 'right'
#$panel.ColumnCount = 1
$panel.BackColor=''
#$panel.RowCount = 1
$panel.CellBorderStyle = "single"
$panel.AutoSize = $true
#$panel.ColumnStyles.Add((new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
#$panel.RowStyles.Add((new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 50)))
#$panel.Margin.Top = 50
#$panel.Margin.Right = 10
#$panel.Padding = 10


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

  $panel.Controls.Add($thisButton)
}
#>
    $panel.Controls.Add($ReturnBtn)
    Get-ChildItem $MainRoot -Directory | foreach{
        If (Test-Path "$($_.FullName)\$CongFolName\$($_.Name)$CSVFileExt" )
        {
            $ScriptCSV = Import-Csv "$($_.FullName)\$CongFolName\$($_.Name)$CSVFileExt"
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
                            $panel.Controls.Add($thisButton)    
                        }
                    }
                }     
            }
        }
    }
#$Mainform.Controls.Add($Chatlabel)
#$Mainform.Controls.Add($MainGB)
#$panel.Controls.Add($MainGB)
#$MainGB.Controls.Add($panel)
<#
$test = [System.Management.Automation.PSSerializer]::serialize($test)
$AddPrinterBtn = [System.Management.Automation.PSSerializer]::deserialize($test)
$AddPrinterBtn = New-Object $AddPrinterBtn
#>
#$panel.Controls.Add($EmailGV)
#$AddPrinterBtn.BackColor = 'red'
#$panel.Controls.Add($AddPrinterBtn)
#$panel.Controls.Add($Settings)
$Mainform.Controls.Add($panel)

#$Mainform.Controls.Add($EmailGVNew)
[void]$Mainform.ShowDialog()