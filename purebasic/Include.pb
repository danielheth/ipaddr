EnableExplicit

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  #DIR_SEPERATOR = "\"
CompilerElse
  #DIR_SEPERATOR = "/"
CompilerEndIf


XIncludeFile "include/String.pbi"
XIncludeFile "include/CommonCore.pbi"
XIncludeFile "include/Parameters.pbi"

XIncludeFile "include/GlobalIP.pbi"

;CompilerIf #PB_Compiler_OS = #PB_OS_Windows
;  XIncludeFile "include/WinEvent.pb"
;  XIncludeFile "include/WmiQuery.pb"
;  XIncludeFile "include/WinRegistry.pb"
;  XIncludeFile "include/WinServices.pb"
;  XIncludeFile "include/WinFileVersion.pb"
;  XIncludeFile "include/WinCore.pb"
;CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
;  XIncludeFile "include/LinuxCore.pb"
;CompilerElseIf  #PB_Compiler_OS = #PB_OS_MacOS
;  XIncludeFile "include/MacServices.pb"
;  XIncludeFile "include/MacCore.pb"
;CompilerEndIf 


;XIncludeFile "Config.pb"

;-- Domains --
;XIncludeFile "Agent.pb"

;XIncludeFile "User.pb"
;XIncludeFile "File.pb"
;XIncludeFile "Ini.pb"
;XIncludeFile "Mount.pb"
;XIncludeFile "Process.pb"


; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 41
; Folding = -
; EnableUnicode
; EnableXP