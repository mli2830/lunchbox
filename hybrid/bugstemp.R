priors <- (" 
  repMean ~ dbeta(1,1)
	effprop ~ dbeta(100,35)
	initDis ~ dbeta(1,1)
  Ndis ~ dgamma(1,1)
           
  ## This may be a bad prior
  R0 ~ dgamma(3,1)
           
  N0 ~ dgamma(N*effprop/(1-effprop),1/(1-effprop))
")

S <- c("
  S[1] <- N0 - I[1]
  "
       ,"
    S[t] <- S[t-1] - I[t]
")

iterloop <- c("for(t in 2:numobs){","}")

nimstart <- ("
  library(nimble)
  nimcode <- nimbleCode({
")

## Jags script
(cat("model{"
     , priors
     , process[2]
     , S[1]
     , observation[2]
     , iterloop[1]
     , process[3]
     , S[2]
     , observation[3]
     , iterloop[2]
     , "}"
    , file=paste("hyb",process[1],observation[1],"buggen",sep=".")
))


## nimble script
(cat(nimstart
     , priors
     , process[2]
     , S[1]
     , observation[2]
     , iterloop[1]
     , process[3]
     , S[2]
     , observation[3]
     , iterloop[2]
     , "})"
     , file=paste("hyb",process[1],observation[1],"nimble.R",sep=".")))



