require(nimble)
options(mc.cores = parallel::detectCores())
source('nimCB.R')
nimbleOptions(verifyConjugatePosteriors=TRUE)
nimCBdata <- lme4:::namedList(obs=sim$Iobs)
nimCBcon <- lme4:::namedList(numobs,N,i0)
nimCBinits <- lme4:::namedList(I=sim$I,effprop,beta,reporting,N0)

nimmod <- nimbleModel(code=nimcode,constants=nimCBcon, data=nimCBdata,
                      inits=nimCBinits)
aa <- configureMCMC(nimmod,print=TRUE)

# nimble is not picking up the conjugate beta priors for nimble
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

source("nimCB2.R")

nimmod <- nimbleModel(code=nimcode,constants=nimCBcon, data=nimCBdata,
                      inits=nimCBinits)
aa <- configureMCMC(nimmod,print=TRUE)

NimbleCB2 <- MCMCsuite(code=nimcode,
                      data=nimCBdata,
                      inits=nimCBinits,
                      constants=nimCBcon,
                      MCMCs=c("jags","nimble","nimble_slice"),
                      monitors=c("beta","reporting","effprop"),
                      calculateEfficiency=TRUE,
                      niter=10000,
                      makePlot=FALSE,
                      savePlot=FALSE,
                      setSeed=5)

print(NimbleCB2$timing)
print(NimbleCB2$summary)




# rdsave(NimbleCB,NimbleCB2) 
