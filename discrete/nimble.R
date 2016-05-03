require(nimble)
##options(mc.cores = parallel::detectCores())
nimbleOptions(verifyConjugatePosteriors=TRUE)
nimCBdata <- lme4:::namedList(obs=sim$Iobs)
nimCBcon <- lme4:::namedList(numobs,N,i0,pSISize=repSize,
                             repobsSize=repSize,eps)

nimCBinits <- lme4:::namedList(I=sim$I,effprop,R0,repMean,N0, 
                               pSIa=sim$pSI,
                               pSIb=sim$pSI, 
#                                repobsa=repMean, 
#                                repobsb=repMean, 
                               initDis=0.2)

params <- c("R0","effprop","repMean")

# nimmod <- nimbleModel(code=nimcode,constants=nimCBcon, data=nimCBdata,
#                       inits=nimCBinits)
# aa <- configureMCMC(nimmod,print=TRUE)
# 
# # nimble is not picking up the conjugate beta priors for nimble
NimbleCB <- MCMCsuite(code=nimcode,
                      data=nimCBdata,
                      inits=nimCBinits,
                      constants=nimCBcon,
                      MCMCs=c("jags","nimble","nimble_slice"),
                      monitors=params,
                      calculateEfficiency=TRUE,
                      niter=iterations,
                      makePlot=FALSE,
                      savePlot=FALSE,
                      setSeed=5)

print(NimbleCB$timing)
print(NimbleCB$summary)
