data {
int<lower=0> numobs; // number of data points
real obs[numobs]; // response
int pop;
int r0;
real zerohack;
}
parameters {
// need to put upper/lower bounds on parameters
//  ... otherwise chain wanders off to outer space
real <lower=0.01,upper=0.2> beta;
real <lower=0.1,upper=0.99> reporting;
real <lower=0.1,upper=1> effpropS;
real <lower=0.1,upper=1> effpropI;
real <lower=0.1> I[numobs];
}
model {
vector[numobs] pSI;
vector[numobs] S;
vector[numobs] shape;
vector[numobs] IOBSshape;
vector[numobs] SIGshape;
vector[numobs] SIGscale;
//real IOBSscale
s0 ~ gamma(effpropS*pop/(1-effpropS),1/(1-effpropS));
S[1] <- s0;
I[1] ~ gamma(effpropI*(pop-S[1])/(1-effpropI),1/(1-effpropI));
pSI[1]<- 1 - (1-beta)^I[1];
IOBSshape[1] <- reporting*I[1]/(1-reporting);
IOBSscale <- 1/(1-reporting+zerohack);
obs[1] ~ gamma(IOBSshape[1], IOBSscale);

for (t in 2:numobs) {
  SIGshape[t] <- pSI[t-1]*S[t-1]/(1-pSI[t-1] + zerohack) + zerohack;
  SIGscale[t] <- 1/(1-pSI[t-1] + zerohack);
  I[t] ~ gamma(SIGshape[t],SIGscale[t]);
  S[t] <- S[t-1] - I[t];
  R[t] <- R[t-1] + I[t-1];
  pSI[t] <- 1 - (1-beta)^I[t];
  IOBSshape[t] <- reporting*I[t]/(1-reporting+zerohack) + zerohack
  obs[t] ~ gamma(IOBSshape[t],IOBSscale)
  }
}