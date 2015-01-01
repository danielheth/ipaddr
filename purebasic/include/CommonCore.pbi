EnableExplicit

XIncludeFile "api/Configuration.pbi"

; Service Status
#SERVICE_UNKNOWN = 0
CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
  #SERVICE_STOPPED = 1
  #SERVICE_RUNNING = 2
  
  #ERROR_SUCCESS = 0
  #ERROR_FAILURE = -1
  
  #PATH_SEPARATOR = "/"
CompilerEndIf

; Service
Structure _Tanium_Service
  PID.i                 ; Pid
  Executable.s          ; Path of running executable
  Status.i              ; Reported Status of service
EndStructure


Procedure StdOut(vMessage.s)
  CPrintN(vMessage)
EndProcedure

Procedure StdErr(vMessage.s)
  ConsoleError("ERROR:  " + vMessage)
EndProcedure


Procedure.l TimeZoneOffset()
  ProcedureReturn 0
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
   Protected result.l,mode.l,tz.TIME_ZONE_INFORMATION
   mode=GetTimeZoneInformation_(tz)
   If mode=#TIME_ZONE_ID_STANDARD
    result-tz\bias-tz\StandardBias
   ElseIf mode=#TIME_ZONE_ID_DAYLIGHT
    result-tz\bias-tz\DaylightBias
   Else
    result-tz\Bias
    EndIf
    ProcedureReturn result*60
  
  CompilerElse
    ;TODO DHM add non-windows timezone detection
    ProcedureReturn 0
  CompilerEndIf
EndProcedure



Procedure.i Split(Array StringArray.s(1), StringToSplit.s, Separator.s = " ")
  Protected c = CountString(StringToSplit, Separator)
  Protected i, l = StringByteLength(Separator.s)
  Protected *p1.Character = @StringToSplit
  Protected *p2.Character = @Separator
  Protected *p = *p1
  ReDim StringArray(c)
  While i < c
    While *p1\c <> *p2\c
      *p1 + SizeOf(Character)
    Wend
    If CompareMemory(*p1, *p2, l)
      CompilerIf #PB_Compiler_Unicode
        StringArray(i) = PeekS(*p, (*p1 - *p) >> 1)
      CompilerElse
        StringArray(i) = PeekS(*p, *p1 - *p)
      CompilerEndIf
      *p1 + l
      *p = *p1
    EndIf
    i + 1
  Wend
  StringArray(c) = PeekS(*p)
  ProcedureReturn c
EndProcedure

Procedure.s Join(Array StringArray.s(1), Separator.s = "")
  Protected r.s, i, l, c = ArraySize(StringArray())
  While i <= c
    l + Len(StringArray(i))
    i + 1  
  Wend
  r = Space(l + Len(Separator) * c)
  i = 1
  l = @r
  CopyMemoryString(@StringArray(0), @l)
  While i <= c
    CopyMemoryString(@Separator)
    CopyMemoryString(@StringArray(i))
    i + 1  
  Wend
  ProcedureReturn r
EndProcedure

Procedure.s ParentPath(vPath.s)
  vPath = StringToLeft(vPath, #DIR_SEPERATOR, 2)
  If vPath <> #NULL$: vPath = vPath + #DIR_SEPERATOR: EndIf
  ProcedureReturn vPath  
EndProcedure

Procedure.s GetClientPath()
  Protected vPath.s = GetAppPath()
  
  While vPath <> #NULL$
    If FileSize(vPath + "rtclient.exe") <> -1 Or FileSize(vPath + "taniumclient.exe") <> -1
      ProcedureReturn vPath
    EndIf  
    vPath = ParentPath(vPath)
  Wend
  ProcedureReturn GetAppPath()
EndProcedure



Procedure explodeStringArray(Array a$(1), s$, delimeter$)
  Protected count, i
  count = CountString(s$,delimeter$) + 1
  
  Debug Str(count) + " substrings found"
  Dim a$(count)
  For i = 1 To count
    a$(i - 1) = StringField(s$,i,delimeter$)
  Next
  ProcedureReturn count ;return count of substrings
EndProcedure

Procedure.s stripChars(source.s,  charsToStrip.s)
  Protected i, *ptrChar.Character, length = Len(source), result.s
  *ptrChar = @source
  For i = 1 To length
    If Not FindString(charsToStrip, Chr(*ptrChar\c))
      result + Chr(*ptrChar\c)
    EndIf
    *ptrChar + SizeOf(Character)
  Next
  ProcedureReturn result 
EndProcedure
; IDE Options = PureBasic 5.31 (Linux - x64)
; CursorPosition = 13
; Folding = RB-
; EnableUnicode
; EnableXP