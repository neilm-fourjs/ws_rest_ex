
&include "db.inc"

FUNCTION mk_db()

	TRY
		CALL disp("Creating DB ...")
		CREATE DATABASE C_DBNAME
		CALL disp("Created DB.")
	CATCH
		CALL disp("Failed:"||STATUS||":"||SQLERRMESSAGE)
		EXIT PROGRAM
	END TRY

	TRY
		CALL disp("Connecting to DB ...")
		DATABASE C_DBNAME
		CALL disp("Connected to DB.")
	CATCH
		CALL disp("Failed:"||STATUS||":"||SQLERRMESSAGE)
		EXIT PROGRAM
	END TRY

	CALL cre_tabs()

END FUNCTION
--------------------------------------------------------------------------------
FUNCTION cre_tabs()

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
	
END FUNCTION
--------------------------------------------------------------------------------