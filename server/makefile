# Automatic Makefile made by make4js by N.J.M.

export FGLAPPSERVER=8090
export FGLPROFILE=./etc/fglprofile

fgl_obj1 =  \
	 MyService.$(4GLOBJ) \
	 lib.$(4GLOBJ) \
	 mk_db.$(4GLOBJ)

fgl_frm1 = 

#depend::
#	echo "making depends";  cd lib ; ./link_lib

PRG1=MyService.42r

include ./Make_fjs.inc


test: MyService.42r
	wget -q  -O - http://localhost:8090/MyService/getStatus

