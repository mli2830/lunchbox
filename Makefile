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

### 

NimbleCB.Rout: simdata.RData nimCB.R NimbleCB.R
		R CMD BATCH NimbleCB.R