Attribute VB_Name = "Module2"
Option Explicit
Public k1 As Long, Kform As Boolean
Public stackshowonly As Boolean
Public Enum Ftypes
    FnoUse
    Finput
    Foutput
    Fappend
    Frandom
End Enum
Public FLEN(512) As Long, FKIND(512) As Ftypes
Public uni(512) As Boolean
Public Type Counters
    k1 As Long
    RRCOUNTER As Long
End Type
Public Type basket
    used As Long
    x As Long  ' for hotspot
    y As Long  '
    XGRAPH As Long  ' graphic cursor
    YGRAPH As Long
    MAXXGRAPH As Long
    MAXYGRAPH As Long
    dv15 As Long  ' not used
    curpos As Long   ' text cursor
    currow As Long
    mypen As Long
    mysplit As Long
    Paper As Long
    italics As Boolean  ' removed from process, only in "current
    bold As Boolean
    double As Boolean
    osplit As Long  '(for double size letters)
    Column As Long
    OCOLUMN As Long
    pageframe As Long
    basicpageframe As Long
    MineLineSpace As Long
    uMineLineSpace As Long
    LastReportLines As Double
    SZ As Single
    UseDouble As Single
    Xt As Long
    Yt As Long
    mx As Long
    My As Long
    FontName As String
    charset As Long
    FTEXT As Long
    FTXT As String
    lastprint As Boolean  ' if true then we have to place letters using currentX
    ' gdi drawing enabled Smooth On, disabled with Smooth Of
    NoGDI As Boolean
    pathgdi As Long  ' only for gdi+
    pathcolor As Long ' only for gdi+
    pathfillstyle As Integer

End Type
Private stopwatch As Long
Private Const LOCALE_SYSTEM_DEFAULT As Long = &H800
Private Const LOCALE_USER_DEFAULT As Long = &H800
Private Const C3_DIACRITIC As Long = &H2
Private Const CT_CTYPE3 As Byte = &H4
Private Declare Function GetStringTypeExW Lib "kernel32.dll" (ByVal Locale As Long, ByVal dwInfoType As Long, ByVal lpSrcStr As Long, ByVal cchSrc As Long, ByRef lpCharType As Byte) As Long
Private Declare Function SetTextCharacterExtra Lib "gdi32" (ByVal hDC As Long, ByVal nCharExtra As Long) As Long
Private Declare Function WideCharToMultiByte Lib "KERNEL32" (ByVal codepage As Long, ByVal dwFlags As Long, ByVal lpWideCharStr As Long, ByVal cchWideChar As Long, ByVal lpMultiByteStr As Long, ByVal cchMultiByte As Long, ByVal lpDefaultChar As Long, ByVal lpUsedDefaultChar As Long) As Long
Private Declare Function GdiFlush Lib "gdi32" () As Long
Public iamactive As Boolean
Declare Function MultiByteToWideChar& Lib "KERNEL32" (ByVal codepage&, ByVal dwFlags&, MultiBytes As Any, ByVal cBytes&, ByVal pWideChars&, ByVal cWideChars&)
Private Declare Function FillRect Lib "user32" (ByVal hDC As Long, lpRect As RECT, ByVal hBrush As Long) As Long
Private Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long

Public Type RECT
        Left As Long
        Top As Long
        Right As Long
        Bottom As Long
End Type
Private Declare Function timeGetTime Lib "winmm.dll" () As Long
Private Const DT_BOTTOM As Long = &H8&
Private Const DT_CALCRECT As Long = &H400&
Private Const DT_CENTER As Long = &H1&
Private Const DT_EDITCONTROL As Long = &H2000&
Private Const DT_END_ELLIPSIS As Long = &H8000&
Private Const DT_EXPANDTABS As Long = &H40&
Private Const DT_EXTERNALLEADING As Long = &H200&
Private Const DT_HIDEPREFIX As Long = &H100000
Private Const DT_INTERNAL As Long = &H1000&
Private Const DT_LEFT As Long = &H0&
Private Const DT_MODIFYSTRING As Long = &H10000
Private Const DT_NOCLIP As Long = &H100&
Private Const DT_NOFULLWIDTHCHARBREAK As Long = &H80000
Private Const DT_NOPREFIX As Long = &H800&
Private Const DT_PATH_ELLIPSIS As Long = &H4000&
Private Const DT_PREFIXONLY As Long = &H200000
Private Const DT_RIGHT As Long = &H2&
Private Const DT_SINGLELINE As Long = &H20&
Private Const DT_TABSTOP As Long = &H80&
Private Const DT_TOP As Long = &H0&
Private Const DT_VCENTER As Long = &H4&
Private Const DT_WORDBREAK As Long = &H10&
Private Const DT_WORD_ELLIPSIS As Long = &H40000
Public Declare Function DestroyCaret Lib "user32" () As Long
Public Declare Function CreateCaret Lib "user32" (ByVal hwnd As Long, ByVal hBitmap As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Public Declare Function ShowCaret Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function GetFocus Lib "user32" () As Long
Public Declare Function SetCaretPos Lib "user32" (ByVal x As Long, ByVal y As Long) As Long
Public Declare Function HideCaret Lib "user32" (ByVal hwnd As Long) As Long
Const dv = 0.877551020408163
Public QUERYLIST As String
Public LASTQUERYLIST As Long
Private Declare Function GetSysColor Lib "user32" (ByVal nIndex As Long) As Long
Public releasemouse As Boolean
Public LASTPROG$
Public NORUN1 As Boolean
Public UseEnter As Boolean
Public dv20 As Single  ' = 24.5
Public dv15 As Long
Public mHelp As Boolean
Public abt As Boolean
Public vH_title$
Public vH_doc$
Public vH_x As Long
Public vH_y As Long
Public ttl As Boolean
Public Const SRCCOPY = &HCC0020
Public Release As Boolean
Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Declare Function RoundRect Lib "gdi32" (ByVal hDC As Long, ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long, ByVal X3 As Long, ByVal y3 As Long) As Long
Declare Function UpdateWindow Lib "user32" (ByVal hwnd As Long) As Long
Declare Function ScrollDC Lib "user32" (ByVal hDC As Long, ByVal dX As Long, ByVal dY As Long, lprcScroll As RECT, lprcClip As RECT, ByVal hrgnUpdate As Long, lprcUpdate As RECT) As Long
Public LastErName As String
Public LastErNameGR As String
Public LastErNum As Long
Public LastErNum1 As Long


Type POINTAPI
        x As Long
        y As Long
End Type
Declare Function GetDC Lib "user32" (ByVal hwnd As Long) As Long
Declare Function PaintDesktop Lib "user32" (ByVal hDC As Long) As Long
Declare Function SelectClipPath Lib "gdi32" (ByVal hDC As Long, ByVal iMode As Long) As Long
  Public Const RGN_AND = 1
    Public Const RGN_COPY = 5
    Public Const RGN_DIFF = 4
    Public Const RGN_MAX = RGN_COPY
    Public Const RGN_MIN = RGN_AND
    Public Const RGN_OR = 2
    Public Const RGN_XOR = 3
Declare Function StrokePath Lib "gdi32" (ByVal hDC As Long) As Long
Declare Function Polygon Lib "gdi32" (ByVal hDC As Long, lpPoint As POINTAPI, ByVal nCount As Long) As Long
Declare Function PolyBezier Lib "gdi32.dll" (ByVal hDC As Long, lppt As POINTAPI, ByVal cPoints As Long) As Long
Declare Function PolyBezierTo Lib "gdi32.dll" (ByVal hDC As Long, lppt As POINTAPI, ByVal cCount As Long) As Long
Declare Function BeginPath Lib "gdi32" (ByVal hDC As Long) As Long
Declare Function EndPath Lib "gdi32" (ByVal hDC As Long) As Long
Declare Function FillPath Lib "gdi32" (ByVal hDC As Long) As Long
Declare Function StrokeAndFillPath Lib "gdi32" (ByVal hDC As Long) As Long

Public PLG() As POINTAPI
Public lckfrm As Long
Public NERR As Boolean
Public moux As Single, mouy As Single, MOUB As Long
Public mouxb As Single, mouyb As Single, MOUBb As Long
Public vol As Long
Public MYFONT As String, myCharSet As Integer, myBold As Boolean
Public FFONT As String

Public escok As Boolean
Public NOEDIT As Boolean
Public CancelEDIT As Boolean

Global Const HWND_TOP = 0

Global Const HWND_TOPMOST = -1
Global Const HWND_NOTOPMOST = -2
Global Const SWP_NOACTIVATE = &H10
Global Const SWP_SHOWWINDOW = &H40
Declare Sub SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cX As Long, ByVal cY As Long, ByVal wFlags As Long)
Declare Function ExtFloodFill Lib "gdi32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long, ByVal wFillType As Long) As Long
Public Const FLOODFILLSURFACE = 1
Public Const FLOODFILLBORDER = 0

Public avifile As String
Public BigPi As Variant
Public Const Pi = 3.14159265358979
Public Const PI2 = 6.28318530717958
Public result As Long
Public mcd As String
Public NOEXECUTION As Boolean
Public QRY As Boolean, GFQRY As Boolean
Public nomore As Boolean


'== MCI Wave API Declarations ================================================
Public ExTarget As Boolean
''Public pageframe As Long
''Public basicpageframe As Long

Public q() As target
Public Targets As Boolean
Public SzOne As Single
Public PenOne As Long
Public NoAction As Boolean
Public StartLine As Boolean
Public www&
Public WWX&, ins&
Public INK$, MINK$
Public MKEY$
Public Type target
    Comm As String
    Tag As String ' specified by id
    Id As Long ' function id
    ' THIS IS POINTS AT CHARACTER RESOLUTION
    SZ As Single
    ' SO WE NEED SZ
    Lx As Long
    ly As Long
    tx As Long
    ty As Long
    back As Long 'background fill color' -1 no fill
    fore As Long 'border line ' -1 no line
    Enable As Boolean ' in use
    Pen As Long
    layer As Long
    Xt As Long
    Yt As Long
    sUAddTwipsTop As Long
End Type

Public here$, PaperOne As Long
Const PROOF_QUALITY = 2
Const NONANTIALIASED_QUALITY = 3
Private Type LOGFONT
  lfHeight As Long
  lfWidth As Long
  lfEscapement As Long
  lfOrientation As Long
  lfWeight As Long
  lfItalic As Byte
  lfUnderline As Byte
  lfStrikeOut As Byte
  lfCharSet As Byte
  lfOutPrecision As Byte
  lfClipPrecision As Byte
  lfQuality As Byte
  lfPitchAndFamily As Byte
' lfFaceName(LF_FACESIZE) As Byte 'THIS WAS DEFINED IN API-CHANGES MY OWN
  lfFaceName As String * 33
End Type
Private Declare Function CreateRoundRectRgn Lib "gdi32" (ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long, ByVal X3 As Long, ByVal y3 As Long) As Long

Private Declare Function PathToRegion Lib "gdi32" (ByVal hDC As Long) As Long
Private Declare Function SetWindowRgn Lib "user32" (ByVal hwnd As Long, ByVal hRgn As Long, ByVal bRedraw As Boolean) As Long
Private Declare Function CreateFontIndirect Lib "gdi32" Alias "CreateFontIndirectA" (lpLogFont As LOGFONT) As Long
Private Declare Function SelectObject Lib "gdi32" (ByVal hDC As Long, ByVal hObject As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
' OCTOBER 2000
Public dstyle As Long
' Jule 2001
Const DC_ACTIVE = &H1
Const DC_ICON = &H4
Const DC_TEXT = &H8
Const BDR_SUNKENOUTER = &H2
Const BDR_RAISEDINNER = &H4
Const EDGE_ETCHED = (BDR_SUNKENOUTER Or BDR_RAISEDINNER)
Const BF_BOTTOM = &H8
Const BF_LEFT = &H1
Const BF_RIGHT = &H4
Const BF_TOP = &H2
Const BF_RECT = (BF_LEFT Or BF_TOP Or BF_RIGHT Or BF_BOTTOM)
Const DFC_BUTTON = 4
Const DFC_POPUPMENU = 5            'Only Win98/2000 !!
Const DFCS_BUTTON3STATE = &H10
Const DC_GRADIENT = &H20          'Only Win98/2000 !!

Private Declare Function DrawCaption Lib "user32" (ByVal hwnd As Long, ByVal hDC As Long, pcRect As RECT, ByVal un As Long) As Long
Private Declare Function DrawEdge Lib "user32" (ByVal hDC As Long, qrc As RECT, ByVal edge As Long, ByVal grfFlags As Long) As Long
Private Declare Function DrawFocusRect Lib "user32" (ByVal hDC As Long, lpRect As RECT) As Long
Private Declare Function DrawFrameControl Lib "user32" (ByVal hDC As Long, lpRect As RECT, ByVal un1 As Long, ByVal un2 As Long) As Long
Private Declare Function DrawText Lib "user32" Alias "DrawTextW" (ByVal hDC As Long, ByVal lpStr As Long, ByVal nCount As Long, lpRect As RECT, ByVal wFormat As Long) As Long
Private Declare Function SetRect Lib "user32" (lpRect As RECT, ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long) As Long
Private Declare Function OffsetRect Lib "user32" (lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
''API declarations
' old api..
'Private Declare Function AddFontResource Lib "gdi32" Alias "AddFontResourceA" (ByVal lpFileName As String) As Long
'Private Declare Function RemoveFontResource Lib "gdi32" Alias "RemoveFontResourceA" (ByVal lpFileName As String) As Long
Public Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long
Private Declare Function GetAsyncKeyState Lib "user32" _
    (ByVal vKey As Long) As Long
Public TextEditLineHeight As Long
Public LablelEditLineHeight As Long
Private Const Utf8CodePage As Long = 65001
Public Function Utf16toUtf8(s As String) As Byte()
    ' code from vbforum
    ' UTF-8 returned to VB6 as a byte array (zero based) because it's pretty useless to VB6 as anything else.
    Dim iLen As Long
    Dim bbBuf() As Byte
    '
    iLen = WideCharToMultiByte(Utf8CodePage, 0, StrPtr(s), Len(s), 0, 0, 0, 0)
    ReDim bbBuf(0 To iLen - 1) ' Will be initialized as all &h00.
    iLen = WideCharToMultiByte(Utf8CodePage, 0, StrPtr(s), Len(s), VarPtr(bbBuf(0)), iLen, 0, 0)
    Utf16toUtf8 = bbBuf
End Function
Public Function KeyPressedLong(ByVal VirtKeyCode As Long) As Long
On Error GoTo KEXIT
If Not Screen.ActiveForm Is Nothing Then
If GetForegroundWindow = Screen.ActiveForm.hwnd Then
KeyPressedLong = GetAsyncKeyState(VirtKeyCode)
End If
End If
KEXIT:
End Function
Public Function KeyPressed(ByVal VirtKeyCode As Long) As Boolean
On Error GoTo KEXIT
If Not Screen.ActiveForm Is Nothing Then
If GetForegroundWindow = Screen.ActiveForm.hwnd Then
KeyPressed = CBool((GetAsyncKeyState(VirtKeyCode) And &H8000&) = &H8000&)
End If
End If
KEXIT:
End Function
Public Function mouse() As Long
On Error GoTo MEXIT
If Not Screen.ActiveForm Is Nothing Then
If GetForegroundWindow = Screen.ActiveForm.hwnd Then
If Screen.ActiveForm Is Form1 Then If Form1.lockme Then Exit Function

mouse = -1 * CBool((GetAsyncKeyState(1) And &H8000&) = &H8000&) - 2 * CBool((GetAsyncKeyState(2) And &H8000&) = &H8000&) - 4 * CBool((GetAsyncKeyState(4) And &H8000&) = &H8000&)

'mouse = (UINT(GetAsyncKeyState((1))) And &HFF) + (UINT(GetAsyncKeyState((2))) And &HFF) * 2 + (UINT(GetAsyncKeyState((4))) And &HFF) * 4
End If
End If
MEXIT:
End Function

Public Function MOUSEX(Optional offset As Long = 0) As Long
Static x As Long
On Error GoTo MOUSEX
Dim tp As POINTAPI
MOUSEX = x
If Not Screen.ActiveForm Is Nothing Then
If GetForegroundWindow = Screen.ActiveForm.hwnd Then
   GetCursorPos tp
   x = tp.x * dv15 - offset
  MOUSEX = x
  End If
End If
MOUSEX:
End Function
Public Function MOUSEY(Optional offset As Long = 0) As Long
Static y As Long
On Error GoTo MOUSEY
Dim tp As POINTAPI
MOUSEY = y
If Not Screen.ActiveForm Is Nothing Then
If GetForegroundWindow = Screen.ActiveForm.hwnd Then
   GetCursorPos tp
   y = tp.y * dv15 - offset
   MOUSEY = y
  End If
End If
MOUSEY:
End Function
Public Sub OnlyInAGroup()
    MyEr "Only in a group", "���� �� ��� �����"
End Sub
Public Sub WrongOperator()
MyEr "Wrong operator", "����� ��������"
End Sub
Public Sub NoOperatorForThatObject(ss$)
If ss$ = "g" Then ss$ = "<="
    MyEr "Object not support operator " + ss$, "�� ����������� ��� ����������� �� ������� " + ss$
End Sub
Public Sub NoStackObjectToMerge()
    MyEr "Not stack object to merge", "��� ����� ����������� ����� �� �����"
End Sub
Public Sub Unsignlongnegative(a$)
    MyErMacro a$, "Unsign long can't be negative", "� �������� �������� ��� ������ �� ����� ���������"
End Sub
Public Sub Unsignlongfailed(a$)
MyErMacro a$, "Unsign long to sign failed", "� ��������� �������� �� ������� �� �������, �������"
End Sub
Public Sub NoProperObject()
MyEr "This object not supported", "���� �� ����������� ��� �������������"
End Sub

Public Sub MyEr(er$, ergr$)
If Left$(LastErName, 1) = Chr(0) Then
    LastErName = vbNullString
    LastErNameGR = vbNullString
End If
If er$ = vbNullString Then
LastErNum = 0
LastErNum1 = 0
LastErName = vbNullString
LastErNameGR = vbNullString
Else
 er$ = Split(er$, ChrW(&H1FFF))(0)
ergr$ = Split(ergr$, ChrW(&H1FFF))(0)
If rinstr(er$, " ") = 0 Then
LastErNum = 1001
Else
''If LastErNum1 <= 0 Then LastErNum = Val(" " & Mid$(er$, rinstr(er$, " ")) + ".0") Else Exit Sub
LastErNum = val(" " & Mid$(er$, rinstr(er$, " ")) + ".0")
End If
If LastErNum = 0 Then LastErNum = -1 ': Debug.Print er$, ergr$: Stop
LastErNum1 = LastErNum
''If iRVAL(HERE$, 0) < 1 Then
If InStr("*" + LastErName, NLtrim$(er$)) = 0 Then
LastErName = RTrim(LastErName) & " " & NLtrim$(er$)
LastErNameGR = RTrim(LastErNameGR) & " " & NLtrim$(ergr$)
End If
''End If
End If
End Sub
Sub UnknownVariable1(a$, v$)
MyErMacro a$, "Unknown Variable " & v$, "������� ��������� " & v$
End Sub
Sub UnknownProperty1(a$, v$)
MyErMacro a$, "Unknown Property " & v$, "������� �������� " & v$
End Sub
Sub UnknownMethod1(a$, v$)
 MyErMacro a$, "unknown method/array  " & v$, "������� �������/������� " & v$
End Sub
Sub UnknownFunction1(a$, v$)
 MyErMacro a$, "unknown function/array " & v$, "������� ���������/������� " & v$
End Sub

Sub InternalError()
 MyEr "Internal Error", "��������� ��������"
End Sub
Public Function LoadFont(FntFileName As String) As Boolean
    Dim FntRC As Long
      '  FntRC = AddFontResource(FntFileName)
        If FntRC = 0 Then 'no success
         LoadFont = False
        Else 'success
         LoadFont = True
        End If
End Function
'FntFileName includes also path
Public Function RemoveFont(FntFileName As String) As Boolean
     Dim rc As Long

     Do
     '  rc = RemoveFontResource(FntFileName)
     Loop Until rc = 0

End Function


Sub myform(m As Object, x As Long, y As Long, x1 As Long, y1 As Long, Optional t As Boolean = False, Optional factor As Single = 1)
Dim hRgn As Long
m.Move x, y, x1, y1
If Int(25 * factor) > 2 Then
m.ScaleMode = vbPixels

hRgn = CreateRoundRectRgn(0, 0, m.ScaleX(x1, 1, 3), m.ScaleY(y1, 1, 3), 25 * factor, 25 * factor)
SetWindowRgn m.hwnd, hRgn, t
DeleteObject hRgn
m.ScaleMode = vbTwips

m.Line (0, 0)-(m.ScaleWidth - dv15, m.ScaleHeight - dv15), m.backcolor, BF
End If
End Sub

Sub MyRect(m As Object, mb As basket, x1 As Long, y1 As Long, way As Long, par As Variant, Optional zoom As Long = 0)
Dim r As RECT, b$
With mb
Dim x0&, y0&, x As Long, y As Long
GetXYb m, mb, x0&, y0&
x = m.ScaleX(x0& * .Xt - DXP, 1, 3)
y = m.ScaleY(y0& * .Yt - DYP, 1, 3)
If x1 >= .mx Then x1 = m.ScaleX(m.ScaleWidth, 1, 3) Else x1 = m.ScaleX(x1 * .Xt, 1, 3)
If y1 >= .My Then y1 = m.ScaleY(m.ScaleHeight, 1, 3) Else y1 = m.ScaleY(y1 * .Yt + .Yt, 1, 3)

SetRect r, x + zoom, y + zoom, x1 - zoom, y1 - zoom
Select Case way
Case 0
DrawEdge m.hDC, r, CLng(par) Mod 256, CLng(par) \ 256
Case 1
DrawCaption m.hwnd, m.hDC, r, CLng(par)
Case 2
DrawEdge m.hDC, r, CLng(par), BF_RECT
Case 3
DrawFocusRect m.hDC, r
Case 4
DrawFrameControl m.hDC, r, DFC_BUTTON, DFCS_BUTTON3STATE
Case 5
b$ = Replace(CStr(par), ChrW(&HFFFFF8FB), ChrW(&H2007))
DrawText m.hDC, StrPtr(b$), Len(CStr(par)), r, DT_CENTER
Case 6
DrawFrameControl m.hDC, r, CLng(par) Mod 256, CLng(par) \ 256
Case Else
k1 = 0
MyDoEvents1 Form1
End Select
LCTbasket m, mb, y0&, x0&
End With
End Sub
Sub MyFill(m As Object, x1 As Long, y1 As Long, way As Long, par As Variant, Optional zoom As Long = 0)
Dim r As RECT, b$
Dim x As Long, y As Long
With players(GetCode(m))
x1 = .XGRAPH + x1
y1 = .YGRAPH + y1
x1 = m.ScaleX(x1, 1, 3)
y1 = m.ScaleY(y1, 1, 3)
x = m.ScaleX(.XGRAPH, 1, 3)
y = m.ScaleY(.YGRAPH, 1, 3)
SetRect r, x + zoom, y + zoom, x1 - zoom, y1 - zoom
Select Case way
Case 0
DrawEdge m.hDC, r, CLng(par) Mod 256, CLng(par) \ 256
Case 1
DrawCaption m.hwnd, m.hDC, r, CLng(par)
Case 2
DrawEdge m.hDC, r, CLng(par), BF_RECT
Case 3
DrawFocusRect m.hDC, r
Case 4
DrawFrameControl m.hDC, r, DFC_BUTTON, DFCS_BUTTON3STATE
Case 5
b$ = Replace(CStr(par), ChrW(&HFFFFF8FB), ChrW(&H2007))
DrawText m.hDC, StrPtr(b$), Len(CStr(par)), r, DT_CENTER
Case 6
DrawFrameControl m.hDC, r, CLng(par) Mod 256, CLng(par) \ 256
Case Else
k1 = 0
MyDoEvents1 Form1
End Select
End With
End Sub
' ***************


Public Sub TextColor(d As Object, tc As Long)
d.ForeColor = tc
End Sub
Public Sub TextColorB(d As Object, mb As basket, tc As Long)
d.ForeColor = tc
mb.mypen = d.ForeColor
End Sub

Public Sub LCTNo(DqQQ As Object, ByVal y As Long, ByVal x As Long)

''DqQQ.CurrentX = x * Xt
''DqQQ.CurrentY = y * Yt + UAddTwipsTop
''xPos = x
''yPos = y
End Sub

Public Sub LCTbasketCur(DqQQ As Object, mybasket As basket)
With mybasket
DqQQ.CurrentX = .curpos * .Xt
DqQQ.CurrentY = .currow * .Yt + .uMineLineSpace

End With
End Sub
Public Sub LCTbasket(DqQQ As Object, mybasket As basket, ByVal y As Long, ByVal x As Long)
DqQQ.CurrentX = x * mybasket.Xt
DqQQ.CurrentY = y * mybasket.Yt + mybasket.uMineLineSpace
mybasket.curpos = x
mybasket.currow = y
End Sub
Public Sub nomoveLCTC(dqq As Object, mb As basket, y As Long, x As Long, t&)
Dim oldx&, oldy&
With mb
oldx& = dqq.CurrentX
oldy& = dqq.CurrentY
dqq.DrawMode = vbXorPen
If t& = 1 Then
dqq.Line (x * .Xt, Int(y * .Yt + .uMineLineSpace))-(x * .Xt + .Xt - DXP, y * .Yt - .uMineLineSpace + .Yt - DYP), (mycolor(.mypen) Xor dqq.backcolor), BF
Else
dqq.Line (x * .Xt, Int((y + 1) * .Yt - .uMineLineSpace - .Yt \ 6 - DYP))-(x * .Xt + .Xt - DXP, (y + 1) * .Yt - .uMineLineSpace - DYP), (mycolor(.mypen) Xor dqq.backcolor), BF
End If
dqq.DrawMode = vbCopyPen
dqq.CurrentX = oldx&
dqq.CurrentY = oldy&
End With
End Sub

Public Sub oldLCTCB(dqq As Object, mb As basket, t&)

dqq.DrawMode = vbXorPen
With mb
'QRY = Not QRY
If IsWine Then
If t& = 1 Then
dqq.Line (.curpos * .Xt, .currow * .Yt + .uMineLineSpace)-(.curpos * .Xt + .Xt, .currow * .Yt - .uMineLineSpace + .Yt), (mycolor(.mypen) Xor dqq.backcolor), BF
Else
dqq.Line (.curpos * .Xt, (dqq.ScaleY((.currow + 1) * .Yt - .uMineLineSpace, 1, 3) - .Yt \ DYP \ 6 - 1) * DYP)-(.curpos * .Xt + .Xt - DXP, (.currow + 1) * .Yt - .uMineLineSpace - DYP), (mycolor(.mypen) Xor dqq.backcolor), BF

End If
Else
If t& = 1 Then
dqq.Line (.curpos * .Xt, .currow * .Yt + .uMineLineSpace)-(.curpos * .Xt + .Xt, .currow * .Yt - .uMineLineSpace + .Yt), &HFFFFFF, BF
Else
dqq.Line (.curpos * .Xt, (dqq.ScaleY((.currow + 1) * .Yt - .uMineLineSpace, 1, 3) - .Yt \ DYP \ 6 - 1) * DYP)-(.curpos * .Xt + .Xt - DXP, (.currow + 1) * .Yt - .uMineLineSpace - DYP), &HFFFFFF, BF
End If
End If
End With
dqq.DrawMode = vbCopyPen
End Sub
Public Sub LCTCnew(dqq As Object, mb As basket, y As Long, x As Long)
DestroyCaret
With mb
CreateCaret dqq.hwnd, 0, dqq.ScaleX(.Xt, 1, 3), dqq.ScaleY((.Yt - .uMineLineSpace * 2) * 0.2, 1, 3)
SetCaretPos dqq.ScaleX(x * .Xt, 1, 3), dqq.ScaleY((y + 0.8) * .Yt, 1, 3)
End With
End Sub
Public Sub LCTCB(dqq As Object, mb As basket, t&)
With mb
If t& = -1 Or Not Form1.ActiveControl Is dqq Then
        If Not t& = -1 Then
        
        Else
        If Form1.ActiveControl Is Nothing Then
        Else
            CreateCaret Form1.ActiveControl.hwnd, 0, -1, 0
            End If
            CreateCaret dqq.hwnd, 0, -1, 0
        End If
        Exit Sub
End If

If t& = 1 Then
       ' CreateCaret dqq.hWnd, 0, dqq.ScaleX(.Xt, 1, 3), dqq.ScaleY((.Yt - .uMineLineSpace * 2), 1, 3)
       CreateCaret dqq.hwnd, 0, dqq.ScaleX(.Xt, 1, 3), dqq.ScaleY(.Yt - .uMineLineSpace * 2, 1, 3)
        SetCaretPos dqq.ScaleX(.curpos * .Xt, 1, 3), dqq.ScaleY(.currow * .Yt + .uMineLineSpace, 1, 3)
        On Error Resume Next
        If Not extreme Then If INK$ = vbNullString Then dqq.Refresh
Else
    CreateCaret dqq.hwnd, 0, dqq.ScaleX(.Xt, 1, 3), .Yt \ DYP \ 6 + 1
        
            SetCaretPos dqq.ScaleX(.curpos * .Xt, 1, 3), dqq.ScaleY((.currow + 1) * .Yt - .uMineLineSpace, 1, 3) - .Yt \ DYP \ 6 - 1
        On Error Resume Next
        If Not extreme Then If INK$ = vbNullString Then dqq.Refresh
End If
dqq.DrawMode = vbCopyPen
dqq.CurrentX = .curpos * .Xt
dqq.CurrentY = .currow * .Yt + .uMineLineSpace
End With
End Sub
Public Sub SetDouble(dq As Object)

SetTextSZ dq, players(GetCode(dq)).SZ, 2


End Sub

Public Sub SetNormal(dq As Object)
SetTextSZ dq, players(GetCode(dq)).SZ, 1
End Sub


Sub BOXbasket(dqq As Object, mybasket As basket, b$, c As Long)
With mybasket
    dqq.Line (.x * .Xt - DXP, .y * .Yt - DYP)-((.x + Len(b$)) * .Xt, .y * .Yt + .Yt), mycolor(c), B
End With
End Sub

Sub BoxBigNew(dqq As Object, mb As basket, x1&, y1&, c As Long)

With mb
dqq.Line (.curpos * .Xt - DXP, .currow * .Yt - DYP)-(x1& * .Xt - DXP + .Xt, y1& * .Yt + .Yt - DYP), mycolor(c), B
End With

End Sub
Sub CircleBig(dqq As Object, mb As basket, x1&, y1&, c As Long, el As Boolean)
Dim x&, y&

With mb
x& = .curpos
y& = .currow
dqq.FillColor = mycolor(c)
dqq.fillstyle = vbFSSolid
If el Then
dqq.Circle (((x& + x1& + 1) / 2 * .Xt) - DXP, ((y& + y1& + 1) / 2 * .Yt) - DYP), RMAX((x1& - x& + 1) * .Xt, (y1& - y& + 1) * .Yt) / 2 - DYP, mycolor(c), , , ((y1& - y& + 1) * .Yt - DYP) / ((x1& - x& + 1) * .Xt - DXP)
Else
dqq.Circle (((x& + x1& + 1) / 2 * .Xt) - DXP, ((y& + y1& + 1) / 2 * .Yt) - DYP), (RMIN((x1& - x& + 1) * .Xt, (y1& - y& + 1) * .Yt) / 2 - DYP), mycolor(c)

End If
dqq.fillstyle = vbFSTransparent
End With
End Sub
Sub Ffill(dqq As Object, x1 As Long, y1 As Long, c As Long, v As Boolean)
Dim osm
With players(GetCode(dqq))
osm = dqq.ScaleMode
dqq.ScaleMode = vbPixels
dqq.FillColor = mycolor(c)
dqq.fillstyle = vbFSSolid
If v Then
ExtFloodFill dqq.hDC, dqq.ScaleX(x1, 1, 3), dqq.ScaleY(y1, 1, 3), dqq.Point(dqq.ScaleX(x1, 1, 3), dqq.ScaleY(y1, 1, 3)), FLOODFILLSURFACE
Else
ExtFloodFill dqq.hDC, dqq.ScaleX(x1, 1, 3), dqq.ScaleY(y1, 1, 3), mycolor(.mypen), FLOODFILLBORDER
End If
dqq.ScaleMode = osm
dqq.fillstyle = vbFSTransparent
End With
'LCT Dqq, y&, x&
End Sub

Sub BoxColorNew(dqq As Object, mb As basket, x1&, y1&, c As Long)
Dim addpixels As Long
With mb
If InternalLeadingSpace() = 0 And .MineLineSpace = 0 Then
addpixels = 0
Else
addpixels = 2
End If

dqq.Line (.curpos * .Xt, .currow * .Yt)-(x1& * .Xt + .Xt - 2 * DXP, y1& * .Yt + .Yt - addpixels * DYP), mycolor(c), BF
End With
End Sub
Sub BoxImage(d1 As Object, mb As basket, x1&, y1&, F As String, df&, s As Boolean)
'
Dim p As Picture, scl As Double, x2&, dib As Object, aPic As StdPicture

If df& > 0 Then
df& = df& * DXP '* 20

Else

df& = 0
End If
With mb
x1& = .curpos + x1& - 1
x2& = x1&
y1& = .currow + y1& - 1
On Error Resume Next
 If (Left$(F$, 4) = "cDIB" And Len(F$) > 12) Then
   Set dib = New cDIBSection
  If Not cDib(F$, dib) Then
    dib.Create x1&, y1&
    dib.Cls d1.backcolor
  End If
      Set p = dib.Picture
    Set dib = Nothing
 Else
        If ExtractType(F, 0) = vbNullString Then
        F = F + ".bmp"
        End If
        FixPath F
        
    If CFname(F) <> "" Then
    F = CFname(F)
    Set aPic = LoadMyPicture(GetDosPath(F$))
     If aPic Is Nothing Then Exit Sub
    Set p = aPic
                                            

    Else
    Set dib = New cDIBSection
    dib.Create x1&, y1&
    dib.Cls d1.backcolor
    Set p = dib.Picture
    Set dib = Nothing
    End If
End If

If Err.Number > 0 Then Exit Sub

If s Then
scl = (y1& - .currow + 1) * .Yt - df&
If p.Type = vbPicTypeBitmap Then
d1.PaintPicture p, .curpos * .Xt, .currow * .Yt, (x1& - .curpos + 1) * .Xt - df&, scl, , , , , vbSrcCopy
Else
d1.PaintPicture p, .curpos * .Xt, .currow * .Yt, (x1& - .curpos + 1) * .Xt - df&, scl
End If
Else
scl = p.Height * ((x1& - .curpos + 1) * .Xt - df&) / p.Width
If p.Type = vbPicTypeBitmap Then
d1.PaintPicture p, .curpos * .Xt, .currow * .Yt, (x1& - .curpos + 1) * .Xt - df&, scl, , , , , vbSrcCopy
Else
d1.PaintPicture p, .curpos * .Xt, .currow * .Yt, (x1& - .curpos + 1) * .Xt - df&, scl
End If
End If
y1& = -Int(-((scl) / .Yt))
Set p = Nothing
''LCT d1, .currow, .curpos
End With
End Sub

Sub sprite(bstack As basetask, ByVal F As String, rst As String)

On Error GoTo SPerror
Dim d1 As Object, amask$, aPic As StdPicture
Set d1 = bstack.Owner
Dim raster As New cDIBSection
Dim p As Double, i As Long, ROT As Double, sp As Double
Dim Pcw As Long, Pch As Long, blend As Double, NoUseBack As Boolean

If Not cDib(F, raster) Then
    If CFname(F) <> "" Then
        F = CFname(F)
        Set aPic = LoadMyPicture(GetDosPath(F$))
        If aPic Is Nothing Then Exit Sub
        raster.CreateFromPicture aPic
        If raster.bitsPerPixel <> 24 Then
            Conv24 raster
        Else
            CheckOrientation raster, F
        End If
    Else
        
        BACKSPRITE = vbNullString
        Exit Sub
    End If
End If
If raster.Width = 0 Then
    BACKSPRITE = vbNullString
    Set raster = Nothing
    Set d1 = Nothing
    Exit Sub
End If
i = -1
sp = 100!
blend = 100!
If FastSymbol(rst$, ",") Then
    If IsExp(bstack, rst$, p) Then i = CLng(p) Else i = -players(GetCode(d1)).Paper
    If FastSymbol(rst$, ",") Then
        If IsExp(bstack, rst$, p) Then ROT = p
        If FastSymbol(rst$, ",") Then
            If Not IsExp(bstack, rst$, sp) Then sp = 100!
            If FastSymbol(rst$, ",") Then
                If IsExp(bstack, rst$, blend) Then
                    blend = Abs(Int(blend)) Mod 101
                    If FastSymbol(rst$, ",") Then GoTo cont0
                ElseIf IsStrExp(bstack, rst$, amask$) Then
                    blend = 100!
                    If FastSymbol(rst$, ",") Then GoTo cont0
                ElseIf FastSymbol(rst$, ",") Then
                blend = 100!
cont0:
                    If Not IsExp(bstack, rst$, p) Then
                            MyEr "missing parameter", "������ ����������"
                            Exit Sub
                    End If
                    NoUseBack = CBool(p)
                Else
                    MyEr "missing parameter", "������ ����������"
                End If
                
                
            End If
            End If
        End If
Else
        Pcw = raster.Width \ 2
        Pch = raster.Height \ 2
        With players(GetCode(d1))
        raster.PaintPicture d1.hDC, Int(d1.ScaleX(.XGRAPH, 1, 3) - Pcw), Int(d1.ScaleX(.YGRAPH, 1, 3) - Pch)
        End With
    GoTo cont1
End If
If sp <= 0 Then sp = 0
If i > 0 Then i = QBColor(i) Else i = -i
RotateDib bstack, raster, ROT, sp, i, NoUseBack, (blend), amask$
Pcw = raster.Width \ 2
Pch = raster.Height \ 2
With players(GetCode(d1))
raster.PaintPicture d1.hDC, Int(d1.ScaleX(.XGRAPH, 1, 3) - Pcw), Int(d1.ScaleX(.YGRAPH, 1, 3) - Pch)
End With
cont1:
If Not bstack.toprinter Then
GdiFlush
End If
Set raster = Nothing
MyDoEvents1 d1
Set d1 = Nothing
Exit Sub
SPerror:
 BACKSPRITE = vbNullString
Set raster = Nothing
End Sub
Sub spriteGDI(bstack As basetask, rst As String)
Dim NoUseBack As Boolean
If bstack.lastobj Is Nothing Then
err1:
    MyEr "Expecting a memory Buffer", "�������� ��������� ������"
    Exit Sub
End If
If Not TypeOf bstack.lastobj Is mHandler Then GoTo err1
If Not bstack.lastobj.t1 = 2 Then GoTo err1
Dim d1 As Object
Set d1 = bstack.Owner
Dim p, i As Long, mem As MemBlock, blend, sp, ROT As Single
Set mem = bstack.lastobj.objref
i = -1
sp = 100!
blend = 0!
If FastSymbol(rst$, ",") Then
    If IsExp(bstack, rst$, p) Then i = CLng(p) Else i = -players(GetCode(d1)).Paper
    If FastSymbol(rst$, ",") Then
        If IsExp(bstack, rst$, p) Then ROT = p
        If FastSymbol(rst$, ",") Then
            If Not IsExp(bstack, rst$, sp) Then sp = 100!
            If FastSymbol(rst$, ",") Then
                If IsExp(bstack, rst$, blend) Then blend = 100 - Abs(Int(blend)) Mod 101
                If FastSymbol(rst$, ",") Then
                    If Not IsExp(bstack, rst$, p) Then
                        MyEr "missing parameter", "������ ����������"
                        Exit Sub
                    End If
                    NoUseBack = Not CBool(p)
                End If
            End If
        End If
    End If
End If
If sp <= 0 Then sp = 0
If i > 0 Then i = QBColor(i) Else i = -i

mem.DrawSpriteToHdc bstack, NoUseBack, ROT, (sp), (blend), i

MyDoEvents1 d1
Set d1 = Nothing
Set bstack.lastobj = Nothing
Exit Sub
SPerror:
Set bstack.lastobj = Nothing
 BACKSPRITE = vbNullString
End Sub

Sub ThumbImage(d1 As Object, x1 As Long, y1 As Long, F As String, border As Long, tpp As Long, ttl1$)
On Error Resume Next
With players(GetCode(d1))
If Left$(F, 4) = "cDIB" And Len(F) > 12 Then
Dim ph As New cDIBSection
If cDib(F, ph) Then
ph.ThumbnailPartPaint d1, x1 / tpp, y1 / tpp, 0, 0, border <> 0, , ttl1$, .XGRAPH / tpp, .YGRAPH / tpp
End If
End If
End With
End Sub
Sub ThumbImageDib(d1 As Object, x1 As Long, y1 As Long, ph As Object, border As Long, tpp As Long, ttl1$)
On Error Resume Next
Dim pointer2dib As cDIBSection
Set pointer2dib = ph
With players(GetCode(d1))
    pointer2dib.ThumbnailPartPaint d1, x1 / tpp, y1 / tpp, 0, 0, border <> 0, , ttl1$, .XGRAPH / tpp, .YGRAPH / tpp
End With
Set pointer2dib = Nothing
End Sub
Sub SImage(d1 As Object, x1 As Long, y1 As Long, F As String)
'
Dim p As Picture, aPic As StdPicture
On Error Resume Next
With players(GetCode(d1))
If Left$(F, 4) = "cDIB" And Len(F) > 12 Then
Dim ph As New cDIBSection
If cDib(F, ph) Then
If x1 = 0 Then
ph.PaintPicture d1.hDC, CLng(d1.ScaleX(.XGRAPH, 1, 3)), CLng(d1.ScaleX(.YGRAPH, 1, 3))
Exit Sub
Else
If y1 = 0 Then y1 = Abs(ph.Height * x1 / ph.Width)
ph.StretchPictureH d1.hDC, CLng(d1.ScaleX(.XGRAPH, 1, 3)), CLng(d1.ScaleX(.YGRAPH, 1, 3)), CLng(d1.ScaleX(x1, 1, 3)), CLng(d1.ScaleX(y1, 1, 3))
Exit Sub
End If
End If
ElseIf CFname(F) <> "" Then
    F = CFname(F)
     Set aPic = LoadMyPicture(GetDosPath(F$), , , True)
     If aPic Is Nothing Then Exit Sub
     Set p = aPic
Else
If y1 = 0 Then y1 = x1
d1.Line (.XGRAPH, .YGRAPH)-(x1, y1), .Paper, BF
d1.CurrentX = .XGRAPH
d1.CurrentY = .YGRAPH
Exit Sub
End If
If x1 = 0 Then
x1 = d1.ScaleX(p.Width, vbHimetric, vbTwips)

If y1 = 0 Then y1 = p.Height * d1.ScaleX(p.Width, vbHimetric, vbTwips) / p.Width
Else
If y1 = 0 Then y1 = p.Height * x1 / p.Width
End If
If Err.Number > 0 Then Exit Sub

If p.Type = vbPicTypeBitmap Then
d1.PaintPicture p, .XGRAPH, .YGRAPH, x1, y1, , , , , vbSrcCopy
Else
d1.PaintPicture p, .XGRAPH, .YGRAPH, x1, y1
End If
Set p = Nothing
End With
' UpdateWindow d1.hwnd
End Sub
Public Function LoadMyPicture(s1$, Optional useback As Boolean = False, Optional bcolor As Variant = 0&, Optional includeico As Boolean = False) As StdPicture
Dim s As String
Err.Clear
   On Error Resume Next
                    If s1$ <> vbNullString Then
                        s$ = UCase(ExtractType(s1$))
                        If s$ = "" Then s$ = "Bmp": s1$ = s1$ + ".bmp"
                        Select Case s
                        Case "JPG", "BMP", "WMF", "EMF", "ICO", "DIB"
                        
                           Set LoadMyPicture = LoadPicture(s1$)
                           If Err.Number > 0 Then
                           Err.Clear
                           If useback Then
                              Set LoadMyPicture = LoadPictureGDIPlus(s1$, , , bcolor, True)
                           Else
                              Set LoadMyPicture = LoadPictureGDIPlus(s1$, , , , True)
                            End If
                           End If
                        Case Else
                            If includeico And Not useback Then
                            Set LoadMyPicture = LoadPicture(s1$)
                                If Err.Number > 0 Then
                                    Err.Clear
                                    GoTo conthere
                                End If
                            Else
conthere:
                          If useback Then
                              Set LoadMyPicture = LoadPictureGDIPlus(s1$, , , bcolor, True)
                           Else
                              Set LoadMyPicture = LoadPictureGDIPlus(s1$, , , , True)
                            End If
                            End If
                        End Select
                    End If
                          
End Function

Public Function GetTextWidth(dd As Object, c As String, r As RECT) As Long
' using current.x and current.y to define r


End Function
Public Sub PrintLineControl(mHdc As Long, c As String, r As RECT)
    DrawText mHdc, StrPtr(c), -1, r, 0
End Sub
Public Sub CalcRect(mHdc As Long, c As String, r As RECT)
r.Top = 0
r.Left = 0
DrawText mHdc, StrPtr(c), -1, r, DT_CALCRECT Or DT_NOPREFIX Or DT_SINGLELINE Or DT_NOCLIP
End Sub

Public Sub PrintLineControlSingle(mHdc As Long, c As String, r As RECT)
    DrawText mHdc, StrPtr(c), -1, r, DT_SINGLELINE Or DT_NOPREFIX Or DT_NOCLIP
    End Sub
'
Public Sub MyPrintNew(ddd As Object, UAddTwipsTop, s$, Optional cr As Boolean = False, Optional fake As Boolean = False)

Dim nr As RECT, nl As Long, mytop As Long
mytop = ddd.CurrentY
If s$ = vbNullString Then
nr.Left = 0: nr.Right = 0: nr.Top = 0: nr.Bottom = 0
CalcRect ddd.hDC, " ", nr
nr.Left = ddd.CurrentX / dv15
nr.Right = nr.Right + nr.Left
nr.Top = ddd.CurrentY / dv15
nr.Bottom = nr.Top + nr.Bottom
nl = (nr.Bottom + 1) * dv15
If cr Then
ddd.CurrentY = (nr.Bottom + 1) * dv15 + UAddTwipsTop ''2
ddd.CurrentX = 0
Else
ddd.CurrentX = nr.Right * dv15
End If
Else
nr.Left = 0: nr.Right = 0: nr.Top = 0: nr.Bottom = 0
CalcRect ddd.hDC, s$, nr
nr.Left = ddd.CurrentX / dv15
nr.Right = nr.Right + nr.Left
nr.Top = ddd.CurrentY / dv15
nr.Bottom = nr.Top + nr.Bottom
nl = (nr.Bottom + 1) * dv15
If Not fake Then
If nr.Left * dv15 < ddd.Width Then PrintLineControlSingle ddd.hDC, s$, nr
End If
If cr Then
ddd.CurrentY = nl + UAddTwipsTop ''* 2
ddd.CurrentX = 0
Else
ddd.CurrentY = mytop
ddd.CurrentX = nr.Right * dv15
End If
End If

End Sub
Public Sub MyPrintOLD(ddd As Object, mb As basket, s$, Optional cr As Boolean = False, Optional fake As Boolean = False, Optional lastpart As Boolean = False)

Dim nr As RECT, nl As Long
With mb
If s$ = vbNullString Then

nr.Left = 0: nr.Right = 0: nr.Top = 0: nr.Bottom = 0
CalcRect ddd.hDC, " ", nr
nr.Left = ddd.CurrentX / dv15
nr.Right = nr.Right + nr.Left
nr.Top = ddd.CurrentY / dv15
nr.Bottom = nr.Top + nr.Bottom
nl = (nr.Bottom + 1) * dv15
If cr Then
ddd.CurrentY = (nr.Bottom + 1) * dv15 + .uMineLineSpace
ddd.CurrentX = 0
Else
ddd.CurrentX = nr.Right * dv15
End If
Else
nr.Left = 0: nr.Right = 0: nr.Top = 0: nr.Bottom = 0
CalcRect ddd.hDC, s$, nr
nr.Left = ddd.CurrentX / dv15
nr.Right = nr.Right + nr.Left
nr.Top = ddd.CurrentY / dv15
nr.Bottom = nr.Top + nr.Bottom
nl = (nr.Bottom + 1) * dv15
If Not fake Then
If nr.Left * dv15 < ddd.Width Then PrintLineControlSingle ddd.hDC, s$, nr
End If
If cr Then
ddd.CurrentY = nl + .uMineLineSpace
ddd.CurrentX = 0
Else
If lastpart Then
If Trim$(s$) = vbNullString Then
ddd.CurrentX = ((nr.Right * dv15 + .Xt \ 2) \ .Xt) * .Xt
Else
ddd.CurrentX = ((nr.Right * dv15 + .Xt \ 1.2) \ .Xt) * .Xt
End If
Else
ddd.CurrentX = nr.Right * dv15
End If
End If
End If

End With
End Sub

Public Sub MyPrint(ddd As Object, s$)
Dim nr As RECT, nl As Long
If s$ = vbNullString Then
    nr.Left = 0: nr.Right = 0: nr.Top = 0: nr.Bottom = 0
    CalcRect ddd.hDC, " ", nr
    nr.Left = ddd.CurrentX / dv15
    nr.Right = nr.Right + nr.Left
    nr.Top = ddd.CurrentY / dv15
    nr.Bottom = nr.Top + nr.Bottom
    nl = (nr.Bottom + 1) * dv15
    ddd.CurrentY = (nr.Bottom + 1) * dv15
    ddd.CurrentX = 0
Else
nr.Left = 0: nr.Right = 0: nr.Top = 0: nr.Bottom = 0
CalcRect ddd.hDC, s$, nr
nr.Left = ddd.CurrentX / dv15
nr.Right = nr.Right + nr.Left
nr.Top = ddd.CurrentY / dv15
nr.Bottom = nr.Top + nr.Bottom
nl = (nr.Bottom + 1) * dv15
If nr.Left * dv15 < ddd.Width Then PrintLineControlSingle ddd.hDC, s$, nr
ddd.CurrentY = nl
ddd.CurrentX = 0
End If
End Sub
Public Function TextWidth(ddd As Object, a$) As Long
Dim nr As RECT
CalcRect ddd.hDC, a$, nr
TextWidth = nr.Right * dv15
End Function
Private Function TextHeight(ddd As Object, a$) As Long
Dim nr As RECT
CalcRect ddd.hDC, a$, nr

TextHeight = nr.Bottom * dv15
End Function

Public Sub PrintLine(dd As Object, c As String, r As RECT)
DrawText dd.hDC, StrPtr(c), -1, r, DT_CENTER
End Sub
Public Sub PrintUnicodeStandardWidthAddXT(dd As Object, c As String, r As RECT)
''dd.CurrentX = dd.CurrentX + Xt

DrawText dd.hDC, StrPtr(c), -1, r, DT_SINGLELINE Or DT_CENTER Or DT_NOPREFIX
End Sub

Public Sub PlainOLD(ddd As Object, mb As basket, ByVal what As String, Optional ONELINE As Boolean = False, Optional nocr As Boolean = False, Optional plusone As Long = 2)
Dim PX As Long, PY As Long, r As Long, p$, c$, LEAVEME As Boolean, nr As RECT, nr2 As RECT
Dim p2 As Long
With mb
p2 = .uMineLineSpace \ dv15 * 2
LEAVEME = False
 PX = .curpos
 PY = .currow
Dim pixX As Long, pixY As Long
pixX = .Xt / dv15
pixY = .Yt / dv15
Dim rTop As Long, rBottom As Long
 With nr
 .Left = PX * pixX
 .Right = .Left + pixX
 .Top = PY * pixY + mb.uMineLineSpace \ dv15
 
 .Bottom = .Top + pixY - mb.uMineLineSpace \ dv15 * 2
 End With
rTop = PY * pixY
rBottom = rTop + pixY - plusone
Do While Len(what) >= .mx - PX And (.mx - PX) > 0
 p$ = Left$(what, .mx - PX)
 
  With nr2
 .Left = PX * pixX
 
 .Right = (PX + Len(p$)) * pixX + 1
 .Top = rTop
 .Bottom = rBottom
 
 End With
 
 If ddd.FontTransparent = False Then
 FillBack ddd.hDC, nr2, ddd.backcolor
 End If
 For r = 0 To Len(p$) - 1
If ONELINE And nocr And PX > .mx Then what = vbNullString: Exit For
 c$ = Mid$(p$, r + 1, 1)

If c$ >= " " Then ddd.CurrentX = ddd.CurrentX + .Xt: PrintUnicodeStandardWidthAddXT ddd, c$, nr
 With nr
 .Left = .Right
 .Right = .Left + pixX
 End With

  Next r
 LCTbasket ddd, mb, PY, PX + r
   
   
what = Mid$(what, .mx - PX + 1)

If Not ONELINE Then PX = 0

If nocr Then Exit Do Else PY = PY + 1

If PY >= .My And Not ONELINE Then

If ddd.name = "PrinterDocument1" Then
getnextpage
 With nr
 .Top = PY * pixY + mb.uMineLineSpace
  .Bottom = .Top + pixY - p2
 End With
PY = 1
Else
ScrollUpNew ddd, mb
End If

PY = PY - 1
End If
If ONELINE Then
LCTbasket ddd, mb, PY, PX
LEAVEME = True
Exit Do
Else
 With nr
 .Left = PX * pixX
 .Right = .Left + pixX
 .Top = PY * pixY + mb.uMineLineSpace
 .Bottom = .Top + pixY - p2
 End With
rTop = PY * pixY
rBottom = rTop + pixY - plusone
End If
Loop
If LEAVEME Then Exit Sub

 If ddd.FontTransparent = False Then
     With nr2
 .Left = PX * pixX
 .Right = (PX + Len(what$)) * pixX + 1
 .Top = rTop
 .Bottom = rBottom
 
 End With
 FillBack ddd.hDC, nr2, ddd.backcolor
 End If
 
If what$ <> "" Then
.currow = PY
.curpos = PX
LCTbasketCur ddd, mb
  For r = 0 To Len(what$) - 1
 c$ = Mid$(what$, r + 1, 1)
 If c$ >= " " Then ddd.CurrentX = ddd.CurrentX + .Xt: PrintUnicodeStandardWidthAddXT ddd, c$, nr
 With nr
 .Left = .Right
 .Right = .Left + pixX
 End With
 
  Next r
  LCTbasket ddd, mb, PY, PX + r
End If

GetXYb ddd, mb, .curpos, .currow
End With
End Sub


Public Sub PlainBaSket(ddd As Object, mybasket As basket, ByVal what As String, Optional ONELINE As Boolean = False, Optional nocr As Boolean = False, Optional plusone As Long = 2, Optional clearline As Boolean = False)
Dim PX As Long, PY As Long, r As Long, p$, c$, LEAVEME As Boolean, nr As RECT, nr2 As RECT
Dim p2 As Long, mUAddPixelsTop As Long
Dim pixX As Long, pixY As Long
Dim rTop As Long, rBottom As Long
Dim lenw&, realR&, realstop&, r1 As Long, WHAT1$

Dim a() As Byte, a1() As Byte
'' LEAVEME = False -  NOT NEEDED
With mybasket
    mUAddPixelsTop = mybasket.uMineLineSpace \ dv15  ' for now
    PX = .curpos
    PY = .currow
    p2 = mUAddPixelsTop * 2
    pixX = .Xt / dv15
    pixY = .Yt / dv15
    With nr
        .Left = PX * pixX
        .Right = .Left + pixX
        .Top = PY * pixY + mUAddPixelsTop
         .Bottom = .Top + pixY - mUAddPixelsTop * 2
    End With
    
    rTop = PY * pixY
    rBottom = rTop + pixY - plusone
    lenw& = Len(what)
    WHAT1$ = what + " "
     ReDim a(Len(WHAT1$) * 2 + 20)
       ReDim a1(Len(WHAT1$) * 2 + 20)
     
     Dim skip As Boolean
     
     skip = GetStringTypeExW(&HB, 1, StrPtr(WHAT1$), Len(WHAT1$), a(0)) = 0  ' Or IsWine
     skip = GetStringTypeExW(&HB, 4, StrPtr(WHAT1$), Len(WHAT1$), a1(0)) = 0 Or skip
        Do While (lenw& - r) >= .mx - PX And (.mx - PX) > 0
        

        With nr2
                .Left = PX * pixX
                 .Right = mybasket.mx * pixX + 1
                .Top = rTop
                .Bottom = rBottom
        End With
        If ddd.FontTransparent = False Then FillBack ddd.hDC, nr2, .Paper
        ddd.CurrentX = PX * .Xt
        ddd.CurrentY = PY * .Yt + .uMineLineSpace
     r1 = .mx - PX - 1 + r
        If ddd.CurrentX = 0 And clearline Then ddd.Line (0&, PY * .Yt)-((.mx - 1) * .Xt + .Xt * 2, (PY) * .Yt + .Yt - 1 * DYP), .Paper, BF
            Do
           '  If ddd.CurrentX = 0 And clearline Then ddd.Line (0&, PY * .Yt)-((.mx - 1) * .Xt + .Xt * 2, (PY) * .Yt + .Yt - 1 * DYP), .Paper, BF

            If ONELINE And nocr And PX > .mx Then what = vbNullString: Exit Do
            c$ = Mid$(WHAT1$, r + 1, 1)
      
            If c$ >= " " Then
            
               If Not skip Then
              If a(r * 2 + 2) = 0 And a(r * 2 + 3) <> 0 And a1(r * 2 + 2) < 8 Then
                          Do
                p$ = Mid$(WHAT1$, r + 2, 1)
                If AscW(p$) < 0 Then Mid$(WHAT1$, r + 2, 1) = " ": Exit Do
                c$ = c$ + p$
                             r = r + 1
                    If r >= r1 Then Exit Do
                    
                     Loop Until a(r * 2 + 2) <> 0 Or a(r * 2 + 3) = 0
                 End If
         
                 End If
                      DrawText ddd.hDC, StrPtr(c$), -1, nr, DT_SINGLELINE Or DT_CENTER Or DT_NOPREFIX
            End If
           r = r + 1
            With nr
            .Left = .Right
            .Right = .Left + pixX
            End With
           ddd.CurrentX = (PX + realR) * .Xt
        realR = realR + 1
     
        If r >= lenw& Then
         r = lenw& + 1
        lenw& = lenw& - 1
        Exit Do
        End If
        If realR > .mx + PX - 1 Then Exit Do
    
         Loop
        .curpos = PX + realR
 
        If Not ONELINE Then PX = 0
        
        If nocr Then Exit Sub Else PY = PY + 1
        
        If PY >= .My And Not ONELINE Then
        
        If ddd.name = "PrinterDocument1" Then
        getnextpage
         With nr
         .Top = PY * pixY + mUAddPixelsTop
          .Bottom = .Top + pixY - p2
         End With
        PY = 1
        Else
        
        ScrollUpNew ddd, mybasket
        End If
        
        PY = PY - 1
       
        End If
        If ONELINE Then

            LEAVEME = True
            Exit Do
        Else
            With nr
               .Left = PX * pixX
               .Right = .Left + pixX
               .Top = PY * pixY + mUAddPixelsTop
               .Bottom = .Top + pixY - p2
            End With
            rTop = PY * pixY
            rBottom = rTop + pixY - plusone
   

        End If
        realR& = 0
    Loop
    If LEAVEME Then
                With mybasket
                .curpos = PX
                .currow = PY
            End With
    Exit Sub
    End If
     If ddd.FontTransparent = False Then
        With nr2
            .Left = PX * pixX
            .Right = (PX + Len(what$)) * pixX + 1
            .Top = rTop
            .Bottom = rBottom
        End With
        FillBack ddd.hDC, nr2, mybasket.Paper
    End If
realR& = 0
    If Len(what$) > r Then

       ddd.CurrentX = PX * .Xt
    
    ddd.CurrentY = PY * .Yt + .uMineLineSpace
        If ddd.CurrentX = 0 And clearline Then ddd.Line (0&, PY * .Yt)-((.mx - 1) * .Xt + .Xt * 2, (PY) * .Yt + .Yt - 1 * DYP), .Paper, BF

r1 = Len(what$) - 1
    For r = r To r1
        c$ = Mid$(WHAT1$, r + 1, 1)
        If c$ >= " " Then
       ' skip = True
             If Not skip Then
           If a(r * 2 + 2) = 0 And a(r * 2 + 3) <> 0 And a1(r * 2 + 2) < 8 Then
            Do
                p$ = Mid$(WHAT1$, r + 2, 1)
                If AscW(p$) < 0 Then Mid$(WHAT1$, r + 2, 1) = " ": Exit Do
                c$ = c$ + p$
                r = r + 1
                If r >= r1 Then Exit Do
            Loop Until a(r * 2 + 2) <> 0 Or a(r * 2 + 3) = 0
            End If
         End If
               
      ddd.CurrentX = ddd.CurrentX + .Xt
        End If
        PrintUnicodeStandardWidthAddXT ddd, c$, nr
        realR& = realR + 1
         With nr
           .Left = .Right
           .Right = .Left + pixX
        End With
    Next r
     .curpos = PX + realR
     .currow = PY
     Exit Sub
    End If

  .curpos = PX
 .currow = PY
  End With
End Sub

Public Function nTextY(basestack As basetask, ByVal what As String, ByVal Font As String, ByVal Size As Single, Optional ByVal degree As Double = 0#)
Dim ddd As Object
Set ddd = basestack.Owner
Dim PX As Long, PY As Long, OLDFONT As String, OLDSIZE As String, DE#
Dim F As LOGFONT, hPrevFont As Long, hFont As Long
Dim BFONT As String
Dim prive As Long
prive = GetCode(ddd)
On Error Resume Next
With players(prive)
BFONT = ddd.Font.name
If Font <> "" Then
If Size = 0 Then Size = ddd.FontSize
StoreFont Font, Size, .charset
ddd.Font.charset = 0
ddd.FontSize = 9
ddd.FontName = .FontName
ddd.Font.charset = .charset
ddd.FontSize = Size
Else
Font = .FontName
End If

DE# = (degree) * 180# / Pi
   F.lfItalic = Abs(.italics)
F.lfWeight = Abs(.bold) * 800
  F.lfEscapement = CLng(10 * DE#)
  F.lfFaceName = Left$(Font, 30) + Chr$(0)
  F.lfCharSet = .charset
  F.lfQuality = 3 ' PROOF_QUALITY
  F.lfHeight = (Size * -20) / DYP

  hFont = CreateFontIndirect(F)
  hPrevFont = SelectObject(ddd.hDC, hFont)
nTextY = Int(TextWidth(ddd, what$) * Sin(degree) + TextHeight(ddd, what$) * Cos(degree))





  hFont = SelectObject(ddd.hDC, hPrevFont)
  DeleteObject hFont

End With
PlaceBasket ddd, players(prive)

End Function
Public Function nText(basestack As basetask, ByVal what As String, ByVal Font As String, ByVal Size As Single, Optional ByVal degree As Double = 0#)
Dim ddd As Object
Set ddd = basestack.Owner
Dim PX As Long, PY As Long, OLDFONT As String, OLDSIZE As String, DE#
Dim F As LOGFONT, hPrevFont As Long, hFont As Long
Dim BFONT As String
Dim prive As Long
prive = GetCode(ddd)
On Error Resume Next
With players(prive)
BFONT = ddd.Font.name
If Font <> "" Then
If Size = 0 Then Size = ddd.FontSize
StoreFont Font, Size, .charset
ddd.Font.charset = 0
ddd.FontSize = 9
ddd.FontName = .FontName
ddd.Font.charset = .charset
ddd.FontSize = Size
Else
Font = .FontName
End If

DE# = (degree) * 180# / Pi
   F.lfItalic = Abs(.italics)
F.lfWeight = Abs(.bold) * 800
  F.lfEscapement = CLng(10 * DE#)
  F.lfFaceName = Left$(Font, 30) + Chr$(0)
  F.lfCharSet = .charset
  F.lfQuality = 3 ' PROOF_QUALITY
  F.lfHeight = (Size * -20) / DYP

  hFont = CreateFontIndirect(F)
  hPrevFont = SelectObject(ddd.hDC, hFont)
nText = Int(TextWidth(ddd, what$) * Cos(degree) + TextHeight(ddd, what$) * Sin(degree))


  hFont = SelectObject(ddd.hDC, hPrevFont)
  DeleteObject hFont

End With
PlaceBasket ddd, players(prive)


End Function
Public Sub fullPlain(dd As Object, mb As basket, ByVal wh$, ByVal wi, Optional fake As Boolean = False, Optional nocr As Boolean = False)
Dim whNoSpace$, Displ As Long, DisplLeft As Long, i As Long, whSpace$, INTD As Long, MinDispl As Long, some As Long
Dim st As Long
st = DXP
MinDispl = (TextWidth(dd, "A") \ 2) \ st
If MinDispl <= 1 Then MinDispl = 3
MinDispl = st * MinDispl
INTD = TextWidth(dd, Space$(Len(wh$) - Len(NLtrim$(wh$))))
dd.CurrentX = dd.CurrentX + INTD

wi = wi - INTD
wh$ = NLtrim$(wh$)
INTD = wi + dd.CurrentX

whNoSpace$ = ReplaceStr(" ", "", wh$)
Dim magicratio As Double, whsp As Long, whl As Double


If whNoSpace$ = wh$ Then
MyPrintNew dd, mb.uMineLineSpace, wh$, Not nocr, fake

    'dd.Print wh$
Else
 If Len(whNoSpace$) > 0 Then
   whSpace$ = Space$(Len(Trim$(wh$)) - Len(whNoSpace$))
   
        Displ = st * ((wi - TextWidth(dd, whNoSpace)) \ (Len(whSpace)) \ st)
        some = (wi - TextWidth(dd, whNoSpace) - Len(whSpace) * Displ) \ st  ' ((Displ - MinDispl) * Len(whSpace)) \ st
        magicratio = some / Len(whNoSpace)
        whsp = Len(whSpace)
                whNoSpace$ = vbNullString
                
        For i = 1 To Len(wh$)
            If Mid$(wh$, i, 1) = " " Then
            whsp = whsp - 1
            
               If whNoSpace$ <> "" Then
               whl = Len(whNoSpace$) * magicratio + whl
                    MyPrintNew dd, mb.uMineLineSpace, whNoSpace$, , fake
                whNoSpace$ = vbNullString
                End If
                If some > 0 Then
                '
                some = some - whl
                dd.CurrentX = ((dd.CurrentX + Displ) \ st) * st + CLng(whl) * st
                whl = whl - CLng(whl)
                Else
              dd.CurrentX = ((dd.CurrentX + Displ) \ st) * st
              End If
              
            Else
                whNoSpace$ = whNoSpace$ & Mid$(wh$, i, 1)
            End If
        Next i

          whl = Len(whNoSpace$) * magicratio + whl
      dd.CurrentX = dd.CurrentX + CLng(whl) * st
      
                   MyPrintNew dd, mb.uMineLineSpace, whNoSpace$, , fake
    Else

            MyPrintNew dd, mb.uMineLineSpace, wh$, Not nocr, fake
    End If
End If
End Sub
Public Sub fullPlainWhere(dd As Object, mb As basket, ByVal wh$, ByVal wi As Long, whr As Long, Optional fake As Boolean = False, Optional nocr As Boolean = False)
Dim whNoSpace$, Displ As Long, DisplLeft As Long, i As Long, whSpace$, INTD As Long, MinDispl As Long
MinDispl = (TextWidth(dd, "A") \ 2) \ DXP
If MinDispl <= 1 Then MinDispl = 3
MinDispl = DXP * MinDispl
If whr = 3 Or whr = 0 Then INTD = TextWidth(dd, Space$(Len(wh$) - Len(NLtrim$(wh$))))
dd.CurrentX = dd.CurrentX + INTD
wi = wi - INTD
wh$ = NLtrim$(wh$)
INTD = wi + dd.CurrentX
whNoSpace$ = ReplaceStr(" ", "", wh$)
If whr = 2 Then
wh$ = Trim(wh$)
whNoSpace$ = ReplaceStr(" ", "", wh$)
dd.CurrentX = dd.CurrentX + ((wi - TextWidth(dd, whNoSpace) - (Len(wh$) - Len(whNoSpace)) * MinDispl)) / 2
ElseIf whr = 1 Then
dd.CurrentX = dd.CurrentX + (wi - TextWidth(dd, whNoSpace) - (Len(wh$) - Len(whNoSpace)) * MinDispl)
Else
INTD = (wi - TextWidth(dd, whNoSpace)) * 0.2 + dd.CurrentX

End If
If whNoSpace$ = wh$ Then
 MyPrintNew dd, mb.uMineLineSpace, wh$, Not nocr, fake
Else
 If Len(whNoSpace$) > 0 Then
   whSpace$ = Space$(Len(Trim$(wh$)) - Len(whNoSpace$))
   INTD = TextWidth(dd, whSpace$) + dd.CurrentX
   
   wh$ = Trim$(wh$)
   Displ = MinDispl
   If Displ * Len(whSpace$) + TextWidth(dd, whNoSpace$) > wi Then
   Displ = (wi - TextWidth(dd, whNoSpace$)) / (Len(wh$))
   
   End If
     
    
                whNoSpace$ = vbNullString
        For i = 1 To Len(wh$)
            If Mid$(wh$, i, 1) = " " Then
            whSpace$ = Mid$(whSpace$, 2)
            
               If whNoSpace$ <> "" Then
                 MyPrintNew dd, mb.uMineLineSpace, whNoSpace$, , fake
                whNoSpace$ = vbNullString
                
                End If
              dd.CurrentX = dd.CurrentX + Displ
 
              
            Else
                whNoSpace$ = whNoSpace$ & Mid$(wh$, i, 1)
            End If
        Next i
        If whNoSpace$ <> "" Then

        End If
          MyPrintNew dd, mb.uMineLineSpace, whNoSpace$, Not nocr, fake
    Else
    MyPrintNew dd, mb.uMineLineSpace, wh$, Not nocr, fake
    
    End If
End If
End Sub

Public Sub wPlain(ddd As Object, mb As basket, ByVal what As String, ByVal wi&, ByVal Hi&, Optional nocr As Boolean = False)
Dim PX As Long, PY As Long, ttt As Long, ruller&
Dim buf$, b$, npy As Long ', npx As long
With mb
PlaceBasket ddd, mb
If what = vbNullString Then Exit Sub
PX = .curpos
PY = .currow
If .mx - PX < wi& Then wi& = .mx - PX
If .My - PY < Hi& Then Hi& = .My - PY
If wi& = 0 Or Hi& < 0 Then Exit Sub
npy = PY
ruller& = wi&
For ttt = 1 To Len(what)
    b$ = Mid$(what, ttt, 1)
    Select Case AscW(b$)
    Case Is > 31
    If TextWidth(ddd, buf$ & b$) <= (wi& * .Xt) Then
    buf$ = buf$ & b$
    End If
    Case Is = 13
    If nocr Then Exit For
    MyPrintNew ddd, mb.uMineLineSpace, buf$, Not nocr
    
    
    buf$ = vbNullString
    Hi& = Hi& - 1
    npy = npy + 1
    LCTbasket ddd, mb, npy, PX
    Case Else
    End Select
    If Hi& < 0 Then Exit For
Next ttt
If Hi& >= 0 And buf$ <> "" Then MyPrintNew ddd, mb.uMineLineSpace, buf$, Not nocr
If Not nocr Then LCTbasket ddd, mb, PY, PX
End With
End Sub
Public Sub wwPlain(bstack As basetask, mybasket As basket, ByVal what As String, ByVal wi As Long, ByVal Hi As Long, Optional scrollme As Boolean = False, Optional nosettext As Boolean = False, Optional frmt As Long = 0, Optional ByVal skip As Long = 0, Optional res As Long, Optional isAcolumn As Boolean = False, Optional collectit As Boolean = False, Optional nonewline As Boolean)
Dim ddd As Object, mDoc As Object
    If collectit Then
                Set mDoc = New Document
                 End If
Set ddd = bstack.Owner
Dim PX As Long, PY As Long, ttt As Long, ruller&, last As Boolean, INTD As Long, nowait As Boolean
Dim nopage As Boolean
Dim buf$, b$, npy As Long, kk&, lCount As Long, SCRnum2stop As Long, itnd As Long
Dim nopr As Boolean, nohi As Long, spcc As Long
Dim dv2x15 As Long
dv2x15 = dv15 * 2
If what = vbNullString Then Exit Sub
With mybasket
If Not nosettext Then
PX = .curpos
PY = .currow
If PX >= .mx Then
nowait = True
PX = 0
End If
LCTbasket ddd, mybasket, PY, PX
Else
PX = .curpos
PY = .currow
End If
If PX > .mx Then nowait = True
If wi = 0 Then
If nowait Then wi = .Xt * (.mx - PX) Else wi = .mx * .Xt

Else
If wi <= .mx Then wi = wi * .Xt
End If

wi = wi - CLng(dv2x15)

ddd.CurrentX = ddd.CurrentX + dv2x15
If Not scrollme Then
If Hi >= 0 Then
If (.My - PY) * .Yt < Hi Then Hi = (.My - PY) * .Yt
End If
Else

If Hi > 1 Then
If .pageframe <> 0 Then
lCount = holdcontrol(ddd, mybasket)
.pageframe = 0
End If
SCRnum2stop = holdcontrol(ddd, mybasket)
End If
End If
If wi = 0 Then Exit Sub
npy = PY
Dim w2 As Long, kkl As Long, MinDispl As Long, OverDispl As Long
MinDispl = (TextWidth(ddd, "A") \ 2) \ DXP
If MinDispl <= 1 Then MinDispl = 3
MinDispl = DXP * MinDispl
 w2 = wi '- TextWidth( ddd, "i") +  dv2x15
 If w2 < 0 Then Exit Sub
 If Left$(what, 1) = " " Then INTD = 1
 Dim kku&
 OverDispl = MinDispl
If Hi < 0 Then
Hi = -Hi - 2
nohi = Hi
nopr = True
End If
Dim paragr As Boolean, help1 As Long, help2 As Long, hstr$
nopr = nopr Or collectit
paragr = True
If bstack.IamThread Then nopage = True
For ttt = 1 To Len(what)
If NOEXECUTION Then Exit For
b$ = Mid$(what, ttt, 1)
If paragr Then INTD = Len(buf$ & b$) - Len(NLtrim$(buf$ & b$))
Select Case AscW(b$)
Case Is > 31
spcc = (Len(buf$ & b$) - Len(ReplaceStr(" ", "", Trim$(buf$ & b$))))

kkl = spcc * OverDispl
hstr$ = ReplaceStr(" ", "", buf$ & b$)
help1 = TextWidth(ddd, Space(INTD) + hstr$)
kk& = (help1 + help2) < (w2 - kkl)
    If kk& Then '- 15 * Len(buf$) Then
        buf$ = buf$ & b$
    Else
         kk& = rinstr(Mid$(buf$, INTD + 1), " ") + INTD
         kku& = rinstr(Mid$(buf$, INTD + 1), "_") + INTD
         If kku& > kk& Then kk& = kku&
         If kk& = INTD Then kk& = Len(buf$) + 1
         If CDbl((Len(buf$) - INTD)) > 0 Then
         If (kk& - INTD) / CDbl((Len(buf$) - INTD)) > 0.5 And kkl / wi > 0.2 Then
         If InStr(Mid$(what, ttt), " ") < (Len(buf$) - kk&) Then
                                kk& = Len(buf$) + 1
                            If OverDispl > 5 * DXP Then
                                   OverDispl = MinDispl - 2 * DXP
                   
                              End If
                      buf$ = buf$ & b$
                      GoTo thmagic
                       ElseIf InStr(Mid$(what, ttt), "_") < (Len(buf$) - kk&) And InStr(Mid$(what, ttt), "_") <> 0 Then
      kk& = Len(buf$) + 1
                    If OverDispl > 5 * DXP Then
                         OverDispl = MinDispl - 2 * DXP
                   
                    End If
                      buf$ = buf$ & b$
                       GoTo thmagic
                       
               End If
         End If
         paragr = False: INTD = 0
         If b$ = "." Or b$ = "_" Or b$ = "," Then
         kk& = Len(buf$) + 1
       buf$ = buf$ & b$
       b$ = vbNullString
         End If
       End If
        If kk& > 0 And kk& < Len(buf$) Then
            b$ = Mid$(buf$, kk& + 1) + b$
                If last Then
                buf$ = Trim$(Left$(buf$, kk&))
                Else
            
                buf$ = Left$(buf$, kk&)
                
                End If
                End If
 
          skip = skip - 1
        If skip < 0 Then
        
            If last Then
             If frmt > 0 Then
                    If Not nopr Then fullPlainWhere ddd, mybasket, Trim$(buf$), w2, frmt, nowait, nonewline
               Else
                    If Not nopr Then fullPlain ddd, mybasket, Trim$(buf$), w2, nowait, nonewline   'DDD.Width ' w2
                 End If
                 If collectit Then
                 mDoc.AppendParagraphOneLine Trim$(buf$)
                 End If
            Else
                If frmt > 0 Then
                    If Not nopr Then fullPlainWhere ddd, mybasket, RTrim$(buf$), w2, frmt, nowait, nonewline ' rtrim
                Else
                    If Not nopr Then fullPlain ddd, mybasket, RTrim$(buf$), w2, nowait, nonewline
                    ' npy
                          End If
              If collectit Then
                 mDoc.AppendParagraphOneLine RTrim$(buf$)
                 End If
            End If
        End If
        If isAcolumn Then Exit Sub
        last = True
        buf$ = b$
        If skip < 0 Or scrollme Then
            Hi = Hi - 1
            lCount = lCount + 1
            npy = npy + 1
            
            If npy >= .My And scrollme Then
            If Not nopr Then
                If SCRnum2stop > 0 Then
                    If lCount >= SCRnum2stop Then
                      If Not bstack.toprinter Then
                       If Not nowait Then
                    
                    If Not nopage Then
                     ddd.Refresh
                        Do
   
                            mywait bstack, 10
                       
                        Loop Until INKEY$ <> "" Or mouse <> 0 Or NOEXECUTION
                        End If
                        End If
                        End If
                        SCRnum2stop = .pageframe
                        lCount = 1
                    
                    End If
                End If
                           If Not bstack.toprinter Then
                                ddd.Refresh
                                ScrollUpNew ddd, mybasket
                              ''If Not isAcolumn Then
                               ''    ddd.CurrentY = .My * .Yt - .Yt
                             '' End If
                            Else
                              getnextpage
                              npy = 1
                          End If
                End If
                npy = npy - 1
                      ''
         ElseIf npy >= .My Then
         
        If Not nopr Then crNew bstack, mybasket
               npy = npy - 1
              
          
      End If
If Not nopr Then LCTbasket ddd, mybasket, npy, PX: ddd.CurrentX = ddd.CurrentX + dv2x15
  End If
    End If
Case Is = 13
If nonewline Then Exit For
paragr = True
 skip = skip - 1
 
        If skip < 0 Or scrollme Then
        
If last Then
    If frmt > 0 Then
        If Not nopr Then fullPlainWhere ddd, mybasket, Trim$(buf$), w2, frmt, nowait, nonewline
    Else
    
        If Not nopr Then fullPlainWhere ddd, mybasket, Trim$(buf$), w2, 3, nowait, nonewline
    End If
        If collectit Then
                 mDoc.AppendParagraphOneLine Trim$(buf$)
                 End If
Else
If frmt > 0 Then
If Not nopr Then fullPlainWhere ddd, mybasket, RTrim(buf$), w2, frmt, nowait, nonewline 'rtrim
Else

If Not nopr Then fullPlainWhere ddd, mybasket, RTrim(buf$), w2, 3, nowait, nonewline ' rtrim
End If
    If collectit Then
                 mDoc.AppendParagraphOneLine RTrim$(buf$)
                 End If
End If
End If
last = False

buf$ = vbNullString
'''''''''''''''''''''''''
If isAcolumn Then Exit Sub
If skip < 0 Or scrollme Then
lCount = lCount + 1
    Hi = Hi - 1
    npy = npy + 1
    If npy >= .My And scrollme Then
    If Not nopr Then
            If SCRnum2stop > 0 Then
                If lCount >= SCRnum2stop Then
                     If Not bstack.toprinter Then
                     If Not nowait Then
                     If Not nopage Then
                     ddd.Refresh
                        Do
      
                            mywait bstack, 10
                        Loop Until INKEY$ <> "" Or mouse <> 0 Or NOEXECUTION
                         End If
                         End If
                         End If
                                    SCRnum2stop = .pageframe
                        lCount = 1
                End If
            End If
            
                  If Not bstack.toprinter Then
                            ddd.Refresh
                            ScrollUpNew ddd, mybasket
                ''     If Not isAcolumn Then
                        ddd.CurrentY = .My * .Yt - .Yt
                         ''  End If
                          Else
                          getnextpage
                          npy = 1
                          End If
            End If
            npy = npy - 1
    ElseIf npy >= .My Then
            
If Not nopr Then crNew bstack, mybasket
            ' 1ST
If Not nopr Then ddd.CurrentY = ddd.CurrentY - mybasket.Yt:   npy = npy - 1
    End If
' If Not nopr Then GetXYb2 ddd, mybasket, ruller&, npy
If Not nopr Then
    If nonewline Then npy = npy + 1
    
    ruller& = ddd.CurrentX \ mybasket.Xt
End If
conthere:
If Not nopr Then LCTbasket ddd, mybasket, npy, PX: ddd.CurrentX = ddd.CurrentX + dv2x15
End If
Case Else
End Select

If Hi < 0 Then
' Exit For
'
skip = 1000
scrollme = False
End If
 OverDispl = MinDispl
thmagic:
Next ttt
If Hi >= 0 And buf$ <> "" Then
 skip = skip - 1
        If skip < 0 Then
If frmt = 2 Then
If Not nopr Then fullPlainWhere ddd, mybasket, RTrim(buf$), w2, frmt, nowait, nonewline
            If collectit Then
                 mDoc.AppendParagraphOneLine RTrim$(buf$)
                 End If
Else
If Hi = 0 And frmt = 0 And Not scrollme Then
If Not nopr Then

MyPrintNew ddd, mybasket.uMineLineSpace, buf$, , nowait     ';   '************************************************************************************

res = ddd.CurrentX
        If Trim$(buf$) = vbNullString Then
        ddd.CurrentX = ((ddd.CurrentX + .Xt \ 2) \ .Xt) * .Xt
        Else
        ddd.CurrentX = ((ddd.CurrentX + .Xt \ 1.2) \ .Xt) * .Xt
        End If
End If
            If collectit Then
                 mDoc.AppendParagraphOneLine buf$
                 End If


Exit Sub
Else
If Not nopr Then
fullPlainWhere ddd, mybasket, RTrim(buf$), w2, frmt, nowait, nonewline
End If
    If collectit Then
                 mDoc.AppendParagraphOneLine buf$
                 End If
End If
End If
End If
If skip < 0 Or scrollme Then
    Hi = Hi - 1
    lCount = lCount + 1
   If Not isAcolumn Then npy = npy + 1
        If npy >= .My And scrollme Then

            If Not nopr Then  ' NOPT -> NOPR
                If SCRnum2stop > 0 Then
                    If lCount >= SCRnum2stop Then
                      If Not bstack.toprinter Then
                      If Not nowait Then
                      If Not nopage Then
                     ddd.Refresh
                    Do
            
                            mywait bstack, 10
                    Loop Until INKEY$ <> "" Or mouse <> 0 Or NOEXECUTION
                    End If
                    End If
                    End If
                                SCRnum2stop = .pageframe
                        lCount = 1
                    End If
                End If
                      If Not bstack.toprinter Then
                            ddd.Refresh
                            
                          ScrollUpNew ddd, mybasket
                             
                                   ddd.CurrentY = .My * .Yt - .Yt
                             
                          Else
                          getnextpage
                          npy = 1
                          End If
            End If
            npy = npy - 1
         ElseIf npy >= .My Then
          
            If npy >= .My Then
            
           If Not (nopr Or isAcolumn) Then crNew bstack, mybasket
            npy = npy - 1
            End If
        End If
    If Not nopr Then LCTbasket ddd, mybasket, npy, PX: ddd.CurrentX = ddd.CurrentX + dv2x15
    End If
End If
If scrollme Then

HoldReset lCount, mybasket
End If
res = nohi - Hi

wi = ddd.CurrentX
    If collectit Then
    Dim aa As Document
   bstack.soros.PushStr mDoc.textDoc
        Set mDoc = Nothing
                 End If
''GetXYb ddd, mybasket, .curpos, .currow
End With
End Sub

Public Sub FeedFont2Stack(basestack As basetask, ok As Boolean)
Dim mS As New mStiva
If ok Then
mS.PushVal CDbl(ReturnBold)
mS.PushVal CDbl(ReturnItalic)
mS.PushVal CDbl(ReturnCharset)
mS.PushVal CDbl(ReturnSize)
mS.PushStr ReturnFontName
mS.PushVal CDbl(1)
Else
mS.PushVal CDbl(0)
End If
basestack.soros.MergeTop mS
End Sub
Public Sub nPlain(basestack As basetask, ByVal what As String, ByVal Font As String, ByVal Size As Single, Optional ByVal degree As Double = 0#, Optional ByVal JUSTIFY As Long = 0, Optional ByVal qual As Boolean = True, Optional ByVal ExtraWidth As Long = 0)
Dim ddd As Object
Set ddd = basestack.Owner
Dim PX As Long, PY As Long, OLDFONT As String, OLDSIZE As Long, DEGR As Double
Dim F As LOGFONT, hPrevFont As Long, hFont As Long, fline$, ruler As Long
Dim BFONT As String
On Error Resume Next
BFONT = ddd.Font.name
If ExtraWidth <> 0 Then
SetTextCharacterExtra ddd.hDC, ExtraWidth
End If
Dim icx As Long, icy As Long, x As Long, y As Long, icH As Long
If JUSTIFY < 0 Then degree = 0
DEGR = (degree) * 180# / Pi

  F.lfItalic = Abs(basestack.myitalic)
  F.lfWeight = Abs(basestack.myBold) * 800
  F.lfEscapement = 0
  F.lfFaceName = Left$(Font, 30) + Chr$(0)
  F.lfCharSet = basestack.myCharSet
  If qual Then
  F.lfQuality = PROOF_QUALITY 'NONANTIALIASED_QUALITY '
  Else
  F.lfQuality = NONANTIALIASED_QUALITY
  End If
  F.lfHeight = (Size * -20) / DYP
  hFont = CreateFontIndirect(F)
  hPrevFont = SelectObject(ddd.hDC, hFont)
    icH = TextHeight(ddd, "fq")
  hFont = SelectObject(ddd.hDC, hPrevFont)
  DeleteObject hFont
 F.lfItalic = Abs(basestack.myitalic)
  F.lfWeight = Abs(basestack.myBold) * 800
F.lfEscapement = CLng(10 * DEGR)
  F.lfFaceName = Left$(Font, 30) + Chr$(0)
  F.lfCharSet = basestack.myCharSet
  If qual Then
  F.lfQuality = PROOF_QUALITY 'NONANTIALIASED_QUALITY '
  Else
  F.lfQuality = NONANTIALIASED_QUALITY
  End If
  F.lfHeight = (Size * -20) / DYP
  

  
    hFont = CreateFontIndirect(F)
  hPrevFont = SelectObject(ddd.hDC, hFont)



icy = CLng(Cos(degree) * icH)
icx = CLng(Sin(degree) * icH)

With players(GetCode(ddd))
If JUSTIFY < 0 Then
JUSTIFY = Abs(JUSTIFY) - 1
If JUSTIFY = 0 Then
y = .YGRAPH - icy
x = .XGRAPH - icx * 2
ElseIf JUSTIFY = 1 Then
y = .YGRAPH
x = .XGRAPH
Else
y = .YGRAPH - icy / 2
x = .XGRAPH - icx
End If
Else
y = .YGRAPH - icy
x = .XGRAPH - icx

End If
End With
what$ = ReplaceStr(vbCrLf, vbCr, what) + vbCr
Do While what$ <> ""
If Left$(what$, 1) = vbCr Then
fline$ = vbNullString
what$ = Mid$(what$, 2)
Else
fline$ = GetStrUntil(vbCr, what$)
End If
x = x + icx
y = y + icy
If JUSTIFY = 1 Then
    ddd.CurrentX = x - Int(TextWidth(ddd, fline$) * Cos(degree) + TextHeight(ddd, fline$) * Sin(degree))
    ddd.CurrentY = y + Int(TextWidth(ddd, fline$) * Sin(degree) - TextHeight(ddd, fline$) * Cos(degree))
ElseIf JUSTIFY = 2 Then
    ddd.CurrentX = x - Int(TextWidth(ddd, fline$) * Cos(degree) + TextHeight(ddd, fline$) * Sin(degree)) \ 2
    ddd.CurrentY = y + Int(TextWidth(ddd, fline$) * Sin(degree) - TextHeight(ddd, fline$) * Cos(degree)) \ 2
Else
    ddd.CurrentX = x
    ddd.CurrentY = y
End If
MyPrint ddd, fline$
Loop
  hFont = SelectObject(ddd.hDC, hPrevFont)
  DeleteObject hFont
If ExtraWidth <> 0 Then SetTextCharacterExtra ddd.hDC, 0
End Sub

Public Sub nForm(bstack As basetask, TheSize As Single, nW As Long, nH As Long, myLineSpace As Long)
    On Error Resume Next
    StoreFont bstack.Owner.Font.name, TheSize, bstack.myCharSet
    nH = fonttest.TextHeight("Wq") + myLineSpace * 2
    nW = fonttest.TextWidth("W") + dv15
End Sub

Sub crNew(bstack As basetask, mb As basket)
Dim d As Object
Set d = bstack.Owner
With mb
Dim PX As Long, PY As Long, r As Long
PX = .curpos
PY = .currow
PX = 0
PY = PY + 1
If PY >= .My Then

If Not bstack.toprinter Then
ScrollUpNew d, mb
PY = .My - 1
Else
PY = 0
PX = 0
getnextpage
End If
End If
.curpos = PX
.currow = PY

End With
End Sub

Public Sub CdESK()
Dim x, y, ff As Form, useform1 As Boolean
If Form1.Visible Then
    If Form5.Visible Then
    Set ff = Form5
    Form5.backcolor = 0
    useform1 = True
    Else
    Set ff = Form1
    End If
    x = ff.Left / DXP
    y = ff.Top / DYP
    If useform1 Then Form1.Hide
    ff.Hide
    
    Sleep 20
    k1 = 0
    MyDoEvents1 Form3
    Dim aa As New cDIBSection
    aa.CreateFromPicture hDCToPicture(GetDC(0), x, y, ff.Width / DXP, ff.Height / DYP)
    
    aa.ThumbnailPaint ff
    ff.Visible = True
    If useform1 Then Form1.Visible = True: If Form3.Visible Then Form3.skiptimer = True: Form3.WindowState = 0
End If
Set ff = Nothing
End Sub
Private Sub FillBack(thathDC As Long, there As RECT, bgcolor As Long)
' create brush
Dim my_brush As Long
my_brush = CreateSolidBrush(bgcolor)
FillRect thathDC, there, my_brush
DeleteObject my_brush
End Sub

Public Sub ScrollUpNew(d As Object, mb As basket)
Dim ar As RECT, r As Long
Dim p As Long
With mb
ar.Left = 0
ar.Bottom = d.Height / dv15
ar.Right = d.Width / dv15
ar.Top = .mysplit * .Yt / dv15
p = .Yt / dv15
r = BitBlt(d.hDC, CLng(ar.Left), CLng(ar.Top), CLng(ar.Right), CLng(ar.Bottom - p), d.hDC, CLng(ar.Left), CLng(ar.Top + p), SRCCOPY)

 ar.Top = ar.Bottom - p
FillBack d.hDC, ar, .Paper
.curpos = 0
.currow = .My - 1
End With
GdiFlush
End Sub
Public Sub ScrollDownNew(d As Object, mb As basket)
Dim ar As RECT, r As Long
Dim p As Long
With mb
ar.Left = 0
ar.Bottom = d.ScaleY(d.Height, 1, 3)
ar.Right = d.ScaleX(d.Width, 1, 3)
ar.Top = d.ScaleY(.mysplit * .Yt, 1, 3)
p = d.ScaleY(.Yt, 1, 3)
r = BitBlt(d.hDC, CLng(ar.Left), CLng(ar.Top + p), CLng(ar.Right), CLng(ar.Bottom - p), d.hDC, CLng(ar.Left), CLng(ar.Top), SRCCOPY)
d.Line (0, .mysplit * .Yt)-(d.ScaleWidth, .mysplit * .Yt + .Yt), .Paper, BF
.currow = .mysplit
.curpos = 0
End With
End Sub





Public Sub SetText(dq As Object, Optional alinespace As Long = -1, Optional ResetColumns As Boolean = False)
' can be used for first time also
Dim mymul As Long
On Error Resume Next
With players(GetCode(dq))
If .FontName = vbNullString Or alinespace = -2 Then
' we have to make it
If alinespace = -2 Then alinespace = 0
ResetColumns = True
.FontName = dq.FontName
.charset = dq.Font.charset
.SZ = dq.FontSize
Else
If Not (fonttest.FontName = .FontName And fonttest.Font.charset = dq.Font.charset And fonttest.Font.Size = .SZ) Then
fonttest.Font.charset = .charset
If fonttest.Font.charset = .charset Then
StoreFont .FontName, .SZ, .charset
dq.Font.charset = 0
dq.FontSize = 9
dq.FontName = .FontName
dq.Font.charset = .charset
dq.FontSize = .SZ
End If
End If
End If
If alinespace <> -1 Then
If .uMineLineSpace = .MineLineSpace * 2 And .MineLineSpace <> 0 Then
.MineLineSpace = alinespace
.uMineLineSpace = alinespace * 2
Else
.MineLineSpace = alinespace
.uMineLineSpace = alinespace ' so now we have normal
End If
End If
.SZ = dq.FontSize
.Xt = fonttest.TextWidth("W") + dv15
.Yt = fonttest.TextHeight("fj")
.mx = Int(dq.Width / .Xt)
.My = Int(dq.Height / (.Yt + .uMineLineSpace * 2))
''.Paper = dq.BackColor
If .My <= 0 Then .My = 1
If .mx <= 0 Then .mx = 1
.Yt = .Yt + .uMineLineSpace * 2
If ResetColumns Then
mymul = Int(.mx / 8)
If mymul = 1 Then mymul = 2
If mymul = 0 Then
.Column = .mx \ 2 - 1
Else
.Column = Int(.mx / mymul)
While (.mx Mod .Column) > 0 And (.mx / .Column >= 3)
.Column = .Column + 1
Wend
End If
If .Column = 0 Then .Column = .mx
.Column = .Column - 1
If .Column < 4 Then .Column = 4
End If
.MAXXGRAPH = dq.Width
.MAXYGRAPH = dq.Height
End With

End Sub

Public Sub SetTextSZ(dq As Object, mSz As Single, Optional factor As Single = 1, Optional AddTwipsTop As Long = -1)
' Used for making specific basket
On Error Resume Next
With players(GetCode(dq))
If AddTwipsTop < 0 Then
    If .double And factor = 1 Then
    .mysplit = .osplit
    .Column = .OCOLUMN
    .currow = (.currow + 1) * 2 - 2
    .curpos = .curpos * 2
    mSz = .SZ / 2
    .uMineLineSpace = .MineLineSpace
    .double = False
    ElseIf factor = 2 And Not .double Then
     .osplit = .mysplit
     .OCOLUMN = .Column
     .Column = .Column / 2
     .mysplit = .mysplit / 2
     .currow = (.currow + 1) / 2
     .curpos = .curpos / 2
     mSz = .SZ * 2
    .uMineLineSpace = .MineLineSpace * 2
    .double = True
    End If
Else

mSz = mSz * factor
.MineLineSpace = AddTwipsTop
.uMineLineSpace = AddTwipsTop * factor
.double = factor <> 1
End If
dq.FontSize = mSz

StoreFont dq.Font.name, mSz, dq.Font.charset
If .double Then
    Dim nowtextheight As Long
    nowtextheight = fonttest.TextHeight("fj")
    If .MineLineSpace = 0 Then
    Else
    If (.Yt - .MineLineSpace * 2) * 2 <> nowtextheight Then
  '  Stop
    .uMineLineSpace = Int((.MAXYGRAPH - nowtextheight * .My / 2) / .My)
    End If
    
    End If
End If
SetText dq



If .My <= 0 Then .My = 1
If .mx <= 0 Then .mx = 1
.SZ = dq.FontSize
.MAXXGRAPH = dq.Width
.MAXYGRAPH = dq.Height
End With

End Sub

Public Sub SetTextBasketBack(dq As Object, mb As basket)
' set minimum display parameters for current object
' need an already filled basket
On Error Resume Next
With mb

If Not (dq.FontName = .FontName And dq.Font.charset = .charset And dq.Font.Size = .SZ) Then

StoreFont .FontName, .SZ, .charset
dq.Font.charset = 0
dq.FontSize = 9
dq.FontName = .FontName
dq.Font.charset = .charset
dq.FontSize = .SZ
End If
dq.ForeColor = .mypen

If Not dq.backcolor = .Paper Then
    dq.backcolor = .Paper
End If
End With
End Sub

Function gf$(bstack As basetask, ByVal y&, ByVal x&, ByVal a$, c&, F&, Optional STAR As Boolean = False)
On Error Resume Next
Dim cLast&, b$, cc$, dq As Object, ownLinespace
Dim mybasket As basket, addpixels As Long
GFQRY = True
Set dq = bstack.Owner
SetText dq
mybasket = players(GetCode(dq))

With mybasket
If InternalLeadingSpace() = 0 And .MineLineSpace = 0 Then
addpixels = 0
Else
addpixels = 2
End If
If dq.Visible = False Then dq.Visible = True
If exWnd = 0 Then dq.SetFocus
dq.FontTransparent = False
LCTbasket dq, mybasket, y&, x&
Dim o$
o$ = a$
If a$ = vbNullString Then a$ = " "
INK$ = vbNullString

Dim XX&
XX& = x&

x& = x& - 1

cLast& = Len(a$)
'*****************
If cLast& + x& >= .mx Then
MyDoEvents
If dq.Font.charset = 161 Then
b$ = InputBoxN("�������� ����������", MesTitle$, a$)
Else
b$ = InputBoxN("Input Variable", MesTitle$, a$)
End If
If b$ = vbNullString Then b$ = a$
If Trim$(b$) < "A" Then b$ = Right$(String$(cLast&, " ") + b$, cLast&) Else b$ = Left$(b$ + String$(cLast&, " "), cLast&)
gf$ = b$
If XX& < .mx Then
dq.FontTransparent = False
If STAR Then
PlainBaSket dq, mybasket, StarSTR(Left$(b$, .mx - x&)), True, , addpixels
Else
PlainBaSket dq, mybasket, Left$(b$, .mx - x&), True, , addpixels
End If
End If
GoTo GFEND
Else
dq.FontTransparent = False
If STAR Then
PlainBaSket dq, mybasket, StarSTR(a$), True, , addpixels
Else
PlainBaSket dq, mybasket, a$, True, , addpixels
End If
End If

'************
b$ = a$
.currow = y&
.curpos = c& + x&
LCTCB dq, mybasket, ins&

Do
MyDoEvents1 Form1
If bstack.IamThread Then If myexit(bstack) Then GoTo contgfhere
If Not TaskMaster Is Nothing Then
If TaskMaster.QueueCount > 0 Then
dq.FontTransparent = True
TaskMaster.RestEnd1
TaskMasterTick
End If
End If
 cc$ = INKEY$
 If cc$ <> "" Then
If Not TaskMaster Is Nothing Then TaskMaster.rest
SetTextBasketBack dq, mybasket
 Else
If Not TaskMaster Is Nothing Then TaskMaster.RestEnd
SetTextBasketBack dq, mybasket
        If iamactive Then
           If Screen.ActiveForm Is Nothing Then
                            DestroyCaret
                      nomoveLCTC dq, mybasket, y&, c& + x&, ins&
                      iamactive = False
           Else
                If Not (GetForegroundWindow = Screen.ActiveForm.hwnd And Screen.ActiveForm.name = "Form1") Then
                 
                      DestroyCaret
                      nomoveLCTC dq, mybasket, y&, c& + x&, ins&
                      iamactive = False
             Else
                         If ShowCaret(dq.hwnd) = 0 Then
                                   HideCaret dq.hwnd
                                   .currow = y&
                                   .curpos = c& + x&
                                   LCTCB dq, mybasket, ins&
                                   ShowCaret dq.hwnd
                         End If
                End If
                End If
     Else
  If Not Screen.ActiveForm Is Nothing Then
            If GetForegroundWindow = Screen.ActiveForm.hwnd And Screen.ActiveForm.name = "Form1" Then
           
                          nomoveLCTC dq, mybasket, y&, c& + x&, ins&
                             iamactive = True
                              If ShowCaret(dq.hwnd) = 0 And Screen.ActiveForm.name = "Form1" Then
                                   HideCaret dq.hwnd
                                   .currow = y&
                                   .curpos = c& + x&
                                   LCTCB dq, mybasket, ins&
                                   ShowCaret dq.hwnd
                         End If
                         End If
            End If
     End If

 End If

 
        If NOEXECUTION Then
        If KeyPressed(&H1B) Then
                       F& = 99 'ESC  ****************
                        c& = 1
                        gf$ = o$
                        b$ = o$
                                          NOEXECUTION = False
                                         BLOCKkey = True
                                    While KeyPressed(&H1B) ''And UseEsc
                                    If Not TaskMaster Is Nothing Then
                             If TaskMaster.Processing Then
                                                TaskMaster.RestEnd1
                                                TaskMaster.TimerTick
                                                TaskMaster.rest
                                                MyDoEvents1 dq
                                                Else
                                                MyDoEvents
                                                
                                                End If
                                                Else
                                                DoEvents
                                                End If
'''sleepwait 1
                                    Wend
                                                                        BLOCKkey = False
                                                                        End If
                 Exit Do
        End If
        Select Case Len(cc$)
        Case 0
        If FKey > 0 Then
        If FK$(FKey) <> "" And FKey <> 13 Then
            cc$ = FK$(FKey)
            interpret basestack1, cc$
        
        End If
        FKey = 0
        Else
        
        End If
        
        Case 1
        If STAR And cc$ = " " Then cc$ = Chr$(127)
                Select Case AscW(cc$)
                Case 8
                        If c& > 1 Then
                        Mid$(b$, c& - 1) = Mid$(b$, c&) & " "
                         c& = c& - 1
                         dq.FontTransparent = False
                                   .currow = y&
                                   .curpos = c& + x&
                                   LCTCB dq, mybasket, ins&
                        If STAR Then
                        PlainBaSket dq, mybasket, StarSTR(Mid$(b$, c&)), True, , addpixels
                        Else
                        PlainBaSket dq, mybasket, Mid$(b$, c&), True, , addpixels
                        End If
                         dq.Refresh
                                   .currow = y&
                                   .curpos = c& + x&
                                   LCTCB dq, mybasket, ins&
                        End If
                Case 6
                F& = -1
                 gf$ = b$
                Exit Do
                Case 13, 9
                F& = 1 'NEXT  *************
                gf$ = b$
                Exit Do

                Case 27
                        F& = 99 'ESC  ****************
                        c& = 1
                        gf$ = o$
                        b$ = o$
                                    NOEXECUTION = False
                                    BLOCKkey = True
                                    While KeyPressed(&H1B) ''And UseEsc
                                    If Not TaskMaster Is Nothing Then
                                    If TaskMaster.Processing Then
                                            TaskMaster.RestEnd1
                                            TaskMaster.TimerTick
                                            TaskMaster.rest
                                            MyDoEvents1 dq
                                            Else
                                            MyDoEvents
                                            
                                            End If
                                            Else
                                            DoEvents
                                            End If
                                    ''''MyDoEvents
                                    Wend
                                                                        BLOCKkey = False
                        NOEXECUTION = False
                        Exit Do
                       Case 32 To 126, Is > 128
           
                        .currow = y&
                        .curpos = c& + x&
                        LCTCB dq, mybasket, ins&
                        If ins& = 1 Then
                          If AscW(cc$) = 32 And STAR Then
                If AscW(Mid$(b$, c& + 1)) > 32 Then
                 Mid$(b$, c&) = Mid$(b$, c& + 1) & " "
                End If
                
                
                Else
                        
                                                
                        Mid$(b$, c&, 1) = cc$
                        dq.FontTransparent = False
                        If STAR Then
                        PlainBaSket dq, mybasket, StarSTR(Mid$(b$, c&)), True, , addpixels
                        Else
                        PlainBaSket dq, mybasket, Mid$(b$, c&), True, , addpixels
                        End If
                         dq.Refresh
                        End If
                        If c& < Len(b$) Then c& = c& + 1
                                   .currow = y&
                                   .curpos = c& + x&
                                   LCTCB dq, mybasket, ins&
                        Else
                                 If AscW(cc$) = 32 And STAR Then
            
                
                
                Else
                     
                        LSet b$ = Left$(b$, c& - 1) + cc$ & Mid$(b$, c&)
                        dq.FontTransparent = False
                        If STAR Then
                        PlainBaSket dq, mybasket, StarSTR(Mid$(b$, c&)), True, , addpixels
                        Else
                        PlainBaSket dq, mybasket, Mid$(b$, c&), True, , addpixels
                        End If
                         dq.Refresh
                        'LCTC Dq, Y&, X& + C& + 1, INS&
                        End If
                        If c& < cLast& Then c& = c& + 1
                                .currow = y&
                                .curpos = c& + x&
                                LCTCB dq, mybasket, ins&
                        End If
                End Select
        Case 2
                Select Case AscW(Right$(cc$, 1))
                Case 81
                F& = 10 ' exit - pagedown ***************
                gf$ = b$
                Exit Do
                Case 73
                F& = -10 ' exit - pageup
                gf$ = b$
                Exit Do
                Case 79
                F& = 20 ' End
                gf$ = b$
                Exit Do
                Case 71
                F& = -20 ' exit - home
                gf$ = b$
                Exit Do
                Case 75 'LEFT
                        If c& > 1 Then
                                   .currow = y&
                                .curpos = c& + x&
                                LCTCB dq, mybasket, ins&
                        c& = c& - 1:
                        .currow = y&
                        .curpos = c& + x&
                        LCTCB dq, mybasket, ins&
                        End If
                Case 77 'RIGHT
                        If c& < cLast& Then
                      
                If Not (AscW(Mid$(b$, c&)) = 32 And STAR) Then
                
             
                                    .currow = y&
                                .curpos = c& + x&
                                LCTCB dq, mybasket, ins&
                        c& = c& + 1:
                        .currow = y&
                                .curpos = c& + x&
                                LCTCB dq, mybasket, ins&
                        End If
                        End If
                Case 72 ' EXIT UP
                F& = -1 ' PREVIUS ***************
                gf$ = b$
                Exit Do
                Case 80 'EXIT DOWN OR ENTER OR TAB
                F& = 1 'NEXT  *************
                gf$ = b$
                Exit Do
                Case 82
                            .currow = y&
                                .curpos = c& + x&
                                LCTCB dq, mybasket, ins&
                ins& = 1 - ins&
                           .currow = y&
                                .curpos = c& + x&
                                LCTCB dq, mybasket, ins&
                Case 83
                        Mid$(b$, c&) = Mid$(b$, c& + 1) & " "
                        dq.FontTransparent = False
                        LCTbasket dq, mybasket, y&, c& + x&
                        If STAR Then
                        PlainBaSket dq, mybasket, StarSTR(Mid$(b$, c&)), True, , addpixels
                        Else
                        PlainBaSket dq, mybasket, Mid$(b$, c&), True, , addpixels
                        End If
                               .currow = y&
                                .curpos = c& + x&
                                LCTCB dq, mybasket, ins&
                     dq.Refresh
                End Select
        End Select
      
Loop

GFEND:
LCTbasket dq, mybasket, y&, x& + 1
If x& < .mx And Not XX& > .mx Then
If STAR Then
 PlainBaSket dq, mybasket, StarSTR(b$), True, , addpixels
Else
PlainBaSket dq, mybasket, b$, True, , addpixels
End If
contgfhere:
 dq.Refresh
If Not TaskMaster Is Nothing Then If TaskMaster.QueueCount > 0 Then TaskMaster.RestEnd
End If
dq.FontTransparent = True
 DestroyCaret
Set dq = Nothing
TaskMaster.RestEnd1
GFQRY = False
End With
End Function



Sub Original(bstack As basetask, COM$)
Dim d As Object, b$

If COM$ <> "" Then QUERYLIST = vbNullString
If Form1.Visible Then REFRESHRATE = 25
If bstack.toprinter Then
bstack.toprinter = False
Form1.PrinterDocument1.Cls
Set d = bstack.Owner
Else
Set d = bstack.Owner
End If
On Error Resume Next
Dim basketcode As Long
basketcode = GetCode(d)


Form1.IEUP ""
Form1.KeyPreview = True
Dim dummy As Boolean, rs As String, mPen As Long, ICO As Long, BAR As Long, bar2 As Long
BAR = 1
Form1.DIS.Visible = True

If COM$ <> "" Then d.Visible = False
ClrSprites
mPen = PenOne
d.Font.bold = bstack.myBold
d.Font.Italic = bstack.myitalic
GetMonitorsNow
Console = FindPrimary
With ScrInfo(Console)
If SzOne < 4 Then SzOne = 4
    'Form1.Visible = False
   ' If IsWine Then
    Sleep 30
    .Width = .Width - dv15 - 1
    .Height = .Height - dv15 - 1
   ' End If
    If Not Form1.WindowState = 0 Then Form1.WindowState = 0
    Sleep 10
    If Form1.WindowState = 0 Then
        Form1.Move .Left, .Top, .Width - 1, .Height - 1
        If Form1.Top <> .Left Or Form1.Left <> .Top Then
            Form1.Cls
            Form1.Move .Left, .Top, .Width - 1, .Height - 1
        End If
    Else
        Sleep 100
        On Error Resume Next
        Form1.WindowState = 0
        Form1.Move .Left, .Top, .Width - 1, .Height - 1
        If Form1.Top <> .Top Or Form1.Left <> .Left Then
        Form1.Cls
        Form1.Move .Left, .Top, .Width - 1, .Height - 1
        End If
    End If
    
Form1.DIS.Visible = True
FrameText d, SzOne, (.Width + .Left - 1 - Form1.Left), (.Height + .Top - 1 - Form1.Top), PaperOne
End With
Form1.DIS.backcolor = mycolor(PaperOne)
If lckfrm = 0 Then
SetText d
bstack.Owner.Font.charset = bstack.myCharSet
StoreFont bstack.Owner.Font.name, SzOne, bstack.myCharSet
 
 With players(basketcode)
.mypen = PenOne
.XGRAPH = 0
.YGRAPH = 0
.bold = bstack.myBold '' I have to change that
.italics = bstack.myitalic
.FontName = bstack.Owner.FontName
.SZ = SzOne
.charset = bstack.myCharSet
.MAXXGRAPH = Form1.Width
.MAXYGRAPH = Form1.Height
.Paper = bstack.Owner.backcolor
.mypen = mycolor(PenOne)
End With


 
' check to see if
Dim ss$, skipthat As Boolean
If Not IsSupervisor Then
    ss$ = ReadUnicodeOrANSI(userfiles & "desktop.inf")
    If ss$ <> "" Then
     skipthat = interpret(bstack, ss$)
     If mycolor(PenOne) <> d.ForeColor Then
     PenOne = -d.ForeColor
     End If
    End If
End If
If SzOne < 36 And d.Height / SzOne > 250 Then SetDouble d: BAR = BAR + 1
If SzOne < 83 Then

If bstack.myCharSet = 161 Then
b$ = "���������� "
Else
b$ = "ENVIRONMENT "
End If
d.ForeColor = mycolor(PenOne)
LCTbasket d, players(DisForm), 0, 0
wwPlain bstack, players(DisForm), b$ & "M2000", d.Width, 0, 0 '',True
ICO = TextWidth(d, b$ & "M2000") + 100
' draw graphic'
Dim IX As Long, IY As Long
With players(DisForm)
IX = (.Xt \ 25) * 25
IY = Form1.Icon.Height * IX / Form1.Icon.Width
If IsWine Then
Form1.DIS.PaintPicture Form1.Icon, ICO, (.Yt - IY) / 2, IX, IY
Form1.DIS.PaintPicture Form1.Icon, ICO, (.Yt - IY) / 2, IX, IY
Else
Dim myico As New cDIBSection
myico.backcolor = Form1.DIS.backcolor
myico.CreateFromPicture Form1.Icon
Form1.DIS.PaintPicture myico.Picture(1), ICO, (.Yt - IY) / 2, IX, IY
End If
End With

' ********
SetNormal d
   Dim osbit As String
   If Is64bit Then osbit = " (64-bit)" Else osbit = " (32-bit)"
        LCTbasket d, players(basketcode), BAR, 0
        rs = RESOURCES
            If bstack.myCharSet = 161 Then
            If Revision = 0 Then
            wwPlain bstack, players(DisForm), "������ �����������: " & CStr(VerMajor) & "." & CStr(VerMinor), d.Width, 0, True
            Else
                    wwPlain bstack, players(DisForm), "������ �����������: " & CStr(VerMajor) & "." & Left$(CStr(VerMinor), 1) & " (" & CStr(Revision) & ")", d.Width, 0, True
                End If
                   wwPlain bstack, players(DisForm), "����������� �������: " & os & osbit, d.Width, 0, True
            
                      wwPlain bstack, players(DisForm), "����� ������: " & Tcase(Originalusername), d.Width, 0, True
                
            Else
             If Revision = 0 Then
              wwPlain bstack, players(DisForm), "Interpreter Version: " & CStr(VerMajor) & "." & CStr(VerMinor), d.Width, 0, True
             Else
                    wwPlain bstack, players(DisForm), "Interpreter Version: " & CStr(VerMajor) & "." & Left$(CStr(VerMinor), 1) & " rev. (" & CStr(Revision) & ")", d.Width, 0, True
                 End If
              
                      wwPlain bstack, players(DisForm), "Operating System: " & os & osbit, d.Width, 0, True
                
                   wwPlain bstack, players(DisForm), "User Name: " & Tcase(Originalusername), d.Width, 0, True
        
                 End If
                        '    cr bstack
            GetXYb d, players(basketcode), bar2, BAR
             players(basketcode).curpos = bar2
            players(basketcode).currow = BAR
           BAR = BAR + 1
            If BAR >= players(basketcode).My Then ScrollUpNew d, players(basketcode)
                    LCTbasket d, players(basketcode), BAR, 0
                    players(basketcode).curpos = 0
            players(basketcode).currow = BAR
    End If
If Not skipthat Then
 dummy = interpret(bstack, "PEN " & CStr(mPen) & ":CLS ," & CStr(BAR))
End If
End If
If Not skipthat Then
dummy = interpret(bstack, COM$)
End If
'cr bstack
End Sub
Sub ClearScr(d As Object, c1 As Long)
Dim aa As Long
With players(GetCode(d))
.Paper = c1
.curpos = 0
.currow = 0
.lastprint = False
End With
d.Line (0, 0)-(d.ScaleWidth - dv15, d.ScaleHeight - dv15), c1, BF
d.CurrentX = 0
d.CurrentY = 0

End Sub
Sub ClearScrNew(d As Object, mb As basket, c1 As Long)
Dim im As New StdPicture, spl As Long
With mb
spl = .mysplit * .Yt
Set im = d.Image
.Paper = c1

If d.name = "Form1" Or mb.used = True Then
d.Line (0, spl)-(d.ScaleWidth - dv15, d.ScaleHeight - dv15), .Paper, BF
.curpos = 0
.currow = .mysplit
Else
d.backcolor = c1
If spl > 0 Then d.PaintPicture im, 0, 0, d.Width, spl, 0, 0, d.Width, spl, vbSrcCopy
.curpos = 0
.currow = .mysplit

End If
.lastprint = False
d.CurrentX = 0
d.CurrentY = 0
End With
End Sub
Function iText(bb As basetask, ByVal v$, wi&, Hi&, aTitle$, n As Long, Optional NumberOnly As Boolean = False, Optional UseIntOnly As Boolean = False) As String
Dim x&, y&, dd As Object, wh&, shiftlittle As Long, OLDV$
Set dd = bb.Owner
With players(GetCode(dd))
If .lastprint Then
x& = (dd.CurrentX + .Xt - dv15) \ .Xt
y& = dd.CurrentY \ .Yt
shiftlittle = x& * .Xt - dd.CurrentX
If y& > .mx Then
y& = .mx - 1
crNew bb, players(GetCode(dd))

End If
Else
x& = .curpos
y& = .currow
End If
If .mx - x& - 1 < wi& Then wi& = .mx - x&
If .My - y& - 1 < Hi& Then Hi& = .My - y& - 1
If wi& = 0 Or Hi& < 0 Then
iText = v$
Exit Function
End If
wi& = wi& + x&
Hi& = Hi& + y&
Form1.EditTextWord = True
wh& = -1
If n <= 0 Then Form1.TEXT1.Title = aTitle$ + " ": wh& = Abs(n - 1)
If NumberOnly Then
Form1.TEXT1.NumberOnly = True
Form1.TEXT1.NumberIntOnly = UseIntOnly
OLDV$ = v$
ScreenEdit bb, v$, x&, y&, wi& - 1, Hi&, wh&, , n, shiftlittle
If result = 99 Then v$ = OLDV$
Form1.TEXT1.NumberIntOnly = False
Form1.TEXT1.NumberOnly = False
Else
OLDV$ = v$
ScreenEdit bb, v$, x&, y&, wi& - 1, Hi&, wh&, , n, shiftlittle
If result = 99 And Hi& = wi& Then v$ = OLDV$
End If
iText = v$
End With
End Function
Sub ScreenEditDOC(bstack As basetask, aaa As Variant, x&, y&, x1&, y1&, Optional l As Long = 0, Optional usecol As Boolean = False, Optional col As Long)
On Error Resume Next
Dim ot As Boolean, back As New Document, i As Long, d As Object
Dim prive As basket
Set d = bstack.Owner
prive = players(GetCode(d))
With prive
Dim oldesc As Boolean
oldesc = escok
escok = False
' we have a limit here
If Not aaa.IsEmpty Then
For i = 1 To aaa.DocParagraphs
back.AppendParagraph aaa.TextParagraph(i)
Next i
End If
i = back.LastSelStart
Dim aaaa As Document, tcol As Long, trans As Boolean
If usecol Then tcol = mycolor(col) Else tcol = d.backcolor
If Not Form1.Visible Then newshow basestack1

'd.Enabled = False
If Not bstack.toback Then d.TabStop = False
If d Is Form1 Then
d.lockme = True
Else
d.Parent.lockme = True
End If
If y1& - y& = 0 Then y& = y& - 1: If y1& < 0 Then y& = y& + 1: y1& = y1& + 1
TextEditLineHeight = y1& - y& + 1

With Form1.TEXT1
'MyDoEvents
ProcTask2 bstack

Hook Form1.hwnd, Nothing '.glistN
.AutoNumber = Not Form1.EditTextWord

.UsedAsTextBox = False
.glistN.LeftMarginPixels = 10
.glistN.maxchar = 0
If d.ForeColor = tcol Then
Set Form1.Point2Me = d
If d.name = "Form1" Then
.glistN.SkipForm = False
Else
.glistN.SkipForm = True
End If
Form1.TEXT1.glistN.BackStyle = 1
End If
Dim scope As Long
scope = ChooseByHue(d.ForeColor, rgb(16, 12, 8), rgb(253, 245, 232))
If d.backcolor = ChooseByHue(scope, d.backcolor, rgb(128, 128, 128)) Then
If lightconv(scope) > 192 Then
scope = lightconv(scope) - 128
.glistN.CapColor = rgb(128 + scope / 2, 128 + scope / 2, 128 + scope / 2)
Else
.glistN.CapColor = scope
End If
Else
scope = lightconv(scope) - 128

If scope > 0 Then
.glistN.CapColor = rgb(128 + scope / 2, 128 + scope / 2, 128 + scope / 2)
Else
.glistN.CapColor = rgb(128, 128, 128)
End If
End If
.SelectionColor = .glistN.CapColor
.glistN.addpixels = 2 * prive.uMineLineSpace / dv15
.EditDoc = True
.enabled = True
.glistN.ZOrder 0

.backcolor = tcol

.ForeColor = d.ForeColor
Form1.SetText1
.glistN.overrideTextHeight = fonttest.TextHeight("fj")
.Font.name = d.Font.name
.Font.Size = d.Font.Size ' SZ 'Int(d.font.Size) Why
.Font.charset = d.Font.charset
.Font.Italic = d.Font.Italic
.Font.bold = d.Font.bold
.Font.name = d.Font.name
.Font.charset = d.Font.charset
.Font.Size = prive.SZ
With prive
If bstack.toback Then

Form1.TEXT1.Move x& * .Xt, y& * .Yt, (x1& - x&) * .Xt + .Xt, (y1& - y&) * .Yt + .Yt
Else
Form1.TEXT1.Move x& * .Xt + d.Left, y& * .Yt + d.Top, (x1& - x&) * .Xt + .Xt, (y1& - y&) * .Yt + .Yt
End If
End With
If d.ForeColor = tcol Then
Form1.TEXT1.glistN.RepaintFromOut d.Image, d.Left, d.Top
End If

Set .mDoc = aaa
.nowrap = False


With Form1.TEXT1
.Form1mn1Enabled = False
.Form1mn2Enabled = False
.Form1mn3Enabled = Clipboard.GetFormat(13) Or Clipboard.GetFormat(1)
End With

Form1.KeyPreview = False
NOEDIT = False

.WrapAll

.Render

.Visible = True
.SetFocus
If l <> 0 Then
    If l > 0 Then
        If aaa.SizeCRLF < l Then l = aaa.SizeCRLF
        
        .SelStart = l
        Else
        .SelStart = 0
    End If
Else
If aaa.SizeCRLF < .LastSelStart Then
.SelStart = 1
Else
 .SelStart = .LastSelStart
End If
End If
    .ResetUndoRedo

End With
''MyDoEvents
ProcTask2 bstack
CancelEDIT = False
Do
BLOCKkey = False

 If bstack.IamThread Then If myexit(bstack) Then GoTo contScreenEditThere1

ProcTask2 bstack


'End If

Loop Until NOEDIT ''Or (KeyPressed(&H1B) And UseEsc)
 NOEXECUTION = False
 BLOCKkey = True
While KeyPressed(&H1B) ''And UseEsc
ProcTask2 bstack

Wend
BLOCKkey = False
contScreenEditThere1:
TaskMaster.RestEnd1
If Form1.TEXT1.Visible Then Form1.TEXT1.Visible = False
 l = Form1.TEXT1.LastSelStart


If d Is Form1 Then
d.lockme = False
Else
d.Parent.lockme = False
End If
If Not CancelEDIT Then

Else
Set aaa = back
back.LastSelStart = i
End If
Set Form1.TEXT1.mDoc = New Document

Form1.TEXT1.glistN.BackStyle = 0
Set Form1.Point2Me = Nothing
UnHook Form1.hwnd
Form1.KeyPreview = True

INK$ = vbNullString
escok = oldesc
Set d = Nothing
End With
End Sub
Sub ScreenEdit(bstack As basetask, a$, x&, y&, x1&, y1&, Optional l As Long = 0, Optional changelinefeeds As Long = 0, Optional maxchar As Long = 0, Optional ExcludeThisLeft As Long = 0)
On Error Resume Next
' allways a$ enter with crlf,but exit with crlf or cr or lf depents from changelinefeeds
Dim oldesc As Boolean, d As Object
Set d = bstack.Owner

''SetTextSZ d, Sz

Dim prive As basket
prive = players(GetCode(d))
oldesc = escok
escok = False
Dim ot As Boolean

If Not bstack.toback Then
d.TabStop = False
d.Parent.lockme = True
Else
d.lockme = True
End If
If Not Form1.Visible Then newshow basestack1
d.Visible = True
If d.Visible Then d.SetFocus
With Form1.TEXT1
'MyDoEvents
ProcTask2 bstack
Hook Form1.hwnd, Nothing
'.Filename = VbNullString
.AutoNumber = Not Form1.EditTextWord

If maxchar > 0 Then
ot = .glistN.DragEnabled
 .glistN.DragEnabled = True
y1& = y&
TextEditLineHeight = 1
.glistN.BorderStyle = 0
.glistN.BackStyle = 1
Set Form1.Point2Me = d
If d.name = "Form1" Then
.glistN.SkipForm = False
Else
.glistN.SkipForm = True
End If

.glistN.HeadLine = vbNullString
.glistN.HeadLine = vbNullString
.glistN.LeftMarginPixels = 1
.glistN.maxchar = maxchar
.nowrap = True
If Len(a$) > maxchar Then
a$ = Left$(a$, maxchar)
End If

l = Len(a$)


.UsedAsTextBox = True

Else
.glistN.BorderStyle = 0
.glistN.BackStyle = 0

If y1& - y& = 0 Then y& = y& - 1: If y1& < 0 Then y& = y& + 1: y1& = y1& + 1
TextEditLineHeight = y1& - y& + 1
.UsedAsTextBox = False
.glistN.LeftMarginPixels = 10
.glistN.maxchar = 0

End If
If Form1.EditTextWord Then
.glistN.WordCharLeft = ConCat(":", "{", "}", "[", "]", ",", "(", ")", "!", ";", "=", ">", "<", """", " ", "+", "-", "/", "*", "^", "$", "%", "_", "@")
.glistN.WordCharRight = ConCat(".", ":", "{", "}", "[", "]", ",", ")", "!", ";", "=", ">", "<", """", " ", "+", "-", "/", "*", "^", "$", "%", "_")
.glistN.WordCharRightButIncluded = vbNullString

Else
.glistN.WordCharLeft = ConCat(":", "{", "}", "[", "]", ",", "(", ")", "!", ";", "=", ">", "<", "'", """", " ", "+", "-", "/", "*", "^", "@")
.glistN.WordCharRight = ConCat(":", "{", "}", "[", "]", ",", ")", "!", ";", "=", ">", "<", "'", """", " ", "+", "-", "/", "*", "^")
.glistN.WordCharRightButIncluded = "(" ' so aaa(sdd) give aaa( as word
End If

Dim scope As Long
scope = ChooseByHue(d.ForeColor, rgb(16, 12, 8), rgb(253, 245, 232))
If d.backcolor = ChooseByHue(scope, d.backcolor, rgb(128, 128, 128)) Then
If lightconv(scope) > 192 Then
scope = lightconv(scope) - 128
.glistN.CapColor = rgb(128 + scope / 2, 128 + scope / 2, 128 + scope / 2)
Else
.glistN.CapColor = scope
End If
Else
scope = lightconv(scope) - 128

If scope > 0 Then
.glistN.CapColor = rgb(128 + scope / 2, 128 + scope / 2, 128 + scope / 2)
Else
.glistN.CapColor = rgb(128, 128, 128)
End If
End If
.SelectionColor = .glistN.CapColor
.glistN.addpixels = 2 * prive.uMineLineSpace / dv15
.EditDoc = True
.enabled = True
'.glistN.AddPixels = 0
.glistN.ZOrder 0
.backcolor = d.backcolor
.ForeColor = d.ForeColor
.Font.name = d.Font.name
Form1.SetText1
.glistN.overrideTextHeight = fonttest.TextHeight("fj")
.Font.Size = d.Font.Size ' SZ 'Int(d.font.Size) Why
.Font.charset = d.Font.charset
.Font.Italic = d.Font.Italic
.Font.bold = d.Font.bold

.Font.name = d.Font.name

.Font.charset = d.Font.charset
.Font.Size = prive.SZ 'Int(d.font.Size)
If bstack.toback Then
If maxchar > 0 Then

.Move x& * prive.Xt - ExcludeThisLeft, y& * prive.Yt, (x1& - x&) * prive.Xt + prive.Xt, (y1& - y&) * prive.Yt + prive.Yt
.glistN.RepaintFromOut d.Image, 0, 0
Else
.Move x& * prive.Xt, y& * prive.Yt, (x1& - x&) * prive.Xt + prive.Xt, (y1& - y&) * prive.Yt + prive.Yt
End If
Else
If maxchar > 0 Then
.Move x& * prive.Xt + d.Left - ExcludeThisLeft, y& * prive.Yt + d.Top, (x1& - x&) * prive.Xt + prive.Xt, (y1& - y&) * prive.Yt + prive.Yt
.glistN.RepaintFromOut d.Image, d.Left, d.Top
Else
.Move x& * prive.Xt + d.Left, y& * prive.Yt + d.Top, (x1& - x&) * prive.Xt + prive.Xt, (y1& - y&) * prive.Yt + prive.Yt
End If
End If
If a$ <> "" Then
If .Text <> a$ Then .LastSelStart = 0
.Text = a$
Else
.Text = vbNullString
.LastSelStart = 0
End If
'.glistN.NoFreeMoveUpDown = True
With Form1.TEXT1
.Form1mn1Enabled = False
.Form1mn2Enabled = False
.Form1mn3Enabled = Clipboard.GetFormat(13) Or Clipboard.GetFormat(1)
End With

Form1.KeyPreview = False

NOEDIT = False

If maxchar = 0 Then
.nowrap = False
.Charpos = 0
Else
.Render
End If

.Visible = True
''MyDoEvents
ProcTask2 bstack
.SetFocus

If l <> 0 Then
    If l > 0 Then
        If Len(a$) < l Then l = Len(a$)
        .SelStart = l
                Else
        .SelStart = 0
    End If
Else
If Len(a$) < .LastSelStart Then
.SelStart = 1
l = Len(a$)
Else
    .SelStart = .LastSelStart
End If
End If
    .ResetUndoRedo



End With
'MyDoEvents
ProcTask2 bstack
CancelEDIT = False
Dim timeOut As Long


Do
BLOCKkey = False

 If bstack.IamThread Then If myexit(bstack) Then GoTo contScreenEditThere

ProcTask2 bstack

 Loop Until NOEDIT
 NOEXECUTION = False
 BLOCKkey = True
While KeyPressed(&H1B) ''And UseEsc
'
ProcTask2 bstack


Wend
BLOCKkey = False
contScreenEditThere:
TaskMaster.RestEnd1
If Form1.TEXT1.Visible Then Form1.TEXT1.Visible = False

 l = Form1.TEXT1.LastSelStart

If bstack.toback Then
d.lockme = False
Else
d.Parent.lockme = False
End If
If Not CancelEDIT Then

If changelinefeeds > 10 Then
a$ = Form1.TEXT1.TextFormatBreak(vbCr)
ElseIf changelinefeeds > 9 Then
a$ = Form1.TEXT1.TextFormatBreak(vbLf)
Else
If changelinefeeds = -1 Then changelinefeeds = 0
a$ = Form1.TEXT1.Text
End If
Else
changelinefeeds = -1
End If

Form1.KeyPreview = True
If maxchar > 0 Then Form1.TEXT1.glistN.DragEnabled = ot

UnHook Form1.hwnd
INK$ = vbNullString

escok = oldesc
Set d = Nothing
End Sub

Function blockCheck(ByVal s$, ByVal lang As Long, countlines As Long, Optional ByVal sbname$ = vbNullString) As Boolean
If s$ = vbNullString Then blockCheck = True: Exit Function
Dim i As Long, j As Long, c As Long, b$, resp&
Dim openpar As Long, oldi As Long
countlines = 1
lang = Not lang
Dim a1 As Boolean
Dim jump As Boolean
If Trim(s$) = vbNullString Then Exit Function
c = Len(s$)
a1 = True
i = 1
Do
Select Case AscW(Mid$(s$, i, 1))
Case 13
If openpar <> 0 Then
If Not lang Then
        b$ = sbname$ + "Problem in parenthesis in line " + CStr(countlines)
    Else
        b$ = sbname$ + "�������� �� ��� ����������� ��� ������ " + CStr(countlines)
    End If
    resp& = ask(b$, True)
If resp& <> 1 Then
blockCheck = True
End If
    Exit Function

End If
If Len(s$) > i + 1 Then countlines = countlines + 1
Case 32, 160
' nothing
Case 34
oldi = i
Do While i < c
i = i + 1
Select Case AscW(Mid$(s$, i, 1))
Case 34
Exit Do
Case 13

checkit:
    If Not lang Then
        b$ = sbname$ + "Problem in string in line " + CStr(countlines)
    Else
        b$ = sbname$ + "�������� �� �o ������������� ��� ������ " + CStr(countlines)
    End If
    resp& = ask(b$, True)
If resp& <> 1 Then
blockCheck = True
End If
Exit Function

Case Else
If i = c Then
'Stop
End If
End Select

Loop
If oldi <> i Then
Else
i = oldi + 1
GoTo checkit
End If

Case 40
openpar = openpar + 1
Case 41
openpar = openpar - 1
Case 39, 92
If openpar <= 0 Then
Do While i < c
i = i + 1
If Mid$(s$, i, 2) = vbCrLf Then Exit Do
Loop
End If
Case 61
jump = True
Case 123


If jump Then
jump = False
' we have a multiline text
Dim target As Long
target = j
    Do
    Select Case AscW(Mid$(s$, i, 1))
    Case 13
    If Len(s$) > i + 1 Then countlines = countlines + 1
Case 34
Do While i < c
i = i + 1
Select Case AscW(Mid$(s$, i, 1))
Case 34
Exit Do
Case 13
 i = oldi + 1
 Do While i < c
 If AscW(Mid$(s$, i, 1)) = 125 Then j = j + 1: Exit Do
 i = i + 1
 Loop
 i = i + 1
 Exit Do
    If Not lang Then
        b$ = sbname$ + "Problem in string in line " + CStr(countlines)
    Else
        b$ = sbname$ + "�������� �� �o ������������� ��� ������ " + CStr(countlines)
    End If
    resp& = ask(b$, True)
If resp& <> 1 Then
blockCheck = True
End If
    Exit Function
'case 10 then
End Select
Loop
    Case 123
    j = j - 1
    Case 125
    j = j + 1: If j = target Then Exit Do
    End Select
    i = i + 1
    Loop Until i > c
    If j <> target Then Exit Do
    Else
j = j - 1
End If


Case 125
j = j + 1: If j = 1 Then Exit Do
Case Else
jump = False

End Select
i = i + 1
Loop Until i > c


If j = 0 Then

ElseIf j < 0 Then
    If Not lang Then
        b$ = sbname$ + "Problem in blocks - look } are less " + CStr(Abs(j))
    Else
        b$ = sbname$ + "�������� �� �� ������� - ��� �� } ����� �������� " + CStr(Abs(j))
    End If
resp& = ask(b$, True)
Else
If Not lang Then
b$ = sbname$ + "Problem in blocks - look { are less " + CStr(j)
Else
b$ = sbname$ + "�������� �� �� ������� - ��� �� { ����� �������� " + CStr(j)
End If
resp& = ask(b$, True)
End If
If resp& <> 1 Then
blockCheck = True
End If

End Function

Sub ListChoise(bstack As basetask, a$, x&, y&, x1&, y1&)
On Error Resume Next
Dim d As Object, oldh As Long
Dim s$, prive As basket
If NOEXECUTION Then Exit Sub
Set d = bstack.Owner
prive = players(GetCode(d))
Hook Form1.hwnd, Form1.List1
Dim ot As Boolean, drop
With Form1.List1
.Font.name = d.Font.name
Form1.Font.charset = d.Font.charset
Form1.Font.Strikethrough = False
.Font.Size = d.Font.Size
.Font.name = d.Font.name
Form1.Font.charset = d.Font.charset
.Font.Size = d.Font.Size
If LEVCOLMENU < 2 Then .backcolor = d.ForeColor
If LEVCOLMENU < 3 Then .ForeColor = d.backcolor
.Font.bold = d.Font.bold
.Font.Italic = d.Font.Italic
.addpixels = 2 * prive.uMineLineSpace / dv15
.VerticalCenterText = True
If d.Visible = False Then d.Visible = True
.StickBar = True
s$ = .HeadLine
.HeadLine = vbNullString
.HeadLine = s$
.enabled = False
If .Visible Then
If .BorderStyle = 0 Then

Else
End If

Else

If .BorderStyle = 0 Then
.Move x& * prive.Xt + d.Left, y& * prive.Yt + d.Top, (x1& - x&) * prive.Xt + prive.Xt, (y1& - y&) * prive.Yt + prive.Yt + .HeadlineHeight * dv15
Else
.Move x& * prive.Xt - dv15 + d.Left, y& * prive.Yt - dv15 + d.Top, (x1& - x&) * prive.Xt + prive.Xt + 2 * dv15, (y1& - y&) * prive.Yt + prive.Yt + 2 * dv15 + .HeadlineHeight * dv15
End If
End If
.enabled = True
.ShowBar = False

If .LeaveonChoose Then
.CalcAndShowBar
Exit Sub
End If



ot = Targets
Targets = False

.PanPos = 0

If .ListIndex < 0 Then
.ShowThis 1
Else
.ShowThis .ListIndex + 1
End If
.Visible = True
.ZOrder 0
NOEDIT = False
.Tag = a$

If a$ = vbNullString Then
    drop = mouse
    MyDoEvents
    ' Form1.KeyPreview = False
    .enabled = True
    .SetFocus
    .LeaveonChoose = True
    If .HeadLine <> "" Then
    oldh = 0
    Else
    oldh = .HeadlineHeight
    End If
    Else
        .enabled = True
    .SetFocus
    .LeaveonChoose = False
    
    End If
    .ShowMe
            If bstack.TaskMain Or TaskMaster.Processing Then
            If TaskMaster.QueueCount > 0 Then
            mywait bstack, 100
              Else
            MyDoEvents
            End If
        Else
         DoEvents
         Sleep 1
         End If

    If .HeadlineHeight <> oldh Then
    If .BorderStyle = 0 Then
    If ((y1& - y&) * prive.Yt + prive.Yt + 2 * dv15 + .HeadlineHeight * dv15) + .Top > ScrY() Then
    .Move .Left, .Top - (((y1& - y&) * prive.Yt + prive.Yt + 2 * dv15 + .HeadlineHeight * dv15) + .Top - ScrY()), (x1& - x&) * prive.Xt + prive.Xt, (y1& - y&) * prive.Yt + prive.Yt + .HeadlineHeight * dv15
    Else
.Move .Left, .Top, (x1& - x&) * prive.Xt + prive.Xt, (y1& - y&) * prive.Yt + prive.Yt + .HeadlineHeight * dv15
End If
Else
If ((y1& - y&) * prive.Yt + prive.Yt + 2 * dv15 + .HeadlineHeight * dv15) + .Top > ScrY() Then
.Move .Left, .Top - (((y1& - y&) * prive.Yt + prive.Yt + 2 * dv15 + .HeadlineHeight * dv15) + .Top - ScrY()), (x1& - x&) * prive.Xt + prive.Xt + 2 * dv15, (y1& - y&) * prive.Yt + prive.Yt + 2 * dv15 + .HeadlineHeight * dv15
Else
.Move .Left, .Top, (x1& - x&) * prive.Xt + prive.Xt + 2 * dv15, (y1& - y&) * prive.Yt + prive.Yt + 2 * dv15 + .HeadlineHeight * dv15
End If
End If
  
oldh = .HeadlineHeight
    End If
    .FloatLimitTop = Form1.Height - prive.Yt * 2
     .FloatLimitLeft = Form1.Width - prive.Xt * 2
    MyDoEvents
    End With
If a$ = vbNullString Then
    Do
        If bstack.TaskMain Or TaskMaster.Processing Then
            If TaskMaster.QueueCount > 0 Then
          mywait bstack, 2
             TaskMaster.RestEnd1
   TaskMaster.TimerTick
TaskMaster.rest
''SleepWait 1
  Sleep 1
              Else
            MyDoEvents
            End If
        Else
         DoEvents
                  Sleep 1
         End If
    
    Loop Until Form1.List1.Visible = False
    If Not NOEXECUTION Then MOUT = False
    Do
    drop = mouse
    MyDoEvents
    Loop Until drop = 0 Or MOUT
    MOUT = False
    While KeyPressed(&H1B) ''And UseEsc
ProcTask2 bstack
Wend
MOUT = False: NOEXECUTION = False
    If Form1.List1.ListIndex >= 0 Then
    a$ = Form1.List1.list(Form1.List1.ListIndex)
    Else
    a$ = vbNullString
    End If
   Form1.List1.enabled = False
    Else
        Form1.List1.enabled = True
    
  If a$ = vbNullString Then
  Form1.List1.SetFocus
  Form1.List1.LeaveonChoose = True
  Else
  d.TabStop = True
  End If
  End If
NOEDIT = True
Set d = Nothing
UnHook Form1.hwnd
Form1.KeyPreview = True
Targets = ot
End Sub
Private Sub mywait11(bstack As basetask, PP As Double)
Dim p As Boolean, e As Boolean
On Error Resume Next
If bstack.Process Is Nothing Then
''If extreme Then MyDoEvents
If PP = 0 Then Exit Sub
Else

Err.Clear
p = bstack.Process.Done
If Err.Number = 0 Then
e = True
If p <> 0 Then
Exit Sub
End If
End If
End If
PP = PP + CDbl(timeGetTime)

Do


If TaskMaster.Processing And Not bstack.TaskMain Then
        If Not bstack.toprinter Then bstack.Owner.Refresh
        'If TaskMaster.tickdrop > 0 Then TaskMaster.tickdrop
        TaskMaster.TimerTick  'Now
       ' SleepWait 1
       MyDoEvents
       
Else
        ' SleepWait 1
        MyDoEvents
        End If
If e Then
p = bstack.Process.Done
If Err.Number = 0 Then
If p <> 0 Then
Exit Do
End If
End If
End If
Loop Until PP <= CDbl(timeGetTime) Or NOEXECUTION

                       If exWnd <> 0 Then
                MyTitle$ bstack
                End If
End Sub
Public Sub WaitDialog(bstack As basetask)
Dim oldesc As Boolean
oldesc = escok
escok = False
Dim d As Object
Set d = bstack.Owner
Dim ot As Boolean, drop
ot = Targets
Targets = False  ' do not use targets for now
NOEDIT = False
    drop = mouse
    ''SleepWait3 100
    Sleep 1
    If bstack.ThreadsNumber = 0 Then
    If Not (bstack.toback Or bstack.toprinter) Then If bstack.Owner.Visible Then bstack.Owner.Refresh

    End If
    Dim mycode As Double, oldcodeid As Double
mycode = Rnd * 1233312231
oldcodeid = Modalid
Dim x As Form, zz As Form
Set zz = Screen.ActiveForm
For Each x In Forms
        If x.Visible And x.name = "GuiM2000" Then
                                   If x.Enablecontrol Then
                                        x.Modal = mycode
                                        x.Enablecontrol = False
                                    End If
        End If
Next x
  
    Do
   

            mywait11 bstack, 5
      Sleep 1
    
    Loop Until loadfileiamloaded = False Or NOEDIT = True Or LastErNum <> 0
    Modalid = mycode
    MOUT = False
    Do
    drop = mouse Or KeyPressed(&H1B)
    MyDoEvents

    Loop Until drop = 0 Or MOUT Or NOEDIT = True Or LastErNum <> 0
 NOEDIT = True
 BLOCKkey = True
While KeyPressed(&H1B) ''And UseEsc

ProcTask2 bstack
NOEXECUTION = False
Wend
Dim z As Form
Set z = Nothing

           For Each x In Forms
            If x.Visible And x.name = "GuiM2000" Then
                If Not x.Enablecontrol Then
                        x.TestModal mycode
               ' Else
                '        Set Z = x
                End If
            End If
            Next x
          Modalid = oldcodeid

BLOCKkey = False
escok = oldesc
INK$ = vbNullString

Form1.KeyPreview = True
Targets = ot
 mywait11 bstack, 5

End Sub

Public Sub FrameText(dd As Object, ByVal Size As Single, x As Long, y As Long, cc As Long, Optional myCut As Boolean = False)
Dim i As Long, mymul As Long

If dd Is Form1.PrinterDocument1 Then
' check this please
Pr_Back dd, Size
Exit Sub
End If


Dim basketcode As Long
basketcode = GetCode(dd)
With players(basketcode)
.curpos = 0
.currow = 0
.XGRAPH = 0
.YGRAPH = 0
If x = 0 Then
x = dd.Width
y = dd.Height
End If

.mysplit = 0

''dd.BackColor = 0 '' mycolor(cc)    ' check if paper...

.Paper = mycolor(cc)
dd.CurrentX = 0
dd.CurrentY = 0

''ClearScreenNew dd, mybasket, cc
dd.CurrentY = 0
dd.Font.Size = Size
Size = dd.Font.Size

''Sleep 1  '' USED TO GIVE TIME TO LOAD FONT
If fonttest.FontName = dd.Font.name And dd.Font.Size = fonttest.Font.Size Then
Else
StoreFont dd.Font.name, Size, dd.Font.charset
End If
.Yt = fonttest.TextHeight("fj")
.Xt = fonttest.TextWidth("W")

While TextHeight(fonttest, "fj") / (.Yt / 2 + dv15) < dv
Size = Size + 0.2
fonttest.Font.Size = Size
Wend
dd.Font.Size = Size
.Yt = TextHeight(fonttest, "fj")
.Xt = fonttest.TextWidth("W") + dv15

.mx = Int(x / .Xt)
.My = Int(y / (.Yt + .MineLineSpace * 2))
.Yt = .Yt + .MineLineSpace * 2
If .mx < 2 Then .mx = 2: x = 2 * .Xt
If .My < 2 Then .My = 2: y = 2 * .Yt
If (.mx Mod 2) = 1 And .mx > 1 Then
.mx = .mx - 1
End If
mymul = Int(.mx / 8)
If mymul = 1 Then mymul = 2
If mymul = 0 Then
.Column = .mx \ 2 - 1
Else
.Column = Int(.mx / mymul)

While (.mx Mod .Column) > 0 And (.mx / .Column >= 3)
.Column = .Column + 1
Wend
End If
If .Column = 0 Then .Column = .mx
' second stage
If .mx Mod .Column > 0 Then


If .mx Mod 4 <> 0 Then .mx = 4 * (.mx \ 4)
If .mx < 4 Then .mx = 4
'.My = Int(y / (.Yt + .MineLineSpace * 2))
'.Yt = .Yt + .MineLineSpace * 2
If .mx < 2 Then .mx = 2: x = 2 * .Xt
If .My < 2 Then .My = 2: y = 2 * .Yt
If (.mx Mod 2) = 1 And .mx > 1 Then
.mx = .mx - 1
End If
mymul = Int(.mx / 8)
If mymul = 1 Then mymul = 2
If mymul = 0 Then
.Column = .mx \ 2 - 1
Else
.Column = Int(.mx / mymul)

While (.mx Mod .Column) > 0 And (.mx / .Column >= 3)
.Column = .Column + 1
Wend
End If
If .Column = 0 Then .Column = .mx

End If

.Column = .Column - 1 ' FOR PRINT 0 TO COLUMN-1

If .Column < 4 Then .Column = 4


.SZ = Size

If dd.name = "Form1" Then
' no change
Else
If dd.name <> "dSprite" And Typename(dd) <> "GuiM2000" Then
Dim mmxx As Long, mmyy As Long, XX As Long, YY As Long
mmxx = .mx * CLng(.Xt)
mmyy = .My * CLng(.Yt)
XX = (dd.Parent.ScaleWidth - mmxx) \ 2
YY = (dd.Parent.ScaleHeight - mmyy) \ 2
dd.Move XX, YY, mmxx, mmyy
ElseIf myCut Then
Dim mmxx1, mmyy1
mmxx1 = .mx * .Xt
mmyy1 = .My * .Yt
dd.Move dd.Left, dd.Top, mmxx1, mmyy1
'dd.width = .mx * .Xt
'dd.Height = .My * .Yt
End If

End If

.MAXXGRAPH = dd.Width
.MAXYGRAPH = dd.Height
.FTEXT = 0
.FTXT = vbNullString

Form1.MY_BACK.ClearUp
If dd.Visible Then
ClearScr dd, .Paper
Else
dd.backcolor = .Paper
End If
End With



End Sub

Sub Pr_Back(dd As Object, Optional mSize As Single = 0)
SetText dd
If mSize > 0 Then
SetTextSZ dd, mSize
End If

End Sub
Function INKEY$()
' ���� � ��������� �� �������� ��� ��������� ���� ���������������, ��� ������ �� ����� ����� �������..
' �� ���������� �� ����� ��� ���� � ������.
' ��������������� ������ ���� ���������� �� ������������

If MKEY$ <> "" Then ' ������� �� �������� ��� ��������� ���� MKEY$
' �� ���� ���� ���� �� �������� ��� ������� �������� ��� ��� ����� ��� INK$
' ��� ���������� �� MKEY$
    INK$ = MKEY$ & INK$
    MKEY$ = vbNullString
End If
' ���� �� ����������� �� �� INK$ �� ���� ������
If INK$ <> "" Then
' ������ ��������� �� ������ 0 ��� ����� Byte, ������ ������ �
    If Asc(INK$) = 0 Then
        INKEY$ = Left$(INK$, 2)
        INK$ = Mid$(INK$, 3)
    Else
    ' ������ ��������� ��� ��������� �� ��� ���� �����
    INKEY$ = PopOne(INK$)
    
   
        
    End If
Else
    '�� ��� ������ ������...��� ������� ������...��������� �� ������!
    INKEY$ = vbNullString
End If

End Function
Function UINKEY$()
' mink$ used for reinput keystrokes
' MINK$ = MINK$ & UINK$
If UKEY$ <> "" Then MINK$ = MINK$ + UKEY$: UKEY$ = vbNullString
If MINK$ <> "" Then
If AscW(MINK$) = 0 Then
    UINKEY$ = Left$(MINK$, 2)
    MINK$ = Mid$(MINK$, 3)
Else
    UINKEY$ = Left$(MINK$, 1)
    MINK$ = Mid$(MINK$, 2)
End If
Else
    UINKEY$ = vbNullString
End If

End Function

Function QUERY(bstack As basetask, Prompt$, s$, m&, Optional USELIST As Boolean = True, Optional endchars As String = vbCr, Optional excludechars As String = vbNullString, Optional checknumber As Boolean = False) As String
'NoAction = True
On Error Resume Next
Dim dX As Long, dY As Long, safe$

If excludechars = vbNullString Then excludechars = Chr$(0)
If QUERYLIST = vbNullString Then QUERYLIST = Chr$(13): LASTQUERYLIST = 1
Dim q1 As Long, sp$, once As Boolean, dq As Object
 
Set dq = bstack.Owner
SetText dq
Dim basketcode As Long, prive As basket
prive = players(GetCode(dq))
With prive
If .currow >= .My Or .lastprint Then crNew bstack, prive: .lastprint = False
LCTbasketCur dq, prive
ins& = 0
Dim fr1 As Long, fr2 As Long, p As Double
UseEnter = False
If dq.name = "DIS" Then
If Form1.Visible = False Then
    If Not Form3.Visible Then
        Form1.Hide: Sleep 100
    Else
        'Form3.PREPARE
    End If

    If Form1.WindowState = vbMinimized Then Form1.WindowState = vbNormal
    Form1.Show , Form5
    If ttl Then
    If Form3.Visible Then
    If Not Form3.WindowState = 0 Then
    Form3.skiptimer = True: Form3.WindowState = 0
    End If
    End If
    End If
    MyDoEvents
    Sleep 100
    End If
Else
    Console = FindFormSScreen(Form1)
If Form1.Top >= VirtualScreenHeight() Then Form1.Move ScrInfo(Console).Left, ScrInfo(Console).Top
End If
If dq.Visible = False Then dq.Visible = True
If exWnd = 0 Then Form1.KeyPreview = True
QRY = True
If GetForegroundWindow = Form1.hwnd Then
If exWnd = 0 Then dq.SetFocus
End If


Dim DE$

PlainBaSket dq, prive, Prompt$, , , 0
dq.Refresh

 

INK$ = vbNullString
dq.FontTransparent = False

Dim a$
s$ = vbNullString
oldLCTCB dq, prive, 0
Do
If Not once Then
If USELIST Then
 DoEvents
  If Not iamactive Then
  Sleep 1
  Else
  If Not (bstack.IamChild Or bstack.IamAnEvent) Then Sleep 1
  End If
 ''If MKEY$ = VbNullString Then Dq.refresh
Else
If Not bstack.IamThread Then

 If Not iamactive Then
 If Not Form1.Visible Then
 If Form1.WindowState = 1 Then Form1.WindowState = 0
 If Form1.Top > VirtualScreenHeight() - 100 Then Form1.Top = ScrInfo(Console).Top
 Form1.Visible = True
 If Form3.Visible Then Form3.skiptimer = True: Form3.WindowState = 0
 End If
 k1 = 0: MyDoEvents1 Form1
 End If
If LastErNum <> 0 Then
      LCTCB dq, prive, -1: DestroyCaret
 oldLCTCB dq, prive, 0
Exit Do
End If
 Else
 
LCTbasketCur dq, prive                       ' here
 End If
 End If
 End If
If Not QRY Then HideCaret dq.hwnd:   Exit Do

 BLOCKkey = False
 If USELIST Then

 If Not once Then
 once = True

 If QUERYLIST <> "" Then  ' up down
 
    If INK = vbNullString Then MyDoEvents
If clickMe = 38 Then

 If Len(QUERYLIST) < LASTQUERYLIST Then LASTQUERYLIST = 2
  q1 = InStr(LASTQUERYLIST, QUERYLIST, vbCr)
         If q1 < 2 Or q1 <= LASTQUERYLIST Then
         q1 = 1: LASTQUERYLIST = 1
         End If
        MKEY$ = vbNullString
        INK = String$(RealLen(s$), 8) + Mid$(QUERYLIST, LASTQUERYLIST, q1 - LASTQUERYLIST)
        LASTQUERYLIST = q1 + 1

    ElseIf clickMe = 40 Then
    
    If LASTQUERYLIST < 3 Then LASTQUERYLIST = Len(QUERYLIST)
    q1 = InStrRev(QUERYLIST, vbCr, LASTQUERYLIST - 2)
         If q1 < 2 Then
                   q1 = Len(QUERYLIST)
         End If
         If q1 > 1 Then
         LASTQUERYLIST = InStrRev(QUERYLIST, vbCr, q1 - 1) + 1
         If LASTQUERYLIST < 2 Then LASTQUERYLIST = 2
         
        MKEY$ = vbNullString
        INK = String$(RealLen(s$), 8) + Mid$(QUERYLIST, LASTQUERYLIST, q1 - LASTQUERYLIST)
   LASTQUERYLIST = q1 + 1

      End If
 End If
 clickMe = -2
 End If
 
 ElseIf INK <> "" Then
 MKEY$ = vbNullString
 Else
 clickMe = 0
 once = False
 End If
 End If

  
againquery:
 a$ = INKEY$
 
If a$ = vbNullString Then
If TaskMaster Is Nothing Then Set TaskMaster = New TaskMaster
    If TaskMaster.QueueCount > 0 Then
  ProcTask2 bstack
  If Not NOEDIT Or Not QRY Then
  LCTCB dq, prive, -1: DestroyCaret
   oldLCTCB dq, prive, 0
  Exit Do
  End If
  SetText dq

LCTbasket dq, prive, .currow, .curpos
    Else
  
   End If
      If iamactive Then
 If ShowCaret(dq.hwnd) = 0 Then
 
   LCTCB dq, prive, 0
  End If
If Not bstack.IamThread Then

MyDoEvents1 Form1  'SleepWait 1
End If

 If Screen.ActiveForm Is Nothing Then
 iamactive = False:  If ShowCaret(dq.hwnd) <> 0 Then HideCaret dq.hwnd
Else
 
    If Not GetForegroundWindow = Screen.ActiveForm.hwnd Then
    iamactive = False:  If ShowCaret(dq.hwnd) <> 0 Then HideCaret dq.hwnd
  
    End If
    End If
    End If

  End If
    If bstack Is Nothing Then
    Set bstack = basestack1
    NOEXECUTION = True
    MOUT = True
     Modalid = 0
                         ShutEnabledGuiM2000
                         MyDoEvents
                         GoTo contqueryhere
    End If
   If bstack.IamThread Then If myexit(bstack) Then GoTo contqueryhere

If Screen.ActiveForm Is Nothing Then
iamactive = False
Else
If Screen.ActiveForm.name <> "Form1" Then
iamactive = False
Else
iamactive = GetForegroundWindow = Screen.ActiveForm.hwnd
End If
End If
If FKey > 0 Then
If FK$(FKey) <> "" Then
s$ = FK$(FKey)
FKey = 0
             ''  here
      LCTCB dq, prive, -1: DestroyCaret
 oldLCTCB dq, prive, 0
 Exit Do
End If
End If


dq.FontTransparent = False
If RealLen(a$) = 1 Or Len(a$) = 1 Or (RealLen(a$) = 0 And Len(a$) = 1 And Len(s$) > 1) Then
   '
   
   If Len(a$) = 1 Then
    If InStr(endchars, a$) > 0 Then
     If a$ = vbCr Then
     If a$ <> Left$(endchars, 1) Then
    
    a$ = Left$(endchars, 1)
     Else
      LCTCB dq, prive, -1: DestroyCaret
 oldLCTCB dq, prive, 0

        Exit Do
End If
     End If
     End If
     ElseIf a$ = vbCr Then
     a$ = Left$(endchars, 1)
     End If
    If Asc(a$) = 27 And escok Then
        
      LCTCB dq, prive, -1: DestroyCaret
 oldLCTCB dq, prive, 0
    s$ = vbNullString
    'If ExTarget Then End

    Exit Do
ElseIf Asc(a$) = 27 Then
a$ = Chr$(0)
End If
If a$ = Chr(8) Then
DE$ = " "
    If Len(s$) > 0 Then
    ExcludeOne s$

             LCTCB dq, prive, -1: DestroyCaret
            oldLCTCB dq, prive, 0

        
        .curpos = .curpos - 1
        If .curpos < 0 Then
            .curpos = .mx - 1: .currow = .currow - 1

            If .currow < .mysplit Then
                ScrollDownNew dq, prive
                PlainBaSket dq, prive, Right$(Prompt$ & s$, .mx - 1), , , 0
                DE$ = vbNullString
            End If
        End If

       LCTbasketCur dq, prive
        dX = .curpos
        dY = .currow
       PlainBaSket dq, prive, DE$, , , 0
       .curpos = dX
       .currow = dY
         
         
            oldLCTCB dq, prive, 0
            
    End If
End If
If safe$ <> "" Then
        a$ = 65
End If
If AscW(a$) > 31 And (RealLen(s$) < m& Or RealLen(a$, True) = 0) Then
If RealLen(a$, True) = 0 Then
If Asc(a$) = 63 And s$ <> "" Then
s$ = s$ & a$: a$ = s$: ExcludeOne s$: a$ = Mid$(a$, Len(s$) + 1)
s$ = s$ + a$
MKEY$ = vbNullString
'UINK = VbNullString
safe$ = a$
INK = Chr$(8)
Else
If s$ = vbNullString Then a$ = " "
GoTo cont12345
End If
Else
cont12345:
    If InStr(excludechars, a$) > 0 Then

    Else
            If checknumber Then
                    fr1 = 1
                    If (s$ = vbNullString And a$ = "-") Or IsNumberQuery(s$ + a$, fr1, p, fr2) Then
                            If fr2 - 1 = RealLen(s$) + 1 Or (s$ = vbNullString And a$ = "-") Then
   If ShowCaret(dq.hwnd) <> 0 Then DestroyCaret
                If a$ = "." Then
                If Not NoUseDec Then
                    If OverideDec Then
                    PlainBaSket dq, prive, NowDec$, , , 0
                    Else
                    PlainBaSket dq, prive, ".", , , 0
                    End If
                Else
                    PlainBaSket dq, prive, QueryDecString, , , 0
                End If
                Else
                   PlainBaSket dq, prive, a$, , , 0
                   End If
                   s$ = s$ & a$
                 
              oldLCTCB dq, prive, 0
                  LCTCB dq, prive, 0
GdiFlush
                            End If
                    
                    End If
            Else
            If ShowCaret(dq.hwnd) <> 0 Then DestroyCaret
                   If safe$ <> "" Then
        a$ = safe$: safe$ = vbNullString
End If
 If InStr(endchars, a$) = 0 Then PlainBaSket dq, prive, a$, , , 0: s$ = s$ & a$
              If .curpos >= .mx Then
                                .curpos = 0
                                .currow = .currow + 1
                            End If
              oldLCTCB dq, prive, 0
                  LCTCB dq, prive, 0
                  GdiFlush
                
            End If
    End If
End If
If InStr(endchars, a$) > 0 Then
    If a$ >= " " Then
                     PlainBaSket dq, prive, a$, , , 0
              
      LCTCB dq, prive, -1: DestroyCaret
                                GdiFlush
                                End If
QUERY = a$
Exit Do
End If
 .pageframe = 0
 End If
End If
If Not QRY Then
      LCTCB dq, prive, -1: DestroyCaret
 oldLCTCB dq, prive, 0
Exit Do
''HideCaret dq.hWnd:


End If
Loop


 
If Not QRY Then s$ = vbNullString
dq.FontTransparent = True
QRY = False

Call mouse

If s$ <> "" And USELIST Then
q1 = InStr(QUERYLIST, Chr$(13) + s$ & Chr$(13))
If q1 = 1 Then ' same place
ElseIf q1 > 1 Then ' reorder
sp$ = Mid$(QUERYLIST, q1 + RealLen(s$) + 1)
QUERYLIST = Chr$(13) + s$ & Mid$(QUERYLIST, 1, q1 - 1) + sp$
Else ' insert
QUERYLIST = Chr$(13) + s$ & QUERYLIST
End If
LASTQUERYLIST = 2
End If
End With
contqueryhere:
If TaskMaster Is Nothing Then Exit Function
If TaskMaster.QueueCount > 0 Then TaskMaster.RestEnd
players(GetCode(dq)) = prive
Set dq = Nothing
TaskMaster.RestEnd1

End Function


Public Sub GetXYb(dd As Object, mb As basket, x As Long, y As Long)
With mb
If dd.CurrentY Mod .Yt <= dv15 Then
y = (dd.CurrentY) \ .Yt
Else
y = (dd.CurrentY - .uMineLineSpace) \ .Yt
End If
x = dd.CurrentX \ .Xt

''
End With
End Sub
Public Sub GetXYb2(dd As Object, mb As basket, x As Long, y As Long)
With mb
x = dd.CurrentX \ .Xt
y = Int((dd.CurrentY / .Yt) + 0.5)
End With
End Sub
Sub Gradient(TheObject As Object, ByVal F&, ByVal t&, ByVal xx1&, ByVal xx2&, ByVal yy1&, ByVal yy2&, ByVal hor As Boolean, ByVal all As Boolean)
    Dim Redval&, Greenval&, Blueval&
    Dim r1&, g1&, b1&, sr&, SG&, sb&
    F& = F& Mod &H1000000
    t& = t& Mod &H1000000
    Redval& = F& And &H10000FF
    Greenval& = (F& And &H100FF00) / &H100
    Blueval& = (F& And &HFF0000) / &H10000
    r1& = t& And &H10000FF
    g1& = (t& And &H100FF00) / &H100
    b1& = (t& And &HFF0000) / &H10000
    sr& = (r1& - Redval&) * 1000 / 127
    SG& = (g1& - Greenval&) * 1000 / 127
    sb& = (b1& - Blueval&) * 1000 / 127
    Redval& = Redval& * 1000
    
    Greenval& = Greenval& * 1000
    Blueval& = Blueval& * 1000
    Dim Step&, Reps&, FillTop As Single, FillLeft As Single, FillRight As Single, FillBottom As Single
    If hor Then
    yy2& = TheObject.Height - yy2&
    If all Then
    Step = ((yy2& - yy1&) / 127)
    Else
    Step = (TheObject.Height / 127)
    End If
    If all Then
    FillTop = yy1&
    Else
    FillTop = 0
    End If
    FillLeft = xx1&
    FillRight = TheObject.Width - xx2&
    FillBottom = FillTop + Step * 2
    Else ' vertical
    
        xx2& = TheObject.Width - xx2&
    If all Then
    Step = ((xx2& - xx1&) / 127)
    Else
    Step = (TheObject.Width / 127)
    End If
    If all Then
    FillLeft = xx1&
    Else
    FillLeft = 0
    End If
    FillTop = yy1&
    FillBottom = TheObject.Height - yy2&
    FillRight = FillLeft + Step * 2
    
    End If
    For Reps = 1 To 127
    If hor Then
        If FillTop <= yy2& And FillBottom >= yy1& Then
        TheObject.Line (FillLeft, RMAX(FillTop, yy1&))-(FillRight, RMIN(FillBottom, yy2&)), rgb(Redval& / 1000, Greenval& / 1000, Blueval& / 1000), BF
        End If
        Redval& = Redval& + sr&
        Greenval& = Greenval& + SG&
        Blueval& = Blueval& + sb&
        FillTop = FillBottom
        FillBottom = FillTop + Step
    Else
        If FillLeft <= xx2& And FillRight >= xx1& Then
        TheObject.Line (RMAX(FillLeft, xx1&), FillTop)-(RMIN(FillRight, xx2&), FillBottom), rgb(Redval& / 1000, Greenval& / 1000, Blueval& / 1000), BF
        End If
        Redval& = Redval& + sr&
        Greenval& = Greenval& + SG&
        Blueval& = Blueval& + sb&
        FillLeft = FillRight
        FillRight = FillRight + Step
    End If
    Next
    
End Sub
Function mycolor(q)
If (cUlng(q) And &HFF000000) = &H80000000 Then
mycolor = GetSysColor(cUlng(q) And &HFF) And &HFFFFFF
Exit Function
End If

If q < 0 Or q > 15 Then

 mycolor = Abs(q) And &HFFFFFF
Else
mycolor = QBColor(q Mod 16)
End If
End Function




Sub ICOPY(d1 As Object, x1 As Long, y1 As Long, w As Long, h As Long)
Dim sv As Long
With players(GetCode(d1))
sv = BitBlt(d1.hDC, CLng(d1.ScaleX(x1, 1, 3)), CLng(d1.ScaleY(y1, 1, 3)), CLng(d1.ScaleX(w, 1, 3)), CLng(d1.ScaleY(h, 1, 3)), d1.hDC, CLng(d1.ScaleX(.XGRAPH, 1, 3)), CLng(d1.ScaleY(.YGRAPH, 1, 3)), SRCCOPY)
'sv = UpdateWindow(d1.hwnd)
End With
End Sub

Sub sHelp(Title$, doc$, x As Long, y As Long)
vH_title$ = Title$
vH_doc$ = doc$
vH_x = x
vH_y = y
End Sub

Sub vHelp(Optional ByVal bypassshow As Boolean = False)
Dim huedif As Long
Dim UAddPixelsTop As Long, monitor As Long

If abt Then
If vH_title$ = lastAboutHTitle Then Exit Sub
vH_title$ = lastAboutHTitle
vH_doc$ = LastAboutText
Else
If vH_title$ = vbNullString Then Exit Sub
End If
If bypassshow Then
monitor = FindMonitorFromMouse
Else
monitor = FindFormSScreen(Form4)
End If
If Not Form4.Visible Then Form4.Show , Form1: bypassshow = True

If bypassshow Then
myform Form4, ScrInfo(monitor).Width - vH_x * Helplastfactor + ScrInfo(monitor).Left, ScrInfo(monitor).Height - vH_y * Helplastfactor + ScrInfo(monitor).Top, vH_x * Helplastfactor, vH_y * Helplastfactor, True, Helplastfactor
Else
If Screen.Width <= Form4.Left - ScrInfo(monitor).Left Then
myform Form4, Screen.Width - vH_x * Helplastfactor + ScrInfo(monitor).Left, Form4.Top, vH_x * Helplastfactor, vH_y * Helplastfactor, True, Helplastfactor
Else
myform Form4, Form4.Left, Form4.Top, vH_x * Helplastfactor, vH_y * Helplastfactor, True, Helplastfactor
End If
End If
Form4.MoveMe

If Form1.Visible Then
If Form1.DIS.Visible Then
  ''  If Abs(Val(hueconvSpecial(mycolor(uintnew(&H80000018)))) - Val(hueconvSpecial(-Paper))) > Abs(Val(hueconvSpecial(mycolor(uintnew(&H80000003)))) - Val(hueconvSpecial(-Paper))) Then
  If Abs(hueconv(mycolor(uintnew(&H80000018))) - val(hueconv(players(0).Paper))) > 10 And Not Abs(lightconv(mycolor(uintnew(&H80000018))) - val(lightconv(players(0).Paper))) < 50 Then
    Form4.backcolor = &H80000018
    Form4.Label1.backcolor = &H80000018
    
    Else
    
    Form4.backcolor = &H80000003
    Form4.Label1.backcolor = &H80000003
    End If

Else
''If Abs(Val(hueconvSpecial(mycolor(&H80000018))) - Val(hueconvSpecial(Form1.BackColor))) > Abs(Val(hueconvSpecial(mycolor(&H80000003))) - Val(hueconvSpecial(Form1.BackColor))) Then
     If Abs(hueconv(mycolor(uintnew(&H80000018))) - val(hueconv(Form1.backcolor))) > 10 And Not Abs(lightconv(mycolor(uintnew(&H80000018))) - val(lightconv(Form1.backcolor))) < 50 Then

    Form4.backcolor = &H80000018
    Form4.Label1.backcolor = &H80000018
    Else
    
    Form4.backcolor = &H80000003
    Form4.Label1.backcolor = &H80000003
    End If
End If
End If
With Form4.Label1
.Visible = True
.enabled = False
.Text = vH_doc$
.SetRowColumn 1, 0
.EditDoc = False
.NoMark = True
If abt Then
.glistN.WordCharLeft = "["
.glistN.WordCharRight = "]"
.glistN.WordCharRightButIncluded = vbNullString
Else
.glistN.WordCharLeft = ConCat(":", "{", "}", "[", "]", ",", "(", ")", "!", ";", "=", ">", "<", "'", """", " ", "+", "-", "/", "*", "^")
.glistN.WordCharRight = ConCat(":", "{", "}", "[", "]", ",", ")", "!", ";", "=", ">", "<", "'", """", " ", "+", "-", "/", "*", "^")
.glistN.WordCharRightButIncluded = "("
End If
.enabled = True
.NewTitle vH_title$, (4 + UAddPixelsTop) * Helplastfactor
.glistN.ShowMe
End With


Form4.ZOrder
Form4.Label1.glistN.DragEnabled = Not abt
If exWnd = 0 Then If Form1.Visible Then Form1.SetFocus
End Sub

Function FileNameType(extension As String) As String
Dim i As Long, fs, b
 strTemp = String(200, Chr$(0))
    'Get
    GetTempPath 200, StrPtr(strTemp)
    strTemp = LONGNAME(mylcasefILE(Left$(strTemp, InStr(strTemp, Chr(0)) - 1)))
    If strTemp = vbNullString Then
     strTemp = mylcasefILE(Left$(strTemp, InStr(strTemp, Chr(0)) - 1))
     If Right$(strTemp, 1) <> "\" Then strTemp = strTemp & "\"
    End If
    
    i = FreeFile
    Open strTemp & "dummy." & extension For Output As i
    Print #i, "test"
    Close #i
    Sleep 10
    Set fs = CreateObject("Scripting.FileSystemObject")
  Set b = fs.GetFile(strTemp & "dummy." & extension)
    FileNameType = b.Type
    KillFile strTemp & "dummy." & extension
End Function
Function mylcasefILE(ByVal a$) As String
If a$ = vbNullString Then Exit Function
If casesensitive Then
' no case change
mylcasefILE = a$
Else
 mylcasefILE = LCase(a$)
 End If

End Function

Function myUcase(ByVal a$, Optional convert As Boolean = False) As String
Dim i As Long
If a$ = vbNullString Then Exit Function
 If AscW(a$) > 255 Or convert Then
 For i = 1 To Len(a$)
 Select Case AscW(Mid$(a$, i, 1))
Case 902
Mid$(a$, i, 1) = ChrW(913)
Case 904
Mid$(a$, i, 1) = ChrW(917)
Case 906
Mid$(a$, i, 1) = ChrW(921)
Case 912
Mid$(a$, i, 1) = ChrW(921)
Case 905
Mid$(a$, i, 1) = ChrW(919)
Case 908
Mid$(a$, i, 1) = ChrW(927)
Case 911
Mid$(a$, i, 1) = ChrW(937)
Case 910
Mid$(a$, i, 1) = ChrW(933)
Case 940
Mid$(a$, i, 1) = ChrW(913)
Case 941
Mid$(a$, i, 1) = ChrW(917)
Case 943
Mid$(a$, i, 1) = ChrW(921)
Case 942
Mid$(a$, i, 1) = ChrW(919)
Case 972
Mid$(a$, i, 1) = ChrW(927)
Case 974
Mid$(a$, i, 1) = ChrW(937)
Case 973
Mid$(a$, i, 1) = ChrW(933)
Case 962
Mid$(a$, i, 1) = ChrW(931)
End Select
Next i
End If
myUcase = UCase(a$)
End Function

Function myLcase(ByVal a$) As String
If a$ = vbNullString Then Exit Function
a$ = Trim$(LCase(a$))
If a$ = vbNullString Then Exit Function
 If AscW(a$) > 255 Then
a$ = a$ & Chr(0)
' Here are greek letters for proper case conversion
a$ = Replace(a$, "�" & Chr(0), "�")
a$ = Replace(a$, Chr(0), "")
a$ = Replace(a$, "� ", "� ")
a$ = Replace(a$, "�$", "�$")
a$ = Replace(a$, "�&", "�&")
a$ = Replace(a$, "�.", "�.")
a$ = Replace(a$, "�(", "�(")
a$ = Replace(a$, "�_", "�_")
a$ = Replace(a$, "�/", "�/")
a$ = Replace(a$, "�\", "�\")
a$ = Replace(a$, "�-", "�-")
a$ = Replace(a$, "�+", "�+")
a$ = Replace(a$, "�*", "�*")
a$ = Replace(a$, "�" & vbCr, "�" & vbCr)
a$ = Replace(a$, "�" & vbLf, "�" & vbLf)
End If

myLcase = a$
End Function
Function MesTitle$()
On Error Resume Next
If ttl Then
If Form1.Caption = vbNullString Then
If here$ = vbNullString Then
MesTitle$ = "M2000"
' IDE
Else
If LASTPROG$ <> "" Then
MesTitle$ = ExtractNameOnly(LASTPROG$)
Else
MesTitle$ = "M2000"
End If
End If
Else
MesTitle$ = Form1.Caption
End If
Else
If Typename$(Screen.ActiveForm) = "GuiM2000" Then
MesTitle$ = Screen.ActiveForm.Title
Else
If here$ = vbNullString Or LASTPROG$ = vbNullString Then
MesTitle$ = "M2000"
Else
MesTitle$ = ExtractNameOnly(LASTPROG$) & " " & here$
End If
End If
End If
End Function
Public Function holdcontrol(wh As Object, mb As basket) As Long
Dim x1 As Long, y1 As Long
With mb
If .pageframe = 0 Then
''GetXYb wh, mb, X1, y1
If .mysplit > 0 Then .pageframe = (.My - .mysplit) * 4 / 5 Else .pageframe = Fix(.My * 4 / 5)
If .pageframe < 1 Then .pageframe = 1
.basicpageframe = .pageframe
holdcontrol = .pageframe
Else
holdcontrol = .basicpageframe
End If
End With
End Function
Public Sub HoldReset(col As Long, mb As basket)
With mb
.basicpageframe = col
If .basicpageframe <= 0 Then .basicpageframe = .pageframe
End With
End Sub
Public Sub gsb_file(Optional assoc As Boolean = True)
   Dim cd As String
     cd = App.path
        AddDirSep cd

        If assoc Then
          associate ".gsb", "M2000 Ver" & Str$(VerMajor) & "." & CStr(VerMinor \ 100) & " User Module", cd & "M2000.EXE"
        Else
      deassociate ".gsb", "M2000 Ver" & Str$(VerMajor) & "." & CStr(VerMinor \ 100) & " User Module", cd & "M2000.EXE"
   End If
End Sub
Public Sub Switches(s$, Optional fornow As Boolean = False)
Dim cc As cRegistry
Set cc = New cRegistry
cc.Temp = fornow
cc.ClassKey = HKEY_CURRENT_USER
    cc.SectionKey = basickey
Dim d$, w$, p As Long, b As Long
If s$ <> "" Then
's$ = mylcasefILE(s$)
    Do While FastSymbol(s$, "-")
            If IsLabel(basestack1, s$, d$) > 0 Then
            d$ = UCase(d$)
            If d$ = "TEST" Then
                STq = False
                STEXIT = False
                STbyST = True
                Form2.Show , Form1
                Form2.Label1(0) = vbNullString
                Form2.Label1(1) = vbNullString
                Form2.Label1(2) = vbNullString
                 TestShowSub = vbNullString
 TestShowStart = 0
   
                stackshow basestack1
                Form1.Show , Form5
                If Form3.Visible Then Form3.skiptimer = True: Form3.WindowState = 0
                trace = True
            ElseIf d$ = "NORUN" Then
                If ttl Then Form3.WindowState = vbNormal Else Form1.Show , Form5
                NORUN1 = True
            ElseIf d$ = "FONT" Then
            ' + LOAD NEW
                cc.ValueKey = "FONT"
                    cc.ValueType = REG_SZ
                 ''   LoadFont (mcd & "TT6492M_.TTF")
                 ' LoadFont (mcd & "TITUSCBZ.TTF")
                    
               cc.Value = "Monospac821Greek BT"
            ElseIf d$ = "SEC" Then
                    cc.ValueKey = "NEWSECURENAMES"
                cc.ValueType = REG_DWORD
                cc.Value = 0
                SecureNames = False
            ElseIf d$ = "DIV" Then
                cc.ValueKey = "DIV"
                    cc.ValueType = REG_DWORD
                  cc.Value = 0
                  UseIntDiv = False
            ElseIf d$ = "LINESPACE" Then
                cc.ValueKey = "LINESPACE"
                    cc.ValueType = REG_DWORD
               
                  cc.Value = 0
            ElseIf d$ = "SIZE" Then
                cc.ValueKey = "SIZE"
                    cc.ValueType = REG_DWORD
               
                  cc.Value = 15
                 
                 
            ElseIf d$ = "PEN" Then
                cc.ValueKey = "PEN"
                    cc.ValueType = REG_DWORD
                  cc.Value = 0
                      cc.ValueKey = "PAPER"
                    cc.ValueType = REG_DWORD
                  cc.Value = 7
                  
            ElseIf d$ = "BOLD" Then
             cc.ValueKey = "BOLD"
                   cc.ValueType = REG_DWORD
                 
                  cc.Value = 0
                 
            
            ElseIf d$ = "PAPER" Then
                cc.ValueKey = "PAPER"
                    cc.ValueType = REG_DWORD
                  cc.Value = 7
                   cc.ValueKey = "PEN"
                    cc.ValueType = REG_DWORD
                  cc.Value = 0
                   
            ElseIf d$ = "GREEK" Then
            cc.ValueKey = "COMMAND"
                 cc.ValueType = REG_SZ
                    cc.Value = "LATIN"
                    If fornow Then pagio$ = "LATIN"
            ElseIf d$ = "DARK" Then
            cc.ValueKey = "HTML"
                 cc.ValueType = REG_SZ
                    cc.Value = "BRIGHT"
            ElseIf d$ = "CASESENSITIVE" Then
            cc.ValueKey = "CASESENSITIVE"
             cc.ValueType = REG_SZ
                    cc.Value = "NO"
            If fornow Then
                casesensitive = False
            End If
            ElseIf d$ = "SBL" Then
            ShowBooleanAsString = False
            ElseIf d$ = "DIM" Then
            DimLikeBasic = False
            ElseIf d$ = "FOR" Then
           ' cc.ValueKey = "FOR-LIKE-BASIC"
           ' cc.ValueType = REG_DWORD
            'cc.Value = CLng(0)
            ForLikeBasic = False
            ElseIf d$ = "PRI" Then
            cc.ValueKey = "PRIORITY-OR"
            cc.ValueType = REG_DWORD
            cc.Value = CLng(0)  ' FALSE IS WRONG VALUE HERE
            priorityOr = False
            ElseIf d$ = "REG" Then
            gsb_file False
            ElseIf d$ = "DEC" Then
            cc.ValueKey = "DEC"
             cc.ValueType = REG_DWORD
                    cc.Value = CLng(0)
                    mNoUseDec = False
                    CheckDec
            ElseIf d$ = "TXT" Then
            cc.ValueKey = "TEXTCOMPARE"
             cc.ValueType = REG_DWORD
                    cc.Value = CLng(0)
                    mTextCompare = False
                    
            ElseIf d$ = "REC" Then
               cc.ValueKey = "FUNCDEEP"  ' RESET
             cc.ValueType = REG_DWORD
                    cc.Value = 300
                    If m_bInIDE Then funcdeep = 128
                    ' funcdeep not used - but functionality stay there for old dll's
                ClaimStack
                If findstack - 100000 > 0 Then
                    stacksize = findstack - 100000
                End If
            Else
            s$ = "-" & d$ & s$
            Exit Do
            End If
            Else
        Exit Do
        End If
        Sleep 2
    Loop
Do While FastSymbol(s$, "+")
If IsLabel(basestack1, s$, d$) > 0 Then
            d$ = UCase(d$)
    If d$ = "TEST" Then
            STq = False
            STEXIT = False
            STbyST = True
            Form2.Show , Form1
            Form2.Label1(0) = vbNullString
            Form2.Label1(1) = vbNullString
            Form2.Label1(2) = vbNullString
             TestShowSub = vbNullString
 TestShowStart = 0

            stackshow basestack1
            
            Form1.Show , Form5
            If Form3.Visible Then Form3.skiptimer = True: Form3.WindowState = 0
            trace = True
        ElseIf d$ = "REG" Then
        gsb_file
        ElseIf d$ = "FONT" Then
    ' + LOAD NEW
        cc.ValueKey = "FONT"
            cc.ValueType = REG_SZ
            If ISSTRINGA(s$, w$) Then cc.Value = w$
            ElseIf d$ = "SEC" Then
                    cc.ValueKey = "NEWSECURENAMES"
                cc.ValueType = REG_DWORD
                cc.Value = -1
                SecureNames = True
            ElseIf d$ = "DIV" Then
                cc.ValueKey = "DIV"
                    cc.ValueType = REG_DWORD
                  cc.Value = -1
                  UseIntDiv = True
        ElseIf d$ = "LINESPACE" Then
            cc.ValueKey = "LINESPACE"
                cc.ValueType = REG_DWORD
            If IsNumberLabel(s$, w$) Then If val(w$) >= 0 And val(w$) <= 60 * dv15 Then cc.Value = CLng(val(w$) * 2)
               
        ElseIf d$ = "SIZE" Then
            cc.ValueKey = "SIZE"
            cc.ValueType = REG_DWORD
            If IsNumberLabel(s$, w$) Then If val(w$) >= 8 And val(w$) <= 48 Then cc.Value = CLng(val(w$))
          
        ElseIf d$ = "PEN" Then
            cc.ValueKey = "PAPER"
            cc.ValueType = REG_DWORD
            p = cc.Value
            cc.ValueKey = "PEN"
            cc.ValueType = REG_DWORD
            If IsNumberLabel(s$, w$) Then
                If p = val(w$) Then p = 16 - p Else p = val(w$) Mod 16
                cc.Value = CLng(val(p))
            End If
        ElseIf d$ = "BOLD" Then
                cc.ValueKey = "BOLD"
                cc.ValueType = REG_DWORD
                If IsNumberLabel(s$, w$) Then cc.Value = CLng(val(w$) Mod 16)
                
        ElseIf d$ = "PAPER" Then
                cc.ValueKey = "PEN"
                cc.ValueType = REG_DWORD
                p = cc.Value
                cc.ValueKey = "PAPER"
                cc.ValueType = REG_DWORD
                If IsNumberLabel(s$, w$) Then
                If p = val(w$) Then p = 16 - p Else p = val(w$) Mod 16
                    cc.Value = CLng(val(p))
                End If
        ElseIf d$ = "GREEK" Then
                cc.ValueKey = "COMMAND"
                cc.ValueType = REG_SZ
                cc.Value = "GREEK"
                If fornow Then pagio$ = "GREEK"
        ElseIf d$ = "DARK" Then
            cc.ValueKey = "HTML"
                 cc.ValueType = REG_SZ
                    cc.Value = "DARK"
        ElseIf d$ = "CASESENSITIVE" Then
                cc.ValueKey = "CASESENSITIVE"
                cc.ValueType = REG_SZ
                cc.Value = "YES"
                If fornow Then
                     casesensitive = True
                End If
           ElseIf d$ = "SBL" Then
            ShowBooleanAsString = True
         ElseIf d$ = "DIM" Then
            DimLikeBasic = True
         ElseIf d$ = "FOR" Then
          '  cc.ValueKey = "FOR-LIKE-BASIC"
           ' cc.ValueType = REG_DWORD
           ' cc.Value = CLng(True)
             ForLikeBasic = True
        ElseIf d$ = "PRI" Then
        cc.ValueKey = "PRIORITY-OR"
                cc.ValueType = REG_DWORD
                cc.Value = CLng(True)
            priorityOr = True
            ElseIf d$ = "TXT" Then
            cc.ValueKey = "TEXTCOMPARE"
             cc.ValueType = REG_DWORD
                    cc.Value = CLng(True)
                    mTextCompare = True
        ElseIf d$ = "DEC" Then
            cc.ValueKey = "DEC"
             cc.ValueType = REG_DWORD
                    cc.Value = CLng(True)
                    mNoUseDec = True
                    CheckDec
        ElseIf d$ = "REC" Then
               cc.ValueKey = "FUNCDEEP"  ' RESET
             cc.ValueType = REG_DWORD
             funcdeep = 3260
                    cc.Value = 3260 ' SET REVISION DEFAULT
        ClaimStack
                If findstack - 100000 > 0 Then
                    stacksize = findstack - 100000
                End If
        Else
            s$ = "+" & d$ & s$
            Exit Do
        End If
    Else
    Exit Do
    End If
Sleep 2
Loop

End If
End Sub
Function blockStringPOS(s$, pos As Long) As Boolean
Dim i As Long, j As Long, c As Long
Dim a1 As Boolean
c = Len(s$)
a1 = True
i = pos
If i > Len(s$) Then Exit Function
Do
Select Case AscW(Mid$(s$, i, 1))
Case 34
Do While i < c
i = i + 1
If AscW(Mid$(s$, i, 1)) = 34 Then Exit Do
'If Asc(Mid$(s$, i, 1)) = 34 Then If Asc(Mid$(s$, i - 1, 1)) <> 92 Then Exit Do
Loop
Case 123
j = j - 1
Case 125
j = j + 1: If j = 1 Then Exit Do
End Select
i = i + 1
Loop Until i > c
If j = 1 Then
blockStringPOS = True
pos = i
Else
pos = Len(s$)
End If

End Function
Function BlockParam2(s$, pos As Long) As Boolean
' need to be open
Dim i As Long, j As Long, ii As Long
j = 1
For i = pos To Len(s$)
Select Case AscW(Mid$(s$, i, 1))
Case 0
Exit For
Case 34
again:
ii = InStr(i + 1, s$, """")
If ii = 0 Then Exit Function
 i = ii
If Mid$(s$, ii - 1, 1) = "`" Then GoTo again

Case 40
j = j + 1
Case 41
j = j - 1
If j = 0 Then Exit For
Case 123
i = i + 1
If blockStringPOS(s$, i) Then
Else
i = 0
'' i = InStr(i + 1, s$, Chr$(125))
End If
If i = 0 Then Exit Function
End Select
Next i
If j = 0 Then pos = i: BlockParam2 = True
End Function
Public Function aheadstatus(a$, Optional srink As Boolean = True, Optional pos As Long = 1) As String 'ok
Dim b$, part$, w$, pos2 As Long, Level&

If a$ = vbNullString Then Exit Function
Dim v1 As Long
If pos = 0 Then pos = 1
Do While pos <= Len(a$)
    w$ = Mid$(a$, pos, 1)
    v1 = AscW(w$)
    If Abs(v1) > 7 Then
    If part$ = vbNullString And w$ = "0" Then
        If pos + 2 <= Len(a$) Then
            If LCase(Mid$(a$, pos, 2)) Like "0[x�]" Then
            'hexadecimal literal number....
                pos = pos + 2
                Do While pos <= Len(a$)
                If Not Mid$(a$, pos, 1) Like "[0-9a-fA-F]" Then Exit Do
                pos = pos + 1
                Loop
                b$ = b$ & "N"
                If pos <= Len(a$) Then
                    w$ = Mid$(a$, pos, 1)
                Else
                    Exit Do
                End If
            End If
        End If
    End If

    If w$ = """" Then
        If part$ <> "" Then
        b$ = b$ & part$
        End If
        part$ = "S"
        pos = pos + 1
        Do While pos <= Len(a$)
        If Mid$(a$, pos, 1) = """" Then Exit Do
    If AscW(Mid$(a$, pos, 1)) < 32 Then Exit Do
   
        pos = pos + 1
        Loop

    ElseIf w$ = Chr$(2) Then  ' packet string
        If part$ <> "" Then
        b$ = b$ & part$
        End If
        part$ = "S"
        '  UNPACKLNG(Mid$(a$, pos+1, 8)+10
        pos = pos + UNPACKLNG(Mid$(a$, pos + 1, 8)) + 8
        w$ = """"
   
    
    ElseIf w$ = "(" Then
        Level& = 0
again:
        If part$ <> "" Then
            ' after
            If part$ = "S" And Level& = 0 Then
            '
             If Mid$(a$, pos + 1, 1) = ")" Then pos = pos + 2: GoTo conthere
             
            End If
            ElseIf Right$(b$, 1) = "a" Then
            b$ = Left$(b$, Len(b$) - 1)
            part$ = vbNullString
            Else
            part$ = "N"
              
        End If
again22:
      pos = pos + 1

        If Not BlockParam2(a$, pos) Then Exit Do
        If Mid$(a$, pos + 1, 1) = "(" Then
        pos = pos + 1: GoTo again22
        End If
       If Mid$(a$, pos + 1, 1) <> "." And Mid$(a$, pos + 1, 2) <> "=>" Then
       b$ = b$ & part$
       End If
        part$ = vbNullString
        
    ElseIf w$ = "{" Then

         
    If part$ <> "" Then
        b$ = b$ & part$
        End If
        part$ = "S"
        
        
            If pos <= Len(a$) Then
        If Not blockStringAhead(a$, pos) Then Exit Do
        End If
      

    Else
        Select Case w$
        Case ","  ' bye bye
        Exit Do
        Case "%"
            If part$ = vbNullString Then
            End If
        Case "$"
            If part$ = vbNullString Then
                If b$ = vbNullString Then
                    part$ = "N"
                ElseIf Right$(b$, 1) = "o" Then
                    part$ = "N"
                Else
                    aheadstatus = b$
                    Exit Function
                End If
            ElseIf part$ = "N" Then
                    b$ = b$ & "Sa"
                    If Mid$(a$, pos + 1, 1) = "." Then pos = pos + 1
                    part$ = vbNullString
            End If
        Case "+", "-", "|"
                    b$ = b$ & part$
                    If b$ = vbNullString Then
                    Else
                    
                part$ = "o"
                End If
        Case "*", "/", "^"
            If part$ <> "o" Then
            b$ = b$ & part$
            End If
            part$ = "o"
        Case " ", ChrW(160)
            If part$ <> "" Then
            b$ = b$ & part$
            part$ = vbNullString
            Else
            'skip
            End If
        Case "0" To "9", "."
            If part$ = "N" Then
            If Len(a$) < pos Then
                If Mid$(a$, pos + 1, 1) Like "[&@#~]" Then pos = pos + 1
            End If
            
            ElseIf part$ = "S" Then
            
            Else
            
            b$ = b$ & part$
            part$ = "N"
            End If
        Case "&"
        If part$ = vbNullString Then
        part$ = "S"
        ElseIf part$ = "N" Then
        b$ = b$ + part$
        part$ = vbNullString
        Else
        b$ = part$
        part$ = "S"
        End If
        Case "e", "E", "�", "�"
            If part$ = "N" Then

            ElseIf part$ = "S" Then
            
            
            Else
            b$ = b$ & part$
            part$ = "N"
            End If
         Case ">", "<", "~"
            If Len(a$) >= pos + 1 Then
            If Mid$(a$, pos, 2) = Mid$(a$, pos, 1) Then
                b$ = b$ & part$
                If b$ = vbNullString Then
                        Else
                        
                    part$ = "o"
                    pos = pos + 1
                    End If
                ElseIf w$ = ">" And pos > 1 Then
                    If Mid$(a$, pos - 1, 2) = "->" Then ' "->"
                   If Right$(b$, 1) = "S" Then
                    b$ = b$ + part$
                    part$ = "N"
                    Else
                      '  part$ = vbNullString
                    End If
                        
                    End If
                End If
            End If
            GoTo there1
         Case "="
            If Mid$(a$, pos + 1, 1) = ">" Then
                pos = pos + 2
                GoTo conthere
                End If
there1:
                If b$ & part$ <> "" Then
               
                w$ = Replace(b$ & part$, "a", "")
            part$ = vbNullString
               If srink Then
                  Do
                b$ = w$
                w$ = Replace(b$, "NN", "N")
                Loop While w$ <> b$
                         Do
                        b$ = w$
                          w$ = Replace(b$, "SlS", "N")
                          Loop While w$ <> b$
                            Do
                          b$ = w$
                          w$ = Replace(b$, "NlN", "N")
                          Loop While w$ <> b$
    
                Do
                b$ = w$
                w$ = Replace(b$, "NoN", "N")
                Loop While w$ <> b$
                
                Do
                b$ = w$
                w$ = Replace(b$, "SoS", "S")
                Loop While w$ <> b$
                Else
              b$ = w$
               End If
               
                If Left$(b$, Len(b$) - 1) <> "l" Then part$ = "l"
                Else
                Exit Do
                End If
        
        Case ")", "}", Is < " ", ":", ";", "'", "\"
        Exit Do
        Case Else
        If part$ = "N" Then
        ElseIf part$ = "S" Then
        Else
        
     b$ = b$ & part$
     part$ = "N"

            End If
        End Select
        End If
End If
        pos = pos + 1
        
conthere:
  
Loop

    w$ = Replace(b$ & part$, "a", "")
    
    b$ = w$
If srink Then
         Do
  b$ = w$

    w$ = Replace(b$, "SlS", "N")
    Loop While w$ <> b$
      Do
    b$ = w$
    w$ = Replace(b$, "NlN", "N")
    Loop While w$ <> b$
    
    Do
    b$ = w$
    w$ = Replace(b$, "NoN", "N")
    Loop While w$ <> b$
    
    Do
    b$ = w$
    w$ = Replace(b$, "SoS", "S")
    Loop While w$ <> b$
End If
   
   
   
   


    aheadstatus = b$




End Function

Function blockStringAhead(s$, pos1 As Long) As Long
Dim i As Long, j As Long, c As Long
Dim a1 As Boolean
c = Len(s$)
a1 = True
i = pos1
If i > c Then blockStringAhead = c: Exit Function
Do

Select Case AscW(Mid$(s$, i, 1))
Case 34
Do While i < c
i = i + 1
If AscW(Mid$(s$, i, 1)) = 34 Then Exit Do
'If Asc(Mid$(s$, i, 1)) = 34 Then If Asc(Mid$(s$, i - 1, 1)) <> 92 Then Exit Do
Loop
Case 123
j = j - 1
Case 125
j = j + 1: If j = 0 Then Exit Do
End Select
i = i + 1
Loop Until i > c
If j = 0 Then
pos1 = i
blockStringAhead = True
Else
blockStringAhead = False
End If


End Function
Public Function CleanStr(sStr As String, noValidcharList As String) As String
Dim a$, i As Long '', ddt As Boolean
If noValidcharList <> "" Then
''If Len(sStr) > 20000 Then ddt = True
If Len(sStr) > 0 Then
For i = 1 To Len(sStr)
''If ddt Then If i Mod 321 = 0 Then Sleep 20
If InStr(noValidcharList, Mid$(sStr, i, 1)) = 0 Then a$ = a$ & Mid$(sStr, i, 1)

Next i
End If
Else
a$ = sStr
End If
CleanStr = a$
End Function
Public Sub ResCounter()
k1 = 0
End Sub

Public Function CheckStackObj(bstack As basetask, anything As Object, vvv() As Variant, Optional counter As Long) As Boolean
If TypeOf bstack.lastobj Is mHandler Then
        If bstack.lastobj.t1 <> 3 Then Exit Function
        counter = bstack.lastobj.index_cursor + 1
        Set anything = bstack.lastobj
        Set bstack.lastobj = Nothing
        If CheckDeepAny(anything, vvv()) Then CheckStackObj = True
End If
        
End Function
Sub myesc(b$)
MyErMacro b$, "Escape", "������� ���������"
End Sub
Sub wrongsizeOrposition(a$)
    MyErMacro a$, "Wrong Size-Position for reading buffer", "����� �������-����, ��� �������� ����������"
End Sub
Sub wrongweakref(a$)
MyErMacro a$, "Wrong weak reference", "����� ������ ��������"
End Sub
Sub negsqrt(a$)
MyErMacro a$, "negative or zero number", "��������� � ����� �� ����"
End Sub
Sub expecteddecimal(a$)
MyErMacro a$, "Expected decimal separator char", "�������� ��������� ����������� ���������"
End Sub
Sub wrongexprinstring(a$)
MyErMacro a$, "Wrong expression in string", "����� ���������� ������� ��� �������������"
End Sub
Sub unknownoffset(a$, s$)
MyErMacro a$, "Unknown Offset " & s$, "������� �������� " & s$
End Sub
Public Function MyDoEvents()
On Error GoTo there
If TaskMaster Is Nothing Then
DoEvents
Exit Function
ElseIf Not TaskMaster.Processing Then
DoEvents
Exit Function
Else
If TaskMaster.PlayMusic Then
                  TaskMaster.OnlyMusic = True
                      TaskMaster.TimerTick
                    TaskMaster.OnlyMusic = False
                 End If
        TaskMaster.StopProcess
         TaskMaster.TimerTick
         DoEvents
         TaskMaster.StartProcess
If TaskMaster Is Nothing Then Exit Function
End If
Exit Function
there:
If Not TaskMaster Is Nothing Then TaskMaster.RestEnd1
End Function
Public Function ContainsUTF16(ByRef Source() As Byte, Optional maxsearch As Long = -1) As Long
  Dim i As Long, lUBound As Long, lUBound2 As Long, lUBound3 As Long
  Dim CurByte As Byte, CurByte1 As Byte
  Dim CurBytes As Long, CurBytes1 As Long
    lUBound = UBound(Source)
    If lUBound > 4 Then
    CurByte = Source(0)
    CurByte1 = Source(1)
    If maxsearch = -1 Then
    maxsearch = lUBound - 1
    ElseIf maxsearch < 8 Or maxsearch > lUBound - 1 Then
    maxsearch = lUBound - 1
    End If
    
    
    
    For i = 2 To maxsearch Step 2
        If CurByte1 = 0 And CurByte < 31 Then CurBytes1 = CurBytes1 + 1
        If CurByte = 0 And CurByte1 < 31 Then CurBytes = CurBytes + 1
        If Source(i) = CurByte Then
            CurBytes = CurBytes + 1
        Else
            CurByte = Source(i)
        End If
        If Source(i + 1) = CurByte1 Then
            CurBytes1 = CurBytes1 + 1
        Else
            CurByte1 = Source(i + 1)
        End If
        
    Next i
    End If
    If CurBytes1 = CurBytes And CurBytes1 * 3 >= lUBound Then
    ContainsUTF16 = 0
    Else
    If CurBytes1 * 3 >= lUBound Then
    ContainsUTF16 = 1
    ElseIf CurBytes * 3 >= lUBound Then
    ContainsUTF16 = 2
    Else
    ContainsUTF16 = 0
    End If
    End If
End Function
Public Function ContainsUTF8(ByRef Source() As Byte) As Boolean
  Dim i As Long, lUBound As Long, lUBound2 As Long, lUBound3 As Long
  Dim CurByte As Byte
    lUBound = UBound(Source)
    lUBound2 = lUBound - 2
    lUBound3 = lUBound - 3
    If lUBound > 2 Then
    
    For i = 0 To lUBound - 1
      CurByte = Source(i)
        If (CurByte And &HE0) = &HC0 Then
        If (Source(i + 1) And &HC0) = &H80 Then
            ContainsUTF8 = ContainsUTF8 Or True
             i = i + 1
             Else
                ContainsUTF8 = False
                Exit For
            End If
        

        ElseIf (CurByte And &HF0) = &HE0 Then
        ' 2 bytes
        If (Source(i + 1) And &HC0) = &H80 Then
            i = i + 1
            If i < lUBound2 Then
            If (Source(i + 1) And &HC0) = &H80 Then
                ContainsUTF8 = ContainsUTF8 Or True
                i = i + 1
            Else
                ContainsUTF8 = False
                Exit For
            End If
                Else
                ContainsUTF8 = False
                Exit For
            End If
        Else
            ContainsUTF8 = False
            Exit For
        End If
        ElseIf (CurByte And &HF8) = &HF0 Then
        ' 2 bytes
        If (Source(i + 1) And &HC0) = &H80 Then
            i = i + 1
            If i < lUBound2 Then
               If (Source(i + 1) And &HC0) = &H80 Then
                    ContainsUTF8 = ContainsUTF8 Or True
                    i = i + 1
                    If i < lUBound3 Then
                       If (Source(i + 1) And &HC0) = &H80 Then
                            ContainsUTF8 = ContainsUTF8 Or True
                            i = i + 1
                        Else
                            ContainsUTF8 = False
                            Exit For
                        End If
                        
                    Else
                        ContainsUTF8 = False
                        Exit For
                    End If
                Else
                    ContainsUTF8 = False
                    Exit For
                End If
                
            Else
                ContainsUTF8 = False
                Exit For
            End If
        Else
            ContainsUTF8 = False
            Exit For
        End If
        
        
        End If
        
    Next i
    End If
    

End Function
Function ReadUnicodeOrANSI(FileName As String, Optional ByVal EnsureWinLFs As Boolean, Optional feedback As Long) As String
Dim i&, FNr&, BLen&, WChars&, BOM As Integer, BTmp As Byte, b() As Byte
Dim mLof As Long, nobom As Long
nobom = 1
' code from Schmidt, member of vbforums
If FileName = vbNullString Then Exit Function
On Error Resume Next
If GetDosPath(FileName) = vbNullString Then MissFile: Exit Function
 On Error GoTo ErrHandler
  BLen = FileLen(GetDosPath(FileName))
'  If Err.Number = 53 Then missfile: Exit Function
 
  If BLen = 0 Then Exit Function
  
  FNr = FreeFile
  Open GetDosPath(FileName) For Binary Access Read As FNr
      Get FNr, , BOM
    Select Case BOM
      Case &HFEFF, &HFFFE 'one of the two possible 16 Bit BOMs
        If BLen >= 3 Then
          ReDim b(0 To BLen - 3): Get FNr, 3, b 'read the Bytes
utf16conthere:
          feedback = 0
          If BOM = &HFFFE Then 'big endian, so lets swap the byte-pairs
          feedback = 1
            For i = 0 To UBound(b) Step 2
              BTmp = b(i): b(i) = b(i + 1): b(i + 1) = BTmp
            Next
          End If
          ReadUnicodeOrANSI = b
        End If
      Case &HBBEF 'the start of a potential UTF8-BOM
        Get FNr, , BTmp
        If BTmp = &HBF Then 'it's indeed the UTF8-BOM
        feedback = 2
          If BLen >= 4 Then
            ReDim b(0 To BLen - 4): Get FNr, 4, b 'read the Bytes
            WChars = MultiByteToWideChar(65001, 0, b(0), BLen - 3, 0, 0)
            ReadUnicodeOrANSI = Space$(WChars)
            MultiByteToWideChar 65001, 0, b(0), BLen - 3, StrPtr(ReadUnicodeOrANSI), WChars
          End If
        Else 'not an UTF8-BOM, so read the whole Text as ANSI
        feedback = 3
          ReadUnicodeOrANSI = Space$(BLen)
          Get FNr, 1, ReadUnicodeOrANSI
        End If
        
      Case Else 'no BOM was detected, so read the whole Text as ANSI
        feedback = 3
       mLof = LOF(FNr)
       Dim buf() As Byte
       If mLof > 1000 Then
       ReDim buf(1000)
       Else
       ReDim buf(mLof)
       End If
       Get FNr, 1, buf()
       Seek FNr, 1
      If ContainsUTF8(buf()) Then 'maybe is utf-8
      feedback = 2
      nobom = -1
        ReDim b(0 To BLen - 1): Get FNr, 1, b
            WChars = MultiByteToWideChar(65001, 0, b(0), BLen, 0, 0)
            ReadUnicodeOrANSI = Space$(WChars)
            MultiByteToWideChar 65001, 0, b(0), BLen, StrPtr(ReadUnicodeOrANSI), WChars
        Else
        ReadUnicodeOrANSI = Space$(BLen)
        Get FNr, 1, ReadUnicodeOrANSI
        End If
            Select Case ContainsUTF16(buf())
        Case 1
            nobom = -1
            BOM = &HFEFF
            ReDim b(0 To BLen - 1): Get FNr, 1, b 'read the Bytes
            GoTo utf16conthere
        Case 2
            nobom = -1
            BOM = &HFEFF
            ReDim b(0 To BLen - 1): Get FNr, 1, b 'read the Bytes
            GoTo utf16conthere
        End Select

    End Select
    
    If InStr(ReadUnicodeOrANSI, vbCrLf) = 0 Then
      If InStr(ReadUnicodeOrANSI, vbLf) Then
      feedback = feedback + 10
   If EnsureWinLFs Then ReadUnicodeOrANSI = Replace(ReadUnicodeOrANSI, vbLf, vbCrLf)
      ElseIf InStr(ReadUnicodeOrANSI, vbCr) Then
      feedback = feedback + 20
      
    If EnsureWinLFs Then ReadUnicodeOrANSI = Replace(ReadUnicodeOrANSI, vbCr, vbCrLf)
      End If
    End If
    feedback = nobom * feedback
ErrHandler:
If FNr Then Close FNr
If Err Then
'MyEr Err.Description, Err.Description
Err.Raise Err.Number, Err.Source & ".ReadUnicodeOrANSI", Err.Description
End If
End Function

Public Function SaveUnicode(ByVal FileName As String, ByVal buf As String, mode2save As Long, Optional Append As Boolean = False) As Boolean
' using doc as extension you can read it from word...with automatic conversion to unicode
' OVERWRITE ALWAYS
Dim w As Long, a() As Byte, F$, i As Long, bb As Byte, yesswap As Boolean
On Error GoTo t12345
If Not Append Then
If Not NeoUnicodeFile(FileName) Then Exit Function
Else
If Not CanKillFile(FileName$) Then Exit Function
End If
F$ = GetDosPath(FileName)
If Err.Number > 0 Or F$ = vbNullString Then Exit Function
w = FreeFile
MyDoEvents
Open F$ For Binary As w
' mode2save
' 0 is utf-le
If Append Then Seek #w, LOF(w) + 1
mode2save = mode2save Mod 10
If mode2save = 0 Then
a() = ChrW(&HFEFF)
Put #w, , a()

ElseIf mode2save = 1 Then
a() = ChrW(&HFFFE) ' big endian...need swap
If Not Append Then Put #w, , a()
yesswap = True
ElseIf Abs(mode2save) = 2 Then  'utf8
If mode2save > 0 And Not Append Then

        Put #w, , CByte(&HEF)
        Put #w, , CByte(&HBB)
        Put #w, , CByte(&HBF)
        End If
        Put #w, , Utf16toUtf8(buf)
        Close w
    SaveUnicode = True
        Exit Function
ElseIf mode2save = 3 Then ' ascii
Put #w, , buf
      Close w
    SaveUnicode = True
        Exit Function
End If

Dim maxmw As Long, iPos As Long
iPos = 1
maxmw = 32000 ' check it with maxmw 20 OR 1
If yesswap Then
For iPos = 1 To Len(buf) Step maxmw
a() = Mid$(buf, iPos, maxmw)
For i = 0 To UBound(a()) - 1 Step 2
bb = a(i): a(i) = a(i + 1): a(i + 1) = bb
Next i
Put #w, 3, a()
Next iPos
Else
For iPos = 1 To Len(buf) Step maxmw
a() = Mid$(buf, iPos, maxmw)
Put #w, , a()
Next iPos
End If
Close w
SaveUnicode = True
t12345:
End Function
Public Sub getUniString(F As Long, s As String)
Dim a() As Byte
a() = s
Get #F, , a()
s = a()
End Sub
Public Function getUniStringNoUTF8(F As Long, s As String) As Boolean
Dim a() As Byte
a() = s
Get #F, , a()
If UBound(a) > 4 Then If Not ContainsUTF16(a(), 256) = 1 Then MyEr "No UTF16LE", "��� ����� UTF16LE": Exit Function
s = a()
getUniStringNoUTF8 = True
End Function
Public Sub putUniString(F As Long, s As String)
Dim a() As Byte
a() = s

Put #F, , a()
End Sub
Public Sub putANSIString(F As Long, s As String)
Put #F, , s
End Sub
Public Function getUniStringlINE(F As Long, s As String) As Boolean
' 2 bytes a time... stop to line end and advance to next line

Dim a() As Byte, s1 As String, ss As Long, lbreak As String
a = " "
On Error GoTo a11
Do While Not (LOF(F) < Seek(F))
Get #F, , a()

s1 = a()
If s1 <> vbCr And s1 <> vbLf Then
s = s + s1
'If Asc(s1) = 63 And (AscW(a()) <> 63 And AscW(a()) <> -257) Then
'If AscW(a()) < &H4000 Then Exit Function
''End If
Else
If Not (LOF(F) < Seek(F)) Then
ss = Seek(F)
lbreak = s1
Get #F, , a()
s1 = a()
If s1 <> vbCr And s1 <> vbLf Or lbreak = s1 Then
Seek #F, ss  ' restore it
End If
End If
Exit Do
End If
Loop
getUniStringlINE = True
a11:
End Function

Public Sub getAnsiStringlINE(F As Long, s As String)
' 2 bytes a time... stop to line end and advance to next line
Dim a As Byte, s1 As String, ss As Long, lbreak As String
'a = " "
On Error GoTo a11
Do While Not (LOF(F) < Seek(F))
Get #F, , a

s1 = Chr(a)
If s1 <> vbCr And s1 <> vbLf Then
s = s + s1
Else
If Not (LOF(F) < Seek(F)) Then
ss = Seek(F)
Get #F, , a
lbreak = s1
s1 = Chr(a)

If s1 <> vbCr And s1 <> vbLf Or lbreak = s1 Then
Seek #F, ss  ' restore it
End If
End If
Exit Do
End If
Loop
'S = StrConv(S, vbUnicode)
a11:
End Sub
Public Sub getUniStringComma(F As Long, s As String, Optional nochar34 As Boolean)
' sring must be in quotes
' 2 bytes a time... stop to line end and advance to next line
' use numbers with . as decimal not ,
Dim a() As Byte, s1 As String, ss As Long, inside As Boolean
s = vbNullString

a = " "
On Error GoTo a1115

Do While Not (LOF(F) < Seek(F))
    Get #F, , a()
    s1 = a()
    If s1 <> " " Then
    If nochar34 Then s = s1: Exit Do
    If s1 = """" Then inside = True: Exit Do
    End If
Loop
' we throw the first
If Not nochar34 Then If s1 <> """" Then Exit Sub

Do While Not (LOF(F) < Seek(F))
    Get #F, , a()
    
    s1 = a()
    If s1 <> vbCr And s1 <> vbLf And nochar34 And Not s1 = inpcsvsep$ Then
        s = s + s1
    ElseIf s1 <> vbCr And s1 <> vbLf And s1 <> """" And Not nochar34 Then
        s = s + s1
    Else
        If nochar34 Then
        GoTo there
        ElseIf s1 = """" Then
            If s = vbNullString Then ' is the first we have empty string
                inside = False
            Else
            ' look if we have one  more
                If Not (LOF(F) < Seek(F)) Then
                    ss = Seek(F)
                    Get #F, , a()
                    If a(0) = 34 Then
                        s = s + Chr(34)
                        GoTo nn1
                    Else
                        Seek #F, ss
                    End If
                End If
            End If
            inside = False
            Do While Not (LOF(F) < Seek(F))
            Get #F, , a()
            s1 = a()
            
            If s1 = vbCr Or s1 = vbLf Or s1 = inpcsvsep$ Then Exit Do
            Loop
there:
            If s1 = inpcsvsep$ Then Exit Do
        End If
        If s1 <> inpcsvsep$ And (Not (LOF(F) < Seek(F))) And (Not inside) Then
            ss = Seek(F)
            Get #F, , a()
            s1 = a()
            If s1 <> vbCr And s1 <> vbLf Then Seek #F, ss             ' restore it
        End If
        If Not inside Then Exit Do Else s = s + s1
    End If
nn1:
Loop
a1115:
End Sub
Public Sub getAnsiStringComma(F As Long, s As String, Optional nochar34 As Boolean)
' sring must be in quotes
' 2 bytes a time... stop to line end and advance to next line
' use numbers with . as decimal not ,
Dim a As Byte, s1 As String, ss As Long, inside As Boolean
s = vbNullString

On Error GoTo a1111

Do While Not (LOF(F) < Seek(F))
Get #F, , a
s1 = Chr$(a)
If s1 <> " " Then
If nochar34 Then s = s1: Exit Do
If s1 = """" Then inside = True: Exit Do

End If
Loop
' we throw the first
If Not nochar34 Then If s1 <> """" Then Exit Sub

Do While Not (LOF(F) < Seek(F))
Get #F, , a

s1 = Chr$(a)
If s1 <> vbCr And s1 <> vbLf And nochar34 And Not s1 = inpcsvsep$ Then
    s = s + s1
ElseIf s1 <> vbCr And s1 <> vbLf And s1 <> """" And Not nochar34 Then
    s = s + s1
Else
If nochar34 Then
        GoTo there
        ElseIf s1 = """" Then
If s = vbNullString Then ' is the first we have empty string
inside = False
Else
' look if we have one  more
If Not (LOF(F) < Seek(F)) Then
ss = Seek(F)

Get #F, , a
If a = 34 Then
s = s + Chr(34)
GoTo nn1
Else
Seek #F, ss
End If
End If

End If
inside = False
Do While Not (LOF(F) < Seek(F))
Get #F, , a
s1 = Chr(a)

If s1 = vbCr Or s1 = vbLf Or s1 = inpcsvsep$ Then Exit Do

Loop
there:
If s1 = inpcsvsep$ Then Exit Do
End If
If s1 <> inpcsvsep$ And (Not (LOF(F) < Seek(F))) And (Not inside) Then
    ss = Seek(F)
    Get #F, , a
    s1 = Chr(a)
    If s1 <> vbCr And s1 <> vbLf Then
    Seek #F, ss  ' restore it
    End If
    End If
If Not inside Then Exit Do Else s = s + s1

End If
nn1:
Loop

a1111:
End Sub
Public Sub getUniRealComma(F As Long, s$)
' 2 bytes a time... stop to line end and advance to next line
' use numbers with . as decimal not ,
Dim a() As Byte, s1 As String, ss As Long
s$ = ""
a = " "
On Error GoTo a111
Do While Not LOF(F) < Seek(F)
Get #F, , a()

s1 = a()
If s1 <> vbCr And s1 <> vbLf And s1 <> inpcsvsep$ Then
s = s + s1
Else
If s1 <> inpcsvsep$ And Not (LOF(F) < Seek(F)) Then
    ss = Seek(F)
    Get #F, , a()
    s1 = a()
    If s1 <> vbCr And s1 <> vbLf Then
    Seek #F, ss  ' restore it
    End If
End If
Exit Do
End If
Loop
s$ = MyTrim$(s$)
If s$ = "" Then s$ = "0"
a111:


End Sub
Public Sub getAnsiRealComma(F As Long, s$)
' 2 bytes a time... stop to line end and advance to next line
' use numbers with . as decimal not ,
Dim a As Byte, s1 As String, ss As Long
s$ = ""


On Error GoTo a112
Do While Not LOF(F) < Seek(F)
Get #F, , a

s1 = Chr(a)
If s1 <> vbCr And s1 <> vbLf And s1 <> inpcsvsep$ Then
s = s + s1
Else
If s1 <> inpcsvsep$ And Not (LOF(F) < Seek(F)) Then
    ss = Seek(F)
    Get #F, , a
    s1 = Chr(a)
    If s1 <> vbCr And s1 <> vbLf Then
    Seek #F, ss  ' restore it
    End If
End If
Exit Do
End If
Loop
s$ = MyTrim$(s$)
If s$ = "" Then s$ = "0"
a112:


End Sub
Public Function RealLenOLD(s$, Optional checkone As Boolean = False) As Long
Dim a() As Byte, ctype As Long, s1$, i As Long, LL As Long, ii As Long
If IsWine Then
RealLenOLD = Len(s$)
Else
ctype = CT_CTYPE3
LL = Len(s$)
   If LL Then
      ReDim a(Len(s$) * 2 + 20)
      If GetStringTypeExW(&HB, ctype, StrPtr(s$), Len(s$), a(0)) <> 0 Then
      ii = 0
      For i = 1 To Len(s$) * 2 - 1 Step 2
      ii = ii + 1
      If a(i - 1) > 0 Then
      If a(i) = 0 Then
      If ii > 1 Then If a(i - 1) < 8 Then LL = LL - 1
      End If
      ElseIf a(i) = 0 Then
      LL = LL - 1
      End If
      
          Next i
      End If
   End If
RealLenOLD = LL
End If
End Function
Public Function RealLen(s$, Optional checkone As Boolean = False) As Long
Dim a() As Byte, a1() As Byte, s1$, i As Long, LL As Long, ii As Long, l$, LLL$
LL = Len(s$)
   If LL Then
      ReDim a(Len(s$) * 2 + 20), a1(Len(s$) * 2 + 20)
         If GetStringTypeExW(&HB, 1, StrPtr(s$), Len(s$), a(0)) <> 0 And GetStringTypeExW(&HB, 4, StrPtr(s$), Len(s$), a1(0)) <> 0 Then
         
ii = 0
      For i = 1 To Len(s$) * 2 - 1 Step 2
ii = ii + 1
       ' Debug.Print I, a(I - 1), a(I)
        If a(i - 1) = 0 Then
        If a(i) = 2 And a1(2) < 8 Then
        
                 If ii > 1 Then
                    s1$ = Mid$(s$, ii, 1)
                    
                    If (AscW(s1$) And &HFFFF0000) = &HFFFF0000 Then
                    Else
                    If l$ = s1$ Then
                        If LLL$ = vbNullString Then LL = LL + 1
                        LLL$ = l$
                    Else
                        l$ = Mid$(s$, ii, 1)
                        LL = LL - 1
                    End If
                    End If
                 Else
                 If checkone Then LL = LL - 1
                 End If
            
        Else
        LLL$ = vbNullString
        End If
       
        
        End If
           l$ = Mid$(s$, ii, 1)
          Next i
      End If
   End If
RealLen = LL
End Function
Public Function PopOne(s$) As String
Dim a() As Byte, ctype As Long, s1$, i As Long, LL As Long, mm As Long
ctype = CT_CTYPE3
Dim one As Boolean
LL = Len(s$)
mm = LL
   If LL Then
      ReDim a(Len(s$) * 2 + 20)
      If GetStringTypeExW(&HB, ctype, StrPtr(s$), Len(s$), a(0)) <> 0 Then
      For i = 1 To Len(s$) * 2 - 1 Step 2
      If a(i - 1) > 0 Then
            If a(i) = 0 Then
            
            If a(i - 1) < 8 Then LL = LL - 1
            Else
            If Not one Then Exit For
            
            End If
            Else
            If one Then Exit For
            one = Not one
            End If
      Next i
      End If
        LL = LL - 1
      mm = mm - LL
   End If
If LL < 0 Then
PopOne = s$
s$ = vbNullString
ElseIf mm > 0 Then
    PopOne = Left$(s$, mm)
    s$ = Right$(s$, LL)
End If

End Function
Public Sub ExcludeOne(s$)
Dim a() As Byte, ctype As Long, s1$, i As Long, LL As Long
LL = Len(s$)
ctype = CT_CTYPE3
   If LL > 1 Then
      ReDim a(Len(s$) * 2 + 20)
      If GetStringTypeExW(&HB, ctype, StrPtr(s$), -1, a(0)) <> 0 Then
      For i = LL * 2 - 1 To 1 Step -2
      If a(i) = 0 Then
      If a(i - 1) > 0 Then
      If a(i - 1) < 8 Then LL = LL - 1
      Else
      Exit For
      End If
      Else
      Exit For
      End If
          Next i
      End If
       LL = LL - 1
       If LL <= 0 Then
       s$ = vbNullString
       Else
       
        s$ = Left$(s$, LL)
        End If
      Else
      s$ = vbNullString
      
   End If
End Sub
Function Tcase(s$) As String
Dim a() As String, i As Long
If s$ = vbNullString Then Exit Function
a() = Split(s$, " ")
For i = 0 To UBound(a())
a(i) = myUcase(Left$(a(i), 1), True) + Mid$(myLcase(a(i)), 2)
Next i
If UBound(a()) > 0 Then
Tcase = Join(a(), " ")
Else
Tcase = a(0) ' myUcase(Left$(s$, 1), True) + Mid$(myLcase(s$), 2)
End If
End Function
Public Sub choosenext()
Dim catchit As Boolean
On Error Resume Next
If Not Screen.ActiveForm Is Nothing Then

    Dim x As Form
     For Each x In Forms
     If x.name = "Form1" Or x.name = "GuiM2000" Or x.name = "Form2" Or x.name = "Form4" Then
         If x.Visible And x.enabled Then
             If catchit Then x.SetFocus: Exit Sub
             If x.hwnd = GetForegroundWindow Then
             catchit = True
             End If
         End If
    End If
         
     Next x
     Set x = Nothing
     For Each x In Forms
     If x.name = "Form1" Or x.name = "GuiM2000" Or x.name = "Form2" Or x.name = "Form4" Then
         If x.Visible And x.enabled Then x.SetFocus: Exit Sub
             
             
         End If
     Next x
     Set x = Nothing
    End If

End Sub
Public Function CheckIsmArray(obj As Object, vv() As Variant) As Boolean
Dim oldobj As Object
If obj Is Nothing Then Exit Function
Set oldobj = obj

Dim kk As Long
again:
If kk > 20 Then Set obj = oldobj: Exit Function
If TypeOf obj Is mHandler Then
    If obj.t1 = 3 Then
        If obj.indirect >= 0 And obj.indirect <= var2used Then
                Set obj = vv(obj.indirect)
                kk = kk + 1
                GoTo again
        Else
                Set obj = obj.objref
        End If

    End If
    
End If
If Not obj Is Nothing Then
If TypeOf obj Is mArray Then If obj.Arr Then CheckIsmArray = True: Set oldobj = Nothing: Exit Function
End If
Set obj = oldobj
End Function
Public Function CheckIsmArrayOrStackOrCollection(obj As Object, vv() As Variant) As Boolean
Dim oldobj As Object
If obj Is Nothing Then Exit Function
Set oldobj = obj

Dim kk As Long
again:
If kk > 20 Then Set obj = oldobj: Exit Function
If TypeOf obj Is mHandler Then
    If obj.t1 <> 2 Then
        If obj.indirect >= 0 And obj.indirect <= var2used Then
                Set obj = vv(obj.indirect)
                kk = kk + 1
                GoTo again
        Else
                Set obj = obj.objref
        End If
   
    End If
    
End If
If Not obj Is Nothing Then
If TypeOf obj Is mArray Then If obj.Arr Then CheckIsmArrayOrStackOrCollection = True: Set oldobj = Nothing: Exit Function
If TypeOf obj Is mStiva Then CheckIsmArrayOrStackOrCollection = True: Set oldobj = Nothing: Exit Function
If TypeOf obj Is FastCollection Then CheckIsmArrayOrStackOrCollection = True: Set oldobj = Nothing: Exit Function
End If
Set obj = oldobj
End Function
Public Function CheckDeepAny(obj As Object, vv() As Variant) As Boolean
Dim oldobj As Object
If obj Is Nothing Then Exit Function
Set oldobj = obj

Dim kk As Long
again:
If kk > 20 Then Set obj = oldobj: Exit Function
If TypeOf obj Is mHandler Then
    If obj.t1 = 3 Then
        If obj.indirect >= 0 And obj.indirect <= var2used Then
                Set obj = vv(obj.indirect)
                kk = kk + 1
                GoTo again
        Else
                Set obj = obj.objref
        End If

    End If
    
End If
If Not obj Is Nothing Then Set oldobj = Nothing: CheckDeepAny = True: Exit Function
Set obj = oldobj
End Function
Public Function CheckLastHandler(obj As Object, vv() As Variant) As Boolean
Dim oldobj As Object, first As Object
If obj Is Nothing Then Exit Function
Set first = obj

Dim kk As Long
again:
If kk > 20 Then Set obj = first: Exit Function
If TypeOf obj Is mHandler Then
    'If obj.t1 = 3 Then
        If obj.indirect >= 0 And obj.indirect <= var2used Then
                Set oldobj = obj
                Set obj = vv(obj.indirect)
                kk = kk + 1
                GoTo again
        Else
                kk = kk + 1
                Set oldobj = obj
                Set obj = obj.objref
                GoTo again
        End If

    'End If
    
End If
If Not oldobj Is Nothing Then Set obj = oldobj: Set oldobj = Nothing: CheckLastHandler = True: Exit Function
Set obj = first
End Function
Public Function CheckLastHandlerOrIterator(obj As Object, vv() As Variant, lastindex As Long) As Boolean
Dim oldobj As Object, first As Object
If obj Is Nothing Then Exit Function
Set first = obj
lastindex = -1
Dim kk As Long
again:
If kk > 20 Then Set obj = first: Exit Function
If TypeOf obj Is mHandler Then
        If obj.UseIterator Then lastindex = obj.index_cursor
        If obj.indirect >= 0 And obj.indirect <= var2used Then
                Set oldobj = obj
                Set obj = vv(obj.indirect)
                kk = kk + 1
                GoTo again
        Else
                kk = kk + 1
                Set oldobj = obj
                Set obj = obj.objref
                GoTo again
        End If

End If
    

If Not oldobj Is Nothing Then Set obj = oldobj: Set oldobj = Nothing: CheckLastHandlerOrIterator = True: Exit Function
Set obj = first
End Function
Public Function IfierVal()
If LastErNum <> 0 Then LastErNum = 0: IfierVal = True
End Function
Public Sub OutOfLimit()
  MyEr "Out of limit", "����� �����"
End Sub
Public Sub stackproblem()
MyEr "Problem in return stack", "�������� ���� ���� ����������"
End Sub
Public Sub PlaceAcommaBefore()
MyEr "Place a comma before", "���� ��� ����� ����"
End Sub
Public Sub unknownid(b$, w$)
MyErMacro b$, "unknown identifier " & w$, "������� ������������� " & w$
End Sub
Public Sub MissCdib()
  MyEr "Missing IMAGE", "������ ������"
End Sub
Public Sub MissFile()
 MyEr "File not found", "��� ������� � ������"
End Sub
Public Sub BadObjectDecl()
  MyEr "Bad object declaration - use Clear Command for Gui Elements", "����� ������ ������������ - ������������� ������ ��� �� ���������� ����� �������� ��� �������� �������������"
End Sub
Public Sub AssigntoNothing()
  MyEr "Bad object declaration - use Declare command", "����� ������ ������������ - ������������� ��� �����"
End Sub
Public Sub Overflow()
 MyEr "Overflow", "�����������"
End Sub
Public Sub MissCdibStr()
  MyEr "Missing IMAGE in string", "������ ������ ��� �������������"
End Sub
Public Sub MissStackStr()
  MyEr "Missing string value from stack", "������ ������������� ��� �� ����"
End Sub
Public Sub WrongFileHandler()
MyEr "Wrong File Handler", "����� ��������� �������"
End Sub

Public Sub MissStackItem()
 MyEr "Missing item from stack", "������ ���� ��� �� ����"
End Sub
Public Sub MissStackNumber()
 MyEr "Missing number value from stack", "������ ������� ��� �� ����"
End Sub
Public Sub missNumber()
MyEr "Only number allowed", "���� ������� �����������"
End Sub
Public Sub MissNumExpr()
MyEr "Missing number expression", "������ ���������� ���������"
End Sub
Public Sub MissLicence()
MyEr "Missing Licence", "������ �����"
End Sub
Public Sub MissStringExpr()
MyEr "Missing string expression", "������ ������������� ���������"
End Sub
Public Sub NoCreateFile()
    MyEr "Can't create file", "��� ����� �� ������ ������"
End Sub
Public Sub BadFilename()
MyEr "Bad filename", "����� ��� ����� �������"
End Sub
Public Sub ReadOnly()
MyEr "Read Only", "���� ��� ��������"
End Sub
Public Sub MissDir()
MyEr "Missing directory name", "������ ����� �������"
End Sub
Public Sub MissType()
MyEr "Wrong data type", "����� ����� ����������"
End Sub

Public Sub BadPath()
MyEr "Bad Path name", "����� ��� ����� ������� (����)"
End Sub
Public Sub BadReBound()
MyEr "Can't commit a reference here", "��� ����� �� ������� ��� ��� �������"
End Sub
Public Sub oxiforPrinter()
MyEr "Not allowed this command for printer", "��� ����������� ���� � ������ ��� ��� ��������"
End Sub
Public Sub ResourceLimit()
MyEr "No more Graphic Resource for forms - 100 Max", "��� ��� ���� ���� ��� ������� �� ������ - 100 �������"
End Sub
Public Sub oxiforforms()
MyEr "Not allowed this command for forms", "��� ����������� ���� � ������ ��� ������"
End Sub
Public Sub SyntaxError()
If LastErName = vbNullString Then
MyEr "Syntax Error", "���������� �����"
Else
If LastErNum = 0 Then LastErNum = -1 ' general
LastErNum1 = LastErNum
End If
End Sub
Public Sub MissingnumVar()
MyEr "missing numeric variable", "������ ���������� ���������"
End Sub
Public Sub BadGraphic()
MyEr "Can't operate graphic", "��� ����� �� �������� �� �������"
End Sub
Public Sub SelectorInUse()
MyEr "File/Folder Selector in Use", "� ��������� �������/������� ����� �� �����"
End Sub
Public Sub MissingDoc()  ' this is for identifier or execute part
MyEr "missing document type variable", "������ ��������� ����� ��������"
End Sub
Public Sub MissingLabel()
MyEr "Missing label/Number line", "������ �������/������� �������"
End Sub
Public Sub MissFuncParammeterdOCVar(ar$)
MyEr "Not a Document variable " + ar$, "��� ����� ��������� ����� �������� " + ar$
End Sub
Public Sub MissingBlock()  ' this is for identifier or execute part
MyEr "missing block {} or string expression", "������ ������� �� {} � ������������� �������"
End Sub
Public Sub MissingCodeBlock()
MyEr "missing block {}", "������ ����� ������ �� {}"
End Sub
Public Sub MissingArray(w$)
MyEr "Can't find array " & w$ & ")", "��� ������ ������ " & w$ & ")"
End Sub
Public Sub ErrNum()
MyEr "Error in number", "����� ���� ������"
End Sub
Public Sub CantAssignValue()
MyEr "Can't assign value to constant", "��� ����� �� ���� ���� �� �������"
End Sub
Public Sub ExpectedVariable()
 MyEr "Expected variable", "�������� ���������"
End Sub

Public Sub Expected(w1$, w2$)
 MyEr "Expected object type " + w1$, "�������� ����������� ����� " + w2$
End Sub
Public Sub ExpectedCaseorElseorEnd2()
MyEr "Expected Case or Else or End Select", "�������� �� � ������ � ����� ��������"
End Sub
Public Sub ExpectedCaseorElseorEnd()
 MyEr "Expected Case or Else or End Select, for two or more commands use {}", "�������� �� � ������ � ����� ��������, ��� ��� � ������������ ������� ������������� { }"
End Sub
Public Sub ExpectedCommentsOnly()
 MyEr "Expected comments (using ' or \) or new line", "�������� ���������� (�� ' � \) � ������ ������"
End Sub

Public Sub ExpectedEndSelect()
 MyEr "Expected �nd Select", "�������� ����� ��������"
End Sub
Public Sub ExpectedEndSelect2()
 MyEr "Expected �nd Select, for two or more commands use {}", "�������� ����� ��������, ��� ��� � ������������ ������� ������������� { }"
End Sub
Public Sub LocaleAndGlobal()
MyEr "Global and local together;", "������ ��� ������ ����!"
End Sub
Public Sub UnknownProperty(w$)
MyEr "Unknown Property " & w$, "������� �������� " & w$
End Sub
Public Sub UnknownVariable(w$)
Dim i As Long
i = rinstr(w$, "." + ChrW(8191))
If i > 0 Then
i = rinstr(w$, ".")
MyEr "Unknown Variable " & Mid$(w$, i), "������� ��������� " & Mid$(w$, i)
Else
MyEr "Unknown Variable " & w$, "������� ��������� " & w$
End If
End Sub
Sub indexout(a$)
MyErMacro a$, "Index out of limits", "������� ����� �����"
End Sub

Sub wrongfilenumber(a$)
 MyErMacro a$, "not valid file number", "����� ������� �������"
End Sub
Public Sub WrongArgument(a$)
MyErMacro a$, Err.Description, "����� ������"
End Sub
Public Sub UnKnownWeak(w$)
 MyEr "Unknown Weak " & w$, "������� ����� " & w$
End Sub
Public Sub InternalEror()
MyEr "Internal error", "��������� �����"
End Sub
Sub NegativeIindex(a$)
MyErMacro a$, "negative index", "��������� ������"
End Sub
Sub joypader(a$, r)
MyErMacro a$, "Joypad number " & CStr(r) & " isn't ready", "�� ������� ����� " & CStr(r) & " ��� ����� ������"
End Sub
Sub noImage(a$)
MyErMacro a$, "�� image in string", "��� ������� ������ ��� �������������"
End Sub
Sub noImageInBuffer(a$)
MyErMacro a$, "No Image in Buffer", "��� ���� ������ � ���������"
End Sub

Sub WrongJoypadNumber(a$)
MyErMacro a$, "Joypad number 0 to 15", "������� ����� ��� 0 ��� 15"
End Sub
Sub CantFindArray(a$, s$)
MyErMacro a$, "Can't find array " & s$, "��� ������ ������ " & s$
End Sub
Sub CantReadDimension(a$, s$)
 MyErMacro a$, "Can't read dimension index from array " & s$, "��� ����� �� ������� ��� ������ ��������� ��� ������ " & s$

End Sub
Sub cantreadlib(a$)
MyErMacro a$, "Can't Read TypeLib", "��� ����� �� ������� ���� ������ ��� ����������"
End Sub
Public Sub NotArray()  ' this is for identifier or execute part
MyEr "Expected Array", "�������� ������"
End Sub
Public Sub NotExistArray()  ' this is for identifier or execute part
MyEr "Array not exist", "��� ������� ������� �������"
End Sub
Public Sub MissingGroup()  ' this is for identifier or execute part
MyEr "missing group type variable", "������ ��������� ����� ������"
End Sub
Public Sub MissingGroupExp()  ' this is for identifier or execute part
MyEr "missing group type expression", "������ ������� ����� ������"
End Sub
Public Sub BadGroupHandle()  ' this is for identifier or execute part
MyEr "group isn't variable", "� ����� ��� ����� ���������"
End Sub
Public Sub MissingDocRef()  ' this is for identifier or execute part
MyEr "invalid document pointer", "�� ������� ������� ��������"
End Sub
Public Sub MissingObjReturn()
MyEr "Missing Object", "��� ����� �����������"
End Sub
Public Sub NoNewLambda()
    MyEr "No New statement for lambda", "��� ������ ���� ��� �����"
End Sub
Public Sub ExpectedObj(nn$)
MyEr "Expected object type " + nn$, "�������� ����������� ����� " + nn$
End Sub
Public Sub MisOperatror(ss$)
MyEr "Group not support operator " + ss$, "� ����� ��� ����������� �� ������� " + ss$
End Sub
Public Sub CantReadFileTimeStap(a$)
MyErMacro a$, "Can't Read File TimeStamp", "��� ����� �� ������� ��� ������������ ��� �������"
End Sub

Public Sub ExpectedObjInline(nn$)
MyErMacro nn$, "Expected Object", "�������� �����������"
End Sub
Public Sub MissingObj()
MyEr "missing object type variable", "������ ��������� ����� ������������"
End Sub
Public Sub BadGetProp()
MyEr "Can't Get Property", "��� ����� �� ������� ���� ��� ��������"
End Sub
Public Sub BadLetProp()
MyEr "Can't Let Property", "��� ����� �� ����� ���� ��� ��������"
End Sub
Public Sub NoNumberAssign()
MyEr "Can't assign number to object", "��� ����� �� ���� ������ ��� �����������"
End Sub
Public Sub NoAssignThere()
MyEr "Use Return Object to change items", "������������� ��� ��������� ����������� ��� �� ����������� �����"
End Sub
Public Sub NoObjectpAssignTolong()
MyEr "Can't assign object to long", "��� ����� �� ���� ����������� ���� �����"
End Sub
Public Sub NoObjectAssign()
MyEr "Can't assign object", "��� ����� �� ���� �����������"
End Sub
Public Sub NoNewStatFor(w1$, w2$)
MyEr "No New statement for " + w1$, "��� ������ ���� ��� " + w2$
End Sub
Public Sub NoThatOperator(ss$)
    MyEr ss$ + " operator not allowed in group definition", " � �������� " + ss$ + " ��� ����������� �� ������ ������"
End Sub
Public Sub MissingObjRef()
MyEr "invalid object pointer", "�� ������� ������� ������������"
End Sub
Public Sub MissingStrVar()  ' this is for identifier or execute part
MyEr "missing string variable", "������ ������������� ���������"
End Sub
Public Sub NoSwap(nameOfvar$)
MyEr "Can't swap ", "��� ����� �� ������ ����� "
End Sub
Public Sub Nosuchvariable(nameOfvar$)
MyEr "No such variable " + nameOfvar$, "��� ������� ������ ��������� " + nameOfvar$
End Sub
Public Sub NoValueForVar(w$)
If LastErNum = 0 Then
MyEr "No value for variable " & w$, "����� ���� � ��������� " & w$
End If
End Sub
Public Sub NoReference()
   MyEr "No reference exist", "��� ������� �������"
End Sub
Public Sub NoCommandOrBlock()
MyEr "Expected in Select Case a Block or a Command", "�������� ���� ������� �� ��� ������ � ��� ����� �������)"
End Sub

Public Sub NoSecReF()
MyEr "No reference allowed - use new variable", "��� ������� ������� - ������������� ��� ���������"
End Sub
Public Sub MissSymbolMyEr(wht$)   ' not the macro one
MyEr "missing " & wht$, "������ " & wht$
End Sub
Public Sub BadCommand()
 MyEr "Command for supervisor rights", "������ ���� ��� ������"
End Sub
Public Sub NoClauseInThread()
MyEr "can't find ERASE or HOLD or RESTART or INTERVAL clause", "��� ����� �� ��� ��� ���� �� ����� � �� ����� � �� ������ � �� ����"
End Sub
Public Sub NoThisInThread()
MyEr "Clause This can't used outside a thread", "� ���� ���� ��� ������ �� �������������� ��� ��� ��� ����"
End Sub
Public Sub MisInterval()
MyEr "Expected number for interval, miliseconds", "�������� ������ ��� ������ �������� ����������� ��������� ������� (����� �� �������� �������������)"
End Sub
Public Sub NoRef2()
MyEr "No with reference in left side of assignment", "��� �� ������� ���� �������� �����"
End Sub
Public Sub WrongObject()
MyEr "Wrong object type", "����� ����������� �����"
End Sub
Public Sub GroupWrongUse()
MyEr "Something wrong with group", "���� ���� ������ �� ��� �����"
End Sub
Public Sub GroupCantSetValue()
    MyEr "Group can't set value", "� ����� ��� ������ �� ����� ����"
End Sub
Public Sub PropCantChange()
MyEr "Property can't change", "� �������� ��� ������ �� �������"
End Sub
Public Sub NeedAGroupFromExpression()
MyEr "Need a group from expression", "���������� ��� ����� ��� ��� �������"
End Sub
Public Sub NeedAGroupInRightExpression()
MyEr "Need a group from right expression", "���������� ��� ����� ��� ��� ����� �������"
End Sub
Public Sub NotAfter(a$)
MyErMacro a$, "not an expression after not", "��� ������� ��������� ����� ��� ���"
End Sub
Public Sub EmptyArray()
MyEr "Empty Array", "������ �������"
End Sub
Public Sub EmptyStack(a$)
 MyErMacro a$, "Stack is empty", "O ����� ����� ������"
End Sub
Public Sub StackTopNotArray(a$)
 MyErMacro a$, "Stack top isn't array", "� ������ ��� ����� ��� ����� �������"
End Sub

Public Sub StackTopNotGroup(a$)
MyErMacro a$, "Stack top isn't group", "� ������ ��� ����� ��� ����� �����"
End Sub
Public Sub StackTopNotNumber(a$)
MyErMacro a$, "Stack top isn't number", "� ������ ��� ����� ��� ����� �������"
End Sub
Public Sub NeedAnArray(a$)
MyErMacro a$, "Need an Array", "���������� ��� ������"
End Sub
Public Sub NoRef()
MyEr "No with reference (&)", "��� �� ������� (&)"
End Sub
Public Sub NoMoreDeep(deep As Variant)
MyEr "No more" + Str(deep) + " levels gosub allowed", "��� ������������ ���� ���" + Str(deep) + " ������� ��� ������ ��������"
End Sub
Public Sub CantFind(w$)
MyEr "Can't find " + w$ + " or type name", "��� ����� �� ��� �o " + w$ + " � ����� �����"
End Sub
Public Sub OverflowLong()
MyEr "OverFlow Long", "Y���������� �����"
End Sub
Public Sub BadUseofReturn()
MyEr "Wrong Use of Return", "���� ����� ��� ����������"
End Sub
Public Sub DevZero()
    MyEr "division by zero", "�������� �� �� �����"
End Sub
Public Sub DevZeroMacro(aa$)
    MyErMacro aa$, "division by zero", "�������� �� �� �����"
End Sub
Public Sub ErrInExponet(a$)
MyErMacro a$, "Error in exponet", "����� ���� ������"
End Sub

Public Sub LambdaOnly(a$)
MyErMacro a$, "Only in lambda function", "���� �� ����� ���������"
End Sub
Public Sub FilePathNotForUser()
MyEr "Filepath is not valid for user", "� ����� ��� ������� ��� ����� ������� ��� ��� ������"
End Sub

' used to isnumber
Public Sub MyErMacro(wher$, en$, gr$)
If stackshowonly Then
LastErNum = -2
wher$ = " : ERROR -2" & Sput(en$) + Sput(gr$) + wher$
Else
MyEr en$, gr$
End If
End Sub
Public Sub MyErMacroStr(wher$, en$, gr$)
If stackshowonly Then
LastErNum = -2
wher$ = " : ERROR -2" & Sput(en$) + Sput(gr$) + wher$
Else
MyEr en$, gr$
End If
End Sub
Public Sub ZeroParam(ar$)   ' we use MyErMacro in isNumber and isString
MyErMacro ar$, "Empty parameter", "�������� ����������"
End Sub
Public Sub MissPar()
MyEr "missing parameter", "������ ����������"
End Sub
Public Sub MissModuleName()
MyEr "Missing module name", "������ ����� ��������"
End Sub
Public Sub NoNext()
MyEr "NEXT without FOR", "������� ����� ���"
End Sub
Public Sub MissNext()
MyEr "Missing the right NEXT", "����� �� ����� �������"
End Sub
Public Sub MissVarName()
MyEr "Missing variable name", "������ ����� ����������"
End Sub
Public Sub MissParam(ar$)
MyErMacro ar$, "missing parameter", "������ ����������"
End Sub
Public Sub MissFuncParameterStringVar()
MyEr "Not a string variable", "��� ����� ������������� ���������"
End Sub
Public Sub MissFuncParameterStringVarMacro(ar$)
MyErMacro ar$, "Not a string variable", "��� ����� ������������� ���������"
End Sub
Public Sub NoSuchFolder()
MyEr "No such folder", "��� ������� ������� �������"
End Sub
Public Sub MissSymbol(wht$)
MyEr "missing " & wht$, "������ " & wht$
End Sub
Public Sub ClearSpace(nm$)
Dim i As Long
Do
    i = 1
    If FastOperator(nm$, vbCrLf, i, 2, False) Then
        SetNextLine nm$
    ElseIf FastOperator(nm$, "\", i) Then
        SetNextLine nm$
    ElseIf FastOperator(nm$, "'", i) Then
        SetNextLine nm$
    Else
    Exit Do
    End If
Loop
End Sub
Public Function StringToEscapeStr(RHS As String, Optional json As Boolean = False) As String
Dim i As Long, cursor As Long, ch As String
cursor = 0
Dim DEL As String
Dim H9F As String
DEL = ChrW(127)
H9F = ChrW(&H9F)
For i = 1 To Len(RHS)
                ch = Mid$(RHS, i, 1)
                cursor = cursor + 1
                Select Case ch
                    Case "\":        ch = "\\"
                   ' Case """":       ch = "\"""
                    Case """"
                    If json Then
                        ch = "\"""
                    Else
                        ch = "\u0022"
                    End If
                    Case vbLf:       ch = "\n"
                    Case vbCr:       ch = "\r"
                    Case vbTab:      ch = "\t"
                    Case vbBack:     ch = "\b"
                    Case vbFormFeed: ch = "\f"
                    Case Is < " ", DEL To H9F
                        ch = "\u" & Right$("000" & Hex$(AscW(ch)), 4)
                End Select
                If cursor + Len(ch) > Len(StringToEscapeStr) Then StringToEscapeStr = StringToEscapeStr + Space$(500)
                Mid$(StringToEscapeStr, cursor, Len(ch)) = ch
                cursor = cursor + Len(ch) - 1
Next
If cursor > 0 Then StringToEscapeStr = Left$(StringToEscapeStr, cursor)

End Function
Public Function EscapeStrToString(RHS As String) As String
Dim i As Long, cursor As Long, ch As String
     For cursor = 1 To Len(RHS)
        ch = Mid$(RHS, cursor, 1)
        i = i + 1
        Select Case ch
            Case """": GoTo ok1
            Case "\":
                cursor = cursor + 1
                ch = Mid$(RHS, cursor, 1)
                Select Case LCase$(ch) 'We'll make this forgiving though lowercase is proper.
                    Case "\", "/": ch = ch
                    Case """":      ch = """"
                    Case "n":      ch = vbLf
                    Case "r":      ch = vbCr
                    Case "t":      ch = vbTab
                    Case "b":      ch = vbBack
                    Case "f":      ch = vbFormFeed
                    Case "u":      ch = ParseHexChar(RHS, cursor, Len(RHS))
                End Select
        End Select
                If i + Len(ch) > Len(EscapeStrToString) Then EscapeStrToString = EscapeStrToString + Space$(500)
                Mid$(EscapeStrToString, i, Len(ch)) = ch
                i = i + Len(ch) - 1
    Next
ok1:
    If i > 0 Then EscapeStrToString = Left$(EscapeStrToString, i)
End Function

Private Function ParseHexChar( _
    ByRef Text As String, _
    ByRef cursor As Long, _
    ByVal LenOfText As Long) As String
    
    Const ASCW_OF_ZERO As Long = &H30&
    Dim Length As Long
    Dim ch As String
    Dim DigitValue As Long
    Dim Value As Long

    For cursor = cursor + 1 To LenOfText
        ch = Mid$(Text, cursor, 1)
        Select Case ch
            Case "0" To "9", "A" To "F", "a" To "f"
                Length = Length + 1
                If Length > 4 Then Exit For
                If ch > "9" Then
                    DigitValue = (AscW(ch) And &HF&) + 9
                Else
                    DigitValue = AscW(ch) - ASCW_OF_ZERO
                End If
                Value = Value * &H10& + DigitValue
            Case Else
                Exit For
        End Select
    Next
    If Length = 0 Then Err.Raise 5 'No hex digits at all.
    cursor = cursor - 1
    ParseHexChar = ChrW$(Value)
End Function

Public Function ReplaceSpace(a$) As String
Dim i As Long, j As Long
i = 1
Do
i = InStr(i, a$, "[")
If i > 0 Then
    i = i + 1
    j = InStr(i, a$, "]")
    If j > 0 Then
    j = j - i
    Mid$(a$, i, j) = Replace(Mid$(a$, i, j), " ", ChrW(160))
    i = i + j
    End If
Else
    Exit Do
End If
Loop
ReplaceSpace = a$
End Function
Function GetReturnArray(bstack As basetask, x1 As Long, b$, p As Variant, ss$, pppp As mArray) As Boolean ' true is error

Do
        If IsExp(bstack, b$, p) Then
        If x1 = 0 Then If MaybeIsSymbol(b$, ",") Then x1 = 1: Set pppp = New mArray: pppp.PushDim (1): pppp.PushEnd
        If x1 = 0 Then
                If Len(bstack.OriginalName$) > 3 Then
                        If Mid$(bstack.OriginalName$, Len(bstack.OriginalName$) - 2, 1) = "$" Then
                            MissStringExpr
                            Exit Do
                        End If
                    End If
                 If Right$(bstack.OriginalName$, 3) = "%()" Then p = MyRound(p)
                 Set bstack.FuncObj = bstack.lastobj
                 Set bstack.lastobj = Nothing
                 bstack.FuncValue = p
        Else
                pppp.SerialItem 0, x1, 9
                If bstack.lastobj Is Nothing Then
                    pppp.item(x1 - 1) = p
                Else
                    If Typename(bstack.lastobj) = "mHandler" Then CheckGarbage bstack
                    Set pppp.item(x1 - 1) = bstack.lastobj
                    Set bstack.lastobj = Nothing
                End If
                bstack.FuncValue = p
                x1 = x1 + 1
                             
        End If
        ElseIf IsStrExp(bstack, b$, ss$) Then
            If x1 = 0 Then If MaybeIsSymbol(b$, ",") Then x1 = 1: Set pppp = New mArray: pppp.PushDim (1): pppp.PushEnd
            If x1 = 0 Then
                If Len(bstack.OriginalName$) > 3 Then
                    If Mid$(bstack.OriginalName$, Len(bstack.OriginalName$) - 2, 1) <> "$" Then
                         MissNumExpr
                         GetReturnArray = True
                         Exit Function
                    End If
                Else
                    MissNumExpr
                    GetReturnArray = True
                    Exit Function
                End If
                Set bstack.FuncObj = bstack.lastobj
                Set bstack.lastobj = Nothing
                bstack.FuncValue = ss$
            Else
                pppp.SerialItem 0, x1, 9
                If bstack.lastobj Is Nothing Then
                    pppp.item(x1 - 1) = ss$
                Else
                    If Typename(bstack.lastobj) = "mHandler" Then CheckGarbage bstack
                    Set pppp.item(x1 - 1) = bstack.lastobj
                    Set bstack.lastobj = Nothing
                End If
                x1 = x1 + 1
                bstack.FuncValue = ss$
                            
            End If
        End If
        Loop Until Not FastSymbol(b$, ",")
        If x1 > 0 Then
         pppp.SerialItem 0, x1, 9
         Set bstack.FuncObj = pppp
         Set pppp = New mArray
         Set bstack.lastobj = Nothing
         If VarType(bstack.FuncValue) = 5 Then
         bstack.FuncValue = 0
         Else
         bstack.FuncValue = vbNullString
         End If
        End If
        x1 = 0
End Function
Function AssignTypeNumeric(v, i As Long) As Boolean
On Error GoTo there
If VarType(v) = vbString Then v = Format$(v)
Select Case i
Case vbBoolean
v = CBool(v)
Case vbCurrency
v = CCur(v)
Case vbDecimal
v = CDec(v)
Case vbLong
v = CLng(v)
Case vbSingle
v = CSng(v)
Case Else
v = CDbl(v)
End Select
AssignTypeNumeric = True
Exit Function
there:
MyEr "Can't convert value", "��� ����� �� ��������� ��� ����"
End Function
Function MergeOperators(ByVal a$, ByVal b$) As String
If a$ = vbNullString Then MergeOperators = b$: Exit Function
If b$ = vbNullString Then MergeOperators = a$: Exit Function
If a$ = b$ Then MergeOperators = a$: Exit Function
Dim BR() As String, i As Long
If Len(a$) > Len(b$) Then
BR() = Split("[]" + b$ + "[]", "][")
For i = 1 To UBound(BR) - 1
If InStr(a$, "[" + BR(i) + "]") = 0 Then a$ = a$ + "[" + BR(i) + "]"
Next i
MergeOperators = a$
Else
BR() = Split("[]" + a$ + "[]", "][")
For i = 1 To UBound(BR) - 1
If InStr(b$, "[" + BR(i) + "]") = 0 Then b$ = b$ + "[" + BR(i) + "]"
Next i
MergeOperators = b$
End If
End Function
Public Sub GarbageFlush()
Dim objptr, obj As Object, i As Long
With GarbageCollector
If .Count > 0 Then
For i = 0 To .Count - 1
.index = i
Set obj = .ValueObj
If TypeOf obj Is FastCollection Then
    obj.GarbageJob
ElseIf TypeOf obj Is mHandler Then
If obj.objref Is Nothing Then

ElseIf TypeOf obj.objref Is FastCollection Then
obj.objref.GarbageJob

End If
End If
Next i
'Set obj = .ValueObj
GarbageCollector.Done = False
GarbageCollector.GarbageJob
End If
End With

End Sub
Public Sub GarbageFlush2()
Dim objptr, obj As Object, i As Long, Tmp As New GarbageClass
With GarbageCollector
If .Count > 0 Then
For i = 0 To .Count - 1
.index = i
Set obj = .ValueObj
If TypeOf obj Is FastCollection Then

Tmp.AddKey .KeyLong
    obj.GarbageJob
ElseIf TypeOf obj Is mHandler Then
If obj.objref Is Nothing Then

ElseIf TypeOf obj.objref Is FastCollection Then
Tmp.AddKey .KeyLong
obj.objref.GarbageJob

End If
End If
Next i
End If
End With
Set obj = Nothing
If Tmp.Count > 0 Then
With Tmp
For i = 0 To .Count - 1
.index = i
If GarbageCollector.Find(Tmp.KeyLong) Then
    If GarbageCollector.ReferCountValue = 1 Then
        GarbageCollector.RemoveWithNoFind
    End If
End If

Next i
End With
End If


End Sub
Function PointPos(F$) As Long
Dim er As Long, er2 As Long
While FastSymbol(F$, Chr(34))
F$ = GetStrUntil(Chr(34), F$)
Wend
Dim i As Long, j As Long, oj As Long
If F$ = vbNullString Then
PointPos = 1
Else
er = 3
er2 = 3
For i = 1 To Len(F$)
er = er + 1
er2 = er2 + 1
Select Case Mid$(F$, i, 1)
Case "."
oj = j: j = i
Case "\", "/", ":", Is = Chr(34)
If er = 2 Then oj = 0: j = i - 2: Exit For
er2 = 1
oj = j: j = 0
If oj = 0 Then oj = i - 1: If oj < 0 Then oj = 0
Case " ", ChrW(160)
If j > 0 Then Exit For
If er2 = 2 Then oj = 0: j = i - 1: Exit For
er = 1
Case "|", "'"
j = i - 1
Exit For
Case Is > " "

If j > 0 Then oj = j Else oj = 0
Case Else
If oj <> 0 Then j = oj Else j = i
Exit For
End Select
Next i
If j = 0 Then
If oj = 0 Then
j = Len(F$) + 1
Else
j = oj
End If
End If
While Mid$(F$, j, i) = " "
j = j - 1
Wend
PointPos = j
End If
End Function
Public Function ExtractType(F$, Optional JJ As Long = 0) As String
Dim i As Long, j As Long, d$
If FastSymbol(F$, Chr(34)) Then F$ = GetStrUntil(Chr(34), F$)
If F$ = vbNullString Then ExtractType = vbNullString: Exit Function
If JJ > 0 Then
j = JJ
Else


j = PointPos(F$)
End If
d$ = F$ & " "
If j < Len(d$) Then
For i = j To Len(d$)
Select Case Mid$(d$, i, 1)
Case "/", "|", "'", " ", Is = Chr(34)
i = i + 1
Exit For
End Select
Next i
If (i - j - 2) < 1 Then
ExtractType = vbNullString
Else
ExtractType = mylcasefILE(Mid$(d$, j + 1, i - j - 2))
End If
Else
ExtractType = vbNullString
End If
End Function


Public Function CFname(a$, Optional TS As Variant, Optional createtime As Variant) As String
If Len(a$) > 2000 Then Exit Function
Dim b$
Dim mDir As New recDir
If Not IsMissing(createtime) Then
mDir.UseUTC = createtime <= 0
End If
Sleep 1
If a$ <> "" Then
On Error GoTo 1
b$ = mDir.Dir1(a$, GetCurDir)
If b$ = vbNullString Then b$ = mDir.Dir1(a$, mDir.GetLongName(App.path))
If b$ <> "" Then
CFname = mylcasefILE(b$)
If Not IsMissing(TS) Then
If Not IsMissing(createtime) Then
If Abs(createtime) = 1 Then
TS = CDbl(mDir.lastTimeStamp2)
Else
TS = CDbl(mDir.lastTimeStamp)
End If
Else
TS = CDbl(mDir.lastTimeStamp)
End If
End If
End If
Exit Function
End If
1:
CFname = vbNullString
End Function

Public Function LONGNAME(Spath As String) As String
LONGNAME = ExtractPath(Spath, , True)
End Function


Public Function ExtractPath(ByVal F$, Optional Slash As Boolean = True, Optional existonly As Boolean = False) As String
If F$ = vbNullString Then Exit Function
Dim i As Long, j As Long, test$
test$ = F$ & " \/:": i = InStr(test$, " "): j = InStr(test$, "\")
If i < j Then j = InStr(test$, "/"): If i < j Then j = InStr(test$, ":"): If i < j Then Exit Function
If Right(F$, 1) = "\" Or Right(F$, 1) = "/" Then F$ = F$ & " a"
j = PointPos(F$)
If Mid$(F$, j, 1) = "." Then j = j - 1
If Len(F$) < j Then
If ExtractType(Mid$(F$, j) & "\.10") = "10" Then j = j - 1 Else Exit Function
Else

End If

j = j - Len(ExtractNameOnly(F$))
If j <= 3 Then
If Mid$(F$, 2, 1) = ":" Then
If Slash Then
ExtractPath = mylcasefILE(Left$(F$, 2)) & "\"
Else
ExtractPath = mylcasefILE(Left$(F$, 2))
End If
Else
ExtractPath = vbNullString
End If
Else
If Slash Then
ExtractPath = mylcasefILE(Left$(F$, j))
Else
ExtractPath = mylcasefILE(Left$(F$, j - 1))
End If
End If

If existonly Then
ExtractPath = mylcasefILE(StripTerminator(GetLongName(ExpEnvirStr(ExtractPath))))
Else
ExtractPath = ExpEnvirStr(ExtractPath)
End If
Dim ccc() As String, c$
ccc() = Split(ExtractPath, "\..")
If UBound(ccc()) > LBound(ccc()) Then
c$ = vbNullString
For i = LBound(ccc()) To UBound(ccc()) - 1
If ccc(i) = vbNullString Then
c$ = ExtractPath(ExtractPath(c$, False))
Else
c$ = c$ & ExtractPath(ccc(i), True)
End If

Next i
If Left$(ccc(i), 1) = "\" Then
ExtractPath = c$ & Mid$(ccc(i), 2)
Else
ExtractPath = c$ & ccc(i)
End If
End If
End Function
Public Function ExtractName(F$) As String
Dim i As Long, j As Long, k$
If F$ = vbNullString Then Exit Function
j = PointPos(F$)
If Mid$(F$, j, 1) = "." Then
k$ = ExtractType(F$, j)
Else
j = Len(F$)
End If
For i = j To 1 Step -1
Select Case Mid$(F$, i, 1)
Case Is < " ", "\", "/", ":"
Exit For
End Select
Next i
If k$ = vbNullString Then
If Mid$(F$, i + j - i, 1) = "." Then
ExtractName = mylcasefILE(Mid$(F$, i + 1, j - i - 1))
Else
ExtractName = mylcasefILE(Mid$(F$, i + 1, j - i))

End If
Else
ExtractName = mylcasefILE(Mid$(F$, i + 1, j - i)) + k$
End If

'ExtractName = mylcasefILE(Trim$(Mid$(f$, I + 1, j - I)))

End Function
Public Function ExtractNameOnly(ByVal F$) As String
Dim i As Long, j As Long
If F$ = vbNullString Then Exit Function
j = PointPos(F$)
If j > Len(F$) Then j = Len(F$)
For i = j To 1 Step -1
Select Case Mid$(F$, i, 1)
Case Is < " ", "\", "/", ":"
Exit For
End Select
Next i
If Mid$(F$, i + j - i, 1) = "." Then
ExtractNameOnly = mylcasefILE(Mid$(F$, i + 1, j - i - 1))
Else
ExtractNameOnly = mylcasefILE(Mid$(F$, i + 1, j - i))
End If
End Function
Public Function GetCurDir(Optional AppPath As Boolean = False) As String
Dim a$, cd As String

If AppPath Then
cd = App.path
AddDirSep cd
a$ = mylcasefILE(cd)
Else
AddDirSep mcd
a$ = mylcasefILE(mcd)

End If
'If Right$(a$, 1) <> "\" Then a$ = a$ & "\"
GetCurDir = a$
End Function
Sub MakeGroupPointer(bstack As basetask, v)
Dim varv As New Group
    With varv
        .IamGlobal = v.IamGlobal
        .IamApointer = True
        .BeginFloat 2
        Set .Sorosref = v.soros
        If Not v.IamFloatGroup Then
        If bstack.UseGroupname <> "" Then
        .lasthere = Mid$(bstack.UseGroupname, 1, Len(bstack.UseGroupname) - 1)
        Else
        .lasthere = here$
        End If
        If Len(v.GroupName) > 1 Then
            .GroupName = Mid$(v.GroupName, 1, Len(v.GroupName) - 1)
        End If
        End If
    End With
     Set varv.LinkRef = v
Set bstack.lastpointer = varv
Set bstack.lastobj = varv
End Sub
Function PreparePointer(bstack As basetask) As Boolean
Dim a As Group, pppp As mArray
    If bstack.lastpointer Is Nothing Then
    
    Else
        Set a = bstack.lastpointer
        
            Set pppp = New mArray
            pppp.PushDim 1
            pppp.PushEnd
            pppp.Arr = True
            Set pppp.item(0) = a
            Set bstack.lastpointer = pppp
            PreparePointer = True
  
    End If
    
End Function
Function BoxGroupVar(aGroup As Variant) As mArray
            Set BoxGroupVar = New mArray
            BoxGroupVar.PushDim 1
            BoxGroupVar.PushEnd
            BoxGroupVar.Arr = True
            Set BoxGroupVar.item(0) = aGroup
End Function

Function BoxGroupObj(aGroup As Object) As mArray
            Set BoxGroupObj = New mArray
            BoxGroupObj.PushDim 1
            BoxGroupObj.PushEnd
            BoxGroupObj.Arr = True
            Set BoxGroupObj.item(0) = aGroup
End Function

Sub monitor(bstack As basetask, prive As basket, lang As Long)
    Dim ss$, di As Object
    Set di = bstack.Owner
    If lang = 0 Then
        wwPlain bstack, prive, "�� ������� ������������: " & GetACP, bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "������� ���������", bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, PathFromApp("m2000"), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "���������� gsb", bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, myRegister("gsb"), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "������� ���������� �������", bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, LONGNAME(strTemp), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "������ �������", bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, mcd, bstack.Owner.Width, 1000, True
        If m_bInIDE Then
        wwPlain bstack, prive, "���� ��������� ��� ����������� " + CStr(stacksize \ 2948 - 1), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "���� ��������� �����������/�������� �� ��� ������ " + CStr(stacksize \ 1772 - 1), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "���� ������� ��� ������� " + CStr(stacksize \ 1254 - 1), bstack.Owner.Width, 1000, True
        Else
        wwPlain bstack, prive, "���� ��������� ��� ����������� " + CStr(stacksize \ 9832 - 1), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "���� ��������� �����������/�������� �� ��� ������ " + CStr(stacksize \ 5864), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "���� ������� ��� �������  " + CStr(stacksize \ 5004), bstack.Owner.Width, 1000, True
        End If
        If OverideDec Then wwPlain bstack, prive, "������ ������� " + CStr(cLid), bstack.Owner.Width, 1000, True
        If UseIntDiv Then ss$ = "+DIV" Else ss$ = "-DIV"
        If priorityOr Then ss$ = ss$ + " +PRI" Else ss$ = ss$ + " -PRI"
        If Not mNoUseDec Then ss$ = ss$ + " -DEC" Else ss$ = ss$ + " +DEC"
        If mNoUseDec <> NoUseDec Then ss$ = ss$ + "(���������)"
        If mTextCompare Then ss$ = ss$ + " +TXT" Else ss$ = ss$ + " -TXT"
        If ForLikeBasic Then ss$ = ss$ + " +FOR" Else ss$ = ss$ + " -FOR"
        If DimLikeBasic Then ss$ = ss$ + " +DIM" Else ss$ = ss$ + " -DIM"
        If ShowBooleanAsString Then ss$ = ss$ + " +SBL" Else ss$ = ss$ + " -SBL"
        If SecureNames Then ss$ = ss$ + " +SEC" Else ss$ = ss$ + " -SEC"
        wwPlain bstack, prive, "��������� " + ss$, bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "���� ���������: ������������� ��� ������ ������� ���������", bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "������:" + Str$(DisplayMonitorCount()) + "  � ������ :" + Str$(FindPrimary + 1), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "���� � ����� ����� ���� �����:" + Str$(FindFormSScreen(di) + 1), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "� ������� ����� ���� �����:" + Str$(Console + 1), bstack.Owner.Width, 1000, True

    Else
        wwPlain bstack, prive, "Default Code Page:" & GetACP, bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "App Path", bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, PathFromApp("m2000"), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "Register gsb", bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, myRegister("gsb"), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "Temporary", bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, LONGNAME(strTemp), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "Current directory", bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, mcd, bstack.Owner.Width, 1000, True
        If m_bInIDE Then
        wwPlain bstack, prive, "Max Limit for Function Recursion " + CStr(stacksize \ 2948 - 1), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "Max Limit for Function/Module Recursion using Call " + CStr(stacksize \ 1772 - 1), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "Max Limit for calling modules in depth " + CStr(stacksize \ 1254 - 1), bstack.Owner.Width, 1000, True
        Else
        wwPlain bstack, prive, "Max Limit for Function Recursion " + CStr(stacksize \ 9832 - 1), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "Max Limit for Function/Module Recursion using Call " + CStr(stacksize \ 5864), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "Max Limit for calling modules in depth " + CStr(stacksize \ 5004), bstack.Owner.Width, 1000, True
        End If
        If OverideDec Then wwPlain bstack, prive, "Locale Overide " + CStr(cLid), bstack.Owner.Width, 1000, True
        If UseIntDiv Then ss$ = "+DIV" Else ss$ = "-DIV"
        If priorityOr Then ss$ = ss$ + " +PRI" Else ss$ = ss$ + " -PRI"
        If Not mNoUseDec Then ss$ = ss$ + " -DEC" Else ss$ = ss$ + " +DEC"
        If mNoUseDec <> NoUseDec Then ss$ = ss$ + "(bypass)"
        If mTextCompare Then ss$ = ss$ + " +TXT" Else ss$ = ss$ + " -TXT"
        If ForLikeBasic Then ss$ = ss$ + " +FOR" Else ss$ = ss$ + " -FOR"
        If DimLikeBasic Then ss$ = ss$ + " +DIM" Else ss$ = ss$ + " -DIM"
        If ShowBooleanAsString Then ss$ = ss$ + " +SBL" Else ss$ = ss$ + " -SBL"
        If SecureNames Then ss$ = ss$ + " +SEC" Else ss$ = ss$ + " -SEC"
        wwPlain bstack, prive, "Switches " + ss$, bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "About Switches: use command Help Switches", bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "Screens:" + Str$(DisplayMonitorCount()) + "  Primary is:" + Str$(FindPrimary + 1), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "This form is in screen:" + Str$(FindFormSScreen(di) + 1), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "Console is in screen:" + Str$(Console + 1), bstack.Owner.Width, 1000, True
    End If
End Sub
Sub NeoSwap(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MySwap(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoComm(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyRead(3, ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoRef(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyRead(2, ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoRead(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyRead(1, ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoReport(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyReport(ObjFromPtr(basestackLP), rest$, lang)
End Sub

Sub NeoDeclare(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyDeclare(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoMethod(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyMethod(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoWith(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyWith(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoSprite(basestackLP As Long, rest$, lang As Long, resp As Boolean)
Dim s$, p
If IsStrExp(ObjFromPtr(basestackLP), rest$, s$) Then
sprite ObjFromPtr(basestackLP), s$, rest$
ElseIf IsExp(ObjFromPtr(basestackLP), rest$, p) Then
spriteGDI ObjFromPtr(basestackLP), rest$
End If
resp = LastErNum1 = 0
End Sub

Sub NeoPlayer(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcPlayer(ObjFromPtr(basestackLP), rest$, lang)
End Sub

Sub NeoPrinter(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcPrinter(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoPage(basestackLP As Long, rest$, lang As Long, resp As Boolean)
ProcPage ObjFromPtr(basestackLP), rest$, lang
resp = True
End Sub
Sub NeoCompact(basestackLP As Long, rest$, lang As Long, resp As Boolean)
BaseCompact ObjFromPtr(basestackLP), rest$
resp = True
End Sub
Sub NeoLayer(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcLayer(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoOrder(basestackLP As Long, rest$, lang As Long, resp As Boolean)
MyOrder ObjFromPtr(basestackLP), rest$
resp = True
End Sub

Sub NeoDelete(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = DELfields(ObjFromPtr(basestackLP), rest$)
'resp = True  '' maybe this can be change
End Sub
Sub NeoAppend(basestackLP As Long, rest$, lang As Long, resp As Boolean)
Dim s$, p As Variant
resp = True
If IsExp(ObjFromPtr(basestackLP), rest$, p) Then
resp = AddInventory(ObjFromPtr(basestackLP), rest$)
ElseIf IsStrExp(ObjFromPtr(basestackLP), rest$, s$) Then
append_table ObjFromPtr(basestackLP), s$, rest$, False
Else
SyntaxError
resp = False
End If
End Sub
Sub NeoSearch(basestackLP As Long, rest$, lang As Long, resp As Boolean)
getrow ObjFromPtr(basestackLP), rest$, , "", lang
resp = True
End Sub
Sub NeoRetr(basestackLP As Long, rest$, lang As Long, resp As Boolean)
getrow ObjFromPtr(basestackLP), rest$, , , lang
resp = True
End Sub
Sub NeoExecute(basestackLP As Long, rest$, lang As Long, resp As Boolean)
If IsLabelSymbolNew(rest$, "������", "CODE", lang) Then
 resp = ExecCode(ObjFromPtr(basestackLP), rest$)
 Else
CommExecAndTimeOut ObjFromPtr(basestackLP), rest$
resp = True
End If

End Sub

Sub NeoTable(basestackLP As Long, rest$, lang As Long, resp As Boolean)
NewTable ObjFromPtr(basestackLP), rest$
resp = True
End Sub
Sub NeoBase(basestackLP As Long, rest$, lang As Long, resp As Boolean)
NewBase ObjFromPtr(basestackLP), rest$
resp = True
End Sub
Sub NeoHold(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcHold(ObjFromPtr(basestackLP))
End Sub
Sub NeoRelease(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcRelease(ObjFromPtr(basestackLP))
End Sub
Sub NeoSuperClass(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcClass(ObjFromPtr(basestackLP), rest$, lang, True)
End Sub
Sub NeoClass(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcClass(ObjFromPtr(basestackLP), rest$, lang, False)
End Sub
Sub NeoDIM(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyDim(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoPathDraw(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcPath(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoDrawings(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyDrawings(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoFill(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcFill(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoFloodFill(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcFLOODFILL(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoTextCursor(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyCursor(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoMouseIcon(basestackLP As Long, rest$, lang As Long, resp As Boolean)
i3MouseIcon ObjFromPtr(basestackLP), rest$, lang
resp = True
End Sub
Sub NeoDouble(basestackLP As Long, rest$, lang As Long, resp As Boolean)
Dim bstack As basetask
Set bstack = ObjFromPtr(basestackLP)
SetDouble bstack.Owner
Set bstack = Nothing
resp = True
End Sub
Sub NeoNormal(basestackLP As Long, rest$, lang As Long, resp As Boolean)
Dim bstack As basetask
Set bstack = ObjFromPtr(basestackLP)
SetNormal bstack.Owner
Set bstack = Nothing
resp = True
End Sub
Sub NeoSort(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcSort(ObjFromPtr(basestackLP), rest$, lang)
End Sub

Sub NeoImage(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcImage(ObjFromPtr(basestackLP), rest$, lang)
End Sub

Sub NeoBitmaps(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyBitmaps(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoDef(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcDef(ObjFromPtr(basestackLP), rest$, lang)
End Sub

Sub NeoMovies(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyMovies(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoSounds(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MySounds(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoPen(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcPen(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoCls(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcCls(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoStructure(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = myStructure(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoInput(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyInput(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoEvent(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = myEvent(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoProto(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcProto(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoModule(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyModule(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoModules(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyModules(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoGroup(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcGroup(0, ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoBack(basestackLP As Long, rest$, lang As Long, resp As Boolean)
ProcBackGround ObjFromPtr(basestackLP), rest$, lang, resp
End Sub
Sub NeoOver(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcOver(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoDrop(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcDrop(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoShift(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcShift(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoShiftBack(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcShiftBack(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoLoad(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcLoad(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoText(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcText(ObjFromPtr(basestackLP), False, rest$)
End Sub
Sub NeoHtml(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcText(ObjFromPtr(basestackLP), True, rest$)
End Sub

Sub NeoCurve(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcCurve(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoPoly(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcPoly(ObjFromPtr(basestackLP), rest$, lang)
End Sub

Sub NeoCircle(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcCircle(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoNew(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyNew(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoTitle(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcTitle(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoDraw(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcDraw(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoWidth(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcDrawWidth(ObjFromPtr(basestackLP), rest$)
End Sub

Sub NeoMove(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcMove(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoStep(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcStep(ObjFromPtr(basestackLP), rest$, lang)
End Sub

Sub NeoPrint(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = RevisionPrint(ObjFromPtr(basestackLP), rest$, 0, lang)
End Sub
Sub NeoCopy(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyCopy(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoPrinthEX(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = RevisionPrint(ObjFromPtr(basestackLP), rest$, 1, lang)
End Sub
Sub NeoRem(basestackLP As Long, rest$, lang As Long, resp As Boolean)
    SetNextLineNL rest$
    resp = True
End Sub
Sub NeoPush(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyPush(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoData(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyData(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoClear(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyClear(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoLinespace(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = procLineSpace(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoSet(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = interpret(ObjFromPtr(basestackLP), GetNextLine(rest$))
End Sub


Sub NeoBold(basestackLP As Long, rest$, lang As Long, resp As Boolean)
ProcBold ObjFromPtr(basestackLP), rest$
resp = True
End Sub
Sub NeoChooseObj(basestackLP As Long, rest$, lang As Long, resp As Boolean)
    resp = ProcChooseObj(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoChooseFont(basestackLP As Long, rest$, lang As Long, resp As Boolean)
    ProcChooseFont ObjFromPtr(basestackLP), lang
    resp = True
End Sub
Sub NeoFont(basestackLP As Long, rest$, lang As Long, resp As Boolean)
    ProcChooseFont ObjFromPtr(basestackLP), lang
    resp = True
End Sub
Sub NeoScore(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyScore(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoPlayScore(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyPlayScore(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoMode(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcMode(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoGradient(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcGradient(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoFunction(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyFunction(0, ObjFromPtr(basestackLP), rest$, lang)
End Sub

Sub NeoFiles(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcFiles(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoCat(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = ProcCat(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Sub NeoLet(basestackLP As Long, rest$, lang As Long, resp As Boolean)
resp = MyLet(ObjFromPtr(basestackLP), rest$, lang)
End Sub
Function GetArrayReference(bstack As basetask, a$, v$, PP, result As mArray, index As Long) As Boolean
Dim dn As Long, dd As Long, p, w3, w2 As Long, pppp As mArray
If Not Typename$(PP) = "mArray" Then Exit Function
Set pppp = PP

If pppp.Arr Then
dn = 0

pppp.SerialItem (0), dd, 5
dd = dd - 1
If dd < 0 Then If Typename(pppp.GroupRef) = "PropReference" Then Exit Function
            
            
p = 0
    GetArrayReference = True
    w2 = 0



        Do While dn <= dd
                    pppp.SerialItem w3, dn, 6
                    
                        If IsExp(bstack, a$, p) Then
                        If dn < dd Then
                            If Not FastSymbol(a$, ",") Then: MyErMacro a$, "need index for " & v$ & ")", "���������� ������ ��� �� ������ " & v$ & ")": GetArrayReference = False: Exit Function
                           
                            Else
                         If FastSymbol(a$, ",") Then
                        GetArrayReference = False
                        MyErMacro a$, "too many indexes for array " & v$ & ")", "������ ������� ��� �� ������ " & v$ & ")"
                        Exit Function
                         
                         End If
                            If Not FastSymbol(a$, ")") Then: MissSymbol ")": GetArrayReference = False: Exit Function
                            
                         
                        End If
                            On Error Resume Next
                            If p < -pppp.myarrbase Then
                            GetArrayReference = False
                              MyErMacro a$, "index too low for array " & v$ & ")", "��������� ������� ��� ������ " & v$ & ")"
                            Exit Function
                            End If
                            
                        If Not pppp.PushOffset(w2, dn, CLng(Fix(p))) Then
                                GetArrayReference = False
                                MyErMacro a$, "index too high for array " & v$ & ")", "������� ������ ��� �� ������ " & v$ & ")"
                                GetArrayReference = False
                            Exit Function
                            End If
                            On Error GoTo 0
                        Else
                        
                         GetArrayReference = False
                        If LastErNum = -2 Then
                        Else
                        
                        MyErMacro a$, "missing index for array " & v$ & ")", "������ ������� ��� �� ������ " & v$ & ")"
                        End If
                        Exit Function
                        End If
                    dn = dn + 1
                    Loop
                    
                    
                        Set result = pppp
                        index = w2
    End If
End Function
Function ProcessArray(bstack As basetask, a$, v$, PP, result) As Boolean
Dim dn As Long, dd As Long, p, w3, w2 As Long, pppp As mArray
If Not Typename$(PP) = "mArray" Then Exit Function
Set pppp = PP

If pppp.Arr Then
dn = 0

pppp.SerialItem (0), dd, 5
dd = dd - 1
If dd < 0 Then If Typename(pppp.GroupRef) = "PropReference" Then Exit Function
            
            
p = 0
    ProcessArray = True
    w2 = 0



        Do While dn <= dd
                    pppp.SerialItem w3, dn, 6
                    
                        If IsExp(bstack, a$, p) Then
                        If dn < dd Then
                            If Not FastSymbol(a$, ",") Then: MyErMacro a$, "need index for " & v$ & ")", "���������� ������ ��� �� ������ " & v$ & ")": ProcessArray = False: Exit Function
                           
                            Else
                         If FastSymbol(a$, ",") Then
                        ProcessArray = False
                        MyErMacro a$, "too many indexes for array " & v$ & ")", "������ ������� ��� �� ������ " & v$ & ")"
                        Exit Function
                         
                         End If
                            If Not FastSymbol(a$, ")") Then: MissSymbol ")": ProcessArray = False: Exit Function
                            
                         
                        End If
                            On Error Resume Next
                            If p < -pppp.myarrbase Then
                            ProcessArray = False
                              MyErMacro a$, "index too low for array " & v$ & ")", "��������� ������� ��� ������ " & v$ & ")"
                            Exit Function
                            End If
                            
                        If Not pppp.PushOffset(w2, dn, CLng(Fix(p))) Then
                                ProcessArray = False
                                MyErMacro a$, "index too high for array " & v$ & ")", "������� ������ ��� �� ������ " & v$ & ")"
                                ProcessArray = False
                            Exit Function
                            End If
                            On Error GoTo 0
                        Else
                        
                         ProcessArray = False
                        If LastErNum = -2 Then
                        Else
                        
                        MyErMacro a$, "missing index for array " & v$ & ")", "������ ������� ��� �� ������ " & v$ & ")"
                        End If
                        Exit Function
                        End If
                    dn = dn + 1
                    Loop
                    If MyIsObject(pppp.item(w2)) Then
                        Set result = pppp.item(w2)
                    Else
                        result = pppp.item(w2)
                    End If
    End If
End Function
Function ReplaceCRLFSPACE(a$) As Boolean
Dim i As Long
For i = 1 To Len(a$)
Select Case AscW(Mid$(a$, i, 1))
Case 13
ReplaceCRLFSPACE = True
Case 32, 10, 160
Case Else
Exit For
End Select
Next i
If i = 1 Then Exit Function
If i > Len(a$) Then a$ = "": Exit Function
Mid$(a$, 1, i - 1) = String$(i - 1, Chr(7))
End Function
Function CallAsk(bstack As basetask, a$, v$) As Boolean
If UCase(v$) = "ASK(" Then
DialogSetupLang 1
Else
DialogSetupLang 0
End If
If AskText$ = vbNullString Then: ZeroParam a$: Exit Function
If FastSymbol(a$, ",") Then IsStrExp bstack, a$, AskTitle$
If FastSymbol(a$, ",") Then IsStrExp bstack, a$, AskOk$
If FastSymbol(a$, ",") Then IsStrExp bstack, a$, AskCancel$
If FastSymbol(a$, ",") Then IsStrExp bstack, a$, AskDIB$
If FastSymbol(a$, ",") Then IsStrExp bstack, a$, AskStrInput$: AskInput = True

olamazi
CallAsk = True
End Function
Public Sub olamazi()
If Form4.Visible Then
Form4.Visible = False
If Form1.Visible Then
   
   ' If Form2.Visible Then Form2.ZOrder
    If Form1.TEXT1.Visible Then
        Form1.TEXT1.SetFocus
    Else
        Form1.SetFocus
    End If
    End If
    End If
End Sub
Sub GetGuiM2000(r$)
Dim aaa As GuiM2000
If TypeOf Screen.ActiveForm Is GuiM2000 Then
Set aaa = Screen.ActiveForm
                  If aaa.index > -1 Then
                  r$ = myUcase(aaa.MyName$ + "(" + CStr(aaa.index) + ")", True)
                  Else
                  r$ = myUcase(aaa.MyName$, True)
                  End If
Else
                r$ = vbNullString
End If

End Sub
