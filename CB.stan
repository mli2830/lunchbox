data {
int<lower=0> N; // number of data points
int obs[N]; // response
int pop;
int i0;
int s0;
real zerohack;
}
parameters {
// need to put upper/lower bounds on parameters
//  ... otherwise chain wanders off to outer space
real <lower=0.01,upper=0.2> beta;
real <lower=0.1,upper=0.99> reporting;
real <lower=0.1,upper=1> effprop;
real <lower=0> I[N];
}
model {
vector[N] pSI;
vector[N] S;
vector[N] shap;
s0 ~ binomial(pop,effprop);
S[1] <- s0;
pSI[1]<- 1 - (1-beta)^i0;
obs[1] ~ binomial(i0,reporting);
for (t in 2:N) {
I[t] ~ binomial(S[t-1],pSI[t-1]);
S[t] <- S[t-1] - I[t];
pSI[t] <- 1.0 - (1.0-beta)^I[t];
obs[t] ~ binomial(I[t],reporting);
}
}