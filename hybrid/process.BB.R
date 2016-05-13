process <- c("BB","
	I[1] ~ dgamma(i0,1)
  beta <- exp(-R0/N0)
  Pdis ~ dunif(0,100)
	pSI[1] <- 1 - exp(I[1]*log(beta))
  x[1] <- Pdis/(1-pSI[1])
  y[1] <- Pdis/(pSI[1])
  "
  ,
#  for(t in 2:numobs){
  "
  kappa[t-1] <- (x[t-1]+y[t-1]+1)/(y[t-1]*(x[t-1]+y[t-1]+S[t-1]))
  I[t] ~ dgamma(S[t-1]*x[t-1]*kappa[t-1],(x[t-1]+y[t-1])*kappa[t-1])
  pSI[t] <- 1 - exp(I[t]*log(beta))
  x[t] <- Pdis/(1-pSI[t])
  y[t] <- Pdis/pSI[t]
")