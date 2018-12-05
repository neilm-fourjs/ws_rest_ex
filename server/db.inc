
CONSTANT C_DBNAME = "ws_rest_db.db"

PUBLIC TYPE t_contact RECORD
		cont_id SMALLINT,
		cont_name VARCHAR(40),
		cont_family_name VARCHAR(40),
		cont_email VARCHAR(40),
		cont_info VARCHAR(40),
		cont_location VARCHAR(40),
		cont_img VARCHAR(40)
	END RECORD