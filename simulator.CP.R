library(ggplot2)
##' @param beta prob. of adequate contact per infective
##' @param i0 initial infected
##' @param t0 initial time (unused)
##' @param numobs ending time
##' @param seed random number seed
##' @param reporting observation probability (1 by default)

simm <- function(beta=0.8,i0=1,t0=1, numobs=10, shapeP=0.1, R0=2,
                 repMean=0.5, repSize=10, seed=NULL){
  
  ## *all* infecteds recover in the next time step
  
  if (!is.null(seed)) set.seed(seed)
  tvec <- seq(1,numobs)
  n <- length(tvec)
  I <- Iobs <- IMean <- pSI <- numeric(n)
  R <- R0
  
  ##Initial conditions
  I[1] <- i0
#  pShape <- rgamma(1,shape=shapeP,rate=shapeP)
#  IMean[1] <- rgamma(1,shape=pShape,rate=pShape/I[1])
  pSI[1] <- (1-beta)^I[1]
  IMean[1] <- I[1]*R
  Iobs[1] <- rpois(1,repMean*I[1])
  
  ## Generate the Unobserved process I, and observables:
  
  for (t in 2:n){
    I[t] <- rpois(1,IMean[t-1])
    pSI[t] <- 1-(1-beta)^I[t]
    IMean[t] <- I[t]*R
#    IMean[t] <- rgamma(1,shape=pShape,rate=pShape/I[t])
    Iobs[t] <- rpois(1,repMean*I[t])
  }
  
  data.frame(time=tvec, I, Iobs,IMean,pSI)
  
}

print(aa <- simm(i0=10,seed=108,numobs=20))