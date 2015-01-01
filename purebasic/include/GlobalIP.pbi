EnableExplicit

InitNetwork()

#getip_server = "checkip.dyndns.com"
#getip_server_host = "checkip.dyndns.org"
#getip_server_port = 80
#getip_server_protocol = "HTTP/1.0"
#getip_delay_part = 25

#getip_finder_id_left = "Current IP Address: "
#getip_finder_id_left_len = 20
#getip_finder_id_right = "</body></html>"
#getip_finder_id_right_len = 14

Procedure.s get_ip(buffer_size.i = 4096, time_for_update.i = 15000)
  Protected result.i = 0
  Protected connection_id.i = OpenNetworkConnection(#getip_server, #getip_server_port, #PB_Network_TCP)
  If connection_id <> 0
    Protected string_to_send_current_ip.s
    string_to_send_current_ip = "GET / " + #getip_server_protocol + #CRLF$
    string_to_send_current_ip + "Host: " + #getip_server_host + #CRLF$ + #CRLF$
    SendNetworkString(connection_id, string_to_send_current_ip)
    Protected time_current.i = ElapsedMilliseconds()
    Protected time_limit.i = time_current + time_for_update
    Repeat
      Select NetworkClientEvent(connection_id)
        Case #PB_NetworkEvent_Data
          Protected *memory_buffer = AllocateMemory(buffer_size)
          If *memory_buffer
            Repeat
              Protected break_from_main.i = 1
              Protected received_size.i = ReceiveNetworkData(connection_id, *memory_buffer, buffer_size)
              If received_size = -1
                CloseNetworkConnection(connection_id)
                result = 4
                Break
              Else
                Protected *memory_global
                If received_size = 0
                  CloseNetworkConnection(connection_id)
                  Debug PeekS(*memory_global)
                Else
                  Protected received_size_global.i
                  received_size_global + received_size
                  *memory_global = ReAllocateMemory(*memory_global, received_size_global)
                  If *memory_global
                    CopyMemory(*memory_buffer, *memory_global + (received_size_global - received_size), received_size)
                    CloseNetworkConnection(connection_id)
                    Break
                  Else
                    CloseNetworkConnection(connection_id)
                    result = 3
                    Break
                  EndIf                
                EndIf
              EndIf
              time_current = ElapsedMilliseconds()
              If time_current >= time_limit
                CloseNetworkConnection(connection_id)
                result = 2
                Break
              Else
                Delay(#getip_delay_part)
              EndIf
            ForEver
            FreeMemory(*memory_buffer)
              string_to_send_current_ip = PeekS(*memory_global, -1, #PB_Ascii)
              FreeMemory(*memory_global)
              string_to_send_current_ip = Mid(string_to_send_current_ip, FindString(string_to_send_current_ip, #getip_finder_id_left, 0) + #getip_finder_id_left_len, FindString(string_to_send_current_ip, #getip_finder_id_right, FindString(string_to_send_current_ip, #getip_finder_id_left, 0) + #getip_finder_id_left_len) - (FindString(string_to_send_current_ip, #getip_finder_id_left, 0) + #getip_finder_id_left_len))
              ;MessageRequester("Your global IP", "Your global IP is:" + #CRLF$ + string_to_send_current_ip)
              ProcedureReturn string_to_send_current_ip
            FreeMemory(*memory_global)
          Else
            CloseNetworkConnection(connection_id)
            result = 3
            Break
          EndIf
        Default
          time_current = ElapsedMilliseconds()
          If time_current >= time_limit
            CloseNetworkConnection(connection_id)
            result = 2
            Break
          Else
            Delay(#getip_delay_part)
          EndIf
      EndSelect
      If break_from_main = 1
        Break
      EndIf
    ForEver
  Else
    result = 1
  EndIf
  
  ;Errors
  If result = 1
    Debug "Can not connect to server"
  ElseIf result = 2
    Debug "Time out of get IP"
  ElseIf result = 3
    Debug "AllocateMemory error" ;Critical error!
  ElseIf result = 4
    Debug "Can not receive data from server"
  EndIf
  
  ProcedureReturn ""
EndProcedure


; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 70
; FirstLine = 47
; Folding = -
; EnableUnicode
; EnableXP