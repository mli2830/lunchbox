data {
int<lower=0> numobs; // number of data points
real obs[numobs]; // response
real pop;
real r0;
real s0;
real zerohack;
}
parameters {
real <lower=0.01,upper=0.2> beta;
real <lower=0,upper=0.9> reporting;
real <lower=0,upper=1> effpropS;
real <lower=0,upper=1> effpropI;
real <lower=0, upper=pop> I[numobs];
}
transformed parameters{
real <lower=0,upper=1> pSI[numobs];
real <lower=0> SIGrate[numobs];
real <lower=0> SIGshape[numobs];
real <lower=0> IOBSshape[numobs];
real <lower=0> IOBSrate;
real <lower=0,upper=pop> S[numobs];
real <lower=0> Sshape;
real <lower=0> Srate;
real <lower=0> IGrate;
real <lower=0> IGshape;
Sshape <- effpropS*pop/(1-effpropS);
Srate <- 1/(1-effpropS);
S[1] <- s0;
IOBSrate <- 1/(1-reporting);
pSI[1] <- 1-(1-beta)^I[1];
IOBSshape[1] <- reporting*I[1]/(1-reporting);
IGrate <- 1/(1-effpropI);
IGshape <- effpropI*(pop-S[1])/(1-effpropI);
for(i in 2:numobs){
  IOBSshape[i] <- reporting*I[i]/(1-reporting);
  SIGshape[i] <- pSI[i-1]*S[i-1]/(1-pSI[i-1]);
  SIGrate[i] <- 1/(1-pSI[i-1]);
  pSI[i] <- 1 - (1-beta)^I[i];
  print("S=",S[1],", pSI=",pSI[1]);
  S[i] <- S[i-1] - I[i];
}
}
model {
vector[numobs] R;
s0 ~ gamma(Sshape,Srate);
R[1] <- r0;
I[1] ~ gamma(IGshape,IGrate);
obs[1] ~ gamma(IOBSshape[1], IOBSrate);
//print(", S=",S[1],", I=", I[1], ", pSI=", pSI[1], ", sp=",IOBSshape[1], ", rt=",IOBSrate);
for (t in 2:numobs) {
//  print(", shape=",SIGshape[2],", rate=", SIGrate[2]);
  I[t] ~ gamma(SIGshape[t],SIGrate[t]);
  R[t] <- R[t-1] + I[t-1];
  obs[t] ~ gamma(IOBSshape[t],IOBSrate);
  }
}