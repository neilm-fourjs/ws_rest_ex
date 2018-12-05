
IMPORT FGL MyService

MAIN
	DEFINE l_ret, l_stat SMALLINT
	DEFINE l_desc STRING
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
			cont_family_name STRING ATTRIBUTE(XMLName = 'cont_family_name'),
			cont_email STRING ATTRIBUTE(XMLName = 'cont_email'),
			cont_info STRING ATTRIBUTE(XMLName = 'cont_info'),
			cont_location STRING ATTRIBUTE(XMLName = 'cont_location'),
			cont_img STRING ATTRIBUTE(XMLName = 'cont_img')
 	END RECORD

	CALL MyService.getContacts() RETURNING l_ret, l_rec1.*
	DISPLAY "Ret:",l_ret," Rows:",l_rec1.rows
	FOR x = 1 TO l_rec1.rows
		DISPLAY l_rec1.ContactList[x].cont_id," : ", l_rec1.ContactList[x].cont_name
	END FOR

	CALL MyService.getContact(2) RETURNING l_ret, l_rec2.*
	DISPLAY "Ret:",l_ret," Rec:",l_rec2.cont_name," ",l_rec2.cont_email

	INITIALIZE l_rec2 TO NULL
	LET l_rec2.cont_id = l_rec1.rows + 1
	LET l_rec2.cont_name = "Test"
	LET l_rec2.cont_family_name = "Test"
	LET l_rec2.cont_email = l_rec2.cont_name.toLowerCase()||"@"||l_rec2.cont_family_name.toLowerCase()||".com"
	CALL MyService.addContact( l_rec2.* ) RETURNING l_ret, l_stat, l_desc
	DISPLAY "Ret:",l_ret," Stat:",l_stat,":",l_desc
END MAIN
