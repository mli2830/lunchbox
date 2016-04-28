##This is a Makefile

target: Jags.B.B.fit.Rout

target pngtarget pdftarget vtarget acrtarget: Jags.B.B.fit.Rout

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
BB.BB.Rout: process.BB.R observation.BB.R bugs_template.R
	    $(run-R)

Jags.CB.fit.Rout: B.B.bug Jags.CB.R
Jags.CBB.fit.Rout: BB.BB.bug Jags.CBB.R
Jags.CP.fit.Rout: CP.bug Jags.CP.R
Jags.B.%.fit.Rout: sim.CBB.Rout B.%.Rout parameters.CBB.R B.%.bug Jags.Discrete.R
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
