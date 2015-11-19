data {
int<lower=0> numobs; // number of data points
real obs[numobs]; // response
real pop;
real zerohack;
}
parameters {
real <lower=0.01,upper=0.2> beta;
real <lower=0,upper=0.9> reporting;
real <lower=0,upper=1> effpropS;
real <lower=0,upper=1> effpropI;
real <lower=0> I[numobs];
}
transformed parameters{
real <lower=effpropS*pop,upper=pop> s0;
real <lower=0> Sshape;
real <lower=0> Srate;
real <lower=0> IGrate;
real <lower=0> IGshape;
real <lower=0> IOBSrate;

Sshape <- effpropS*pop/(1-effpropS);
Srate <- 1/(1-effpropS);
s0 <- effpropS*pop;
IOBSrate <- 1/(1-reporting);
IGshape <- effpropI*(pop-s0)/(1-effpropI);
IGrate <- 1/(1-effpropI);
}
model {
vector[numobs] S;
vector[numobs] pSI;
vector[numobs] SIGshape;
vector[numobs]SIGrate;
vector[numobs] IOBSshape;
s0 ~ gamma(Sshape,Srate);
S[1] <- s0;
SIGshape[1] <- IGshape;
SIGrate[1] <- IGrate;
I[1] ~ gamma(SIGshape[1],SIGrate[1]);
pSI[1] <- 1 - (1-beta)^I[1];
IOBSshape[1] <- reporting*I[1]/(1-reporting);
obs[1] ~ gamma(IOBSshape[1], IOBSrate);


for (t in 2:numobs) {
  pSI[t] <- 1 - (1-beta)^I[t];
  S[t] <- S[t-1] - I[t] + zerohack; // < 0 will never happen in binomial 
  SIGshape[t] <- pSI[t-1]*S[t-1]/(1-pSI[t-1]);
  SIGrate[t] <- 1/(1-pSI[t-1]);
  I[t] ~ gamma(SIGshape[t],SIGrate[t]);
//  print("SIGshape=",SIGshape[t],", pSI=",pSI[t])
  IOBSshape[t] <- reporting*I[t]/(1-reporting);
  obs[t] ~ gamma(IOBSshape[t],IOBSrate);
  }
}