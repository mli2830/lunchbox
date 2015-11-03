simSI <- function(beta = 0.9999,i0=2, s0=2000, 
                 t0=1, end=20,seed=NULL){
  if (!is.null(seed)) set.seed(seed)
  tvec <- seq(1,end)
  n <- length(tvec)
  I <- numeric(n)
  S <- numeric(n)
  R <- numeric(n)
  
  ##Initial conditions
  S[1] <- s0
  I[1] <- i0
  R[1] <- 0
  Psi <- 1 - beta^I[1]
  
  ##Generate the Unobserved process I, and observables
  
  for (t in 2:n){
    I[t] <- rbinom(1,prob=Psi,size=S[t-1])
    S[t] <- S[t-1] - I[t]
    R[t] <- R[t-1] + I[t-1]
    Psi <- 1 - beta^I[t]
  }
  
  cbind(tvec, S, I, R)
}




