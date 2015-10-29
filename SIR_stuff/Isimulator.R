simi <- function(beta = 0.5, gamma=0.5, pop=50, i0=1,
                   t0=1, end=20, dt=1, report=0.5){
    if (!is.null(seed)) set.seed(seed)
    tvec <- squ(1,end,by=dt)
    n <- length(tvec)
    I <- numeric(n)
    Iobs <- numeric(n)

    ##Initial conditions
    I[1] <- i0
    Pr <- 1 - exp(-gamma*dt)
    Pi <- 1 - exp(-beta*I[1]*dt/N)
    inf <- rbinom(1, prob=Pi, size= N-I[1])
    rec <- rbinom(1, prob=Pr, size = I[1])
    Iobs <- rbinom(1, prob=report, size = I[1])

    ##Generate the Unobserved process I, and observables

    for (t in 2:n){
        I[t] <- I[t-1] - rec + inf
        Pi <- 1 - exp(-beta*I[t]*dt/N)
        inf <- rbinom(1, prob=Pi, size = N-I[t])
        rec <- rbinom(1, prob=Pr, size = I[t])
        Iobs[i] <- rbinom(1, prob=report, size = I[t])
    }

    cbind(tvec, I, Iobs)
}



    
