##This is a Makefile

current: target

target pngtarget pdftarget vtarget acrtarget: fit.dis.b.p.1.4000.Rout 

##################################################################

Sources += Makefile stuff.mk
include stuff.mk
-include $(ms)/git.def

sim.%.Rout: simulators/simulator.CBB.R parameters.CBB.R name.R simulators/simulate.CBB.R
	$(run-R)

fit.%.Rout: sim.%.Rout name.R parameters.CBB.R process.R observations.R nimbletemp.R fit.R
	$(run-R)


## Discrete

dis.jags.fit.Rout: sim.CB.Rout parameters.CBB.R dis.B.B.buggen discrete/jags.R
	$(run-R)

## Hybrid

# Mike, do you need to fix this flow?
Sources += hyb.B.P.buggen

hyb.jags.fit.Rout: sim.CB.Rout parameters.CBB.R hyb.B.P.buggen hybrid/jags.R
	$(run-R)

hyb.jags.plot.Rout: hyb.jags.fit.Rout jagsplot.R
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
