process <- c("NB"
  ,"
  Pdis ~ dgamma(1,1)
	I[1] ~ dnegbin(initDis,i0)
  beta <- exp(-R0/N0)
	pSI[1] <- 1 - exp(I[1]*log(beta))
  IMean[1] ~ dgamma(1,1)
  "
  , 
  #  "for(t in 2:numobs){
  "
  IMean[t] ~ dgamma(Pdis,Pdis/(pSI[t-1]*S[t-1] + eps))
  I[t] ~ dpois(IMean[t])
  pSI[t] <- 1 - exp(I[t]*log(beta))
  "
             #  }"
)