nimcode <- nimbleCode({
  ## inits
  reporting ~ dunif(0,1)
  effprop ~ dunif(0,1)
  beta ~ dunif(0,0.2)

  N0 ~ dgamma(N*effprop/(1-effprop),1/(1-effprop))

  S[1] <- N0-I[1]
  pSI[1] <- 1 - (1-beta)^I[1] 
  I[1] ~ dunif(0,3)
  obs[1] ~ dpois(reporting*I[1])
  
  for(t in 2:numobs){
    #I[t] ~ dbin(pSI[t-1],S[t-1])
    SIGshape[t] <- pSI[t-1]*S[t-1]/(1-pSI[t-1] + zerohack) + zerohack
    SIGrate[t] <- 1/(1-pSI[t-1] + zerohack)
    I[t] ~ dgamma(SIGshape[t],SIGrate[t])
    S[t] <- S[t-1] - I[t]
    pSI[t] <- 1 - (1-beta)^I[t]
    #obs[t] ~ dbin(reporting,I[t])
    obs[t] ~ dpois(reporting*I[t])
  }
}
)