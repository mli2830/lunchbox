##simulate CB data

sim <- simCB(beta=beta,N=N,effprop=effprop,i0=i0,repMean=repMean,
             numobs=numobs,seed=seed)

print(sim)
# rdsave(sim)
