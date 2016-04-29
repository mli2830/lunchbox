##This is a Makefile

target: Jags.B.P.fit.Rout

target pngtarget pdftarget vtarget acrtarget: Jags.B.P.fit.Rout

##################################################################

Sources += Makefile stuff.mk
include stuff.mk
-include $(ms)/git.def

sim.CBB.Rout: simulate.CBB.R
sim.CP.Rout: simulate.CP.R
sim.%.Rout: simulator.%.R parameters.CBB.R simulate.%.R
	    $(run-R)

B.%.Rout: process.B.R observation.%.R bugs_template.R
	  $(run-R)
BB.%.Rout: process.BB.R observation.%.R bugs_template.R
	    $(run-R)
P.%.Rout: process.P.R observation.%.R bugs_template.R
	  $(run-R)

Jags.B.%.fit.Rout: sim.CBB.Rout B.%.Rout parameters.CBB.R B.%.buggen Jags.Discrete.R
	$(run-R)

Jags.P.%.fit.Rout: sim.CBB.Rout P.%.Rout parameters.CBB.R P.%.buggen Jags.Discrete.R
		   $(run-R)

Jags.BB.%.fit.Rout: sim.CBB.Rout BB.%.Rout parameters.CBB.R BB.%.buggen Jags.Discrete.R
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
