simi <- function(beta = 0.5, N=50, i0=1, 
                   t0=1, end=20,seed=NULL){
    if (!is.null(seed)) set.seed(seed)
    tvec <- seq(1,end)
    n <- length(tvec)
    inc <- I <- Pi <- incobs <- numeric(n)

    ##Initial conditions
    I[1] <- i0
    Pi[1] <- 1 - (1-beta)^I[1]
    inc[1] <- rbinom(1,prob=Pi[1],size= N - I[1])

    ##Generate the Unobserved process I, and observables

    for (t in 2:n){
        I[t] <- I[t-1] + inc[t-1]
        Pi[t] <- 1 - (1-beta)^I[t]
        inc[t] <- rbinom(1,prob=Pi[t],size=N-sum(inc))
    }

    cbind(tvec,I, inc)
}



    
