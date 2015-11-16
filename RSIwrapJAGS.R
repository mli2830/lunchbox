library(R2jags)
library(mcmcplots)
library(lattice)
library(coda)

source("SIsimulator.R")
sirdat <- simCB(beta=0.05,i0=1,s0 = 100,t0 = 2,
                Pobs=0.5, end = 20, seed=101)

sirdat

jagsdat <- list(Iobs=sirdat$Iobs, M=nrow(sirdat),i0=1)
parameters <- c("beta","Pobs","s0")

## Two chains from fairly divergent starting points
## (s0 starts at real value)
## set initial I to observed I +1 so that we never have a case
## with Iobs=0, I>0
inits <- list(list(beta=0.1,Pobs=0.2,
                   I=sirdat$Iobs+1,s0=100),
              list(beta=0.02,Pobs=0.7,I=sirdat$Iobs+1,s0=100))


## When using JAGS 3.2.0 we sometimes get:
## "Unable to create conjugate sampler
## Please send a bug report to martyn_plummer@users.sourceforge.net"
## web-search reveals this workaround from
##    http://sourceforge.net/p/mcmc-jags/bugs/22/:
rjags::set.factory("bugs::Conjugate", FALSE, type="sampler")
j1 <- jags(data=jagsdat,inits, param=parameters, 
           model.file= "SImodel.bug" ,
           n.chains=length(inits), n.iter=10000, n.burnin=0)


m1 <- as.mcmc(j1)
xyplot(m1)                    ## traceplot
splom(as.matrix(m1),pch=".")  ## pairs plot
mcmcplot(m1)                  ## fancy plot
plot(j1)                      ## another fancy (but less useful) plot


