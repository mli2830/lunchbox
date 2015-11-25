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
mod <- nimbleModel(code = nimcode, 
                   data=nimCBdata,
                   inits=nimCBinits,
                   constants=nimCBcon,
                   name="mod")

configmod <- configureMCMC(mod,print=TRUE)
configmod$removeSamplers(c('reporting',"effprop","beta"),print=TRUE)
configmod$addSampler("reporting",type="slice",print=TRUE)
configmod$addSampler("effprop",type="slice",print=TRUE)
configmod$addSampler("beta",type="slice",print=TRUE)


configmod$getSamplers()

mcmod <- buildMCMC(configmod,)
cmod <- compileNimble(mod,mcmod)

cmod$mcmod$run(10000)
aa <- as.matrix(cmod$mcmod$mvSamples)


library(coda)

effectiveSize(as.mcmc.list(as.mcmc(aa[,11:13])))
library(lattice)

xyplot(as.mcmc(aa[,11:13]))

