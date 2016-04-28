library(ggplot2)
##' @param beta prob. of adequate contact per infective
##' @param i0 initial infected
##' @param t0 initial time (unused)
##' @param numobs ending time
##' @param seed random number seed
##' @param reporting observation probability (1 by default)

simm <- function(R0=2,i0=1,t0=1, numobs=10, N=1000, effprop=0.9,
                 repMean=0.5, seed=NULL){
  
  ## *all* infecteds recover in the next time step
  
  if (!is.null(seed)) set.seed(seed)
  tvec <- seq(1,numobs)
  n <- length(tvec)
  I <- Iobs <- IMean <- pSI <- S <- R <- numeric(n)
  
  ##Initial conditions
  
  N0 <- round(effprop*N)
  I[1] <- i0
  S[1] <- N0 - i0
  R[1] <- N - N0
  IMean[1] <- I[1]*R0*(S[1]/N0)
  Iobs[1] <- rpois(1,repMean*I[1])
  
  ## Generate the Unobserved process I, and observables:
  
  for (t in 2:n){
    I[t] <- rpois(1,IMean[t-1])
    S[t] <- S[t-1] - I[t]
    R[t] <- R[t-1] + I[t-1]
    IMean[t] <- I[t]*R0*(S[t]/N0)
    Iobs[t] <- rpois(1,repMean*I[t])
  }
  
  data.frame(time=tvec, S, I, R, Iobs,IMean)
  
}