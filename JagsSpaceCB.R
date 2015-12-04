require(R2jags)
options(mc.cores = parallel::detectCores())

source("paramsSpaceCB.R")
source("spaceCBsimulator.R")
source("simulatespaceCB.R")

rjags::set.factory("bugs::Conjugate", TRUE, type="sampler")
data <- list(obs=sim$Iobs,
             i0=i0,
             spacenum=spacenum,
             numobs=numobs,
             subpop = round(N*effprop/spacenum),
             N=N)
inits <- list(list(I=sim$I,  
  effprop =effprop,
  reporting =reporting,
  N0 = N*effprop,
  beta=matrix(betab,nrow=spacenum,ncol=spacenum)))
params = c("effprop","reporting","beta")
Jagsmod <- jags.model(file="spaceCB.bug",data=data,inits=inits)

list.samplers(Jagsmod)

JagsSpaceCB <- jags(data=data,
               inits=inits,
               param = params,
               model.file = "spaceCB.bug",
               n.iter = iterations,
               n.chains = length(inits))

print(JagsSpaceCB)

saveRDS(JagsSpaceCB,file="JagsSpaceCB")