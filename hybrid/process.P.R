process <- c("P"
             , "
	IMean[1] <- i0*R0
  I[1] ~ dpois(IMean[1])
  "
  , 
  #  "for(t in 2:numobs){
  " IMean[t] <- I[t-1]*R0*(S[t-1]/N0)
  I[t] ~ dpois(IMean[t])"
  #  }
)