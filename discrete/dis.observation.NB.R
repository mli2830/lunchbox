observation <- c("NB"
                 , "
  obs[1] ~ dnegbin(repMean,I[1])
  "
                 ,
                 #  "for(t in 2:numobs){
                 "obs[t] ~ dnegbin(repMean,I[t]) 
"
                 #}"
)