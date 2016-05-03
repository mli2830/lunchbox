process <- c("BB","
	I[1] ~ dgamma(i0,1)
  beta <- exp(-R0/N0)
	pSI[1] <- 1 - exp(I[1]*log(beta))
	pSIa[1] ~ dgamma(pSISize/(1-pSI[1]),1)
	pSIb[1] ~ dgamma(pSISize/(pSI[1]),1)
  
  for(t in 2:numobs){
  SIGshape[t] <- S[t-1]*SIGrate[t]*pSIa[t-1]/(pSIa[t-1]+pSIb[t-1])
  SIGrate[t] <- 1/(1-pSIa[t-1]/(pSIa[t-1]+pSIb[t-1]))
  I[t] ~ dgamma(SIGshape[t],SIGrate[t])
  pSI[t] <- 1 - exp(I[t]*log(beta))
	pSIa[t] ~ dgamma(pSISize/(1-pSI[t]),1)
	pSIb[t] ~ dgamma(pSISize/(pSI[t]),1)
}
")