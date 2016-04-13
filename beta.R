rbbinom <- function(n, mu, k, size){
	mtilde <- rbeta(n, k/(1-mu), k/mu)
	return(rbinom(n, prob=mtilde, size=size))
}

r <- rbbinom(1000, 1/2, 1, 10)
print(c(m=mean(r), s=sd(r)))
