# Created by Atena Mahdzadeh - FrmSupMgmt.ps1
# Jan 12 2024
#
#Try
#{
 . "$(Split-Path $PSScriptRoot -Parent)\Config\$(($PSCommandPath.Split('\') | select -last 1) -replace (".ps1$","var.ps1"))"

    if($varDebugTrace -ne 0)
    {
        Set-PSDebug -Trace $varDebugTrace    
    }
    Else
    {
        Set-PSDebug -Trace $varDebugTrace  
    }

#    throw [System.IO.FileNotFoundException] "$file not found."

<#FormControls 
   +++++++++++++++++++++++++++++++++
#>
#MainTableکنترل 
$MainTable = New-Object System.Windows.Forms.TableLayoutPanel
#$MainTable.Dock = "fill"
$MainTable.BackColor= ' '
$MainTable.CellBorderStyle = "Single"
$MainTable.AutoSize = $true

#SupplyInfoTable Control
$SupplyInfoTable = New-Object System.Windows.Forms.TableLayoutPanel
$SupplyInfoTable.Dock = "fill"
$SupplyInfoTable.BackColor= ' '
$SupplyInfoTable.CellBorderStyle = "Single"
$SupplyInfoTable.AutoSize = $true
$SupplyInfoTable.ColumnCount = 2
$SupplyInfoTable.RowCount = 8
$SupplyInfoTable.BackColor = 'pink'

#address1Tbl 
$address1Tbl = New-Object System.Windows.Forms.TableLayoutPanel
$address1Tbl.Dock = "fill"
$address1Tbl.BackColor= ' '
$address1Tbl.CellBorderStyle = "Single"
$address1Tbl.AutoSize = $true
$address1Tbl.ColumnCount = 2
$address1Tbl.RowCount = 6

#address2Tbl 
$address2Tbl = New-Object System.Windows.Forms.TableLayoutPanel
$address2Tbl.Dock = "fill"
$address2Tbl.BackColor= ' '
$address2Tbl.CellBorderStyle = "Single"
$address2Tbl.AutoSize = $true
$address2Tbl.ColumnCount = 2
$address2Tbl.RowCount = 6

#کنترل دکمه بازگشت به صفحه اصلی
$ReturnBtn = New-Object system.Windows.Forms.Button
$ReturnBtn.Name = $retunBtnName
$ReturnBtn.BackColor = "#d2d4d6"
$ReturnBtn.text = "بازگشت به صفحه اصلی"
$ReturnBtn.width = 100
$ReturnBtn.height = 35
$ReturnBtn.Font = 'Microsoft Sans Serif,10'
$ReturnBtn.ForeColor = "#000"

#کنترل دکمه انصراف
$CancelBtn = New-Object system.Windows.Forms.Button
$CancelBtn.Name = $retunBtnName
$CancelBtn.BackColor = "#d2d4d6"
$CancelBtn.text = "انصراف"
$CancelBtn.width = 100
$CancelBtn.height = 35
$CancelBtn.Font = 'Microsoft Sans Serif,10'
$CancelBtn.ForeColor = "#000"


# رویداد کلیک دکمه انصراف
    $CancelBtn.Add_Click({
    $Mainform.Close()
    $Mainform.Dispose()
#& "$MainRoot\$($this.Name).ps1"
& "$MainRoot\desktop.ps1"
}.GetNewClosure())

#کنترل دکمه ذخیره به صفحه اصلی
$saveBtn = New-Object system.Windows.Forms.Button
$saveBtn.Name = $retunBtnName
$saveBtn.BackColor = "#d2d4d6"
$saveBtn.text = "ذخیره"
$saveBtn.width = 100
$saveBtn.height = 35
$saveBtn.Font = 'Microsoft Sans Serif,10'
$saveBtn.ForeColor = "#000"

#MainGroupboxControl                       -Created by atena jan 14 24 
$DesktopGB = New-Object system.Windows.Forms.Groupbox
$DesktopGB.Size = New-Object System.Drawing.Size(500,550)
#$DesktopGB.Dock = [System.Windows.Forms.DockStyle]::Fill
$DesktopGB.AutoSize = $true
$DesktopGB.BackColor = ''

#ddress1GroupboxControl                       -Created by atena jan 19 24 
$address1GB = New-Object system.Windows.Forms.Groupbox
$address1GB.Size = New-Object System.Drawing.Size(100,100)
#$address1GB.Dock = [System.Windows.Forms.DockStyle]::Fill
$address1GB.AutoSize = $true
$address1GB.BackColor = 'white'


#ddress2GroupboxControl                       -Created by atena jan 19 24 
$address2GB = New-Object system.Windows.Forms.Groupbox
$address2GB.Size = New-Object System.Drawing.Size(100,100)
#$address2GB.Dock = [System.Windows.Forms.DockStyle]::Fill
$address2GB.AutoSize = $true
$address2GB.BackColor = 'white'

#MainGBLblControl -                          -Created by atena jan 14 24 
$MainGBLbl = New-Object System.Windows.Forms.label
$MainGBLbl.Location = New-Object System.Drawing.size(520,-5)
$MainGBLbl.Size = New-Object System.Drawing.Size(250,20) 
$MainGBLbl.Text = "ایجــاد یا ویــرایــش اطـــلاعات تامـــیــن کنـنده" 
$MainGBLbl.Font = 'Arial'
$MainGBLbl.TextAlign=[System.Drawing.ContentAlignment]::BottomRight    

#address1GBLblControl -                          -Created by atena jan 14 24 
$address1GBLbl = New-Object System.Windows.Forms.label
$address1GBLbl.Location = New-Object System.Drawing.size(520,-5)
$address1GBLbl.Size = New-Object System.Drawing.Size(250,20) 
$address1GBLbl.Text = "ادرس ارسال/دریافت کالا" 
$address1GBLbl.Font = 'Arial'
$address1GBLbl.TextAlign=[System.Drawing.ContentAlignment]::BottomRight 

#address2GBLblControl -                          -Created by atena jan 14 24 
$address2GBLbl = New-Object System.Windows.Forms.label
$address2GBLbl.Location = New-Object System.Drawing.size(520,-5)
$address2GBLbl.Size = New-Object System.Drawing.Size(250,20) 
$address2GBLbl.Text = "ادرس ارسال/دریافت فاکتور" 
$address2GBLbl.Font = 'Arial'
$address2GBLbl.TextAlign=[System.Drawing.ContentAlignment]::BottomRight 
    
#SupplytCodeLbl -                           -Created by atena jan 19 24
$codeLbl = New-Object System.Windows.Forms.label
#$codeLbl.Location = New-Object System.Drawing.size(195,85)
#$codeLbl.Size = New-Object System.Drawing.Size(70,20) 
$codeLbl.Text = "کد تامین کننده" 
$codeLbl.TextAlign=[System.Drawing.ContentAlignment]::TopLeft
#$codeLbl.Visible = $False
$codeLbl.BackColor = 'yellow'

#Supplyaddress1countrynamelbl -                           -Created by atena jan 19 24
$country1Lbl = New-Object System.Windows.Forms.label
$country1Lbl.Text = "کشور" 
$country1Lbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight
$country1Lbl.BackColor = 'yellow'

#Supplyaddress1codelbl -                           -Created by atena jan 19 24
$addresscode1Lbl = New-Object System.Windows.Forms.label
$addresscode1Lbl.Text = "کد پستی" 
$addresscode1Lbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight
$addresscode1Lbl.BackColor = 'yellow'

#Supplyaddress2codelbl -                           -Created by atena jan 19 24
$addresscode2Lbl = New-Object System.Windows.Forms.label
$addresscode2Lbl.Text = "کد پستی" 
$addresscode2Lbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight
$addresscode2Lbl.BackColor = 'yellow'

#Supplyaddress1citynamelbl -                           -Created by atena jan 19 24
$city1Lbl = New-Object System.Windows.Forms.label
$city1Lbl.Text = "استان" 
$city1Lbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight
$city1Lbl.BackColor = 'yellow'

#Supplyaddress2countrynamelbl -                           -Created by atena jan 19 24
$country2Lbl = New-Object System.Windows.Forms.label
$country2Lbl.Text = "کشور" 
$country2Lbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight
$country2Lbl.BackColor = 'yellow'

#Supplyaddress2citynamelbl -                           -Created by atena jan 19 24
$city2Lbl = New-Object System.Windows.Forms.label
$city2Lbl.Text = "استان" 
$city2Lbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight
$city2Lbl.BackColor = ''


#supplycodetxtbox
$codetxtbox = New-Object System.Windows.Forms.TextBox
#$codetxtbox.TextAlign=[System.Drawing.ContentAlignment]::Topright
$codetxtbox.BackColor = 'blue'
                                       

#supplyaddress1countrytxtbox
$country1txtbox = New-Object System.Windows.Forms.TextBox
#$country1txtbox.TextAlign=[System.Drawing.ContentAlignment]::Topright
$country1txtbox.BackColor = 'blue'

#supplyaddress2countrytxtbox
$country2txtbox = New-Object System.Windows.Forms.TextBox
#$country2txtbox.TextAlign=[System.Drawing.ContentAlignment]::Topright
$country2txtbox.BackColor = 'blue'

#supplyaddress2citytxtbox
$city2txtbox = New-Object System.Windows.Forms.TextBox
#$city2txtbox.TextAlign=[System.Drawing.ContentAlignment]::Topright
$city2txtbox.BackColor = 'blue'

#supplyaddress1codetxtbox
$addresscode1txt = New-Object System.Windows.Forms.TextBox
#$addresscode1txt.TextAlign=[System.Drawing.ContentAlignment]::Topright
$addresscode1txt.BackColor = 'blue'

#supplyaddress2codetxtbox
$addresscode2txt = New-Object System.Windows.Forms.TextBox
#$addresscode2txt.TextAlign=[System.Drawing.ContentAlignment]::TopRight
$addresscode2txt.BackColor = 'blue'  

#Supplyfulladdress1lbl -                           -Created by atena jan 19 24
$fulladdress1lbl = New-Object System.Windows.Forms.label
$fulladdress1lbl.Text = "آدرس" 
$fulladdress1lbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight
$fulladdress1lbl.BackColor = 'yellow'   

#supplyfulladdress1codetxtbox
$fulladdress1txt = New-Object System.Windows.Forms.TextBox
#$fulladdress1txt.TextAlign=[System.Drawing.ContentAlignment]::Topright
$fulladdress1txt.BackColor = 'blue'      

#Supplyfulladdress2lbl -                           -Created by atena jan 19 24
$fulladdress2lbl = New-Object System.Windows.Forms.label
$fulladdress2lbl.Text = "آدرس" 
$fulladdress2lbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight
$fulladdress2lbl.BackColor = 'yellow'   

#supplyfulladdress2txtbox
$fulladdress2txt = New-Object System.Windows.Forms.TextBox
#$fulladdress2txt.TextAlign=[System.Drawing.ContentAlignment]::Topright
$fulladdress2txt.BackColor = 'blue'   

#Supplyaddress1Commentlbl -                           -Created by atena jan 19 24
$address1commentlbl = New-Object System.Windows.Forms.label
$address1commentlbl.Text = "توضیحات" 
$address1commentlbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight
$address1commentlbl.BackColor = 'yellow'

#supplyaddress1Commenttxtbox
$address1commenttxtbox = New-Object System.Windows.Forms.TextBox
#$addres1scommenttxtbox.TextAlign=[System.Drawing.ContentAlignment]::Topright
$address1commenttxtbox.BackColor = 'blue'   

#Supplyaddress2Commentlbl -                           -Created by atena jan 19 24
$address2commentlbl = New-Object System.Windows.Forms.label
$address2commentlbl.Text = "توضیحات" 
$address2commentlbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight
$address2commentlbl.BackColor = 'yellow'

#supplyaddress2Commenttxtbox
$address2commenttxtbox = New-Object System.Windows.Forms.TextBox
#$addres2scommenttxtbox.TextAlign=[System.Drawing.ContentAlignment]::TopRight
$address2commenttxtbox.BackColor = 'blue'                  

#SupplyCommentlbl -                           -Created by atena jan 19 24
$SupplyCommentlbl  = New-Object System.Windows.Forms.label
$SupplyCommentlbl.Text = "توضیحات" 
$SupplyCommentlbl.TextAlign=[System.Drawing.ContentAlignment]::TopRight
$SupplyCommentlbl.BackColor = 'yellow'

#SupplyCommenttxtbox
$SupplyCommenttxtbox = New-Object System.Windows.Forms.TextBox
#$SupplyCommenttxtbox.TextAlign=[System.Drawing.ContentAlignment]::Topright
$SupplyCommenttxtbox.BackColor = 'blue'   

                                         
#SupplyNameLbl -                           -Created by atena jan 14 24 
$NameLbl = New-Object System.Windows.Forms.label
#$NameLbl.Location = New-Object System.Drawing.size(195,85)
#$NameLbl.Size = New-Object System.Drawing.Size(70,20) 
$NameLbl.Text = "نام سازمان تامین کننده" 
$NameLbl.TextAlign=[System.Drawing.ContentAlignment]::TopLeft
#$NameLbl.Visible = $False
$NameLbl.BackColor = 'red'

#supplynametxtbox
$nametxtbox = New-Object System.Windows.Forms.TextBox
#$nametxtbox.TextAlign=[System.Drawing.ContentAlignment]::Topright
$nametxtbox.BackColor = 'blue'
                                         
#SupplycontactLbl -                           -Created by atena jan 14 24 
$SupplycontactLbl = New-Object System.Windows.Forms.label
#$SupplycontactLbl.Location = New-Object System.Drawing.size(195,85)
#$SupplycontactLbl.Size = New-Object System.Drawing.Size(70,20) 
$SupplycontactLbl.Text = "نام نماینده تامین کننده" 
$SupplycontactLbl.TextAlign=[System.Drawing.ContentAlignment]::TopLeft
#$SupplycontactLbl.Visible = $False
$SupplycontactLbl.BackColor = 'red'

#supplycontacttxtbox
$contacttxtbox = New-Object System.Windows.Forms.TextBox
#$contacttxtbox.TextAlign=[System.Drawing.ContentAlignment]::Topright
$contacttxtbox.BackColor = 'blue'

#SupplyWebsiteLbl -                           -Created by atena jan 19 24 
$WebsiteLbl = New-Object System.Windows.Forms.label
#$WebsiteLbl.Location = New-Object System.Drawing.size(195,85)
#$WebsiteLbl.Size = New-Object System.Drawing.Size(70,20) 
$WebsiteLbl.Text = "وبسایت تامین کننده" 
$WebsiteLbl.TextAlign=[System.Drawing.ContentAlignment]::TopLeft
#$WebsiteLbl.Visible = $False
$WebsiteLbl.BackColor = 'red'

#supplywebsitetxtbox
$websitetxtbox = New-Object System.Windows.Forms.TextBox
#$websitetxtbox.TextAlign=[System.Drawing.ContentAlignment]::Topright
$websitetxtbox.BackColor = 'blue'

#maintxtbox
$maintxtbox = New-Object System.Windows.Forms.TextBox
#$maintxtbox.TextAlign=[System.Drawing.ContentAlignment]::Topright
$maintxtbox.BackColor = 'blue'
$maintxtbox.Text = ' the end'
$maintxtbox.ForeColor = 'white'

# رویداد کلیک دکمه بازگشت به صفحه اصلی
    $ReturnBtn.Add_Click({
    $Mainform.Close()
    $Mainform.Dispose()
& "$MainRoot\$($this.Name).ps1"
}.GetNewClosure())

#اضافه کردن کنترلها به فرم و جدول اصلی
$MainTable.Controls.Add($ReturnBtn)
$Mainform.Controls.add($DesktopGB)
$DesktopGB.Controls.Add($MainTable)
$DesktopGB.Controls.Add($MainGBLbl)
$MainTable.Controls.Add($SupplyInfoTable)
$SupplyInfoTable.Controls.Add($codetxtbox)
$SupplyInfoTable.Controls.Add($codeLbl)
$SupplyInfoTable.Controls.Add($Nametxtbox)
$SupplyInfoTable.Controls.Add($NameLbl)
$SupplyInfoTable.Controls.Add($contacttxtbox)
$SupplyInfoTable.Controls.Add($SupplycontactLbl)
$SupplyInfoTable.Controls.Add($websitetxtbox)
$SupplyInfoTable.Controls.Add($WebsiteLbl)
#$SupplyInfoTable.Controls.Add()
$SupplyInfoTable.Controls.Add($address1tbl)
$address1Tbl.Controls.Add($address1GB)
#$address1GB.Controls.Add($address1GBLbl)
$address1Tbl.Controls.Add($address1GBLbl)
$address1Tbl.Controls.Add($country1txtbox)
$address1Tbl.Controls.Add($country1Lbl)
$address1Tbl.Controls.Add($city1txt)
$address1Tbl.Controls.Add($city1Lbl)
$address1Tbl.Controls.Add($addresscode1txt)
$address1Tbl.Controls.Add($addresscode1Lbl)
$address1Tbl.Controls.Add($fulladdress1txt)
$address1Tbl.Controls.Add($fulladdress1lbl)
$address1Tbl.Controls.Add($address1commenttxtbox)
$address1Tbl.Controls.Add($address1commentlbl)
$SupplyInfoTable.Controls.Add($address2Tbl)
$address2Tbl.Controls.Add($address2GB)
#$address2GB.controls.Add($address2Tbl)
$address2Tbl.Controls.Add($address2GBLbl)
$address2Tbl.Controls.Add($country2txtbox)
$address2Tbl.Controls.Add($country2Lbl)
$address2Tbl.Controls.Add($city2txt)
$address2Tbl.Controls.Add($city2Lbl)
$address2Tbl.Controls.Add($addresscode2txt)
$address2Tbl.Controls.Add($addresscode2Lbl)
$address2Tbl.Controls.Add($fulladdress2txt)
$address2Tbl.Controls.Add($fulladdress2lbl)
$address2Tbl.Controls.Add($address2commenttxtbox)
$address2Tbl.Controls.Add($address2commentlbl)
$SupplyInfoTable.Controls.Add($SupplyCommenttxtbox)
$SupplyInfoTable.Controls.Add($SupplyCommentlbl)
$SupplyInfoTable.Controls.Add($CancelBtn)
$SupplyInfoTable.Controls.Add($saveBtn)



[void]$Mainform.ShowDialog()
