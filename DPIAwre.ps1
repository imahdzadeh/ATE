Add-Type -AssemblyName System.Windows.Forms
Add-Type -TypeDefinition '
public class DPIAware
{
    [System.Runtime.InteropServices.DllImport("user32.dll")]
    public static extern bool SetProcessDPIAware();
}
'

[System.Windows.Forms.Application]::EnableVisualStyles()
[void] [DPIAware]::SetProcessDPIAware()

$form = [System.Windows.Forms.Form]@{
    Width  = 960
    Height = 540
}
$form.ShowDialog()