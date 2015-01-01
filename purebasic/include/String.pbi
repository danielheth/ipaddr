EnableExplicit

Procedure StringStartsWith(string1$, string2$, casesensitive.i = #False)
  
  ;returns one if string1$ starts with string2$, otherwise returns zero
  If Not casesensitive
    If FindString(LCase(string1$), LCase(string2$), 1) = 1
      ProcedureReturn 1
    EndIf
  Else
    If FindString(string1$, string2$, 1) = 1
      ProcedureReturn 1
    EndIf
  EndIf
  
  ProcedureReturn 0
  
EndProcedure

Procedure StringContains(string1$, string2$, location = 0, casesensitive.i = #False)
  ;returns the location of the next occurrence of string2$ in string1$ starting from location,
  ;or zero if no remaining occurrences of string2$ are found in string1$
  
  If Not casesensitive
    ProcedureReturn FindString(LCase(string1$), LCase(string2$), location + 1)
  Else
    ProcedureReturn FindString(string1$, string2$, location + 1)
  EndIf
  
EndProcedure

Procedure StringEndsWith(string1$, string2$)
  
  ;returns one if string1$ ends with string2$, otherwise returns zero
  Protected ls = Len(string2$)
  If Len(string1$) - ls >= 0 And Right(string1$, ls) = string2$
    ProcedureReturn 1
  EndIf
  
ProcedureReturn 0
  
EndProcedure

Procedure StringIsNumeric(t$)
  
  Protected ok = 1, p, a
  t$ = Trim(t$)
  For p = 1 To Len(t$)
    a = Asc(Mid(t$, p,1))
    If a<>45 And a<>46 And (a<48 Or a>57) : ok=0 : Break : EndIf
  Next
  ProcedureReturn ok
  
EndProcedure

Procedure.s HtmlDecode(vString.s)
  
  vString = ReplaceString(vString, "%3A", ":", #PB_String_NoCase)
  vString = ReplaceString(vString, "%5C", "\", #PB_String_NoCase)
  
  ProcedureReturn vString
  
EndProcedure

Procedure.s StringWildToRegEx(vFileWildCard.s)
  
  vFileWildCard = ReplaceString(vFileWildCard, "\", "\\")
  vFileWildCard = ReplaceString(vFileWildCard, ".", "\.")
  vFileWildCard = ReplaceString(vFileWildCard, "*", ".*")
  vFileWildCard = ReplaceString(vFileWildCard, "?", ".")
  vFileWildCard = "\A" + vFileWildCard + "\z"
  
  ProcedureReturn vFileWildCard
  
EndProcedure

Procedure.s StringWildToSqlLike(vFileWildCard.s)
  
  vFileWildCard = ReplaceString(vFileWildCard, "*", "%")
  
  ProcedureReturn vFileWildCard
  
EndProcedure

Procedure.s StringEnvironment(vString.s)
  
  If ExamineEnvironmentVariables()
    While NextEnvironmentVariable()
      vString = ReplaceString(vString, "%" + EnvironmentVariableName() + "%", EnvironmentVariableValue(), #PB_String_CaseSensitive)
    Wend
  EndIf
  
  ProcedureReturn vString  
  
EndProcedure

Procedure.s QuotedString(vValue.s)
  
  ProcedureReturn Chr(34) + vValue + Chr(34)
  
EndProcedure

Procedure CPrintN(Text.s)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Text = Text + Chr(13) + Chr(10)
    Protected len = Len(Text)
    Protected OemText.s = Space(len)
    CharToOemBuff_(@Text, @OemText, len)
    WriteConsoleData(@OemText, Len(OemText))
    ;FlushFileBuffers_(GetStdHandle_(#STD_OUTPUT_HANDLE))
  CompilerElse
    PrintN(Text.s)
  CompilerEndIf
EndProcedure

Procedure.s StringToLeft(vString.s, vLeftOfChar.s, vCount.i = 1)
  Protected i.i, vFoundCount.i = 0
  For i = Len(vString) To 1 Step -1
    If Mid(vString, i, 1) = vLeftOfChar: vFoundCount = vFoundCount + 1: EndIf
    If vFoundCount > vCount
      vString = Mid(vString, 1, i - 1)
      ProcedureReturn vString
    EndIf
  Next
  ProcedureReturn #NULL$
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 125
; FirstLine = 61
; Folding = ---
; EnableUnicode
; EnableXP