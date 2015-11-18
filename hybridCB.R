library(R2jags)
library(nimble)
library(rstan)
options(mc.cores = parallel::detectCores())

## parameters -----
beta <- 0.02
pop <- 100
effpropS <- 0.8
effpropI <- 0.2
reporting <- 0.8

s0 <- effprop*pop
r0 <- 0
zerohack <- 0.001

##creating the data ----

source("SIsimulator.R")

sim <- simCB(beta=beta,pop=pop,effpropS=effpropS,effpropI=effpropI,seed=3)
sim



data <- list(obs=sim$Iobs,
             pop=100,
             M=nrow(sim),
             r0=0)

##initial values -----

inits <- list(list(I = sim$I+1,
              effpropS=effpropS,
              effpropI=effpropI,
              beta = beta,
              reporting = reporting))

## fit CB jags ----

params = c('beta',
           'effpropS',
           'effpropI',
           'reporting')

rjags::set.factory("bugs::Conjugate", FALSE, type="sampler")

cbjags <- jags(data=data,
               inits=inits,
               param = params,
               model.file = "CB.bug",
               n.iter = 8000,
               n.chains = 1)

## fit CB nimble ----
source('nimCB.R')

nimCBdata <- list(obs=sim$Iobs)
nimCBcon <- list(M=nrow(sim),pop=pop,r0=r0)

nimCBinits <- list(I=sim$I,
                   effpropS=effpropS,
                   effpropI=effpropI,
                   beta=beta,
                   reporting=reporting,
                   s0=effpropS*pop)
nimcb <- MCMCsuite(code=nimcode,
                   data=nimCBdata,
                   inits=nimCBinits,
                   constants=nimCBcon,
                   MCMCs=c("jags","nimble"),
                   monitors=c("beta","reporting","effpropS","effpropI"),
                   niter=4000,
                   makePlot=TRUE,
                   savePlot=TRUE)

## Why can't we do CB stan?? because ints are non-differentiable

## fit hybrid jags ----
data$obs = data$obs+zerohack
data$zerohack = zerohack

hybridjags <- jags(data=data,
               inits=inits,
               param = params,
               model.file = "hybrid.bug",
               n.iter = 8000,
               n.chains = 1)

## hybrid stan ----

obs <- sim$Iobs + 0.02
N = 20
pop = 100
i0=2
epi=0.01
I<- obs + 0.02

## all default options: runs
s1 <- stan(file='hybrid.stan',data=list(obs=obs,N=N,pop=pop,i0=i0,
                                      I=I,epi=epi), init="0",
           pars=c("beta","reporting","effprop","I"),iter=2000,
           seed=1001,
           chains = 1)


