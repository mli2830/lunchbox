##This is a Makefile

current: target

target pngtarget pdftarget vtarget acrtarget: dis.jags.fit.Rout

##################################################################

Sources += Makefile stuff.mk
include stuff.mk
-include $(ms)/git.def

sim.CB.Rout: simulators/simulate.CB.R
sim.%.Rout: simulators/simulator.%.R parameters.CBB.R simulators/simulate.%.R
	$(run-R)

## Discrete

dis.jags.fit.Rout: sim.CB.Rout parameters.CBB.R dis.B.B.buggen discrete/jags.R
	$(run-R)


## Hybrid

hyb.jags.fit.Rout: sim.CB.Rout parameters.CBB.R hyb.B.P.buggen hybrid/jags.R
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
