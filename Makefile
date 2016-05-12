##This is a Makefile

target: dis.nim.BB.BB.fit.Rout

target pngtarget pdftarget vtarget acrtarget: jags.B.P.fit.Rout

##################################################################

Sources += Makefile stuff.mk
include stuff.mk
-include $(ms)/git.def

sim.CBB.Rout: simulate.CBB.R
sim.CP.Rout: simulate.CP.R
sim.NB.Rout: simulate.CNB.R
sim.%.Rout: simulator.%.R parameters.CBB.R simulate.%.R
	    $(run-R)

## Discrete

dis.B.%.Rout: discrete/process.B.R discrete/observation.%.R discrete/bugstemp.R
	      $(run-R)
dis.BB.%.Rout: discrete/process.BB.R discrete/observation.%.R discrete/bugstemp.R
	       $(run-R)
dis.P.%.Rout: discrete/process.P.R discrete/observation.%.R discrete/bugstemp.R
	      $(run-R)
dis.NB.%.Rout: discrete/process.NB.R discrete/observation.%.R discrete/bugstemp.R
	       $(run-R)



dis.jags.B.%.fit.Rout: sim.CBB.Rout dis.B.%.Rout parameters.CBB.R dis.B.%.buggen discrete/jags.R
	$(run-R)

dis.nim.B.%.fit.Rout: sim.CBB.Rout dis.B.%.Rout parameters.CBB.R dis.B.%.nimble.R discrete/nimble.R
		      $(run-R)

dis.jags.P.%.fit.Rout: sim.CBB.Rout dis.P.%.Rout parameters.CBB.R dis.P.%.buggen discrete/jags.R
		       $(run-R)

dis.nim.P.%.fit.Rout: sim.CBB.Rout dis.P.%.Rout parameters.CBB.R dis.P.%.nimble.R discrete/nimble.R
		      $(run-R)


dis.jags.BB.%.fit.Rout: sim.CBB.Rout dis.BB.%.Rout parameters.CBB.R dis.BB.%.buggen discrete/jags.R
			$(run-R)

dis.nim.BB.%.fit.Rout: sim.CBB.Rout dis.BB.%.Rout parameters.CBB.R dis.BB.%.nimble.R discrete/nimble.R
		       $(run-R)

dis.jags.NB.%.fit.Rout: sim.CBB.Rout dis.NB.%.Rout parameters.CBB.R dis.NB.%.buggen discrete/jags.R
			$(run-R)

dis.nim.NB.%.fit.Rout: sim.CBB.Rout dis.NB.%.Rout parameters.CBB.R dis.NB.%.nimble.R discrete/nimble.R
		       $(run-R)


## Hybrid

hyb.%.P.Rout: hybrid/process.%.R hybrid/observation.P.R hybrid/bugstemp.R
	      $(run-R)

hyb.jags.%.P.fit.Rout: sim.CBB.Rout hyb.%.P.Rout parameters.CBB.R hyb.%.P.buggen hybrid/jags.R
		       $(run-R)

hyb.nim.%.P.fit.Rout: sim.CBB.Rout hyb.%.P.Rout parameters.CBB.R hyb.%.P.nimble.R hybrid/nimble.R
		      $(run-R)

clean:
	rm *.nimble.R *.buggen *.wrapR.r *.Rout


Pymc.fit: PymcCB.py
	python PymcCB.py

#############
Sources += $(wildcard *.R *.bug)

-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/linux.mk
-include $(ms)/wrapR.mk
-include rmd.mk
