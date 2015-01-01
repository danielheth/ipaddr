EnableExplicit

Procedure.s GetAppPath()
  If #PB_Compiler_Debugger
    If #PB_OS_Windows
      ProcedureReturn GetPathPart(ProgramFilename()) + "bin\win\"
    ElseIf #PB_OS_Linux
      ProcedureReturn GetPathPart(ProgramFilename()) + "bin/linux/"
    ElseIf #PB_OS_MacOS
      ProcedureReturn GetPathPart(ProgramFilename()) + "bin/mac/"
    EndIf
  Else
    ProcedureReturn GetPathPart(ProgramFilename())  
  EndIf
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 14
; Folding = -
; EnableUnicode
; EnableXP