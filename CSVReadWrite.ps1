$ListImportDelimiter = ","

function SelectCsvFile () {
    Add-Type -AssemblyName System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Datei auswählen"
    $OpenFileDialog.InitialDirectory = Get-Location
    $OpenFileDialog.RestoreDirectory = $true
    $OpenFileDialog.filter = 'Tabelle (*.csv)|*.csv'
    $SelectedFile=$OpenFileDialog.ShowDialog()
    If ($SelectedFile -eq "Cancel") {
        $result = $null
    } 
    else { 
        $result= new-object System.Collections.ArrayList
        $data=@(import-csv  $OpenFileDialog.FileName -Delimiter $ListImportDelimiter)
        $result.AddRange($data) 
    }
   
    $OpenFileDialog.Dispose()
    return $result
    
}
#############################################
#Main Routine
#############################################

# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
# Create a new form
$ManageTeamsForm = New-Object system.Windows.Forms.Form
# Define the size, title and background color
$ManageTeamsForm.ClientSize = New-Object System.Drawing.Point(1000,700)


#DataGrid
$DataGrid = new-object System.windows.forms.DataGridView
$DataGrid.width             = 800
$DataGrid.height            = 500
$DataGrid.location          = New-Object System.Drawing.Point(37,80)

#loades testing csv on startup
$result= new-object System.Collections.ArrayList 
$data=@(import-csv  "D:\ATE\IT\Root\Config\PPM14\frmBPMNAnalyst\Controls.csv" -Delimiter $ListImportDelimiter)
$result.AddRange($data) 

$DataGrid.DataSource = $result


#Select File Button
$SelectCsvFileButton = New-Object System.Windows.Forms.Button
$SelectCsvFileButton.Location = New-Object System.Drawing.Size(100,35)
$SelectCsvFileButton.Size = New-Object System.Drawing.Size(120,23)
$SelectCsvFileButton.Text = "Open CSV"
$SelectCsvFileButton.Add_Click({
    $DataGrid.DataSource =SelectCsvFile;
    ForEach ($row in $DataGrid.DataSource ){ #Testing if DataSource successfully changes
        write-host $row
    }
    })

$ManageTeamsForm.controls.AddRange(@($SelectCsvFileButton,$DataGrid))
[void]$ManageTeamsForm.ShowDialog()