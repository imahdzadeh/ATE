function add {
 $status='logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','logged1','disconnected1','locked1','logged2','disconnected2','locked2','logged3','disconnected3','locked3'
 foreach ($s in $status)
 {
    $i =$listbox.Items.Add($s)
 }
}

$listBox_DrawItem={
param(
  [System.Object] $sender, 
  [System.Windows.Forms.DrawListViewItemEventArgs] $e
 )

 if ( $e.Item.text.contains('locked'))  
 { 
    $Color=[System.Drawing.Color]::yellowgreen       
    try
    {
      $brush = new-object System.Drawing.SolidBrush($Color)
     $e.Graphics.FillRectangle($brush, $e.Bounds)
    }
    finally
    {
      $brush.Dispose()
    }
 }
 else
 {
    $e.DrawBackground();
 }

 $e.DrawFocusRectangle();
 if ($e.Item.Checked)
 {
    [System.Windows.Forms.ControlPaint]::DrawCheckBox($e.Graphics,$e.Bounds.X, $e.Bounds.Top + 1, 15, 15, [System.Windows.Forms.ButtonState]::Checked)
 }
 else
 {
    [System.Windows.Forms.ControlPaint]::DrawCheckBox($e.Graphics,$e.Bounds.X, $e.Bounds.Top + 1, 15, 15, [System.Windows.Forms.ButtonState]::Flat)
 }

   [System.Drawing.font] $headerFont = new-object System.Drawing.font("Helvetica", 
            10, [System.Drawing.FontStyle]::Regular)

   $sf = new-object System.Drawing.StringFormat
   $sf.Alignment = [System.Drawing.StringAlignment]::Near

     $rect = New-Object System.Drawing.RectangleF
     $rect.x = $e.Bounds.X+16
     $rect.y = $e.Bounds.Top+1
     $rect.width = $e.bounds.right
     $rect.height = $e.bounds.bottom
   $e.Graphics.DrawString($e.item.Text, 
                          $headerFont, 
                          [System.Drawing.Brushes]::Black, 
                          $rect, 
                          $sf)
}     
$listBox_DrawSubItem={
param(
  [System.Object] $sender, 
  [System.Windows.Forms.DrawListViewSubItemEventArgs] $e
 )
}     

$listBox_DrawHeader={
param(
  [System.Object] $sender, 
  [System.Windows.Forms.DrawListViewColumnHeaderEventArgs] $e
 )

   [System.Drawing.font] $headerFont = new-object System.Drawing.font("Helvetica", 
            10, [System.Drawing.FontStyle]::Bold)
   $e.DrawBackground();
   $sf = new-object System.Drawing.StringFormat
   $sf.Alignment = [System.Drawing.StringAlignment]::Center

     $rect = New-Object System.Drawing.RectangleF
     $rect.x = $e.Bounds.X+16
     $rect.y = $e.Bounds.Top+1
     $rect.width = $e.bounds.right
     $rect.height = $e.bounds.bottom
     $e.Graphics.DrawString($e.Column.text,$e.Item.Font,[System.Drawing.Brushes]::Black, $rect )
   $e.Graphics.DrawString($e.Header.Text, 
                          $headerFont, 
                          [System.Drawing.Brushes]::Black, 
                          $rect, 
                          $sf)
}     



#Generated Form Function
function GenerateForm {


#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#endregion

#region Generated Form Objects
$form1 = New-Object System.Windows.Forms.Form
$add = New-Object System.Windows.Forms.Button
$listbox = New-Object System.Windows.Forms.Listview
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------
#Provide Custom Code for events specified in PrimalForms.
$handler_form1_Load= 
{
#TODO: Place custom script here

}

$handler_btnRechercher_Click= 
{
add
#TODO: Place custom script here

}

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
    $form1.WindowState = $InitialFormWindowState
}

#----------------------------------------------
#region Generated Form Code
$form1.BackColor = [System.Drawing.Color]::FromArgb(255,240,240,240)
$form1.Text = "Move VM"
$form1.Name = "form1"
$form1.AutoScaleMode = 3

$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$form1.AutoScroll = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 357
$System_Drawing_Size.Height = 486
$form1.ClientSize = $System_Drawing_Size
$form1.add_Load($handler_form1_Load)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 330
$System_Drawing_Size.Height = 407
$listbox.Size = $System_Drawing_Size
$listbox.DataBindings.DefaultDataSourceUpdateMode = 0
$listbox.Name = "listview"
$listBox.view = [System.Windows.Forms.View]::Details
$listbox.CheckBoxes = $true
$listbox.fullrowselect = $true
$listBox.OwnerDraw = $true
$listBox.Add_DrawItem($listBox_DrawItem)
$listBox.Add_DrawSubItem($listBox_DrawSubItem)
$listBox.add_DrawColumnHeader($listBox_DrawHeader)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 21
$listbox.Location = $System_Drawing_Point
$listbox.TabIndex = 4
$listbox.add_Click($action_si_click_sur_VMKO)
$listBox.Columns.Add("VMs", 300, [System.Windows.Forms.HorizontalAlignment]::Center) | out-null

$form1.Controls.Add($listbox)

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form

add

$form1.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm    