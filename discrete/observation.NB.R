observation <- c("NB"
  , "
  obsdis ~ dgamma(1,1)
  obs[1] ~ dgamma(obsdis,repMean*
  "
  ,
  #  "for(t in 2:numobs){
  "obs[t] ~ dnegbin(repMean,I[t]) 
"
#}"
)