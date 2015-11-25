lunch: NimbleCB.RData
	less NimbleCB.Rout

dinner: simdata.RData nimCB.R NimbleCB.R eviltwin.R
	R CMD BATCH eviltwin.R
	less eviltwin.Rout
###########################################################

###Simulate data

simdata.RData: paramsCB.R CBsimulator.R simulateCB.R
	 R CMD BATCH simulateCB.R

###########################################################
## FITTING MCMC
### fit jags cb

JagsCB.RData: simdata.RData CB.bug JagsCB.R
	      R CMD BATCH JagsCB.R

### 

NimbleCB.RData: simdata.RData nimCB.R NimbleCB.R
		R CMD BATCH NimbleCB.R