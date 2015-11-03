library(R2jags)
library(mcmcplots)
source('SIsimulator.R')

sirdat <- simSI(beta=0.999,i0=2,s0 = 2000,t0 = 2,
               end = 20, seed=10)

sirdat

jagsdat <- list(I=sirdat[,3],M=nrow(sirdat),s0=2000,i0=2)
parameters <- c("beta")
inits <- list(list(beta=0.9))


j1 <- jags(data=jagsdat,inits, param=parameters, 
           model.file= "SImodel.bug" ,
           n.chains=length(inits), n.iter=5000, n.burnin=500, n.thin=37)


j1

mcmcthing <- as.mcmc(j1)
mcmcplot(mcmcthing)
