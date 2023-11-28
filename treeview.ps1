function Show-DirectoryTree {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [string]$RootFolder
    )

    # recursive helper function to add folder nodes to the treeview
    function Add-Node {
        param (
            [System.Windows.Forms.TreeNode]$parentNode, 
            [System.IO.DirectoryInfo]$Folder
        )
        Write-Verbose "Adding node $($Folder.Name)"
        $subnode      = New-Object System.Windows.Forms.TreeNode
        $subnode.Text = $Folder.Name
        [void]$parentNode.Nodes.Add($subnode)
        Get-ChildItem -Path $Folder.FullName -Directory | ForEach-Object {
            Add-Node $subnode $_
        }
    }

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $Form = New-Object System.Windows.Forms.Form
    $Form.Text = "Folders"
    $Form.Size = New-Object System.Drawing.Size(390, 390)

    $TreeView = New-Object System.Windows.Forms.TreeView
    $TreeView.Location = New-Object System.Drawing.Point(48, 12)
    $TreeView.Size = New-Object System.Drawing.Size(290, 322)
    $Form.Controls.Add($TreeView)

    $rootnode = New-Object System.Windows.Forms.TreeNode
    # get the name of the rootfolder to use for the root node
    $rootnode.Text = [System.IO.Path]::GetFileName($RootFolder.TrimEnd('\'))  #'# or use: (Get-Item -Path $RootFolder).Name
    $rootnode.Name = "Root"
    [void]$TreeView.Nodes.Add($rootnode)
    # expand just the root node
    $rootNode.Expand()

    # get all subdirectories inside the root folder and 
    # call the recursive function on each of them
    Get-ChildItem -Path $RootFolder -Directory | ForEach-Object {
        Add-Node $rootnode $_
   }

   $Form.Add_Shown({$Form.Activate()})
   [void] $Form.ShowDialog()

   # remove the form when done with it
   $Form.Dispose()
}

# call the function to show the directory tree 
# take off the -Verbose switch if you do not want console output
Show-DirectoryTree -RootFolder 'C:\msi' -Verbose