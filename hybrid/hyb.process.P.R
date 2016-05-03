process <- c("P","
	IMean[1] <- i0*R0
  
  for(t in 1:numobs){
    I[t] ~ dgamma(IMean[t],1)
    IMean[t+1] <- I[t]*R0*(S[t]/N0)
  }
")