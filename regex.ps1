#'PRF1El100.csv' -replace '^[A-Za-z]*\d*[A-Za-z]*(\d+).csv', '$1'
#'jsmit123456' -replace '\D+(\d+)','$1'
. "$($env:comroot)\IT\Root\Config\Config.ps1"
. "D:\HST\IT\Root\Main\PR12\Config\PrdTestCreationVar.ps1"

# Define objects and variables customed to this script below
#///////////////////////////////////////////////////////////////////////////////////
     $ConfFileVer = $null
    $ConfFileVer = gci "D:\HST\Production\Projects\Ellie\Gel Nail Polish" -file -Recurse| Foreach{
        $_ -match $RegExVar
    } | Select-Object *, @{ n = "IntVal"; e = {[int]($Matches[4])}} | Sort-Object IntVal | Select-Object -Last 1
    $ConfFileVer.IntVal








#[regex]::Replace((gci "D:\HST\Production\Projects\Ellie\Gel Nail Polish\Tests" -file).Name, '^[A-Za-z]*\d*[A-Za-z]*(\d+).csv', '$1')
  #      ((gci "D:\HST\Production\Projects\Ellie\Gel Nail Polish\Tests" -file).Name).Replace('^[A-Za-z]*\d*[A-Za-z]*(\d+).csv', '$1')
  <#
  $test = gci "D:\HST\Production\Projects\Ellie\Gel Nail Polish\Tests" -file | Foreach{
  $_ -replace '^[A-Za-z]*\d*[A-Za-z]*(\d+).csv', '$1'
  } | Select-Object *, @{ n = "IntVal"; e = {[int]($_)}} | Sort-Object IntVal | Select-Object -Last 1
#>
 <# 
 # For testing purposes
#$fileList = @([PSCustomObject]@{ Name = "11" }, [PSCustomObject]@{ Name = "2" }, [PSCustomObject]@{ Name = "1" })
# OR
#$fileList = New-Object -TypeName System.Collections.ArrayList
#$fileList.AddRange(@([PSCustomObject]@{ Name = "11" }, [PSCustomObject]@{ Name = "2" }, [PSCustomObject]@{ Name = "1" })) | Out-Null

$highest = $fileList | Select-Object *, @{ n = "IntVal"; e = { [int]($_.Name) } } | Sort-Object IntVal | Select-Object -Last 1

$newName = $highest.IntVal + 1

New-Item $newName -ItemType Directory
#>
# (B10|OF11|HR20|LA30|OP40|IT50|AF60|SA70|MKT80|CE90|PR12|PU13), '$1'
# \wB10|\wOF11|\wHR20|\wLA30|\wOP40|\wIT50|\wAF60|\wSA70|\wMKT80|\wCE90|\wPR12|\wPU13

#gci "D:\HST\Production\Projects\Ellie\Gel Nail Polish" -file -Recurse| select {$_ -replace '^PRF\d*[A-Za-z]*\d*', ''} 
# B10|OF11|HR20|LA30|OP40|IT50|AF60|SA70|MKT80|CE90|PR12|PU13
#$RegExVar = [regex]::escape($ConFol) +("\d*") + [regex]::escape($DepCode) + "\d*.csv"
#$RegExVar = "($($conFol))(\d*)($($DepCode))(\d*)(.csv)"
# another way
#$RegExVar = "([regex]::escape($ConFol))(\d*)([regex]::escape($DepCode))(\d*)(.csv)"
#$RegExVar
#$test = 'PRF1PR121.csv' -match $RegExVar
#"$($Matches[1])$($Matches[2])"
<#
$Matches[0]
$Matches[1]
$Matches[2]
$Matches[3]
$Matches[4]
$Matches[5]
#>
$RegExVar = $Null
$Matches = $null
# | Select-Object *, @{ n = "IntVal"; e = {[int]($_)}} | Sort-Object IntVal | Select-Object -Last 1
#$test.IntVal

<#
$DGVCBInfoVer = gci "$confRoot\$ConFol" -file | Foreach{
  $_ -replace '^PRF', ''
  } | Select-Object *, @{ n = "IntVal"; e = {[int]($_)}} | Sort-Object IntVal | Select-Object -Last 1
$DGVCBInfoVer.IntVal
#>