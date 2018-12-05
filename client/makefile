# Automatic Makefile made by make4js by N.J.M.

cleanextra=rm MyService.4gl

fgl_obj1 =  \
	 MyClient.$(4GLOBJ) \
	 MyService.$(4GLOBJ)

fgl_frm1 = 

#depend::
#	echo "making depends";  cd lib ; ./link_lib

EXTRA_TARGETS=MyService.4gl

PRG1=MyClient.42r

include ./Make_fjs.inc


MyService.4gl: 
	fglrestful http://localhost:8090/MyService?openapi.json && rm MyService.4gl~
