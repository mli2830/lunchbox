require(R2jags)
# options(mc.cores = parallel::detectCores())

mult <- 1:4
data <- lme4:::namedList(obs=sim$Iobs,N,i0=5,numobs)

iList <- lme4:::namedList(R0,effprop=0.9,N0,repMean=0.5
)


inits <- lapply (mult, function(m){
  return(c(iList, list(I = c(m+sim$Iobs))))
})

params <- c("R0","effprop","repMean")

print(inits)
print(length(inits))

# Jagsmod <- jags.model(file="CB.bug",data=data,inits=inits)

# list.samplers(Jagsmod)

JagsCP <- jags(data=data,
               inits=inits,
               param = params,
               model.file = "CP.bug",
               n.iter = iterations,
               n.chains = length(inits))

print(JagsCP)

# rdsave(JagsCP)
