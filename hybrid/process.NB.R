process <- c("NB","
	I[1] ~ dgamma(i0,1)
  beta <- exp(-R0/N0)
	pSI[1] <- 1 - exp(I[1]*log(beta))
  Pdis ~ dunif(0,100)
  "
  ,
#  for(t in 2:numobs){
  "I[t] ~ dgamma(Pdis,Pdis/(pSI[t-1]*S[t-1]))
  pSI[t] <- 1 - exp(I[t]*log(beta))

")