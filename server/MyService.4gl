IMPORT com
IMPORT FGL service1

MAIN
  DEFINE ret INTEGER
  CALL com.WebServiceEngine.RegisterRestService("service1", "MyService")
  CALL disp("Server started")
  CALL com.WebServiceEngine.Start()
  WHILE TRUE
    LET ret = com.WebServiceEngine.ProcessServices(-1)
    CASE ret
      WHEN 0
        CALL disp("Request processed.")
      WHEN -1
        CALL disp("Timeout reached.")
      WHEN -2
        CALL disp("Disconnected from application server.")
        EXIT PROGRAM # The Application server has closed the connection
      WHEN -3
        CALL disp("Client Connection lost.")
      WHEN -4
        CALL disp("Server interrupted with Ctrl-C.")
      WHEN -9
        CALL disp("Unsupported operation.")
      WHEN -10
        CALL disp("Internal server error.")
      WHEN -23
        CALL disp("Deserialization error.")
      WHEN -35
        CALL disp("No such REST operation found.")
      WHEN -36
        CALL disp("Missing REST parameter.")
      OTHERWISE
        CALL disp("Unexpected server error " || ret || ".")
        EXIT WHILE
    END CASE
    IF int_flag <> 0 THEN
      LET int_flag = 0
      EXIT WHILE
    END IF
  END WHILE
  CALL disp("Server stopped")
END MAIN
--------------------------------------------------------------------------------
FUNCTION disp( l_msg STRING)
	DISPLAY CURRENT,":",l_msg
END FUNCTION
