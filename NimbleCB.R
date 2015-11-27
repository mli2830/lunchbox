require(nimble)
options(mc.cores = parallel::detectCores())
source('nimCB.R')

nimCBdata <- list(obs=sim$Iobs)
nimCBcon <- list(numobs=numobs,N=N,i0=i0)

nimCBinits <- list(I=sim$I,
                   effprop=effprop,
                   beta=beta,
                   reporting=reporting,
                   N0=N0
)

nimmod <- nimbleModel(code=nimcode,constants=nimCBcon, data=nimCBdata,
                      inits=nimCBinits)
aa <- configureMCMC(nimmod,print=TRUE)

# nimble is not picking up the conjugate beta priors for nimble
NimbleCB <- MCMCsuite(code=nimcode,
                   data=nimCBdata,
                   inits=nimCBinits,
                   constants=nimCBcon,
                   MCMCs=c("jags","nimble","nimble_slice"),
                   monitors=c("beta","reporting","effprop"),
                   calculateEfficiency=TRUE,
                   niter=10000,
                   makePlot=FALSE,
                   savePlot=FALSE)

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
                      savePlot=FALSE)

print(NimbleCB2$timing)
print(NimbleCB2$summary)




saveRDS(NimbleCB,file="NimbleCB")
saveRDS(NimbleCB2,file="NimbleCB2")

