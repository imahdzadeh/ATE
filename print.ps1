function print-image {
 param([string]$imageName = $(throw "Enter image name to print"),
    [string]$printer = "",
    [bool]$fitImageToPaper = $true)

 trap { break; }

 # check out Lee Holmes' blog(http://www.leeholmes.com/blog/HowDoIEasilyLoadAssembliesWhenLoadWithPartialNameHasBeenDeprecated.aspx)
 # on how to avoid using deprecated "LoadWithPartialName" function
 # To load assembly containing System.Drawing.Printing.PrintDocument
 [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

 # Bitmap image to use to print image
 $bitmap = $null

 $doc = new-object System.Drawing.Printing.PrintDocument
 # if printer name not given, use default printer
 if ($printer -ne "") {
  $doc.PrinterSettings.PrinterName = $printer
 }
 
 $doc.DocumentName = [System.IO.Path]::GetFileName($imageName)

 $doc.add_BeginPrint({
  Write-Host "==================== $($doc.DocumentName) ===================="
 })
 
 # clean up after printing...
 $doc.add_EndPrint({
  if ($bitmap -ne $null) {
   $bitmap.Dispose()
   $bitmap = $null
  }
  Write-Host "xxxxxxxxxxxxxxxxxxxx $($doc.DocumentName) xxxxxxxxxxxxxxxxxxxx"
 })
 
 # Adjust image size to fit into paper and print image
 $doc.add_PrintPage({
  Write-Host "Printing $imageName..."
 
  $g = $_.Graphics
  $pageBounds = $_.MarginBounds
  $img = new-object Drawing.Bitmap($imageName)
  
  $adjustedImageSize = $img.Size
  $ratio = [double] 1;
  
  # Adjust image size to fit on the paper
  if ($fitImageToPaper) {
   $fitWidth = [bool] ($img.Size.Width > $img.Size.Height)
   if (($img.Size.Width -le $_.MarginBounds.Width) -and
    ($img.Size.Height -le $_.MarginBounds.Height)) {
    $adjustedImageSize = new-object System.Drawing.SizeF($img.Size.Width, $img.Size.Height)
   } else {
    if ($fitWidth) {
     $ratio = [double] ($_.MarginBounds.Width / $img.Size.Width);
    } else {
     $ratio = [double] ($_.MarginBounds.Height / $img.Size.Height)
    }
    
    $adjustedImageSize = new-object System.Drawing.SizeF($_.MarginBounds.Width, [float]($img.Size.Height * $ratio))
   }
  }

  # calculate destination and source sizes
  $recDest = new-object Drawing.RectangleF($pageBounds.Location, $adjustedImageSize)
  $recSrc = new-object Drawing.RectangleF(0, 0, $img.Width, $img.Height)
  
  # Print to the paper
  $_.Graphics.DrawImage($img, $recDest, $recSrc, [Drawing.GraphicsUnit]"Pixel")
  
  $_.HasMorePages = $false; # nothing else to print
 })
 
 $doc.Print()
}

print-image "D:\ATE\IT\Root\images\SolidLine.png"