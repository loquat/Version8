VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "mHandler"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Generic Handler
Option Explicit
Public objref As Object
Public t1 As Variant, indirect As Long
Public ReadOnly As Boolean
Public index_start As Variant ' 1 for start
Public index_End As Variant  ' -1 for end
Public index_cursor As Variant
Public UseIterator As Boolean
Public oEnum As Variant
Public IamEnum As Boolean
Private Sub Class_Initialize()
indirect = -1
index_start = 0
index_End = -1
UseIterator = False
End Sub

''Public Par1 As Variant
Private Sub Class_Terminate()
Set objref = Nothing
End Sub
Public Sub CopyTo(a As mHandler)
If IamEnum Then Set a = Me: Exit Sub
Set a = New mHandler
a.t1 = t1
''A.Par1 = Par1   ' key or index ???
' no copy for reference
a.indirect = indirect
a.index_start = index_start
a.index_End = index_End
a.index_cursor = index_cursor
a.UseIterator = UseIterator
Set a.objref = objref
End Sub
Public Function Iterate()
        Iterate = GetNext(ObjPtr(oEnum), index_cursor)
        If IsObject(index_cursor) Then Set objref = index_cursor: index_cursor = vbEmpty
        index_End = 1
        If Not Iterate Then index_End = -1
End Function
Sub ConstructEnumerator(penum As Variant)
IamEnum = True
Set oEnum = penum
If GetNext(ObjPtr(penum), index_cursor) Then
If IsObject(index_cursor) Then Set objref = index_cursor: index_cursor = vbEmpty
    index_End = 0
End If
End Sub
