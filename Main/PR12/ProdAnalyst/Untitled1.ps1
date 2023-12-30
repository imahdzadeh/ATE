Get-ChildItem D:\ATE\IT\Root -file -Recurse -Force| foreach{
    If ($_.Name -eq "desktop.ini")

    {
        Remove-Item $_.FullName -Force 
    }

}