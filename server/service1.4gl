
TYPE t_contact RECORD
		cont_id INTEGER,
		cont_name STRING,
		cont_email STRING
	END RECORD
TYPE t_contacts RECORD 
		rows SMALLINT,
		ContactList DYNAMIC ARRAY OF RECORD
			cont_id INTEGER,
			cont_name STRING
		END RECORD
	END RECORD
DEFINE m_data DYNAMIC ARRAY OF t_contact
--------------------------------------------------------------------------------
#+ http://localhost:8090/MyService/getContacts
#+ result: A Record that contains an Array ( can't just return an array? )
PUBLIC FUNCTION getContacts() 
	ATTRIBUTES( WSPath = "/getContacts", WSGET, WSDescription = "Get list of contacts")
	RETURNS (t_contacts ATTRIBUTES(WSMedia = 'application/json,application/xml'))
	DEFINE l_rec t_contacts
	IF m_data.getLength() = 0 THEN CALL setupData() END IF
	FOR l_rec.rows = 1 TO m_data.getLength()
		LET l_rec.ContactList[l_rec.rows].cont_id = l_rec.rows
		LET l_rec.ContactList[l_rec.rows].cont_name = m_data[l_rec.rows].cont_name
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
	IF m_data.getLength() = 0 THEN CALL setupData() END IF
	RETURN m_data[ l_id ].*
END FUNCTION
--------------------------------------------------------------------------------
PRIVATE FUNCTION setupData()
	LET m_data[1].cont_id = 1
	LET m_data[1].cont_name = "Neil Martin"
	LET m_data[1].cont_email = "neilm@4js-emea.com"
	LET m_data[2].cont_id = 2
	LET m_data[2].cont_name = "Ryan Hamlin"
	LET m_data[2].cont_email = "ryanh@4js-emea.com"
	LET m_data[3].cont_id = 3
	LET m_data[3].cont_name = "Michelle Young"
	LET m_data[3].cont_email = "michelley@4js-emea.com"
END FUNCTION
