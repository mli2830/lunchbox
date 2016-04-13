require(R2jags)
# options(mc.cores = parallel::detectCores())

data <- lme4:::namedList(obs=sim$Iobs,N,i0,numobs)
inits <- list(lme4:::namedList(I=sim$I,effprop,beta,N0,repMean))
params <- c("beta","effprop","repMean")

Jagsmod <- jags.model(file="CB.bug",data=data,inits=inits)

list.samplers(Jagsmod)

JagsCB <- jags(data=data,
               inits=inits,
               param = params,
               model.file = "CB.bug",
               n.iter = iterations,
               n.chains = length(inits))

print(JagsCB)

# rdsave(JagsCB)
