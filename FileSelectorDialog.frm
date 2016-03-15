VERSION 5.00
Begin VB.Form LoadFile 
   AutoRedraw      =   -1  'True
   BackColor       =   &H003B3B3B&
   BorderStyle     =   0  'None
   ClientHeight    =   8145
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   3690
   BeginProperty Font 
      Name            =   "Arial"
      Size            =   14.25
      Charset         =   161
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H00FFFFFF&
   Icon            =   "FileSelectorDialog.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8145
   ScaleWidth      =   3690
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin M2000.gList gList1 
      Height          =   3600
      Left            =   135
      TabIndex        =   0
      Top             =   720
      Width           =   3420
      _ExtentX        =   6033
      _ExtentY        =   6350
      Max             =   1
      Vertical        =   -1  'True
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   161
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Enabled         =   -1  'True
      dcolor          =   65535
      Backcolor       =   3881787
      ForeColor       =   14737632
      CapColor        =   9797738
   End
   Begin M2000.gList gList2 
      Height          =   495
      Left            =   135
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   180
      Width           =   3420
      _ExtentX        =   6033
      _ExtentY        =   873
      Max             =   1
      Vertical        =   -1  'True
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   161
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Enabled         =   -1  'True
      Backcolor       =   3881787
      ForeColor       =   16777215
      CapColor        =   16777215
   End
   Begin M2000.gList glist3 
      Height          =   375
      Left            =   180
      TabIndex        =   2
      Top             =   7635
      Width           =   3420
      _ExtentX        =   6033
      _ExtentY        =   661
      Max             =   1
      Vertical        =   -1  'True
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   161
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Enabled         =   -1  'True
      Backcolor       =   8421504
      ForeColor       =   14737632
      CapColor        =   49344
   End
End
Attribute VB_Name = "LoadFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Declare Function CopyFromLParamToRect Lib "user32" Alias "CopyRect" (lpDestRect As RECT, ByVal lpSourceRect As Long) As Long
Private noChangeColorGlist3 As Boolean
Public WithEvents mySelector As FileSelector
Attribute mySelector.VB_VarHelpID = -1
Private Declare Function DestroyCaret Lib "user32" () As Long
Dim height1 As Long, width1 As Long
Public TEXT1 As myTextBox
Attribute TEXT1.VB_VarHelpID = -1
Private Type myImage
    image As StdPicture
    Height As Long
    Width As Long
    top As Long
    Left As Long
End Type
Dim Image1 As myImage
Dim iTop As Long, iLeft As Long, iwidth As Long, iheight As Long
Dim nopreview As Boolean
Dim oldLeftMarginPixels As Long
Dim firstpath As Long
Dim setupxy As Single
Dim Lx As Long, ly As Long, dr As Boolean
Dim scrTwips As Long
Dim bordertop As Long, borderleft As Long
Dim allwidth As Long, itemWidth As Long
Dim dirlistindex As Long
Dim dirlisttop As Long
  Dim ihave As Boolean



Private Sub Form_Load()
height1 = 8145 * DYP / 15
width1 = 3690 * DXP / 15
UnHook3 hWnd
loadfileiamloaded = True
scrTwips = Screen.TwipsPerPixelX
' clear data...
setupxy = 20
Set mySelector = New FileSelector
gList3.LeaveonChoose = True
gList3.VerticalCenterText = True
gList3.restrictLines = 1
gList3.PanPos = 0
firstpath = False
nopreview = False
oldLeftMarginPixels = 0
gList2.CapColor = rgb(255, 160, 0)
gList2.HeadLine = ""

gList2.FloatList = True
gList2.MoveParent = True
gList3.NoPanRight = False
gList1.NoPanLeft = False

Set TEXT1 = New myTextBox
Set TEXT1.Container = gList3

nopreview = True
'fHeight = gList1.Height
Set mySelector = New FileSelector
With mySelector
Set .glistN = gList1
Set .TEXT1 = TEXT1
gList1.NoCaretShow = True
.NostateDir = True
End With
If SetUp = SetUpGR Then
With gList1

.VerticalCenterText = True
.additemFast "���������� ����"
.menuEnabled(0) = False
.additemFast "  ������������"
.additemFast "  �����"
.additemFast "  ����"
.MenuItem 2, False, True, False, "time"
.MenuItem 3, False, True, False, "name"
.MenuItem 4, False, True, False, "type"
.addsep
.additemFast "����������"
.menuEnabled(5) = False
.additemFast "  ��� ������"
.additemFast "  ��� 3 ��������"
.additemFast "  ����� ����"
.MenuItem 7, True, True, False, "normal"
.MenuItem 8, True, True, False, "3levels"
.MenuItem 9, True, True, False, "recur"
.addsep
.additemFast "�����������"
.menuEnabled(10) = False
.additemFast "  ������ �� �����"
.additemFast "  �������� �������"
.additemFast "  �������� �������"
.MenuItem 12, True, False, False, "push"
.MenuItem 13, True, False, False, "multi"
.MenuItem 14, True, False, False, "expand"
.addsep
.additemFast "���� ��� �������"
.additemFast "������� ��� ������"
.addsep
.additemFast "�����������"
.menuEnabled(18) = False
.additemFast "������ ����� �� ����"
.menuEnabled(19) = False
.additemFast "������� ��� ������� �"
.menuEnabled(20) = False
.additemFast "�� ����� ���� ��� �����"
.menuEnabled(21) = False
.addsep
.additemFast "������� ������ 2014"
.menuEnabled(23) = False

oldLeftMarginPixels = .LeftMarginPixels + 10
.LeftMarginPixels = 0
PlaceSettings
ReadSettings
End With

Else
With gList1
.VerticalCenterText = True
.additemFast "Sort Type"
.menuEnabled(0) = False
.additemFast "  By Time Stamp"
.additemFast "  By Name"
.additemFast "  By Type"
.MenuItem 2, False, True, False, "time"
.MenuItem 3, False, True, False, "name"
.MenuItem 4, False, True, False, "type"
.addsep
.additemFast "Performance"
.menuEnabled(5) = False
.additemFast "  Normal"
.additemFast "  Recursive 3 levels"
.additemFast "  Recursive"
.MenuItem 7, True, True, False, "normal"
.MenuItem 8, True, True, False, "3levels"
.MenuItem 9, True, True, False, "recur"
.addsep
.additemFast "Behavior"
.menuEnabled(10) = False
.additemFast "  Push to Scroll"
.additemFast "  MultiSelect"
.additemFast "  Expand Width"
.MenuItem 12, True, False, False, "push"
.MenuItem 13, True, False, False, "multi"
.MenuItem 14, True, False, False, "expand"
.addsep
.additemFast "Undo Changes"
.additemFast "Abord and Exit"
.addsep
.additemFast "Information"
.menuEnabled(18) = False
.additemFast "slide right in the textbox"
.menuEnabled(19) = False
.additemFast "down side to return file"
.menuEnabled(20) = False
.additemFast "or double click the file list"
.menuEnabled(21) = False
.addsep
.additemFast "George Karras 2014"
.menuEnabled(23) = False

oldLeftMarginPixels = .LeftMarginPixels + 10
.LeftMarginPixels = 0
PlaceSettings
ReadSettings
End With

End If
With mySelector
.NostateDir = False
 lastfactor = ScaleDialogFix(SizeDialog)
If ExpandWidth Then
If LastWidth = 0 Then LastWidth = -1
Else
LastWidth = -1
End If
ScaleDialog lastfactor, DialogPreview, LastWidth
''UserFileName = .Mydir.ExtractName(UserFileName)
UserFileName = ""
.FileTypesToDisplay = FileTypesShow
.Mydir.Nofiles = FolderOnly
.Mydir.TopFolder = TopFolder

If ReturnFile <> "" Then
UserFileName = .Mydir.ExtractName(ReturnFile)
.selectedFile = .Mydir.ExtractName(ReturnFile)
gList3.ShowMe
.FilePath = ExtractPath(ReturnFile)
If .TEXT1 <> .Mydir.ExtractName(ReturnFile) Then .TEXT1 = .Mydir.ExtractName(ReturnFile)
ReturnFile = ""
Else
.FilePath = ExtractPath(TopFolder)
End If

End With

If FolderOnly Then
gList2.HeadLine = SelectFolderCaption
ElseIf SaveDialog Then
gList2.HeadLine = SaveFileCaption
Else
gList2.HeadLine = LoadFileCaption
End If
gList2.HeadlineHeight = gList2.HeightPixels
gList2.SoftEnterFocus
If selectorLastX = -1 And selectorLastY = -1 Then
Else
Move selectorLastX, selectorLastY
End If
'If TEXT1 <> "" Then
TEXT1.Locked = False
gList3.listindex = 0
gList3.SoftEnterFocus
If gList1.Value <> gList1.listindex Then
gList1.Spinner = True
gList1.Value = gList1.listindex
gList1.Spinner = False
End If
End Sub



Private Sub Form_MouseDown(Button As Integer, shift As Integer, x As Single, y As Single)
If Button = 1 Then

If lastfactor = 0 Then lastfactor = 1

If bordertop < 150 Then
If (y > Height - 150 And y < Height) And (x > Width - 150 And x < Width) Then
dr = True
mousepointer = vbSizeNWSE
Lx = x
ly = y
End If

Else
If (y > Height - bordertop And y < Height) And (x > Width - borderleft And x < Width) Then
dr = True
mousepointer = vbSizeNWSE
Lx = x
ly = y
End If

End If
End If
End Sub

Private Sub Form_MouseMove(Button As Integer, shift As Integer, x As Single, y As Single)
Dim addX As Long, addy As Long, factor As Single, Once As Boolean
If Once Then Exit Sub
If Button = 0 Then dr = False
If bordertop < 150 Then
If (y > Height - 150 And y < Height) And (x > Width - 150 And x < Width) Then mousepointer = vbSizeNWSE Else mousepointer = 0
 Else
 If (y > Height - bordertop And y < Height) And (x > Width - borderleft And x < Width) Then mousepointer = vbSizeNWSE Else mousepointer = 0
End If
If dr Then
    If y < (Height - bordertop) Or y > Height Then addy = (y - ly)
    If x < (Width - borderleft) Or x > Width Then addX = (x - Lx)
    
   If Not ExpandWidth Then addX = 0
        If lastfactor = 0 Then lastfactor = 1
        factor = lastfactor

        
  
        Once = True
        If Height > ScrY() Then addy = -(Height - ScrY()) + addy
        If Width > ScrX() Then addX = -(Width - ScrX()) + addX
        If (addy + Height) / height1 > 0.4 And ((Width + addX) / width1) > 0.4 Then

        If addy <> 0 Then
         If ((addy + Height) / height1) > ScrY() Then
      addX = 0
      addy = 0
         Else
        SizeDialog = ((addy + Height) / height1)
        End If
        End If
        lastfactor = ScaleDialogFix(SizeDialog)


        If ((Width * lastfactor / factor + addX) / Height * lastfactor / factor) < (width1 / height1) Then
        addX = -Width * lastfactor / factor - 1
      
           End If

        If addX = 0 Then
        If lastfactor <> factor Then ScaleDialog lastfactor, DialogPreview, Width
        Lx = x
        
        Else
        Lx = x * lastfactor / factor
         ScaleDialog lastfactor, DialogPreview, (Width + addX) * lastfactor / factor
         End If

        
         
        
        LastWidth = Width
        gList2.HeadlineHeight = gList2.HeightPixels
        gList2.PrepareToShow
        mySelector.ResetHeightSelector
        gList1.PrepareToShow
       
      
        ly = ly * lastfactor / factor
    
        'End If
        End If
        Else
        Lx = x
        ly = y
   
End If
Once = False
End Sub

Private Sub Form_MouseUp(Button As Integer, shift As Integer, x As Single, y As Single)
If dr Then Me.mousepointer = 0
dr = False
End Sub
Private Sub Form_Unload(Cancel As Integer)
DestroyCaret
Dim i As Long, filetosave As String
If mySelector.mselChecked Then
ReturnListOfFiles = ""
With mySelector
For i = 0 To .Mydir.listcount - 1
' prepare list for files
If .Mydir.ReadMark(i) Then
    If .recnowchecked Then
 filetosave = .Mydir.FindFolder(i) + .Mydir.List(i)
    Else
    filetosave = .Mydir.path + .Mydir.List(i)
    End If
If ReturnListOfFiles = "" Then
ReturnListOfFiles = filetosave
Else
ReturnListOfFiles = ReturnListOfFiles & "#" & filetosave
End If
End If
Next i
End With
ElseIf FolderOnly Then
If ReturnFile <> "" Then
If Not mySelector.Mydir.isdir(ReturnFile) Then MakeFolder ReturnFile
If Not mySelector.Mydir.isdir(ReturnFile) Then ReturnFile = ""
End If
End If
Set Image1.image = Nothing
Image1.Width = 0

selectorLastX = Left
selectorLastY = top
Sleep 200
loadfileiamloaded = False
End Sub
Private Sub MakeFolder(ByVal a$)
a$ = Left$(a$, Len(a$) - 1)
On Error Resume Next
MkDir a$
Sleep 1
End Sub

Private Sub gList1_ExposeItemMouseMove(Button As Integer, ByVal item As Long, ByVal x As Long, ByVal y As Long)

Static doubleclick As Long

If mySelector.IamBusy Then Exit Sub
If item = -1 Then
    If Button = 1 And x > gList1.WidthPixels - setupxy And y < setupxy Then
    doubleclick = doubleclick + 1
      If doubleclick > 1 Then
      doubleclick = 0
FlipList
    End If

    End If
Else
doubleclick = 0

End If
End Sub
Private Sub FlipList()
        If Not gList1.HeadLine = SetUp Then
                dirlisttop = gList1.ScrollFrom
                dirlistindex = gList1.listindex
                mySelector.NostateDir = True
                gList1.LeftMarginPixels = oldLeftMarginPixels
                gList1.HeadLine = "" ' reset
                gList1.HeadLine = SetUp
                gList1.ScrollTo 0
                gList1.ListindexPrivateUse = 1
                gList1.ShowMe
        Else
                GetSettings
                If Not ReadSettings Then
                mySelector.NostateDir = False
                gList1.ScrollTo dirlistindex
                gList1.ListindexPrivateUse = dirlistindex
                gList1.LeftMarginPixels = 0
                gList1.HeadLine = ""
                gList1.HeadLine = " "
                mySelector.ResetHeightSelector
                gList1.PrepareToShow
                Else
                mySelector.NostateDir = False
                gList1.LeftMarginPixels = 0
                gList1.HeadLine = ""
                gList1.HeadLine = " "
                mySelector.reload
                mySelector.ResetHeightSelector
                gList1.PrepareToShow
                End If
        End If

End Sub




Private Sub gList1_GotFocus()
If gList1.listindex = -1 Then gList1.listindex = gList1.ScrollFrom
End Sub

Private Sub gList1_HeaderSelected(Button As Integer)
If Button = 1 And Not mySelector.NostateDir Then
gList1.CapColor = rgb(0, 160, 0)
gList1.ShowMe2
gList1.refresh
mySelector.reload
gList1.CapColor = rgb(106, 128, 149)
gList1.ShowMe2
End If
End Sub

Private Sub gList1_KeyDown(KeyCode As Integer, shift As Integer)
If KeyCode = vbKeyEscape Then
mySelector.AbordAll
CancelDialog = True
Unload Me
End If
End Sub



Private Sub gList1_selected2(item As Long)
If mySelector.NostateDir = True Then
' we ar in setup
Select Case item
Case 15
PlaceSettings
gList1.ScrollTo 0
Case 16
With mySelector
.AbordAll
.selectedFile = ""
End With
CancelDialog = True
Unload Me
End Select
End If
End Sub

Private Sub gList1_SyncKeyboard(item As Integer)
If item = 8 Then
    FlipList
    item = 0
End If
End Sub

Private Sub gList2_ExposeItemMouseMove(Button As Integer, ByVal item As Long, ByVal x As Long, ByVal y As Long)
If gList2.DoubleClickCheck(Button, item, x, y, CLng(setupxy) / 2, CLng(setupxy) / 2, CLng(setupxy) / 2, -1) Then
                      mySelector.AbordAll
                      Unload Me
End If
End Sub


Private Sub gList1_ExposeRect(ByVal item As Long, ByVal thisrect As Long, ByVal thisHDC As Long, skip As Boolean)
If item = -1 Then
mySelector.FillThere thisHDC, thisrect, gList1.CapColor
FillThereMyVersion2 thisHDC, thisrect, &HF0F0F0
skip = True
End If
End Sub
Private Sub gList2_ExposeRect(ByVal item As Long, ByVal thisrect As Long, ByVal thisHDC As Long, skip As Boolean)
If item = -1 Then
mySelector.FillThere thisHDC, thisrect, gList2.CapColor
FillThereMyVersion thisHDC, thisrect, &H999999
skip = True
End If
End Sub




Private Sub glist3_CheckGotFocus()
       gList3.BackColor = rgb(0, 160, 0)
    gList3.ShowMe2
    noChangeColorGlist3 = True
End Sub

Private Sub glist3_ExposeItemMouseMove(Button As Integer, ByVal item As Long, ByVal x As Long, ByVal y As Long)
If gList3.EditFlag Then Exit Sub
    If gList3.List(0) = "" Then
    gList3.BackColor = &H808080
    gList3.ShowMe2
    Exit Sub
    End If
 
If Button = 1 Then
  gList3.LeftMarginPixels = gList3.WidthPixels - gList3.UserControlTextWidth(gList3.List(0)) / Screen.TwipsPerPixelX
       gList3.BackColor = rgb(0, 160, 0)
    gList3.ShowMe2
Else

    gList3.LeftMarginPixels = 8
 If Not noChangeColorGlist3 Then gList3.BackColor = &H808080
   gList3.ShowMe2


End If


End Sub



Private Sub glist3_KeyDown(KeyCode As Integer, shift As Integer)
If Not mySelector.Mydir.isReadOnly(mySelector.Mydir.path) Then
If Not gList3.EditFlag Then

If NewFolder Then

If Not (gList1.listindex = -1) Then
gList1.listindex = -1
gList1.ShowMe2
gList3.clear
gList3.SelStart = 1
TEXT1 = "NewFolder"
End If
    gList3.LeftMarginPixels = 8
  gList3.BackColor = &H808080
  
gList3.EditFlag = True
gList3.NoCaretShow = False
gList3.BackColor = &H0
gList3.ForeColor = &HFFFFFF
ElseIf Not FileExist Then
If Not (gList1.listindex = -1) Then
gList1.listindex = -1
gList1.ShowMe2
gList3.clear
gList3.SelStart = 1
If UserFileName <> "" Then
TEXT1 = UserFileName
Else
TEXT1 = "NewFile"
End If
End If
    gList3.LeftMarginPixels = 8
  gList3.BackColor = &H808080
  
gList3.EditFlag = True
gList3.NoCaretShow = False
gList3.BackColor = &H0
gList3.ForeColor = &HFFFFFF
Else
If KeyCode = vbKeyReturn Then GoTo HERE
End If
gList3.ShowMe2
KeyCode = 0

ElseIf KeyCode = vbKeyReturn Then
HERE:
DestroyCaret
If TEXT1 <> "" Then
gList3.EditFlag = False
gList3.Enabled = False
glist3_PanLeftRight True
End If
KeyCode = 0
End If
End If

End Sub

Private Sub glist3_LostFocus()
 noChangeColorGlist3 = False
gList3.BackColor = &H808080
gList3.ShowMe2
End Sub

Private Sub glist3_PanLeftRight(Direction As Boolean)
Dim that As New recDir, tt As Integer
If TEXT1 = "" Then Exit Sub

If Direction Then
If mySelector.Mydir.path = "" Then
If gList2.HeadLine = SelectFolderCaption And TEXT1 <> "" And TEXT1 <> ".." Then
ReturnFile = TEXT1 & "\"
Else
ReturnFile = ""
End If
mySelector.AbordAll
Unload Me
Else
If TEXT1 <> "" Then
TEXT1 = mySelector.Mydir.CleanName(TEXT1.Text)

    If mySelector.Mydir.Nofiles Then
        If TEXT1 = SelectFolderButton Then
            ReturnFile = mySelector.GetPath
        ElseIf TEXT1.glistN.EditFlag Then
            ReturnFile = mySelector.GetPath + TEXT1 & "\"
        ElseIf mySelector.glistN.listindex >= 0 Then
            ReturnFile = Mid$(mySelector.Mydir.List(mySelector.glistN.listindex), 2) & "\"
        Else
         ReturnFile = mySelector.GetPath + TEXT1 & "\"
    End If
    Else

        ReturnFile = mySelector.GetPath + gList3.List(0)
        
    End If

mySelector.AbordAll
gList1.Enabled = False
gList2.Enabled = False
TEXT1.Enabled = False
Unload Me
Else
Beep
End If
End If
End If
End Sub

Private Sub gList3_Selected2(item As Long)
If item = -2 Then
If gList3.PanPos <> 0 Then
glist3_PanLeftRight (True)
Exit Sub
End If

gList3.LeftMarginPixels = 8
gList3.BackColor = &H808080
gList3.ForeColor = &HE0E0E0
gList3.EditFlag = False
gList3.NoCaretShow = True


ElseIf Not mySelector.Mydir.isReadOnly(mySelector.Mydir.path) Then
If NewFolder Then
If Not (gList1.listindex = -1) Then
gList1.listindex = -1
gList1.ShowMe2
TEXT1 = "NewFolder"
End If
    gList3.LeftMarginPixels = 8
  gList3.BackColor = &H808080
  
gList3.EditFlag = True
gList3.NoCaretShow = False
gList3.BackColor = &H0
gList3.ForeColor = &HFFFFFF
ElseIf Not FileExist Then
If Not (gList1.listindex = -1) Then
gList1.listindex = -1
gList1.ShowMe2
If UserFileName <> "" Then
TEXT1 = UserFileName
Else
TEXT1 = "NewFile"
End If
End If
    gList3.LeftMarginPixels = 8
  gList3.BackColor = &H808080
  
gList3.EditFlag = True
gList3.NoCaretShow = False
gList3.BackColor = &H0
gList3.ForeColor = &HFFFFFF
End If
End If
gList3.ShowMe2
End Sub



Private Sub mySelector_DoubleClick(file As String)
ReturnFile = file
mySelector.AbordAll
Unload Me
End Sub

Private Sub mySelector_NewHeadline(newpath As String)
If firstpath = 0 Then
Else
If Not SaveDialog Then TEXT1 = ""
 Line (0, 0)-(ScaleWidth - dv15, ScaleHeight - dv15), Me.BackColor, BF

Set LoadApicture = LoadPicture("")
End If
firstpath = firstpath + 1
End Sub
Public Property Set LoadApicture(aImage As StdPicture)
On Error Resume Next
Dim sc As Double
Set Image1.image = Nothing
Image1.Width = 0
If aImage Is Nothing Then Exit Property
If aImage.Width = 0 Then Exit Property
Set Image1.image = aImage
If (aImage.Width / iwidth) < (aImage.Height / iheight) Then
sc = aImage.Height / iheight
ImageMove Image1, iLeft + (iwidth - aImage.Width / sc) / 2, iTop, aImage.Width / sc, iheight
Else
sc = aImage.Width / iwidth
ImageMove Image1, iLeft, iTop + (iheight - aImage.Height / sc) / 2, iwidth, aImage.Height / sc
End If


Image1.Height = aImage.Height
Image1.Width = aImage.Width
End Property
Private Sub mySelector_TraceFile(file As String)
If Not DialogPreview Then
TEXT1 = mySelector.Mydir.List(mySelector.glistN.listindex)
refresh
Else
Dim aImage As StdPicture, sc As Single
Static ihave As Boolean
If ihave Then Exit Sub
mySelector.glistN.Enabled = False
' read ratio
 Line (0, 0)-(ScaleWidth - dv15, ScaleHeight - dv15), Me.BackColor, BF

Set LoadApicture = LoadPicture("")
On Error Resume Next
Err.clear
'If FileLen(file) > 1500000 Then Image1.refresh
Set aImage = LoadPicture(GetDosPath(file))
If file = "" Or Err.Number > 0 Then Exit Sub
ihave = True
 Line (0, 0)-(ScaleWidth - dv15, ScaleHeight - dv15), Me.BackColor, BF

Set LoadApicture = LoadPicture(GetDosPath(file))
refresh
TEXT1 = mySelector.Mydir.List(mySelector.glistN.listindex)
mySelector.glistN.Enabled = True

ihave = False
End If
End Sub



Private Sub Text1_KeyPress(KeyAscii As Integer)
If KeyAscii = 13 Then
KeyAscii = 0
Beep
End If
End Sub
Public Sub FillThereMyVersion2(thathDC As Long, thatRect As Long, thatbgcolor As Long)
Dim a As RECT, b As Long
b = CLng(Rnd * 3) + setupxy / 3

CopyFromLParamToRect a, thatRect
a.Left = a.Right - setupxy
a.top = b
a.Bottom = b + setupxy / 5
mySelector.FillThere thathDC, VarPtr(a), thatbgcolor
a.top = b + setupxy / 5 + setupxy / 10
a.Bottom = b + setupxy \ 2
mySelector.FillThere thathDC, VarPtr(a), thatbgcolor

End Sub
Public Sub FillThereMyVersion(thathDC As Long, thatRect As Long, thatbgcolor As Long)
Dim a As RECT, b As Long
b = 2
CopyFromLParamToRect a, thatRect
a.Left = b
a.Right = setupxy - b
a.top = b
a.Bottom = setupxy - b
mySelector.FillThere thathDC, VarPtr(a), 0
b = 5
a.Left = b
a.Right = setupxy - b
a.top = b
a.Bottom = setupxy - b
mySelector.FillThere thathDC, VarPtr(a), rgb(255, 160, 0)


End Sub
Sub PlaceSettings()
' using global var settings
Dim a() As String, i As Long, j As Long
a() = Split(Settings, ",")
For i = 0 To gList1.listcount - 1
gList1.ListSelectedNoRadioCare(i) = False
Next i
For i = LBound(a()) To UBound(a())
If gList1.GetMenuId(a(i), j) Then
gList1.ListSelectedNoRadioCare(j) = True
End If
Next i
End Sub
Function ReadSettings() As Boolean
' using global var settings
' we have to read at NostateDir=true
Dim a() As String, i As Long, j As Long
a() = Split(Settings, ",")
' reset some flags
gList1.StickBar = False
mySelector.mselChecked = False
multifileselection = False
ExpandWidth = False
For i = LBound(a()) To UBound(a())
While gList1.Id(j) <> a(i)
j = j + 1
Wend
j = j + 1  ' now we are in base 1
Select Case j
Case 2, 3, 4
If Not (mySelector.Mydir.SortType = j - 2) Then
mySelector.SortType = j - 2
ReadSettings = True
End If

mySelector.SortType = j - 2
Case 7  ' normal
If (mySelector.recnowchecked Or mySelector.recnow3checked) Then
ReadSettings = True
End If
mySelector.recnowchecked = False
mySelector.recnow3checked = False
Case 8  ' recursive plus level = 3
If Not (mySelector.recnowchecked And mySelector.recnow3checked) Then
ReadSettings = True
End If
mySelector.recnowchecked = True
mySelector.recnow3checked = True
Case 9  ' recursive
If Not (mySelector.recnowchecked And Not mySelector.recnow3checked) Then
ReadSettings = True
End If
mySelector.recnowchecked = True
mySelector.recnow3checked = False
Case 12 ' stickbar
gList1.StickBar = True ' plays for the two lists
Case 13 ' multiselect
mySelector.mselChecked = True
multifileselection = True
Case 14 ' Expand Width
ExpandWidth = True
End Select


Next i
End Function

Sub GetSettings()
Dim s As String, i As Long
For i = 0 To gList1.listcount - 1
If gList1.ListSelected(i) = True Then
If s = "" Then s = gList1.Id(i) Else s = s & "," & gList1.Id(i)
End If
Next i
Settings = s
End Sub
Function ScaleDialogFix(ByVal factor As Single) As Single
gList2.FontSize = 14.25 * factor
factor = gList2.FontSize / 14.25
gList1.FontSize = 11.25 * factor
factor = gList1.FontSize / 11.25
ScaleDialogFix = factor
End Function
Sub ScaleDialog(ByVal factor As Single, PreviewFile As Boolean, Optional NewWidth As Long = -1)
On Error Resume Next
lastfactor = factor
gList1.addpixels = 10 * factor
gList3.FontSize = 11.25 * factor
mySelector.PreserveNpixelsHeaderRight = 20 * factor
setupxy = 20 * factor
oldLeftMarginPixels = 30 * factor
If mySelector.NostateDir Then
gList1.LeftMarginPixels = oldLeftMarginPixels
End If


bordertop = 10 * scrTwips * factor
borderleft = bordertop
Dim heightTop As Long, heightSelector As Long, HeightPreview As Long, HeightBottom As Long
Dim shapeHeight As Long
heightTop = 30 * factor * scrTwips
HeightBottom = 30 * factor * scrTwips
' some space here
If Not PreviewFile Then
heightSelector = 450 * factor * scrTwips
If 12 - mySelector.HeadLinesNum < 0 Then
gList1.restrictLines = 0
Else
gList1.restrictLines = 13 - mySelector.HeadLinesNum
End If
Else
If 6 - mySelector.HeadLinesNum < 0 Then
gList1.restrictLines = 0
Else
gList1.restrictLines = 6 - mySelector.HeadLinesNum
End If
heightSelector = 240 * factor * scrTwips
gList1.restrictLines = 6
End If
HeightPreview = 180 * factor * scrTwips
shapeHeight = 160 * factor * scrTwips  ' and width
' some space here
HeightBottom = 30 * factor * scrTwips
If (NewWidth < 0) Or NewWidth <= (246 * scrTwips * factor) Then
NewWidth = 246 * scrTwips * factor
End If
itemWidth = (NewWidth - 2 * borderleft)
allwidth = NewWidth 'itemWidth + 2 * borderleft
Dim allheight As Long
gList2.FloatLimitTop = ScrY() - bordertop - heightTop
gList2.FloatLimitLeft = ScrX() - borderleft * 3
If PreviewFile Then
allheight = bordertop + heightTop + bordertop + heightSelector + bordertop + HeightPreview + bordertop + HeightBottom + bordertop
Else
allheight = bordertop + heightTop + bordertop + heightSelector + bordertop + HeightBottom + bordertop

End If

Move Left, top, allwidth, allheight
gList2.Move borderleft, bordertop, itemWidth, heightTop
gList1.Move borderleft, 2 * bordertop + heightTop, itemWidth, heightSelector
gList3.Move borderleft, allheight - HeightBottom - bordertop, itemWidth, HeightBottom

If iwidth = 0 Then iwidth = itemWidth
If iheight = 0 Then iheight = HeightPreview
If Image1.Width = 0 Then
Image1.Width = iwidth
Image1.Height = iheight
End If
If PreviewFile Then
Dim curIwidth As Long, curIheight As Long, sc As Single
curIwidth = Image1.Width
curIheight = Image1.Height
iLeft = borderleft
iTop = 3 * bordertop + heightTop + heightSelector
iwidth = itemWidth
iheight = HeightPreview
 Line (0, 0)-(ScaleWidth - dv15, ScaleHeight - dv15), Me.BackColor, BF
If (curIwidth / iwidth) < (curIheight / iheight) Then
sc = curIheight / iheight
ImageMove Image1, iLeft + (iwidth - curIwidth / sc) / 2, iTop, curIwidth / sc, iheight
Else
sc = curIwidth / iwidth
ImageMove Image1, iLeft, iTop + (iheight - curIheight / sc) / 2, iwidth, curIheight / sc
End If
''Shape1.Move borderleft, 3 * bordertop + heightTop + 240 * factor * scrTwips + 10 * scrTwips, itemWidth, shapeHeight
''Image1.Visible = True
''Shape1.Visible = True
Else
''Image1.Visible = False
''Shape1.Visible = False
End If
End Sub
Private Sub ImageMove(a As myImage, neoTop As Long, NeoLeft As Long, NeoWidth As Long, NeoHeight As Long)
If a.image Is Nothing Then Exit Sub


If a.image.Width = 0 Then Exit Sub
If a.image.Type = vbPicTypeIcon Then

Dim aa As New cDIBSection
aa.BackColor = BackColor
aa.CreateFromPicture a.image
aa.ResetBitmapTypeToBITMAP
PaintPicture aa.Picture, neoTop, NeoLeft, NeoWidth, NeoHeight
Else
PaintPicture a.image, neoTop, NeoLeft, NeoWidth, NeoHeight
End If
refresh
End Sub
Private Sub gList1_RegisterGlist(this As gList)
Set LastGlist3 = this
End Sub
Public Sub hookme(this As gList)
Set LastGlist3 = this
End Sub

