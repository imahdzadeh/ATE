#'PRF1El100.csv' -replace '^[A-Za-z]*\d*[A-Za-z]*(\d+).csv', '$1'
#'jsmit123456' -replace '\D+(\d+)','$1'

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
$test = gci "D:\HST\Production\Projects\Ellie\Gel Nail Polish\Tests" -file | Foreach{
  $_ -replace '^PRF*(\d*)[A-Za-z]*\d*.csv', '$1'
  } | Select-Object *, @{ n = "IntVal"; e = {[int]($_)}} | Sort-Object IntVal | Select-Object -Last 1

$test.IntVal

$DGVCBInfoVer = gci "D:\HST\IT\Root\Config\PRF" -file | Foreach{
  $_ -replace '^PRF', ''
  } | Select-Object *, @{ n = "IntVal"; e = {[int]($_)}} | Sort-Object IntVal | Select-Object -Last 1
$DGVCBInfoVer.IntVal