require(R2jags)
# options(mc.cores = parallel::detectCores())

type <- unlist(strsplit(rtargetname,"[.]"))

mult <- 1:4
data <- lme4:::namedList(obs=sim$Iobs
  , N
  , i0=6
  , numobs
)

iList <- lme4:::namedList(effprop
  , R0
  , N0
  , repMean
)

inits <- lapply (mult, function(m){
  return(c(iList, list(I = c(m+sim$Iobs))))
})

params <- c("R0","effprop","repMean")

print(type)
print(data)
print(inits)
print(length(inits))


# Jagsmod <- jags.model(file="CB.bug",data=data,inits=inits)

# list.samplers(Jagsmod)

system.time(JagsDiscrete <- jags(data=data
    , inits=inits
    , param = params
    , model.file = input_files[[1]]
    , n.iter = iterations
    , n.chains = length(inits))
)

print(JagsDiscrete)

print(plot(JagsDiscrete))
print(traceplot(JagsDiscrete))
# rdsave(JagsDiscrete)
