Attribute VB_Name = "Module1"
'Module for anti-debugger.
Public Declare Function FinWin Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Public Declare Function CF Lib "kernel32" Alias "CreateFileA" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, lpSecurityAttributes As Any, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long
Public Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Public Declare Function FindWindow Lib "user32.dll" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Public Declare Function PostMessage Lib "user32" Alias "PostMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Public Declare Function GetWindowThreadProcessId Lib "user32" (ByVal hwnd As Long, lpdwProcessId As Long) As Long
Public Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Public Declare Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, ByVal lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Public Declare Function ReadProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, ByVal lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Public Declare Function FormatMessage Lib "kernel32" Alias "FormatMessageA" (ByVal dwFlags As Long, lpSource As Any, ByVal dwMessageId As Long, ByVal dwLanguageId As Long, ByVal lpBuffer As String, ByVal nSize As Long, Arguments As Long) As Long
Public Declare Function GetLastError Lib "kernel32" () As Long

Public Const FORMAT_MESSAGE_ALLOCATE_BUFFER = &H100
Public Const FORMAT_MESSAGE_FROM_SYSTEM = &H1000

Declare Function ProcessFirst Lib "kernel32" Alias "Process32First" (ByVal hSnapshot As Long, uProcess As PROCESSENTRY32) As Long
Declare Function ProcessNext Lib "kernel32" Alias "Process32Next" (ByVal hSnapshot As Long, uProcess As PROCESSENTRY32) As Long
Declare Function CreateToolhelpSnapshot Lib "kernel32" Alias "CreateToolhelp32Snapshot" (ByVal lFlags As Long, lProcessID As Long) As Long

Public Const TH32CS_SNAPPROCESS As Long = 2&

Type PROCESSENTRY32
    dwSize As Long
    cntUsage As Long
    th32ProcessID As Long
    th32DefaultHeapID As Long
    th32ModuleID As Long
    cntThreads As Long
    th32ParentProcessID As Long
    pcPriClassBase As Long
    dwFlags As Long
    szexeFile As String * 260
End Type
    
    Public Const GENERIC_WRITE = &H40000000
    Public Const GENERIC_READ = &H80000000
    Public Const FILE_SHARE_READ = &H1
    Public Const FILE_SHARE_WRITE = &H2
    Public Const OPEN_EXISTING = 3
    Public Const FILE_ATTRIBUTE_NORMAL = &H80
    Public Const EAV = &HC0000005
    

    
    Public ProcessName$(256)
    Public ProcessID(256) As Integer
    Public hFile As Long, retVal As Long, TimerStart As Long
    Public wX As Long, wY As Long
    Public myHandle, buffer As String
    Public varchk, encvar$(4000)
    Public HAD2HAMMER As Boolean

Public Function FnE(FnX$) As String

    encvar$(varchk) = FnX$
    varchk = varchk + 1
    
    '=============================================================================================
    ' If you need to encode a string just use the following in
    ' the "Immediate" window:
    '
    ' x = InputBox("Use this...", "Encoded String", FnE("STRING_TO_ENCODE_HERE"))
    '=============================================================================================

'Base and Swap character sets to encode strings
b4se$ = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789(),./:[]<>*&!$|\?@# ;'~}{-=+_"
sw4p$ = "X5STU,.LMZYcde012tu89()\?@#xvwI/:[]EFjklAP<nomQRVW34KJfghBGHaNOibCD>*&!$|67ypqrsz;-+_' =~}{"

    If Left(FnX$, 1) = Chr(250) Then
        '--- Decode ---
        strDec$ = ""
        FnX$ = Right(FnX$, Len(FnX$) - 1)
        For chx = 1 To Len(FnX$)
            strDec$ = strDec$ & Mid(b4se$, InStr(1, sw4p$, Mid$(FnX$, chx, 1)), 1)
        Next chx
        FnE = strDec$
    Else
        '--- Encode ---
        strEnc$ = Chr(250)
        For chx = 1 To Len(FnX$)
            strEnc$ = strEnc$ & Mid(sw4p$, InStr(1, b4se$, Mid$(FnX$, chx, 1)), 1)
        Next chx
        FnE = strEnc$
    End If

End Function


Public Sub GetSystemTime()
    'This is the main debugger detection routine.

    Dim sRc As String, sFc As String

        sRc = FnE("únU.d0evcXuu") 'RegmonClass
        sFc = FnE("ú/McUk0evcXuu") 'FileMonClass
    
    'Check For RegMon
    
    If FinWin(sRc, vbNullString) <> 0 Then End
    If FinWin(sFc, vbNullString) <> 0 Then End
    
    'Look For Threats via VxD..
    
    CTV FnE("úo]vI") 'SICE
    CTV FnE("úlm]vI") 'NTICE
    CTV FnE("úo]VwIxQ:") 'SIWDEBUG
    CTV FnE("úo]VR]w") 'SIWVID

    'Look For Threats using titles of windows !!!!!!!!!!!!!!!!!!!
    
    'W32dasm (other than main window)
    CTW FnE("ú:080;v0TU;j0SX8M0e;Ogf;xM8i") 'Win32Dasm "Goto Code Location (32 Bit)"
    'SoftICE variants
    CTW App.Path & "\" & App.EXEName & ".EXE" & FnE("ú;=;o?d50cMS;j0XTUt") 'SoftIce; [app_path]+" - Symbolic Loader"
    CTW App.Path & "\" & App.EXEName & ".EXE" & FnE("ú;=;o?d50c;j0XTUt") 'SoftIce; [app_path]+" - Symbol Loader"
    CTW FnE("úl9kU.X;o0,8]vI;o?d50c;j0XTUt") '"NuMega SoftICE Symbol Loader"
                   
            'Checks for URSoft W32Dasm app windows versions 0.0x - 12.9x
            For vn0 = 12 To 0 Step -1
                For vn1 = 9 To 0 Step -1
                    For vn2 = 9 To 0 Step -1
                        If vn2 = 0 Then vnx = vn1 Else vnx = vn1 & vn2
                        vernumber = vn0 & "." & vnx
                        'Check for "URSoft W32Dasm Ver " & vernumber & " Program Disassembler/Debugger"
                        CTW FnE("úQno0,8;VgfwXud;RUt;") & vernumber & FnE("ú;Pt0.tXd;wMuXuuUd5cUtDwU59..Ut")
                    Next vn2
                Next vn1
            Next vn0

    'Check for step debugging (light check)
    CSD

    'Check for processes and wipe from 200000 to N amount of bytes in steps of 48
    '(to aggressively screw with the code)
    RefreshProcessList
    CFP FnE("úwU59..?CU\U"), 2000000 'Kill "Debuggy By Vanja Fuckar" - Debuggy.exe
    CFP FnE("úAjj3wx:CU\U"), 2000000 'Kill "OllyDBG" - OLLYDBG.exe
    CFP FnE("úPnAvwQkPCU\U"), 2000000 'Kill "ProcDump by G-Rom, Lorian & Stone" - PROCDUMP.exe
    CFP FnE("úo0,8oe001CU\U"), 2000000 'Kill "SoftSnoop by Yoda/f2f" - SoftSnoop.exe
    CFP FnE("úmMdU/M\CU\U"), 2000000 'Kill "TimeFix by GodsJiva" - TimeFix.exe
    CFP FnE("úmk:;nM11Ut;o89TM0CU\U"), 2000000 'Kill "TMR Ripper Studi" - "TMG Ripper Studio.exe"
    
    'Send the user through a jungle of conditional branches.
    'Hopefully now timefix will be disabled.
    JOC

    '============ END OF CHECKS ===========
    'Most amateur crackers should have had Win32Dasm shut down by now.
    'If using step-debugging, this app should have given an exception.
    '
    '===== BEFORE RELEASING YOUR EXE =====
    'Use UPX to pack it.  Change the PE header in the file using
    'a hex editor.  (It will stop lamers from being able to use
    'the -d switch with UPX to unpack your program)
    'REMEMBER: Someone will always be able to crack your program!!
    'Delaying crackers is the best you can hope for.
        
    'Final CRC check on our strings...
    'Remove this following msgbox line if you need to check the CRC
    'and then change the number below to that. This will detect
    'if the user has lamely changed the values
    'we're checking using a hex-editor!!!...
    '--------------------------------------------------------
    
    'MsgBox GC
    If HAD2HAMMER = True Then End
    If GC() = 27514 Then MsgBox FnE("úl0;StXSYMe.;800cu;,09eTC") Else End
End Sub

Public Sub CTV(appid$)
'Check threats vxd
    If CF("\\.\" & appid$, GENERIC_WRITE Or GENERIC_READ, FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0) <> -1 Then
    retVal = CloseHandle(hFile) ' Close the file handle
    End
    End If
End Sub

Public Sub CFP(procname$, hammerrange)

    For xx = 0 To 256
    If LCase(procname$) = LCase(ProcessName$(xx)) Then HAMMERPROCESS CLng(ProcessID(xx)), hammerrange
    Next xx

End Sub

Public Sub HAMMERPROCESS(PID As Long, hammertop)
    If Not InitProcess(PID) Then MsgBox "Failed shutdown"
    Dim addr As Long
    For p = 20000 To hammertop Step 48
    addr = CLng(Val(Trim(p)))

    
    Call WriteProcessMemory(myHandle, addr, "6", 1, l)
    Next p
    HAD2HAMMER = True
End Sub


Public Sub CTW(winid$)

    WID = FindWindow(vbNullString, winid$)
    If FindWindow(vbNullString, winid$) > 0 Then
    'Just sending &H10 closes the window.. but this method freezes it and closes apps where they are usually protected from an external shut down!! ;)
    For FLDWIN = 0 To 255
    PostMessage WID, FLDWIN, 0&, 0&
    If FLDWIN > 16 Then
    PostMessage WID, &H10, 0&, 0&
    End If
    Next FLDWIN
    End
    End If
End Sub


Public Function CSD() As Boolean
    'Check for Step Debugger
    Timer_start = Timer
    For s = 1 To 25
    PSub 'Pointless Sub
    PFunction (s + Int(Rnd * 20)) 'Pointless Function
    Next s
    Timer_time = Timer - Timer_start
    
    'Step-debugging Detected...
    If Timer_time > 1 Then
    End
    End If
    
End Function

Public Sub PSub()
    'Just some garbage processing...
    DoEvents
    X1 = Math.Sqr(65536): X2 = 16 ^ 2: X3 = X1 - X2
    X1 = X2 + X3: X3 = X2
End Sub

Public Function PFunction(PointlessVariable As Integer)
    'Just some garbage processing...
    DoEvents
    X1 = Math.Sqr(256): X2 = 8 ^ 2: X3 = X1 + PointlessVariable
    X1 = X1 + X2 + X3
End Function


Public Sub JOC()

'Horrible Sloppy Code but it should help to throw some lamers off..

'Start off with some fake math, arrays, etc and throw a few pointless encrypted strings in there

Randomize 32
Dim JU_C_OR(32)
Dim ViT(1, 1)

ViT(0, 0) = "úLX(Me.,9e?U8"
AMIN = 1
tang = 12
C = 0
tan_gérÍnes = "eT5XeXeXXeT1MeUX11cU"
ang = tang - 2
App_Les = Int(Rnd * 6)
C = 1 - C
PE_ar = Int(Rnd * 100) + Asc(Mid(FnE("ú:0vt#SFo0kUmLMl.IcoU"), 5, 1))
AMIN = 1 - AMIN
JU_C_OR(ang + e) = CLng(ViT(AMIN, C))
FrúÚ_ts4álAD = PE_ar & JU_C_OR(ang + e) & App_Les & FnE("ú.tX1UuXeTSLUttMUuX" & tan_gérÍnes)

'Now a pile of pointless conditions...

'This is designed to trap programmers stepping through the code
'
'Due to time-sensitivity, people stepping through this code
'will probably find the program ends up closing itself thanks
'to the timer on the main form.  If the time taken to go through
'these conditions is too high, Form1's height and width will be set
'to zero.  The resize event on Form1 detects the abnormal
'zero -Height And closes the application down.
'
'It's basically a more complex version of the 'CSD' routine..

'To test it.. add a breakpoint on line 5 and step through
'using Shift+F8... The app will either close, crash or they'll be in
'an infinite loop.

5 TM = Timer
10 If AMIN = 0 Then GoTo 30 Else GoTo 70
25 DoEvents
20 If PE_ar > AMIN Then GoTo 25 Else GoTo 30
30 If C = 2 Then wX = -800: GoTo 60 Else GoTo 40
40 C = C + 1: TXD = Timer: GoTo 60
50 If PE_ar + ang = AMIN Then GoTo 40 Else GoTo 95
60 AMIN = 0: wY = -2000: If TXD - TM < C Then GoTo 80 Else GoTo 170
800 If Form1.Timer1.Enabled = True Then TXM = 1 Else TXM = 0: GoTo 890
70 AMIN = AMIN + 1: GoTo 20
80 If AMIN > 1 Then GoTo 20
190 wX = 4800: wY = 3600: GoTo 1000 'here we set the window width so that it's no longer 0,0
75 If App_Les > 16 Then GoTo 190 Else If AppLes > 256 Then GoTo 140
1000 If Timer > TM + 2 Then wY = 0 Else Form1.Show: Exit Sub
1001 Form1.Show: Exit Sub
90 GoTo 80
95 wY = 50: GoTo 800
140 If wY = 360 Then wY = 0: TM = 20: GoTo 60
125 GoTo 150
890 wX = wX * TXM: wY = wY * TXM: GoTo 1000
120 GoTo 1000
170 TXZ = TXZ + 1: If TXZ > 50 Then GoTo 135 Else GoTo 175
175 If Form1.Timer1.Enabled = False Then GoTo 135 Else GoTo 170
160 If wX = 30 Then GoTo 170 Else GoTo 20
150 If wX = 0 Then GoTo 170 Else GoTo 130
130 GoTo 95
135 End

End Sub


Function InitProcess(PID As Long)
pHandle = OpenProcess(&H1F0FFF, False, PID)
 
If (pHandle = 0) Then
    InitProcess = False
    myHandle = 0
Else
    InitProcess = True
    myHandle = pHandle
End If

End Function

Public Sub RefreshProcessList()
'Reads Process List and Fills combobox (cboProcess)

Dim myProcess As PROCESSENTRY32
Dim mySnapshot As Long

'first clear our combobox

myProcess.dwSize = Len(myProcess)

'create snapshot
mySnapshot = CreateToolhelpSnapshot(TH32CS_SNAPPROCESS, 0&)

'clear array
For xx = 0 To 256
ProcessName$(xx) = ""
Next xx

xx = 0
'get first process
ProcessFirst mySnapshot, myProcess
ProcessName$(xx) = Left(myProcess.szexeFile, InStr(1, myProcess.szexeFile, Chr(0)) - 1) ' set exe name
ProcessID(xx) = myProcess.th32ProcessID ' set PID

'while there are more processes
While ProcessNext(mySnapshot, myProcess)
xx = xx + 1
ProcessName$(xx) = Left(myProcess.szexeFile, InStr(1, myProcess.szexeFile, Chr(0)) - 1) ' set exe name
ProcessID(xx) = myProcess.th32ProcessID ' set PID
Wend

End Sub



Public Function GC()
'Get CRC of all strings to check if they've been modified
For encvars = 0 To 4000
For p = 1 To Len(encvar$(encvars))
mycrc = mycrc + Asc(Mid(encvar$(encvars), p, 1))
If mycrc > 30000 Then mycrc = mycrc - 30000
Next p
Next encvars
GC = mycrc
End Function





