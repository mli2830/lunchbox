library(R2jags)
library(nimble)
library(rstan)
options(mc.cores = parallel::detectCores())

## parameters -----
source('paramsCB.R')

##creating the data ----

source("CGsimulator.R")

sim <- simCG(beta=beta,N=N,effprop=effprop,i0=i0,reporting=reporting,repshape=0.1,
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


data$obs = data$obs+zerohack
inits[[1]]$I <- inits[[1]]$I + zerohack


params = c('beta',
           'effprop',
           'reporting')

hybridjags <- jags(data=data,
                   inits=inits,
                   param = params,
                   model.file = "hybrid.bug",
                   n.iter = 8000,
                   n.chains = 1)

## fit hybrid nimble ----

source('nimhybrid.R')

nimhydata <- list(obs=sim$Iobs+zerohack)
nimhycon <- list(numobs=numobs,pop=pop,r0=r0,zerohack=zerohack)

nimhyinits <- list(I=sim$I+zerohack,
                   effprop=effprop,
                   beta=beta,
                   reporting=reporting,
                   s0=s0
)
nimcb <- MCMCsuite(code=nimcode,
                   data=nimhydata,
                   inits=nimhyinits,
                   constants=nimhycon,
                   MCMCs=c("jags","nimble"),
                   monitors=c("beta","reporting","effprop"),
                   niter=4000,
                   makePlot=TRUE,
                   savePlot=TRUE)

## hybrid stan ----

## all default options: runs
s1 <- stan(file='hybrid.stan',data=data, init=inits,
           pars=c("beta","reporting","effpropS","effpropI","I"),iter=4000,
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
                        makePlot=TRUE,
                        savePlot=TRUE)
