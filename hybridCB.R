library(R2jags)
library(nimble)

##creating the data ----

source("SIsimulator.R")

sim <- simCB(beta=0.02,pop=100,effprop=0.8,i0=2,seed=3)
sim



data <- list(obs=sim$Iobs,
             pop=100,
             M=length(sim$Iobs),
             i0=2)

##initial values -----

inits <- list(list(I = sim$Iobs+1,
              effprop=0.8,
              beta = 0.01,
              reporting = 0.8))

## fit CB jags ----

params = c('beta',
              'effprop',
              'reporting')

rjags::set.factory("bugs::Conjugate", FALSE, type="sampler")

cbjags <- jags(data=data,
               inits=inits,
               param = params,
               model=function(){
                 ## inits
                 reporting ~ dunif(0,1)
                 effprop ~ dunif(0,1)
                 beta ~ dunif(0,0.2)
                 S[1] ~ dbin(effprop,pop)
                 R[1] <- 0
                 pSI[1] <- 1 - (1-beta)^i0 
                 I[1] ~ dbin(pSI[1],S[1])
                 obs[1] ~ dbin(reporting , I[1])
                 
                 for(t in 2:M){
                   I[t] ~ dbin(pSI[t-1],S[t-1])
                   S[t] <- S[t-1] - I[t]
                   R[t] <- R[t-1] + I[t-1]
                   pSI[t] <- 1 - (1-beta)^I[t]
                   obs[t] ~ dbin(reporting,I[t])
                 }
               },
               n.iter = 8000,
               n.chains = 1)

## fit hybrid jags ----

data$obs <- data$obs + 0.0001

hybridjags <- jags(data=data,
               inits=inits,
               param = params,
               model=function(){
                 ## inits
                 reporting ~ dunif(0,1)
                 effprop ~ dunif(0,1)
                 beta ~ dunif(0,0.2)
#                 S[1] ~ dbin(effprop,pop)
                 S[1] <- effprop*pop
                 R[1] <- 0
                 pSI[1] <- 1 - (1-beta)^i0 
#                 I[1] ~ dbin(pSI[1],S[1])
                 I[1] ~ dgamma(pSI[1]*S[1]/(1-pSI[1]),
                               1/(1-pSI[1]))
#                 obs[1] ~ dbin(reporting , I[1])
                 obs[1] ~ dgamma(reporting*I[1]/(1-reporting),
                                 1/(1-reporting))
                 
                 for(t in 2:M){
#                   I[t] ~ dbin(pSI[t-1],S[t-1])
                   I[t] ~ dgamma(pSI[t-1]*S[t-1]/(1-pSI[t-1]),
                                 1/(1-pSI[t-1]))
                   S[t] <- S[t-1] - I[t]
                   R[t] <- R[t-1] + I[t-1]
                   pSI[t] <- 1 - (1-beta)^I[t]
#                   obs[t] ~ dbin(reporting,I[t])
                   obs[t] ~ dgamma(reporting*I[t]/(1-reporting),
                                   1/(1-reporting))
                 }
               },
               n.iter = 8000,
               n.chains = 1)

## hybrid stan ----

library("rstan")
options(mc.cores = parallel::detectCores())


obs <- sim$Iobs
N = 20
one <- 1

mcode <-
  "data {
int<lower=0> N; // number of data points
real obs[N]; // response
real I[N];
int pop;
int i0;
real epi;
}
parameters {
// need to put upper/lower bounds on parameters
//  ... otherwise chain wanders off to outer space
real <lower=0.01,upper=0.2> beta;
real <lower=0.1,upper=0.9> reporting;
real <lower=0.1,upper=1> effprop;
}
model {
vector[N] pSI;
vector[N] S;
vector[N] shap;
S[1] <- effprop*pop;
pSI[1]<- 1 - (1-beta)^i0;
shap[1] <- pSI[1]*S[1]/(1-pSI[1]+epi);
I[1] ~ gamma(exp(shap[1]),1/(1-pSI[1]+epi));
for (t in 2:N) {
shap[t] <- pSI[t-1]*S[t-1]/(1-pSI[t-1]+epi);
I[t] ~ gamma(exp(shap[t]),1/(1-pSI[t-1]+epi));
S[t] <- S[t-1] - I[t];
pSI[t] <- 1.0 - (1.0-beta)^I[t];
obs[t] ~ gamma(reporting*I[t]/(1.0-reporting+epi),1.0/(1.0-reporting+epi));
}
}
"
## all default options: runs
s1 <- stan(model_code=mcode,data=list(obs=sim$Iobs,N=N,pop=pop,i0=i0,
                                      I=sim$I,S=sim$S,R=sim$R,epi=epi),
           pars=c("beta","reporting","effprop"),iter=2000,
           seed=1001,
           chains = 1)
