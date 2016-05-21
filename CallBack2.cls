VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CallBack2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'class for call back
Private objref As basetask
Private mineHere$
Event ErrorAtt(ByRef recover As Variant)
Dim locked As Boolean
Friend Sub NoPublic(bstack As basetask, where$)
        Set objref = New basetask
        Set objref.Sorosref = bstack.soros
        Set objref.Owner = bstack.Owner
        mineHere$ = where$
End Sub
Public Sub ExecuteStatement(ByVal code$)
Dim what$, pos As Long, func As Boolean, param$
If IsLabelOnly(code$, what$) > 4 Then
    func = True
ElseIf what$ = "" Then
    Exit Sub
ElseIf LTrim$(code$) = "" Then
' one call
Call Run(what$)
Exit Sub
End If
Do
 pos = 1
  drop$ = aheadstatus(code$, True, pos)
  If drop$ = "" And pos > Len(code$) Then Exit Sub
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
  If drop$ = "" And pos > Len(code$) Then Exit Function
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
If lockedidonce Then Exit Sub
Call Run(code$, False)
End Sub
Public Function Run(ByVal code$, Optional clean As Boolean = True) As Boolean
Dim ohere$, stay As Variant
If elevatestatus2 Then Exit Function
elevatestatus2 = 1
If clean Then PushStage objref, 0
ohere$ = HERE$
HERE$ = mineHere$
NoAction = True
NOEXECUTION = False
objref.toprinter = False
MOUT = False
ResetBreak
Run = True
        LastErNum = 0: LastErNum1 = 0
        LastErName = ""
        LastErNameGR = ""

If Execute(objref, code$, False) <> 1 Then
Run = fasle

If Not App.StartMode = vbSModeStandalone Then
                 MOUT = True
                 ProcTitle objref, Chr$(34) + Chr$(34) + ",0", 0
End If
             
                End If
                Dim x As Form
                    For Each x In Forms
             
                    If Typename$(x) = "GuiM2000" Then Unload x
                    Next
                    Set x = Nothing
If NERR Then

RaiseEvent ErrorAtt(stay)
If Not stay Then GoTo finalize
End If
    objref.toprinter = False
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
finalize:
HERE$ = ohere$

If clean Then PopStage objref
elevatestatus2 = 0
End Function
Property Get ErrorGr() As String
ErrorGr = LastErNameGR
End Property
Property Get ErrorEn() As String
ErrorEn = LastErName
End Property
Property Get Status() As Long
If elevatestatus2 Then
Status = -elevatestatus2
Else
Status = LastErNum
End If
End Property
Public Sub Reset()

    NERR = False
        LastErNum = 0: LastErNum1 = 0
        LastErName = ""
        LastErNameGR = ""
 

        
End Sub

Private Sub Class_Initialize()
        Set objref = New basetask
        Set objref.Owner = Form1.DIS
        mineHere$ = "" 'HERE$
End Sub

Private Sub Class_Terminate()
Set objref.Owner = Nothing
Set objref.Sorosref = Nothing
Set objref = Nothing

End Sub
