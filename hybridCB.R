library(R2jags)
library(nimble)

##creating the data ----

source("SIsimulator.R")

sim <- simCB(beta=0.02,pop=100,effprop=0.8,i0=2,seed=3)
sim



data <- list(obs=sim$Iobs,
             pop=100,
             M=length(sim$Iobs),
             i0=2)

##initial values -----

inits <- list(list(I = sim$Iobs+1,
              effprop=0.8,
              beta = 0.01,
              reporting = 0.8))

## fit CB jags ----

params = c('beta',
              'effprop',
              'reporting')

rjags::set.factory("bugs::Conjugate", FALSE, type="sampler")

cbjags <- jags(data=data,
               inits=inits,
               param = params,
               model=function(){
                 ## inits
                 reporting ~ dunif(0,1)
                 effprop ~ dunif(0,1)
                 beta ~ dunif(0,0.2)
                 S[1] ~ dbin(effprop,pop)
                 R[1] <- 0
                 pSI[1] <- 1 - (1-beta)^i0 
                 I[1] ~ dbin(pSI[1],S[1])
                 obs[1] ~ dbin(reporting , I[1])
                 
                 for(t in 2:M){
                   I[t] ~ dbin(pSI[t-1],S[t-1])
                   S[t] <- S[t-1] - I[t]
                   R[t] <- R[t-1] + I[t-1]
                   pSI[t] <- 1 - (1-beta)^I[t]
                   obs[t] ~ dbin(reporting,I[t])
                 }
               },
               n.iter = 8000,
               n.chains = 1)

## fit hybrid jags ----

data$obs <- data$obs + 0.0001

hybridjags <- jags(data=data,
               inits=inits,
               param = params,
               model=function(){
                 ## inits
                 reporting ~ dunif(0,1)
                 effprop ~ dunif(0,1)
                 beta ~ dunif(0,0.2)
#                 S[1] ~ dbin(effprop,pop)
                 S[1] <- effprop*pop
                 R[1] <- 0
                 pSI[1] <- 1 - (1-beta)^i0 
#                 I[1] ~ dbin(pSI[1],S[1])
                 I[1] ~ dgamma(pSI[1]*S[1]/(1-pSI[1]),
                               1/(1-pSI[1]))
#                 obs[1] ~ dbin(reporting , I[1])
                 obs[1] ~ dgamma(reporting*I[1]/(1-reporting),
                                 1/(1-reporting))
                 
                 for(t in 2:M){
#                   I[t] ~ dbin(pSI[t-1],S[t-1])
                   I[t] ~ dgamma(pSI[t-1]*S[t-1]/(1-pSI[t-1]),
                                 1/(1-pSI[t-1]))
                   S[t] <- S[t-1] - I[t]
                   R[t] <- R[t-1] + I[t-1]
                   pSI[t] <- 1 - (1-beta)^I[t]
#                   obs[t] ~ dbin(reporting,I[t])
                   obs[t] ~ dgamma(reporting*I[t]/(1-reporting),
                                   1/(1-reporting))
                 }
               },
               n.iter = 8000,
               n.chains = 1)

## hybrid stan ----

library("rstan")
options(mc.cores = parallel::detectCores())


obs <- sim$Iobs + 0.02
N = 20
pop = 100
i0=2
epi=0.01
I<- obs + 0.02

## all default options: runs
s1 <- stan(file='hybrid.stan',data=list(obs=obs,N=N,pop=pop,i0=i0,
                                      I=I,epi=epi), init="0",
           pars=c("beta","reporting","effprop"),iter=2000,
           seed=1001,
           chains = 1)
