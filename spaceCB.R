##' Basic chain binomial simulator
##' @param beta prob. of adequate contact per infective
##' @param population size
##' @param effprop initial effective proportion of population
##' @param i0 initial infected
##' @param t0 initial time (unused)
##' @param numobs ending time
##' @param seed random number seed
##' @param reporting observation probability (1 by default)
##' @return a data frame with columns (time, S, I, R) 
simspaceCB <- function(spacenum = 1,betatemp = 0.02, N=100, effprop=0.9, i0=1,
                       t0=1, numobs=20, reporting=1, seed=NULL){
  
  ## *all* infecteds recover in the next time step
  
  if (!is.null(seed)) set.seed(seed)
  tvec <- seq(1,numobs)
  n <- length(tvec)
  S <- matrix(0,ncol=spacenum,nrow=numobs)
  R <- Iobs <- numeric(numobs)
  pSI <- I <- array(0,dim=c(numobs,spacenum,spacenum))
  
  
  
  ##Initial conditions
  N0 <- round(effprop*N)
  I[1,1,1] <- i0 
  S[1,] <- round(N0/spacenum)
  S[1,1] <- S[1,1]-I[1,1,1]
  R[1] <- N-N0
  pSI[1,,] <- 0
  beta <- array(betatemp,dim=c(numobs,spacenum,spacenum))
  pSI[1,1,1] <- 1 - (1-beta[1,1,1])^I[1,1,1]
  Iobs[1] <- rbinom(1,prob=reporting,size=sum(I[1,,]))
  
  ## Generate the Unobserved process I, and observables:
  
  for (t in 2:n){
    for (i in 1:spacenum){
      for (j in 1:spacenum){
        I[t,i,j] <- rbinom(1,prob=pSI[t-1,i,j],size=S[t-1,i])
        pSI[t,i,j] <- 1 - (1-beta[t,i,j])^sum(I[t,,j])
      }
      S[t,i] <- S[t-1,i] - sum(I[t,i,])
    }
    R[t] <- R[t-1] + sum(I[t-1,,])
    Iobs[t] <- rbinom(1,prob=reporting,size=sum(I[t,,]))
  }
  
  return(list(time=tvec, S=S, I=I, R=R, Iobs=Iobs))
  
}

aa <- simspaceCB(spacenum = 2, numobs=10, betatemp=0.03,N=10000)
