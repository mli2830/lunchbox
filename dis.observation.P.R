observation <- c("P","
  for(t in 1:numobs){
    obs[t] ~ dpois(I[t]*repMean)
}
")