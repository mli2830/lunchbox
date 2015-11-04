library(R2jags)
library(mcmcplots)
source('SIsimulator.R')

sirdat <- simSI(beta=0.05,i0=1,s0 = 100,t0 = 2,
                Pobs=0.5,
                end = 20, seed=101)

sirdat

jagsdat <- list(Iobs=sirdat$Iobs, M=nrow(sirdat),i0=1)
parameters <- c("beta","Pobs","s0")

## so how do we set a good initial value without knowing it??
inits <- list(list(beta=0.1,Pobs=0.2,
                   I=sirdat$Iobs+1,s0=100),
              list(beta=0.02,Pobs=0.7,I=sirdat$Iobs+1,s0=100))


## http://sourceforge.net/p/mcmc-jags/bugs/22/
rjags::set.factory("bugs::Conjugate", FALSE, type="sampler")
j1 <- jags(data=jagsdat,inits, param=parameters, 
           model.file= "SImodel.bug" ,
           n.chains=length(inits), n.iter=10000, n.burnin=0)

## ???
## Unable to create conjugate sampler
## Please send a bug report to martyn_plummer@users.sourceforge.net

library(lattice)
library(coda)
library(mcmcplots)
m1 <- as.mcmc(j1)
xyplot(m1)
splom(as.matrix(m1),pch=".")
mcmcplot(m1)
plot(j1)


