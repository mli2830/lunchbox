process <- c("P"
             , "
	IMean[1] <- i0*R0
  I[1] ~ dpois(IMean[1])
  beta <- exp(-R0/N0)
	pSI[1] <- 1 - exp(I[1]*log(beta))
  
  "
  , 
  #  "for(t in 2:numobs){
  " IMean[t] <- pSI[t-1]*S[t-1]
  pSI[t] <- 1 - exp(I[t]*log(beta))
  I[t] ~ dpois(IMean[t])"
  #  }
)