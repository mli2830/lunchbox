library(nimble)

nimcode <- nimbleCode({
  ## inits
  reporting ~ dunif(0,1)
  effprop ~ dunif(0,1)
  beta ~ dunif(0,0.2)
  s0 ~ dbin(effprop,pop)
  S[1] <- s0
  R[1] <- r0
  pSI[1] <- 1 - (1-beta)^i0 
  I[1] ~ dbin(1,i0)
  obs[1] ~ dbin(reporting , i0)
  
  for(t in 2:M){
    I[t] ~ dbin(pSI[t-1],S[t-1])
    S[t] <- S[t-1] - I[t]
    R[t] <- R[t-1] + I[t-1]
    pSI[t] <- 1 - (1-beta)^I[t]
    obs[t] ~ dbin(reporting,I[t])
  }})
