. 'D:\HST\IT\Root\Config\Config.c'

$ConFol = "PRF" 
$ProjNames = Get-ChildItem -Path $ProdRoot -Directory | ForEach-Object{$_.Name}
$strCBPeopName = 'Material Code'
$FileExt = ".csv"
$FolderNameTests = "Tests"
