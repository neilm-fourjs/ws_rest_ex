IMPORT util
IMPORT FGL lib
--&define C_WSMEDIA "application/json,application/xml"
&define C_WSMEDIA "application/json"
--------------------------------------------------------------------------------
#+ GET <server>/MyService/getContacts
#+ result: A Record that contains an Array ( can't just return an array? )
PUBLIC FUNCTION getContacts() ATTRIBUTES(WSPath = "/getContacts", WSGet, WSDescription = "Get list of contacts")
		RETURNS(t_contacts ATTRIBUTES(WSMedia = C_WSMEDIA))

	DEFINE l_rec t_contacts
	FOR l_rec.rows = 1 TO m_conts.getLength()
		LET l_rec.ContactList[l_rec.rows].cont_id   = l_rec.rows
		LET l_rec.ContactList[l_rec.rows].cont_name = m_conts[l_rec.rows].cont_name
	END FOR
	LET l_rec.rows = l_rec.ContactList.getLength()
	RETURN l_rec.*
END FUNCTION
--------------------------------------------------------------------------------
#+ GET <server>/MyService/getContact/<id>
#+ result: A record by ID
PUBLIC FUNCTION getContact(l_id SMALLINT ATTRIBUTE(WSParam))
		ATTRIBUTES(WSPath = "/getContact/{l_id}", WSGet, WSDescription = "Get a contacts")
		RETURNS(t_contact ATTRIBUTES(WSMedia = C_WSMEDIA))

	RETURN m_conts[l_id].*
END FUNCTION
--------------------------------------------------------------------------------
#+ POST <server>/MyService/addContact
#+ result: String
PUBLIC FUNCTION addContact(l_cont t_contact) ATTRIBUTES(WSPath = "/addContact", WSPost, WSDescription = "Add a contact" {, WSScope="contacts.add"})
		RETURNS(INT, STRING ATTRIBUTES(WSMedia = C_WSMEDIA))
--	RETURNS (INT, STRING ATTRIBUTES(WSMedia = 'application/json,application/xml'))
	IF lib.checkExists(l_cont.cont_id, l_cont.cont_email) THEN
		RETURN 100, "Contact already exists!"
	END IF
	IF NOT lib.addContact(l_cont.*) THEN
		RETURN 101, "Failed to add Contact!"
	END IF
	RETURN 0, "Okay"
END FUNCTION
--------------------------------------------------------------------------------
#+ GET <server>/MyService/status
#+ result: JSON string
PUBLIC FUNCTION status(
		l_ipaddr STRING ATTRIBUTES(WSHeader, WSOptional, WSName = "X-FourJs-Environment-Variable-REMOTE_ADDR"),
		l_prog_dir STRING ATTRIBUTES(WSHeader, WSOptional, WSName = "X-FourJs-Environment-Variable-FGL_VMPROXY_COMMAND_DIR"),
		l_connection STRING ATTRIBUTES(WSHeader, WSOptional, WSName = "Connection"),
		l_cookie STRING ATTRIBUTES(WSHeader, WSOptional, WSName = "Cookie"),
		l_user_agent STRING ATTRIBUTES(WSHeader, WSOptional, WSName = "User-Agent"),
		l_accept_lang STRING ATTRIBUTES(WSHeader, WSOptional, WSName = "Accept-Language"),
		l_accept STRING ATTRIBUTES(WSHeader, WSOptional, WSName = "Accept")
		) ATTRIBUTES(WSPath = "/status", WSGet, WSDescription = "Get status")
		RETURNS(util.JSONObject ATTRIBUTES(WSMedia = 'application/json'))
	DEFINE l_info util.JSONObject
	LET l_info = util.JSONObject.create()
	RUN "env | sort"
	CALL l_info.put("Status", "All Good :)")
	CALL l_info.put("Prog Dir", l_prog_dir)
	CALL l_info.put("Connection", l_connection)
	CALL l_info.put("Coookie", l_cookie)
	CALL l_info.put("Accept-Language", l_accept_lang)
	CALL l_info.put("Accept", l_accept)
	CALL l_info.put("REMOTE_ADDR", l_ipaddr)
	CALL l_info.put("User-Agent", l_user_agent)
	RETURN l_info
END FUNCTION
