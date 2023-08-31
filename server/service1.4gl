
IMPORT FGL lib
--------------------------------------------------------------------------------
#+ GET <server>/MyService/getContacts
#+ result: A Record that contains an Array ( can't just return an array? )
PUBLIC FUNCTION getContacts() ATTRIBUTES( 
		WSPath = "/getContacts", 
		WSGet, 
		WSDescription = "Get list of contacts")
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
#+ GET <server>/MyService/getContact/<id>
#+ result: A record by ID
PUBLIC FUNCTION getContact(l_id SMALLINT ATTRIBUTE(WSParam)) ATTRIBUTES( 
		WSPath = "/getContact/{l_id}", 
		WSGet, 
		WSDescription = "Get a contacts")
	RETURNS (t_contact ATTRIBUTES(WSMedia = 'application/json,application/xml'))

	RETURN m_conts[ l_id ].*
END FUNCTION
--------------------------------------------------------------------------------
#+ POST <server>/MyService/addContact
#+ result: String
PUBLIC FUNCTION addContact(l_cont t_contact) ATTRIBUTES( 
		WSPath = "/addContact", 
		WSPost, 
		WSDescription = "Add a contact")
	RETURNS (INT, STRING ATTRIBUTES(WSMedia = 'application/json'))
--	RETURNS (INT, STRING ATTRIBUTES(WSMedia = 'application/json,application/xml'))
	IF lib.checkExists( l_cont.cont_id, l_cont.cont_email ) THEN
		RETURN 100,"Contact already exists!"
	END IF
	IF NOT lib.addContact( l_cont.* ) THEN
		RETURN 101,"Failed to add Contact!"
	END IF
	RETURN 0,"Okay"
END FUNCTION
--------------------------------------------------------------------------------
