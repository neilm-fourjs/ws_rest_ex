
IMPORT os

CONSTANT C_IMGPATH = "got"

PUBLIC TYPE t_contact RECORD
		cont_id SMALLINT,
		cont_name VARCHAR(40),
		cont_family_name VARCHAR(40),
		cont_email VARCHAR(40),
		cont_info VARCHAR(40),
		cont_location VARCHAR(40),
		cont_img VARCHAR(40)
	END RECORD

PUBLIC DEFINE m_conts DYNAMIC ARRAY OF t_contact

PUBLIC TYPE t_contacts RECORD 
		rows SMALLINT,
		ContactList DYNAMIC ARRAY OF RECORD
			cont_id INTEGER,
			cont_name STRING
		END RECORD
	END RECORD

--------------------------------------------------------------------------------
FUNCTION disp( l_msg STRING)
	DISPLAY CURRENT,":",l_msg
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION db_connect( l_db STRING )
	TRY
		CALL disp("Connecting to DB ...")
		DATABASE l_db
		CALL disp("Connected to DB.")
	CATCH
		DISPLAY STATUS,":",SQLERRMESSAGE
		EXIT PROGRAM
	END TRY
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION setupData()
	CALL m_conts.clear()
	DECLARE cur1 CURSOR FOR SELECT * FROM contacts
	FOREACH cur1 INTO m_conts[ m_conts.getLength() + 1].*
	END FOREACH
	CALL m_conts.deleteElement( m_conts.getLength())
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION load_contacts()
	CALL m_conts.clear()
	CALL add_contact("Tyrion Lannister","Brainy one, with scar, short.","Dragonstone")
	CALL add_contact("Jamie Lannister","Pretty boy, one arm, tall","Kings Landing")
	CALL add_contact("Cersei Lannister","Evil","Kings Landing")
	CALL add_contact("Joffrey Baratheon","Annoying little runt","Grave")
	CALL add_contact("Daenerys Targaryen","Mother of Dragons, blah blah","Dragonstone")
	CALL add_contact("Sansa Stark","Vain","Winterfell")
	CALL add_contact("Arya Stark","Cute, turning evil?","Winterfell")
	CALL add_contact("Bran Stark","Crippled and strange!","Beyond the Wall")
	CALL add_contact("Jon Snow","Bastard and brooding","The Wall")
	CALL add_contact("Margaery Tyrell","","Sunspear")
	CALL add_contact("Theon Greyjoy","","Iron Islands")
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION add_contact(l_name STRING, l_bio STRING, l_loc STRING)
	DEFINE l_nam, l_house, l_img STRING
	DEFINE x SMALLINT
	LET x = l_name.getIndexOf(" ",1)
	LET l_nam = l_name.subString(1,x-1).toLowerCase()
	LET l_house = l_name.subString(x+1, l_name.getLength())
	IF l_house = "Snow" THEN LET l_house = "Stark" END IF
	CALL m_conts.appendElement()

	LET l_img = os.path.join(C_IMGPATH,l_nam)||".jpg"
--	DISPLAY "Img:",l_img," - ",os.path.join(getImagePath(),l_img)
	IF NOT os.path.exists( os.path.join(getImagePath(),l_img) ) THEN
		LET l_img = os.path.join(C_IMGPATH,l_house)
	END IF

	LET m_conts[ m_conts.getLength() ].cont_id = m_conts.getLength()
	LET m_conts[ m_conts.getLength() ].cont_name = l_name
	LET m_conts[ m_conts.getLength() ].cont_family_name = l_house
	LET m_conts[ m_conts.getLength() ].cont_email = l_nam||"@"||l_house.toLowerCase()||".got"
	LET m_conts[ m_conts.getLength() ].cont_info = l_bio
	LET m_conts[ m_conts.getLength() ].cont_img = l_img
	LET m_conts[ m_conts.getLength() ].cont_location = l_loc
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION getImagePath()
	DEFINE l_path STRING
	DEFINE l_st base.StringTokenizer
	LET l_st = base.StringTokenizer.create( fgl_getEnv("FGLIMAGEPATH"), os.path.pathSeparator() )
	WHILE l_st.hasMoreTokens()
		LET l_path = l_st.nextToken()
		IF os.path.isDirectory( l_path ) THEN RETURN l_path END IF
	END WHILE
	RETURN "."
END FUNCTION
