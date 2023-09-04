
IMPORT FGL wstest

&define RESTJSON

MAIN
	DEFINE l_ret, l_stat SMALLINT
	DEFINE l_desc STRING
	DEFINE x SMALLINT

&ifdef RESTJSON
	DEFINE l_rec1 wstest.t_contacts
	DEFINE l_rec2 wstest.t_contact
&else
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
&endif

	DISPLAY "calling:wstest.getContacts() ... "
	CALL wstest.getContacts() RETURNING l_ret, l_rec1
	DISPLAY SFMT( "Ret: %1 WSError: %2 : %3",l_ret, wsError.code, wsError.description)
	FOR x = 1 TO l_rec1.rows
		DISPLAY l_rec1.ContactList[x].cont_id," : ", l_rec1.ContactList[x].cont_name
	END FOR

	DISPLAY "calling:wstest.getContact(2) ... "
	CALL wstest.getContact(2) RETURNING l_ret, l_rec2.*
	DISPLAY SFMT( "Ret: %1 WSError: %2 : %3",l_ret, wsError.code, wsError.description)

	INITIALIZE l_rec2 TO NULL
	LET l_rec2.cont_id = l_rec1.rows + 1
	LET l_rec2.cont_name = "Test"
	LET l_rec2.cont_family_name = "Test"
	LET l_rec2.cont_email = downshift(SFMT("%1@%2.com",l_rec2.cont_name,l_rec2.cont_family_name))
	DISPLAY "calling: wstest.addContact( rec ) ..."
	CALL wstest.addContact( l_rec2 ) RETURNING l_ret, l_stat, l_desc
	DISPLAY SFMT( "Ret: %1 Stat: %2 : %3 WSError: %4 : %5",l_ret, l_stat, l_desc, wsError.code, wsError.description, err_get(wsError.code))

END MAIN
