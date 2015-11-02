library(R2jags)
source('Isimulator.R')

sirdat <- simi(beta=2,gamma = 0.4,pop = 50,i0 = 1,s0=49,t0 = 1,
               end = 20,dt = 1,report = 0.3, seed=101)

sirdat



jagsdat <- list(o=sirdat[,4], dt=1,M=nrow(sirdat), i0=1, s0=49,pop=50)
parameters <- c("beta","gamma","report")
inits <- list(list(beta=2,gamma=0.3,report=0.4))


j1 <- jags(data=jagsdat,inits, param=parameters, model.file = "Imodel.bug",   
           n.chains=length(inits), n.iter=5000, n.burnin=500, n.thin=37)


j1

library(mcmcplots)

mcmcthing <- as.mcmc(j1)
mcmcplot(mcmcthing)
