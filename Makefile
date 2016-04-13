##This is a Makefile

target pngtarget pdftarget vtarget acrtarget: Jagsfit.Rout

##################################################################


Sources += Makefile stuff.mk
include stuff.mk
-include $(ms)/git.def

simdat.Rout: CBsimulator.R paramsCB.R simulateCB.R
	     $(run-R)

Jagsfit.Rout: simdat.Rout paramsCB.R JagsCB.R
	      $(run-R)


#############
Sources += $(wildcard *.R)
Sources += $(Released/*.csv)




Sources += $(wildcard notes/*.txt) $(wildcard notes/*.md)

-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/linux.mk
-include $(ms)/wrapR.mk
-include rmd.mk