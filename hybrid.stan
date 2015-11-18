data {
int<lower=0> numobs; // number of data points
real obs[numobs]; // response
int pop;
real r0;
real s0;
real zerohack;
}
parameters {
// need to put upper/lower bounds on parameters
//  ... otherwise chain wanders off to outer space
real <lower=0.01,upper=0.2> beta;
real <lower=0.1,upper=0.9> reporting;
real <lower=0.1,upper=1> effpropS;
real <lower=0.1,upper=1> effpropI;
real <lower=0.1> I[numobs];
}
model {
vector[numobs] pSI;
vector[numobs] S;
vector[numobs] R;
vector[numobs] shape;
vector[numobs] IOBSshape;
vector[numobs] SIGshape;
vector[numobs] SIGrate;
real IOBSrate;
s0 ~ gamma(effpropS*pop/(1-effpropS),1/(1-effpropS));
S[1] <- s0;
R[1] <- r0;
I[1] ~ gamma(effpropI*(pop-S[1])/(1-effpropI),1/(1-effpropI));
pSI[1]<- 1 - (1-beta)^I[1];
IOBSshape[1] <- reporting*I[1]/(1-reporting) + zerohack;
IOBSrate[1] <- 1/(1-reporting);
obs[1] ~ gamma(IOBSshape[1], IOBSrate[1]);
//print(", S=",S[1],", I=", I[1], ", pSI=", pSI[1], ", sp=",IOBSshape[1], ", rt=",IOBSrate);
for (t in 2:numobs) {
  SIGshape[t] <- pSI[t-1]*S[t-1]/(1-pSI[t-1] + zerohack) + zerohack;
  SIGrate[t] <- 1/(1-pSI[t-1] + zerohack);
  I[t] ~ gamma(SIGshape[t],SIGrate[t]);
  S[t] <- S[t-1] - I[t];
  R[t] <- R[t-1] + I[t-1];
  pSI[t] <- 1 - (1-beta)^I[t];
  IOBSshape[t] <- reporting*I[t]/(1-reporting+zerohack) + zerohack;
  obs[t] ~ gamma(IOBSshape[t],IOBSrate);
  }
}