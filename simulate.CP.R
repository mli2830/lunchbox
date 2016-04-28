##simulate CP data

system.time(sim <- simm(R0=R0
  , N=N
  , effprop=effprop
  , i0=i0
  , repMean=repMean
  , numobs=numobs
  , seed=seed
)
)

print(sim)
# rdsave(sim)
