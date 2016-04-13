##This is a Makefile

target pngtarget pdftarget vtarget acrtarget: Pymc.fit

##################################################################


Sources += Makefile stuff.mk
include stuff.mk
-include $(ms)/git.def

simdat.Rout: CBsimulator.R paramsCB.R simulateCB.R
	$(run-R)

%.fit.Rout: simdat.Rout paramsCB.R %CB.R
	$(run-R)

Pymc.fit: PymcCB.py
	python PymcCB.py

#############
Sources += $(wildcard *.R)
Sources += $(Released/*.csv)




Sources += $(wildcard notes/*.txt) $(wildcard notes/*.md)

-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/linux.mk
-include $(ms)/wrapR.mk
-include rmd.mk