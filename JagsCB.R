require(R2jags)
options(mc.cores = parallel::detectCores())

rjags::set.factory("bugs::Conjugate", FALSE, type="sampler")

JagsCB <- jags(data=data,
               inits=inits,
               param = params,
               model.file = "CB.bug",
               n.iter = iterations,
               n.chains = length(inits))

print(JagsCB)

saveRDS(JagsCB,file="JagsCB")