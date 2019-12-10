VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3825
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   5370
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3825
   ScaleWidth      =   5370
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer1 
      Interval        =   500
      Left            =   60
      Top             =   2640
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'And remember, compile to p-code!!!




Private Sub Form_Load()
HAD2HAMMER = False

wX = 0: wY = 0
GetSystemTime
End Sub

Private Sub Form_Resize()
If wY = 0 Then End
End Sub

Private Sub Timer1_Timer()
Me.Move Me.Left, Me.Top, wX, wY
End Sub

