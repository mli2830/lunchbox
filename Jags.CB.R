require(R2jags)
# options(mc.cores = parallel::detectCores())

data <- lme4:::namedList(obs=sim$Iobs,N,i0,numobs,reppSize=repSize,
                         repobsSize=repSize,esp)
inits <- list(lme4:::namedList(I=sim$I,reppa=sim$pSI,effprop,beta,N0,repMean,
                               reppb=sim$pSI, repobsa=sim$pSI,
                               repobsb=sim$pSI))
params <- c("beta","effprop","repMean")

print(inits)

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
