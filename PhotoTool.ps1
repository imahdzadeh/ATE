$wia = New-Object -com wia.imagefile
$wia.LoadFile("D:\ATE\IT\Root\images\Untitled.png")
$wip = New-Object -ComObject wia.imageprocess
$scale = $wip.FilterInfos.Item("Scale").FilterId                    
$wip.Filters.Add($scale)
$wip.Filters[1].Properties("MaximumWidth") = 100
$wip.Filters[1].Properties("MaximumHeight") =25
#aspect ratio should be set as false if you want the pics in exact size 
$wip.Filters[1].Properties("PreserveAspectRatio") = $true
$wip.Apply($wia) 
$newimg = $wip.Apply($wia)

$dialog = [System.Windows.Forms.SaveFileDialog]::new()
            $dialog.RestoreDirectory = $true
            $result = $dialog.ShowDialog()
$newimg.SaveFile($dialog.FileName)