data {
int<lower=0> numobs; // number of data points
int obs[numobs]; // response
real N;
real zerohack;
}
parameters {
real <lower=0.01,upper=0.2> beta;
real <lower=0,upper=0.9> reporting;
real <lower=0,upper=1> effprop;
real <lower=0> I[numobs];
real <lower=0,upper=N> N0;
}
transformed parameters{
real <lower=0> Nshape;
real <lower=0> Nrate;
Nshape <- effprop*N/(1-effprop);
Nrate <- 1/(1-effprop);

}
model {
vector[numobs] S;
vector[numobs] pSI;
vector[numobs] SIGshape;
vector[numobs]SIGrate;
N0 ~ gamma(Nshape,Nrate);

SIGshape[1] <- 1;
SIGrate[1] <- 1;
I[1] ~ uniform(0,3);
S[1] <- N0 - I[1];
pSI[1] <- 1 - (1-beta)^I[1];
obs[1] ~ poisson(reporting*I[1]);


for (t in 2:numobs) {
  pSI[t] <- 1 - (1-beta)^I[t];
  S[t] <- S[t-1] - I[t] + zerohack; // < 0 will never happen in binomial 
  SIGshape[t] <- pSI[t-1]*S[t-1]/(1-pSI[t-1])+ zerohack ;
  SIGrate[t] <- 1/(1-pSI[t-1]);
  I[t] ~ gamma(SIGshape[t],SIGrate[t]);
  obs[t] ~ poisson(reporting*I[t]);
  }
}