IMPORT com

IMPORT FGL lib
IMPORT FGL service1
IMPORT util
&include "db.inc"
MAIN
	DEFINE ret INTEGER

	CALL lib.db_connect(C_DBNAME)
	CALL lib.fillContactArray()

	IF base.Application.getArgument(1) = "showheaders" THEN
		CALL showHeaders()
		EXIT PROGRAM
	END IF

	CALL com.WebServiceEngine.RegisterRestService("service1", "wstest")
	CALL lib.disp("Server started")
	CALL com.WebServiceEngine.Start()
	WHILE TRUE
		LET ret = com.WebServiceEngine.ProcessServices(-1)
		CASE ret
			WHEN 0
				CALL lib.disp("Request processed.")
			WHEN -1
				CALL lib.disp("Timeout reached.")
			WHEN -2
				CALL lib.disp("Disconnected from application server.")
				EXIT PROGRAM # The Application server has closed the connection
			WHEN -3
				CALL lib.disp("Client Connection lost.")
			WHEN -4
				CALL lib.disp("Server interrupted with Ctrl-C.")
			WHEN -9
				CALL lib.disp("Unsupported operation.")
			WHEN -10
				CALL lib.disp("Internal server error.")
			WHEN -23
				CALL lib.disp("Deserialization error.")
			WHEN -35
				CALL lib.disp("No such REST operation found.")
			WHEN -36
				CALL lib.disp("Missing REST parameter.")
			OTHERWISE
				CALL lib.disp("Unexpected server error " || ret || ".")
				EXIT WHILE
		END CASE
		IF int_flag <> 0 THEN
			LET int_flag = 0
			EXIT WHILE
		END IF
	END WHILE
	CALL lib.disp("Server stopped")
END MAIN
--------------------------------------------------------------------------------
-- simple function to just dump the http headers.
FUNCTION showHeaders()
	DEFINE l_req com.HttpServiceRequest
	DEFINE x     INT
	DEFINE l_json util.JSONObject
	LET l_json = util.JSONObject.create()
	CALL com.WebServiceEngine.Start()
	LET l_req = com.WebServiceEngine.GetHTTPServiceRequest(-1)
	FOR x = 1 TO l_req.getRequestHeaderCount()
		CALL l_json.put(l_req.getRequestHeaderName(x), l_req.getRequestHeaderValue(x))
	END FOR
	DISPLAY l_json.toString()
	CALL l_req.setResponseHeader("Content-Type", "application/json")
	CALL l_req.sendTextResponse(200, "OK", l_json.toString())
END FUNCTION
