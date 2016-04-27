##simulate CBB data

system.time(sim <- simm(lambda=lambda
  , N=N
  , effprop=effprop
  , i0=i0
  , repMean=repMean 
  , repSize=repSize
  , numobs=numobs,
  seed=seed
  )
)

print(sim)
# rdsave(sim)
