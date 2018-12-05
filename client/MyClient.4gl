
IMPORT FGL MyService

MAIN
	DEFINE l_ret SMALLINT
	DEFINE x SMALLINT

	DEFINE l_rec1 RECORD ATTRIBUTE(XMLName = 'rv0') 
			rows INTEGER ATTRIBUTE(XMLName = 'rows'),
			ContactList DYNAMIC ARRAY ATTRIBUTE(XMLList) OF RECORD ATTRIBUTE(XMLName = 'element')
				cont_id INTEGER ATTRIBUTE(XMLName = 'cont_id'),
				cont_name STRING ATTRIBUTE(XMLName = 'cont_name')
			END RECORD
		END RECORD

	DEFINE l_rec2 RECORD ATTRIBUTE(XMLName = 'rv0') 
			cont_id INTEGER ATTRIBUTE(XMLName = 'cont_id'),
			cont_name STRING ATTRIBUTE(XMLName = 'cont_name'),
			cont_email STRING ATTRIBUTE(XMLName = 'cont_email')
 	END RECORD

	CALL MyService.getContacts() RETURNING l_ret, l_rec1.*
	DISPLAY "Ret:",l_ret," Rows:",l_rec1.rows
	FOR x = 1 TO l_rec1.rows
		DISPLAY l_rec1.ContactList[x].cont_id," : ", l_rec1.ContactList[x].cont_name
	END FOR

	CALL MyService.getContact(2) RETURNING l_ret, l_rec2.*
	DISPLAY "Ret:",l_ret," Rec:",l_rec2.cont_name," ",l_rec2.cont_email

END MAIN
