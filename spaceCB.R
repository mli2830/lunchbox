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
simspaceCB <- function(spacenum = 1,betaw = 0.02, betab = 0.01, N=100, effprop=0.9, i0=1,
                       effinf=0.8, t0=1, numobs=20, reporting=1, seed=NULL){
  
  ## *all* infecteds recover in the next time step
  
  if (!is.null(seed)) set.seed(seed)
  tvec <- seq(1,numobs)
  n <- length(tvec)
  S  <- I <- pSI <- matrix(0,ncol=spacenum,nrow=numobs)
  beta <- matrix(betab,nrow=spacenum, ncol=spacenum)
  R <- Iobs <- numeric(numobs)
#  pSI <- I <-array(0,dim=c(numobs,spacenum,spacenum))
  
  
  ##Initial conditions
  N0 <- round(effprop*N)
  I[1,1] <- i0 
  S[1,] <- round(N0/spacenum)
  S[1,1] <- S[1,1]-I[1,1]
  R[1] <- N-N0
  pSI[1,] <- 0
  for(i in 1:spacenum){
    beta[i,i] <- betaw
  }
  for (i in 1:spacenum){
    temp <- spacenum
    for (j in 1:spacenum){
      temp <- temp - (1-beta[i,j])^I[1,j] 
    }
    pSI[1,i] <- effinf*min(temp,1)
  }
  
  Iobs[1] <- rbinom(1,prob=reporting,size=sum(I[1,]))
  
  ## Generate the Unobserved process I, and observables:
  
  for (t in 2:n){
    for (i in 1:spacenum){
        I[t,i] <- rbinom(1,prob=pSI[t-1,i],size=S[t-1,i])
        S[t,i] <- S[t-1,i] - I[t,i]
        R[t] <- R[t-1] + sum(I[t-1,])
    }
    for (i in 1:spacenum){
      temp <- spacenum
        for (j in 1:spacenum){
          temp <- temp - (1-beta[i,j])^I[t,j]
        }
    pSI[t,i] <- effinf*min(1, temp)
    Iobs[t] <- rbinom(1,prob=reporting,size=sum(I[t,]))
  }
    
    Iobs[t] <- rbinom(1,prob=reporting,size=sum(I[t,]))
  }
  return(list(time=tvec, S=S, I=I, R=R, Iobs=Iobs, pSI=pSI))
  
}

sim <- simspaceCB(spacenum = 5, numobs=20, betaw=0.005, betab=0.0001, N=2000,seed=4, effinf=1)
sim
plot(sim$Iobs)
