process <- c("B","
	I[1] ~ dgamma(i0,1)
  beta <- exp(-R0/N0)
	pSI[1] <- 1 - exp(I[1]*log(beta))
  "
  ,
#  for(t in 2:numobs){
  "SIGrate[t] <- 1/(1-pSI[t-1])
  SIGshape[t] <- pSI[t-1]*S[t-1]*SIGrate[t]
  I[t] ~ dgamma(SIGshape[t],SIGrate[t])
  pSI[t] <- 1 - exp(I[t]*log(beta))

")