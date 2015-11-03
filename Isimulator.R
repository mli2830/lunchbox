simi <- function(beta = 0.5, gamma=0.5,pop=50, i0=1, 
                   t0=1, end=20, dt=1, report=0.5,seed=NULL){
    if (!is.null(seed)) set.seed(seed)
    tvec <- seq(1,end,by=dt)
    n <- length(tvec)
    I <- numeric(n)
    S <- numeric(n)
    Iobs <- numeric(n)

    ##Initial conditions
    I[1] <- i0
    S[1] <- pop-i0
    Pr <- 1 - exp(-gamma*dt)
    Pi <- 1 - exp(-beta*S[1]*I[1]*dt/(pop))
    inf <- rbinom(1, prob=Pi, size= S[1])
    rec <- rbinom(1, prob=Pr, size = I[1])
    Iobs <- rbinom(1, prob=report, size = I[1])

    ##Generate the Unobserved process I, and observables

    for (t in 2:n){
        S[t] <- S[t-1] - inf
        I[t] <- I[t-1] - rec + inf
        Pi <- 1 - exp(-beta*I[t]*S[t]/(pop))
        Pr <- 1 - exp(-gamma*dt)
        inf <- rbinom(1, prob=Pi, size = S[t])
        rec <- rbinom(1, prob=Pr, size = I[t])
        Iobs[t] <- rbinom(1, prob=report, size = I[t])
    }

    cbind(tvec, S, I, Iobs)
}



    
