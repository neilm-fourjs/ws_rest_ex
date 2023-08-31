# Automatic Makefile made by make4js by N.J.M.

cleanextra=rm wstest.4gl

fgl_obj1 =  \
	 MyClient.$(4GLOBJ) \
	 wstest.$(4GLOBJ)

fgl_frm1 = 

#depend::
#	echo "making depends";  cd lib ; ./link_lib

EXTRA_TARGETS=wstest.4gl

PRG1=MyClient.42r

include ./Make_fjs.inc

wstest.4gl: 
	fglrestful -o $@ http://localhost/g/ws/r/MyService/wstest?openapi.json && rm -f wstest.4gl~

wstest.4gl: 
#	fglrestful -o $@ http://localhost:8090/wstest?openapi.json && rm -f wstest.4gl~
