Attribute VB_Name = "Module9"
Option Explicit
Private Declare Function EnumDisplayMonitors Lib "user32" (ByVal hDC As Long, lprcClip As Any, ByVal lpfnEnum As Long, dwData As Any) As Long
Public Declare Function MonitorFromPoint Lib "user32" (ByVal x As Long, ByVal y As Long, ByVal dwFlags As Long) As Long
Private Declare Function MonitorFromWindow Lib "user32" (ByVal hWND As Long, ByVal dwFlags As Long) As Long

Private Declare Function GetMonitorInfo Lib "user32" Alias "GetMonitorInfoA" (ByVal hmonitor As Long, ByRef lpmi As MONITORINFO) As Long
Private Declare Function GetWindowRect Lib "user32" (ByVal hWND As Long, lpRect As RECT) As Long
Private Declare Function UnionRect Lib "user32" (lprcDst As RECT, lprcSrc1 As RECT, lprcSrc2 As RECT) As Long
Private Declare Function OffsetRect Lib "user32" (lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
Private Declare Function MoveWindow Lib "user32" (ByVal hWND As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal bRepaint As Long) As Long
'Private Type RECT
 '   Left As Long
  '  Top As Long
   ' Right As Long
    'Bottom As Long
'End Type
Private Type MONITORINFO
    cbSize As Long
    rcMonitor As RECT
    rcWork As RECT
    dwFlags As Long
End Type
Public Const MONITORINFOF_PRIMARY = &H1
Public Const MONITOR_DEFAULTTONEAREST = &H2
Public Const MONITOR_DEFAULTTONULL = &H0
Public Const MONITOR_DEFAULTTOPRIMARY = &H1
Dim rcMonitors() As RECT 'coordinate array for all monitors
Dim rcVS         As RECT 'coordinates for Virtual Screen

Public Type Screens
    Top As Long
    Left As Long
    Height As Long
    Width As Long
    primary As Boolean
    handler As Long
End Type
Public ScrInfo() As Screens
Public Console As Long
' MI.dwFlags = MONITORINFOF_PRIMARY

Private Const SM_CXVIRTUALSCREEN = 78
Private Const SM_CYVIRTUALSCREEN = 79
Private Const SM_CMONITORS = 80
Private Const SM_SAMEDISPLAYFORMAT = 81

Private Declare Function GetSystemMetrics Lib "user32" ( _
   ByVal nIndex As Long) As Long

Public Property Get VirtualScreenWidth() As Long
If IsWine Then
   VirtualScreenWidth = (GetSystemMetrics(SM_CXVIRTUALSCREEN)) * dv15 - 1
Else
   VirtualScreenWidth = (GetSystemMetrics(SM_CXVIRTUALSCREEN)) * dv15
   End If
End Property
Public Property Get VirtualScreenHeight() As Long
If IsWine Then
VirtualScreenHeight = (GetSystemMetrics(SM_CYVIRTUALSCREEN)) * dv15 - 1
Else
   VirtualScreenHeight = (GetSystemMetrics(SM_CYVIRTUALSCREEN)) * dv15
   End If
End Property
Public Property Get DisplayMonitorCount() As Long
   DisplayMonitorCount = GetSystemMetrics(SM_CMONITORS)
End Property
Public Property Get AllMonitorsSame() As Long
   AllMonitorsSame = GetSystemMetrics(SM_SAMEDISPLAYFORMAT)
End Property
Public Sub GetMonitorsNow()
  Dim n As Long
    EnumDisplayMonitors 0, ByVal 0&, AddressOf MonitorEnumProc, n
    Console = FindMonitorFromMouse
End Sub
Function EnumMonitors(F As Form) As Long
    Dim n As Long
    EnumDisplayMonitors 0, ByVal 0&, AddressOf MonitorEnumProc, n
    With F
        .Move .Left, .Top, (rcVS.Right - rcVS.Left) * 2 + .Width - .ScaleWidth, (rcVS.Bottom - rcVS.Top) * 2 + .Height - .ScaleHeight
    End With
    F.Scale (rcVS.Left, rcVS.Top)-(rcVS.Right, rcVS.Bottom)
    F.Caption = n & " Monitor" & IIf(n > 1, "s", vbNullString)
    F.lblMonitors(0).Appearance = 0 'Flat
    F.lblMonitors(0).BorderStyle = 1 'FixedSingle
    For n = 0 To n - 1
        If n Then
            Load F.lblMonitors(n)
            F.lblMonitors(n).Visible = True
        End If
        With rcMonitors(n)
            F.lblMonitors(n).Move .Left, .Top, .Right - .Left, .Bottom - .Top
            F.lblMonitors(n).Caption = "Monitor " & n + 1 & vbLf & _
                .Right - .Left & " x " & .Bottom - .Top & vbLf & _
                "(" & .Left & ", " & .Top & ")-(" & .Right & ", " & .Bottom & ")"
        End With
    Next
End Function
Private Function MonitorEnumProc(ByVal hmonitor As Long, ByVal hdcMonitor As Long, lprcMonitor As RECT, dwData As Long) As Long
    Dim mi As MONITORINFO
    ReDim Preserve rcMonitors(dwData)
    ReDim Preserve ScrInfo(dwData)
    rcMonitors(dwData) = lprcMonitor
    mi.cbSize = Len(mi)
    GetMonitorInfo hmonitor, mi
    
    With ScrInfo(dwData)
    'If IsWine And mi.rcMonitor.Left = 0 And mi.rcMonitor.Top = 0 Then
     '   .Left = 1
      '  .Top = 1
        
   ' Else
    .Left = mi.rcMonitor.Left * dv15
    
    .Top = mi.rcMonitor.Top * dv15
    'End If
    
    .Height = (mi.rcMonitor.Bottom - mi.rcMonitor.Top + 1) * dv15
    .Width = (mi.rcMonitor.Right - mi.rcMonitor.Left + 1) * dv15
    .primary = CBool(mi.dwFlags = MONITORINFOF_PRIMARY)
    .handler = hmonitor
    End With
    UnionRect rcVS, rcVS, lprcMonitor 'merge all monitors together to get the virtual screen coordinates
    dwData = dwData + 1 'increase monitor count
    MonitorEnumProc = 1 'continue
End Function

Sub SavePosition(hWND As Long)
    Dim rc As RECT
    GetWindowRect hWND, rc 'save position in pixel units
    SaveSetting "Multi Monitor Demo", "Position", "Left", rc.Left
    SaveSetting "Multi Monitor Demo", "Position", "Top", rc.Top
End Sub


Function FindPrimary() As Long
Dim i As Long
For i = 0 To UBound(ScrInfo())
If ScrInfo(i).primary Then FindPrimary = i: Exit Function
Next i
End Function
Function FindFormSScreenCorner(z As Object) As Long
Dim F As Form
If TypeOf z Is Form Then
Set F = z
Else
Set F = z.Parent
End If
FindFormSScreenCorner = FindMonitorFromPixel(F.Left, F.Top)

End Function
Function FindFormSScreen(z As Object)
Dim F As Form
If TypeOf z Is Form Then
Set F = z
Else
Set F = z.Parent
End If
On Error Resume Next
Dim thismonitor As Long
thismonitor = MonitorFromWindow(F.hWND, MONITOR_DEFAULTTONEAREST)
Dim i As Long
For i = 0 To UBound(ScrInfo())
If thismonitor = ScrInfo(i).handler Then FindFormSScreen = i:   Exit Function
Next i
End Function
Function FindMonitorFromPixel(x, y) As Long
Dim x1 As Long, y1 As Long
x1 = x \ dv15
y1 = y \ dv15
Dim i As Long
For i = 0 To UBound(ScrInfo())
If ScrInfo(i).handler = MonitorFromPoint(x1, y1, MONITOR_DEFAULTTONEAREST) Then FindMonitorFromPixel = i: Exit Function
Next i

End Function
Function FindMonitorFromMouse()
'
   ' - offset
Dim x As Long, y As Long, tp As POINTAPI
GetCursorPos tp
x = tp.x
y = tp.y
Dim i As Long
For i = 0 To UBound(ScrInfo())
If ScrInfo(i).handler = MonitorFromPoint(x, y, MONITOR_DEFAULTTONEAREST) Then FindMonitorFromMouse = i: Exit Function
Next i
End Function
Sub MoveFormToOtherMonitor(F As Form)
Dim k As Long, z As Long
'k = FindMonitorFromPixel(F.Left, F.Top)
z = FindMonitorFromMouse
'If k <> Z Then
' center to z
If F.Width > ScrInfo(z).Width Then
    If F.Height > ScrInfo(z).Height Then
        F.Move ScrInfo(z).Left, ScrInfo(z).Top
    Else
        F.Move ScrInfo(z).Left, ScrInfo(z).Top + (ScrInfo(z).Height - F.Height) / 2
    End If
    
ElseIf F.Height > ScrInfo(z).Height Then
    F.Move ScrInfo(z).Left + (ScrInfo(z).Width - F.Width) / 2, ScrInfo(z).Top
Else
 ' F.Move ScrInfo(Z).Left + (ScrInfo(Z).width - F.width) / 2, ScrInfo(Z).Top + (ScrInfo(Z).Height - F.Height) / 2

End If
'End If
End Sub
Sub MoveFormToOtherMonitorOnly(F As Form, Optional flag As Boolean)
Dim k As Long, z As Long
Dim nowX As Long, nowY As Long
k = FindMonitorFromPixel(F.Left, F.Top)
z = FindMonitorFromMouse
If k = z Then
If flag Then
Dim tp As POINTAPI
GetCursorPos tp
nowX = tp.x * dv15
nowY = tp.y * dv15
flag = False
Else
flag = False
nowX = F.Left - ScrInfo(k).Left + ScrInfo(z).Left
nowY = F.Top - ScrInfo(k).Top + ScrInfo(z).Top
'Exit Sub
End If
Else
nowX = F.Left - ScrInfo(k).Left + ScrInfo(z).Left
nowY = F.Top - ScrInfo(k).Top + ScrInfo(z).Top
End If

If nowX > ScrInfo(z).Left + ScrInfo(z).Width Then
    nowX = ScrInfo(z).Left + ScrInfo(z).Width * 2 / 3
End If
If nowX + F.Width > ScrInfo(z).Left + ScrInfo(z).Width Then
    If F.Width < ScrInfo(z).Width Then
    nowX = ScrInfo(z).Left + ScrInfo(z).Width - F.Width
    Else
    nowX = ScrInfo(z).Left
    End If
End If
If nowY > ScrInfo(z).Top + ScrInfo(z).Height Then
    nowY = ScrInfo(z).Top + ScrInfo(z).Height * 2 / 3
End If
If nowY + F.Height > ScrInfo(z).Top + ScrInfo(z).Height Then
    If F.Height < ScrInfo(z).Height Then
    nowY = ScrInfo(z).Top + ScrInfo(z).Height - F.Height
    Else
    nowY = ScrInfo(z).Top
    End If
End If

If F.Width > ScrInfo(z).Width Then
    If F.Height > ScrInfo(z).Height Then
        nowX = ScrInfo(z).Left
        nowY = ScrInfo(z).Top
    Else
        nowX = ScrInfo(z).Left
        nowY = ScrInfo(z).Top + (ScrInfo(z).Height - F.Height) / 2
    End If
    
ElseIf F.Height > ScrInfo(z).Height Then
    nowX = ScrInfo(z).Left + (ScrInfo(z).Width - F.Width) / 2
    nowY = ScrInfo(z).Top
ElseIf flag Then
    nowX = ScrInfo(z).Left + (ScrInfo(z).Width - F.Width) / 2
    nowY = ScrInfo(z).Top + (ScrInfo(z).Height - F.Height) / 2
End If
F.Move nowX, nowY
End Sub
Sub MoveFormToOtherMonitorCenter(F As Form)
Dim k As Long, z As Long
'k = FindMonitorFromPixel(F.Left, F.Top)
z = FindMonitorFromMouse
'If k <> Z Then
' center to z
If F.Width > ScrInfo(z).Width Then
    If F.Height > ScrInfo(z).Height Then
        F.Move ScrInfo(z).Left, ScrInfo(z).Top
    Else
        F.Move ScrInfo(z).Left, ScrInfo(z).Top + (ScrInfo(z).Height - F.Height) / 2
    End If
    
ElseIf F.Height > ScrInfo(z).Height Then
    F.Move ScrInfo(z).Left + (ScrInfo(z).Width - F.Width) / 2, ScrInfo(z).Top
Else
 F.Move ScrInfo(z).Left + (ScrInfo(z).Width - F.Width) / 2, ScrInfo(z).Top + (ScrInfo(z).Height - F.Height) / 2

End If
'End If
End Sub
