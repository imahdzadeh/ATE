#Write-Host $("-" * 5)
$test = $("-" * 5)

$RegExNoneCo= "^[a-zA-Z0-9.,$;]*$"
$RegExComment= "#'$_'"
# | Set-Content D:\HST\IT\Root\test.txt
#(Get-Content D:\HST\IT\Root\test.txt) -replace '(.*?)', '#$_'

#$path = "D:\HST\IT\Root\test.txt"

$path = "D:\HST\Production\Projects\Ellie\Gel Nail Polish\Tests\PRF1PR1212.csv"
#"sdfsdfsdfsdfsdfs" | Out-File $path

#"LENCHN2,2,2,kghjlkhjg,Created,12/13/2023 11:21 PM,Isar" -replace '^.*(?:\r?\n)?' , '#$_'

#virus Get-Content $path | foreach {$_ -replace '^[a-zA-Z0-9.,$;]*(?:\r?\n)?' , '#$_' | Out-File $path -Append}
#(Get-Content $path) | foreach {$_ -replace '^.*(?:\r?\n)?' , '#$_' } | Out-File $path
#(Get-Content $path) | foreach {$_ -replace '^[a-zA-Z0-9.,$;%]*(?:\r?\n)?' , 'A' }

#$test= Get-Content $path |  ConvertTo-Csv -Delimiter ',' -NoTypeInformation
#$test
#(Get-Content "D:\HST\Production\Projects\Ellie\Gel Nail Polish\Tests\PRF1PR121.txt") -replace '^[a-zA-Z0-9.,$;]*$' , '#$_' | Set-Content  "D:\HST\Production\Projects\Ellie\Gel Nail Polish\Tests\PRF1PR121.txt"

#"sdfsdfsdfsdf" -match '^[a-zA-Z0-9.s,$;]*$','$1'
#$matches[0]

$mydata = Get-Content $path | Where-Object { !$_.StartsWith("#") } | ConvertFrom-Csv

$mydata