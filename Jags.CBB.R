require(R2jags)
# options(mc.cores = parallel::detectCores())

mult <- 1:4
data <- lme4:::namedList(obs=sim$Iobs,N,i0=6,numobs,reppSize=repSize,
                         repobsSize=repSize,eps
)

iList <- lme4:::namedList(
  reppa=sim$pSI,effprop=0.9,R0,N0,repMean=0.5,
  reppb=sim$pSI, repobsa=sim$pSI, repobsb=sim$pSI
)


inits <- lapply (mult, function(m){
  return(c(iList, list(I = m+sim$Iobs)))
})

params <- c("R0","effprop","repMean")

print(inits)
print(length(inits))

# Jagsmod <- jags.model(file="CB.bug",data=data,inits=inits)

# list.samplers(Jagsmod)

JagsCB <- jags(data=data,
               inits=inits,
               param = params,
               model.file = "CBB.bug",
               n.iter = iterations,
               n.chains = length(inits))

print(JagsCB)

# rdsave(JagsCB)
