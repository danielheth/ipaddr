EnableExplicit

;if you change any of these three, be sure to update 
;them under Compiler->Compiler Options and Version Info
;tab on all 4 targets
#BUILD_MAJOR = 1
#BUILD_MINOR = 1
#BUILD_NUM = 1

CompilerIf Defined(BUILD_NUMBER, #PB_Constant)
  ;compiled from command line via jenkins build
  ;Debug "Constant 'BUILD_NUMBER' is declared"
CompilerElse
  ;compiled from IDE so we need to declare a build number
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    #BUILD_NUMBER = 1
  CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
    #BUILD_NUMBER = 1
  CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
    #BUILD_NUMBER = 1
  CompilerEndIf
  
CompilerEndIf


Declare.i Main()
Declare MainHelp()

; Includes
XIncludeFile "Include.pb"

; Application Entry Point
Main()

; Procedures


Procedure.i GetIPAddress(List private_ip.s())  
  ;NewList private_ip.s()
  If InitNetwork()   
    If ExamineIPAddresses() 
      Protected Result
      Result = NextIPAddress()
      While Result
        AddElement(private_ip())
        private_ip() = IPString(Result)
        Result = NextIPAddress()
      Wend
      ProcedureReturn #True  
    Else
      StdErr("No Network Connection")
      ProcedureReturn #False
    EndIf
  Else
    StdErr("Could not initialize WSA.")
    ProcedureReturn #False
  EndIf 
EndProcedure


Procedure.i Main()
  Protected vSuccess.b = #True
  Protected vCommand.s = LCase(GetCommand())
  
  Protected hostname.s
  Protected public_ip_addr.s
  NewList private_ip.s()
    
  OpenConsole() 
  
  ;-- Help --
  If StringStartsWith(vCommand, "?") Or StringStartsWith(vCommand, "-?")
    MainHelp()
    
  ElseIf StringStartsWith(vCommand, "h") Or StringStartsWith(vCommand, "-h")
    hostname = GetEnvironmentVariable("COMPUTERNAME")
    StdOut(hostname)
    vSuccess = #True
    
  ElseIf StringStartsWith(vCommand, "p") Or StringStartsWith(vCommand, "-p")
    public_ip_addr = get_ip()
    StdOut(public_ip_addr)
    vSuccess = #True
    
  ElseIf StringStartsWith(vCommand, "a") Or StringStartsWith(vCommand, "-a")
    hostname = GetEnvironmentVariable("COMPUTERNAME")
    StdOut("  hostname: " + hostname)
    
    public_ip_addr = get_ip()
    StdOut(" public_ip: " + public_ip_addr)
    
    GetIPAddress(private_ip())
    ForEach private_ip()
      StdOut("private_ip: " + private_ip())
    Next
    vSuccess = #True
    
    
  ;-- Process --
  Else
    GetIPAddress(private_ip())
    ForEach private_ip()
      StdOut(private_ip())
    Next
    vSuccess = #True
    
 
  EndIf
  CloseConsole()
  
  ProcedureReturn #ERROR_SUCCESS
EndProcedure


Procedure MainHelp()
  
  StdOut("IPAddr build " + Str(#BUILD_MAJOR) + "." + Str(#BUILD_MINOR) + "." + Str(#BUILD_NUM) + "." +  Str(#PB_Editor_CompileCount + 1))
  
  StdOut("")
  StdOut("Usage: ipaddr [?|h|p]")
  Stdout("")
  
  StdOut(" -? = Display Help Information")
  StdOut(" -v = Display Version Information")
  StdOut(" -h = Display Hostname")
  StdOut(" -p = Return Public IP Address, if possible")
  StdOut("")
EndProcedure


; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 94
; FirstLine = 63
; Folding = -
; EnableUnicode
; EnableXP