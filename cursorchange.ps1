Add-Type -TypeDefinition @'
public class SysParamsInfo {
    [System.Runtime.InteropServices.DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
    public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint pvParam, uint fWinIni);
    
    const int SPI_SETCURSORS = 0x0057;
    const int SPIF_UPDATEINIFILE = 0x01;
    const int SPIF_SENDCHANGE = 0x02;

    public static void CursorHasChanged() {
        SystemParametersInfo(SPI_SETCURSORS, 0, 0, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
    }
}
'@

# Change the cursor
Set-ItemProperty -Path 'HKCU:\Control Panel\Cursors' -Name 'hand' -Value '%SystemRoot%\cursors\aero_arrow_xl.cur'

# Notify the system about settings change by calling the C# code
[SysParamsInfo]::CursorHasChanged()