EnableExplicit

XIncludeFile "String.pbi"

Structure Parameter
  Name.s
  OriginalName.s
  Value.s
EndStructure

Procedure.i InitParameters()
  
  Static vInitialized = #False
    
  If Not vInitialized
    vInitialized = #True
  
    Global g_Command.s = ""
    Global NewList g_Parameters.Parameter()
    Global g_CommandLine.s = ""
  
    g_Command = LCase(ProgramParameter())
    g_CommandLine = g_Command    
    Protected vParameter.s = ProgramParameter()
    
    While Len(vParameter) > 0
      If StringStartsWIth(vParameter, "-") Or StringStartsWith(vParameter, "/")
        AddElement(g_Parameters())
        g_Parameters()\Name = LCase(Mid(vParameter, 2))
        g_Parameters()\OriginalName = Mid(vParameter, 2)
        g_Parameters()\Value = #NULL$
      ElseIf ListIndex(g_Parameters()) >= 0
        If g_Parameters()\Value = #NULL$
          g_Parameters()\Value = vParameter 
        EndIf
      EndIf
      g_CommandLine = g_CommandLine + " " + vParameter
      vParameter = ProgramParameter()
    Wend
  EndIf
    
  ProcedureReturn ListSize(g_Parameters())  
    
EndProcedure

Procedure.s GetCommandLine()
  
  InitParameters()
  ProcedureReturn g_CommandLine
  
EndProcedure

Procedure.s GetCommand()
  
  InitParameters()
  ProcedureReturn g_Command
  
EndProcedure

Procedure.i HasParameter(vName.s)
  
  InitParameters()
  
  ResetList(g_Parameters())
  ForEach g_Parameters()
    If StringStartsWith(LCase(vName), g_Parameters()\Name)
      ProcedureReturn #True
    EndIf
  Next
  
  ProcedureReturn #False
  
EndProcedure

Procedure.s GetParameter(vName.s, vDefault.s = #NULL$)
  
  InitParameters()
  
  ResetList(g_Parameters())
  ForEach g_Parameters()
    If StringStartsWIth(LCase(vName), g_Parameters()\Name)
      If Len(g_Parameters()\Value) = 0
        ProcedureReturn vDefault
      Else
        ProcedureReturn g_Parameters()\Value
      EndIf
    EndIf
  Next
  
  ProcedureReturn vDefault
  
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 2
; Folding = -
; EnableUnicode
; EnableXP