priors <- (" 
  repMean ~ dbeta(1,1)
  effprop ~ dbeta(1,1)
  initDis ~ dbeta(1,1)
           
  ## This may be a bad prior
  R0 ~ dgamma(2,1)
           
  N0 ~ dgamma(N*effprop/(1-effprop),1/(1-effprop))
")

S <- ("
  S[1] <- N0 - I[1]
  for(t in 2:numobs){
    S[t] <- S[t-1] - I[t] + 1
  }
")

nimstart <- ("
  library(nimble)
  nimcode <- nimbleCode({
")

## Jags script
(cat("model{"
     , priors
     , S
     , process[2]
     , observation[2]
     , "}"
    , file=paste("hyb",process[1],observation[1],"buggen",sep=".")
))


## nimble script
(cat(nimstart
     , priors
     , S
     , process[2]
     , observation[2]
     , "})"
     , file=paste("hyb",process[1],observation[1],"nimble.R",sep=".")))



