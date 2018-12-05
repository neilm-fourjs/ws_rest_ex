
IMPORT FGL lib
--------------------------------------------------------------------------------
#+ http://localhost:8090/MyService/getContacts
#+ result: A Record that contains an Array ( can't just return an array? )
PUBLIC FUNCTION getContacts() 
	ATTRIBUTES( WSPath = "/getContacts", WSGET, WSDescription = "Get list of contacts")
	RETURNS (t_contacts ATTRIBUTES(WSMedia = 'application/json,application/xml'))
	DEFINE l_rec t_contacts
	FOR l_rec.rows = 1 TO m_conts.getLength()
		LET l_rec.ContactList[l_rec.rows].cont_id = l_rec.rows
		LET l_rec.ContactList[l_rec.rows].cont_name = m_conts[l_rec.rows].cont_name
	END FOR
	LET l_rec.rows = l_rec.ContactList.getLength()
	RETURN l_rec.*
END FUNCTION
--------------------------------------------------------------------------------
#+ http://localhost:8090/MyService/getContact/<id>
#+ result: A record
PUBLIC FUNCTION getContact(l_id SMALLINT ATTRIBUTE(WSParam)) 
	ATTRIBUTES( WSPath = "/getContact/{l_id}", WSGET, WSDescription = "Get a contacts")
	RETURNS (t_contact ATTRIBUTES(WSMedia = 'application/json,application/xml'))
	RETURN m_conts[ l_id ].*
END FUNCTION
--------------------------------------------------------------------------------
