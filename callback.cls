VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "callback"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'class for call back
Private objref As basetask
Private mineHere$
Private setstacklimit As Boolean
Private par1$, par2$
Public Event ErrorAtt(ByRef recover As Variant)
Public finished As Boolean
Private hTimer As Long, hTimer2
Dim locked As Boolean
Dim ExtForm As Object

Friend Sub NoPublic(bstack As basetask, where$)

        Set objref = New basetask
        Set objref.Sorosref = bstack.soros
        Set objref.Owner = bstack.Owner
        mineHere$ = where$
End Sub
Friend Sub GetIcon(a As StdPicture)
On Error Resume Next
Dim k As StdPicture
If IhaveExtForm Then
ExtForm.GetIcon PackData(a)
End If
End Sub
Private Function PackData(obj As Object) As String
    Dim pbTemp  As PropertyBag
    Set pbTemp = New PropertyBag
    With pbTemp
        Call .WriteProperty("icon", obj)
        Let PackData = .Contents
    End With
    
    Set pbTemp = Nothing
End Function
Property Get IhaveExtForm() As Boolean
IhaveExtForm = Not ExtForm Is Nothing
End Property
Public Sub SetExtCaption(a$)
On Error Resume Next
If ExtForm Is Nothing Then Exit Sub
If a$ = "" Then
Hide
Form1.CaptionW = ExtForm.CaptionW
Else
Show
ExtForm.CaptionW = a$
End If
End Sub
Public Sub GetForm(F As Object)

Set ExtForm = F
'If F Is Nothing Then Exit Sub

End Sub
Public Sub StackMax(stack As Long)
If IsWine Then
stacksize = 32000000
findstack = stacksize - 100000
Exit Sub
End If
If m_bInIDE Then
ClaimStack
If findstack - 100000 > 0 Then
    stacksize = findstack - 100000
End If
Exit Sub
End If
If stack = -12345 Then stacksize = 32000000: Exit Sub
If stack > 1000000 Then
 stacksize = stack - 100000
 findstack = stack
Else
ClaimStack
If findstack - 100000 > 0 Then
    stacksize = findstack - 100000
End If
End If
End Sub
Public Sub Cli(LoadFileAndSwitches$, Optional Prompt$ = ">")
par1$ = LoadFileAndSwitches$
par2$ = Prompt$
CliRun
End Sub
Public Sub Shutdown(Cancel As Integer)
If Cancel < 1 Then
Dim F As Form, i As Long, F1 As GuiM2000, nook As Long
For i = Forms.count - 1 To 0 Step -1
Set F = Forms(i)
If TypeOf F Is GuiM2000 Then
    Set F1 = F
    
    If Modalid <> 0 Then
        If F1.Modal = Modalid Then
            If F1.MyName$ <> "" Then
                
                    
                    F1.ByeBye2 nook
                
            End If
        End If
    Else
        If F1.MyName$ <> "" Then
        
        
        F1.ByeBye2 nook
        
        End If
    End If
End If
If nook Then Cancel = True: Exit For
Next i
Set F = Nothing


If Cancel Then Exit Sub
End If
byPassCallback = True
NOEXECUTION = True
If Cancel > 0 Then
NERR = True: NOEXECUTION = True
ExTarget = True: INK$ = Chr(27): UKEY$ = Chr$(27)  ': UINK$ = Chr(27)
End If
If Not TaskMaster Is Nothing Then
If TaskMaster.Processing Then
TaskMaster.StopProcess

End If
TaskMaster.Dispose
End If
If exWnd <> 0 Then
MyDoEvents
    nnn$ = "bye bye"
    exWnd = 0

    End If
'If form5iamloaded Then Unload Form5
Set ExtForm = Nothing
finished = True
End Sub
Public Sub AsyncCli(LoadFileAndSwitches$, Optional Prompt$ = ">")
par1$ = LoadFileAndSwitches$
par2$ = Prompt$
Set UseMe = Me
hTimer = SetTimer(0&, 0&, 10, AddressOf RunMe)
End Sub
Public Sub AsyncShow()
If hTimer2 Then Exit Sub
Set UseMe = Me
hTimer2 = SetTimer(0&, 0&, 10, AddressOf ShowForm1)
End Sub
Friend Sub CliRun()
Dim LoadFileAndSwitches$, Prompt$
LoadFileAndSwitches$ = par1$
Prompt$ = par2$
Dim ohere$, s$
If findstack = 0 Then ClaimStack
If findstack - 100000 > 0 Then
    stacksize = findstack - 100000
End If
If elevatestatus Then Exit Sub
If basestack1.Owner Is Nothing Then Exit Sub
elevatestatus = 1
ohere$ = here$
here$ = mineHere$
If LoadFileAndSwitches$ = vbNullString Then newshow objref
Form3.skiptimer = True
NoAction = True
NOEXECUTION = False
objref.toprinter = False
MOUT = False
ResetBreak
LastErNum = 0: LastErNum1 = 0
LastErName = vbNullString
LastErNameGR = vbNullString
s$ = LoadFileAndSwitches$
If Not ISSTRINGA(s$, cLine) Then
cLine = mylcasefILE(Trim(s$))
Else
cLine = mylcasefILE(cLine)
End If
While Left$(cLine, 1) = Chr(34) And Right$(cLine, 1) = Chr(34) And Len(cLine) > 2
cLine = Mid$(cLine, 2, Len(cLine) - 2)
Wend
If ExtractType(cLine) <> "gsb" Then cLine = vbNullString
If cLine <> "" Then
para$ = ExtractPath(cLine) + ExtractName(cLine)
para$ = Trim$(Mid$(cLine, Len(para$) + 1))
's$ = cLine + " " + s$
cLine = Left$(cLine, Len(cLine$) - Len(para$))
ElseIf s$ <> "" Then
para$ = Trim$(s$)
End If



Switches para$, True
If Trim$(para$) <> "" And Not Left$(para$, 1) Like "[+-]" Then interpret basestack1, para$
If Not INK$ = Chr(27) Then
Form1.MyPrompt cLine, Prompt$
End If
finalize:
here$ = ohere$
elevatestatus = 0
If IsWine Then
DoEvents
Sleep 5
End If
On Error Resume Next
If Not ExtForm Is Nothing Then ExtForm.Shutdown
finished = True
End Sub
Property Let ShowGui(RHS As Boolean)
If Forms.count = 0 Then Exit Property
If RHS Then
Form1.Visible = True
Form1.WindowState = 0
If Form1.Top >= VirtualScreenHeight Then Form1.Move ScrInfo(Console).Left, ScrInfo(Console).Top
Else
If Form1.WindowState = 0 Then
If Not (QRY Or GFQRY Or Forms.count > 5) Then Form1.Visible = False
End If
End If
End Property
Public Sub ExecuteStatement(ByVal code$)
Dim what$, pos As Long, func As Boolean, param$, drop$
If IsLabelOnly(code$, what$) > 4 Then
    func = True
ElseIf what$ = vbNullString Then
    Exit Sub
ElseIf LTrim$(code$) = vbNullString Then
' one call
Call Run(what$)
Exit Sub
End If
Do
 pos = 1
  drop$ = aheadstatus(code$, True, pos)
  If drop$ = vbNullString And pos > Len(code$) Then Exit Sub
  If param$ <> "" Then
  param$ = param$ + ", " + Left$(code$, pos - 1)
  Else
  param$ = Left$(code$, pos - 1)
  End If
  code$ = Mid$(code$, pos)
  Loop Until Not FastSymbol(code$, ",")
  If func Then
  Call Run(what$ + " " + param$ + ")")
  Else
  Call Run(what$ + " " + param$)
  End If
End Sub
Public Function Eval(code$) As Variant
Dim pos As Long, p As Double, s As String, drop$
 pos = 1
  drop$ = aheadstatus(code$, True, pos)
  If drop$ = vbNullString And pos > Len(code$) Then Exit Function
  If InStr(drop$, "N") Then
  If IsExp(objref, Left$(code$, pos), p) Then
  If Not objref.lastobj Is Nothing Then
  Set Eval = objref.lastobj
  
  Else
    Eval = p
   End If
  End If
  Else
  If IsStrExp(objref, Left$(code$, pos), s$) Then
  If Not objref.lastobj Is Nothing Then
      Set Eval = objref.lastobj
  Else
    Eval = s$
  End If
  End If
  End If
Set objref.lastobj = Nothing
End Function
Public Sub AddExecCode(code$)
If locked Then Exit Sub
Call Run(code$, False)
End Sub
Public Function Run(ByVal code$, Optional clean As Boolean = True) As Boolean
Dim ohere$, stay As Variant
If elevatestatus Then Exit Function
byPassCallback = False
 If basestack1.Owner Is Nothing Then Exit Function
elevatestatus = 1
If clean Then PushStage objref, 0
ohere$ = here$
here$ = mineHere$
NoAction = True
NOEXECUTION = False
objref.toprinter = False
MOUT = False
ResetBreak
Run = True
        LastErNum = 0: LastErNum1 = 0
        LastErName = vbNullString
        LastErNameGR = vbNullString
If Execute(objref, code$, False) <> 1 Then
        Run = False
                 MOUT = True
End If
If clean Or MOUT Or ExTarget Then
                Dim x As Form
                    For Each x In Forms
             
                    If Typename$(x) = "GuiM2000" Then Unload x
                    Next
                    Set x = Nothing
If NERR Then

RaiseEvent ErrorAtt(stay)
If Not stay Then GoTo finalize
End If
If Not objref Is Nothing Then
    objref.toprinter = False
Else
    Run = False: GoTo finalize
End If
    If MOUT Then
            NOEXECUTION = False
            ResetBreak
            MOUT = interpret(objref, "new: flush: clear")
            MOUT = False
        Else
        
        If NOEXECUTION Then
                closeAll
        End If

        End If
        
MOUT = True
NoAction = False

If ExTarget Then Run = False
End If
finalize:
here$ = ohere$

If clean Then
If Not objref Is Nothing Then PopStage objref Else Run = False
End If
elevatestatus = 0
End Function

Property Get ErrorGr() As String
ErrorGr = LastErNameGR
End Property
Property Get ErrorEn() As String
ErrorEn = LastErName
End Property


Property Get Status() As Long
If elevatestatus Then
Status = -elevatestatus
Else
Status = LastErNum
End If
End Property
Public Sub Reset()
elevatestatus = 0
    NERR = False
        LastErNum = 0: LastErNum1 = 0
        LastErName = vbNullString
        LastErNameGR = vbNullString
 'If Not App.StartMode = vbSModeStandalone Then
 
NeoSubMain
 
' End If

        
End Sub
Public Sub Show()
On Error Resume Next
If UseMe Is Nothing Then Exit Sub
Form1.CaptionW = ""
If ExtForm.WindowState = 0 Then ExtForm.Visible = True
End Sub

Public Sub Hide()
On Error Resume Next
If UseMe Is Nothing Then Exit Sub

ExtForm.Hide
End Sub
Public Function IamVisible() As Boolean
On Error Resume Next
If UseMe Is Nothing Then Exit Function

IamVisible = ExtForm.Visible
End Function
Private Sub Class_Initialize()
Dim anyname As Long
startaddress = VarPtr(anyname)
stacksize = 900000
 If Not l_complete Then NeoSubMain
        Set objref = New basetask
        Set objref.Owner = Form1.DIS
        mineHere$ = vbNullString 'HERE$
End Sub

Private Sub Class_Terminate()
StopTimer
Set objref.Owner = Nothing
Set objref.Sorosref = Nothing
Set objref = Nothing
globalstack.Flush
GarbageFlush
TerminateM2000
terminatefinal
l_complete = False
'MsgBox "terminate"
End Sub
Public Sub StopTimer()
  If hTimer <> 0 Then
  '' MasterTimer = 0
    KillTimer 0&, hTimer
    hTimer = 0
  End If
End Sub
Public Sub StopTimer2()
  If hTimer2 <> 0 Then
  '' MasterTimer = 0
    KillTimer 0&, hTimer2
    hTimer = 0
  End If
End Sub
Public Sub SetFocus()
If WindowState = 1 Then WindowState = 0
If Form1.Visible Then Form1.Show , Form5:   Form1.SetFocus

   
End Sub
Public Property Get WindowState() As Variant
WindowState = 1 - CLng(Form1.Visible Or Form1.TrueVisible)
End Property

Public Property Let WindowState(ByVal vNewValue As Variant)
If vNewValue = 1 Then
    If Form1.Visible Or Form1.TrueVisible Then
    Form1.TrueVisible = Form1.Visible Or Form1.TrueVisible
    Form1.Visible = False
     If Form4.Visible Then Form4.Visible = False: reopen4 = True
    If Form2.Visible Then If trace Then Form2.Visible = False: reopen2 = True
    End If
Else
        
        Form1.Visible = Form1.Visible Or Form1.TrueVisible
        If Form1.Visible Then
        If Not trace Then reopen2 = False
        If vH_title$ = vbNullString Then reopen4 = False
        If reopen4 Then Form4.Show , Form1: Form4.Visible = True
        If reopen2 Then Form2.Show , Form1: Form2.Visible = True
        Form1.Show
        End If
        
End If

End Property
