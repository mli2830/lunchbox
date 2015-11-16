library(R2jags)
library(mcmcplots)
source('Isimulator.R')

sirdat <- simi(beta=0.02,N = 50,i0 = 1,t0 = 1,
               end = 20, seed=100)
sirdat

jagsdat <- list(inc=sirdat[,3],n=nrow(sirdat), i0=1,N=50)
parameters <- c("beta")
inits <- list(list(beta=0.2))


j1 <- jags(data=jagsdat,inits, param=parameters, 
           model.file= "Imodel.bug" ,
           n.chains=length(inits), n.iter=5000, n.burnin=500, n.thin=37)


j1

mcmcthing <- as.mcmc(j1)
mcmcplot(mcmcthing)
