#==================================#
#|   Created by Isar & @ten@ Mahdzadeh    |#
#==================================#
#|   March 04 2024             |#
#==================================#
#|   imahdzadeh@gmail.com      |#

#==================================#
#|   Atenshin Elsci               |#
#==================================#

$DepCodeTemp = (Split-Path $PSScriptRoot -Parent).Split('\') | select -Last 1
$ConFol =  (Get-Item $PSScriptRoot).parent.Parent.Parent.FullName
$pathTemp = "$ConFol\Config\$DepCodeTemp\$((Get-Item $PSCommandPath).Name)" -replace (".ps1$","")
. "$pathTemp\$(((Get-Item $PSCommandPath).Name) -replace (".ps1$","var.ps1"))"


if($varDebugTrace -ne 0){Set-PSDebug -Trace $varDebugTrace}Else{Set-PSDebug -Trace $varDebugTrace}
