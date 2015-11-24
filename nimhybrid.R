nimcode <- nimbleCode({
  ## inits
  reporting ~ dunif(0,1)
  effpropS ~ dunif(0,1)
  beta ~ dunif(0,0.2)
  effpropI ~ dunif(0,1)

  N0 ~ dgamma(N*effprop/(1-effprop),1/(1-effprop))

  S[1] <- s0
  R[1] <- r0
  pSI[1] <- 1 - (1-beta)^I[1] 
  I[1] ~ dgamma(effpropI*(pop-S[1])/(1-effpropI),1/(1-effpropI))
  IOBSshape[1] <- reporting*I[1]/(1-reporting)
  IOBSrate <- 1/(1-reporting+zerohack)
  obs[1] ~ dgamma(IOBSshape[1], IOBSrate)
  
  for(t in 2:numobs){
    #I[t] ~ dbin(pSI[t-1],S[t-1])
    SIGshape[t] <- pSI[t-1]*S[t-1]/(1-pSI[t-1] + zerohack) + zerohack
    SIGrate[t] <- 1/(1-pSI[t-1] + zerohack)
    I[t] ~ dgamma(SIGshape[t],SIGrate[t])
    S[t] <- S[t-1] - I[t]
    R[t] <- R[t-1] + I[t-1]
    pSI[t] <- 1 - (1-beta)^I[t]
    #obs[t] ~ dbin(reporting,I[t])
    IOBSshape[t] <- reporting*I[t]/(1-reporting+zerohack) + zerohack
    obs[t] ~ dgamma(IOBSshape[t],IOBSrate)
  }
}
)