observation <- c("B","
#  obs[1] ~ dpois(repMean*I[1])
  repGshape[1] <- repMean*I[1]*repGrate
  repGrate <- 1/(1-repMean)
  obs[1] ~ dgamma(repGshape[1],repGrate)

  for(t in 2:numobs){
  repGshape[t] <- repMean*I[t]*repGrate
  repGrate <- 1/(1-repMean)
  obs[t] ~ dgamma(repGshape[t],repGrate)
}
")