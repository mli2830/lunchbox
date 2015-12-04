##simulate CB data
source('paramsSpaceCB.R')
source("spaceCBsimulator.R")

sim <- simspaceCB(spacenum = spacenum, numobs=numobs, 
                  betaw=betaw, betab=betab, N=N,seed=seed)
sim
plot(sim$Iobs)

save.image("spaceSimdata.RData")

# sim <- simspaceCB(spacenum = 2, numobs=40, betaw=0.002, betab=0.001, N=4000,seed=4, effinf=1)
# sim
# plot(sim$Iobs)
# 
# sim <- simspaceCB(spacenum = 3, numobs=20, betaw=0.001, betab=0.001, N=2000,seed=4, effinf=1)
# sim
# plot(sim$Iobs)
# 
# sim <- simspaceCB(spacenum = 6, numobs=20, betaw=0.01, betab=0.005, N=1000,seed=4, effinf=1)
# sim
# plot(sim$Iobs)
# 
# 
# sim <- simspaceCB(spacenum = 10, numobs=30, betaw=0.01, betab=0.0005, N=1000,seed=4, effinf=1)
# sim
# plot(sim$Iobs)
# 
# sim <- simspaceCB(spacenum = 15, numobs=30, betaw=0.001, betab=0.0008, N=2000,seed=4, effinf=1)
# sim
# plot(sim$Iobs)
# 
# 
# sim <- simspaceCB(spacenum = 2, numobs=20, betaw=0.01, betab=0.0003, N=1000,seed=4, effinf=1)
# sim
# plot(sim$Iobs)
# 
