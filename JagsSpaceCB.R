require(R2jags)
options(mc.cores = parallel::detectCores())

rjags::set.factory("bugs::Conjugate", TRUE, type="sampler")

Jagsmod <- jags.model(file="spaceCB.bug",data=data,inits=inits)

list.samplers(Jagsmod)

JagsSapceCB <- jags(data=data,
               inits=inits,
               param = params,
               model.file = "spaceCB.bug",
               n.iter = iterations,
               n.chains = length(inits))

print(JagsSpaceCB)

saveRDS(JagsSpaceCB,file="JagsSpaceCB")