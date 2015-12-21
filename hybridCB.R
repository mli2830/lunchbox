library(R2jags)
library(nimble)
library(rstan)
options(mc.cores = parallel::detectCores())

## parameters -----
source('paramsCB.R')
iterations=4000
##creating the data ----

source("CBsimulator.R")

sim <- simCB(beta=beta,N=N,effprop=effprop,i0=i0,reporting=reporting,
             numobs=numobs,seed=seed)

sim

data <- list(obs=sim$Iobs,
             N=N,
             i0=i0,
             numobs=nrow(sim),
             zerohack=zerohack)

##initial values -----
inits <- list(list(I = sim$I,
              effprop=effprop,
              beta = beta,
              N0=N0,
              reporting = reporting))

## fit CB jags ----

params = c('beta',
           'effprop',
           'reporting')

rjags::set.factory("bugs::Conjugate", TRUE, type="sampler")

cbjags <- jags(data=data,
               inits=inits,
               param = params,
               model.file = "CB.bug",
               n.iter = iterations,
               n.chains = 1)

## fit CB nimble ----
source('nimCB.R')

nimCBdata <- list(obs=sim$Iobs)
nimCBcon <- list(numobs=numobs,N=N,i0=i0)

nimCBinits <- list(I=sim$I,
                   effprop=effprop,
                   beta=beta,
                   reporting=reporting,
                   N0=N0
                   )
nimcb <- MCMCsuite(code=nimcode,
                   data=nimCBdata,
                   inits=nimCBinits,
                   constants=nimCBcon,
                   MCMCs=c("jags","nimble","nimble_slice"),
                   monitors=c("beta","reporting","effprop"),
                   calculateEfficiency=TRUE,
                   niter=4000,
                   makePlot=FALSE,
                   savePlot=FALSE)

## fit hybrid jags ----
inits[[1]]$I <- inits[[1]]$I + zerohack

hybridjags <- jags(data=data,
                   inits=inits,
                   param = params,
                   model.file = "hybrid.bug",
                   n.iter = 8000,
                   n.chains = 1)

quit()
## fit hybrid nimble ----

source('nimhybrid.R')

nimhydata <- list(obs=sim$Iobs)
nimhycon <- list(numobs=numobs,N=N,zerohack=zerohack)

nimhyinits <- list(I=sim$I+zerohack,
                   effprop=effprop,
                   beta=beta,
                   reporting=reporting,
                   N0=N0
                   )
nimhy <- MCMCsuite(code=nimcode,
                   data=nimhydata,
                   inits=nimhyinits,
                   constants=nimhycon,
                   MCMCs=c("jags","nimble","nimble_slice"),
                   monitors=c("beta","reporting","effprop"),
                   calculateEfficiency=TRUE,
                   niter=8000,
                   makePlot=FALSE,
                   savePlot=FALSE)

## hybrid stan ----

## all default options: runs
s1 <- stan(file='hybrid.stan',data=data, init=inits,
           pars=c("beta","reporting","effprop","I"),iter=4000,
           seed=1001,
           chains = 1)

## fit all hybrid via nimble ----

source('nimhybrid.R')

nimhydata <- list(obs=sim$Iobs+zerohack)
nimhycon <- list(numobs=numobs,pop=pop,r0=r0,zerohack=zerohack)

nimhyinits <- list(I=sim$I+zerohack,
                   effpropS=effpropS,
                   effpropI=effpropI,
                   beta=beta,
                   reporting=reporting,
                   s0=s0
)
allhybrids <- MCMCsuite(code=nimcode,
                   data=nimhydata,
                   inits=nimhyinits,
                   constants=nimhycon,
                   stan_model="hybrid.stan",
                   MCMCs=c("jags","nimble","stan"),
                   monitors=c("beta","reporting","effpropS","effpropI"),
                   niter=4000,
                   makePlot=FALSE,
                   savePlot=FALSE)

## fit CB nimble and hybrid stan ----
source('nimCB.R')

nimCBdata <- list(obs=sim$Iobs)
nimCBcon <- list(numobs=numobs,pop=pop,r0=r0)

nimCBinits <- list(I=sim$I,
                   effpropS=effpropS,
                   effpropI=effpropI,
                   beta=beta,
                   reporting=reporting,
                   s0=s0)

nimcb <- MCMCsuite(code=nimcode,
                   data=nimCBdata,
                   inits=nimCBinits,
                   constants=nimCBcon,
                   stan_model="hybrid.stan",
                   MCMCs=c("jags","nimble","nimble_slice","stan"),
                   monitors=c("beta","reporting","effpropS","effpropI"),
                   niter=6000,
                   thin=3,
                   makePlot=FALSE,
                   savePlot=FALSE)

nimmod <- nimbleModel(code=nimcode,data=nimCBdata,inits=nimCBinits,constants=nimCBcon)
cmod <- configureMCMC(nimmod,print=TRUE)
