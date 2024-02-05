$wia = New-Object -com wia.imagefile
$dialog = [System.Windows.Forms.OpenFileDialog]::new()
$dialog.RestoreDirectory = $true
$result = $dialog.ShowDialog()
if($result -eq [System.Windows.Forms.DialogResult]::OK){
    $wia.LoadFile($dialog.FileName)
    $wip = New-Object -ComObject wia.imageprocess
    $scale = $wip.FilterInfos.Item("Scale").FilterId                    
    $wip.Filters.Add($scale)
    $wip.Filters[1].Properties("MaximumWidth") = 120
    $wip.Filters[1].Properties("MaximumHeight") =120
    #aspect ratio should be set as false if you want the pics in exact size 
    $wip.Filters[1].Properties("PreserveAspectRatio") = $true
    $wip.Apply($wia) 
    $newimg = $wip.Apply($wia)

    $dialogsave = [System.Windows.Forms.SaveFileDialog]::new()
    $dialogsave.RestoreDirectory = $true
    $resultsave = $dialogsave.ShowDialog()
    if($resultsave -eq [System.Windows.Forms.DialogResult]::OK){
        $newimg.SaveFile($dialogsave.FileName)
    }
}