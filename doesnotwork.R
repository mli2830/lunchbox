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

NimbleCB <- MCMCsuite(code=nimcode,
                      data=nimCBdata,
                      inits=nimCBinits,
                      constants=nimCBcon,
                      MCMCs=c("hacks"),
                      MCMCdefs=list(
                        hacks=quote({
                          configmod <- configureMCMC(mod,nodes=NULL)
                          #     configmod$removeSamplers(c('reporting',"effprop","beta"),print=FALSE)
                          #     configmod$addSampler("reporting",type="slice",print=FALSE)
                          #     configmod$addSampler("effprop",type="slice",print=FALSE)
                          #     configmod$addSampler("beta",type="slice",print=FALSE)
                          configmod})
                      ),
                      monitors=c("beta","reporting","effprop"),
                      calculateEfficiency=TRUE,
                      niter=10000,
                      makePlot=FALSE,
                      savePlot=FALSE)

print(NimbleCB$timing)
print(NimbleCB$summary)

saveRDS(NimbleCB,file="NimbleCB")
