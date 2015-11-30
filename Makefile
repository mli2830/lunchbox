snack:	JagsCB.Rout
	less JagsCB.Rout

lunch: NimbleCB.Rout
	less NimbleCB.Rout

###########################################################

###Simulate data

simdata.RData: paramsCB.R CBsimulator.R simulateCB.R
	       R CMD BATCH simulateCB.R

###########################################################
## FITTING MCMC
### fit jags cb

JagsCB.Rout: simdata.RData CB.bug JagsCB.R
	     R CMD BATCH JagsCB.R

### fit nimble cb

NimbleCB.Rout: simdata.RData nimCB.R nimCB2.R NimbleCB.R
	       R CMD BATCH NimbleCB.R
		
		

### fit jags hybrid

Jagshybrid.Rout: simdata.RData hybrid.bug Jagshybrid.R
		 R CMD BATCH Jagshybrid.R
