##This is a Makefile

target: B.B.Rout

target pngtarget pdftarget vtarget acrtarget: Jags.fit.Rout 

##################################################################

Sources += Makefile stuff.mk
include stuff.mk
-include $(ms)/git.def

sim.CBB.Rout: simulate.CBB.R
sim.CP.Rout: simulate.CP.R
sim.%.Rout: simulator.%.R parameters.CBB.R simulate.%.R
	    $(run-R)

B.B.Rout: process.B.R observation.B.R bugs_template.R
	  $(run-R)

Jags.CB.fit.Rout: B.B.bug Jags.CB.R
Jags.CBB.fit.Rout: CB.bug Jags.CBB.R
Jags.CP.fit.Rout: CP.bug Jags.CP.R
Jags.%.fit.Rout: sim.CBB.Rout parameters.CBB.R Jags.%.R
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
