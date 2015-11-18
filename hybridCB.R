library(R2jags)
library(nimble)
library(rstan)
options(mc.cores = parallel::detectCores())
source('nimCB.R')


## parameters -----
beta <- 0.02
pop <- 100
effprop <- 0.8
reporting <- 0.8

s0 <- effprop*pop
i0 <- 2
r0 <- 0
zerohack <- 0.001

##creating the data ----

source("SIsimulator.R")

sim <- simCB(beta=beta,pop=pop,effprop=effprop,i0=i0,seed=3)
sim



data <- list(obs=sim$Iobs,
             pop=100,
             M=nrow(sim),
             i0=2,
             r0=0)

##initial values -----

inits <- list(list(I = c(i0,sim$I[2:20]+1),
              effprop=effprop,
              beta = beta,
              reporting = reporting))

## fit CB jags ----

params = c('beta',
              'effprop',
              'reporting')

rjags::set.factory("bugs::Conjugate", FALSE, type="sampler")

cbjags <- jags(data=data,
               inits=inits,
               param = params,
               model.file = "CB.bug",
               n.iter = 8000,
               n.chains = 1)

## fit CB nimble ----

nimCBdata <- list(obs=sim$Iobs)
nimCBcon <- list(M=nrow(sim),i0=i0,pop=pop,r0=r0)

nimCBinits <- list(I=sim$I,
                   effprop=effprop,
                   beta=beta,
                   reporting=reporting,
                   s0=effprop*pop)
nimcb <- MCMCsuite(code=nimcode,
                   data=nimCBdata,
                   inits=nimCBinits,
                   constants=nimCBcon,
                   MCMCs=c("jags","nimble"),
                   monitors=c("beta","reporting","effprop"),
                   niter=4000,
                   makePlot=TRUE,
                   savePlot=TRUE)

## Why can't we do CB stan?? because ints are non-differentiable

## fit hybrid jags ----

data$obs <- data$obs 
inits[[1]]$I <- inits[[1]]$I 
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


