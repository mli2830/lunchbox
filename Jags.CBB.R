require(R2jags)
# options(mc.cores = parallel::detectCores())

mult <- 1:4
data <- lme4:::namedList(obs=sim$Iobs,N,i0=6,numobs,pSISize=repSize,
                         repobsSize=repSize,eps
)

iList <- lme4:::namedList(
  pSIa=sim$pSI,effprop=0.7,R0,N0,repMean=0.5,
  pSIb=sim$pSI, repobsa=repMean, repobsb=repMean, initDis=0.2
)


inits <- lapply (mult, function(m){
  return(c(iList, list(I = c(m+sim$Iobs))))
})

params <- c("R0","effprop","repMean")

print(inits)
print(length(inits))

# Jagsmod <- jags.model(file="CB.bug",data=data,inits=inits)

# list.samplers(Jagsmod)

JagsCBB <- jags(data=data,
               inits=inits,
               param = params,
               model.file = "BB.BB.bug",
               n.iter = iterations,
               n.chains = length(inits))

print(JagsCBB)

# rdsave(JagsCBB)
