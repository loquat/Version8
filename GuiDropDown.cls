VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "GuiDropDown"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public WithEvents Textbox As myTextBox
Attribute Textbox.VB_VarHelpID = -1
Public WithEvents glistN As gList
Attribute glistN.VB_VarHelpID = -1
Public WithEvents Pad As Form
Attribute Pad.VB_VarHelpID = -1
Private mEnabled As Boolean
Dim Iam As Boolean
Public UseOnlyTheList As Boolean
'' autocomplete isn't check yet for GuiDropDown...
'' next...time...
Public AutoComplete As Boolean
Public NoCaseSensitive As Boolean
' gui own
Public ctrlName As String
Private mesCtrlName As String
Dim mIndex As Long, mStayOpen As Boolean, mMenuStyle As Boolean, mMenuWidth As Long
Dim Callback As GuiM2000
Dim mListText As String

Public Property Get GetCallBack() As Form
Set GetCallBack = Callback
End Property
Private Sub glistN_CtrlPlusF1()
  If mIndex >= 0 Then
   Callback.Callback mesCtrlName + ".About(" + Str(mIndex) + ")"
   Else
      Callback.Callback mesCtrlName + ".About()"
      End If
End Sub
 Public Sub Construct(there As Form, name$)
 Dim PadGui As GuiM2000
 mIndex = -1
 Set Callback = there
 Set PadGui = New GuiM2000
 Set Pad = PadGui
 On Error Resume Next
 Set glistN = Pad.Controls(1)
 If Err.Number > 0 Then
 Set glistN = Pad.Controls(1)
 End If
 PadGui.PopUpMenuVal = True
 With Pad
.gList2.HeadLine = vbNullString
.gList2.HeadLine = vbNullString
.gList2.HeadlineHeight = .gList2.HeightPixels
End With
 Set Textbox = New myTextBox
 ctrlName = GetTag$
 Set Textbox.Container = there.Controls.Add("m2000.glist", ctrlName)
 there.AddGuiControl Me
 glistN.Dynamic
 Textbox.glistN.Dynamic
 there.Controls(ctrlName).TabStop = True
 mesCtrlName = name$
End Sub
 Public Sub ConstructArray(there As Form, name$, i As Long)
 mIndex = i
 Set Callback = there
 Dim PadGui As GuiM2000
 Set PadGui = New GuiM2000
 Set Pad = PadGui

 On Error Resume Next
 Set glistN = Pad.Controls(1)
 If Err.Number > 0 Then
 Set glistN = Pad.Controls(1)
 End If
 PadGui.PopUpMenuVal = True
 With Pad
 .Controls(0).Visible = 0
 .gList2.HeadLine = vbNullString
.gList2.HeadLine = vbNullString
.gList2.HeadlineHeight = .gList2.HeightPixels
End With
 Set Textbox = New myTextBox
  ctrlName = GetTag$
 Set Textbox.Container = there.Controls.Add("m2000.glist", ctrlName)
 there.AddGuiControl Me
 glistN.Dynamic
 Textbox.glistN.Dynamic
 there.Controls(ctrlName).TabStop = True
 mesCtrlName = name$
End Sub

Public Sub Move(x, y, Optional w, Optional h)
With Textbox
If IsMissing(w) Then
.glistN.MoveTwips CLng(x), CLng(y), 0, 0
ElseIf IsMissing(h) Then
.glistN.MoveTwips CLng(x), CLng(y), CLng(w), 0
Else
.glistN.MoveTwips CLng(x), CLng(y), CLng(w), CLng(h)
End If
Pad.Move Pad.Left, Pad.Top, .glistN.widthtwips, .glistN.HeightTwips * 5
End With
glistN.restrictLines = 5
glistN.MoveTwips 0, 0, Pad.Width, Pad.Height
End Sub
Public Sub deconstruct()
If Not glistN Is Nothing Then glistN.Shutdown
Set glistN = Nothing
If Not Pad Is Nothing Then Unload Pad
If Not Textbox Is Nothing Then Textbox.Dereference
Set Textbox = Nothing
Set Callback = Nothing
Set Pad = Nothing
End Sub
Public Sub FontAttr(ThisFontName, Optional ThisMode = -1, Optional ThisBold = True)
Dim aa As New StdFont
If ThisFontName <> "" Then

aa.name = ThisFontName

If ThisMode > 7 Then aa.Size = ThisMode Else aa = 7
aa.bold = ThisBold
Set Textbox.glistN.Font = aa
End If
End Sub
Public Property Get index() As Long
index = mIndex
End Property

Public Property Set Container(glistNN As gList)
Set glistN = glistNN
glistNN.enabled = True
glistNN.NoPanRight = True
glistNN.SingleLineSlide = True
glistNN.LeaveonChoose = True
glistNN.LeftMarginPixels = 8
glistNN.VerticalCenterText = True
glistNN.StickBar = True ' try with false - or hold shift to engage false
glistNN.NoFreeMoveUpDown = True
If Not Textbox Is Nothing Then
Textbox.Prompt = ChrW(&H25BC) + " "
End If
End Property
Public Property Get ListText()
ListText = glistN.ListValue
End Property
Public Property Let Label(a$)
Textbox.Prompt = a$ + " " + ChrW(&H25BC) & " "
Textbox.glistN.ShowMe
End Property



Private Sub glistN_MenuChecked(item As Long)
'
  If mIndex >= 0 Then
   Callback.Callback mesCtrlName + ".MenuChecked(" + Str(mIndex) + "," + Str(glistN.ListIndex) + ")"
   Else
      Callback.Callback mesCtrlName + ".MenuChecked(" + Str(glistN.ListIndex) + ")"
      End If
End Sub
Property Let menuEnabled(item As Long, ByVal RHS As Boolean)
glistN.menuEnabled(item) = RHS
End Property

Property Get menuEnabled(item As Long) As Boolean
menuEnabled = Not glistN.ListSep(item)
End Property
Public Function GetMenuId(Id$, pos As Long) As Boolean
'
GetMenuId = glistN.GetMenuId(Id$, pos)
End Function
Property Get Id(item As Long) As String
'
Id = glistN.Id(item)
End Property


Private Sub glistN_RefreshOnly()
glistN.PrepareToShow
End Sub

Private Sub glistN_RegisterGlist(this As gList)
Dim mo As Object
Set mo = glistN.Parent
If Not mo Is Nothing Then
On Error Resume Next
mo.hookme this
If Err.Number > 0 Then this.NoWheel = True
End If
Set mo = Nothing
End Sub




Private Sub Class_Terminate()
Set Textbox = Nothing
Set glistN = Nothing
If Not Pad Is Nothing Then Unload Pad
Set Pad = Nothing
End Sub

Private Sub glistN_CheckGotFocus()
Textbox.SkipProcAtExitFocus = True
If Textbox.glistN.TabStopSoft Then Callback.LastActive = ctrlName

Textbox.glistN.NoCaretShow = True
glistN.ForeColor = rgb(0, 0, 0)
glistN.backcolor = rgb(255, 255, 255)
glistN.NoCaretShow = False:
glistN.PanPos = 0
Textbox.glistN.dropkey = False
End Sub
Private Sub glistN_CheckLostFocus()
If Textbox.SkipProcAtExitFocus Then
Textbox.Retired
Textbox.SkipProcAtExitFocus = False
Callback.LastActive = ""
Else
Pad.Visible = False
End If
Iam = True

End Sub

Private Sub glistN_KeyDown(KeyCode As Integer, Shift As Integer)
If KeyCode = vbKeyLeft Or KeyCode = vbKeyRight Then
If Textbox.glistN.EditFlag Then
Iam = True
glistN.BypassLeaveonChoose = True
If Textbox.glistN.TabStopSoft Then Callback.LastActive = ctrlName
Textbox.SetFocus
Else
KeyCode = 9
Iam = False
glistN.BypassLeaveonChoose = True

Textbox.SetFocus
Pad.Visible = False
End If
ElseIf KeyCode = 9 Then
KeyCode = 0
Iam = False
glistN.BypassLeaveonChoose = True

Textbox.SetFocus
Pad.Visible = False
End If
End Sub

Private Sub glistN_PanLeftRight(Direction As Boolean)
Dim item As Long
If Direction = True Then
item = glistN.ListIndex
If mMenuStyle Then
If glistN.ListSep(item) Then Exit Sub
If glistN.ListRadio(item) Then
    glistN.ListSelected(item) = True
    
End If
Else
Textbox.vartext = glistN.list(item): Textbox.SelStart = Len(Textbox.Text) + 1
End If
 Textbox.SetFocus
   If mIndex >= 0 Then
   Callback.Callback mesCtrlName + ".DblClick(" + Str(mIndex) + "," + Str(item) + ")"
   Else
      Callback.Callback mesCtrlName + ".DblClick(" + Str(item) + ")"
      End If
      
  
End If
End Sub
Private Sub glistN_ScrollMove(item As Long)
'
   If mIndex >= 0 Then
   Callback.Callback mesCtrlName + ".Move(" + Str(mIndex) + "," + Str(item) + ")"
   Else
      Callback.Callback mesCtrlName + ".Move(" + Str(item) + ")"
      End If
End Sub

Private Sub glistN_ScrollSelected(item As Long, y As Long)
   If mIndex >= 0 Then
   Callback.Callback mesCtrlName + ".Scroll(" + Str(mIndex) + "," + Str(item) + ")"
   Else
      Callback.Callback mesCtrlName + ".Scroll(" + Str(item) + ")"
      End If
End Sub


Public Property Get list(index) As Variant
On Error Resume Next
list = glistN.list(CLng(index))
End Property
Public Property Let list(index, RHS As Variant)
On Error Resume Next
glistN.list(CLng(index)) = CStr(RHS)
End Property

Private Sub glistN_Selected(item As Long)
If glistN.PanPos <> 0 Then glistN.PanPos = 0
   If mIndex >= 0 Then
   Callback.Callback mesCtrlName + ".Click(" + Str(mIndex) + "," + Str(item) + ")"
   Else
      Callback.Callback mesCtrlName + ".Click(" + Str(item) + ")"
      End If
      
End Sub

Private Sub Pad_Activate()
glistN.SetFocus
End Sub

Private Sub Pad_Deactivate()
'Pad.UNhookMe
End Sub

Private Sub Textbox_CtrlPlusF1()
  If mIndex >= 0 Then
   Callback.Callback mesCtrlName + ".About(" + Str(mIndex) + ")"
   Else
      Callback.Callback mesCtrlName + ".About()"
      End If
End Sub

Private Sub Textbox_DeployMenu()
On Error Resume Next
Textbox.SetFocus
'If Iam Then
ShowMenu
End Sub

Private Sub textbox_KeyDown(KeyCode As Integer, Shift As Integer)
Dim b$
Dim gl As Long, x As Long, x1 As gList, XX As Boolean
Iam = True
If KeyCode = vbKeyRight And Len(MenuGroup) <> 0 Then
Set x1 = Textbox.glistN
Dim obj As gList
With Callback
.LastActive = vbNullString
For x = 1 To .Controls.count - 1

    If TypeOf .Controls(x) Is gList Then
    If XX Then
        If .Controls(x).enabled And .Controls(x).TabStop Then
            If .Controls(x).MenuGroup = x1.MenuGroup Then
  
            Textbox.Retired

            .Controls(x).ShowMenu: Exit For
            
            End If
        End If
    Else
    Set obj = .Controls(x)
        If obj Is x1 Then XX = True
        Set obj = Nothing
    End If
    End If
    
Next x

End With
Set x1 = Nothing
ElseIf KeyCode = vbKeyLeft And Len(MenuGroup) <> 0 Then
Set x1 = Textbox.glistN
With Callback
.LastActive = vbNullString
For x = .Controls.count - 1 To 1 Step -1
    If TypeOf .Controls(x) Is gList Then
    If XX Then
        If .Controls(x).enabled And .Controls(x).TabStop Then
            If .Controls(x).MenuGroup = x1.MenuGroup Then
         
                    Textbox.Retired
                    .Controls(x).ShowMenu: Exit For
           End If
         
        End If
    Else
     Set obj = .Controls(x)
        If obj Is x1 Then XX = True
        Set obj = Nothing
    End If
    End If
Next x
End With
Set x1 = Nothing
ElseIf KeyCode = vbKeyDown Or (KeyCode = vbKeyReturn And UseOnlyTheList) Then
Iam = False
If glistN.listcount > 0 Then Callback.LastActive = ""

If Pad.Visible Then If glistN.Visible Then glistN.enabled = True: Textbox.SkipProcAtExitFocus = True: glistN.SetFocus: Exit Sub

    KeyCode = 0
 If mIndex >= 0 Then
   Callback.Callback mesCtrlName + ".OpenMenu(" + Str(mIndex) + "," + Str(-1) + ")"
   Else
      Callback.Callback mesCtrlName + ".OpenMenu(" + Str(-1) + ")"
      End If
    gl = glistN.listcount
     If gl = 0 Then
     '  If Callback.Visible Then Callback.SetFocus
        Exit Sub
     End If
     If mMenuStyle Then
     If mMenuWidth > 1000 Then
     Pad.Width = mMenuWidth
     Else
     Pad.Width = Callback.Controls(ctrlName).Width
     End If
     Else
Pad.Width = CLng(Callback.Controls(ctrlName).Width / 1.618 * dv15) \ dv15
End If
If Callback.Controls(ctrlName).Height * gl < VirtualScreenHeight() * 2 / 5 Then

'Pad.Height = (((Callback.Controls(ctrlName).Height * gl) \ dv15) + 1) * dv15
'glistN.restrictLines = gl
Pad.Height = Callback.Controls(ctrlName).Height * gl
Debug.Print Pad.Height
glistN.restrictLines = gl
Else
glistN.restrictLines = (VirtualScreenHeight() * 2 / 5) \ Callback.Controls(ctrlName).Height
Pad.Height = Callback.Controls(ctrlName).Height * glistN.restrictLines

End If
glistN.AutoHide = False
glistN.StickBar = False
glistN.ShowBar = False
glistN.MoveTwips 0, 0, Pad.Width, Pad.Height

    Textbox.SkipProcAtExitFocus = True
    Textbox.glistN.NoCaretShow = True
    Textbox.glistN.ShowPan
    glistN.LeaveonChoose = True
   ' glistN.SetFocus
 If AutoComplete Then
  glistN.moveto Text
  If glistN.ListIndex < 0 Then
  glistN.ListIndex = 0
  Else
  'glistN.ShowPan '
 glistN.ShowThis glistN.ListIndex + 1
  
  End If
  Else
        If glistN.LastSelected >= 0 Then
        glistN.ListIndex = glistN.LastSelected - 1
    ElseIf mMenuStyle Then
    glistN.ListindexPrivateUseFirstFree 0
    Else
    glistN.moveto Text
        If glistN.ListIndex < 0 Then
  glistN.ListIndex = 0
  Else
glistN.ShowPan
 
  End If
  
    End If
End If
'Hook Pad.hWnd, glistN
    If mMenuWidth <> 0 Then
    Callback.PopUpPos Pad, Left, Top, Callback.Controls(ctrlName).Height
    Else
Callback.PopUpPos Pad, Left + Callback.Controls(ctrlName).Width - Pad.Width, Top, Callback.Controls(ctrlName).Height
End If
If Textbox.glistN.TabStopSoft Then Callback.LastActive = ctrlName

ElseIf KeyCode = vbKeyTab Then
Callback.LastActive = ""
Textbox.SkipProcAtExitFocus = False
Pad.Visible = False
'glistN.Visible = False
ElseIf AutoComplete And KeyCode = vbKeyRight And Textbox.SelStart >= Len(Textbox.Text) Then
b$ = Myleft$(Textbox.glistN.LastLinePart, 1)
If b$ <> "" Then Textbox.glistN.LastLinePart = Mid$(Textbox.glistN.LastLinePart, 2)
Textbox.Text = Textbox.Text + b$
ElseIf KeyCode = vbKeyReturn Then
If Edit Then
If Textbox.glistN.TabStopSoft Then Callback.LastActive = ctrlName

  If mIndex >= 0 Then
   Callback.Callback mesCtrlName + ".DblClick(" + Str(mIndex) + "," + Str(-1) + ")"
   Else
      Callback.Callback mesCtrlName + ".DblClick(" + Str(-1) + ")"
      End If
   End If
End If


End Sub
Function Myleft$(a As Variant, pos As Variant)
Myleft$ = Mid$(a, 1, pos)
End Function

Private Sub TextBox_KeyPress(KeyAscii As Integer)
Iam = KeyAscii = 9
If KeyAscii = 9 Then Pad.Visible = False
End Sub

Private Sub textbox_LostFocus()
Textbox.glistN.NoCaretShow = True
'If Iam Or Not mMenuStyle Or glistN.listcount = 0 Then

If Textbox.glistN.BackStyle = 1 Then Textbox.glistN.CenterText = True

If Callback.LastActive <> ctrlName Then Textbox.glistN.ShowMe: Callback.LastActive = ctrlName

glistN.BypassLeaveonChoose = False
If Iam Then

Pad.Visible = False

Else

If Not glistN.enabled Then

glistN.enabled = True
End If
End If

End Sub
Private Sub textbox_GotFocus()
 Textbox.glistN.NoCaretShow = Not Textbox.enabled
 If Not Iam Then If Textbox.glistN.TabStopSoft Then Callback.LastActive = ctrlName

 If Textbox.glistN.BackStyle = 1 Then Textbox.glistN.CenterText = False
 
 Textbox.glistN.ShowMe
If Pad.Visible Then

glistN.enabled = False
glistN.BypassLeaveonChoose = False
End If
End Sub
Private Sub glistN_Selected2(item As Long)
If glistN.ListSep(item) Then Exit Sub
If item >= 0 Then
If mMenuStyle Then
If glistN.ListSep(item) Then Exit Sub
If glistN.ListRadio(item) Then
    glistN.ListSelected(item) = True
    
End If
Else
Textbox.vartext = glistN.list(item): Textbox.SelStart = Len(Textbox.Text) + 1
End If

Pad.UNhookMe
Textbox.SetFocus

   If mIndex >= 0 Then
   Callback.Callback mesCtrlName + ".DblClick(" + Str(mIndex) + "," + Str(item) + ")"
   Else
      Callback.Callback mesCtrlName + ".DblClick(" + Str(item) + ")"
      End If
       
Else 'If item < -1 Then
'glistN.Visible = False

Pad.Visible = False
End If
End Sub


Private Sub textbox_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
Dim gl As Long

If Textbox.glistN.DblClick Then
Iam = False

 Textbox.glistN.ShowMe2

 End If

 If Pad.Visible Then Iam = True: Exit Sub



If (Button And 1) = 1 And Not Pad.Visible Then

 If mIndex >= 0 Then
   Callback.Callback mesCtrlName + ".OpenMenu(" + Str(mIndex) + "," + Str(-1) + ")"
   Else
      Callback.Callback mesCtrlName + ".OpenMenu(" + Str(-1) + ")"
      End If
gl = glistN.listcount
If gl = 0 Then Exit Sub

Textbox.glistN.dropkey = True
If glistN.Visible Then glistN.enabled = True: Textbox.SkipProcAtExitFocus = True: glistN.SetFocus: Textbox.glistN.dropkey = False: Exit Sub

If mMenuStyle Then
     If mMenuWidth > 1000 Then
     Pad.Width = mMenuWidth
     Else
     Pad.Width = Callback.Controls(ctrlName).Width
     End If
     Else
Pad.Width = CLng(Callback.Controls(ctrlName).Width / 1.618 * dv15) \ dv15
End If

If Callback.Controls(ctrlName).Height * gl < ScrY() * 2 / 5 Then

Pad.Height = Callback.Controls(ctrlName).Height * gl
glistN.restrictLines = gl

Else
glistN.restrictLines = (ScrY() * 2 / 5) \ Callback.Controls(ctrlName).Height
Pad.Height = Callback.Controls(ctrlName).Height * glistN.restrictLines

End If

glistN.MoveTwips 0, 0, Pad.Width, Pad.Height
glistN.AutoHide = False
glistN.StickBar = False
glistN.ShowBar = False
    Textbox.SkipProcAtExitFocus = True
    glistN.LeaveonChoose = True
  If AutoComplete Then
        glistN.moveto Text
        If glistN.ListIndex < 0 Then
        glistN.ListIndex = 0
        Else
        glistN.ShowThis glistN.ListIndex + 1
        
         End If
  Else
        If glistN.LastSelected >= 0 Then
             glistN.ListIndex = glistN.LastSelected
    ElseIf mMenuStyle Then
    glistN.ListindexPrivateUseFirstFree 0
    Else
            glistN.moveto Text
                If glistN.ListIndex < 0 Then
                glistN.ListIndex = 0
                Else
                glistN.ShowThis glistN.ListIndex + 1
                
                End If
    End If
    End If
'Hook Pad.hWnd, glistN
    If mMenuWidth <> 0 Then
    Callback.PopUpPos Pad, Left, Top, Callback.Controls(ctrlName).Height
    Else
Callback.PopUpPos Pad, Left + Callback.Controls(ctrlName).Width - Pad.Width, Top, Callback.Controls(ctrlName).Height
End If


Button = 0
Textbox.glistN.dropkey = False
Iam = Not Pad.Visible

End If

End Sub
Private Sub glistN_SyncKeyboard(item As Integer)
Static F As Long
F = glistN.FindItemStartWidth(Chr$(item), Not NoCaseSensitive, F + 1)
If F >= 0 Then
glistN.ScrollTo F - glistN.lines / 2, F + 1
    If mIndex >= 0 Then
   Callback.Callback mesCtrlName + ".PickOther(" + Str(mIndex) + ",{" + glistN.ListValue + "})"
   Else
      Callback.Callback mesCtrlName + ".PickOther({" + glistN.ListValue + "})"
      End If
Else
F = -1
End If
End Sub

Private Sub TextBox_ValidString(ThatString As String, setpos As Long)
Dim l As Boolean
If Not AutoComplete Then Exit Sub
Dim F As Long
Iam = True
If ThatString = vbNullString And Textbox.glistN.LastLinePart <> "" Then
F = glistN.FindItemStartWidth(Textbox.glistN.LastLinePart, Not NoCaseSensitive, 0)

Else
F = glistN.FindItemStartWidth(ThatString, Not NoCaseSensitive, 0)
End If
If F >= 0 Then
If Not NoCaseSensitive Then ThatString = Myleft$(glistN.list(F), Len(ThatString))
Textbox.glistN.LastLinePart = Mid$(glistN.list(F), Len(ThatString) + 1)
'RaiseEvent AutoCompleteDone(glistN.List(f))
   If mIndex >= 0 Then
   Callback.Callback mesCtrlName + ".AutoCompleteDone(" + Str(mIndex) + ",{" + glistN.list(F) + "})"
   Else
      Callback.Callback mesCtrlName + ".AutoCompleteDone({" + glistN.list(F) + "})"
      End If

glistN.enabled = False
glistN.ScrollTo F - glistN.lines / 2, F + 1
glistN.enabled = True
glistN.ShowMe

Else
If UseOnlyTheList Then
l = Textbox.glistN.enabled
Textbox.glistN.enabled = False
Textbox.glistN.LastLinePart = Textbox.vartext + Textbox.glistN.LastLinePart
ThatString = vbNullString
setpos = 0
Textbox.glistN.enabled = l
Else
Textbox.glistN.LastLinePart = vbNullString
End If
End If
End Sub

Public Property Get Text() As String
Text = Textbox.vartext + Textbox.glistN.LastLinePart
End Property

Public Property Let Text(ByVal RHS As String)
On Error Resume Next
If glistN Is Nothing Then Exit Property
 Textbox.glistN.LastLinePart = vbNullString
Textbox.vartext = RHS

End Property
Public Property Get locked() As Boolean
locked = Textbox.locked
End Property

Public Property Let locked(ByVal RHS As Boolean)
If RHS = Textbox.locked Then Exit Property
If RHS Then
If Not Textbox.locked Then
glistN.BypassLeaveonChoose = True

Textbox.SetFocus
glistN.BypassLeaveonChoose = False
End If
End If
Textbox.locked = RHS
End Property
Public Sub additem(a$)
glistN.additemFast a$
Text = a$
End Sub

Public Sub additemFast(a$)
glistN.additemFast a$
End Sub
Public Sub MenuItem(a$, Optional enabledthis As Boolean = True, Optional checked As Boolean = False, Optional radiobutton As Boolean = False, Optional firstate As Boolean = False, Optional IdD)
Dim item
mMenuStyle = True
If Not a$ = vbNullString Then
glistN.additemFast a$
End If
item = glistN.listcount
If a$ = vbNullString Then
glistN.AddSep
Else
If IsMissing(IdD) Then
glistN.MenuItem item, checked, radiobutton, firstate

Else
glistN.MenuItem item, checked, radiobutton, firstate, CStr(IdD)
End If
glistN.menuEnabled(CLng(item - 1)) = enabledthis
End If
End Sub
Public Sub MenuRadio(a$, Optional enabledthis As Boolean = True, Optional firstate As Boolean = False, Optional IdD)
Dim item, checked As Boolean
checked = False
mMenuStyle = True
If Not a$ = vbNullString Then
glistN.additemFast a$
End If
item = glistN.listcount
If a$ = vbNullString Then
glistN.AddSep
Else
If IsMissing(IdD) Then
glistN.MenuItem item, True, True, False

Else
glistN.MenuItem item, True, True, False, CStr(IdD)
End If
If firstate Then glistN.ListSelectedNoRadioCare(CLng(item - 1)) = True
glistN.menuEnabled(CLng(item - 1)) = enabledthis
End If
End Sub

Property Let ListRadioPrivate(item As Long, RHS As Boolean)
glistN.ListSelectedNoRadioCare(item) = RHS
End Property
Property Get ListSelected(item As Long) As Boolean
ListSelected = glistN.ListSelected(item)
End Property
Property Let ListSelected(item As Long, RHS As Boolean)
glistN.ListSelected(item) = RHS
End Property
Property Get ListChecked(item As Long) As Boolean
ListChecked = glistN.ListChecked(item)
End Property
Property Let ListChecked(item As Long, RHS As Boolean)
glistN.ListChecked(item) = RHS
End Property
Property Get ListMenu(item As Long) As Boolean
ListMenu = glistN.ListMenu(item)
End Property

Property Get ListRadio(item As Long) As Boolean
ListRadio = glistN.ListRadio(item)
End Property
Property Let ListRadio(item As Long, RHS As Boolean)
glistN.ListRadio(item) = RHS
End Property
Property Get ListSep(item As Long) As Boolean
ListSep = glistN.ListSep(item)
End Property
Property Let ListSep(item As Long, RHS As Boolean)
glistN.ListSep(item) = RHS
End Property
Public Sub Shutdown()
'new
glistN.Shutdown
glistN.enabled = False
Textbox.locked = True

End Sub

Public Sub SetUp()
'white = rgb(255, 255, 255)
'black = 0
'dimm1 = rgb(100, 200, 160)
'dimm2 = rgb(200, 120, 60)

Dim ff As New StdFont
Dim ff1 As New StdFont
With Callback
ff.name = .CtrlFontName
ff.charset = Form1.DIS.Font.charset
ff.Size = .CtrlFontSize
ff.bold = .CtrlFontBold
ff1.name = .CtrlFontName
ff1.charset = Form1.DIS.Font.charset
ff1.Size = .CtrlFontSize
ff1.bold = .CtrlFontBold


End With
Set Textbox.glistN.Font = ff1
Textbox.FadePartColor = &H777777
Textbox.Retired
With glistN

.SingleLineSlide = True
.NoPanLeft = True
.NoPanRight = False
.Vertical = True
.VerticalCenterText = True
.Text = mListText
.backcolor = 0 'dimm2

.MoveTwips 0, 0, Pad.Width, Pad.Height

Set .Font = ff
.ForeColor = Callback.Controls(1).ForeColor

.dcolor = rgb(127, 127, 127)
.NoCaretShow = False
.enabled = True
.StickBar = True
enabled = True
.ShowMe
End With

End Sub

Public Property Let ListText(ByVal vNewValue As Variant)
mListText = vNewValue
glistN.Text = mListText
End Property
Public Property Get enabled() As Boolean
enabled = Textbox.glistN.enabled
End Property

Public Property Let enabled(ByVal RHS As Boolean)
Textbox.glistN.enabled = RHS
End Property

Public Property Get Edit() As Boolean
Edit = Textbox.glistN.EditFlag
End Property

Public Property Let Edit(ByVal RHS As Boolean)
With Textbox
.glistN.EditFlag = RHS
.glistN.NoCaretShow = Not RHS
End With
End Property
Public Property Get Left() As Variant
Left = Callback.Controls(ctrlName).Left
End Property

Public Property Let Left(ByVal RHS As Variant)
Callback.Controls(ctrlName).Left = RHS
End Property
Public Property Get Top() As Variant
Top = Callback.Controls(ctrlName).Top
End Property
Public Property Let Top(ByVal RHS As Variant)
Callback.Controls(ctrlName).Top = RHS
End Property
Public Sub Sort(Optional SkipChar As Long = 1)
If glistN.listcount < 2 Then Exit Sub
Dim doc As Document, m As Long
Set doc = New Document
doc.textDocFast = glistN.Text
m = glistN.ListIndex
If SkipChar < 1 Then SkipChar = 1
doc.SortDoc SkipChar, 1, glistN.listcount
glistN.Text = doc.textDoc
If m > 0 Then glistN.ListindexPrivateUse = m
glistN.ShowMe2
Set doc = Nothing
End Sub
Public Property Get Find(ByVal FindThis$) As Variant
    Find = glistN.Find(FindThis)
End Property
Public Property Get ListIndex() As Variant
ListIndex = glistN.ListIndex
End Property

Public Property Let ListIndex(ByVal vNewValue As Variant)
glistN.ListIndex = CLng(vNewValue)
glistN.ShowPan

End Property
Public Property Let ListIndex2(ByVal vNewValue As Variant)
glistN.ListindexPrivateUse = CLng(vNewValue)
End Property
Public Property Get listcount() As Variant
listcount = glistN.listcount
End Property
Public Property Get MaxCharLength() As Long
MaxCharLength = Textbox.glistN.maxchar
End Property

Public Property Let MaxCharLength(ByVal RHS As Long)
Textbox.glistN.maxchar = RHS
End Property
Public Property Let ShowAlways(ByVal vNewValue As Variant)
mStayOpen = CBool(vNewValue)
Textbox.ShowAlways = CBool(vNewValue)
End Property

Sub GetFocus()
On Error Resume Next
Callback.Controls(ctrlName).SetFocus
End Sub


Public Property Get MenuStyle() As Variant
MenuStyle = mMenuStyle
End Property

Public Property Let MenuStyle(ByVal vNewValue As Variant)
mMenuStyle = vNewValue
If mMenuStyle Then
glistN.BorderStyle = 1
Textbox.vartext = vbNullString
End If
End Property

Public Property Get MenuWidth() As Variant
MenuWidth = mMenuWidth
End Property

Public Property Let MenuWidth(ByVal vNewValue As Variant)
mMenuWidth = vNewValue
End Property
Public Sub Clear()
On Error Resume Next
Iam = False
Pad.Visible = False
glistN.Clear

Textbox.SetFocus
End Sub
Public Property Let Mark(item)
glistN.dcolor = mycolor(item)
End Property
Public Sub Remove(item)
On Error Resume Next
If item < 0 Then Exit Sub
glistN.Removeitem item
End Sub
Public Sub Insert(item, a$)
On Error Resume Next
glistN.ListindexPrivateUse = item
If glistN.ListIndex > -1 Then
glistN.additemAtListIndex a$
End If
End Sub
Public Sub MenuItemAtListIndex(Optional enabledthis As Boolean = True, Optional checked As Boolean = False, Optional radiobutton As Boolean = False, Optional firstate As Boolean = False, Optional IdD)
Dim item
mMenuStyle = True
item = glistN.ListIndex
If item < 0 Then Exit Sub
If IsMissing(IdD) Then
glistN.MenuItem item, checked, radiobutton, firstate

Else
glistN.MenuItem item, checked, radiobutton, firstate, CStr(IdD)
End If
glistN.menuEnabled(CLng(item - 1)) = enabledthis
End Sub


Public Property Get MenuGroup() As Variant
MenuGroup = Textbox.glistN.MenuGroup
End Property

Public Property Let MenuGroup(ByVal RHS As Variant)
Textbox.glistN.MenuGroup = RHS
End Property

Public Property Get BorderStyle() As Variant
BorderStyle = glistN.BorderStyle
End Property

Public Property Let BorderStyle(ByVal vNewValue As Variant)
glistN.BorderStyle = vNewValue
End Property
Public Sub ShowMenu()
If mMenuStyle Then
    If glistN.listcount <> 0 Then textbox_KeyDown vbKeyDown, 0
End If
End Sub
Sub Transparent()
Dim x  As Long, y As Long
Textbox.glistN.BackStyle = 1
Textbox.glistN.GetLeftTop x, y
Textbox.glistN.RepaintFromOut Callback.Image, x, y
End Sub
Public Property Get FadePartColor() As Variant
FadePartColor = Textbox.FadePartColor
End Property

Public Property Let FadePartColor(ByVal vNewValue As Variant)
On Error Resume Next
Textbox.FadePartColor = CLng(vNewValue)
End Property
Public Property Let Default(RHS)
On Error Resume Next
If CBool(RHS) Then Callback.Default = ctrlName
End Property
