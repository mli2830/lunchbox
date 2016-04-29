##This is a Makefile

target: jags.B.P.fit.Rout

target pngtarget pdftarget vtarget acrtarget: jags.B.P.fit.Rout

##################################################################

Sources += Makefile stuff.mk
include stuff.mk
-include $(ms)/git.def

sim.CBB.Rout: simulate.CBB.R
sim.CP.Rout: simulate.CP.R
sim.%.Rout: simulator.%.R parameters.CBB.R simulate.%.R
	    $(run-R)

## Discrete

dis.B.%.Rout: dis.process.B.R dis.observation.%.R dis.bugstemp.R
	      $(run-R)
dis.BB.%.Rout: dis.process.BB.R dis.observation.%.R dis.bugstemp.R
	       $(run-R)
dis.P.%.Rout: dis.process.P.R dis.observation.%.R dis.bugstemp.R
	      $(run-R)

dis.jags.B.%.fit.Rout: sim.CBB.Rout dis.B.%.Rout parameters.CBB.R dis.B.%.buggen dis.jags.R
	$(run-R)

dis.jags.P.%.fit.Rout: sim.CBB.Rout dis.P.%.Rout parameters.CBB.R dis.P.%.buggen dis.jags.R
		   $(run-R)

dis.jags.BB.%.fit.Rout: sim.CBB.Rout dis.BB.%.Rout parameters.CBB.R dis.BB.%.buggen dis.jags.R
		    $(run-R)


## Hybrid

hyb.B.%.Rout: hyb.process.B.R hyb.observation.%.R hyb.bugstemp.R
	      $(run-R)
hyb.BB.%.Rout: hyb.process.BB.R hyb.observation.%.R hyb.bugstemp.R
	       $(run-R)
hyb.P.%.Rout: hyb.process.P.R hyb.observation.%.R hyb.bugstemp.R
	      $(run-R)

hyb.jags.B.%.fit.Rout: sim.CBB.Rout hyb.B.%.Rout parameters.CBB.R hyb.B.%.buggen hyb.jags.R
	$(run-R)

hyb.jags.P.%.fit.Rout: sim.CBB.Rout hyb.P.%.Rout parameters.CBB.R hyb.P.%.buggen hyb.jags.R
		   $(run-R)

hyb.jags.BB.%.fit.Rout: sim.CBB.Rout hyb.BB.%.Rout parameters.CBB.R hyb.BB.%.buggen hyb.jags.R
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
