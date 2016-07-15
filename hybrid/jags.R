require(R2jags)
# options(mc.cores = parallel::detectCores())

type <- unlist(strsplit(rtargetname,"[.]"))

mult <- 1:4
data <- lme4:::namedList(obs=sim$Iobs
  , N
  , i0=6
  , numobs
)
# data <- lme4:::namedList(obs=sim$Iobs,N,i0=6,numobs,pSISize=repSize,
#                          repobsSize=repSize,eps
# )
iList <- lme4:::namedList(effprop=0.7
  , R0=1
  , N0
  , repMean=0.5
)

inits <- lapply (mult, function(m){
  return(c(iList, list(I = c(m+sim$Iobs))))
})

params <- c("R0","effprop","repMean")

print(inits)
print(length(inits))

# Jagsmod <- jags.model(file="CB.bug",data=data,inits=inits)

# list.samplers(Jagsmod)

system.time(JagsHybrid <- jags(data=data,
                     inits=inits,
                     param = params,
                     model.file = input_files[[1]],
                     n.iter = iterations,
                     n.chains = length(inits))
)
print(JagsHybrid)

# rdsave(JagsHybrid)
