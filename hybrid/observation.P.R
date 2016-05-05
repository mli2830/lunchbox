observation <- c("P","
  obs[1] ~ dpois(repMean*I[1])

  for(t in 2:numobs){
  obs[t] ~ dpois(repMean*I[1])
}
")