##nimble stuff 

library(nimble)

modcode <- nimbleCode({
  ## Initial values
  I[1] <- i0
  S[1] <- s0
  Pr[1] <- pr0
  Pi[1] <- 1 - exp(-beta*I[1]*S[1]*dt/pop)
  o[1] ~ dbin(report,I[1])
  inf[1] ~ dbin(Pi[1],S[1])
  rec[1] ~ dbin(Pr[1],I[1])
  
  ## Step through observations
  for (t in 2:M) {
    S[t] <- S[t-1] - inf[t-1]
    I[t] <- I[t-1] - rec[t-1] + inf[t-1]
    
    
    Pr[t] <- 1 - exp(-gamma*dt)
    Pi[t] <- 1 - exp(-beta*S[t]*I[t]*dt/pop)
    inf[t] ~ dbin(Pi[t],S[t])
    rec[t] ~ dbin(Pr[t],I[t])
    o[t] ~ dbin(report,I[t])
  }
  ## aux variables
  
  ## priors
  beta ~ dgamma(3,1)
  gamma ~ dunif(0,5)
  report ~ dunif(0,5)
  
}
)



modConsts <- list(M=nrow(sirdat),dt=1,i0=1,s0=49,pop=50,pr0=1-exp(-0.5))

modData <- list(o=sirdat[,4],
                I = numeric(nrow(sirdat)),
                S = numeric(nrow(sirdat)),
                inf = numeric(nrow(sirdat)),
                rec = numeric(nrow(sirdat)),
                Pr = numeric(nrow(sirdat)))

modInits <- list(beta = 1, gamma=0.5, report=0.5)

testing <- nimbleModel(code = modcode, name = 'sir', constants = modConsts,
                    data = modData, inits = modInits)

testingMCMC <- buildMCMC(testing)


Ctesting <- compileNimble(testing)
CtestingMCMC <- compileNimble(testingMCMC, project = testing)
CtestingMCMC$run(10000)

MCMCsamples <- as.matrix(CtestingMCMC$mvSamples)
plot(MCMCsamples[ , 'beta'], type = 'l', xlab = 'iteration',  ylab = expression(beta))
