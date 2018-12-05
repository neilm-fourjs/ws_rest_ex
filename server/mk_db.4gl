
IMPORT FGL lib
&include "db.inc"

MAIN
	DEFINE x SMALLINT
	DEFINE l_cont t_contact

	TRY
		CALL disp("Creating DB ...")
		CREATE DATABASE C_DBNAME
		CALL disp("Created DB.")
	CATCH
		DISPLAY STATUS,":",SQLERRMESSAGE
	END TRY

	CALL db_connect(C_DBNAME)

	TRY
		DROP TABLE contacts
	CATCH
	END TRY

	CALL disp("Creating contacts table ...")
	CREATE TABLE contacts (
		cont_id SMALLINT,
		cont_name VARCHAR(40),
		cont_family_name VARCHAR(40),
		cont_email VARCHAR(40),
		cont_info VARCHAR(40),
		cont_location VARCHAR(40),
		cont_img VARCHAR(40)
	)

	CALL disp("Creating contacts data ...")
	CALL load_contacts()
	
	CALL disp("Loading contacts data into DB ...")
	FOR x = 1 TO m_conts.getLength()
		LET l_cont.* = m_conts[x].*
		INSERT INTO contacts VALUES( l_cont.* )
	END FOR
	CALL disp(SFMT("Loaded %1 rows into contacts table.", m_conts.getLength()))

END MAIN
--------------------------------------------------------------------------------