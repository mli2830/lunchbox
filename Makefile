##This is a Makefile

target: Jags.CBB.fit.Rout

target pngtarget pdftarget vtarget acrtarget: Jags.fit.Rout 

##################################################################

Sources += Makefile stuff.mk
include stuff.mk
-include $(ms)/git.def

simdat.Rout: simulator.CBB.R params.CBB.R simulate.CBB.R
	$(run-R)

Jags.CB.fit.Rout: CB.bug Jags.CB.R
Jags.CBB.fit.Rout: CBB.bug Jags.CBB.R
Jags.%.fit.Rout: simdat.Rout paramsCB.R Jags.%.R
	$(run-R)

Pymc.fit: PymcCB.py
	python PymcCB.py

#############
Sources += $(wildcard *.R *.bug)

-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/linux.mk
-include $(ms)/wrapR.mk
-include rmd.mk
