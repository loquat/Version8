Attribute VB_Name = "Module2"
Option Explicit
Public k1 As Long, Kform As Boolean
Public stackshowonly As Boolean, NoBackFormFirstUse As Boolean
Public Enum Ftypes
    FnoUse
    Finput
    Foutput
    Fappend
    Frandom
End Enum
Public FLEN(512) As Long, FKIND(512) As Ftypes
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
    italics As Boolean  ' removed from process, only in current
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
Private Const myArray = "mArray"
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
Public Const LOCALE_SDECIMAL = &HE&
Public Const LOCALE_SGROUPING = &H10&
Public Const LOCALE_STHOUSAND = &HF&
Public Const LOCALE_SMONDECIMALSEP = &H16&
Public Const LOCALE_SMONTHOUSANDSEP = &H17&
Public Const LOCALE_SMONGROUPING = &H18&
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
Public Declare Function CreateCaret Lib "user32" (ByVal hWND As Long, ByVal hBitmap As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Public Declare Function ShowCaret Lib "user32" (ByVal hWND As Long) As Long
Public Declare Function GetFocus Lib "user32" () As Long
Public Declare Function SetCaretPos Lib "user32" (ByVal x As Long, ByVal y As Long) As Long
Public Declare Function HideCaret Lib "user32" (ByVal hWND As Long) As Long
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
Declare Function UpdateWindow Lib "user32" (ByVal hWND As Long) As Long
Declare Function ScrollDC Lib "user32" (ByVal hDC As Long, ByVal dX As Long, ByVal dY As Long, lprcScroll As RECT, lprcClip As RECT, ByVal hrgnUpdate As Long, lprcUpdate As RECT) As Long
Public LastErName As String
Public LastErNameGR As String
Public LastErNum As Long
Public LastErNum1 As Long, LastErNum2 As Long


Type POINTAPI
        x As Long
        y As Long
End Type
Declare Function GetDC Lib "user32" (ByVal hWND As Long) As Long
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
Private Declare Sub CopyMemory Lib "KERNEL32" Alias "RtlMoveMemory" ( _
    lpvDest As Any, lpvSource As Any, ByVal cbCopy As Long)

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
Declare Sub SetWindowPos Lib "user32" (ByVal hWND As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cX As Long, ByVal cY As Long, ByVal wFlags As Long)
Declare Function ExtFloodFill Lib "gdi32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long, ByVal wFillType As Long) As Long
Public Const FLOODFILLSURFACE = 1
Public Const FLOODFILLBORDER = 0

Public avifile As String
Public BigPi As Variant
Public Const Pi = 3.14159265358979
Public Const PI2 = 6.28318530717958
Public Result As Long
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
    pen As Long
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
Private Declare Function SetWindowRgn Lib "user32" (ByVal hWND As Long, ByVal hRgn As Long, ByVal bRedraw As Boolean) As Long
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

Private Declare Function DrawCaption Lib "user32" (ByVal hWND As Long, ByVal hDC As Long, pcRect As RECT, ByVal un As Long) As Long
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
If GetForegroundWindow = Screen.ActiveForm.hWND Then
KeyPressedLong = GetAsyncKeyState(VirtKeyCode)
End If
End If
KEXIT:
End Function
Public Function KeyPressed(ByVal VirtKeyCode As Long) As Boolean
On Error GoTo KEXIT
If Not Screen.ActiveForm Is Nothing Then
If GetForegroundWindow = Screen.ActiveForm.hWND Then
KeyPressed = CBool((GetAsyncKeyState(VirtKeyCode) And &H8000&) = &H8000&)
End If
End If
KEXIT:
End Function
Public Function mouse() As Long
On Error GoTo MEXIT
If Not Screen.ActiveForm Is Nothing Then
If GetForegroundWindow = Screen.ActiveForm.hWND Then
''If Screen.ActiveForm Is Form1 Then If Form1.lockme Then Exit Function

mouse = -1 * CBool((GetAsyncKeyState(1) And &H8000&) = &H8000&) - 2 * CBool((GetAsyncKeyState(2) And &H8000&) = &H8000&) - 4 * CBool((GetAsyncKeyState(4) And &H8000&) = &H8000&)
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
If GetForegroundWindow = Screen.ActiveForm.hWND Then
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
If GetForegroundWindow = Screen.ActiveForm.hWND Then
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
    MyErMacro a$, "Unsign long can't be negative", "� �������� ����� ������� ��� ������ �� ����� ���������"
End Sub
Public Sub Unsignlongfailed(a$)
MyErMacro a$, "Unsign long to sign failed", "� ��������� �������� ����� ������� �� ������� �� �������, �������"
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

LastErNum = val(" " & Mid$(er$, rinstr(er$, " ")) + ".0")
End If
If LastErNum = 0 Then LastErNum = -1 ': Debug.Print er$, ergr$: Stop
LastErNum1 = LastErNum

If InStr("*" + LastErName, NLtrim$(er$)) = 0 Then
LastErName = RTrim(LastErName) & " " & NLtrim$(er$)
LastErNameGR = RTrim(LastErNameGR) & " " & NLtrim$(ergr$)
End If
End If
End Sub
Sub UnknownVariable1(a$, v$)
Dim i As Long
i = rinstr(v$, "." + ChrW(8191))
If i > 0 Then
    i = rinstr(v$, ".")
    MyErMacro a$, "Unknown Variable " & Mid$(v$, i), "������� ��������� " & Mid$(v$, i)
Else
    i = rinstr(v$, "].")
    If i > 0 Then
        MyErMacro a$, "Unknown Variable " & Mid$(v$, i + 2), "������� ��������� " & Mid$(v$, i + 2)
    Else
        i = rinstr(v$, ChrW(8191))
    If i > 0 Then
        i = InStr(i + 1, v$, ".")
        If i > 0 Then
            MyErMacro a$, "Unknown Variable " & Mid$(v$, i + 1), "������� ��������� " & Mid$(v$, i + 1)
        Else
            MyErMacro a$, "Unknown Variable", "������� ���������"
        End If
    Else
        MyErMacro a$, "Unknown Variable " & v$, "������� ��������� " & v$
    End If
    End If
End If

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
SetWindowRgn m.hWND, hRgn, t
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
DrawCaption m.hWND, m.hDC, r, CLng(par)
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
DrawCaption m.hWND, m.hDC, r, CLng(par)
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
CreateCaret dqq.hWND, 0, dqq.ScaleX(.Xt, 1, 3), dqq.ScaleY((.Yt - .uMineLineSpace * 2) * 0.2, 1, 3)
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
            CreateCaret Form1.ActiveControl.hWND, 0, -1, 0
            End If
            CreateCaret dqq.hWND, 0, -1, 0
        End If
        Exit Sub
End If

If t& = 1 Then
       ' CreateCaret dqq.hWnd, 0, dqq.ScaleX(.Xt, 1, 3), dqq.ScaleY((.Yt - .uMineLineSpace * 2), 1, 3)
       CreateCaret dqq.hWND, 0, dqq.ScaleX(.Xt, 1, 3), dqq.ScaleY(.Yt - .uMineLineSpace * 2, 1, 3)
        SetCaretPos dqq.ScaleX(.curpos * .Xt, 1, 3), dqq.ScaleY(.currow * .Yt + .uMineLineSpace, 1, 3)
        On Error Resume Next
        If Not extreme Then If INK$ = vbNullString Then dqq.Refresh
Else
    CreateCaret dqq.hWND, 0, dqq.ScaleX(.Xt, 1, 3), .Yt \ DYP \ 6 + 1
        
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
                           If Err.Number > 0 Then
                           Err.Clear
                           
                           Set LoadMyPicture = LoadPicture("")
                           End If
                           If LoadMyPicture Is Nothing Then
                           Set LoadMyPicture = LoadPicture("")
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
                            If Err.Number > 0 Then
                           Err.Clear
                          
                           Set LoadMyPicture = LoadPicture("")
                           End If
                           If LoadMyPicture Is Nothing Then
                           Set LoadMyPicture = LoadPicture("")
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
'Dim m As Long
'm = dd.CurrentX + r.Left

DrawText dd.hDC, StrPtr(c), -1, r, DT_SINGLELINE Or DT_CENTER Or DT_NOPREFIX
'dd.CurrentX = m
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

If nounder32(c$) Then ddd.CurrentX = ddd.CurrentX + .Xt: PrintUnicodeStandardWidthAddXT ddd, c$, nr
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
 If nounder32(c$) Then ddd.CurrentX = ddd.CurrentX + .Xt: PrintUnicodeStandardWidthAddXT ddd, c$, nr
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
      
            If nounder32(c$) Then
            
               If Not skip Then
              If a(r * 2 + 2) = 0 And a(r * 2 + 3) <> 0 And a1(r * 2 + 2) < 8 Then
                          Do
                p$ = Mid$(WHAT1$, r + 2, 1)
                If ideographs(p$) Then Exit Do
                If Not nounder32(p$) Then Mid$(WHAT1$, r + 2, 1) = " ": Exit Do
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
        If nounder32(c$) Then
       ' skip = True
             If Not skip Then
           If a(r * 2 + 2) = 0 And a(r * 2 + 3) <> 0 And a1(r * 2 + 2) < 8 Then
            Do
                p$ = Mid$(WHAT1$, r + 2, 1)
                If ideographs(p$) Then Exit Do
                If Not nounder32(p$) Then Mid$(WHAT1$, r + 2, 1) = " ": Exit Do
                c$ = c$ + p$
                r = r + 1
                If r >= r1 Then Exit Do
            Loop Until a(r * 2 + 2) <> 0 Or a(r * 2 + 3) = 0
            End If
         End If
               
      ddd.CurrentX = ddd.CurrentX + .Xt
        
      Else
        If c$ = Chr$(7) Then Beep
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
   ' If nounder32(b$) Then
   If Not b$ = vbCr Then
    If TextWidth(ddd, buf$ & b$) <= (wi& * .Xt) Then
    buf$ = buf$ & b$
    End If
    ElseIf b$ = vbCr Then
    
    If nocr Then Exit For
    MyPrintNew ddd, mb.uMineLineSpace, buf$, Not nocr
    
    
    buf$ = vbNullString
    Hi& = Hi& - 1
    npy = npy + 1
    LCTbasket ddd, mb, npy, PX
    End If
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
If b$ = Chr$(0) Or b$ = vbLf Then
ElseIf Not b$ = vbCr Then
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
'ElseIf b$ = vbCr Then
Else
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
End If

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
    Form5.RestoreSizePos
    Form5.backcolor = 0
    useform1 = True
    Else
    Set ff = Form1
    End If
    x = ff.Left / DXP
    y = ff.Top / DYP
    If useform1 Then Form1.Visible = False
    ff.Hide
    Sleep 50
    MyDoEvents1 ff, True
    
    Dim aa As New cDIBSection
    aa.CreateFromPicture hDCToPicture(GetDC(0), x, y, ff.Width / DXP, ff.Height / DYP)
    aa.ThumbnailPaint ff
    GdiFlush
      ff.Visible = True
      
    If useform1 Then Form1.Visible = True
    
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
                If Not (GetForegroundWindow = Screen.ActiveForm.hWND And Screen.ActiveForm.name = "Form1") Then
                 
                      DestroyCaret
                      nomoveLCTC dq, mybasket, y&, c& + x&, ins&
                      iamactive = False
             Else
                         If ShowCaret(dq.hWND) = 0 Then
                                   HideCaret dq.hWND
                                   .currow = y&
                                   .curpos = c& + x&
                                   LCTCB dq, mybasket, ins&
                                   ShowCaret dq.hWND
                         End If
                End If
                End If
     Else
  If Not Screen.ActiveForm Is Nothing Then
            If GetForegroundWindow = Screen.ActiveForm.hWND And Screen.ActiveForm.name = "Form1" Then
           
                          nomoveLCTC dq, mybasket, y&, c& + x&, ins&
                             iamactive = True
                              If ShowCaret(dq.hWND) = 0 And Screen.ActiveForm.name = "Form1" Then
                                   HideCaret dq.hWND
                                   .currow = y&
                                   .curpos = c& + x&
                                   LCTCB dq, mybasket, ins&
                                   ShowCaret dq.hWND
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

Public Sub ResetPrefresh()
Dim i As Long
For i = -2 To 131
    Prefresh(i).k1 = 0
    Prefresh(i).RRCOUNTER = 0
Next i

End Sub

Sub original(bstack As basetask, COM$)
Dim d As Object, b$

If COM$ <> "" Then QUERYLIST = vbNullString
If Form1.Visible Then REFRESHRATE = 25: ResetPrefresh
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
GDILines = False  ' reset to normal ' use Smooth on to change this to true
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
NoBackFormFirstUse = False
If players(-1).MAXXGRAPH <> 0 Then ClearScrNew Form1, players(-1), 0&
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
    LastErNum = 0
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
If Result = 99 Then v$ = OLDV$
Form1.TEXT1.NumberIntOnly = False
Form1.TEXT1.NumberOnly = False
Else
OLDV$ = v$
ScreenEdit bb, v$, x&, y&, wi& - 1, Hi&, wh&, , n, shiftlittle
If Result = 99 And Hi& = wi& Then v$ = OLDV$
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

Hook Form1.hWND, Nothing '.glistN
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
.mDoc.ColorEvent = True
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
UnHook Form1.hWND
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
Hook Form1.hWND, Nothing
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
If .nowrap Then
.nowrap = False
End If
.Charpos = 0
If Len(a$) < 100000 Then .Render
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

UnHook Form1.hWND
INK$ = vbNullString

escok = oldesc
Set d = Nothing
End Sub

Function blockCheck(ByVal s$, ByVal Lang As Long, countlines As Long, Optional ByVal sbname$ = vbNullString) As Boolean
If s$ = vbNullString Then blockCheck = True: Exit Function
Dim i As Long, j As Long, c As Long, b$, resp&
Dim openpar As Long, oldi As Long
countlines = 1
Lang = Not Lang
Dim a1 As Boolean
Dim jump As Boolean
If Trim(s$) = vbNullString Then Exit Function
c = Len(s$)
a1 = True
i = 1
Do
Select Case AscW(Mid$(s$, i, 1))
Case 13

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
    If Not Lang Then
        b$ = sbname$ + "Problem in string in line " + CStr(countlines)
    Else
        b$ = sbname$ + "�������� �� �� ������������� ��� ������ " + CStr(countlines)
    End If
    resp& = ask(b$, True)
If resp& <> 4 Then
blockCheck = True
End If
Exit Function
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
    If Not Lang Then
        b$ = sbname$ + "Problem in string in line " + CStr(countlines)
    Else
        b$ = sbname$ + "�������� �� �� ������������� ��� ������ " + CStr(countlines)
    End If
    resp& = ask(b$, True)
If resp& <> 4 Then
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
If openpar <> 0 And j > 0 Then
If Not Lang Then
        b$ = sbname$ + "Problem in parenthesis in line " + CStr(countlines)
    Else
        b$ = sbname$ + "�������� �� ��� ����������� ��� ������ " + CStr(countlines)
    End If
    resp& = ask(b$, True)
If resp& <> 4 Then
blockCheck = True
End If
    Exit Function

End If
j = j + 1: If j = 1 Then Exit Do
Case Else
jump = False

End Select
i = i + 1
Loop Until i > c
If openpar <> 0 Then
If Not Lang Then
        b$ = sbname$ + "Problem in parenthesis in line " + CStr(countlines)
    Else
        b$ = sbname$ + "�������� �� ��� ����������� ��� ������ " + CStr(countlines)
    End If
    resp& = ask(b$, True)
If resp& <> 4 Then
blockCheck = True

End If

End If
If j = 0 Then

ElseIf j < 0 Then
    If Not Lang Then
        b$ = sbname$ + "Problem in blocks - look } are less " + CStr(Abs(j))
    Else
        b$ = sbname$ + "�������� �� �� ������� - ��� �� } ����� �������� " + CStr(Abs(j))
    End If
resp& = ask(b$, True)
Else
If Not Lang Then
b$ = sbname$ + "Problem in blocks - look { are less " + CStr(j)
Else
b$ = sbname$ + "�������� �� �� ������� - ��� �� { ����� �������� " + CStr(j)
End If
resp& = ask(b$, True)
End If
If resp& <> 4 Then
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
Hook Form1.hWND, Form1.List1
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
UnHook Form1.hWND
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
'NOEDIT = False
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
    
    Loop Until loadfileiamloaded = False Or LastErNum <> 0
    Modalid = mycode
    MOUT = False
    Do
    drop = mouse Or KeyPressed(&H1B)
    MyDoEvents

    Loop Until drop = 0 Or MOUT Or LastErNum <> 0
 ' NOEDIT = True
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

Form1.KeyPreview = Not Form1.gList1.Visible
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

Sub Pr_Back(dd As Object, Optional msize As Single = 0)
SetText dd
If msize > 0 Then
SetTextSZ dd, msize
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
If GetForegroundWindow = Form1.hWND Then
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
If Not QRY Then HideCaret dq.hWND:   Exit Do

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
 If ShowCaret(dq.hWND) = 0 Then
 
   LCTCB dq, prive, 0
  End If
If Not bstack.IamThread Then

MyDoEvents1 Form1  'SleepWait 1
End If

 If Screen.ActiveForm Is Nothing Then
 iamactive = False:  If ShowCaret(dq.hWND) <> 0 Then HideCaret dq.hWND
Else
 
    If Not GetForegroundWindow = Screen.ActiveForm.hWND Then
    iamactive = False:  If ShowCaret(dq.hWND) <> 0 Then HideCaret dq.hWND
  
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
iamactive = GetForegroundWindow = Screen.ActiveForm.hWND
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
   If ShowCaret(dq.hWND) <> 0 Then DestroyCaret
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
            If ShowCaret(dq.hWND) <> 0 Then DestroyCaret
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
Dim sV As Long
With players(GetCode(d1))
sV = BitBlt(d1.hDC, CLng(d1.ScaleX(x1, 1, 3)), CLng(d1.ScaleY(y1, 1, 3)), CLng(d1.ScaleX(w, 1, 3)), CLng(d1.ScaleY(h, 1, 3)), d1.hDC, CLng(d1.ScaleX(.XGRAPH, 1, 3)), CLng(d1.ScaleY(.YGRAPH, 1, 3)), SRCCOPY)
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
Form4.moveMe

If Form1.Visible Then
If Form1.DIS.Visible Then
  ''  If Abs(Val(hueconvSpecial(mycolor(uintnew(&H80000018)))) - Val(hueconvSpecial(-Paper))) > Abs(Val(hueconvSpecial(mycolor(uintnew(&H80000003)))) - Val(hueconvSpecial(-Paper))) Then
  If Abs(hueconv(mycolor(uintnew(&H80000018))) - val(hueconv(players(0).Paper))) > 10 And Not Abs(lightconv(mycolor(uintnew(&H80000018))) - val(lightconv(players(0).Paper))) < 50 Then
    Form4.backcolor = &H80000018
    Form4.label1.backcolor = &H80000018
    
    Else
    
    Form4.backcolor = &H80000003
    Form4.label1.backcolor = &H80000003
    End If

Else
''If Abs(Val(hueconvSpecial(mycolor(&H80000018))) - Val(hueconvSpecial(Form1.BackColor))) > Abs(Val(hueconvSpecial(mycolor(&H80000003))) - Val(hueconvSpecial(Form1.BackColor))) Then
     If Abs(hueconv(mycolor(uintnew(&H80000018))) - val(hueconv(Form1.backcolor))) > 10 And Not Abs(lightconv(mycolor(uintnew(&H80000018))) - val(lightconv(Form1.backcolor))) < 50 Then

    Form4.backcolor = &H80000018
    Form4.label1.backcolor = &H80000018
    Else
    
    Form4.backcolor = &H80000003
    Form4.label1.backcolor = &H80000003
    End If
End If
End If
With Form4.label1
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
.glistN.WordCharLeft = ConCat(":", "{", "}", "[", "]", ",", "!", ";", "=", ">", "<", "'", """", " ", "+", "-", "/", "*", "^")
.glistN.WordCharRight = ConCat(":", "{", "}", "[", "]", ",", "!", ";", "=", ">", "<", "'", """", " ", "+", "-", "/", "*", "^")
.glistN.WordCharRightButIncluded = ChrW(160)
End If
.enabled = True
.NewTitle vH_title$, (4 + UAddPixelsTop) * Helplastfactor
.glistN.ShowMe
End With


'Form4.ZOrder
Form4.label1.glistN.DragEnabled = Not abt
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
                Form2.label1(0) = vbNullString
                Form2.label1(1) = vbNullString
                Form2.label1(2) = vbNullString
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
            ElseIf d$ = "EXT" Then
            wide = False
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
            Form2.label1(0) = vbNullString
            Form2.label1(1) = vbNullString
            Form2.label1(2) = vbNullString
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
            ElseIf d$ = "EXT" Then
            wide = True
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
                If Mid$(a$, pos + 1, 1) Like "[&@#%~]" Then pos = pos + 1
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
c = Len(s$)
i = pos1
If i > c Then blockStringAhead = c: Exit Function
Do

Select Case AscW(Mid$(s$, i, 1))
Case 34
Do While i < c
i = i + 1
If AscW(Mid$(s$, i, 1)) = 34 Then Exit Do

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

Public Function CheckStackObj(bstack As basetask, anything As Object, Optional counter As Long) As Boolean
If TypeOf bstack.lastobj Is mHandler Then
        If bstack.lastobj.t1 <> 3 Then Exit Function
        counter = bstack.lastobj.index_cursor + 1
        Set anything = bstack.lastobj
        Set bstack.lastobj = Nothing
        If CheckDeepAny(anything) Then CheckStackObj = True
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
ElseIf Not TaskMaster.Processing And TaskMaster.QueueCount = 0 Then
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
        
          ReadUnicodeOrANSI = StrConv(Space$(BLen), vbFromUnicode)
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
       Dim notok As Boolean
      If ContainsUTF8(buf()) Then 'maybe is utf-8
      feedback = 2
      nobom = -1
        ReDim b(0 To BLen - 1): Get FNr, 1, b
            WChars = MultiByteToWideChar(65001, 0, b(0), BLen, 0, 0)
            ReadUnicodeOrANSI = Space$(WChars)
            MultiByteToWideChar 65001, 0, b(0), BLen, StrPtr(ReadUnicodeOrANSI), WChars
        Else
        notok = True
        
        
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
        End If
        If notok Then
        ReDim b(0 To BLen - 1): Get FNr, 1, b
        If BLen Mod 2 = 1 Then
        ReadUnicodeOrANSI = StrConv(Space$(BLen), vbFromUnicode)
        Else
        ReadUnicodeOrANSI = Space$(BLen \ 2)
        End If
         CopyMemory ByVal StrPtr(ReadUnicodeOrANSI), b(0), BLen
         
         cLid = FoundLocaleId(Left$(ReadUnicodeOrANSI, 500))
         
         
         
        ReadUnicodeOrANSI = StrConv(ReadUnicodeOrANSI, vbUnicode, cLid)
        'End If
        End If
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
Dim buf1() As Byte
buf1 = StrConv(buf, vbFromUnicode, cLid)
Put #w, , buf1()
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
Dim a() As Byte
a() = StrConv(s, vbFromUnicode, cLid)

Put #F, , a()
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

s1 = ChrW(AscW(ChrW(AscW(StrConv(ChrW(a), vbUnicode, cLid)))))
If s1 <> vbCr And s1 <> vbLf Then
s = s + s1
Else
If Not (LOF(F) < Seek(F)) Then
ss = Seek(F)
Get #F, , a
lbreak = s1
s1 = ChrW(AscW(ChrW(AscW(StrConv(ChrW(a), vbUnicode, cLid)))))

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
s1 = ChrW(AscW(StrConv(ChrW(a), vbUnicode, cLid)))
If s1 <> " " Then
If nochar34 Then s = s1: Exit Do
If s1 = """" Then inside = True: Exit Do

End If
Loop
' we throw the first
If Not nochar34 Then If s1 <> """" Then Exit Sub

Do While Not (LOF(F) < Seek(F))
Get #F, , a

s1 = ChrW(AscW(StrConv(ChrW(a), vbUnicode, cLid)))
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
s1 = ChrW(AscW(StrConv(ChrW(a), vbUnicode, cLid)))

If s1 = vbCr Or s1 = vbLf Or s1 = inpcsvsep$ Then Exit Do

Loop
there:
If s1 = inpcsvsep$ Then Exit Do
End If
If s1 <> inpcsvsep$ And (Not (LOF(F) < Seek(F))) And (Not inside) Then
    ss = Seek(F)
    Get #F, , a
    s1 = ChrW(AscW(StrConv(ChrW(a), vbUnicode, cLid)))
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

s1 = ChrW(AscW(StrConv(ChrW(a), vbUnicode, cLid)))
If s1 <> vbCr And s1 <> vbLf And s1 <> inpcsvsep$ Then
s = s + s1
Else
If s1 <> inpcsvsep$ And Not (LOF(F) < Seek(F)) Then
    ss = Seek(F)
    Get #F, , a
    s1 = ChrW(AscW(StrConv(ChrW(a), vbUnicode, cLid)))
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
             If x.hWND = GetForegroundWindow Then
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
Public Function CheckIsmArray(obj As Object) As Boolean
Dim oldobj As Object
If obj Is Nothing Then Exit Function
Set oldobj = obj

Dim kk As Long
again:
If kk > 20 Then Set obj = oldobj: Exit Function
If TypeOf obj Is mHandler Then
    If obj.t1 = 3 Then
        If obj.indirect >= 0 And obj.indirect <= var2used Then
                Set obj = var(obj.indirect)
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
Public Function CheckIsmArrayOrStackOrCollection(obj As Object) As Boolean
Dim oldobj As Object
If obj Is Nothing Then Exit Function
Set oldobj = obj

Dim kk As Long
again:
If kk > 20 Then Set obj = oldobj: Exit Function
If TypeOf obj Is mHandler Then
    If obj.t1 <> 2 Then
        If obj.indirect >= 0 And obj.indirect <= var2used Then
                Set obj = var(obj.indirect)
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
Public Function CheckDeepAny(obj As Object) As Boolean
Dim oldobj As Object
If obj Is Nothing Then Exit Function
Set oldobj = obj

Dim kk As Long
again:
If kk > 20 Then Set obj = oldobj: Exit Function
If TypeOf obj Is mHandler Then
    If obj.t1 = 3 Then
        If obj.indirect >= 0 And obj.indirect <= var2used Then
                Set obj = var(obj.indirect)
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
Public Function CheckLastHandler(obj As Object) As Boolean
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
                Set obj = var(obj.indirect)
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
Public Function CheckLastHandlerVariant(obj) As Boolean
Dim oldobj As Object, first As Object
If obj Is Nothing Then Exit Function
Set first = obj

Dim kk As Long
again:
If kk > 20 Then Set obj = first: Exit Function
If obj Is Nothing Then Exit Function
If TypeOf obj Is mHandler Then
    'If obj.t1 = 3 Then
        If obj.indirect >= 0 And obj.indirect <= var2used Then
                Set oldobj = obj
                Set obj = var(obj.indirect)
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
If Not oldobj Is Nothing Then Set obj = oldobj: Set oldobj = Nothing: CheckLastHandlerVariant = True: Exit Function
Set obj = first
End Function
Public Function CheckLastHandlerOrIterator(obj As Object, lastindex As Long) As Boolean
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
                Set obj = var(obj.indirect)
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
Public Sub NoEnumaretor()
  MyEr "No enumarator found for this object", "��� ����� ������ �������� ��� ���� �� �����������"
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
Public Sub MissString()
MyEr "Missing string", "������ �������������"
End Sub
Public Sub MissStringNumber()
MyEr "Missing string or number", "������ ������������� � �������"
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
MyEr "File/Folder Selector in Use", "� ����� �������� �������/������� ����� �� �����"
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
Public Sub MissingEnumBlock()
MyEr "missing block {} for enumeration constants", "������ ����� {} ��� �������� ����������� "
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
Public Sub UnknownVariable(v$)
Dim i As Long
i = rinstr(v$, "." + ChrW(8191))
If i > 0 Then
    i = rinstr(v$, ".")
    MyEr "Unknown Variable " & Mid$(v$, i), "������� ��������� " & Mid$(v$, i)
Else
    i = rinstr(v$, "].")
    If i > 0 Then
        MyEr "Unknown Variable " & Mid$(v$, i + 2), "������� ��������� " & Mid$(v$, i + 2)
    Else
        i = rinstr(v$, ChrW(8191))
    If i > 0 Then
        i = InStr(i + 1, v$, ".")
        If i > 0 Then
            MyEr "Unknown Variable " & Mid$(v$, i + 1), "������� ��������� " & Mid$(v$, i + 1)
        Else
            MyEr "Unknown Variable", "������� ���������"
        End If
    Else
        MyEr "Unknown Variable " & v$, "������� ��������� " & v$
    End If
    End If
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
Public Sub NoObjectpAssignToInteger()
MyEr "Can't assign object to Integer", "��� ����� �� ���� ����������� ���� �������"
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
MyEr "Wrong object type", "����� ����� ������������"
End Sub
Public Sub WrongType()
MyEr "Wrong type", "����� �����"
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
MyErMacro a$, "not an expression after not operator", "��� ������� ��������� ����� ��� ������� ���"
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
MyEr "Can't find " + w$ + " or type name", "��� ����� �� ��� �� " + w$ + " � ����� �����"
End Sub
Public Sub OverflowLong(Optional b As Boolean = False)
If b Then
MyEr "OverFlow Integer", "Y���������� ��������"
Else
MyEr "OverFlow Long", "Y���������� �����"
End If
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
Public Sub nonext()
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
                    Case "a":       ch = Chr$(7)
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
Case vbInteger
v = CInt(v)
Case Else
v = CDbl(v)
End Select
AssignTypeNumeric = True
Exit Function
there:
If Err = 6 Then
OverflowLong i = vbInteger
Exit Function
End If
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
' obsolate
End Sub
Public Sub GarbageFlush2()
'obsolate
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
       ' If bstack.UseGroupname <> "" Then
       ' .lasthere = Mid$(bstack.UseGroupname, 1, Len(bstack.UseGroupname) - 1)
       ' Else
        .lasthere = here$
       ' End If
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

Sub monitor(bstack As basetask, prive As basket, Lang As Long)
    Dim ss$, di As Object
    Set di = bstack.Owner
    If Lang = 0 Then
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
        If wide Then ss$ = ss$ + " +EXT" Else ss$ = ss$ + " -EXT"
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
          If wide Then ss$ = ss$ + " +EXT" Else ss$ = ss$ + " -EXT"
        If SecureNames Then ss$ = ss$ + " +SEC" Else ss$ = ss$ + " -SEC"
        wwPlain bstack, prive, "Switches " + ss$, bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "About Switches: use command Help Switches", bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "Screens:" + Str$(DisplayMonitorCount()) + "  Primary is:" + Str$(FindPrimary + 1), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "This form is in screen:" + Str$(FindFormSScreen(di) + 1), bstack.Owner.Width, 1000, True
        wwPlain bstack, prive, "Console is in screen:" + Str$(Console + 1), bstack.Owner.Width, 1000, True
    End If
End Sub
Sub NeoSwap(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MySwap(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoComm(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyRead(3, ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoRef(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyRead(2, ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoRead(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyRead(1, ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoReport(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyReport(ObjFromPtr(basestackLP), rest$, Lang)
End Sub

Sub NeoDeclare(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyDeclare(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoMethod(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyMethod(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoWith(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyWith(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoSprite(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
Dim s$, p
If IsStrExp(ObjFromPtr(basestackLP), rest$, s$) Then
sprite ObjFromPtr(basestackLP), s$, rest$
ElseIf IsExp(ObjFromPtr(basestackLP), rest$, p) Then
spriteGDI ObjFromPtr(basestackLP), rest$
End If
resp = LastErNum1 = 0
End Sub

Sub NeoPlayer(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcPlayer(ObjFromPtr(basestackLP), rest$, Lang)
End Sub

Sub NeoPrinter(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcPrinter(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoPage(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
ProcPage ObjFromPtr(basestackLP), rest$, Lang
resp = True
End Sub
Sub NeoCompact(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
BaseCompact ObjFromPtr(basestackLP), rest$
resp = True
End Sub
Sub NeoLayer(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcLayer(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoOrder(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
MyOrder ObjFromPtr(basestackLP), rest$
resp = True
End Sub

Sub NeoDelete(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = DELfields(ObjFromPtr(basestackLP), rest$)
'resp = True  '' maybe this can be change
End Sub
Sub NeoAppend(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
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
Sub NeoSearch(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
getrow ObjFromPtr(basestackLP), rest$, , "", Lang
resp = True
End Sub
Sub NeoRetr(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
getrow ObjFromPtr(basestackLP), rest$, , , Lang
resp = True
End Sub
Sub NeoExecute(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
If IsLabelSymbolNew(rest$, "������", "CODE", Lang) Then
 resp = ExecCode(ObjFromPtr(basestackLP), rest$)
 Else
CommExecAndTimeOut ObjFromPtr(basestackLP), rest$
resp = True
End If

End Sub

Sub NeoTable(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
NewTable ObjFromPtr(basestackLP), rest$
resp = True
End Sub
Sub NeoBase(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
NewBase ObjFromPtr(basestackLP), rest$
resp = True
End Sub
Sub NeoHold(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcHold(ObjFromPtr(basestackLP))
End Sub
Sub NeoRelease(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcRelease(ObjFromPtr(basestackLP))
End Sub
Sub NeoSuperClass(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcClass(ObjFromPtr(basestackLP), rest$, Lang, True)
End Sub
Sub NeoClass(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcClass(ObjFromPtr(basestackLP), rest$, Lang, False)
End Sub
Sub NeoDIM(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyDim(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoPathDraw(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcPath(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoDrawings(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyDrawings(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoFill(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcFill(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoFloodFill(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcFLOODFILL(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoTextCursor(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyCursor(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoMouseIcon(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
i3MouseIcon ObjFromPtr(basestackLP), rest$, Lang
resp = True
End Sub
Sub NeoDouble(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
Dim bstack As basetask
Set bstack = ObjFromPtr(basestackLP)
SetDouble bstack.Owner
Set bstack = Nothing
resp = True
End Sub
Sub NeoNormal(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
Dim bstack As basetask
Set bstack = ObjFromPtr(basestackLP)
SetNormal bstack.Owner
Set bstack = Nothing
resp = True
End Sub
Sub NeoSort(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcSort(ObjFromPtr(basestackLP), rest$, Lang)
End Sub

Sub NeoImage(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcImage(ObjFromPtr(basestackLP), rest$, Lang)
End Sub

Sub NeoBitmaps(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyBitmaps(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoDef(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcDef(ObjFromPtr(basestackLP), rest$, Lang)
End Sub

Sub NeoMovies(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyMovies(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoSounds(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MySounds(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoPen(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcPen(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoCls(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcCls(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoStructure(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = myStructure(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoInput(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyInput(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoEvent(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = myEvent(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoProto(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcProto(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoEnum(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcEnum(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoModule(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyModule(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoModules(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyModules(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoGroup(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcGroup(0, ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoBack(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
ProcBackGround ObjFromPtr(basestackLP), rest$, Lang, resp
End Sub
Sub NeoOver(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcOver(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoDrop(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcDrop(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoShift(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcShift(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoShiftBack(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcShiftBack(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoLoad(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcLoad(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoText(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcText(ObjFromPtr(basestackLP), False, rest$)
End Sub
Sub NeoHtml(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcText(ObjFromPtr(basestackLP), True, rest$)
End Sub

Sub NeoCurve(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcCurve(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoPoly(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcPoly(ObjFromPtr(basestackLP), rest$, Lang)
End Sub

Sub NeoCircle(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcCircle(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoNew(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyNew(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoTitle(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcTitle(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoDraw(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcDraw(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoWidth(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcDrawWidth(ObjFromPtr(basestackLP), rest$)
End Sub

Sub NeoMove(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcMove(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoStep(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcStep(ObjFromPtr(basestackLP), rest$, Lang)
End Sub

Sub NeoPrint(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = RevisionPrint(ObjFromPtr(basestackLP), rest$, 0, Lang)
End Sub
Sub NeoCopy(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyCopy(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoPrinthEX(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = RevisionPrint(ObjFromPtr(basestackLP), rest$, 1, Lang)
End Sub
Sub NeoRem(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
    SetNextLineNL rest$
    resp = True
End Sub
Sub NeoPush(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyPush(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoData(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyData(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoClear(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyClear(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoLinespace(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = procLineSpace(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoSet(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = interpret(ObjFromPtr(basestackLP), GetNextLine(rest$))
End Sub


Sub NeoBold(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
ProcBold ObjFromPtr(basestackLP), rest$
resp = True
End Sub
Sub NeoChooseObj(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
    resp = ProcChooseObj(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoChooseFont(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
    ProcChooseFont ObjFromPtr(basestackLP), Lang
    resp = True
End Sub
Sub NeoFont(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
    ProcChooseFont ObjFromPtr(basestackLP), Lang
    resp = True
End Sub
Sub NeoScore(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyScore(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoPlayScore(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyPlayScore(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoMode(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcMode(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoGradient(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcGradient(ObjFromPtr(basestackLP), rest$)
End Sub
Sub NeoFunction(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyFunction(0, ObjFromPtr(basestackLP), rest$, Lang)
End Sub

Sub NeoFiles(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcFiles(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoCat(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = ProcCat(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Sub NeoLet(basestackLP As Long, rest$, Lang As Long, resp As Boolean)
resp = MyLet(ObjFromPtr(basestackLP), rest$, Lang)
End Sub
Function GetArrayReference(bstack As basetask, a$, v$, PP, Result As mArray, index As Long) As Boolean
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
                    
                    
                        Set Result = pppp
                        index = w2
    End If
End Function
Function ProcessArray(bstack As basetask, a$, v$, PP, Result) As Boolean
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
                        Set Result = pppp.item(w2)
                    Else
                        Result = pppp.item(w2)
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
Public Function IsSupervisor() As Boolean

Dim ss$
                 ss$ = UCase(userfiles)
                    DropLeft "\M2000_USER\", ss$
IsSupervisor = ss$ = vbNullString
End Function


Public Function UserPath() As String

Dim ss$
                 ss$ = UCase(userfiles)
                    DropLeft "\M2000_USER\", ss$
        If ss$ <> "" Then
        If CanKillFile(mcd) Then
        DropLeft "\", ss$
UserPath = Mid$(mcd, Len(userfiles) - Len(ss$) + 1)
If UserPath = vbNullString Then
UserPath = "."
End If
Else
UserPath = mcd
End If
Else
UserPath = mcd
End If
End Function
Public Function UserPath2() As String

Dim ss$
                 ss$ = UCase(userfiles)
                    DropLeft "\M2000_USER\", ss$
        If ss$ <> "" Then
        If CanKillFile(mcd) Then
        DropLeft "\", ss$
UserPath2 = Mid$(mcd, Len(userfiles) - Len(ss$) + 1)
If UserPath2 = vbNullString Then
UserPath2 = "."
End If
Else
UserPath2 = mcd
End If
Else
UserPath2 = mcd
End If
If Right$(UserPath2, 1) = "\" Then UserPath2 = Left$(UserPath2$, Len(UserPath2$) - 1)


End Function
Function Fast2Label(a$, c$, cl As Long, d$, dl As Long, ahead&) As Boolean
Dim i As Long, Pad$, j As Long
j = Len(a$)
If j = 0 Then Exit Function
i = MyTrimL(a$)
If i > j Then Exit Function
Pad$ = myUcase(Mid$(a$, i, ahead& + 1)) + " "
If j - i >= cl - 1 Then
If InStr(c$, Left$(Pad$, cl)) > 0 Then
If Mid$(Pad$, cl + 1, 1) Like "[0-9+.\( @-]" Then
a$ = Mid$(a$, MyTrimLi(a$, i + cl))
Fast2Label = True
End If
Exit Function
End If
End If
If j - i >= dl - 1 Then
If InStr(d$, Left$(Pad$, dl)) > 0 Then
If Mid$(Pad$, dl + 1, 1) Like "[0-9+.\( @-]" Then
a$ = Mid$(a$, MyTrimLi(a$, i + dl))
Fast2Label = True
End If
End If
End If
End Function
Function Fast2Symbol(a$, c$, k As Long, d$, l As Long) As Boolean
Dim i As Long, j As Long
j = Len(a$)
If j = 0 Then Exit Function
i = MyTrimL(a$)
If i > j Then Exit Function
If j - i >= k - 1 Then
    If InStr(c$, Mid$(a$, i, k)) > 0 Then
    a$ = Mid$(a$, MyTrimLi(a$, i + k))
    Fast2Symbol = True
    Exit Function
    End If
End If
'If j - i >= Len(d$) - 1 Then
If j - i >= l - 1 Then
    If InStr(d$, Mid$(a$, i, l)) > 0 Then
    a$ = Mid$(a$, MyTrimLi(a$, i + l))
    Fast2Symbol = True
    Exit Function
    End If

End If
End Function
Function FastOperator2(a$, c$, i As Long) As Boolean
If Mid$(a$, i, 1) = c$ Then
Mid$(a$, i, 1) = " "
FastOperator2 = True
End If
End Function
Function FastOperator2char(a$, c$, i As Long) As Boolean
If Mid$(a$, i, 2) = c$ Then
Mid$(a$, i, 2) = "  "
FastOperator2char = True
End If
End Function
Function FastOperator(a$, c$, i As Long, Optional cl As Long = 1, Optional Remove As Boolean = True) As Boolean
Dim j As Long
If i <= 0 Then i = 1
j = Len(a$)
If j = 0 Then Exit Function
i = MyTrimLi(a$, i)
If i > j Then i = 1 ' no spaces
If j - i < cl - 1 Then Exit Function
If InStr(c$, Mid$(a$, i, cl)) > 0 Then
If Remove Then Mid$(a$, i, cl) = Space$(cl)
FastOperator = True
End If
End Function
Function FastType(a$, c$) As Boolean
Dim i As Long, j As Long, cl, part$
cl = Len(c$)
j = Len(a$)
If j = 0 Then Exit Function
i = MyTrimL(a$)
If i > j Then Exit Function  ' this is not good
If j - i < cl - 1 Then
Exit Function
End If
If IsLabelOnly(Mid$(a$, i, cl + 1), part$) = 1 Then

If c$ = part$ Then
a$ = Mid$(a$, MyTrimLi(a$, i + cl))
FastType = True
End If
End If
End Function
Function FastSymbol(a$, c$, Optional mis As Boolean = False, Optional cl As Long = 1) As Boolean
Dim i As Long, j As Long
j = Len(a$)
If j = 0 Then Exit Function
i = MyTrimL(a$)
If i > j Then Exit Function  ' this is not good
If j - i < cl - 1 Then
If mis Then MyEr "missing " & c$, "������ " & c$
Exit Function
End If
If InStr(c$, Mid$(a$, i, cl)) > 0 Then
a$ = Mid$(a$, MyTrimLi(a$, i + cl))
'Mid$(a$, i, cl) = Space$(cl)
FastSymbol = True
ElseIf mis Then
MyEr "missing " & c$, "������ " & c$
End If
End Function
Function NocharsInLine(a$) As Boolean
Dim i As Long, j As Long
j = Len(a$)
If j = 0 Then NocharsInLine = True: Exit Function
i = MyTrimL(a$)
If i > j Then NocharsInLine = True: Exit Function

End Function
Sub DropCommentOrLine(a$)
Dim i As Long, j As Long
again:
j = Len(a$)
If j = 0 Then a$ = vbNullString:  Exit Sub
i = MyTrimL(a$)
If i > j Then a$ = vbNullString: Exit Sub
Select Case AscW(Mid$(a$, i, 1))
Case 39, 92
' drop line
i = InStr(i, a$, vbLf)
If i = 0 Then a$ = vbNullString Else a$ = Mid$(a$, i + 1): GoTo again
Case 13
' drop one line
Mid$(a$, 1, i + 1) = Space$(i + 1)
GoTo again
Case Else
If i > 1 Then Mid$(a$, 1, i - 1) = Space$(i - 1)
End Select


End Sub
Function MaybeIsTwoSymbol(a$, c$, Optional l As Long = 2) As Boolean
Dim i As Long
If a$ = vbNullString Then Exit Function
i = MyTrimL(a$)
If i > Len(a$) Then Exit Function
MaybeIsTwoSymbol = InStr(c$, Mid$(a$, i, 2)) > 0

End Function
Function MaybeIsSymbol(a$, c$) As Boolean
Dim i As Long
If a$ = vbNullString Then Exit Function
i = MyTrimL(a$)
If i > Len(a$) Then Exit Function
MaybeIsSymbol = InStr(c$, Mid$(a$, i, 1)) > 0
End Function
Function MaybeIsSymbol2(a$, c$, i As Long) As Boolean
'' for isnumber
If a$ = vbNullString Then Exit Function
i = MyTrimL(a$)
If i > Len(a$) Then Exit Function
MaybeIsSymbol2 = InStr(c$, Mid$(a$, i, 1)) > 0
End Function


Function MaybeIsSymbolNoSpace(a$, c$) As Boolean
MaybeIsSymbolNoSpace = Left$(a$, 1) Like c$
End Function
Function IsLabelSymbolNew(a$, gre$, Eng$, code As Long, Optional mis As Boolean = False, Optional ByVal ByPass As Boolean = False, Optional checkonly As Boolean = False, Optional Free As Boolean = True) As Boolean
' code 2  gre or eng, set new value to code 1 or 0
' 0 for gre
' 1 for eng
' return true if we have label
Dim what As Boolean, drop$
Select Case code
Case 0
IsLabelSymbolNew = IsLabelSymbol3(1032, a$, gre$, drop$, mis, ByPass, checkonly, Free)
Case 1
IsLabelSymbolNew = IsLabelSymbol3(1033, a$, Eng$, drop$, mis, ByPass, checkonly, Free)
Case 2
what = IsLabelSymbol3(1032, a$, gre$, drop$, mis, ByPass, checkonly, Free)
If what Then
code = 0
IsLabelSymbolNew = what
Exit Function
End If
what = IsLabelSymbol3(1033, a$, Eng$, drop$, mis, ByPass, checkonly, Free)
If what Then code = 1
IsLabelSymbolNew = what
End Select
End Function
Function IsLabelSymbolNewExp(a$, gre$, Eng$, code As Long, usethis$) As Boolean
' code 2  gre or eng, set new value to code 1 or 0
' 0 for gre
' 1 for eng
' return true if we have label
If Len(usethis$) = 0 Then
Dim what As Boolean
Select Case code
Case 0
IsLabelSymbolNewExp = IsLabelSymbol3(1032, a$, gre$, usethis$, False, False, False, True)
Case 1
IsLabelSymbolNewExp = IsLabelSymbol3(1033, a$, Eng$, usethis$, False, False, False, True)
Case 2
what = IsLabelSymbol3(1032, a$, gre$, usethis$, False, False, False, True)
If what Then
code = 0
IsLabelSymbolNewExp = what
Exit Function
End If
what = IsLabelSymbol3(1033, a$, Eng$, usethis$, False, False, False, True)
If what Then code = 1
IsLabelSymbolNewExp = what
End Select
Else
Select Case code
Case 0, 2
IsLabelSymbolNewExp = gre$ = usethis$
Case 1
IsLabelSymbolNewExp = Eng$ = usethis$
End Select
If IsLabelSymbolNewExp Then a$ = Mid$(a$, MyTrimL(a$) + Len(usethis$))
End If
If IsLabelSymbolNewExp Then
usethis$ = vbNullString
End If
End Function


Function IsLabelSymbol3(ByVal code As Double, a$, c$, useth$, Optional mis As Boolean = False, Optional ByVal ByPass As Boolean = False, Optional checkonly As Boolean = False, Optional needspace As Boolean = False) As Boolean
Dim test$, what$, pass As Long
If ByPass Then Exit Function

If a$ <> "" And c$ <> "" Then
    test$ = a$
    If Right$(c$, 1) <= "9" Then
        If FastSymbol(test$, c$, , Len(c$)) Then
            If needspace Then
                If test$ = vbNullString Then
                ElseIf AscW(test$) < 36 Then
                ElseIf InStr(":;\',", Left$(test$, 1)) > 0 Then ' : ; ,
                Else
                    Exit Function
                End If
            End If
            If Not checkonly Then a$ = test$
            IsLabelSymbol3 = True
        Else
            If mis Then MyEr "missing " & c$, "������ " & c$
        End If
        Exit Function
    Else
        pass = 1000 ' maximum
        IsLabelSymbol3 = IsLabelSYMB33(test$, what$, pass)
   
      If Len(what$) <> Len(c$) Then
               If code = 1032 Then
                useth$ = myUcase(what$, True)
            Else
                useth$ = UCase(what$)
            End If
      IsLabelSymbol3 = False
         If mis Then GoTo theremiss
        Exit Function
      End If
    End If
    If what$ = vbNullString Then
    
        If mis Then GoTo theremiss
        Exit Function
    End If
    If code = 1032 Then
        what$ = myUcase(what$, True)
    Else
        what$ = UCase(what$)
    End If
    If what$ = c$ Then
    
        test$ = Mid$(test$, pass)
        If needspace Then
            If test$ = vbNullString Then
            ElseIf AscW(test$) < 36 Then
            ElseIf InStr(":;\',", Left$(test$, 1)) > 0 Then
            ' : ; ,
            Else
                IsLabelSymbol3 = False
                Exit Function
            End If
        End If
        If checkonly Then
          '  A$ = what$ & TEST$
          Else
           a$ = test$
        End If
  
       Else
             If mis Then
theremiss:
           ''  MyErMacro a$, "missing " & c$, "������ " & c$
                 MyEr "missing " & c$, "������ " & c$
                 Else
                 useth$ = what$
              End If
            IsLabelSymbol3 = False
            End If
Else
If mis Then GoTo theremiss
End If
End Function
Function IsLabelSymbol(a$, c$, Optional mis As Boolean = False, Optional ByVal ByPass As Boolean = False, Optional checkonly As Boolean = False) As Boolean
Dim test$, what$, pass As Long
If ByPass Then Exit Function

  If a$ <> "" And c$ <> "" Then
test$ = a$
pass = Len(c$)

IsLabelSymbol = IsLabelSYMB33(test$, what$, pass)
If Len(what$) <> Len(c$) Then IsLabelSymbol = False
If Not IsLabelSymbol Then
     If mis Then
                 MyEr "missing " & c$, "������ " & c$
              End If
Exit Function
End If

        If myUcase(what$) = c$ Then
        If checkonly Then
     '   A$ = what$ & " " & TEST$
        Else
                    a$ = Mid$(test$, pass)
          End If
  
             Else
             If mis Then
                 MyEr "missing " & c$, "������ " & c$
              End If
            IsLabelSymbol = False
            End If

End If
End Function
Function IsLabelSymbolLatin(a$, c$, Optional mis As Boolean = False, Optional ByVal ByPass As Boolean = False, Optional checkonly As Boolean = False) As Boolean
Dim test$, what$, pass As Long
If ByPass Then Exit Function

  If a$ <> "" And c$ <> "" Then
test$ = a$
pass = Len(c$)
IsLabelSymbolLatin = IsLabelSYMB33(test$, what$, pass)
If Len(what$) <> Len(c$) Then IsLabelSymbolLatin = False
If Not IsLabelSymbolLatin Then
             If mis Then
                 MyEr "missing " & c$, "������ " & c$
              End If
            Exit Function
End If
        If UCase(what$) = c$ Then
        If checkonly Then
      '  A$ = what$ & " " & TEST$
        Else
                    a$ = Mid$(test$, pass)
          End If
  
             Else
             If mis Then
                 MyEr "missing " & c$, "������ " & c$
              End If
            IsLabelSymbolLatin = False
            End If

End If
End Function

Function GetRes(bstack As basetask, b$, Lang As Long, data$) As Boolean
Dim w$, x1 As Long, label1$, useHandler As mHandler, par As Boolean, pppp As mArray, p As Variant
If IsLabelSymbolNew(b$, "��", "AS", Lang) Then
            w$ = Funcweak(bstack, b$, x1, label1$)
            If LastErNum1 = -1 And x1 < 5 Then Exit Function
            If w$ = "" Then
            If bstack.UseGroupname <> "" Then
                If Len(label1$) > Len(bstack.UseGroupname) Then
                    If bstack.UseGroupname = Left$(label1$, Len(bstack.UseGroupname)) Then
                        MyEr "No such member in this group", "��� ������� ������ ����� �� ���� ��� �����"
                        Exit Function
                    End If
                End If
            ElseIf x1 = 1 Then
contvar1:
            x1 = globalvar(label1$, 0#)
            Set useHandler = New mHandler
                useHandler.t1 = 2
        If FastSymbol(b$, ",") Then
        If IsExp(bstack, b$, p) Then
         Set useHandler.objref = Decode64toMemBloc(data$, par, CBool(p))
        Else
        GetRes = True
        MissParam data$: Exit Function
        End If
        Else
                Set useHandler.objref = Decode64toMemBloc(data$, par)
                End If
                If par Then
                    Set var(x1) = useHandler
                    GetRes = True
            
                Else
                    GoTo err1
                End If
                Exit Function
            ElseIf x1 = 3 Then
                x1 = globalvar(label1$, vbNullString)
                var(x1) = Decode64(data$, par)
                If Not par Then GoTo err1
                GetRes = True
                Exit Function
            ElseIf x1 = 5 Then
                If GetVar(bstack, label1$, x1) Then
                    If GetArrayReference(bstack, b$, label1$, var(x1), pppp, x1) Then
                        Set useHandler = New mHandler
                        useHandler.t1 = 2
                        If Not par Then GoTo err1
                        If FastSymbol(b$, ",") Then
        If IsExp(bstack, b$, p) Then
         Set useHandler.objref = Decode64toMemBloc(data$, par, CBool(p))
        Else
        GetRes = True
        MissParam data$: Exit Function
        End If
        Else
                        Set useHandler.objref = Decode64toMemBloc(data$, par)
                        End If
                    
                        Set pppp.item(x1) = useHandler
                        GetRes = True
                    End If
                    Exit Function
            
                Else
                    MyEr "", ""
                    MyEr "Array not defined", "� ������� ��� ���� �������"
                    Exit Function
                End If
            ElseIf x1 = 6 Then
contstr1:
                If GetVar(bstack, label1$, x1) Then
                    If GetArrayReference(bstack, b$, label1$, var(x1), pppp, x1) Then
                        pppp.item(x1) = Decode64(data$, par)
                        If Not par Then GoTo err1
                        GetRes = True
                    End If
                    Exit Function
                Else
                    MyEr "", ""
                    MyEr "Array not defined", "� ������� ��� ���� �������"
                    Exit Function
                End If
            End If
            End If

            If x1 = 1 Then
            If GetVar(bstack, label1$, x1) Then
            Set useHandler = New mHandler
                useHandler.t1 = 2
        
                Set useHandler.objref = Decode64toMemBloc(data$, par)
                If par Then
                    Set var(x1) = useHandler
                    GetRes = True
            
                Else
err1:
                    MyEr "Can't decode this resource", "��� ������ �� ��������������� ���� �� ����"
                End If
                Exit Function
            Else
                GoTo contvar1
            End If
                ElseIf x1 = 3 Then
                
                If GetVar(bstack, label1$, x1) Then
                var(x1) = Decode64(data$, par)
                If Not par Then GoTo err1
                GetRes = True
                Exit Function
                End If
                ElseIf x1 = 5 Then
                If GetVar(bstack, label1$, x1) Then
                      DropLeft "(", w$
                    If GetArrayReference(bstack, w$, label1$, var(x1), pppp, x1) Then
                        Set useHandler = New mHandler
                        useHandler.t1 = 2
                        Set useHandler.objref = Decode64toMemBloc(data$, par)
                        If Not par Then GoTo err1
                        Set pppp.item(x1) = useHandler
                        GetRes = True
                    End If
                    Exit Function
            
                Else
                    MyEr "", ""
                    MyEr "Array not defined", "� ������� ��� ���� �������"
                    Exit Function
                End If
                            ElseIf x1 = 6 Then
                               If GetVar(bstack, label1$, x1) Then
                            DropLeft "(", w$
                    If GetArrayReference(bstack, w$, label1$, var(x1), pppp, x1) Then
                        pppp.item(x1) = Decode64(data$, par)
                        If Not par Then GoTo err1
                        GetRes = True
                    End If
                    Exit Function
                Else
                    MyEr "", ""
                    MyEr "Array not defined", "� ������� ��� ���� �������"
                    Exit Function
                End If
            End If
        
        End If
End Function

Function IsHILOWWORD(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
    Dim p As Variant
    If IsExp(bstack, a$, r) Then
        If FastSymbol(a$, ",") Then
              If IsExp(bstack, a$, p) Then
                    r = SG * (r * &H10000 + p)
                    
                     IsHILOWWORD = FastSymbol(a$, ")", True)
                  Else
                     
                    MissParam a$
                End If
        Else
             
             MissParam a$
        End If
     Else
             
             MissParam a$
      End If
     
End Function
Function IsBinaryNot(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
  If IsExp(bstack, a$, r) Then
            On Error Resume Next
    If r < 0 Then r = r And &H7FFFFFFF
             r = SG * (uintnew(-1) - r)
        If Err.Number > 0 Then
            
            WrongArgument a$
          
            Exit Function
            End If
    On Error GoTo 0
    
        IsBinaryNot = FastSymbol(a$, ")", True)
    Else
           MissParam a$
    
    End If
End Function
Function IsBinaryNeg(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
  If IsExp(bstack, a$, r) Then
            On Error Resume Next
       
             r = SG * (uintnew(-1) - uintnew(r))
        If Err.Number > 0 Then
        
            WrongArgument a$
        
            Exit Function
            End If
    On Error GoTo 0
    
        IsBinaryNeg = FastSymbol(a$, ")", True)
    Else
           MissParam a$
    
    End If
End Function
Function IsBinaryOr(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
        Dim p As Variant
     If IsExp(bstack, a$, r) Then
        If FastSymbol(a$, ",") Then
        If IsExp(bstack, a$, p) Then
            r = SG * uintnew((signlong(r) Or signlong(p)))
         IsBinaryOr = FastSymbol(a$, ")", True)
           Else
                
                MissParam a$
        End If
          Else
                MissParam a$
       End If
         Else
                MissParam a$
       End If
End Function
Function IsBinaryAnd(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
    Dim p As Variant
    If IsExp(bstack, a$, r) Then
            If FastSymbol(a$, ",") Then
                If IsExp(bstack, a$, p) Then
                    r = SG * uintnew((signlong(r) And signlong(p)))
                    
                    IsBinaryAnd = FastSymbol(a$, ")", True)
                Else
                    
                    MissParam a$
                End If
            Else
                
                MissParam a$
            End If
        Else
            
            MissParam a$
       
       End If
End Function
Function IsBinaryXor(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
    Dim p As Variant
        If IsExp(bstack, a$, r) Then
            If FastSymbol(a$, ",") Then
                If IsExp(bstack, a$, p) Then
                    r = SG * uintnew((signlong(r) Xor signlong(p)))
                    
                    IsBinaryXor = FastSymbol(a$, ")", True)
                Else
                    
                    MissParam a$
                End If
            Else
                
                MissParam a$
            End If
        Else
            
            MissParam a$
       
       End If
End Function
Function IsBinaryShift(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
Dim p As Variant
   If IsExp(bstack, a$, r) Then
  
            If FastSymbol(a$, ",") Then
                    If IsExp(bstack, a$, p) Then
                         If p > 31 Or p < -31 Then
                         
                         MyErMacro a$, "Shift from -31 to 31", "�������� ��� -31 �� 31"
                         IsBinaryShift = False: Exit Function
                         Else
                               If p > 0 Then
                              r = SG * uintnew((signlong(r) And signlong(2 ^ (32 - p) - 1))) * 2 ^ p
                              ElseIf p = 0 Then
                              If SG < 0 Then r = -r
                              Else
                              p = -p
                               r = SG * uintnew((signlong(r) And signlong(uintnew(-1) - uintnew(2 ^ p - 1)))) / 2 ^ p
                              End If
                              
                            IsBinaryShift = FastSymbol(a$, ")", True)
                    Exit Function
                         End If
                    Else
                          
                        MissParam a$
                    End If
            Else
                
                MissParam a$
            End If
    Else
            
            MissParam a$
   End If

End Function
Function IsBinaryRotate(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
Dim p As Variant
        If IsExp(bstack, a$, r) Then
             If FastSymbol(a$, ",") Then
                 If IsExp(bstack, a$, p) Then
                        If p > 31 Or p < -31 Then
                            
                              MyErMacro a$, "Rotation from -31 to 31", "��������� ��� -31 �� 31"
                             IsBinaryRotate = False: Exit Function
                        Else
                             If p > 0 Then
                                 r = SG * (uintnew((signlong(r) And signlong(2 ^ (32 - p) - 1))) * 2 ^ p + uintnew((signlong(r) And signlong(uintnew(-1) - uintnew(2 ^ (32 - p) - 1)))) / 2 ^ (32 - p))
                     
                             ElseIf p = 0 Then
                                 If SG < 0 Then r = -r
                             Else
                                 p = 32 + p
                                 r = SG * (uintnew((signlong(r) And signlong(2 ^ (32 - p) - 1))) * 2 ^ p + uintnew((signlong(r) And signlong(uintnew(-1) - uintnew(2 ^ (32 - p) - 1)))) / 2 ^ (32 - p))
                                 
                             End If
                        End If
                     
                  Else
                    
                    MissParam a$
                 End If
             Else
                
                MissParam a$
            End If
        IsBinaryRotate = FastSymbol(a$, ")", True)
        Else
            
            MissParam a$
        End If
End Function
Function IsSin(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
   If IsExp(bstack, a$, r) Then
    r = Sin(r * 1.74532925199433E-02)
    ''r = Sgn(r) * Int(Abs(r) * 10000000000000#) / 10000000000000#
    If Abs(r) < 1E-16 Then r = 0
    If SG < 0 Then r = -r
    
    
 IsSin = FastSymbol(a$, ")", True)
    Else
                
                MissParam a$
    
    End If
End Function
Function IsAbs(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
If IsExp(bstack, a$, r) Then
    r = Abs(r)
    If SG < 0 Then r = -r
    
 IsAbs = FastSymbol(a$, ")", True)
    Else
                MissParam a$
    End If
End Function

Function IsCos(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
  If IsExp(bstack, a$, r) Then

    r = Cos(r * 1.74532925199433E-02)
 
    If Abs(r) < 1E-16 Then r = 0
    If SG < 0 Then r = -r
    
    
  IsCos = FastSymbol(a$, ")", True)
    Else
                
                MissParam a$
    
    End If
End Function
Function IsTan(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
If IsExp(bstack, a$, r) Then
     
     If r = Int(r) Then
        If r Mod 90 = 0 And r Mod 180 <> 0 Then
        MyErMacro a$, "Wrong Tan Parameter", "����� ���������� �����������"
        IsTan = False: Exit Function
        End If
        End If
    r = Sgn(r) * Tan(r * 1.74532925199433E-02)

     If Abs(r) < 1E-16 Then r = 0
     If Abs(r) < 1 And Abs(r) + 0.0000000000001 >= 1 Then r = Sgn(r)
   If SG < 0 Then r = -r
    
IsTan = FastSymbol(a$, ")", True)
     Else
                
                MissParam a$
    
    End If
End Function
Function IsAtan(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
 If IsExp(bstack, a$, r) Then
     
     r = SG * Atn(r) * 180# / Pi
        
IsAtan = FastSymbol(a$, ")", True)
     Else
                
                MissParam a$
    
    End If
End Function
Function IsLn(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
  If IsExp(bstack, a$, r) Then
    If r <= 0 Then
       MyErMacro a$, "Only > zero parameter", "���� >0 ����������"
        IsLn = False: Exit Function
    Else
    r = SG * Log(r)
    
    End If
    
 IsLn = FastSymbol(a$, ")", True)
     Else
                
                MissParam a$
    
    End If
End Function
Function IsLog(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
If IsExp(bstack, a$, r) Then
        If r <= 0 Then
       MyErMacro a$, "Only > zero parameter", "���� >0 ����������"
        IsLog = False: Exit Function
    Else
    r = SG * Log(r) / Log(10#)
    
    End If
   IsLog = FastSymbol(a$, ")", True)
    Else
                
                MissParam a$
    
    End If
End Function
Function IsFreq(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
Dim p As Variant
    If IsExp(bstack, a$, r) Then
           If FastSymbol(a$, ",") Then
                If IsExp(bstack, a$, p) Then
                    r = SG * GetFrequency(CInt(r), CInt(p))
                    
                    IsFreq = FastSymbol(a$, ")", True)
                    Else
                
                MissParam a$
                End If
            Else
                
                MissParam a$
            End If
     Else
                
                MissParam a$
     End If
End Function
Function IsSqrt(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
    If IsExp(bstack, a$, r) Then
    
    If r <= 0 Then
    negsqrt a$
    Exit Function
   
    End If
  
    r = Sqr(r)
    If SG < 0 Then r = -r
    
   IsSqrt = FastSymbol(a$, ")", True)
    Else
                
                MissParam a$
    
    End If
End Function
Function GiveForm() As Form
Set GiveForm = Form1
End Function
Function IsNumberD(a$, d As Double) As Boolean
Dim a1 As Long
If a$ <> "" Then
For a1 = 1 To Len(a$) + 1
Select Case Mid$(a$, a1, 1)
Case " ", ",", ChrW(160)
If a1 > 1 Then Exit For
Case Is = Chr(2)
If a1 = 1 Then Exit Function
Exit For
End Select
Next a1
If a1 > Len(a$) Then a1 = Len(a$) + 1
d = CDbl(val("0" & Left$(a$, a1 - 1)))
a$ = Mid$(a$, a1)
IsNumberD = True
Else
IsNumberD = False
End If
End Function
Function IsNumberLabel(a$, Label$) As Boolean
Dim a1 As Long, LI As Long, A2 As Long
LI = Len(a$)
' No zero number.
' First 1....9
' second ...to fifth (0 to 9) 99999 is the maximum
'
If LI > 0 Then
'a1 = 1
a1 = MyTrimL2(a$)
'While Mid$(a$, a1, 1) = " ": a1 = a1 + 1: Wend
' we start from a1
A2 = a1
If a1 > LI Then a$ = vbNullString: Exit Function
If LI > 5 + A2 Then LI = 4 + A2
If Mid$(a$, a1, 1) Like "[0-9]" Then
Do While a1 <= LI
a1 = a1 + 1
If Not Mid$(a$, a1, 1) Like "[0-9]" Then Exit Do

Loop
Label$ = Mid$(a$, A2, a1 - A2): a$ = Mid$(a$, a1)
IsNumberLabel = True
End If

End If
End Function
Function IsNumberQuery(a$, fr As Long, r As Double, lr As Long) As Boolean
Dim SG As Long, sng As Long, n$, ig$, DE$, sg1 As Long, ex$, rr As Double
' ti kanei to e$
If a$ = vbNullString Then IsNumberQuery = False: Exit Function
SG = 1
sng = fr - 1
    Do While sng < Len(a$)
    sng = sng + 1
    Select Case Mid$(a$, sng, 1)
    Case " ", "+", ChrW(160)
    Case "-"
    SG = -SG
    Case Else
    Exit Do
    End Select
    Loop
n$ = Mid$(a$, sng)

If val("0" & Mid$(a$, sng, 1)) = 0 And Left(Mid$(a$, sng, 1), sng) <> "0" And Left(Mid$(a$, sng, 1), sng) <> "." Then
IsNumberQuery = False

Else
'compute ig$
    If Mid$(a$, sng, 1) = "." Then
    ' no long part
    ig$ = "0"
    DE$ = "."

    Else
    Do While sng <= Len(a$)
        
        Select Case Mid$(a$, sng, 1)
        Case "0" To "9"
        ig$ = ig$ & Mid$(a$, sng, 1)
        Case "."
        DE$ = "."
        Exit Do
        Case Else
        Exit Do
        End Select
       sng = sng + 1
    Loop
    End If
    ' compute decimal part
    If DE$ <> "" Then
      sng = sng + 1
        Do While sng <= Len(a$)
       
        Select Case Mid$(a$, sng, 1)
        Case " ", ChrW(160)
        If Not (sg1 And Len(ex$) = 1) Then
        Exit Do
        End If
        Case "0" To "9"
        If sg1 Then
        ex$ = ex$ & Mid$(a$, sng, 1)
        Else
        DE$ = DE$ & Mid$(a$, sng, 1)
        End If
        Case "E", "e" ' ************check it
             If ex$ = vbNullString Then
               sg1 = True
        ex$ = "E"
        Else
        Exit Do
        End If
   
               Case "�", "�" ' ************check it
                         If ex$ = vbNullString Then
               sg1 = True
        ex$ = "E"
        Else
        Exit Do
        End If
        
        
        Case "+", "-"
        If sg1 And Len(ex$) = 1 Then
         ex$ = ex$ & Mid$(a$, sng, 1)
        Else
        Exit Do
        End If
        Case Else
        Exit Do
        End Select
         sng = sng + 1
        Loop
        If sg1 Then
            If Len(ex$) < 3 Then
                If ex$ = "E" Then
                    ex$ = " "
                ElseIf ex$ = "E-" Or ex$ = "E+" Then
                    ex$ = "  "
                End If
            End If
        End If
    End If
    If ig$ = vbNullString Then
    IsNumberQuery = False
    lr = 1
    Else
    If SG < 0 Then ig$ = "-" & ig$
    Err.Clear
    On Error Resume Next
    n$ = ig$ & DE$ & ex$
    sng = Len(ig$ & DE$ & ex$)
    rr = val(ig$ & DE$ & ex$)
    If Err.Number > 0 Then
         lr = 0
    Else
        r = rr
       lr = sng - fr + 2
       IsNumberQuery = True
    End If
    
       
    
    End If
End If
End Function


Function IsNumberOnly(a$, fr As Long, r As Variant, lr As Long, Optional useRtypeOnly As Boolean = False, Optional usespecial As Boolean = False) As Boolean
Dim SG As Long, sng As Long, ig$, DE$, sg1 As Long, ex$, foundsign As Boolean
' ti kanei to e$
If a$ = vbNullString Then IsNumberOnly = False: Exit Function
SG = 1
sng = fr - 1
    Do While sng < Len(a$)
    sng = sng + 1
    Select Case Mid$(a$, sng, 1)
    Case " ", ChrW(160)
    Case "+"
    foundsign = True
    Case "-"
    SG = -SG
    foundsign = True
    Case Else
    Exit Do
    End Select
    Loop
If LCase(Mid$(a$, sng, 2)) Like "0[x�]" Then
    If foundsign Then
    MyEr "no sign for hex values", "��� ������� ��� �������������"
    IsNumberOnly = False
    GoTo er111
    End If
    ig$ = ""
    DE$ = ""
    sng = sng + 1
    Do While MaybeIsSymbolNoSpace(Mid$(a$, sng + 1, 1), "[0-9A-Fa-f]")
    DE$ = DE$ + Mid$(a$, sng + 1, 1)
    sng = sng + 1
    If Len(DE$) = 8 Then Exit Do
    Loop
    sng = sng + 1
    SG = 1 ' no sign
    If DE$ = "" Then
    MyEr "ivalid hex values", "����� ������ ��� �����������"
    IsNumberOnly = False
    GoTo er111
    End If
    If MaybeIsSymbolNoSpace(Mid$(a$, sng, 1), "[&%]") Then
    
        sng = sng + 1
        ig$ = "&H" + DE$
        DE$ = ""
        If Mid$(a$, sng - 1, 1) = "%" Then
        If Len(ig$) > 6 Then
        OverflowLong True
        IsNumberOnly = False
        GoTo er111
        Else
        r = CInt(0)
        End If
        Else
        r = CLng(0)
        End If
        GoTo conthere1
    ElseIf useRtypeOnly Then
        If VarType(r) = vbLong Or VarType(r) = vbInteger Then
        ig$ = "&H" + DE$
        DE$ = ""
        GoTo conthere1
        End If
    End If
        DE$ = Right$("00000000" & DE$, 8)
        r = CDbl(UNPACKLNG(Left$(DE$, 4)) * 65536#) + CDbl(UNPACKLNG(Right$(DE$, 4)))
        GoTo contfinal
  
ElseIf val("0" & Mid$(a$, sng, 1)) = 0 And Left(Mid$(a$, sng, 1), sng) <> "0" And Left(Mid$(a$, sng, 1), sng) <> "." Then
IsNumberOnly = False

Else
'compute ig$
    If Mid$(a$, sng, 1) = "." Then
    ' no long part
    ig$ = "0"
    DE$ = "."

    Else
    Do While sng <= Len(a$)
        
        Select Case Mid$(a$, sng, 1)
        Case "0" To "9"
        ig$ = ig$ & Mid$(a$, sng, 1)
        Case "."
        DE$ = "."
        Exit Do
        Case Else
        Exit Do
        End Select
       sng = sng + 1
    Loop
    End If
    ' compute decimal part
    If DE$ <> "" Then
      sng = sng + 1
        Do While sng <= Len(a$)
       
        Select Case Mid$(a$, sng, 1)
        Case " ", ChrW(160)
        If Not (sg1 And Len(ex$) = 1) Then
        Exit Do
        End If
        Case "0" To "9"
        If sg1 Then
        ex$ = ex$ & Mid$(a$, sng, 1)
        Else
        DE$ = DE$ & Mid$(a$, sng, 1)
        End If
        Case "E", "e" ' ************check it
            If ex$ = vbNullString Then
               sg1 = True
                ex$ = "E"
            Else
                Exit Do
            End If
        Case "�", "�" ' ************check it
            If ex$ = vbNullString Then
                sg1 = True
                ex$ = "E"
            Else
                Exit Do
            End If
        Case "+", "-"
            If sg1 And Len(ex$) = 1 Then
             ex$ = ex$ & Mid$(a$, sng, 1)
            Else
                Exit Do
            End If
        Case Else
            Exit Do
        End Select
        sng = sng + 1
        Loop
        If Len(ex$) < 3 Then
                If ex$ = "E" Then
                ex$ = "0"
                sng = sng + 1
                ElseIf ex$ = "E-" Or ex$ = "E+" Then
                ex$ = "00"
                sng = sng + 2
                End If
                End If
    End If
    If ig$ = vbNullString Then
    IsNumberOnly = False
    lr = 1
    Else
    If SG < 0 Then ig$ = "-" & ig$
    On Error GoTo er111
     If useRtypeOnly Then GoTo conthere1
    If sng <= Len(a$) Then
    If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = cdecimaldot$
    Select Case Mid$(a$, sng, 1)
    Case "@"
    r = CDec(ig$ & DE$)
    sng = sng + 1
    Case "&"
    r = CLng(ig$)
    sng = sng + 1
    Case "%"
    r = CInt(ig$)
    sng = sng + 1
    Case "~"
    r = CSng(ig$ & DE$ & ex$)
    sng = sng + 1
    Case "#"
    r = CCur(ig$ & DE$)
    sng = sng + 1
    Case Else
GoTo conthere
    End Select
    Else
conthere:
        If useRtypeOnly Then
conthere1:
        If usespecial Then
       If sng <= Len(a$) Then
            Select Case Mid$(a$, sng, 1)
            Case "@"
                r = CDec(0)
                sng = sng + 1
            Case "&"
                r = CLng(0)
                sng = sng + 1
            Case "~"
                r = CSng(0)
                sng = sng + 1
            Case "#"
                r = CCur(0)
                sng = sng + 1
            Case "%"
                r = CInt(0)
                sng = sng + 1
        End Select
        End If
        End If
         If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = cdecimaldot$
        Select Case VarType(r)
        Case vbDecimal
        r = CDec(ig$ & DE$)
        Case vbLong
        r = CLng(ig$)
        Case vbInteger
        r = CInt(ig$)
        Case vbSingle
        r = CSng(ig$ & DE$ & ex$)
        Case vbCurrency
        r = CCur(ig$ & DE$)
        Case vbBoolean
        r = CBool(ig$ & DE$)
        Case Else
        r = CDbl(ig$ & DE$ & ex$)
        End Select
        Else
        If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = "."
        r = val(ig$ & DE$ & ex$)
        End If
    End If
contfinal:
    lr = sng - fr + 1
    
    IsNumberOnly = True
    Exit Function
    End If
End If
er111:
    lr = sng - fr + 1
    Err.Clear
Exit Function

End Function


Function IsNumberD2(a$, d As Variant, Optional noendtypes As Boolean = False, Optional exceptspecial As Boolean) As Boolean
' for inline stacitems
If VarType(d) = vbEmpty Then d = 0#
Dim a1 As Long
If a$ <> "" Then
For a1 = 1 To Len(a$) + 1
Select Case Mid$(a$, a1, 1)
Case " ", ChrW(160)
If a1 > 1 Then Exit For
Case Is = Chr(2)
If a1 = 1 Then Exit Function
Exit For
End Select
Next a1
If a1 > Len(a$) Then a1 = Len(a$) + 1
If IsNumberOnly(a$, 1, d, a1, noendtypes, exceptspecial) Then
a$ = Mid$(a$, a1)

IsNumberD2 = True
ElseIf Fast3NoSpace(a$, "������", 6, "������", 6, "TRUE", 4, 6) Then
d = True
IsNumberD2 = True
ElseIf Fast3NoSpace(a$, "������", 6, "������", 6, "FALSE", 5, 5) Then
d = False
IsNumberD2 = True
Else
IsNumberD2 = False
End If
Else
IsNumberD2 = False
End If

End Function

Function IsNumberD3(a$, fr As Long, a1 As Long) As Boolean
' for inline stacitems
Dim d As Double
If a$ <> "" Then
For a1 = fr To Len(a$) + 1
Select Case Mid$(a$, a1, 1)
Case " ", ChrW(160)
If a1 > fr Then Exit For
Case Is = Chr(2)
If a1 = fr Then Exit Function
Exit For
End Select
Next a1
If a1 > Len(a$) Then a1 = Len(a$) + 1
If IsNumberOnly(a$, fr, d, a1) Then
IsNumberD3 = True
Else
a1 = fr
IsNumberD3 = False
End If
Else
a1 = fr
IsNumberD3 = False
End If

End Function

Sub tsekme()
Dim b$, l As Double
b$ = " 12323 45.44545 -2345.343 .345 345.E-45 34.53 434 534 534 534 345"
'b$ = VbNullString
Debug.Print b$
While IsNumberD2(b$, l)
Debug.Print l
Wend
End Sub
Function IsNumberCheck(a$, r As Variant, Optional mydec$ = " ") As Boolean
Dim sng&, SG As Variant, ig$, DE$, sg1 As Boolean, ex$, s$
If mydec$ = " " Then mydec$ = "."
SG = 1
Do While sng& < Len(a$)
sng& = sng& + 1
Select Case Mid$(a$, sng&, 1)
Case "#"
    If Len(a$) > sng& Then
    If MaybeIsSymbolNoSpace(Mid$(a$, sng& + 1, 1), "[0-9A-Fa-f]") Then
    s$ = "0x00" + Mid$(a$, sng& + 1, 6)
    If Len(s$) < 10 Then Exit Function
        If IsNumberCheck(s$, r) Then
        If s$ <> "" Then
          
             
        Else
            s$ = Right$("00000000" & Mid$(a$, sng& + 1, 6), 8)
            a$ = Mid$(a$, sng& + 7)
   r = SG * -(CDbl(UNPACKLNG(Right$(s$, 2)) * 65536#) + CDbl(UNPACKLNG(Mid$(s$, 5, 2)) * 256#) + CDbl(UNPACKLNG(Mid$(s$, 3, 2))))
   IsNumberCheck = True
   Exit Function
        End If
        End If
        Else
        
    End If
    Else

    '' out
    End If
    Exit Function
Case " ", "+", ChrW(160)
Case "-"
SG = -SG
Case Else
Exit Do
End Select
Loop
a$ = Mid$(a$, sng&)
sng& = 1
If val("0" & Mid$(Replace(a$, mydec$, "."), sng&, 1)) = 0 And Left(Mid$(a$, sng&, 1), sng&) <> "0" And Left(Mid$(a$, sng&, 1), sng&) <> mydec$ Then
IsNumberCheck = False
Else

    If Mid$(a$, sng&, 1) = mydec$ Then

    ig$ = "0"
    DE$ = mydec$
    ElseIf LCase(Mid$(a$, sng&, 2)) Like "0[x�]" Then
    ig$ = "0"
    DE$ = "0x"
  sng& = sng& + 1
Else
    Do While sng& <= Len(a$)
        
        Select Case Mid$(a$, sng&, 1)
        Case "0" To "9"
        ig$ = ig$ & Mid$(a$, sng&, 1)
        Case mydec$
        DE$ = mydec$
        Exit Do
        Case Else
        Exit Do
        End Select
       sng& = sng& + 1
    Loop
    End If
    ' compute decimal part
    If DE$ <> "" Then
      sng& = sng& + 1
        Do While sng& <= Len(a$)
       
        Select Case Mid$(a$, sng&, 1)
        Case " ", ChrW(160)
        If Not (sg1 And Len(ex$) = 1) Then
        Exit Do
        End If
        Case "A" To "D", "a" To "d", "F", "f"
        If Left$(DE$, 2) = "0x" Then
        DE$ = DE$ & Mid$(a$, sng&, 1)
        End If
        Case "0" To "9"
        If sg1 Then
        ex$ = ex$ & Mid$(a$, sng&, 1)
        Else
        DE$ = DE$ & Mid$(a$, sng&, 1)
        End If
        Case "E", "e"
         If Left$(DE$, 2) = "0x" Then
         DE$ = DE$ & Mid$(a$, sng&, 1)
         Else
              If ex$ = vbNullString Then
               sg1 = True
        ex$ = "E"
        Else
        Exit Do
        End If
        End If
        Case "�", "�"
                         If ex$ = vbNullString Then
               sg1 = True
        ex$ = "E"
        Else
        Exit Do
        End If
        ex$ = "E"
        
        Case "+", "-"
        If sg1 And Len(ex$) = 1 Then
         ex$ = ex$ & Mid$(a$, sng&, 1)
        Else
        Exit Do
        End If
        Case Else
        Exit Do
        End Select
         sng& = sng& + 1
        Loop
        If Len(ex$) < 3 Then
                If ex$ = "E" Then
                ex$ = "0"
                sng = sng + 1
                ElseIf ex$ = "E-" Or ex$ = "E+" Then
                ex$ = "00"
                sng = sng + 2
                End If
                End If
    End If
    If ig$ = vbNullString Then
    IsNumberCheck = False
    Else

    If Left$(DE$, 2) = "0x" Then

            If Mid$(DE$, 3) = vbNullString Then
            r = 0
            Else
            DE$ = Right$("00000000" & Mid$(DE$, 3), 8)
            r = CDbl(UNPACKLNG(Left$(DE$, 4)) * 65536#) + CDbl(UNPACKLNG(Right$(DE$, 4)))
            End If
    Else
        If SG < 0 Then ig$ = "-" & ig$
                   On Error Resume Next
                        If ex$ <> "" Then
                        If Len(ex$) < 3 Then
                                If ex$ = "E" Then
                                ex$ = "0"
                                ElseIf ex$ = "E-" Or ex$ = "E+" Then
                                ex$ = "00"
                                End If
                                End If
                               If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = "."
                               If val(Mid$(ex$, 2)) > 308 Or val(Mid$(ex$, 2)) < -324 Then
                               
                                   r = val(ig$ & DE$)
                                   sng = sng - Len(ex$)
                                   ex$ = vbNullString
                                   
                               Else
                                   r = val(ig$ & DE$ & ex$)
                               End If
                           Else
                       If sng <= Len(a$) Then
            Select Case Asc(Mid$(a$, sng, 1))
            Case 64
                Mid$(a$, sng, 1) = " "
                If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = cdecimaldot$
                r = CDec(ig$ & DE$)
                If Err.Number = 6 Then
                Err.Clear
                If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = "."
                r = val(ig$ & DE$)
                End If
            Case 35
            Mid$(a$, sng, 1) = " "
                If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = cdecimaldot$
                r = CCur(ig$ & DE$)
                If Err.Number = 6 Then
                Err.Clear
                If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = "."
                r = val(ig$ & DE$)
                End If
           Case 37
                Mid$(a$, sng, 1) = " "
                If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = cdecimaldot$
                r = CInt(ig$)
                If Err.Number = 6 Then
                Err.Clear
                r = val(ig$)
                End If
           Case 38
                Mid$(a$, sng, 1) = " "
                r = CLng(ig$)
                If Err.Number = 6 Then
                    Err.Clear
                    r = val(ig$)
                End If
            Case 126
                Mid$(a$, sng, 1) = " "
                If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = cdecimaldot$
                r = CSng(ig$ & DE$)
                If Err.Number = 6 Then
                Err.Clear
                If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = "."
                r = val(ig$ & DE$)
                End If
            Case Else
                If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = "."
                r = val(ig$ & DE$)
            End Select
            Else
            If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = "."
            r = val(ig$ & DE$)
            End If
                           End If
                     If Err.Number = 6 Then
                         If Len(ex$) > 2 Then
                             ex$ = Left$(ex$, Len(ex$) - 1)
                             sng = sng - 1
                             Err.Clear
                             If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = "."
                             r = val(ig$ & DE$ & ex$)
                             If Err.Number = 6 Then
                                 sng = sng - Len(ex$)
                                 If DE$ <> vbNullString Then Mid$(DE$, 1, 1) = "."
                                  r = val(ig$ & DE$)
                             End If
                         End If
                       MyEr "Error in exponet", "����� ���� ������"
                       IsNumberCheck = False
                       Exit Function
                     End If
           
         End If
           a$ = Mid$(a$, sng&)
           IsNumberCheck = True
End If
End If
End Function
Function utf8encode(a$) As String
Dim bOut() As Byte, lPos As Long
If a$ = "" Then Exit Function
bOut() = Utf16toUtf8(a$)
lPos = UBound(bOut()) + 1
If lPos Mod 2 = 1 Then
    utf8encode = StrConv(String$(lPos, Chr(0)), vbFromUnicode)
Else
    utf8encode = String$((lPos + 1) \ 2, Chr(0))
    End If
    CopyMemory ByVal StrPtr(utf8encode), bOut(0), LenB(utf8encode)
End Function
Function utf8decode(a$) As String
Dim b() As Byte, BLen As Long, WChars As Long
BLen = LenB(a$)
            ReDim b(0 To BLen - 1)
            CopyMemory b(0), ByVal StrPtr(a$), BLen
            WChars = MultiByteToWideChar(65001, 0, b(0), (BLen), 0, 0)
            utf8decode = Space$(WChars)
            MultiByteToWideChar 65001, 0, b(0), (BLen), StrPtr(utf8decode), WChars
End Function
Sub test(a$)
Dim pos1 As Long
pos1 = 1
Debug.Print aheadstatus(a$, False, pos1)
Debug.Print pos1
Debug.Print Left$(a$, pos1)
End Sub
Public Function ideographs(c$) As Boolean
Dim code As Long
If c$ = vbNullString Then Exit Function
code = AscW(c$)  '
ideographs = (code And &H7FFF) >= &H4E00 Or (-code > 24578) Or (code >= &H3400& And code <= &HEDBF&) Or (code >= -1792 And code <= -1281)
End Function
Public Function nounder32(c$) As Boolean
nounder32 = AscW(c$) > 31 Or AscW(c$) < 0
End Function

Function GetImageX(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
Dim w1 As Long, s$, w2 As Long, pppp As mArray, useHandler As mHandler
GetImageX = False
If IsExp(bstack, a$, s$) Then
      GetImageX = FastSymbol(a$, ")", True)
        If Not bstack.lastobj Is Nothing Then
           If TypeOf bstack.lastobj Is mHandler Then
              Set useHandler = bstack.lastobj
              Set bstack.lastobj = Nothing
              If useHandler.t1 = 2 Then
                  If useHandler.objref.ReadImageSizeX(r) Then
                  r = SG * bstack.Owner.ScaleX(r, 3, 1)
                          Set useHandler = Nothing
                      Exit Function
                  End If
              End If
           End If
        End If
            noImageInBuffer a$
            GetImageX = False
            r = 0#
    
Else
w1 = Abs(IsLabel(bstack, a$, s$))
        If w1 = 3 Then
            If GetVar(bstack, s$, w1) Then
                If Typename(var(w1)) <> "String" Then MissString: Exit Function
                If Left$(var(w1), 4) = "cDIB" And Len(var(w1)) > 12 Then
                    r = cDIBwidth1(var(w1)) * DXP
                    If SG < 0 Then r = -r
                    GetImageX = FastSymbol(a$, ")", True)
                Else
                    noImage a$
                    Exit Function
                End If
            Else
                MissFuncParameterStringVarMacro a$
            End If
        ElseIf w1 = 6 Then
            If neoGetArray(bstack, s$, pppp) Then
                If Not NeoGetArrayItem(pppp, bstack, s$, w2, a$) Then Exit Function
                If Not pppp.IsStringItem(w2) Then MissString: Exit Function
                Dim sV As Variant
                pppp.SwapItem w2, sV
          
                If Left$(sV, 4) = "cDIB" And Len(sV) > 12 Then
                    r = SG * cDIBwidth1(sV) * DXP
                    If SG < 0 Then r = -r
                    pppp.SwapItem w2, sV
                    GetImageX = FastSymbol(a$, ")", True)
                Else
                    pppp.SwapItem w2, sV
                    noImage a$
                End If
    
        Else
            MissParam a$
        End If
End If
End If
    
 
End Function
Function GetImageY(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
Dim w1 As Long, s$, w2 As Long, pppp As mArray, useHandler As mHandler
GetImageY = False
If IsExp(bstack, a$, s$) Then
      GetImageY = FastSymbol(a$, ")", True)
        If Not bstack.lastobj Is Nothing Then
           If TypeOf bstack.lastobj Is mHandler Then
              Set useHandler = bstack.lastobj
              Set bstack.lastobj = Nothing
              If useHandler.t1 = 2 Then
                  If useHandler.objref.ReadImageSizeY(r) Then
                  r = SG * bstack.Owner.ScaleY(r, 3, 1)
                          Set useHandler = Nothing
                      Exit Function
                  End If
              End If
           End If
        End If
            noImageInBuffer a$
            GetImageY = False
            r = 0#
    
Else
w1 = Abs(IsLabel(bstack, a$, s$))
        If w1 = 3 Then
            If GetVar(bstack, s$, w1) Then
                If Typename(var(w1)) <> "String" Then MissString: Exit Function
                If Left$(var(w1), 4) = "cDIB" And Len(var(w1)) > 12 Then
                    r = cDIBheight1(var(w1)) * DXP
                    If SG < 0 Then r = -r
                    GetImageY = FastSymbol(a$, ")", True)
                Else
                    noImage a$
                    Exit Function
                End If
            Else
                MissFuncParameterStringVarMacro a$
            End If
        ElseIf w1 = 6 Then
            If neoGetArray(bstack, s$, pppp) Then
                If Not NeoGetArrayItem(pppp, bstack, s$, w2, a$) Then Exit Function
                If Not pppp.IsStringItem(w2) Then MissString: Exit Function
                Dim sV As Variant
                pppp.SwapItem w2, sV
          
                If Left$(sV, 4) = "cDIB" And Len(sV) > 12 Then
                    r = SG * cDIBheight1(sV) * DXP
                    If SG < 0 Then r = -r
                    pppp.SwapItem w2, sV
                    GetImageY = FastSymbol(a$, ")", True)
                Else
                    pppp.SwapItem w2, sV
                    noImage a$
                End If
    
        Else
            MissParam a$
        End If
End If
End If
    
 
End Function
Function GetImageXpixels(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
Dim w1 As Long, s$, w2 As Long, pppp As mArray, useHandler As mHandler
GetImageXpixels = False
If IsExp(bstack, a$, s$) Then
      GetImageXpixels = FastSymbol(a$, ")", True)
        If Not bstack.lastobj Is Nothing Then
           If TypeOf bstack.lastobj Is mHandler Then
              Set useHandler = bstack.lastobj
              Set bstack.lastobj = Nothing
              If useHandler.t1 = 2 Then
                  If useHandler.objref.ReadImageSizeX(r) Then
                  r = SG * r
                          Set useHandler = Nothing
                      Exit Function
                  End If
              End If
           End If
        End If
            noImageInBuffer a$
            GetImageXpixels = False
            r = 0#
    
Else
w1 = Abs(IsLabel(bstack, a$, s$))
        If w1 = 3 Then
            If GetVar(bstack, s$, w1) Then
                If Typename(var(w1)) <> "String" Then MissString: Exit Function
                If Left$(var(w1), 4) = "cDIB" And Len(var(w1)) > 12 Then
                    r = cDIBwidth1(var(w1))
                    If SG < 0 Then r = -r
                    GetImageXpixels = FastSymbol(a$, ")", True)
                Else
                    noImage a$
                    Exit Function
                End If
            Else
                MissFuncParameterStringVarMacro a$
            End If
        ElseIf w1 = 6 Then
            If neoGetArray(bstack, s$, pppp) Then
                If Not NeoGetArrayItem(pppp, bstack, s$, w2, a$) Then Exit Function
                If Not pppp.IsStringItem(w2) Then MissString: Exit Function
                Dim sV As Variant
                pppp.SwapItem w2, sV
          
                If Left$(sV, 4) = "cDIB" And Len(sV) > 12 Then
                    r = SG * cDIBwidth1(sV)
                    If SG < 0 Then r = -r
                    pppp.SwapItem w2, sV
                    GetImageXpixels = FastSymbol(a$, ")", True)
                Else
                    pppp.SwapItem w2, sV
                    noImage a$
                End If
    
        Else
            MissParam a$
        End If
End If
End If
    
 
End Function
Function GetImageYpixels(bstack As basetask, a$, r As Variant, SG As Variant) As Boolean
Dim w1 As Long, s$, w2 As Long, pppp As mArray, useHandler As mHandler
GetImageYpixels = False
If IsExp(bstack, a$, s$) Then
      GetImageYpixels = FastSymbol(a$, ")", True)
        If Not bstack.lastobj Is Nothing Then
           If TypeOf bstack.lastobj Is mHandler Then
              Set useHandler = bstack.lastobj
              Set bstack.lastobj = Nothing
              If useHandler.t1 = 2 Then
                  If useHandler.objref.ReadImageSizeY(r) Then
                  r = SG * r
                          Set useHandler = Nothing
                      Exit Function
                  End If
              End If
           End If
        End If
            noImageInBuffer a$
            GetImageYpixels = False
            r = 0#
    
Else
w1 = Abs(IsLabel(bstack, a$, s$))
        If w1 = 3 Then
            If GetVar(bstack, s$, w1) Then
                If Typename(var(w1)) <> "String" Then MissString: Exit Function
                If Left$(var(w1), 4) = "cDIB" And Len(var(w1)) > 12 Then
                    r = cDIBheight1(var(w1))
                    If SG < 0 Then r = -r
                    GetImageYpixels = FastSymbol(a$, ")", True)
                Else
                    noImage a$
                    Exit Function
                End If
            Else
                MissFuncParameterStringVarMacro a$
            End If
        ElseIf w1 = 6 Then
            If neoGetArray(bstack, s$, pppp) Then
                If Not NeoGetArrayItem(pppp, bstack, s$, w2, a$) Then Exit Function
                If Not pppp.IsStringItem(w2) Then MissString: Exit Function
                Dim sV As Variant
                pppp.SwapItem w2, sV
          
                If Left$(sV, 4) = "cDIB" And Len(sV) > 12 Then
                    r = SG * cDIBheight1(sV)
                    If SG < 0 Then r = -r
                    pppp.SwapItem w2, sV
                    GetImageYpixels = FastSymbol(a$, ")", True)
                Else
                    pppp.SwapItem w2, sV
                    noImage a$
                End If
    
        Else
            MissParam a$
        End If
End If
End If
    
 
End Function

Function enthesi(bstack As basetask, rest$) As String
'first is the string "label {0} other {1}
Dim counter As Long, pat$, final$, pat1$, pl1 As Long, pl2 As Long, pl3 As Long
Dim q$, p As Variant, p1 As Integer, pd$
If IsStrExp(bstack, rest$, final$) Then
  If FastSymbol(rest$, ",") Then
    Do
    pl2 = 1
        pat$ = "{" + CStr(counter)
       pat1$ = pat$ + ":"
        pat$ = pat$ + "}"
        If IsStrExp(bstack, rest$, q$) Then
fromboolean:
            final$ = Replace$(final$, pat$, q$)
AGAIN0:
        pl2 = InStr(pl2, final$, pat1$)
          If pl2 > 0 Then
           pl1 = InStr(pl2, final$, "}")
           pl3 = val(Mid$(final$, pl2 + Len(pat1$)) + "}")
           If pl3 <> 0 Then
        If pl3 > 0 Then
            pd$ = Left$(q$ + Space$(pl3), pl3)
            Else
            pd$ = Right$(Space$(Abs(pl3)) + q$, Abs(pl3))
            End If
      End If
            final$ = Replace$(final$, Mid$(final$, pl2, pl1 - pl2 + 1), pd$)
            GoTo AGAIN0
          End If
            If Not FastSymbol(rest$, ",") Then Exit Do
        ElseIf IsExp(bstack, rest$, p, , True) Then
        If VarType(p) = vbBoolean Then q$ = Format$(p, DefBooleanString): GoTo fromboolean
again1:
        pl2 = InStr(pl2, final$, pat1$)
        If pl2 > 0 Then
        pl1 = InStr(pl2, final$, "}")
        If Mid$(final$, pl2 + Len(pat1$), 1) = ":" Then
        p1 = 0
        pl3 = val(Mid$(final$, pl2 + Len(pat1$) + 1) + "}")
        Else
        p1 = val("0" + Mid$(final$, pl2 + Len(pat1$)))
        
        pl3 = val(Mid$(final$, pl2 + Len(pat1$) + Len(Str$(p1))) + "}")
        If p1 < 0 Then p1 = 13 '22
        If p1 > 13 Then p1 = 13
      p = MyRound(p, p1)
      End If
      pd$ = LTrim(Str(p))
      
      If InStr(pd$, "E") > 0 Or InStr(pd$, "e") > 0 Then '' we can change e to greek �
      pd$ = Format$(p, "0." + String$(p1, "0") + "E+####")
           If Not NoUseDec Then
                   If OverideDec Then
                    pd$ = Replace$(pd$, GetDeflocaleString(LOCALE_SDECIMAL), Chr(2))
                    pd$ = Replace$(pd$, GetDeflocaleString(LOCALE_STHOUSAND), Chr(3))
                    pd$ = Replace$(pd$, Chr(2), NowDec$)
                    pd$ = Replace$(pd$, Chr(3), NowThou$)
                    
                ElseIf InStr(pd$, NowDec$) > 0 Then
                pd$ = Replace$(pd$, NowDec$, Chr(2))
                pd$ = Replace$(pd$, NowThou$, Chr(3))
                pd$ = Replace$(pd$, Chr(2), ".")
                pd$ = Replace$(pd$, Chr(3), ",")
                
                End If
            End If
      ElseIf p1 <> 0 Then
       pd$ = Format$(p, "0." + String$(p1, "0"))
               If Not NoUseDec Then
                If OverideDec Then
                    pd$ = Replace$(pd$, GetDeflocaleString(LOCALE_SDECIMAL), Chr(2))
                    pd$ = Replace$(pd$, GetDeflocaleString(LOCALE_STHOUSAND), Chr(3))
                    pd$ = Replace$(pd$, Chr(2), NowDec$)
                    pd$ = Replace$(pd$, Chr(3), NowThou$)
                ElseIf InStr(pd$, NowDec$) > 0 Then
                pd$ = Replace$(pd$, NowDec$, Chr(2))
                pd$ = Replace$(pd$, NowThou$, Chr(3))
                pd$ = Replace$(pd$, Chr(2), ".")
                pd$ = Replace$(pd$, Chr(3), ",")
                
                End If
            End If
      End If
   
      If pl3 <> 0 Then
        If pl3 > 0 Then
            pd$ = Left$(pd$ + Space$(pl3), pl3)
            Else
            pd$ = Right$(Space$(Abs(pl3)) + pd$, Abs(pl3))
            End If
      End If
            final$ = Replace$(final$, Mid$(final$, pl2, pl1 - pl2 + 1), pd$)
            GoTo again1
        Else
        
        If NoUseDec Then
            final$ = Replace$(final$, pat$, CStr(p))
        Else
        pd$ = LTrim(Str$(p))
         If Left$(pd$, 1) = "." Then
        pd$ = "0" + pd$
        ElseIf Left$(pd$, 2) = "-." Then pd$ = "-0" + Mid$(pd$, 2)
        End If
        If OverideDec Then
        final$ = Replace$(final$, pat$, Replace(pd$, ".", NowDec$))
        Else
        final$ = Replace$(final$, pat$, pd$)
        End If
        End If
        
        
            End If
            If Not FastSymbol(rest$, ",") Then Exit Do
        Else
            Exit Do
        End If
        counter = counter + 1
    Loop
    Else
    enthesi = EscapeStrToString(final$)
    Exit Function
    End If
End If
enthesi = final$
End Function

Public Function GetDeflocaleString(ByVal this As Long) As String
On Error GoTo 1234
    Dim Buffer As String, ret&, r&
    Buffer = String$(514, 0)
      
        ret = GetLocaleInfoW(0, this, StrPtr(Buffer), Len(Buffer))
    GetDeflocaleString = Left$(Buffer, ret - 1)
    
1234:
    
End Function
Function RevisionPrint(basestack As basetask, rest$, xa As Long, Lang As Long) As Boolean
Dim Scr As Object, oldCol As Long, oldFTEXT As Long, oldFTXT As String, oldpen As Long
Dim par As Boolean, i As Long, F As Long, p As Variant, W4 As Boolean, pn&, s$, dlen As Long
Dim o As Long, w3 As Long, x1 As Long, y1 As Long, x As Double, ColOffset As Long
Dim work As Boolean, work2 As Long, skiplast As Boolean, ss$, ls As Long, myobject As Object, counter As Long, Counterend As Long, countDir As Long
Dim bck$, clearline As Boolean, ihavecoma As Boolean, isboolean As Boolean
Set Scr = basestack.Owner
w3 = -1
Dim basketcode As Long, prive As basket
basketcode = GetCode(Scr)
prive = players(basketcode)
With prive
If .MAXXGRAPH = 0 Then MyEr "No form to print", "��� ������� ����� ��� ��������": Exit Function
PlaceBasketPrive Scr, prive
Scr.FontTransparent = True
On Error GoTo 0
Dim opn&
par = True
If MaybeIsSymbol2(rest$, "#", F) Then
   If Mid$(rest$, F + 1, 6) Like "[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]" Then
   
   Else
  Mid$(rest$, 1, F) = Space$(F)
        If IsExp(basestack, rest$, p, , True) Then
        If p < 0 Then
        If p < -1 Then
        
                     .lastprint = False
                     par = False
        End If
        F = p
                     If Not FastSymbol(rest$, ",") Then
                     s$ = vbNullString
                     pn& = 2
                     GoTo isAstring
                     End If
        Else
                     F = CLng(MyMod(p, 512))
                     If FKIND(F) = FnoUse Or FKIND(F) = Finput Or FKIND(F) = Frandom Then MyEr "Wrong File Handler", "����� ��������� �������": RevisionPrint = False: Exit Function
                     Dim clearprive As basket
                     prive = clearprive
                     .lastprint = False
                     par = False
                     If Not FastSymbol(rest$, ",") Then
                     s$ = vbNullString
                     pn& = 2
                     GoTo isAstring
                     End If
                     
                     
            End If
             
       Else
       MyEr "expected file number", "�������� ������ �������"
       End If
    End If
Else
ss$ = Left$(rest$, MyTrimL(rest$) + 5)
ls = Len(ss$)
If Not IsLabelSYMB3(ss$, s$) Then
                    F = 0
                    
Else
Select Case Lang
Case 1
If Len(s$) > 3 Then
If InStr("BOUP", UCase(Left$(s$, 1))) > 0 Then

Select Case UCase(s$)
        Case "BACK"
        Mid$(rest$, 1, ls - Len(ss$)) = Space$(ls - Len(ss$))
        F = 4
        Case "OVER"
        F = 1
        Mid$(rest$, 1, ls - Len(ss$)) = Space$(ls - Len(ss$))
        Case "UNDER"
        F = 2
         Mid$(rest$, 1, ls - Len(ss$)) = Space$(ls - Len(ss$))
        Case "PART"
        F = 3
        Mid$(rest$, 1, ls - Len(ss$)) = Space$(ls - Len(ss$))
        Case Else
        ''rest$ = s$ + rest$
        F = 0
        End Select
        Else
        F = 0
        End If
        Else
        F = 0
End If
Case 0, 2
If Len(s$) > 2 Then
If InStr("����", myUcase(Left$(s$, 1))) > 0 Then
        Select Case myUcase(s$, True)
        Case "�����"
        Mid$(rest$, 1, ls - Len(ss$)) = Space$(ls - Len(ss$))
        F = 4
        Case "����"
        Mid$(rest$, 1, ls - Len(ss$)) = Space$(ls - Len(ss$))
        F = 1
        Case "���"
        Mid$(rest$, 1, ls - Len(ss$)) = Space$(ls - Len(ss$))
        F = 2
        Case "�����"
        Mid$(rest$, 1, ls - Len(ss$)) = Space$(ls - Len(ss$))
        F = 3
        Case Else
        F = 0
        End Select
        Else
        F = 0
        End If
        Else
        F = 0
End If
Case -1   '' this is for ?
If Len(s$) > 2 Then
If InStr("BOUP����", myUcase(Left$(s$, 1))) > 0 Then
Select Case myUcase(s$)
        Case "�����", "BACK"
        Mid$(rest$, 1, ls - Len(ss$)) = Space$(ls - Len(ss$))
        F = 4
        Case "����", "OVER"
        Mid$(rest$, 1, ls - Len(ss$)) = Space$(ls - Len(ss$))
        F = 1
        Case "���", "UNDER"
        Mid$(rest$, 1, ls - Len(ss$)) = Space$(ls - Len(ss$))
        F = 2
        Case "�����", "PART"
        Mid$(rest$, 1, ls - Len(ss$)) = Space$(ls - Len(ss$))
        F = 3
        Case Else
        F = 0
        End Select
        Else
        F = 0
        End If
        Else
        F = 0
        End If
        Lang = 0
        End Select
        
        If F > 0 And .lastprint Then
        .lastprint = False
        
        GetXYb Scr, prive, x1&, y1&
        If F <> 2 Then If x1& > 0 Or y1& >= .mx Then crNew basestack, prive
        End If
If F = 1 Then  ''
    work = True
    oldCol = .Column
    Scr.Line (0&, .currow * .Yt)-((.mx - 1) * .Xt + .Xt * 2, (.currow) * .Yt + .Yt - 2 * DYP), .Paper, BF
    LCTbasket Scr, prive, .currow, 0&
    .Column = .mx - 1
    W4 = True
    oldFTEXT = .FTEXT
    oldFTXT = .FTXT
    oldpen = .mypen
    pn& = 2
    .FTEXT = 4
ElseIf F = 2 Then
    work = True
    oldCol = .Column
    Scr.Line (0&, (.currow) * .Yt + .Yt - DYP)-((.mx - 1) * .Xt + .Xt * 2, (.currow) * .Yt + .Yt - DYP), .mypen, BF
    crNew basestack, prive
    LCTbasketCur Scr, prive
    W4 = True
    oldFTEXT = .FTEXT
    oldFTXT = .FTXT
    oldpen = .mypen
    .FTEXT = 4
    pn& = 2
ElseIf F = 3 Then
' we print in a line with lost chars, so controling the start of printing
' we can render text, like from a view port Some columns are hidden because they went out of screen;
work = True
oldCol = .Column
LCTbasket Scr, prive, .currow, 0&
W4 = True
oldFTEXT = .FTEXT
oldFTXT = .FTXT
.FTEXT = 4
oldpen = .mypen
ElseIf F = 4 Then
    work = True
    clearline = True
    ' LCTbasketCur scr, prive
    If .curpos > 0 Then
    crNew basestack, prive
    LCTbasketCur Scr, prive
    End If
    Scr.Line (0&, .currow * .Yt)-((.mx - 1) * .Xt + .Xt * 2, (.currow) * .Yt + .Yt - 1 * DYP), .Paper, BF
   ' scr.Line (0&, (.currow) * .Yt + .Yt - DYP)-((.mx - 1) * .Xt + .Xt * 2, (.currow) * .Yt + .Yt - 1 * DYP), .mypen, BF
    LCTbasketCur Scr, prive
    pn& = 2
End If

F = 0
End If

End If
If W4 Then pn& = 2 Else pn& = 0

s$ = vbNullString
If par Then
    If .FTEXT > 3 And .curpos >= .mx And Not W4 Then
    crNew basestack, prive
    w3 = 0
End If
End If
If par Then
If FastSymbol(rest$, ";") Then

            If .lastprint Then
            .lastprint = False
            LCTbasketCur Scr, prive
            crNew basestack, prive
            End If
         
ElseIf .lastprint Then
If .FTEXT > 3 Then pn& = 7: GoTo newntrance

End If
End If


Do

   If FastSymbol(rest$, "~(", , 2) Then ' means combine
        ' get the color and then look for @( parameters)
        w3 = -1
    If par Then  ' par is false when we print in files, we can't use color;
   
                 If IsExp(basestack, rest$, p, , True) Then .mypen = CLng(mycolor(p))
                 TextColor Scr, .mypen
                 
                     If FastSymbol(rest$, ",") Then
                     
                                If W4 Or Not work Then
                                  If prive.lastprint Then
                                   prive.lastprint = False
                                   GetXYb Scr, prive, .curpos, .currow
                                                   If work Then
                       .curpos = .curpos - ColOffset
                      If (.curpos Mod (.Column + 1)) <> 0 Then
                      .curpos = .curpos + (.Column + 1) - (.curpos Mod (.Column + 1)) + ColOffset
                      Else
                       .curpos = .curpos + ColOffset
                      End If
                 If W4 Then LCTbasketCur Scr, prive
                       End If
                                  End If
                               
                              LCTbasketCur Scr, prive
                             
                                Else
                                 If work Then
                       .curpos = .curpos - ColOffset
                      If (.curpos Mod (.Column + 1)) <> 0 Then
                      .curpos = .curpos + (.Column + 1) - (.curpos Mod (.Column + 1)) + ColOffset
                      Else
                       .curpos = .curpos + ColOffset
                      End If
                 If W4 Then LCTbasketCur Scr, prive
                       End If
                               '' LCTbasketCur scr, prive
                                End If
                                
                                
'                                         GetXYb scr, prive, .curpos, .currow
                   ''  LCTbasketCur scr, prive
                x1 = .Column + .curpos + 1
                y1 = .currow + 1
                
                                pn& = 99
                             GoTo pthere   ' background and border and or images
            
            
                 End If
                         If Not FastSymbol(rest$, ")") Then RevisionPrint = False: Set Scr = Nothing: Exit Function
                         pn& = 99
    End If
    ElseIf FastSymbol(rest$, "@(", , 2) Then
    clearline = False
    w3 = -1
               'If Not par Then RevisionPrint = False: Set scr = Nothing: Exit Function
                If IsExp(basestack, rest$, p, , True) Then

                If par Then .curpos = CLng(Fix(p))
                End If
                
                If FastSymbol(rest$, ",") Then
                If IsExp(basestack, rest$, p, , True) Then
                If CLng(Fix(p)) >= .My Then
                If par Then .currow = .My - 1
                Else
                If par Then .currow = CLng(Fix(p))
                End If
                End If
                End If

                If FastSymbol(rest$, ",") Then
                
                If IsExp(basestack, rest$, p, , True) Then x1 = CLng(Fix(p))
                Else
                x1 = 1
                End If
                
                If FastSymbol(rest$, ",") Then
                If IsExp(basestack, rest$, p, , True) Then y1 = CLng(Fix(p))
                Else
                y1 = 1
                End If

                If FastSymbol(rest$, ",") Then
             '   On Error Resume Next
pthere:
                   
                If par Then LCTbasketCur Scr, prive
                If IsStrExp(basestack, rest$, s$) Then
                p = 0
                    If FastSymbol(rest$, ",") Then
                        If IsExp(basestack, rest$, p, , True) Then
                            If p <> 0 Then p = True
                        Else
                        p = True
                        End If
                    End If
             
                    x1 = Abs(x1 - .curpos)
                    y1 = Abs(y1 - .currow)
                    
                    If par Then BoxImage Scr, prive, x1, y1, s$, 0, (p)
                    'If P <> 0 Then .currow = y1 + .currow
                ElseIf IsExp(basestack, rest$, p, , True) Then
         
                    If par Then BoxColorNew Scr, prive, x1 - 1, y1 - 1, (p)
                    If FastSymbol(rest$, ",") Then
                        If IsExp(basestack, rest$, x, , True) Then
                            If par Then BoxBigNew Scr, prive, x1 - 1, y1 - 1, (x)
                            
                            
                            
                        Else
                            RevisionPrint = False
                            Set Scr = Nothing
                            Exit Function
                        End If
                    End If
                Else
                    RevisionPrint = False
                    Set Scr = Nothing
                    Exit Function
                
                End If

                End If
             If par Then LCTbasket Scr, prive, .currow, .curpos
                
        If Not FastSymbol(rest$, ")") Then
        RevisionPrint = False
        Set Scr = Nothing
        Exit Function
        End If
        work = False
        pn& = 99
        ElseIf LastErNum <> 0 Then
      RevisionPrint = LastErNum = -2
      Set Scr = Nothing
    Exit Function
    
    ElseIf FastSymbol(rest$, "$(", , 2) Then
conthere:
w3 = -1
        If IsExp(basestack, rest$, p, , True) Then
        If Not par Then p = 0
            .FTEXT = Abs(p) Mod 10
            ' 0 STANDARD LEFT chars before typed beyond the line are directed to the next line
            ' 1  RIGHT
            ' 2 CENTER
            ' 3 LEFT
            ' 4 LEFT PROP....expand to next .Column......
            ' 5 RIGHT PROP
            ' 6 CENTER PROP
            ' 7 LEFT PROP
            ' 8 left and right justify
            ' 9 New in version 8 Left justify(like 7) without word wrap (cut excess)
        ElseIf IsStrExp(basestack, rest$, s$) Then
            .FTXT = s$
        End If
        
        
        If FastSymbol(rest$, ",") Then
                If IsExp(basestack, rest$, p, , True) Then
                    If par Then
                        p = p - 1
                        If Abs(Int(p Mod (.mx + 1))) < 2 Then
                            MyEr ".Column minimum width is 4 chars", "��������� ������� ������ ����� �� �������� ����������"
                        Else
                            If W4 Or Not work Then
                                LCTbasketCur Scr, prive
                            Else
                                GetXYb Scr, prive, .curpos, .currow
                            End If
                            If W4 Then ColOffset = .curpos    ' now we have columns from offset ColOffset
                                .Column = Abs(Int(p Mod (.mx + 1)))
                            End If
                    End If
                    
                Else
                    RevisionPrint = False
                    Set Scr = Nothing
                    Exit Function
                End If
         End If
      
            If Not FastSymbol(rest$, ")") Then
            RevisionPrint = False
            Set Scr = Nothing
            Exit Function
            End If
        
        
        If par Then pn& = 99
        ElseIf LastErNum <> 0 Then
       RevisionPrint = LastErNum <> -2
       Set Scr = Nothing
    Exit Function
    ElseIf Not myobject Is Nothing Then
takeone:
    '' for arrays only
    If countDir >= 0 Then
    
    If counter = myobject.count Or (counter > Counterend And Counterend > -1) Or countDir = 0 Then
        Set myobject = Nothing
              SwapStrings rest$, bck$
            '  rest$ = bck$
            ' bck$ = vbNullString
        GoTo taketwo
    End If
Else
        If counter < 0 Or (counter < Counterend And Counterend > -1) Then
        Set myobject = Nothing
            SwapStrings rest$, bck$
             ' rest$ = bck$
            ' bck$ = vbNullString
        GoTo taketwo
    End If
    End If
    
    myobject.index = counter
    If myobject.IsEmpty Then
        s$ = " "
        counter = counter + countDir
        GoTo isAstring
    Else
            If Not IsNumeric(myobject.Value) Then
                If MyIsObject(myobject.Value) Then
                    s$ = " "
                Else
                    s$ = myobject.Value
                End If

                
                counter = counter + countDir
                GoTo isAstring
            Else
                p = myobject.Value
                counter = counter + countDir
                GoTo isanumber
            End If
    End If

    
    ElseIf IsExp(basestack, rest$, p) Then
            If Not basestack.lastobj Is Nothing Then
                
                If Typename(basestack.lastobj) = myArray Then
                Set myobject = basestack.lastobj
                Set basestack.lastobj = Nothing
                Counterend = -1
                counter = 0
                countDir = 1
                bck$ = vbNullString
                SwapStrings rest$, bck$
                'bck$ = rest$
                'rest$ = vbNullString
                GoTo takeone
                ElseIf Typename(basestack.lastobj) = "mHandler" Then
                    Set myobject = basestack.lastobj
                    Set basestack.lastobj = Nothing
                    With myobject
                    If myobject.UseIterator Then
                        If TypeOf myobject.objref Is Enumeration Then
                        p = myobject.objref.Value
                        Set myobject = Nothing
                        GoTo isanumber
                        Else
                        counter = myobject.index_start
                        Counterend = myobject.index_End
                        If counter <= Counterend Then countDir = 1 Else countDir = -1
                        End If
                        
                    Else
                        Counterend = -1
                        counter = 0
                        countDir = 1
                        If myobject.t1 = 4 Then
                    p = myobject.index_cursor
                    Set myobject = Nothing
                    GoTo isanumber
                        ElseIf Not CheckIsmArrayOrStackOrCollection(myobject) Then
                            Set myobject = Nothing
                            
                        Else
                                SwapStrings rest$, bck$
                                'bck$ = rest$
                                'rest$ = vbNullString
                                GoTo takeone
                        End If
                        
                    End If
                    End With
                    If Not CheckLastHandler(myobject) Then
                    NoProperObject
                    rest$ = bck$: RevisionPrint = False: Exit Function
                    End If

                    If Typename(myobject.objref) = "FastCollection" Then
                             Set myobject = myobject.objref
                             SwapStrings rest$, bck$
                        'bck$ = rest$
                        'rest$ = vbNullString
                        GoTo takeone
                    ElseIf Typename(myobject.objref) = "mStiva" Then
                        Set myobject = myobject.objref
                        SwapStrings rest$, bck$
                        'bck$ = rest$
                        'rest$ = vbNullString
                        GoTo takeone

                    ElseIf Typename(myobject.objref) = myArray Then
                        If myobject.objref.Arr Then
                            Set myobject = myobject.objref
                            SwapStrings rest$, bck$
                        'bck$ = rest$
                        'rest$ = vbNullString
                        GoTo takeone
                        End If
                   ElseIf Typename(myobject.objref) = "Enumeration" Then
                 
                 Set myobject = myobject.objref
                 
                            rest$ = bck$
                       GoTo takeone
                        End If
                ElseIf TypeOf basestack.lastobj Is VarItem Then
                    p = basestack.lastobj.ItemVariant
                End If
                Set basestack.lastobj = Nothing
            ElseIf VarType(p) = vbBoolean Then
            isboolean = True
            End If
isanumber:
        If par Then
            If .lastprint Then opn& = 5

            pn& = 1
            If .Column = 1 Then
            
            pn& = 6
            End If
            Else
            .lastprint = False
            pn& = 1
           End If
    ElseIf LastErNum <> 0 Then
            .lastprint = False
            RevisionPrint = LastErNum = -2
            Set Scr = Nothing
            Exit Function
    ElseIf IsStrExp(basestack, rest$, s$) Then
    ' special not good for every day...is 255 char in greek codepage
   '   If InStr(s$, ChrW(&HFFFFF8FB)) > 0 Then s$ = Replace(s$, ChrW(&HFFFFF8FB), ChrW(&H2007))
     If Not basestack.lastobj Is Nothing Then
                If Typename(basestack.lastobj) = myArray Then
                Set myobject = basestack.lastobj
                Set basestack.lastobj = Nothing
                Counterend = -1
                counter = 0
                countDir = 1
                SwapStrings rest$, bck$
                'bck$ = rest$
                'rest$ = vbNullString
                GoTo takeone
                End If
                
            End If
isAstring:
If par Then

    If .lastprint Then opn& = 5
            pn& = 2
            
      If .Column = 1 Then
            
            pn& = 7
            End If
            Else
             .lastprint = False
            pn& = 2
            End If
    ElseIf LastErNum <> 0 Then
             RevisionPrint = LastErNum = -2
             Set Scr = Nothing
                Exit Function
    Else
    If pn& <> 0 And pn& < 5 And Not .lastprint Then
        If par Then
            If Not W4 Then
          '' GetXYb scr, prive, .curpos, .currow

If Not (.curpos = 0) Then
GetXYb Scr, prive, .curpos, .currow
If pn& = 1 Then
crNew basestack, prive: skiplast = True
ElseIf pn& = 2 Then

If Abs(w3) = 1 And .curpos = 0 And Not (.FTEXT = 9 Or .FTEXT = 5 Or .FTEXT = 6) Then
If .FTEXT = 7 Then
crNew basestack, prive: skiplast = True
End If
Else
crNew basestack, prive: skiplast = True
End If
End If
End If


            End If
        Else
        If F < 0 Then
            crNew basestack, prive
        ElseIf uni(F) Then
            putUniString F, vbCrLf
            Else
            putANSIString F, vbCrLf
            'Print #f,
            End If
        End If
    End If
 
        Exit Do
    End If
conthere2:
If .lastprint And opn& > 4 Then .lastprint = False
    If FastSymbol(rest$, ";") Then
'' LEAVE W3
If par Then
   If opn& = 0 And (Not work) And (Not .lastprint) Then

   LCTbasket Scr, prive, .currow, .curpos
   End If
  
   ' IF  WORK THEN opn&=5
   opn& = 5
  End If
newntrance:
work = True
.lastprint = True
        
         Do While FastSymbol(rest$, ";")
         Loop
    ElseIf Not FastSymbol(rest$, ",") Then
    
    pn& = pn& + opn&
  opn& = 0
  rest$ = NLtrim$(rest$)
 If Len(rest$) > 0 Then If Not MaybeIsSymbol(rest$, " : }\'" + vbCr) Then Exit Function

    Else
If par Then
ihavecoma = True ' 'rest$ = "," & rest$
End If
    End If
    pn& = pn& + opn&
    Select Case pn&
    Case 0
    Exit Do
    Case 1
        If .FTXT = vbNullString Then
        If xa Then
        s$ = PACKLNG2$(p)
        Else
If NoUseDec Then
    If isboolean Then
        If ShowBooleanAsString Then
            If cLid = 1032 Then
                s$ = Format$(p, ";\�\�\�\�\�\�;\�\�\�\�\�\�")
            ElseIf cLid = 1033 Then
                s$ = Format$(p, ";\T\r\u\e;\F\a\l\s\e")
            Else
                s$ = Format$(p, DefBooleanString)
            End If
            isboolean = False
            GoTo contboolean2
        Else
            p = p * 1
            isboolean = False
            GoTo contboolean
        End If
    Else
        s$ = CStr(p)
    End If
Else

If isboolean Then
    If ShowBooleanAsString Then
        If cLid = 1032 Then
            s$ = Format$(p, ";\�\�\�\�\�\�;\�\�\�\�\�\�")
        ElseIf cLid = 1033 Then
            s$ = Format$(p, ";\T\r\u\e;\F\a\l\s\e")
        Else
            s$ = Format$(p, DefBooleanString)
        End If
        isboolean = False
        GoTo contboolean2
    Else
        p = p * 1
        isboolean = False
        GoTo contboolean
    End If
Else
contboolean:
On Error Resume Next
 s$ = LTrim$(Str(p))
 If Err Then s$ = Typename$(p): Err.Clear
    If Left$(s$, 1) = "." Then
    s$ = "0" + s$
    ElseIf Left$(s$, 2) = "-." Then s$ = "-0" + Mid$(s$, 2)
 End If
 
 If OverideDec Then s$ = Replace$(s$, ".", NowDec$)
 End If
End If
contboolean2:
      If .FTEXT < 4 Then
            If InStr(s$, ".") > 0 Then
                 If InStr(s$, ".") <= .Column Then
                        If RealLen(s$) > .Column + 1 Then
                                 If .FTEXT > 0 Then s$ = Left$(s$, .Column + 1)
                        End If
                End If
            ElseIf .FTEXT > 0 Then
                 If RealLen(s$) > .Column + 1 Then s$ = String$(.Column, "?")
            End If
          End If
    End If
        Else
        s$ = Format$(p, .FTXT)
        If Not NoUseDec Then
            If OverideDec Then
                s$ = Replace$(s$, GetDeflocaleString(LOCALE_SDECIMAL), Chr(2))
                s$ = Replace$(s$, GetDeflocaleString(LOCALE_STHOUSAND), Chr(3))
                s$ = Replace$(s$, Chr(2), NowDec$)
                s$ = Replace$(s$, Chr(3), NowThou$)
                
            ElseIf InStr(s$, NowDec$) > 0 And InStr(.FTXT, ".") > 0 Then
                ElseIf InStr(s$, NowDec$) > 0 Then
                s$ = Replace$(s$, NowDec$, Chr(2))
                s$ = Replace$(s$, NowThou$, Chr(3))
                s$ = Replace$(s$, Chr(2), ".")
                s$ = Replace$(s$, Chr(3), ",")
            
            End If
            End If
        End If
     If par Then
        If .Column > 2 Then   ' .Column 3 means 4 chars width
        If opn& < 5 Then
    '                    ensure that we are align in .Column  (.Column is based zero...)
    skiplast = False
               If .currow >= .My Then
               If Not W4 Then crNew basestack, prive: skiplast = True
               End If
        
                        If work Then
                       .curpos = .curpos - ColOffset
                      If (.curpos Mod (.Column + 1)) <> 0 Then
                      .curpos = .curpos + (.Column + 1) - (.curpos Mod (.Column + 1)) + ColOffset
                      Else
                       .curpos = .curpos + ColOffset
                      End If
                 If W4 Then LCTbasketCur Scr, prive
                       End If
                       work = True
    End If
            If .curpos >= .mx Then
    '' ???
                    Else
            If clearline And .curpos = 0 Then Scr.Line (0&, .currow * .Yt)-((.mx - 1) * .Xt + .Xt * 2, (.currow) * .Yt + .Yt - 1 * DYP), .Paper, BF
            Select Case .FTEXT
            Case 0
            
                          
                       PlainBaSket Scr, prive, Space$(.Column - (RealLen(s$) - 1) Mod (.Column + 1)) + s$, W4, W4, , clearline
                       
            Case 3
                        PlainBaSket Scr, prive, Right$(Space$(.Column - (RealLen(s$) - 1) Mod (.Column + 1)) + Left$(s$, .Column + 1), .Column + 1), W4, W4, , clearline
            Case 2
                        If RealLen(s$) > .Column + 1 Then s$ = "????"
                        PlainBaSket Scr, prive, Left$(Space$((.Column + 1 - RealLen(s$)) \ 2) + Left$(s$, .Column + 1) & Space$(.Column), .Column + 1), W4, W4, , clearline
            Case 1
                        PlainBaSket Scr, prive, Left$(s$ & Space$(.Column), .Column + 1), W4, W4, , clearline
            Case 5
                        x1 = .curpos
                        y1 = .currow
                        If Not (.mx - 1 <= .curpos And W4 <> 0) Then
                        LCTbasketCur Scr, prive
                        Scr.CurrentX = Scr.CurrentX + (.Xt - TextWidth(Scr, Left$(s$, 1))) \ 2
                        wwPlain basestack, prive, s$, .Column * .Xt + .Xt - (.Xt - TextWidth(Scr, Left$(s$, 1))) \ 2, 0, , True, 0, , CBool(W4), True, , True
                        .currow = y1
        

                        .curpos = x1 + .Column + 1
                        
                        End If
                     If .curpos >= .mx And Not W4 Then
                   
                         .currow = .currow + 1
                         .curpos = 0
                         End If
              If .lastprint Then
     
                 If .curpos = 0 Then
                 If .currow >= .My Then crNew basestack, prive Else LCTbasketCur Scr, prive
                 End If
                 
     Scr.CurrentX = .curpos * .Xt
                
                  Scr.CurrentY = .currow * .Yt + .uMineLineSpace
             
         
                   End If
            Case 4, 7, 8
                         wwPlain basestack, prive, s$ & vbCrLf, .Column * .Xt + .Xt - (.Xt - TextWidth(Scr, Right$(s$, 1))) \ 2, 0, , , 1, , , pn& < 5, , True
                        .curpos = .curpos + .Column + 1
                        If .curpos >= .mx And Not W4 Then
                                .curpos = 0
                                .currow = .currow + 1

                        End If
                        If .lastprint Then
                            If .curpos = 0 Then
                                If .currow >= .My Then
                                crNew basestack, prive
                                
                             
                              
                                Else
                                LCTbasketCur Scr, prive

                                End If
                            End If
                            If .curpos > 0 Then Scr.CurrentX = .curpos * .Xt - (.Xt - TextWidth(Scr, Right$(s$, 1))) \ 2 Else Scr.CurrentX = .curpos * .Xt
                            Scr.CurrentY = .currow * .Yt + .uMineLineSpace
                        End If
            Case 6
                            
                        wwPlain basestack, prive, s$, .Column * .Xt + .Xt, 0, , False, 2, , , pn& < 5, , True
                        .curpos = .curpos + .Column + 1
                        If .curpos >= .mx And Not W4 Then
                            .curpos = 0
                            .currow = .currow + 1
                        End If
                        If .lastprint Then
                            If .curpos = 0 Then
                                If .currow >= .My Then crNew basestack, prive Else LCTbasketCur Scr, prive
                            End If
                            Scr.CurrentX = .curpos * .Xt
                            Scr.CurrentY = .currow * .Yt + .uMineLineSpace
                        End If
                            
            Case 9
                            LCTbasketCur Scr, prive
                            wPlain Scr, prive, s$, 1000, 0, True
                             GetXYb Scr, prive, .curpos, .currow
                           .curpos = .curpos + 1
                            If (.curpos Mod (.Column + 1)) <> 0 Then
                     .curpos = .curpos + (.Column + 1) - (.curpos Mod (.Column + 1)) + ColOffset
                      Else
                       .curpos = .curpos + ColOffset
                      End If
                             '     .curpos = .curpos + .Column + 1
                            If .curpos >= .mx And Not W4 Then
                                .curpos = 0
                                .currow = .currow + 1
                            End If
                                                               If .lastprint Then
     
                 If .curpos = 0 Then
                 If .currow >= .My Then crNew basestack, prive Else LCTbasketCur Scr, prive
                 End If
                If .curpos > 0 Then Scr.CurrentX = .curpos * .Xt - (.Xt - TextWidth(Scr, Right$(s$, 1))) \ 2 Else Scr.CurrentX = .curpos * .Xt
                  Scr.CurrentY = .currow * .Yt + .uMineLineSpace
             
         
                   End If
            End Select
End If
            
            
            
        Else
        ' no way to use this any more...7 rev 20
        PlainBaSket Scr, prive, s$
        End If
 
        Else
          If F < 0 Then
            PlainBaSket Scr, prive, s$
        ElseIf uni(F) Then
            putUniString F, s$
            Else
            putANSIString F, s$
        'Print #f, S$;
        End If
        End If
    Case 2
    '' for string.....................................................................................................................
        If .FTXT <> "" Then
        s$ = Format$(s$, .FTXT)
        End If
        If par Then
        If .Column > 0 Then
                             x1 = .curpos: y1 = .currow
                skiplast = False
                                If .currow >= .My And Not W4 Then
                                crNew basestack, prive
                                skiplast = True
                                End If
                        If work Then
                       .curpos = .curpos - ColOffset
                      If (.curpos Mod (.Column + 1)) <> 0 Then
                      .curpos = .curpos + (.Column + 1) - (.curpos Mod (.Column + 1)) + ColOffset
                      Else
                       .curpos = .curpos + ColOffset
                     
                      End If
                      '' LCTbasket scr, prive,   y1, X1
                       If W4 Then LCTbasketCur Scr, prive
                       End If
                       work = True
          If s$ = vbNullString Then s$ = " "
          
                 If .curpos >= .mx Then
                 y1 = 1
                    Else
                               If clearline And .curpos = 0 Then Scr.Line (0&, .currow * .Yt)-((.mx - 1) * .Xt + .Xt * 2, (.currow) * .Yt + .Yt - 1 * DYP), .Paper, BF

            Select Case .FTEXT
                Case 1
                           '' GetXY scr, X1, y1
                          ''  If s$ = VbNullString Then s$ = " "
                          dlen = RealLen(s$)
                          PlainBaSket Scr, prive, Left$(s$ & Space$(Len(s$) - dlen + .Column - (dlen - 1) Mod (.Column + 1)), .Column + 1 + Len(s$) - dlen), W4, W4, , clearline
                Case 2
                            dlen = RealLen(s$)
                            If dlen > (.Column + 1 + Len(s$) - dlen) Then s$ = Left$(s$, .Column + 1 + Len(s$) - dlen):  dlen = RealLen(s$)
                            
                            PlainBaSket Scr, prive, Left$(Space$((.Column + 1 + Len(s$) - dlen - dlen) \ 2) + s$ & Space$(.Column), .Column + 1 + Len(s$) - dlen), W4, W4, , clearline
                Case 3
                            dlen = RealLen(s$)
                            PlainBaSket Scr, prive, Right$(Space$(.Column + Len(s$) - dlen - (dlen - 1) Mod (.Column + 1)) & s$, .Column + 1 + Len(s$) - dlen), W4, W4, , clearline
                Case 0
                           '' If s$ = VbNullString Then s$ = " "
                        
                            PlainBaSket Scr, prive, s$ + Space$(.Column - (RealLen(s$) - 1) Mod (.Column + 1)), W4, W4, , clearline
                       
                Case 4
                            
                            LCTbasketCur Scr, prive
                            Scr.CurrentX = Scr.CurrentX + (.Xt - TextWidth(Scr, Left$(s$, 1))) \ 2
                            
                            w3 = 0
                            wwPlain basestack, prive, s$, Scr.Width, 0, , True, 0, , w3, True
                            w3 = w3 \ .Xt + 1
                            ' go to next .Column...
                            
                            .curpos = (.Column + 1) * ((w3 + .Column + 1) \ (.Column + 1))
                        If .curpos >= .mx And Not W4 Then
                                .curpos = 0
                                .currow = .currow + 1
                            End If
                Case 5
                           '' GetXY scr, X1, y1
                            LCTbasketCur Scr, prive
                            Scr.CurrentX = Scr.CurrentX + (.Xt - TextWidth(Scr, Left$(s$, 1))) \ 2
                            wwPlain basestack, prive, s$, .Column * .Xt + .Xt - (.Xt - TextWidth(Scr, Left$(s$, 1))) \ 2, 0, , True, 3, , , True
                            .curpos = .curpos + .Column + 1
                            If .curpos >= .mx And Not W4 Then
                                .curpos = 0
                                .currow = .currow + 1
                            End If
                Case 6
                        ''    LCTbasketCur scr, prive
                            wwPlain basestack, prive, s$, .Column * .Xt + .Xt, 0, , False, 2, , , True
                                        .curpos = .curpos + .Column + 1
                            If .curpos >= .mx And Not W4 Then
                                .curpos = 0
                                .currow = .currow + 1
                             End If
                Case 7
                            
                            LCTbasketCur Scr, prive
                    work2 = Scr.CurrentY
                            
                            wwPlain basestack, prive, s$ & vbCrLf, .Column * .Xt + .Xt - (.Xt - TextWidth(Scr, Right$(s$, 1))) \ 2, 0, , True, 1, , , True, , True
                       Scr.CurrentY = work2
                            .curpos = .curpos + .Column + 1
                            If .curpos >= .mx And Not W4 Then
                                .curpos = 0
                                .currow = .currow + 1
                            End If
                Case 8
                            LCTbasketCur Scr, prive
                            Scr.CurrentX = Scr.CurrentX + (.Xt - TextWidth(Scr, Left$(s$, 1))) \ 2
                            If Not (.mx - 1 <= x1 And W4 <> 0) Then
                                    wwPlain basestack, prive, s$, .Column * .Xt + .Xt - (.Xt - TextWidth(Scr, Left$(s$, 1))) \ 2, 0, , True, 0, , , True
                            End If
                            .curpos = .curpos + .Column + 1
                            If .curpos >= .mx And Not W4 Then
                                .curpos = 0
                                .currow = .currow + 1
                            End If
                Case 9
                            LCTbasketCur Scr, prive

              wPlain Scr, prive, s$, .Column + 1, 0, True
                GetXYb Scr, prive, .curpos, .currow
                          .curpos = .curpos + 1
                            If (.curpos Mod (.Column + 1)) <> 0 Then
                     .curpos = .curpos + (.Column + 1) - (.curpos Mod (.Column + 1)) + ColOffset
                      Else
                       .curpos = .curpos + ColOffset
                      End If
                            If .curpos >= .mx And Not W4 Then
                                .curpos = 0
                                .currow = .currow + 1
                            End If
                End Select
                End If
        Else
            PlainBaSket Scr, prive, s$
        
        End If
        Else
              If F < 0 Then
            PlainBaSket Scr, prive, s$
        ElseIf uni(F) Then
            putUniString F, s$
            Else
            putANSIString F, s$
        'Print #f, S$;
        End If
        End If
    Case 6
        If par Then
                If .FTEXT > 3 Then
            w3 = 0
             x1 = .curpos
             y1 = .currow
                        If .FTXT <> "" Then
                                       s$ = Format$(p, .FTXT)
            If Not NoUseDec Then
               If OverideDec Then
                s$ = Replace$(s$, GetDeflocaleString(LOCALE_SDECIMAL), Chr(2))
                s$ = Replace$(s$, GetDeflocaleString(LOCALE_STHOUSAND), Chr(3))
                s$ = Replace$(s$, Chr(2), NowDec$)
                s$ = Replace$(s$, Chr(3), NowThou$)
                
            ElseIf InStr(s$, NowDec$) > 0 And InStr(.FTXT, ".") > 0 Then
                s$ = Replace$(s$, NowDec$, Chr(2))
                s$ = Replace$(s$, NowThou$, Chr(3))
                s$ = Replace$(s$, Chr(2), ".")
                s$ = Replace$(s$, Chr(3), ",")
            
            End If
            End If
                               
                                If .FTEXT > 4 And Not work Then Scr.CurrentX = Scr.CurrentX + (.Xt - TextWidth(Scr, Left$(s$, 1))) \ 2
                                If Scr.CurrentX < .mx * .Xt Then
                            
                                wwPlain basestack, prive, s$, Scr.Width, 0, , True, 0, , w3
                                
                                End If
                                
                        Else
                                 If xa Then
                                        s$ = PACKLNG2$(p)
                                Else
                                If NoUseDec Then
                                       s$ = CStr(p)
                                    Else
                                     s$ = LTrim$(Str(p))
                                      If Left$(s$, 1) = "." Then
                                        s$ = "0" + s$
                                        ElseIf Left$(s$, 2) = "-." Then s$ = "-0" + Mid$(s$, 2)
                                        End If
                                     If OverideDec Then s$ = Replace$(s$, ".", NowDec$)
                                    End If
                                End If

                                If .FTEXT > 4 And Not work Then Scr.CurrentX = Scr.CurrentX + (.Xt - TextWidth(Scr, Left$(s$, 1))) \ 2
                                      If Scr.CurrentX < 0 Then
                             
                                
                                
                                End If
                                wwPlain basestack, prive, s$, Scr.Width, 0, , True, 0, , w3
                                work = True
                                Scr.CurrentX = w3
                         
                                            
                        End If
                      '' Then LCTbasket scr, prive, y1, W3 \ .Xt + 1
                Else
                        If .FTXT = vbNullString Then
                      
                                If xa Then
                                    PlainBaSket Scr, prive, PACKLNG2$(p)
                                Else
                                  If NoUseDec Then
                                    s$ = CStr(p)
                                        Else
                                            s$ = LTrim$(Str(p))
                                                If Left$(s$, 1) = "." Then
                                                s$ = "0" + s$
                                                ElseIf Left$(s$, 2) = "-." Then s$ = "-0" + Mid$(s$, 2)
                                                End If
                                            If OverideDec Then s$ = Replace$(s$, ".", NowDec$)
                                        End If
                                    PlainBaSket Scr, prive, s$
                                End If
                        Else
                      s$ = Format$(p, .FTXT)
            If Not NoUseDec Then
                If OverideDec Then
                    s$ = Replace$(s$, GetDeflocaleString(LOCALE_SDECIMAL), Chr(2))
                    s$ = Replace$(s$, GetDeflocaleString(LOCALE_STHOUSAND), Chr(3))
                    s$ = Replace$(s$, Chr(2), NowDec$)
                    s$ = Replace$(s$, Chr(3), NowThou$)
                ElseIf InStr(s$, NowDec$) > 0 And InStr(.FTXT, ".") > 0 Then
                    s$ = Replace$(s$, NowDec$, Chr(2))
                    s$ = Replace$(s$, NowThou$, Chr(3))
                    s$ = Replace$(s$, Chr(2), ".")
                    s$ = Replace$(s$, Chr(3), ",")
                
                End If
            End If
      
                            PlainBaSket Scr, prive, s$
                        End If
                End If
        Else
              If F < 0 Then
            PlainBaSket Scr, prive, s$
        ElseIf uni(F) Then
            putUniString F, s$
            Else
            putANSIString F, s$
        ' Print #f, S$;
        End If
        End If
    Case 7
        If par Then
        If s$ <> "" Then
           If .FTEXT > 3 Then
            w3 = 0
             x1 = .curpos
             y1 = .currow
            If Not work Then LCTbasketCur Scr, prive
              If .FTXT <> "" Then s$ = Format$(s$, .FTXT)
                        If .FTEXT > 4 And Not work Then Scr.CurrentX = Scr.CurrentX + (.Xt - TextWidth(Scr, Left$(s$, 1))) \ 2
                        wwPlain basestack, prive, s$, Scr.Width, 0, , True, 0, , w3
                        work = True
                       Scr.CurrentX = w3
            Else
                If .FTXT <> "" Then
                PlainBaSket Scr, prive, Format$(s$, .FTXT), , , , clearline
                Else
                PlainBaSket Scr, prive, s$, , , , clearline
                End If
                
            End If
        Else

          
        End If
   
        Else
              If F < 0 Then
            PlainBaSket Scr, prive, s$
        ElseIf uni(F) Then
            putUniString F, s$
            Else
            putANSIString F, s$
        ' Print #f, S$;
        End If
        End If
    End Select
taketwo:
If ihavecoma Then
ihavecoma = False
GoTo cont12344
    ElseIf FastSymbol(rest$, ",") Then
cont12344:
        w3 = 1
        pn& = 0
      ''  skiplast = False
        If opn& > 4 Then
            Scr.CurrentX = Scr.CurrentX + .Xt - dv15
            GetXYb Scr, prive, .curpos, .currow
            If work Then
                .curpos = .curpos - ColOffset
                If (.curpos Mod (.Column + 1)) <> 0 Then
                    .curpos = .curpos + (.Column + 1) - (.curpos Mod (.Column + 1)) + ColOffset
                Else
                    .curpos = .curpos + ColOffset
                End If
                If W4 Then LCTbasketCur Scr, prive
            End If
            work = True
        Else
            work = False
        End If
        opn& = 0
        Do While FastSymbol(rest$, ",")
            If par Then
            ' ok I want that
            If .Column > .mx And .FTEXT < 4 Then
            Else
                If Not W4 Then
                    If Not skiplast Then crNew basestack, prive
                End If
            End If
            Else
                If F < 0 Then
                    crNew basestack, prive
                    
                ElseIf uni(F) Then
                    putUniString F, vbCrLf
                Else
                    putANSIString F, vbCrLf
            'Print #f,
                End If
            End If
        Loop
    End If
If par Or F < 0 Then players(basketcode) = prive
Loop

If W4 <> 0 And par Then
        .FTEXT = oldFTEXT
        .FTXT = oldFTXT
        .Column = oldCol
        If .mypen <> oldpen Then .mypen = oldpen: TextColor Scr, oldpen
        ElseIf par Then
        If pn& > 4 And opn& = 0 Then
        
                 If pn& < 99 Then
                 If work Then
                 .lastprint = False
                 End If
                 If Not skiplast Then crNew basestack, prive
                 End If
        ElseIf .currow >= .My Or (w3 < 0 And pn& = 0) Then
              crNew basestack, prive
              LCTbasketCur Scr, prive
        ElseIf pn& > 4 Then
       
        End If

End If
EXITNOW:
If basestack.IamThread Then
' let thread do the refresh
ElseIf par Then
    If Not extreme Then
    PrintRefresh basestack, Scr
    End If
End If
RevisionPrint = True
If par Or F < 0 Then players(basketcode) = prive
If myexit(basestack) Then Exit Function
End With
End Function

Private Function MyMod(r1, po) As Variant
MyMod = r1 - Fix(r1 / po) * po
End Function
Sub dset()

'USING the temporary path
    strTemp = String(MAX_FILENAME_LEN, Chr$(0))
    'Get
    GetTempPath MAX_FILENAME_LEN, StrPtr(strTemp)
    strTemp = LONGNAME(mylcasefILE(Left$(strTemp, InStr(strTemp, Chr(0)) - 1)))
    If strTemp = vbNullString Then
     strTemp = mylcasefILE(Left$(strTemp, InStr(strTemp, Chr(0)) - 1))
    End If
' NOW COPY
' for mcd
Dim cd As String, dummy As Long, q$

''cd = App.Path
''AddDirSep cd
''mcd = mylcasefILE(cd)

' Return to standrad path...for all users
userfiles = GetSpecialfolder(CLng(26)) & "\M2000"
AddDirSep userfiles
If Not isdir(userfiles) Then
MkDir userfiles
End If

mcd = userfiles
DefaultDec$ = GetDeflocaleString(LOCALE_SDECIMAL)
If NowDec$ <> "" Then
ElseIf OverideDec Then
NowDec$ = GetlocaleString(LOCALE_SDECIMAL)
NowThou$ = GetlocaleString(LOCALE_STHOUSAND)
Else
NowDec$ = DefaultDec$
NowThou$ = GetDeflocaleString(LOCALE_STHOUSAND)
End If
CheckDec
cdecimaldot$ = GetDeflocaleString(LOCALE_SDECIMAL)
End Sub
Public Sub CheckDec()
OverideDec = False
NowDec$ = GetDeflocaleString(LOCALE_SDECIMAL)
NowThou$ = GetDeflocaleString(LOCALE_STHOUSAND)
If NowDec$ = "." Then
NoUseDec = False
Else
NoUseDec = mNoUseDec
End If
End Sub
Function ProcEnumGroup(bstack As basetask, rest$, Optional glob As Boolean = False) As Boolean

    Dim s$, w1$, v As Long, enumvalue As Long, myenum As Enumeration, mh As mHandler, v1 As Long
    enumvalue = 0
    If IsLabelOnly(rest$, w1$) = 1 Then
       ' w1$ = myUcase$(w1$)
        v = globalvar(bstack.GroupName + w1$, v, , glob)
        Set myenum = New Enumeration
        
        myenum.EnumName = w1$
        Else
        MyEr "No proper name for enumeration", "�� �������� ����� ��� ����������"
        Exit Function
    End If
    If FastSymbol(rest$, "{") Then
        s$ = block(rest$)
        
        Do
        If FastSymbol(s$, vbCrLf, , 2) Then
        While FastSymbol(s$, vbCrLf, , 2)
        Wend
        ElseIf IsLabelOnly(s$, w1$) = 1 Then
            'w1 = myUcase(w1$)
            If FastSymbol(s$, "=") Then
            If IsExp(bstack, s$, enumvalue) Then
                If Not bstack.lastobj Is Nothing Then
                    MyEr "No Object allowed as enumeration value", "��� ����������� ����������� ��� ���� ����������"
                    Exit Function
                    End If
                End If
            Else
                    enumvalue = enumvalue + 1
            End If
            myenum.AddOne w1$, enumvalue
            Set mh = New mHandler
            Set mh.objref = myenum
            mh.t1 = 4
            mh.ReadOnly = True
            mh.index_cursor = enumvalue
            mh.index_start = myenum.count - 1
             v1 = globalvar(bstack.GroupName + w1$, v1, , glob)
             Set var(v1) = mh
            ProcEnumGroup = True
        Else
            Exit Do
        End If
        If FastSymbol(s$, ",") Then ProcEnumGroup = False
        Loop
        If v1 > v Then Set var(v) = var(v1) Else MyEr "Empty Enumeration", "����� ����������": Exit Function
        ProcEnumGroup = FastSymbol(rest$, "}", True)
    Else
        MissingEnumBlock
        Exit Function
    End If
    
    
End Function
Function ProcEnum(bstack As basetask, rest$, Optional glob As Boolean = False) As Boolean

    Dim s$, w1$, v As Long, enumvalue As Long, myenum As Enumeration, mh As mHandler, v1 As Long
    enumvalue = 0
    If IsLabelOnly(rest$, w1$) = 1 Then
       ' w1$ = myUcase$(w1$)
        v = globalvar(w1$, v, , glob)
        Set myenum = New Enumeration
        
        myenum.EnumName = w1$
        Else
        MyEr "No proper name for enumeration", "�� �������� ����� ��� ����������"
        Exit Function
    End If
    If FastSymbol(rest$, "{") Then
        s$ = block(rest$)
        
        Do
        If FastSymbol(s$, vbCrLf, , 2) Then
        While FastSymbol(s$, vbCrLf, , 2)
        Wend
        ElseIf IsLabelOnly(s$, w1$) = 1 Then
            'w1 = myUcase(w1$)
            If FastSymbol(s$, "=") Then
            If IsExp(bstack, s$, enumvalue) Then
                If Not bstack.lastobj Is Nothing Then
                    MyEr "No Object allowed as enumeration value", "��� ����������� ����������� ��� ���� ����������"
                    Exit Function
                    End If
                End If
            Else
                    enumvalue = enumvalue + 1
            End If
            myenum.AddOne w1$, enumvalue
            Set mh = New mHandler
            Set mh.objref = myenum
            mh.t1 = 4
            mh.ReadOnly = True
            mh.index_cursor = enumvalue
            mh.index_start = myenum.count - 1
             v1 = globalvar(w1$, v1, , glob)
             Set var(v1) = mh
            ProcEnum = True
        Else
            Exit Do
        End If
        If FastSymbol(s$, ",") Then ProcEnum = False
        Loop
        If v1 > v Then Set var(v) = var(v1) Else MyEr "Empty Enumeration", "����� ����������": Exit Function
        ProcEnum = FastSymbol(rest$, "}", True)
    Else
        MissingEnumBlock
        Exit Function
    End If
    
    
End Function

