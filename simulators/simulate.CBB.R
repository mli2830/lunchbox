##simulate CBB data

system.time(sim <- simm(R0=R0
  , N=N
  , effprop=effprop
  , i0=i0
  , repMean=repprop
  , repSize=repSize
  , numobs=numobs,
  seed=seed
  )
)

print(sim)
# rdsave(sim)
