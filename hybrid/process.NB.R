process <- c("NB","
	I[1] ~ dgamma(2,1)
  beta <- exp(-R0/N0)
	pSI[1] <- 1 - exp(I[1]*log(beta))
  IMean[1] ~ dgamma(1,1)
  "
  ,
#  for(t in 2:numobs){
  "IMean[t] ~ dgamma(Pdis,Pdis/(pSI[t-1]*S[t-1] + eps))
  I[t] ~ dgamma(IMean[t],1)
  pSI[t] <- 1 - exp(I[t]*log(beta))
}
")