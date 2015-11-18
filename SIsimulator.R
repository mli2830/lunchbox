##' Basic chain binomial simulator
##' @param beta prob. of adequate contact per infective
##' @param i0 initial infectives
##' @param s0 initial susceptibles
##' @param t0 initial time (unused)
##' @param end ending time
##' @param seed random number seed
##' @param reporting observation probability (1 by default)
##' @return a data frame with columns (time, S, I, R)
##' @details This is a Reed-Frost model.  N=s0+i0.
##' @examples
##' set.seed(101)
##' s1 <- simSI(beta=0.02,Pobs=0.7)
##' matplot(s1[,1],s1[,-1],type="b",lty=1,pch=1,
##'         col=c(1,2,4,5))
simCB <- function(beta = 0.02, pop=100, effprop=0.9, i0=1,
                 t0=1, end=20, reporting=1, seed=NULL){

  ## BMB: change name to "chain-binomial" ? e.g., simCB?
  ## *all* infecteds recover in the next time step
    
  ## default params: R0=beta*N=2
  if (!is.null(seed)) set.seed(seed)
  tvec <- seq(1,end)
  n <- length(tvec)
  I <- Iobs <- S <- R <- numeric(n)
  
  ##Initial conditions
  S[1] <- round(effprop*pop)
  I[1] <- i0
  R[1] <- 0
  Psi <- 1 - (1-beta)^I[1]  ## Reed-Frost
  ## e.g. see http://depts.washington.edu/sismid09/software/Module_7/reedfrost.R
  ## or the somewhat lame Wikipedia page
  
  ## should we scale force of infection by N or not??
  ## if we don't scale _explicitly_ then R0 = beta*N

  ## Generate the Unobserved process I, and observables:

  for (t in 2:n){
    I[t] <- rbinom(1,prob=Psi,size=S[t-1])
    S[t] <- S[t-1] - I[t]
    R[t] <- R[t-1] + I[t-1]
    Psi <- 1 - (1-beta)^I[t]
    Iobs[t] <- rbinom(1,prob=reporting,size=I[t])
  }
  
  data.frame(time=tvec, S, I, R, Iobs)

}
