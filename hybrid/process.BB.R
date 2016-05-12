process <- c("BB","
	I[1] ~ dgamma(i0,1)
  beta <- exp(-R0/N0)
	pSI[1] <- 1 - exp(I[1]*log(beta))
  "
  ,
#  for(t in 2:numobs){
  "
  rate[t-1] <- 2/((1-pSI[t-1])*(1+S[t-1])) 
  I[t] ~ dgamma(S[t-1]*pSI[t-1]*rate[t-1],rate[t-1])
  pSI[t] <- 1 - exp(I[t]*log(beta))
")