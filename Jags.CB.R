require(R2jags)
# options(mc.cores = parallel::detectCores())

mult <- 1:4
data <- lme4:::namedList(obs=sim$Iobs,N,i0=5,numobs)

iList <- lme4:::namedList(beta,effprop=0.9,N0,repMean=0.5
)


inits <- lapply (mult, function(m){
	return(c(iList, list(I = m+sim$Iobs)))
})

params <- c("beta","effprop","repMean")

print(inits)
print(length(inits))

# Jagsmod <- jags.model(file="CB.bug",data=data,inits=inits)

# list.samplers(Jagsmod)

JagsCB <- jags(data=data,
               inits=inits,
               param = params,
               model.file = "CB.bug",
               n.iter = iterations,
               n.chains = length(inits))

print(JagsCB)

# rdsave(JagsCB)
